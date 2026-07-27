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
		s_load_dword s20, s[0:1], 0x58
		s_load_dword s21, s[0:1], 0x5c
		s_load_dword s22, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s22
		v_accvgpr_write_b32 a4, 0
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v3, s0
		v_accvgpr_write_b32 a5, v3
		s_lshr_b32 s0, s16, 3
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s19, s1
		s_nop 0
		v_mov_b32_e32 v3, s1
		v_accvgpr_write_b32 a6, v3
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s1, v3
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s19, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s19, s19, 0
		s_add_i32 s1, s1, s19
		s_ashr_i32 s1, s1, 3
		s_mul_i32 s1, s1, 16
		v_mov_b32_e32 v3, s1
		v_accvgpr_write_b32 a7, v3
		v_accvgpr_read_b32 v3, a7
		s_nop 0
		v_readfirstlane_b32 s1, v3
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s19, s0, 15
		s_mul_i32 s1, s1, 8
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s22, v3
		s_add_i32 s1, s22, s1
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s22, v3
		s_cmp_lt_i32 s1, s22
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s1, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s23, s1
		s_cselect_b32 s23, 1, 0
		v_readfirstlane_b32 s24, v1
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		v_readfirstlane_b32 s25, v1
		s_cmp_lt_i32 s25, 0
		v_readfirstlane_b32 s25, v1
		s_cselect_b32 s24, s24, s25
		v_mov_b32_e32 v3, s24
		v_cvt_f32_u32_e32 v3, v3
		v_rcp_iflag_f32_e32 v3, v3
		v_mov_b32_e32 v4, 0x4f7ffffe
		v_mul_f32_e32 v3, v4, v3
		v_cvt_u32_f32_e32 v3, v3
		s_xor_b32 s25, s24, -1
		v_readfirstlane_b32 s26, v3
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
		v_readfirstlane_b32 s27, v1
		s_xor_b32 s1, s1, s27
		s_xor_b32 s27, s24, -1
		s_add_i32 s27, s27, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s27, s24
		v_mov_b32_e32 v3, s1
		s_add_i32 s24, s22, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s22, s24, s22
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		v_mov_b32_e32 v4, s22
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
		v_mov_b32_e32 v5, s19
		v_accvgpr_write_b32 a8, v5
		v_accvgpr_read_b32 v5, a8
		s_nop 0
		v_readfirstlane_b32 s19, v5
		s_mul_i32 s19, s19, 0x100
		v_and_b32_e32 v5, 1, v0
		v_lshrrev_b32_e32 v6, 1, v0
		v_and_b32_e32 v7, 1, v6
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v7
		v_lshrrev_b32_e32 v7, 2, v0
		v_and_b32_e32 v9, 1, v7
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v9
		v_bitop3_b32 v9, v5, v8, v10 bitop3:0x96
		v_lshrrev_b32_e32 v11, 3, v0
		v_and_b32_e32 v12, 1, v11
		v_mov_b32_e32 v13, 8
		v_mul_lo_u32 v13, v13, v12
		v_xor_b32_e32 v9, v9, v13
		v_lshrrev_b32_e32 v14, 4, v0
		v_and_b32_e32 v15, 1, v14
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v15
		v_lshrrev_b32_e32 v17, 6, v0
		v_accvgpr_write_b32 a9, v17
		v_accvgpr_read_b32 v17, a9
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 32
		v_mul_lo_u32 v18, v18, v17
		v_bitop3_b32 v9, v9, v16, v18 bitop3:0x96
		v_lshrrev_b32_e32 v19, 7, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v9, v9, v20
		v_accvgpr_write_b32 a10, v9
		v_xor_b32_e32 v5, 0x80, v5
		v_xor_b32_e32 v5, v5, v8
		v_xor_b32_e32 v5, v5, v10
		v_bitop3_b32 v5, v5, v13, v16 bitop3:0x96
		v_bitop3_b32 v5, v5, v18, v20 bitop3:0x96
		v_accvgpr_write_b32 a11, v5
		v_mov_b32_e32 v5, 2
		v_mul_lo_u32 v5, v5, v15
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v9, 1, v8
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v9
		v_bitop3_b32 v13, v12, v5, v10 bitop3:0x96
		v_mov_b32_e32 v16, 8
		v_mul_lo_u32 v16, v16, v17
		v_xor_b32_e32 v13, v13, v16
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v19
		v_xad_u32 v13, v13, v18, s19
		v_bitop3_b32 v20, 32, v12, v5 bitop3:0x96
		v_bitop3_b32 v20, v20, v10, v16 bitop3:0x96
		v_xad_u32 v20, v20, v18, s19
		v_bitop3_b32 v21, 64, v12, v5 bitop3:0x96
		v_bitop3_b32 v21, v21, v10, v16 bitop3:0x96
		v_xad_u32 v21, v21, v18, s19
		v_xor_b32_e32 v22, 0x60, v12
		v_xor_b32_e32 v22, v22, v5
		v_xor_b32_e32 v22, v22, v10
		v_xor_b32_e32 v22, v22, v16
		v_xad_u32 v22, v22, v18, s19
		v_xor_b32_e32 v23, 0x80, v12
		v_xor_b32_e32 v23, v23, v5
		v_xor_b32_e32 v23, v23, v10
		v_xor_b32_e32 v23, v23, v16
		v_xad_u32 v23, v23, v18, s19
		v_xor_b32_e32 v24, 0xa0, v12
		v_xor_b32_e32 v24, v24, v5
		v_xor_b32_e32 v24, v24, v10
		v_xor_b32_e32 v24, v24, v16
		v_xad_u32 v24, v24, v18, s19
		v_xor_b32_e32 v25, 0xc0, v12
		v_xor_b32_e32 v25, v25, v5
		v_xor_b32_e32 v25, v25, v10
		v_xor_b32_e32 v25, v25, v16
		v_xad_u32 v25, v25, v18, s19
		v_xor_b32_e32 v26, 0xe0, v12
		v_xor_b32_e32 v5, v26, v5
		v_xor_b32_e32 v5, v5, v10
		v_xor_b32_e32 v5, v5, v16
		v_xad_u32 v5, v5, v18, s19
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v16, a4
		v_and_b32_e32 v16, 0xffff, v16
		v_lshlrev_b32_e32 v18, 16, v16
		v_or_b32_e32 v28, v16, v18
		v_mov_b32_e32 v29, v28
		v_mov_b32_e32 v30, v28
		v_mov_b32_e32 v31, v28
		v_accvgpr_read_b32 v16, a8
		s_nop 0
		v_readfirstlane_b32 s23, v16
		s_mul_i32 s23, s23, s12
		s_lshl_b32 s23, s23, 9
		v_readfirstlane_b32 s28, v3
		s_mul_i32 s28, s28, s10
		s_lshl_b32 s28, s28, 1
		s_add_i32 s29, s23, s28
		v_readfirstlane_b32 s30, v4
		s_mul_i32 s30, s30, s11
		s_lshl_b32 s30, s30, 1
		s_add_i32 s29, s29, s30
		v_mul_lo_u32 v16, s12, v11
		v_lshl_add_u32 v18, v16, 1, s29
		v_and_b32_e32 v26, 1, v0
		v_accvgpr_write_b32 a12, v26
		v_accvgpr_read_b32 v26, a12
		v_lshl_add_u32 v18, v26, 4, v18
		v_and_b32_e32 v26, 1, v7
		v_accvgpr_write_b32 a13, v26
		v_accvgpr_read_b32 v26, a13
		v_lshl_add_u32 v18, v26, 6, v18
		v_and_b32_e32 v6, 1, v6
		v_accvgpr_write_b32 a14, v6
		v_accvgpr_read_b32 v6, a14
		v_lshl_add_u32 v6, v6, 5, v18
		v_cmp_lt_i32_e64 vcc, v13, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[32:35], v6, s[24:27], 0 offen
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
		v_lshl_add_u32 v6, v16, 1, s29
		v_accvgpr_read_b32 v13, a12
		v_lshl_add_u32 v6, v13, 4, v6
		v_accvgpr_read_b32 v13, a13
		v_lshl_add_u32 v6, v13, 6, v6
		v_accvgpr_read_b32 v13, a14
		v_lshl_add_u32 v6, v13, 5, v6
		v_cmp_lt_i32_e64 vcc, v20, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[36:39], v6, s[24:27], 0 offen
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
		v_lshl_add_u32 v6, v16, 1, s29
		v_accvgpr_read_b32 v13, a12
		v_lshl_add_u32 v6, v13, 4, v6
		v_accvgpr_read_b32 v13, a13
		v_lshl_add_u32 v6, v13, 6, v6
		v_accvgpr_read_b32 v13, a14
		v_lshl_add_u32 v6, v13, 5, v6
		v_cmp_lt_i32_e64 vcc, v21, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[40:43], v6, s[24:27], 0 offen
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
		v_lshl_add_u32 v6, v16, 1, s29
		v_accvgpr_read_b32 v13, a12
		v_lshl_add_u32 v6, v13, 4, v6
		v_accvgpr_read_b32 v13, a13
		v_lshl_add_u32 v6, v13, 6, v6
		v_accvgpr_read_b32 v13, a14
		v_lshl_add_u32 v6, v13, 5, v6
		v_cmp_lt_i32_e64 vcc, v22, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[44:47], v6, s[24:27], 0 offen
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
		v_lshl_add_u32 v6, v16, 1, s29
		v_accvgpr_read_b32 v13, a12
		v_lshl_add_u32 v6, v13, 4, v6
		v_accvgpr_read_b32 v13, a13
		v_lshl_add_u32 v6, v13, 6, v6
		v_accvgpr_read_b32 v13, a14
		v_lshl_add_u32 v6, v13, 5, v6
		v_cmp_lt_i32_e64 vcc, v23, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[20:23], v6, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v20, v28
		v_mov_b32_e32 v21, v29
		v_mov_b32_e32 v22, v30
		v_mov_b32_e32 v23, v31
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s29, 0x140, s12
		s_add_i32 s29, s29, s23
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v6, v16, 1, s29
		v_accvgpr_read_b32 v13, a12
		v_lshl_add_u32 v6, v13, 4, v6
		v_accvgpr_read_b32 v13, a13
		v_lshl_add_u32 v6, v13, 6, v6
		v_accvgpr_read_b32 v13, a14
		v_lshl_add_u32 v6, v13, 5, v6
		v_cmp_lt_i32_e64 vcc, v24, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[48:51], v6, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v48, v28
		v_mov_b32_e32 v49, v29
		v_mov_b32_e32 v50, v30
		v_mov_b32_e32 v51, v31
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s29, 0x180, s12
		s_add_i32 s29, s29, s23
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v6, v16, 1, s29
		v_accvgpr_read_b32 v13, a12
		v_lshl_add_u32 v6, v13, 4, v6
		v_accvgpr_read_b32 v13, a13
		v_lshl_add_u32 v6, v13, 6, v6
		v_accvgpr_read_b32 v13, a14
		v_lshl_add_u32 v6, v13, 5, v6
		v_cmp_lt_i32_e64 vcc, v25, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[24:27], v6, s[24:27], 0 offen
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
		v_lshl_add_u32 v6, v16, 1, s23
		v_accvgpr_read_b32 v13, a12
		v_lshl_add_u32 v6, v13, 4, v6
		v_accvgpr_read_b32 v13, a13
		v_lshl_add_u32 v6, v13, 6, v6
		v_accvgpr_read_b32 v13, a14
		v_lshl_add_u32 v6, v13, 5, v6
		v_cmp_lt_i32_e64 vcc, v5, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[52:55], v6, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v5, a9
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 2, v5
		v_and_b32_e32 v6, 1, v8
		v_accvgpr_write_b32 a15, v6
		v_accvgpr_read_b32 v6, a15
		v_lshlrev_b32_e32 v6, 1, v6
		v_and_b32_e32 v8, 1, v14
		v_accvgpr_write_b32 a16, v8
		v_accvgpr_read_b32 v8, a16
		v_xor_b32_e32 v8, v0, v8
		v_bitop3_b32 v5, v5, v6, v8 bitop3:0x96
		v_lshlrev_b32_e32 v5, 4, v5
		v_add_u32_e32 v5, 0x10000, v5
		ds_write_b128 v5, v[32:35] offset:2480
		ds_write_b128 v5, v[36:39] offset:6576
		ds_write_b128 v5, v[40:43] offset:10672
		ds_write_b128 v5, v[44:47] offset:14768
		v_accvgpr_read_b32 v6, a9
		v_lshlrev_b32_e32 v6, 12, v6
		v_add_u32_e32 v6, 0x10000, v6
		v_and_b32_e32 v8, 63, v0
		v_lshrrev_b32_e32 v13, 3, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v14, 6, v13
		v_add_u32_e32 v16, v6, v14
		v_lshrrev_b32_e32 v18, 2, v8
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v28, 5, v18
		v_add_u32_e32 v29, v16, v28
		v_lshrrev_b32_e32 v30, 5, v8
		v_accvgpr_write_b32 a17, v30
		v_lshrrev_b32_e32 v30, 4, v8
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v30, 7, v30
		v_lshrrev_b32_e32 v31, 1, v8
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v32, 4, v31
		v_and_b32_e32 v33, 1, v8
		v_lshlrev_b32_e32 v33, 3, v33
		v_accvgpr_read_b32 v34, a17
		v_add3_u32 v34, v34, v30, v14
		v_add3_u32 v34, v34, v28, v32
		v_add_u32_e32 v35, v33, v34
		v_xor_b32_e32 v35, v35, v31
		v_lshl_add_u32 v29, v35, 4, v29
		ds_read_b128 a[20:23], v29 offset:2480
		v_lshlrev_b32_e32 v18, 1, v18
		v_add3_u32 v35, v33, v34, 2
		v_bitop3_b32 v35, v18, v35, v31 bitop3:0x96
		v_lshl_add_u32 v16, v35, 4, v16
		ds_read_b128 a[24:27], v16 offset:2480
		v_add3_u32 v34, v33, v34, 4
		v_xad_u32 v34, v34, v31, v18
		v_lshlrev_b32_e32 v13, 2, v13
		v_xor_b32_e32 v34, v34, v13
		v_lshl_add_u32 v34, v34, 4, v6
		ds_read_b128 a[28:31], v34 offset:2480
		v_accvgpr_read_b32 v35, a17
		v_add3_u32 v30, 6, v35, v30
		v_add3_u32 v14, v30, v14, v28
		v_add3_u32 v14, v14, v32, v33
		v_xor_b32_e32 v14, v14, v31
		v_bitop3_b32 v13, v13, v18, v14 bitop3:0x96
		v_lshl_add_u32 v6, v13, 4, v6
		ds_read_b128 a[32:35], v6 offset:2480
		v_accvgpr_read_b32 v13, a8
		s_nop 0
		v_readfirstlane_b32 s23, v13
		s_add_i32 s23, s23, 1
		s_mul_i32 s23, s23, 0x100
		s_mov_b32 s24, 0x7f
		v_mov_b32_e32 v13, 64
		v_mul_lo_u32 v13, v13, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v5, v[20:23] offset:2480
		ds_write_b128 v5, v[48:51] offset:6576
		ds_write_b128 v5, v[24:27] offset:10672
		ds_write_b128 v5, v[52:55] offset:14768
		v_mov_b32_e32 v5, 32
		v_mul_lo_u32 v5, v5, v15
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v29 offset:2480
		ds_read_b128 a[40:43], v16 offset:2480
		ds_read_b128 a[44:47], v34 offset:2480
		ds_read_b128 a[48:51], v6 offset:2480
		v_readfirstlane_b32 s25, v2
		s_add_i32 s23, s23, s25
		s_cmp_lt_i32 s21, s23
		s_cselect_b32 s23, s21, s23
		s_add_i32 s25, s23, 0x7f
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s36, s24, 0
		s_add_i32 s25, s25, s36
		s_ashr_i32 s25, s25, 7
		v_readfirstlane_b32 s36, v2
		s_add_i32 s36, s19, s36
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s37, s24, 0
		s_add_i32 s36, s36, s37
		s_ashr_i32 s36, s36, 7
		s_cmp_lt_i32 s36, s25
		s_cselect_b32 s36, s36, s25
		s_cmp_gt_i32 s36, 0
		s_cselect_b32 s36, s36, 0
		v_bitop3_b32 v6, v13, v5, v14 bitop3:0x96
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v19
		v_bitop3_b32 v6, v6, v17, v15 bitop3:0x96
		v_accvgpr_write_b32 a18, v6
		v_bitop3_b32 v6, 4, v13, v5 bitop3:0x96
		v_bitop3_b32 v16, 8, v13, v5 bitop3:0x96
		v_bitop3_b32 v13, 12, v13, v5 bitop3:0x96
		v_accvgpr_read_b32 v18, a18
		v_cmp_lt_i32_e64 s[38:39], v18, s21
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v12
		v_mov_b32_e32 v12, 64
		v_mul_lo_u32 v12, v12, v9
		v_bitop3_b32 v9, v18, v5, v12 bitop3:0x96
		v_bitop3_b32 v9, v9, v17, v15 bitop3:0x96
		v_accvgpr_write_b32 a19, v9
		v_bitop3_b32 v9, 4, v18, v5 bitop3:0x96
		v_bitop3_b32 v19, 8, v18, v5 bitop3:0x96
		v_bitop3_b32 v5, 12, v18, v5 bitop3:0x96
		v_accvgpr_read_b32 v18, a19
		v_cmp_lt_i32_e64 vcc, v18, s21
		v_readfirstlane_b32 s40, v0
		v_accvgpr_read_b32 v18, a9
		v_mul_lo_u32 v18, s15, v18
		v_accvgpr_read_b32 v20, a15
		v_mul_lo_u32 v20, s15, v20
		v_lshlrev_b32_e32 v20, 5, v20
		v_lshl_add_u32 v18, v18, 1, v20
		v_accvgpr_read_b32 v20, a16
		v_mul_lo_u32 v20, s15, v20
		v_lshl_add_u32 v18, v20, 6, v18
		v_and_b32_e32 v11, 1, v11
		v_accvgpr_write_b32 a52, v11
		v_accvgpr_read_b32 v11, a52
		v_mul_lo_u32 v11, s15, v11
		v_lshlrev_b32_e32 v11, 7, v11
		v_accvgpr_read_b32 v20, a12
		v_lshlrev_b32_e32 v20, 4, v20
		v_add3_u32 v11, v18, v11, v20
		v_accvgpr_read_b32 v18, a13
		v_lshlrev_b32_e32 v18, 6, v18
		v_accvgpr_read_b32 v21, a14
		v_lshlrev_b32_e32 v21, 5, v21
		v_add3_u32 v11, v11, v18, v21
		v_readfirstlane_b32 s37, v3
		s_mul_i32 s37, s37, s13
		s_lshl_b32 s37, s37, 1
		v_readfirstlane_b32 s41, v4
		s_mul_i32 s41, s41, s14
		s_lshl_b32 s41, s41, 1
		s_add_i32 s42, s37, s41
		v_add_u32_e32 v22, s42, v11
		v_mov_b32_e32 v23, 0x80000000
		v_cndmask_b32_e64 v22, v23, v22, s[38:39]
		s_lshr_b32 s42, s40, 6
		s_mul_i32 s43, 0x410, s42
		s_mov_b32 m0, s43
		v_accvgpr_read_b32 v24, a10
		v_add_u32_e32 v24, s19, v24
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v24, s20
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a54, v24
		v_accvgpr_write_b32 a55, v25
		s_lshl_b32 s44, s15, 3
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s41
		v_add_u32_e32 v22, s44, v11
		v_cndmask_b32_e64 v22, v23, v22, s[38:39]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v24, a11
		v_add_u32_e32 v24, s19, v24
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v24, s20
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a56, v24
		v_accvgpr_write_b32 a57, v25
		s_lshl_b32 s44, s15, 4
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s41
		v_add_u32_e32 v22, s44, v11
		v_cndmask_b32_e64 v22, v23, v22, s[38:39]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v6, v6, v14
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v6, v17, v15 bitop3:0x96
		v_accvgpr_write_b32 a53, v6
		s_mul_i32 s44, 24, s15
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s41
		v_add_u32_e32 v6, s44, v11
		v_cndmask_b32_e64 v6, v23, v6, s[38:39]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v16, v16, v14
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v16, v17, v15 bitop3:0x96
		v_accvgpr_write_b32 a58, v6
		v_accvgpr_read_b32 v6, a9
		v_mul_lo_u32 v6, s17, v6
		v_accvgpr_read_b32 v16, a15
		v_mul_lo_u32 v16, s17, v16
		v_lshlrev_b32_e32 v16, 7, v16
		v_lshl_add_u32 v6, v6, 1, v16
		v_accvgpr_read_b32 v16, a16
		v_mul_lo_u32 v16, s17, v16
		v_lshl_add_u32 v6, v16, 6, v6
		v_accvgpr_read_b32 v16, a52
		v_mul_lo_u32 v16, s17, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_add3_u32 v6, v6, v16, v20
		v_add3_u32 v6, v6, v18, v21
		v_accvgpr_read_b32 v16, a0
		s_nop 0
		v_readfirstlane_b32 s38, v16
		v_readfirstlane_b32 s39, v3
		s_mul_i32 s38, s39, s38
		s_lshl_b32 s38, s38, 1
		v_accvgpr_read_b32 v3, a1
		s_nop 0
		v_readfirstlane_b32 s39, v3
		v_readfirstlane_b32 s44, v4
		s_mul_i32 s39, s44, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s44, s38, s39
		v_add_u32_e32 v3, s44, v6
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_mul_i32 s42, 0x440, s42
		s_add_i32 m0, s42, 0x81f0
		v_xor_b32_e32 v4, v13, v14
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v4, v17, v15 bitop3:0x96
		v_accvgpr_write_b32 a59, v3
		s_lshl_b32 s44, s17, 3
		s_add_i32 s44, s44, s38
		s_add_i32 s44, s44, s39
		v_add_u32_e32 v3, s44, v6
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v9, v12
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v4, v17, v15 bitop3:0x96
		v_accvgpr_write_b32 a60, v3
		s_lshl_b32 s44, s17, 4
		s_add_i32 s44, s44, s38
		s_add_i32 s44, s44, s39
		v_add_u32_e32 v3, s44, v6
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v19, v12
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v4, v17, v15 bitop3:0x96
		v_accvgpr_write_b32 a61, v3
		s_mul_i32 s44, 24, s17
		s_add_i32 s44, s44, s38
		s_add_i32 s44, s44, s39
		v_add_u32_e32 v3, s44, v6
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v5, v12
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v4, v17, v15 bitop3:0x96
		v_accvgpr_write_b32 a62, v3
		s_mul_i32 s44, s36, 0x80
		v_mbcnt_lo_u32_b32 v3, -1, 0
		v_mbcnt_hi_u32_b32 v3, -1, v3
		v_and_b32_e32 v4, 1, v3
		v_lshrrev_b32_e32 v5, 4, v3
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 4, v5
		v_lshrrev_b32_e32 v9, 3, v3
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_add3_u32 v12, v4, v5, v9
		v_lshrrev_b32_e32 v13, 2, v3
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshrrev_b32_e32 v3, 1, v3
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add3_u32 v12, v12, v13, v3
		v_add_u32_e32 v4, 32, v4
		v_bitop3_b32 v3, v13, v4, v3 bitop3:0x96
		v_bitop3_b32 v3, v5, v9, v3 bitop3:0x96
		v_mov_b32_e32 v4, 0x3e38aa3b
		v_mov_b32_e32 v5, 0x3e38aa3b
		s_mov_b32 s36, 0xff800000
		v_mov_b32_e32 v9, s36
		v_mov_b32_e32 v13, s36
		s_mov_b32 s36, 1.0
		v_mov_b32_e32 v14, s36
		v_mov_b32_e32 v15, s36
		s_mov_b32 s36, 0
		v_accvgpr_read_b32 v16, a17
		v_lshlrev_b32_e32 v16, 4, v16
		v_accvgpr_write_b32 a63, v16
		v_and_b32_e32 v8, 31, v8
		v_lshrrev_b32_e32 v16, 4, v8
		v_lshlrev_b32_e32 v16, 9, v16
		v_lshrrev_b32_e32 v17, 3, v8
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 0x2080
		v_mul_lo_u32 v18, v18, v17
		v_lshrrev_b32_e32 v17, 2, v8
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v19, 0x1040
		v_mul_lo_u32 v19, v19, v17
		v_lshrrev_b32_e32 v17, 1, v8
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v20, 0x820
		v_mul_lo_u32 v20, v20, v17
		v_accvgpr_write_b32 a64, v20
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v17, 0x410
		v_mul_lo_u32 v17, v17, v8
		v_accvgpr_write_b32 a65, v17
		v_and_b32_e32 v8, 3, v0
		v_accvgpr_write_b32 a66, v8
		v_accvgpr_read_b32 v8, a66
		v_lshlrev_b32_e32 v8, 3, v8
		v_accvgpr_write_b32 a67, v8
		v_accvgpr_read_b32 v8, a15
		v_mov_b32_e32 v17, 0x2200
		v_mul_lo_u32 v17, v17, v8
		v_accvgpr_write_b32 a68, v17
		v_accvgpr_read_b32 v8, a16
		v_lshlrev_b32_e32 v8, 5, v8
		v_accvgpr_write_b32 a69, v8
		v_and_b32_e32 v7, 3, v7
		v_mov_b32_e32 v8, 0x440
		v_mul_lo_u32 v8, v8, v7
		v_accvgpr_write_b32 a70, v8
		s_lshl_b32 s45, s15, 8
		s_add_i32 s45, s45, s37
		s_add_i32 s45, s45, s41
		s_mul_i32 s46, 0x108, s15
		s_add_i32 s46, s46, s37
		s_add_i32 s46, s46, s41
		s_mul_i32 s47, 0x110, s15
		s_add_i32 s47, s47, s37
		s_add_i32 s47, s47, s41
		s_mul_i32 s48, 0x118, s15
		s_add_i32 s37, s48, s37
		s_add_i32 s37, s37, s41
		s_lshl_b32 s41, s17, 8
		s_add_i32 s41, s41, s38
		s_add_i32 s48, s41, s39
		s_mul_i32 s41, 0x108, s17
		s_add_i32 s41, s41, s38
		s_add_i32 s49, s41, s39
		s_mul_i32 s41, 0x110, s17
		s_add_i32 s41, s41, s38
		s_add_i32 s50, s41, s39
		s_mul_i32 s41, 0x118, s17
		s_add_i32 s38, s41, s38
		s_add_i32 s38, s38, s39
		v_lshlrev_b32_e32 v7, 2, v12
		v_accvgpr_write_b32 a71, v7
		v_lshlrev_b32_e32 v3, 2, v3
		v_accvgpr_write_b32 a72, v3
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
		s_lshr_b32 s39, s36, 7
		s_and_b32 s41, s39, 1
		s_mul_i32 s51, 0x4100, s41
		v_accvgpr_read_b32 v3, a63
		v_add3_u32 v3, s51, v3, v16
		v_add3_u32 v3, v3, v18, v19
		v_accvgpr_read_b32 v7, a64
		v_accvgpr_read_b32 v8, a65
		v_add3_u32 v3, v3, v7, v8
		ds_read_b128 v[24:27], v3
		ds_read_b128 a[76:79], v3 offset:32
		ds_read_b128 a[80:83], v3 offset:64
		ds_read_b128 a[84:87], v3 offset:96
		ds_read_b128 v[28:31], v3 offset:256
		ds_read_b128 a[88:91], v3 offset:288
		ds_read_b128 a[92:95], v3 offset:320
		ds_read_b128 a[96:99], v3 offset:352
		ds_read_b128 v[96:99], v3 offset:128
		ds_read_b128 a[100:103], v3 offset:160
		ds_read_b128 a[104:107], v3 offset:192
		ds_read_b128 a[108:111], v3 offset:224
		ds_read_b128 v[100:103], v3 offset:384
		ds_read_b128 a[112:115], v3 offset:416
		ds_read_b128 a[116:119], v3 offset:448
		ds_read_b128 a[120:123], v3 offset:480
		s_mul_i32 s41, 0x4400, s41
		v_accvgpr_read_b32 v3, a67
		v_accvgpr_read_b32 v7, a68
		v_add3_u32 v3, s41, v3, v7
		v_accvgpr_read_b32 v7, a69
		v_accvgpr_read_b32 v8, a70
		v_add3_u32 v3, v3, v7, v8
		ds_read_b64_tr_b16 a[124:125], v3 offset:33264
		ds_read_b64_tr_b16 a[126:127], v3 offset:37616
		ds_read_b64_tr_b16 a[128:129], v3 offset:33392
		ds_read_b64_tr_b16 a[130:131], v3 offset:37744
		ds_read_b64_tr_b16 a[132:133], v3 offset:33520
		ds_read_b64_tr_b16 a[134:135], v3 offset:37872
		ds_read_b64_tr_b16 a[136:137], v3 offset:33648
		ds_read_b64_tr_b16 a[138:139], v3 offset:38000
		ds_read_b64_tr_b16 a[140:141], v3 offset:33776
		ds_read_b64_tr_b16 a[142:143], v3 offset:38128
		ds_read_b64_tr_b16 a[144:145], v3 offset:33904
		ds_read_b64_tr_b16 a[146:147], v3 offset:38256
		ds_read_b64_tr_b16 a[148:149], v3 offset:34032
		ds_read_b64_tr_b16 a[150:151], v3 offset:38384
		ds_read_b64_tr_b16 a[152:153], v3 offset:34160
		ds_read_b64_tr_b16 a[154:155], v3 offset:38512
		ds_read_b64_tr_b16 a[156:157], v3 offset:33328
		ds_read_b64_tr_b16 a[158:159], v3 offset:37680
		ds_read_b64_tr_b16 a[160:161], v3 offset:33456
		ds_read_b64_tr_b16 a[162:163], v3 offset:37808
		ds_read_b64_tr_b16 a[164:165], v3 offset:33584
		ds_read_b64_tr_b16 a[166:167], v3 offset:37936
		ds_read_b64_tr_b16 a[168:169], v3 offset:33712
		ds_read_b64_tr_b16 a[170:171], v3 offset:38064
		ds_read_b64_tr_b16 a[172:173], v3 offset:33840
		ds_read_b64_tr_b16 a[174:175], v3 offset:38192
		ds_read_b64_tr_b16 a[176:177], v3 offset:33968
		ds_read_b64_tr_b16 a[178:179], v3 offset:38320
		ds_read_b64_tr_b16 a[180:181], v3 offset:34096
		ds_read_b64_tr_b16 a[182:183], v3 offset:38448
		ds_read_b64_tr_b16 a[184:185], v3 offset:34224
		ds_read_b64_tr_b16 a[186:187], v3 offset:38576
		s_mul_i32 s41, s15, s36
		s_lshl_b32 s41, s41, 1
		s_add_i32 s51, s45, s41
		v_add_u32_e32 v3, s51, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v7, s41, v11
		s_add_i32 s39, s39, 1
		v_add_u32_e32 v8, s46, v7
		s_and_b32 s39, s39, 1
		v_add_u32_e32 v12, s47, v7
		s_mul_i32 s41, 0x4100, s39
		v_add_u32_e32 v7, s37, v7
		s_add_i32 s41, s43, s41
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[20:23], 0
		s_mov_b32 m0, s41
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[20:23], 0
		s_mul_i32 s41, s17, s36
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[20:23], 0
		s_add_i32 s36, s36, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[20:23], 0
		v_accvgpr_read_b32 v17, a18
		v_add_u32_e32 v17, s36, v17
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[36:39], 0
		v_accvgpr_read_b32 v20, a53
		v_add_u32_e32 v20, s36, v20
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[36:39], 0
		v_accvgpr_read_b32 v21, a58
		v_add_u32_e32 v21, s36, v21
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[36:39], 0
		v_accvgpr_read_b32 v22, a59
		v_add_u32_e32 v22, s36, v22
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], a[36:39], 0
		v_cmp_lt_i32_e64 s[52:53], v17, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[24:27], v[112:127]
		v_accvgpr_read_b32 v17, a19
		v_add_u32_e32 v17, s36, v17
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[24:27], v[128:143]
		v_accvgpr_read_b32 v24, a60
		v_add_u32_e32 v24, s36, v24
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[24:27], v[144:159]
		v_accvgpr_read_b32 v25, a61
		v_add_u32_e32 v25, s36, v25
		v_mfma_f32_32x32x16_bf16 v[160:175], a[112:115], a[24:27], v[160:175]
		v_cmp_lt_i32_e64 s[54:55], v17, s21
		v_mfma_f32_32x32x16_bf16 v[176:191], a[112:115], a[40:43], v[176:191]
		v_cndmask_b32_e64 v3, v23, v3, s[52:53]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[40:43], v[192:207]
		v_cmp_lt_i32_e64 s[52:53], v20, s21
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[40:43], v[208:223]
		s_nop 0
		v_cndmask_b32_e64 v3, v23, v8, s[52:53]
		v_cmp_lt_i32_e64 s[52:53], v21, s21
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		v_cndmask_b32_e64 v8, v23, v12, s[52:53]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v22, s21
		s_nop 1
		v_cndmask_b32_e64 v3, v23, v7, s[52:53]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v7, a62
		v_add_u32_e32 v7, s36, v7
		s_lshl_b32 s41, s41, 1
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_add_i32 s51, s48, s41
		v_add_u32_e32 v8, s51, v6
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v8, v23, v8, s[54:55]
		s_mul_i32 s39, 0x4400, s39
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v24, s21
		s_add_i32 s39, s42, s39
		v_add_u32_e32 v3, s41, v6
		s_add_i32 m0, s39, 0x81f0
		v_add_u32_e32 v12, s49, v3
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[40:43], v[224:239]
		v_cndmask_b32_e64 v8, v23, v12, s[52:53]
		v_cmp_lt_i32_e64 s[52:53], v25, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v12, s50, v3
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v8, v23, v12, s[52:53]
		v_cmp_lt_i32_e64 vcc, v7, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v3, s38, v3
		v_cndmask_b32_e32 v3, v23, v3, vcc
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[28:31], v[112:127]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s36, s44
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[28:31], v[128:143]
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
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
		v_max3_f32 v3, v112, v113, v114
		v_max3_f32 v7, v116, v117, v118
		v_max3_f32 v8, v120, v121, v122
		v_max3_f32 v12, v124, v125, v126
		v_max3_f32 v17, v128, v129, v130
		v_max3_f32 v20, v132, v133, v134
		v_max3_f32 v21, v136, v137, v138
		v_max3_f32 v22, v140, v141, v142
		v_max3_f32 v24, v144, v145, v146
		v_max3_f32 v25, v148, v149, v150
		v_max3_f32 v26, v152, v153, v154
		v_max3_f32 v27, v156, v157, v158
		v_max3_f32 v28, v160, v161, v162
		v_max3_f32 v29, v164, v165, v166
		v_max3_f32 v30, v168, v169, v170
		v_max3_f32 v31, v172, v173, v174
		v_max3_f32 v3, v3, v115, v7
		v_max3_f32 v7, v8, v123, v12
		v_max3_f32 v8, v17, v131, v20
		v_max3_f32 v12, v21, v139, v22
		v_max3_f32 v17, v24, v147, v25
		v_max3_f32 v20, v26, v155, v27
		v_max3_f32 v21, v28, v163, v29
		v_max3_f32 v22, v30, v171, v31
		v_max3_f32 v3, v3, v119, v7
		v_max3_f32 v7, v8, v135, v12
		v_max3_f32 v8, v17, v151, v20
		v_max3_f32 v12, v21, v167, v22
		v_max3_f32 v3, v3, v127, v7
		v_max3_f32 v7, v8, v159, v12
		v_max3_f32 v3, v3, v143, v7
		v_max_f32_e32 v3, v3, v175
		v_mov_b32_e32 v20, v3
		v_mov_b32_e32 v21, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v20, v21
		v_max_f32_e32 v24, v20, v21
		v_max3_f32 v3, v192, v193, v194
		v_max3_f32 v7, v196, v197, v198
		v_max3_f32 v8, v200, v201, v202
		v_max3_f32 v12, v204, v205, v206
		v_max3_f32 v17, v208, v209, v210
		v_max3_f32 v20, v212, v213, v214
		v_max3_f32 v21, v216, v217, v218
		v_max3_f32 v22, v220, v221, v222
		v_max3_f32 v25, v224, v225, v226
		v_max3_f32 v26, v228, v229, v230
		v_max3_f32 v27, v232, v233, v234
		v_max3_f32 v28, v236, v237, v238
		v_max3_f32 v29, v176, v177, v178
		v_max3_f32 v30, v180, v181, v182
		v_max3_f32 v31, v184, v185, v186
		v_max3_f32 v96, v188, v189, v190
		v_max3_f32 v3, v3, v195, v7
		v_max3_f32 v7, v8, v203, v12
		v_max3_f32 v8, v17, v211, v20
		v_max3_f32 v12, v21, v219, v22
		v_max3_f32 v17, v25, v227, v26
		v_max3_f32 v20, v27, v235, v28
		v_max3_f32 v21, v29, v179, v30
		v_max3_f32 v22, v31, v187, v96
		v_max3_f32 v3, v3, v199, v7
		v_max3_f32 v7, v8, v215, v12
		v_max3_f32 v8, v17, v231, v20
		v_max3_f32 v12, v21, v183, v22
		v_max3_f32 v3, v3, v207, v7
		v_max3_f32 v7, v8, v239, v12
		v_max3_f32 v3, v3, v223, v7
		v_max_f32_e32 v3, v3, v191
		v_mov_b32_e32 v20, v3
		v_mov_b32_e32 v21, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v20, v21
		v_max_f32_e32 v25, v20, v21
		v_pk_mul_f32 v[20:21], v[24:25], v[4:5]
		v_max_f32_e32 v24, v9, v20
		v_max_f32_e32 v25, v13, v21
		v_pk_fma_f32 v[20:21], v[112:113], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[114:115], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[116:117], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[118:119], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[120:121], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[122:123], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[124:125], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[126:127], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[128:129], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[130:131], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[132:133], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[134:135], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[136:137], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[138:139], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[140:141], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[142:143], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[144:145], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[146:147], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[148:149], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[150:151], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[152:153], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[154:155], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[156:157], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[158:159], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[160:161], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[162:163], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[164:165], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[166:167], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[168:169], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[170:171], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[172:173], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[174:175], v[4:5], v[24:25] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[192:193], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[194:195], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[196:197], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[198:199], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[200:201], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[202:203], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[204:205], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[206:207], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[208:209], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[210:211], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[212:213], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[214:215], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[216:217], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[218:219], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[220:221], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[222:223], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[224:225], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[226:227], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[228:229], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[230:231], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[232:233], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[234:235], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[236:237], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[238:239], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[176:177], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[4:5], v[24:25] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v20
		v_exp_f32_e32 v218, v21
		v_exp_f32_e32 v20, v26
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
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v248, v119
		v_exp_f32_e32 v191, v120
		v_exp_f32_e32 v219, v121
		v_exp_f32_e32 v21, v122
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
		v_exp_f32_e32 v117, v150
		v_exp_f32_e32 v249, v151
		v_exp_f32_e32 v118, v152
		v_exp_f32_e32 v120, v153
		v_exp_f32_e32 v122, v154
		v_exp_f32_e32 v124, v155
		v_exp_f32_e32 v126, v156
		v_exp_f32_e32 v128, v157
		v_exp_f32_e32 v130, v158
		v_exp_f32_e32 v132, v159
		v_exp_f32_e32 v134, v160
		v_exp_f32_e32 v136, v161
		v_exp_f32_e32 v138, v162
		v_exp_f32_e32 v140, v163
		v_exp_f32_e32 v142, v164
		v_exp_f32_e32 v144, v165
		v_exp_f32_e32 v146, v166
		v_exp_f32_e32 v148, v167
		v_exp_f32_e32 v150, v168
		v_exp_f32_e32 v152, v169
		v_exp_f32_e32 v154, v170
		v_exp_f32_e32 v156, v171
		v_exp_f32_e32 v158, v172
		v_exp_f32_e32 v160, v173
		v_exp_f32_e32 v162, v174
		v_exp_f32_e32 v164, v175
		v_exp_f32_e32 v166, v192
		v_exp_f32_e32 v168, v193
		v_exp_f32_e32 v170, v194
		v_exp_f32_e32 v172, v195
		v_exp_f32_e32 v174, v196
		v_exp_f32_e32 v192, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v119, v200
		v_exp_f32_e32 v121, v201
		v_exp_f32_e32 v123, v202
		v_exp_f32_e32 v125, v203
		v_exp_f32_e32 v127, v204
		v_exp_f32_e32 v129, v205
		v_exp_f32_e32 v131, v206
		v_exp_f32_e32 v133, v207
		v_exp_f32_e32 v135, v208
		v_exp_f32_e32 v137, v209
		v_exp_f32_e32 v139, v210
		v_exp_f32_e32 v141, v211
		v_exp_f32_e32 v143, v212
		v_exp_f32_e32 v145, v213
		v_exp_f32_e32 v147, v214
		v_exp_f32_e32 v149, v215
		v_exp_f32_e32 v151, v216
		v_exp_f32_e32 v153, v217
		v_exp_f32_e32 v155, v176
		v_exp_f32_e32 v157, v177
		v_exp_f32_e32 v159, v178
		v_exp_f32_e32 v161, v179
		v_exp_f32_e32 v163, v180
		v_exp_f32_e32 v165, v181
		v_exp_f32_e32 v167, v182
		v_exp_f32_e32 v169, v183
		v_exp_f32_e32 v171, v184
		v_exp_f32_e32 v173, v185
		v_exp_f32_e32 v175, v186
		v_exp_f32_e32 v193, v187
		v_exp_f32_e32 v195, v188
		v_exp_f32_e32 v197, v189
		v_pk_add_f32 v[176:177], v[190:191], v[218:219]
		v_pk_add_f32 v[178:179], v[20:21], v[220:221]
		v_pk_add_f32 v[180:181], v[26:27], v[222:223]
		v_pk_add_f32 v[182:183], v[28:29], v[224:225]
		v_pk_add_f32 v[184:185], v[30:31], v[226:227]
		v_pk_add_f32 v[186:187], v[96:97], v[228:229]
		v_pk_add_f32 v[188:189], v[98:99], v[230:231]
		v_pk_add_f32 v[198:199], v[100:101], v[232:233]
		v_pk_add_f32 v[200:201], v[102:103], v[234:235]
		v_pk_add_f32 v[202:203], v[104:105], v[236:237]
		v_pk_add_f32 v[204:205], v[106:107], v[238:239]
		v_pk_add_f32 v[206:207], v[108:109], v[240:241]
		v_pk_add_f32 v[208:209], v[110:111], v[242:243]
		v_pk_add_f32 v[210:211], v[112:113], v[244:245]
		v_pk_add_f32 v[212:213], v[114:115], v[246:247]
		v_pk_add_f32 v[214:215], v[116:117], v[248:249]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[184:185], v[186:187]
		v_pk_add_f32 v[182:183], v[188:189], v[198:199]
		v_pk_add_f32 v[184:185], v[200:201], v[202:203]
		v_pk_add_f32 v[186:187], v[204:205], v[206:207]
		v_pk_add_f32 v[188:189], v[208:209], v[210:211]
		v_pk_add_f32 v[198:199], v[212:213], v[214:215]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[184:185], v[186:187]
		v_pk_add_f32 v[182:183], v[188:189], v[198:199]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[176:177], v[178:179]
		v_add_f32_e32 v3, v180, v181
		v_accvgpr_read_b32 v7, a71
		ds_bpermute_b32 v176, v7, v3
		v_accvgpr_read_b32 v7, a72
		ds_bpermute_b32 v178, v7, v3
		v_pk_add_f32 v[180:181], v[118:119], v[120:121]
		v_pk_add_f32 v[182:183], v[122:123], v[124:125]
		v_pk_add_f32 v[184:185], v[126:127], v[128:129]
		v_pk_add_f32 v[186:187], v[130:131], v[132:133]
		v_pk_add_f32 v[188:189], v[134:135], v[136:137]
		v_pk_add_f32 v[198:199], v[138:139], v[140:141]
		v_pk_add_f32 v[200:201], v[142:143], v[144:145]
		v_pk_add_f32 v[202:203], v[146:147], v[148:149]
		v_pk_add_f32 v[204:205], v[150:151], v[152:153]
		v_pk_add_f32 v[206:207], v[154:155], v[156:157]
		v_pk_add_f32 v[208:209], v[158:159], v[160:161]
		v_pk_add_f32 v[210:211], v[162:163], v[164:165]
		v_pk_add_f32 v[212:213], v[166:167], v[168:169]
		v_pk_add_f32 v[214:215], v[170:171], v[172:173]
		v_pk_add_f32 v[216:217], v[174:175], v[192:193]
		v_pk_add_f32 v[250:251], v[194:195], v[196:197]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[198:199]
		v_pk_add_f32 v[186:187], v[200:201], v[202:203]
		v_pk_add_f32 v[188:189], v[204:205], v[206:207]
		v_pk_add_f32 v[198:199], v[208:209], v[210:211]
		v_pk_add_f32 v[200:201], v[212:213], v[214:215]
		v_pk_add_f32 v[202:203], v[216:217], v[250:251]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[198:199]
		v_pk_add_f32 v[186:187], v[200:201], v[202:203]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[180:181], v[182:183]
		v_mov_b32_e32 v179, v185
		v_mov_b32_e32 v177, v184
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[180:181], v[176:177], v[178:179]
		v_mov_b32_e32 v176, v181
		v_mov_b32_e32 v177, v181
		s_nop 1
		v_permlane32_swap_b32_e32 v176, v177
		v_add_f32_e32 v179, v176, v177
		v_sub_f32_e32 v3, v9, v24
		v_sub_f32_e32 v7, v13, v25
		v_exp_f32_e32 v8, v3
		v_exp_f32_e32 v12, v7
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
		v_mov_b32_e32 v13, v12
		v_pk_mul_f32 v[64:65], v[64:65], v[12:13]
		v_pk_mul_f32 v[66:67], v[66:67], v[12:13]
		v_pk_mul_f32 v[68:69], v[68:69], v[12:13]
		v_pk_mul_f32 v[70:71], v[70:71], v[12:13]
		v_pk_mul_f32 v[72:73], v[72:73], v[12:13]
		v_pk_mul_f32 v[74:75], v[74:75], v[12:13]
		v_pk_mul_f32 v[76:77], v[76:77], v[12:13]
		v_pk_mul_f32 v[78:79], v[78:79], v[12:13]
		v_pk_mul_f32 v[80:81], v[80:81], v[12:13]
		v_pk_mul_f32 v[82:83], v[82:83], v[12:13]
		v_pk_mul_f32 v[84:85], v[84:85], v[12:13]
		v_pk_mul_f32 v[86:87], v[86:87], v[12:13]
		v_pk_mul_f32 v[88:89], v[88:89], v[12:13]
		v_pk_mul_f32 v[90:91], v[90:91], v[12:13]
		v_pk_mul_f32 v[92:93], v[92:93], v[12:13]
		v_pk_mul_f32 v[94:95], v[94:95], v[12:13]
		v_mov_b32_e32 v176, v8
		v_mov_b32_e32 v177, v12
		v_mov_b32_e32 v178, v180
		v_mov_b64_e32 v[8:9], v[14:15]
		v_pk_fma_f32 v[14:15], v[8:9], v[176:177], v[178:179]
		v_cvt_pk_bf16_f32 v176, v190, v218
		v_cvt_pk_bf16_f32 v177, v20, v220
		v_cvt_pk_bf16_f32 v178, v26, v222
		v_cvt_pk_bf16_f32 v179, v28, v224
		v_cvt_pk_bf16_f32 v180, v30, v226
		v_cvt_pk_bf16_f32 v181, v96, v228
		v_cvt_pk_bf16_f32 v182, v98, v230
		v_cvt_pk_bf16_f32 v183, v100, v232
		v_cvt_pk_bf16_f32 v184, v102, v234
		v_cvt_pk_bf16_f32 v185, v104, v236
		v_cvt_pk_bf16_f32 v186, v106, v238
		v_cvt_pk_bf16_f32 v187, v108, v240
		v_cvt_pk_bf16_f32 v200, v110, v242
		v_cvt_pk_bf16_f32 v201, v112, v244
		v_cvt_pk_bf16_f32 v202, v114, v246
		v_cvt_pk_bf16_f32 v203, v116, v248
		v_cvt_pk_bf16_f32 v204, v191, v219
		v_cvt_pk_bf16_f32 v205, v21, v221
		v_cvt_pk_bf16_f32 v206, v27, v223
		v_cvt_pk_bf16_f32 v207, v29, v225
		v_cvt_pk_bf16_f32 v188, v31, v227
		v_cvt_pk_bf16_f32 v189, v97, v229
		v_cvt_pk_bf16_f32 v190, v99, v231
		v_cvt_pk_bf16_f32 v191, v101, v233
		v_cvt_pk_bf16_f32 v28, v103, v235
		v_cvt_pk_bf16_f32 v29, v105, v237
		v_cvt_pk_bf16_f32 v30, v107, v239
		v_cvt_pk_bf16_f32 v31, v109, v241
		v_cvt_pk_bf16_f32 v96, v111, v243
		v_cvt_pk_bf16_f32 v97, v113, v245
		v_cvt_pk_bf16_f32 v98, v115, v247
		v_cvt_pk_bf16_f32 v99, v117, v249
		v_cvt_pk_bf16_f32 v100, v118, v120
		v_cvt_pk_bf16_f32 v101, v122, v124
		v_cvt_pk_bf16_f32 v102, v126, v128
		v_cvt_pk_bf16_f32 v103, v130, v132
		v_cvt_pk_bf16_f32 v104, v134, v136
		v_cvt_pk_bf16_f32 v105, v138, v140
		v_cvt_pk_bf16_f32 v106, v142, v144
		v_cvt_pk_bf16_f32 v107, v146, v148
		v_cvt_pk_bf16_f32 v108, v150, v152
		v_cvt_pk_bf16_f32 v109, v154, v156
		v_cvt_pk_bf16_f32 v110, v158, v160
		v_cvt_pk_bf16_f32 v111, v162, v164
		v_cvt_pk_bf16_f32 v112, v166, v168
		v_cvt_pk_bf16_f32 v113, v170, v172
		v_cvt_pk_bf16_f32 v114, v174, v192
		v_cvt_pk_bf16_f32 v115, v194, v196
		v_cvt_pk_bf16_f32 v208, v119, v121
		v_cvt_pk_bf16_f32 v209, v123, v125
		v_cvt_pk_bf16_f32 v210, v127, v129
		v_cvt_pk_bf16_f32 v211, v131, v133
		v_cvt_pk_bf16_f32 v116, v135, v137
		v_cvt_pk_bf16_f32 v117, v139, v141
		v_cvt_pk_bf16_f32 v118, v143, v145
		v_cvt_pk_bf16_f32 v119, v147, v149
		v_cvt_pk_bf16_f32 v120, v151, v153
		v_cvt_pk_bf16_f32 v121, v155, v157
		v_cvt_pk_bf16_f32 v122, v159, v161
		v_cvt_pk_bf16_f32 v123, v163, v165
		v_cvt_pk_bf16_f32 v124, v167, v169
		v_cvt_pk_bf16_f32 v125, v171, v173
		v_cvt_pk_bf16_f32 v126, v175, v193
		v_cvt_pk_bf16_f32 v127, v195, v197
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[176:179], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[176:179], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[100:103], v[80:95]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[100:103], v[64:79]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[104:107], v[80:95]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
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
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[208:211], v[64:79]
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
		v_mov_b32_e32 v9, v24
		v_mov_b32_e32 v13, v25
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s25, s25, 0x80
		v_accvgpr_read_b32 v3, a10
		v_readfirstlane_b32 s36, v2
		s_nop 1
		v_add_u32_e32 v3, s36, v3
		v_add_u32_e32 v3, s19, v3
		v_accvgpr_read_b32 v7, a11
		v_readfirstlane_b32 s36, v2
		s_nop 1
		v_add_u32_e32 v7, s36, v7
		v_add_u32_e32 v7, s19, v7
		v_xor_b32_e32 v8, 1, v10
		v_accvgpr_write_b32 a10, v8
		v_xor_b32_e32 v8, 2, v10
		v_accvgpr_write_b32 a11, v8
		v_xor_b32_e32 v8, 3, v10
		v_accvgpr_write_b32 a63, v8
		v_xor_b32_e32 v8, 8, v10
		v_accvgpr_write_b32 a67, v8
		v_xor_b32_e32 v8, 9, v10
		v_accvgpr_write_b32 a73, v8
		v_xor_b32_e32 v8, 10, v10
		v_accvgpr_write_b32 a74, v8
		v_xor_b32_e32 v8, 11, v10
		v_accvgpr_write_b32 a75, v8
		v_xor_b32_e32 v8, 16, v10
		v_accvgpr_write_b32 a76, v8
		v_xor_b32_e32 v8, 17, v10
		v_accvgpr_write_b32 a77, v8
		v_xor_b32_e32 v8, 18, v10
		v_accvgpr_write_b32 a78, v8
		v_xor_b32_e32 v8, 19, v10
		v_accvgpr_write_b32 a79, v8
		v_xor_b32_e32 v8, 24, v10
		v_accvgpr_write_b32 a80, v8
		v_xor_b32_e32 v8, 25, v10
		v_accvgpr_write_b32 a81, v8
		v_xor_b32_e32 v8, 26, v10
		v_accvgpr_write_b32 a82, v8
		v_xor_b32_e32 v8, 27, v10
		v_accvgpr_write_b32 a83, v8
		v_xor_b32_e32 v8, 32, v10
		v_accvgpr_write_b32 a84, v8
		v_xor_b32_e32 v8, 33, v10
		v_accvgpr_write_b32 a85, v8
		v_xor_b32_e32 v8, 34, v10
		v_accvgpr_write_b32 a86, v8
		v_xor_b32_e32 v8, 35, v10
		v_accvgpr_write_b32 a87, v8
		v_xor_b32_e32 v8, 40, v10
		v_accvgpr_write_b32 a88, v8
		v_xor_b32_e32 v8, 41, v10
		v_accvgpr_write_b32 a89, v8
		v_xor_b32_e32 v8, 42, v10
		v_accvgpr_write_b32 a90, v8
		v_xor_b32_e32 v8, 43, v10
		v_accvgpr_write_b32 a91, v8
		v_xor_b32_e32 v8, 48, v10
		v_accvgpr_write_b32 a92, v8
		v_xor_b32_e32 v8, 49, v10
		v_accvgpr_write_b32 a93, v8
		v_xor_b32_e32 v8, 50, v10
		v_accvgpr_write_b32 a94, v8
		v_xor_b32_e32 v8, 51, v10
		v_accvgpr_write_b32 a95, v8
		v_xor_b32_e32 v8, 56, v10
		v_accvgpr_write_b32 a96, v8
		v_xor_b32_e32 v8, 57, v10
		v_accvgpr_write_b32 a97, v8
		v_xor_b32_e32 v8, 58, v10
		v_accvgpr_write_b32 a98, v8
		v_xor_b32_e32 v8, 59, v10
		v_accvgpr_write_b32 a99, v8
		v_xor_b32_e32 v8, 64, v10
		v_accvgpr_write_b32 a100, v8
		v_xor_b32_e32 v8, 0x41, v10
		v_accvgpr_write_b32 a101, v8
		v_xor_b32_e32 v8, 0x42, v10
		v_accvgpr_write_b32 a102, v8
		v_xor_b32_e32 v8, 0x43, v10
		v_accvgpr_write_b32 a103, v8
		v_xor_b32_e32 v8, 0x48, v10
		v_accvgpr_write_b32 a104, v8
		v_xor_b32_e32 v8, 0x49, v10
		v_accvgpr_write_b32 a105, v8
		v_xor_b32_e32 v8, 0x4a, v10
		v_accvgpr_write_b32 a106, v8
		v_xor_b32_e32 v8, 0x4b, v10
		v_accvgpr_write_b32 a107, v8
		v_xor_b32_e32 v8, 0x50, v10
		v_accvgpr_write_b32 a108, v8
		v_xor_b32_e32 v8, 0x51, v10
		v_accvgpr_write_b32 a109, v8
		v_xor_b32_e32 v8, 0x52, v10
		v_accvgpr_write_b32 a110, v8
		v_xor_b32_e32 v8, 0x53, v10
		v_accvgpr_write_b32 a111, v8
		v_xor_b32_e32 v8, 0x58, v10
		v_accvgpr_write_b32 a112, v8
		v_xor_b32_e32 v8, 0x59, v10
		v_accvgpr_write_b32 a113, v8
		v_xor_b32_e32 v8, 0x5a, v10
		v_accvgpr_write_b32 a114, v8
		v_xor_b32_e32 v8, 0x5b, v10
		v_accvgpr_write_b32 a115, v8
		v_xor_b32_e32 v8, 0x60, v10
		v_accvgpr_write_b32 a116, v8
		v_xor_b32_e32 v8, 0x61, v10
		v_accvgpr_write_b32 a117, v8
		v_xor_b32_e32 v8, 0x62, v10
		v_accvgpr_write_b32 a118, v8
		v_xor_b32_e32 v8, 0x63, v10
		v_accvgpr_write_b32 a119, v8
		v_xor_b32_e32 v8, 0x68, v10
		v_accvgpr_write_b32 a120, v8
		v_xor_b32_e32 v8, 0x69, v10
		v_accvgpr_write_b32 a121, v8
		v_xor_b32_e32 v8, 0x6a, v10
		v_accvgpr_write_b32 a122, v8
		v_xor_b32_e32 v8, 0x6b, v10
		v_accvgpr_write_b32 a123, v8
		v_xor_b32_e32 v8, 0x70, v10
		v_accvgpr_write_b32 a124, v8
		v_xor_b32_e32 v8, 0x71, v10
		v_accvgpr_write_b32 a125, v8
		v_xor_b32_e32 v8, 0x72, v10
		v_accvgpr_write_b32 a126, v8
		v_xor_b32_e32 v8, 0x73, v10
		v_accvgpr_write_b32 a127, v8
		v_xor_b32_e32 v8, 0x78, v10
		v_accvgpr_write_b32 a128, v8
		v_xor_b32_e32 v8, 0x79, v10
		v_accvgpr_write_b32 a129, v8
		v_xor_b32_e32 v8, 0x7a, v10
		v_accvgpr_write_b32 a130, v8
		v_xor_b32_e32 v8, 0x7b, v10
		v_accvgpr_write_b32 a131, v8
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v8, v8, 4, v16
		v_add3_u32 v8, v8, v18, v19
		v_accvgpr_read_b32 v12, a64
		v_accvgpr_read_b32 v16, a65
		v_add3_u32 v8, v8, v12, v16
		v_accvgpr_write_b32 a17, v8
		v_accvgpr_read_b32 v8, a66
		v_accvgpr_read_b32 v12, a68
		v_lshl_add_u32 v8, v8, 3, v12
		v_accvgpr_read_b32 v12, a69
		v_accvgpr_read_b32 v16, a70
		v_add3_u32 v8, v8, v12, v16
		v_accvgpr_write_b32 a64, v8
		v_mov_b32_e32 v8, 0xff800000
		s_cmp_lt_i32 s44, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s19, s44, 0x80
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s36, s24, 0
		s_add_i32 s36, s44, s36
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
		v_accvgpr_read_b32 v12, a17
		v_add_u32_e32 v12, s36, v12
		ds_read_b128 a[132:135], v12
		ds_read_b128 a[136:139], v12 offset:32
		ds_read_b128 a[140:143], v12 offset:64
		ds_read_b128 a[144:147], v12 offset:96
		ds_read_b128 a[148:151], v12 offset:256
		ds_read_b128 a[152:155], v12 offset:288
		ds_read_b128 a[156:159], v12 offset:320
		ds_read_b128 a[160:163], v12 offset:352
		ds_read_b128 a[164:167], v12 offset:128
		ds_read_b128 a[168:171], v12 offset:160
		ds_read_b128 a[172:175], v12 offset:192
		ds_read_b128 a[176:179], v12 offset:224
		ds_read_b128 v[16:19], v12 offset:384
		ds_read_b128 a[180:183], v12 offset:416
		ds_read_b128 a[184:187], v12 offset:448
		ds_read_b128 a[188:191], v12 offset:480
		s_mul_i32 s36, 0x4400, s39
		v_accvgpr_read_b32 v12, a64
		v_add_u32_e32 v12, s36, v12
		ds_read_b64_tr_b16 a[192:193], v12 offset:33264
		ds_read_b64_tr_b16 a[194:195], v12 offset:37616
		ds_read_b64_tr_b16 a[196:197], v12 offset:33392
		ds_read_b64_tr_b16 a[198:199], v12 offset:37744
		ds_read_b64_tr_b16 a[200:201], v12 offset:33520
		ds_read_b64_tr_b16 a[202:203], v12 offset:37872
		ds_read_b64_tr_b16 a[204:205], v12 offset:33648
		ds_read_b64_tr_b16 a[206:207], v12 offset:38000
		ds_read_b64_tr_b16 a[208:209], v12 offset:33776
		ds_read_b64_tr_b16 a[210:211], v12 offset:38128
		ds_read_b64_tr_b16 a[212:213], v12 offset:33904
		ds_read_b64_tr_b16 a[214:215], v12 offset:38256
		ds_read_b64_tr_b16 a[216:217], v12 offset:34032
		ds_read_b64_tr_b16 a[218:219], v12 offset:38384
		ds_read_b64_tr_b16 a[220:221], v12 offset:34160
		ds_read_b64_tr_b16 a[222:223], v12 offset:38512
		ds_read_b64_tr_b16 a[224:225], v12 offset:33328
		ds_read_b64_tr_b16 a[226:227], v12 offset:37680
		ds_read_b64_tr_b16 a[228:229], v12 offset:33456
		ds_read_b64_tr_b16 a[230:231], v12 offset:37808
		ds_read_b64_tr_b16 a[232:233], v12 offset:33584
		ds_read_b64_tr_b16 a[234:235], v12 offset:37936
		ds_read_b64_tr_b16 a[236:237], v12 offset:33712
		ds_read_b64_tr_b16 a[238:239], v12 offset:38064
		ds_read_b64_tr_b16 a[240:241], v12 offset:33840
		ds_read_b64_tr_b16 a[242:243], v12 offset:38192
		ds_read_b64_tr_b16 a[244:245], v12 offset:33968
		ds_read_b64_tr_b16 a[246:247], v12 offset:38320
		ds_read_b64_tr_b16 a[248:249], v12 offset:34096
		ds_read_b64_tr_b16 a[250:251], v12 offset:38448
		ds_read_b64_tr_b16 a[252:253], v12 offset:34224
		ds_read_b64_tr_b16 a[254:255], v12 offset:38576
		s_cmp_lt_i32 s19, s23
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v12, a18
		v_add_u32_e32 v12, s19, v12
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, s19, v12
		v_cmp_lt_i32_e64 s[54:55], v12, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s36, s15, s44
		s_lshl_b32 s36, s36, 1
		s_add_i32 s39, s45, s36
		v_add_u32_e32 v12, s39, v11
		v_cndmask_b32_e64 v12, v23, v12, s[52:53]
		s_mov_b32 s52, 1
		s_mov_b32 s53, 0
		s_mov_b32 s41, 0
		s_mul_i32 s56, s52, s40
		s_mul_hi_u32 s57, s52, s40
		s_mul_i32 s39, s52, s41
		s_add_i32 s57, s57, s39
		s_mul_i32 s39, s53, s40
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
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s43, -1, 0
		s_mov_b32 s56, 0x4100
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s42
		s_mul_hi_u32 s61, s56, s42
		s_mul_i32 s39, s56, s43
		s_add_i32 s61, s61, s39
		s_mul_i32 s39, s57, s42
		s_add_i32 s61, s61, s39
		s_add_u32 s56, s58, s60
		s_addc_u32 s57, s59, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v20, a53
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v20, s21
		s_add_i32 s39, s46, s36
		v_add_u32_e32 v12, s39, v11
		v_cndmask_b32_e64 v12, v23, v12, s[56:57]
		s_add_u32 s56, s58, 0x1040
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v20, a58
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v20, s21
		s_add_i32 s39, s47, s36
		v_add_u32_e32 v12, s39, v11
		v_cndmask_b32_e64 v12, v23, v12, s[56:57]
		s_add_u32 s56, s58, 0x2080
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v20, a59
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v20, s21
		s_add_i32 s36, s37, s36
		v_add_u32_e32 v12, s36, v11
		v_cndmask_b32_e64 v12, v23, v12, s[56:57]
		s_add_u32 s56, s58, 0x30c0
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v20, a60
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_mul_i32 s36, s17, s44
		s_lshl_b32 s36, s36, 1
		s_add_i32 s39, s48, s36
		v_add_u32_e32 v12, s39, v6
		v_cndmask_b32_e64 v12, v23, v12, s[54:55]
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
		s_mul_i32 s58, s54, s42
		s_mul_hi_u32 s59, s54, s42
		s_mul_i32 s39, s54, s43
		s_add_i32 s59, s59, s39
		s_mul_i32 s39, s55, s42
		s_add_i32 s59, s59, s39
		s_add_u32 s42, s52, s58
		s_addc_u32 s43, s53, s59
		s_add_u32 s52, s42, 0
		s_addc_u32 s53, s43, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v21, a61
		v_add_u32_e32 v21, s19, v21
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v20, s21
		s_add_i32 s39, s49, s36
		v_add_u32_e32 v12, s39, v6
		v_cndmask_b32_e64 v12, v23, v12, s[42:43]
		s_add_u32 s42, s56, 0x92f0
		s_addc_u32 s43, s57, 0
		s_add_u32 s42, s42, s58
		s_addc_u32 s43, s43, s59
		s_add_u32 s52, s42, 0
		s_addc_u32 s53, s43, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v20, a62
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v21, s21
		s_add_i32 s19, s50, s36
		v_add_u32_e32 v12, s19, v6
		s_add_u32 s52, s56, 0xa3f0
		s_addc_u32 s53, s57, 0
		s_add_u32 s52, s52, s58
		s_addc_u32 s53, s53, s59
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v12, v23, v12, s[42:43]
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_add_i32 s19, s38, s36
		v_cmp_lt_i32_e64 vcc, v20, s21
		v_add_u32_e32 v12, s19, v6
		s_add_u32 s42, s56, 0xb4f0
		s_addc_u32 s43, s57, 0
		v_cndmask_b32_e32 v12, v23, v12, vcc
		s_add_u32 s42, s42, s58
		s_addc_u32 s43, s43, s59
		s_add_u32 s52, s42, 0
		s_addc_u32 s53, s43, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[20:23], 0
		v_add_u32_e32 v12, s44, v10
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[20:23], 0
		v_accvgpr_read_b32 v20, a10
		v_add_u32_e32 v20, s44, v20
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[20:23], 0
		v_accvgpr_read_b32 v21, a11
		v_add_u32_e32 v21, s44, v21
		v_mfma_f32_32x32x16_bf16 v[144:159], v[16:19], a[20:23], 0
		v_accvgpr_read_b32 v22, a63
		v_add_u32_e32 v22, s44, v22
		v_mfma_f32_32x32x16_bf16 v[160:175], v[16:19], a[36:39], 0
		v_accvgpr_read_b32 v16, a74
		v_add_u32_e32 v16, s44, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[36:39], 0
		v_accvgpr_read_b32 v17, a75
		v_add_u32_e32 v17, s44, v17
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[36:39], 0
		v_accvgpr_read_b32 v18, a78
		v_add_u32_e32 v18, s44, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[36:39], 0
		v_accvgpr_read_b32 v19, a79
		v_add_u32_e32 v19, s44, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[24:27], v[96:111]
		v_accvgpr_read_b32 v24, a82
		v_add_u32_e32 v24, s44, v24
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[24:27], v[112:127]
		v_accvgpr_read_b32 v25, a83
		v_add_u32_e32 v25, s44, v25
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[24:27], v[128:143]
		v_accvgpr_read_b32 v26, a86
		v_add_u32_e32 v26, s44, v26
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[24:27], v[144:159]
		v_accvgpr_read_b32 v27, a87
		v_add_u32_e32 v27, s44, v27
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[40:43], v[160:175]
		v_accvgpr_read_b32 v28, a90
		v_add_u32_e32 v28, s44, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[40:43], v[176:191]
		v_accvgpr_read_b32 v29, a91
		v_add_u32_e32 v29, s44, v29
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[40:43], v[192:207]
		v_accvgpr_read_b32 v30, a94
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a65, v30
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[40:43], v[208:223]
		v_accvgpr_read_b32 v30, a95
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a66, v30
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[28:31], v[96:111]
		v_accvgpr_read_b32 v30, a98
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a68, v30
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[28:31], v[112:127]
		v_accvgpr_read_b32 v30, a99
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a69, v30
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[28:31], v[128:143]
		v_accvgpr_read_b32 v30, a102
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a70, v30
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[28:31], v[144:159]
		v_accvgpr_read_b32 v30, a103
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a132, v30
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[44:47], v[160:175]
		v_accvgpr_read_b32 v30, a106
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a133, v30
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[44:47], v[176:191]
		v_accvgpr_read_b32 v30, a107
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a134, v30
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[44:47], v[192:207]
		v_accvgpr_read_b32 v30, a110
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a135, v30
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[44:47], v[208:223]
		v_accvgpr_read_b32 v30, a111
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a136, v30
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[32:35], v[96:111]
		v_accvgpr_read_b32 v30, a114
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a137, v30
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[32:35], v[112:127]
		v_accvgpr_read_b32 v30, a115
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a138, v30
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[32:35], v[128:143]
		v_accvgpr_read_b32 v30, a118
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a139, v30
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[32:35], v[144:159]
		v_accvgpr_read_b32 v30, a119
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a140, v30
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[48:51], v[160:175]
		v_accvgpr_read_b32 v30, a122
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a141, v30
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[48:51], v[176:191]
		v_accvgpr_read_b32 v30, a123
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a142, v30
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[48:51], v[192:207]
		v_accvgpr_read_b32 v30, a126
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a143, v30
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[48:51], v[208:223]
		v_accvgpr_read_b32 v30, a127
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a144, v30
		v_accvgpr_read_b32 v30, a130
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a145, v30
		v_accvgpr_read_b32 v30, a131
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a146, v30
		v_cmp_ge_i32_e64 s[42:43], v3, v12
		v_cmp_ge_i32_e64 s[52:53], v3, v20
		v_cmp_ge_i32_e64 s[54:55], v3, v21
		v_cmp_ge_i32_e64 vcc, v3, v22
		v_accvgpr_read_b32 v30, a67
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_read_b32 v31, a73
		v_add_u32_e32 v31, s44, v31
		v_cndmask_b32_e32 v225, v8, v99, vcc
		v_cmp_ge_i32_e64 s[56:57], v3, v30
		v_cmp_ge_i32_e64 s[58:59], v3, v31
		v_cmp_ge_i32_e64 s[60:61], v3, v16
		v_cmp_ge_i32_e64 vcc, v3, v17
		v_accvgpr_read_b32 v99, a76
		v_add_u32_e32 v99, s44, v99
		v_accvgpr_read_b32 v224, a77
		v_add_u32_e32 v226, s44, v224
		v_cndmask_b32_e32 v229, v8, v103, vcc
		v_cmp_ge_i32_e64 s[62:63], v3, v99
		v_cmp_ge_i32_e64 s[64:65], v3, v226
		v_cmp_ge_i32_e64 s[66:67], v3, v18
		v_cmp_ge_i32_e64 vcc, v3, v19
		v_accvgpr_read_b32 v103, a80
		v_add_u32_e32 v103, s44, v103
		v_accvgpr_read_b32 v224, a81
		v_add_u32_e32 v227, s44, v224
		v_cndmask_b32_e32 v231, v8, v107, vcc
		v_cmp_ge_i32_e64 s[68:69], v3, v103
		v_cmp_ge_i32_e64 s[70:71], v3, v227
		v_cmp_ge_i32_e64 s[72:73], v3, v24
		v_cmp_ge_i32_e64 vcc, v3, v25
		v_accvgpr_read_b32 v107, a84
		v_add_u32_e32 v107, s44, v107
		v_accvgpr_read_b32 v224, a85
		v_add_u32_e32 v232, s44, v224
		v_cndmask_b32_e32 v235, v8, v111, vcc
		v_cmp_ge_i32_e64 s[74:75], v3, v107
		v_cmp_ge_i32_e64 s[76:77], v3, v232
		v_cmp_ge_i32_e64 s[78:79], v3, v26
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_accvgpr_read_b32 v111, a88
		v_add_u32_e32 v111, s44, v111
		v_accvgpr_read_b32 v224, a89
		v_add_u32_e32 v233, s44, v224
		v_cndmask_b32_e32 v237, v8, v115, vcc
		v_cmp_ge_i32_e64 s[80:81], v3, v111
		v_cmp_ge_i32_e64 s[82:83], v3, v233
		v_cmp_ge_i32_e64 s[84:85], v3, v28
		s_nop 1
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_write_b32 a148, v238
		v_accvgpr_write_b32 a149, v239
		v_cmp_ge_i32_e64 vcc, v3, v29
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_read_b32 v115, a92
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_read_b32 v224, a93
		v_add_u32_e32 v236, s44, v224
		v_cndmask_b32_e32 v239, v8, v119, vcc
		v_cmp_ge_i32_e64 s[84:85], v3, v115
		s_nop 1
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_cmp_ge_i32_e64 s[84:85], v3, v236
		s_nop 1
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a152, v240
		v_accvgpr_write_b32 a153, v241
		v_accvgpr_read_b32 v119, a65
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a154, v240
		v_accvgpr_write_b32 a155, v241
		v_accvgpr_read_b32 v119, a66
		v_cmp_ge_i32_e64 vcc, v3, v119
		v_accvgpr_read_b32 v119, a96
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a147, v119
		v_accvgpr_read_b32 v119, a97
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a156, v119
		v_cndmask_b32_e32 v241, v8, v123, vcc
		v_accvgpr_read_b32 v119, a147
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a158, v242
		v_accvgpr_write_b32 a159, v243
		v_accvgpr_read_b32 v119, a156
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v119, a68
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a162, v242
		v_accvgpr_write_b32 a163, v243
		v_accvgpr_read_b32 v119, a69
		v_cmp_ge_i32_e64 vcc, v3, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_read_b32 v119, a100
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a157, v119
		v_accvgpr_read_b32 v119, a101
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a164, v119
		v_cndmask_b32_e32 v243, v8, v127, vcc
		v_accvgpr_read_b32 v119, a157
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v119, a164
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v119, a70
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a170, v244
		v_accvgpr_write_b32 a171, v245
		v_accvgpr_read_b32 v119, a132
		v_cmp_ge_i32_e64 vcc, v3, v119
		v_accvgpr_read_b32 v119, a104
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a165, v119
		v_accvgpr_read_b32 v119, a105
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a172, v119
		v_cndmask_b32_e32 v245, v8, v131, vcc
		v_accvgpr_read_b32 v119, a165
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v119, a172
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v119, a133
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a178, v246
		v_accvgpr_write_b32 a179, v247
		v_accvgpr_read_b32 v119, a134
		v_cmp_ge_i32_e64 vcc, v3, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_read_b32 v119, a108
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a173, v119
		v_accvgpr_read_b32 v119, a109
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a180, v119
		v_cndmask_b32_e32 v247, v8, v135, vcc
		v_accvgpr_read_b32 v119, a173
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v119, a180
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a184, v248
		v_accvgpr_write_b32 a185, v249
		v_accvgpr_read_b32 v119, a135
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a186, v248
		v_accvgpr_write_b32 a187, v249
		v_accvgpr_read_b32 v119, a136
		v_cmp_ge_i32_e64 vcc, v3, v119
		v_accvgpr_read_b32 v119, a112
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a181, v119
		v_accvgpr_read_b32 v119, a113
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a188, v119
		v_cndmask_b32_e32 v249, v8, v139, vcc
		v_accvgpr_read_b32 v119, a181
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		s_nop 1
		v_mov_b32_e32 v250, s84
		v_mov_b32_e32 v251, s85
		v_accvgpr_write_b32 a190, v250
		v_accvgpr_write_b32 a191, v251
		v_accvgpr_read_b32 v119, a188
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		v_accvgpr_read_b32 v119, a137
		v_cmp_ge_i32_e64 s[86:87], v3, v119
		v_cndmask_b32_e64 v251, v8, v141, s[84:85]
		s_nop 0
		v_cndmask_b32_e64 v252, v8, v142, s[86:87]
		v_accvgpr_read_b32 v119, a138
		v_cmp_ge_i32_e64 vcc, v3, v119
		v_accvgpr_read_b32 v119, a116
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_read_b32 v123, a117
		v_add_u32_e32 v123, s44, v123
		v_cndmask_b32_e32 v253, v8, v143, vcc
		v_cmp_ge_i32_e64 s[84:85], v3, v119
		v_cmp_ge_i32_e64 s[86:87], v3, v123
		v_accvgpr_read_b32 v127, a139
		v_cmp_ge_i32_e64 s[88:89], v3, v127
		v_cndmask_b32_e64 v142, v8, v144, s[84:85]
		v_cndmask_b32_e64 v143, v8, v145, s[86:87]
		v_cndmask_b32_e64 v144, v8, v146, s[88:89]
		v_accvgpr_read_b32 v127, a140
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a120
		v_add_u32_e32 v127, s44, v127
		v_accvgpr_read_b32 v131, a121
		v_add_u32_e32 v131, s44, v131
		v_cndmask_b32_e32 v145, v8, v147, vcc
		v_cmp_ge_i32_e64 s[84:85], v3, v127
		v_cmp_ge_i32_e64 s[86:87], v3, v131
		v_accvgpr_read_b32 v135, a141
		v_cmp_ge_i32_e64 s[88:89], v3, v135
		v_cndmask_b32_e64 v146, v8, v148, s[84:85]
		v_cndmask_b32_e64 v147, v8, v149, s[86:87]
		v_cndmask_b32_e64 v148, v8, v150, s[88:89]
		v_accvgpr_read_b32 v135, a142
		v_cmp_ge_i32_e64 vcc, v3, v135
		v_accvgpr_read_b32 v135, a124
		v_add_u32_e32 v135, s44, v135
		v_accvgpr_read_b32 v139, a125
		v_add_u32_e32 v139, s44, v139
		v_cndmask_b32_e32 v149, v8, v151, vcc
		v_cmp_ge_i32_e64 s[84:85], v3, v135
		v_cmp_ge_i32_e64 s[86:87], v3, v139
		v_accvgpr_read_b32 v141, a143
		v_cmp_ge_i32_e64 s[88:89], v3, v141
		v_cndmask_b32_e64 v150, v8, v152, s[84:85]
		v_cndmask_b32_e64 v151, v8, v153, s[86:87]
		v_cndmask_b32_e64 v152, v8, v154, s[88:89]
		v_accvgpr_read_b32 v141, a144
		v_cmp_ge_i32_e64 vcc, v3, v141
		v_accvgpr_read_b32 v141, a128
		v_add_u32_e32 v141, s44, v141
		v_accvgpr_read_b32 v153, a129
		v_add_u32_e32 v153, s44, v153
		v_accvgpr_write_b32 a189, v153
		v_cndmask_b32_e32 v153, v8, v155, vcc
		v_cmp_ge_i32_e64 s[84:85], v3, v141
		v_accvgpr_read_b32 v154, a189
		v_cmp_ge_i32_e64 s[86:87], v3, v154
		v_accvgpr_read_b32 v154, a145
		v_cmp_ge_i32_e64 s[88:89], v3, v154
		v_cndmask_b32_e64 v154, v8, v156, s[84:85]
		v_cndmask_b32_e64 v155, v8, v157, s[86:87]
		v_cndmask_b32_e64 v156, v8, v158, s[88:89]
		v_accvgpr_read_b32 v157, a146
		v_cmp_ge_i32_e64 vcc, v3, v157
		v_cndmask_b32_e64 v254, v8, v96, s[42:43]
		v_cndmask_b32_e64 v255, v8, v97, s[52:53]
		v_cndmask_b32_e32 v157, v8, v159, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v12
		v_cmp_ge_i32_e64 s[52:53], v7, v20
		v_cmp_ge_i32_e64 s[84:85], v7, v21
		v_cndmask_b32_e64 v20, v8, v176, s[42:43]
		v_cndmask_b32_e64 v21, v8, v177, s[52:53]
		v_cndmask_b32_e64 v96, v8, v178, s[84:85]
		v_cmp_ge_i32_e64 vcc, v7, v22
		v_cndmask_b32_e64 v224, v8, v98, s[54:55]
		v_cndmask_b32_e64 v158, v8, v100, s[56:57]
		v_cndmask_b32_e32 v97, v8, v179, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v30
		v_cmp_ge_i32_e64 s[52:53], v7, v31
		v_cmp_ge_i32_e64 s[54:55], v7, v16
		v_cndmask_b32_e64 v30, v8, v180, s[42:43]
		v_cndmask_b32_e64 v31, v8, v181, s[52:53]
		v_cndmask_b32_e64 v176, v8, v182, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v17
		v_cndmask_b32_e64 v159, v8, v101, s[58:59]
		v_cndmask_b32_e64 v228, v8, v102, s[60:61]
		v_cndmask_b32_e32 v177, v8, v183, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v99
		v_cmp_ge_i32_e64 s[52:53], v7, v226
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_cndmask_b32_e64 v16, v8, v184, s[42:43]
		v_cndmask_b32_e64 v17, v8, v185, s[52:53]
		v_cndmask_b32_e64 v98, v8, v186, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v19
		v_cndmask_b32_e64 v18, v8, v104, s[62:63]
		v_cndmask_b32_e64 v19, v8, v105, s[64:65]
		v_cndmask_b32_e32 v99, v8, v187, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v103
		v_cmp_ge_i32_e64 s[52:53], v7, v227
		v_cmp_ge_i32_e64 s[54:55], v7, v24
		v_cndmask_b32_e64 v100, v8, v188, s[42:43]
		v_cndmask_b32_e64 v101, v8, v189, s[52:53]
		v_cndmask_b32_e64 v102, v8, v190, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v25
		v_cndmask_b32_e64 v230, v8, v106, s[66:67]
		v_cndmask_b32_e64 v24, v8, v108, s[68:69]
		v_cndmask_b32_e32 v103, v8, v191, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v107
		v_cmp_ge_i32_e64 s[52:53], v7, v232
		v_cmp_ge_i32_e64 s[54:55], v7, v26
		v_cndmask_b32_e64 v104, v8, v192, s[42:43]
		v_cndmask_b32_e64 v105, v8, v193, s[52:53]
		v_cndmask_b32_e64 v106, v8, v194, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v27
		v_cndmask_b32_e64 v25, v8, v109, s[70:71]
		v_cndmask_b32_e64 v234, v8, v110, s[72:73]
		v_cndmask_b32_e32 v107, v8, v195, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v111
		v_cmp_ge_i32_e64 s[52:53], v7, v233
		v_cmp_ge_i32_e64 s[54:55], v7, v28
		v_cndmask_b32_e64 v26, v8, v196, s[42:43]
		v_cndmask_b32_e64 v27, v8, v197, s[52:53]
		v_cndmask_b32_e64 v108, v8, v198, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v29
		v_cndmask_b32_e64 v28, v8, v112, s[74:75]
		v_cndmask_b32_e64 v29, v8, v113, s[76:77]
		v_cndmask_b32_e32 v109, v8, v199, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v115
		v_cmp_ge_i32_e64 s[52:53], v7, v236
		v_accvgpr_read_b32 v12, a65
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v110, v8, v200, s[42:43]
		v_cndmask_b32_e64 v111, v8, v201, s[52:53]
		v_cndmask_b32_e64 v112, v8, v202, s[54:55]
		v_accvgpr_read_b32 v12, a66
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_cndmask_b32_e64 v236, v8, v114, s[78:79]
		v_cndmask_b32_e64 v114, v8, v116, s[80:81]
		v_cndmask_b32_e32 v113, v8, v203, vcc
		v_accvgpr_read_b32 v12, a147
		v_cmp_ge_i32_e64 s[42:43], v7, v12
		v_accvgpr_read_b32 v12, a156
		v_cmp_ge_i32_e64 s[52:53], v7, v12
		v_accvgpr_read_b32 v12, a68
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v178, v8, v204, s[42:43]
		v_cndmask_b32_e64 v179, v8, v205, s[52:53]
		v_cndmask_b32_e64 v180, v8, v206, s[54:55]
		v_accvgpr_read_b32 v12, a69
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_cndmask_b32_e64 v115, v8, v117, s[82:83]
		v_accvgpr_read_b32 v12, a148
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a149
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v238, v8, v118, s[42:43]
		v_cndmask_b32_e32 v181, v8, v207, vcc
		v_accvgpr_read_b32 v12, a157
		v_cmp_ge_i32_e64 s[42:43], v7, v12
		v_accvgpr_read_b32 v12, a164
		v_cmp_ge_i32_e64 s[52:53], v7, v12
		v_accvgpr_read_b32 v12, a70
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v116, v8, v208, s[42:43]
		v_cndmask_b32_e64 v117, v8, v209, s[52:53]
		v_cndmask_b32_e64 v182, v8, v210, s[54:55]
		v_accvgpr_read_b32 v12, a132
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_accvgpr_read_b32 v12, a150
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a151
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v184, v8, v120, s[42:43]
		v_accvgpr_read_b32 v12, a152
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a153
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v185, v8, v121, s[42:43]
		v_cndmask_b32_e32 v183, v8, v211, vcc
		v_accvgpr_read_b32 v12, a165
		v_cmp_ge_i32_e64 s[42:43], v7, v12
		v_accvgpr_read_b32 v12, a172
		v_cmp_ge_i32_e64 s[52:53], v7, v12
		v_accvgpr_read_b32 v12, a133
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v120, v8, v212, s[42:43]
		v_cndmask_b32_e64 v121, v8, v213, s[52:53]
		v_cndmask_b32_e64 v186, v8, v214, s[54:55]
		v_accvgpr_read_b32 v12, a134
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_accvgpr_read_b32 v12, a154
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a155
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v240, v8, v122, s[42:43]
		v_accvgpr_read_b32 v12, a158
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a159
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v188, v8, v124, s[42:43]
		v_cndmask_b32_e32 v187, v8, v215, vcc
		v_accvgpr_read_b32 v12, a173
		v_cmp_ge_i32_e64 s[42:43], v7, v12
		v_accvgpr_read_b32 v12, a180
		v_cmp_ge_i32_e64 s[52:53], v7, v12
		v_accvgpr_read_b32 v12, a135
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v190, v8, v216, s[42:43]
		v_cndmask_b32_e64 v191, v8, v217, s[52:53]
		v_cndmask_b32_e64 v192, v8, v218, s[54:55]
		v_accvgpr_read_b32 v12, a136
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_accvgpr_read_b32 v12, a160
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a161
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v189, v8, v125, s[42:43]
		v_accvgpr_read_b32 v12, a162
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a163
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v242, v8, v126, s[42:43]
		v_cndmask_b32_e32 v193, v8, v219, vcc
		v_accvgpr_read_b32 v12, a181
		v_cmp_ge_i32_e64 s[42:43], v7, v12
		v_accvgpr_read_b32 v12, a188
		v_cmp_ge_i32_e64 s[52:53], v7, v12
		v_accvgpr_read_b32 v12, a137
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v124, v8, v220, s[42:43]
		v_cndmask_b32_e64 v125, v8, v221, s[52:53]
		v_cndmask_b32_e64 v194, v8, v222, s[54:55]
		v_accvgpr_read_b32 v12, a138
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_accvgpr_read_b32 v12, a166
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a167
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v196, v8, v128, s[42:43]
		v_accvgpr_read_b32 v12, a168
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a169
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v197, v8, v129, s[42:43]
		v_cndmask_b32_e32 v195, v8, v223, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v119
		v_cmp_ge_i32_e64 s[52:53], v7, v123
		v_accvgpr_read_b32 v12, a139
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v118, v8, v160, s[42:43]
		v_cndmask_b32_e64 v119, v8, v161, s[52:53]
		v_cndmask_b32_e64 v122, v8, v162, s[54:55]
		v_accvgpr_read_b32 v12, a140
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_accvgpr_read_b32 v12, a170
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a171
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v244, v8, v130, s[42:43]
		v_accvgpr_read_b32 v12, a174
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a175
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v128, v8, v132, s[42:43]
		v_cndmask_b32_e32 v123, v8, v163, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v127
		v_cmp_ge_i32_e64 s[52:53], v7, v131
		v_accvgpr_read_b32 v12, a141
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v126, v8, v164, s[42:43]
		v_cndmask_b32_e64 v127, v8, v165, s[52:53]
		v_cndmask_b32_e64 v130, v8, v166, s[54:55]
		v_accvgpr_read_b32 v12, a142
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_accvgpr_read_b32 v12, a176
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a177
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v129, v8, v133, s[42:43]
		v_accvgpr_read_b32 v12, a178
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a179
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v246, v8, v134, s[42:43]
		v_cndmask_b32_e32 v131, v8, v167, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v135
		v_cmp_ge_i32_e64 s[52:53], v7, v139
		v_accvgpr_read_b32 v12, a143
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v132, v8, v168, s[42:43]
		v_cndmask_b32_e64 v133, v8, v169, s[52:53]
		v_cndmask_b32_e64 v134, v8, v170, s[54:55]
		v_accvgpr_read_b32 v12, a144
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_accvgpr_read_b32 v12, a182
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a183
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v160, v8, v136, s[42:43]
		v_accvgpr_read_b32 v12, a184
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a185
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v161, v8, v137, s[42:43]
		v_cndmask_b32_e32 v135, v8, v171, vcc
		v_cmp_ge_i32_e64 s[42:43], v7, v141
		v_accvgpr_read_b32 v12, a189
		v_cmp_ge_i32_e64 s[52:53], v7, v12
		v_accvgpr_read_b32 v12, a145
		v_cmp_ge_i32_e64 s[54:55], v7, v12
		v_cndmask_b32_e64 v136, v8, v172, s[42:43]
		v_cndmask_b32_e64 v137, v8, v173, s[52:53]
		v_cndmask_b32_e64 v162, v8, v174, s[54:55]
		v_accvgpr_read_b32 v12, a146
		v_cmp_ge_i32_e64 vcc, v7, v12
		v_accvgpr_read_b32 v12, a186
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a187
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v248, v8, v138, s[42:43]
		v_accvgpr_read_b32 v12, a190
		s_nop 0
		v_readfirstlane_b32 s42, v12
		v_accvgpr_read_b32 v12, a191
		s_nop 0
		v_readfirstlane_b32 s43, v12
		s_nop 1
		v_cndmask_b32_e64 v250, v8, v140, s[42:43]
		v_cndmask_b32_e32 v163, v8, v175, vcc
		v_max3_f32 v12, v254, v255, v224
		v_max3_f32 v22, v158, v159, v228
		v_max3_f32 v138, v18, v19, v230
		v_max3_f32 v139, v24, v25, v234
		v_max3_f32 v140, v28, v29, v236
		v_max3_f32 v141, v114, v115, v238
		v_max3_f32 v164, v184, v185, v240
		v_max3_f32 v165, v188, v189, v242
		v_max3_f32 v166, v196, v197, v244
		v_max3_f32 v167, v128, v129, v246
		v_max3_f32 v168, v160, v161, v248
		v_max3_f32 v169, v250, v251, v252
		v_max3_f32 v170, v142, v143, v144
		v_max3_f32 v171, v146, v147, v148
		v_max3_f32 v172, v150, v151, v152
		v_max3_f32 v173, v154, v155, v156
		v_max3_f32 v12, v12, v225, v22
		v_max3_f32 v22, v138, v231, v139
		v_max3_f32 v138, v140, v237, v141
		v_max3_f32 v139, v164, v241, v165
		v_max3_f32 v140, v166, v245, v167
		v_max3_f32 v141, v168, v249, v169
		v_max3_f32 v164, v170, v145, v171
		v_max3_f32 v165, v172, v153, v173
		v_max3_f32 v12, v12, v229, v22
		v_max3_f32 v22, v138, v239, v139
		v_max3_f32 v138, v140, v247, v141
		v_max3_f32 v139, v164, v149, v165
		v_max3_f32 v12, v12, v235, v22
		v_max3_f32 v22, v138, v253, v139
		v_max3_f32 v12, v12, v243, v22
		v_max_f32_e32 v12, v12, v157
		v_mov_b32_e32 v138, v12
		v_mov_b32_e32 v139, v12
		s_nop 1
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v140, v138, v139
		v_max3_f32 v12, v20, v21, v96
		v_max3_f32 v22, v30, v31, v176
		v_max3_f32 v138, v16, v17, v98
		v_max3_f32 v139, v100, v101, v102
		v_max3_f32 v141, v104, v105, v106
		v_max3_f32 v164, v26, v27, v108
		v_max3_f32 v165, v110, v111, v112
		v_max3_f32 v166, v178, v179, v180
		v_max3_f32 v167, v116, v117, v182
		v_max3_f32 v168, v120, v121, v186
		v_max3_f32 v169, v190, v191, v192
		v_max3_f32 v170, v124, v125, v194
		v_max3_f32 v171, v118, v119, v122
		v_max3_f32 v172, v126, v127, v130
		v_max3_f32 v173, v132, v133, v134
		v_max3_f32 v174, v136, v137, v162
		v_max3_f32 v12, v12, v97, v22
		v_max3_f32 v22, v138, v99, v139
		v_max3_f32 v138, v141, v107, v164
		v_max3_f32 v139, v165, v113, v166
		v_max3_f32 v141, v167, v183, v168
		v_max3_f32 v164, v169, v193, v170
		v_max3_f32 v165, v171, v123, v172
		v_max3_f32 v166, v173, v135, v174
		v_max3_f32 v12, v12, v177, v22
		v_max3_f32 v22, v138, v109, v139
		v_max3_f32 v138, v141, v187, v164
		v_max3_f32 v139, v165, v131, v166
		v_max3_f32 v12, v12, v103, v22
		v_max3_f32 v22, v138, v195, v139
		v_max3_f32 v12, v12, v181, v22
		v_max_f32_e32 v12, v12, v163
		v_mov_b32_e32 v138, v12
		v_mov_b32_e32 v139, v12
		s_nop 1
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v141, v138, v139
		v_pk_mul_f32 v[138:139], v[140:141], v[4:5]
		v_max_f32_e32 v140, v9, v138
		v_max_f32_e32 v141, v13, v139
		v_pk_fma_f32 v[138:139], v[254:255], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[224:225], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[158:159], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[228:229], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[18:19], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[230:231], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[24:25], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[234:235], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[28:29], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[236:237], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[114:115], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[238:239], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[184:185], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[240:241], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[188:189], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[242:243], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[196:197], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[244:245], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[128:129], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[246:247], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[160:161], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[248:249], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[142:143], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[4:5], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[20:21], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[96:97], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[30:31], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[176:177], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[16:17], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[98:99], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[26:27], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[108:109], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[178:179], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[116:117], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[182:183], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[120:121], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[186:187], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[190:191], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[124:125], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[194:195], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[118:119], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[134:135], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[4:5], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v162, v138
		v_exp_f32_e32 v214, v139
		v_exp_f32_e32 v138, v164
		v_exp_f32_e32 v216, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v218, v167
		v_exp_f32_e32 v166, v158
		v_exp_f32_e32 v220, v159
		v_exp_f32_e32 v158, v168
		v_exp_f32_e32 v222, v169
		v_exp_f32_e32 v168, v18
		v_exp_f32_e32 v224, v19
		v_exp_f32_e32 v18, v170
		v_exp_f32_e32 v226, v171
		v_exp_f32_e32 v170, v24
		v_exp_f32_e32 v228, v25
		v_exp_f32_e32 v24, v172
		v_exp_f32_e32 v230, v173
		v_exp_f32_e32 v172, v28
		v_exp_f32_e32 v232, v29
		v_exp_f32_e32 v28, v174
		v_exp_f32_e32 v234, v175
		v_exp_f32_e32 v174, v114
		v_exp_f32_e32 v236, v115
		v_exp_f32_e32 v114, v198
		v_exp_f32_e32 v238, v199
		v_exp_f32_e32 v198, v184
		v_exp_f32_e32 v240, v185
		v_exp_f32_e32 v184, v200
		v_exp_f32_e32 v242, v201
		v_exp_f32_e32 v200, v188
		v_exp_f32_e32 v244, v189
		v_exp_f32_e32 v163, v202
		v_exp_f32_e32 v215, v203
		v_exp_f32_e32 v139, v196
		v_exp_f32_e32 v217, v197
		v_exp_f32_e32 v165, v204
		v_exp_f32_e32 v219, v205
		v_exp_f32_e32 v167, v128
		v_exp_f32_e32 v221, v129
		v_exp_f32_e32 v159, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v169, v160
		v_exp_f32_e32 v225, v161
		v_exp_f32_e32 v19, v208
		v_exp_f32_e32 v227, v209
		v_exp_f32_e32 v171, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v25, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v173, v142
		v_exp_f32_e32 v233, v143
		v_exp_f32_e32 v29, v144
		v_exp_f32_e32 v235, v145
		v_exp_f32_e32 v175, v146
		v_exp_f32_e32 v237, v147
		v_exp_f32_e32 v115, v148
		v_exp_f32_e32 v239, v149
		v_exp_f32_e32 v199, v150
		v_exp_f32_e32 v241, v151
		v_exp_f32_e32 v185, v152
		v_exp_f32_e32 v243, v153
		v_exp_f32_e32 v201, v154
		v_exp_f32_e32 v245, v155
		v_exp_f32_e32 v128, v156
		v_exp_f32_e32 v142, v157
		v_exp_f32_e32 v144, v20
		v_exp_f32_e32 v146, v21
		v_exp_f32_e32 v20, v96
		v_exp_f32_e32 v148, v97
		v_exp_f32_e32 v96, v30
		v_exp_f32_e32 v150, v31
		v_exp_f32_e32 v30, v176
		v_exp_f32_e32 v152, v177
		v_exp_f32_e32 v154, v16
		v_exp_f32_e32 v156, v17
		v_exp_f32_e32 v16, v98
		v_exp_f32_e32 v160, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v176, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v188, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v196, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v202, v107
		v_exp_f32_e32 v106, v26
		v_exp_f32_e32 v204, v27
		v_exp_f32_e32 v26, v108
		v_exp_f32_e32 v206, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v208, v111
		v_exp_f32_e32 v110, v112
		v_exp_f32_e32 v210, v113
		v_exp_f32_e32 v112, v178
		v_exp_f32_e32 v212, v179
		v_exp_f32_e32 v129, v180
		v_exp_f32_e32 v143, v181
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v147, v117
		v_exp_f32_e32 v21, v182
		v_exp_f32_e32 v149, v183
		v_exp_f32_e32 v97, v120
		v_exp_f32_e32 v151, v121
		v_exp_f32_e32 v31, v186
		v_exp_f32_e32 v153, v187
		v_exp_f32_e32 v155, v190
		v_exp_f32_e32 v157, v191
		v_exp_f32_e32 v17, v192
		v_exp_f32_e32 v161, v193
		v_exp_f32_e32 v99, v124
		v_exp_f32_e32 v177, v125
		v_exp_f32_e32 v101, v194
		v_exp_f32_e32 v189, v195
		v_exp_f32_e32 v103, v118
		v_exp_f32_e32 v197, v119
		v_exp_f32_e32 v105, v122
		v_exp_f32_e32 v203, v123
		v_exp_f32_e32 v107, v126
		v_exp_f32_e32 v205, v127
		v_exp_f32_e32 v27, v130
		v_exp_f32_e32 v207, v131
		v_exp_f32_e32 v109, v132
		v_exp_f32_e32 v209, v133
		v_exp_f32_e32 v111, v134
		v_exp_f32_e32 v211, v135
		v_exp_f32_e32 v113, v136
		v_exp_f32_e32 v213, v137
		v_pk_add_f32 v[116:117], v[162:163], v[214:215]
		v_pk_add_f32 v[118:119], v[138:139], v[216:217]
		v_pk_add_f32 v[120:121], v[164:165], v[218:219]
		v_pk_add_f32 v[122:123], v[166:167], v[220:221]
		v_pk_add_f32 v[124:125], v[158:159], v[222:223]
		v_pk_add_f32 v[126:127], v[168:169], v[224:225]
		v_pk_add_f32 v[130:131], v[18:19], v[226:227]
		v_pk_add_f32 v[132:133], v[170:171], v[228:229]
		v_pk_add_f32 v[134:135], v[24:25], v[230:231]
		v_pk_add_f32 v[136:137], v[172:173], v[232:233]
		v_pk_add_f32 v[178:179], v[28:29], v[234:235]
		v_pk_add_f32 v[180:181], v[174:175], v[236:237]
		v_pk_add_f32 v[182:183], v[114:115], v[238:239]
		v_pk_add_f32 v[186:187], v[198:199], v[240:241]
		v_pk_add_f32 v[190:191], v[184:185], v[242:243]
		v_pk_add_f32 v[192:193], v[200:201], v[244:245]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[130:131], v[132:133]
		v_pk_add_f32 v[124:125], v[134:135], v[136:137]
		v_pk_add_f32 v[126:127], v[178:179], v[180:181]
		v_pk_add_f32 v[130:131], v[182:183], v[186:187]
		v_pk_add_f32 v[132:133], v[190:191], v[192:193]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[130:131], v[132:133]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[116:117], v[118:119]
		v_add_f32_e32 v12, v120, v121
		v_accvgpr_read_b32 v22, a71
		ds_bpermute_b32 v116, v22, v12
		v_accvgpr_read_b32 v22, a72
		ds_bpermute_b32 v118, v22, v12
		v_pk_add_f32 v[120:121], v[128:129], v[142:143]
		v_pk_add_f32 v[122:123], v[144:145], v[146:147]
		v_pk_add_f32 v[124:125], v[20:21], v[148:149]
		v_pk_add_f32 v[126:127], v[96:97], v[150:151]
		v_pk_add_f32 v[130:131], v[30:31], v[152:153]
		v_pk_add_f32 v[132:133], v[154:155], v[156:157]
		v_pk_add_f32 v[134:135], v[16:17], v[160:161]
		v_pk_add_f32 v[136:137], v[98:99], v[176:177]
		v_pk_add_f32 v[178:179], v[100:101], v[188:189]
		v_pk_add_f32 v[180:181], v[102:103], v[196:197]
		v_pk_add_f32 v[182:183], v[104:105], v[202:203]
		v_pk_add_f32 v[186:187], v[106:107], v[204:205]
		v_pk_add_f32 v[190:191], v[26:27], v[206:207]
		v_pk_add_f32 v[192:193], v[108:109], v[208:209]
		v_pk_add_f32 v[194:195], v[110:111], v[210:211]
		v_pk_add_f32 v[246:247], v[112:113], v[212:213]
		v_pk_add_f32 v[120:121], v[120:121], v[122:123]
		v_pk_add_f32 v[122:123], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[126:127], v[134:135], v[136:137]
		v_pk_add_f32 v[130:131], v[178:179], v[180:181]
		v_pk_add_f32 v[132:133], v[182:183], v[186:187]
		v_pk_add_f32 v[134:135], v[190:191], v[192:193]
		v_pk_add_f32 v[136:137], v[194:195], v[246:247]
		v_pk_add_f32 v[120:121], v[120:121], v[122:123]
		v_pk_add_f32 v[122:123], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[126:127], v[134:135], v[136:137]
		v_pk_add_f32 v[120:121], v[120:121], v[122:123]
		v_pk_add_f32 v[122:123], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[120:121], v[122:123]
		v_mov_b32_e32 v119, v125
		v_mov_b32_e32 v117, v124
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[120:121], v[116:117], v[118:119]
		v_mov_b32_e32 v116, v121
		v_mov_b32_e32 v117, v121
		s_nop 1
		v_permlane32_swap_b32_e32 v116, v117
		v_add_f32_e32 v119, v116, v117
		v_sub_f32_e32 v9, v9, v140
		v_sub_f32_e32 v12, v13, v141
		v_exp_f32_e32 v116, v9
		v_exp_f32_e32 v122, v12
		v_mov_b32_e32 v117, v116
		v_pk_mul_f32 v[32:33], v[32:33], v[116:117]
		v_pk_mul_f32 v[34:35], v[34:35], v[116:117]
		v_pk_mul_f32 v[36:37], v[36:37], v[116:117]
		v_pk_mul_f32 v[38:39], v[38:39], v[116:117]
		v_pk_mul_f32 v[40:41], v[40:41], v[116:117]
		v_pk_mul_f32 v[42:43], v[42:43], v[116:117]
		v_pk_mul_f32 v[44:45], v[44:45], v[116:117]
		v_pk_mul_f32 v[46:47], v[46:47], v[116:117]
		v_pk_mul_f32 v[48:49], v[48:49], v[116:117]
		v_pk_mul_f32 v[50:51], v[50:51], v[116:117]
		v_pk_mul_f32 v[52:53], v[52:53], v[116:117]
		v_pk_mul_f32 v[54:55], v[54:55], v[116:117]
		v_pk_mul_f32 v[56:57], v[56:57], v[116:117]
		v_pk_mul_f32 v[58:59], v[58:59], v[116:117]
		v_pk_mul_f32 v[60:61], v[60:61], v[116:117]
		v_pk_mul_f32 v[62:63], v[62:63], v[116:117]
		v_mov_b32_e32 v123, v122
		v_pk_mul_f32 v[64:65], v[64:65], v[122:123]
		v_pk_mul_f32 v[66:67], v[66:67], v[122:123]
		v_pk_mul_f32 v[68:69], v[68:69], v[122:123]
		v_pk_mul_f32 v[70:71], v[70:71], v[122:123]
		v_pk_mul_f32 v[72:73], v[72:73], v[122:123]
		v_pk_mul_f32 v[74:75], v[74:75], v[122:123]
		v_pk_mul_f32 v[76:77], v[76:77], v[122:123]
		v_pk_mul_f32 v[78:79], v[78:79], v[122:123]
		v_pk_mul_f32 v[80:81], v[80:81], v[122:123]
		v_pk_mul_f32 v[82:83], v[82:83], v[122:123]
		v_pk_mul_f32 v[84:85], v[84:85], v[122:123]
		v_pk_mul_f32 v[86:87], v[86:87], v[122:123]
		v_pk_mul_f32 v[88:89], v[88:89], v[122:123]
		v_pk_mul_f32 v[90:91], v[90:91], v[122:123]
		v_pk_mul_f32 v[92:93], v[92:93], v[122:123]
		v_pk_mul_f32 v[94:95], v[94:95], v[122:123]
		v_mov_b32_e32 v12, v116
		v_mov_b32_e32 v13, v122
		v_mov_b32_e32 v118, v120
		v_mov_b64_e32 v[116:117], v[14:15]
		v_pk_fma_f32 v[14:15], v[116:117], v[12:13], v[118:119]
		v_cvt_pk_bf16_f32 v116, v162, v214
		v_cvt_pk_bf16_f32 v117, v138, v216
		v_cvt_pk_bf16_f32 v118, v164, v218
		v_cvt_pk_bf16_f32 v119, v166, v220
		v_cvt_pk_bf16_f32 v120, v158, v222
		v_cvt_pk_bf16_f32 v121, v168, v224
		v_cvt_pk_bf16_f32 v122, v18, v226
		v_cvt_pk_bf16_f32 v123, v170, v228
		v_cvt_pk_bf16_f32 v124, v24, v230
		v_cvt_pk_bf16_f32 v125, v172, v232
		v_cvt_pk_bf16_f32 v126, v28, v234
		v_cvt_pk_bf16_f32 v127, v174, v236
		v_cvt_pk_bf16_f32 v132, v114, v238
		v_cvt_pk_bf16_f32 v133, v198, v240
		v_cvt_pk_bf16_f32 v134, v184, v242
		v_cvt_pk_bf16_f32 v135, v200, v244
		v_cvt_pk_bf16_f32 v180, v163, v215
		v_cvt_pk_bf16_f32 v181, v139, v217
		v_cvt_pk_bf16_f32 v182, v165, v219
		v_cvt_pk_bf16_f32 v183, v167, v221
		v_cvt_pk_bf16_f32 v136, v159, v223
		v_cvt_pk_bf16_f32 v137, v169, v225
		v_cvt_pk_bf16_f32 v138, v19, v227
		v_cvt_pk_bf16_f32 v139, v171, v229
		v_cvt_pk_bf16_f32 v164, v25, v231
		v_cvt_pk_bf16_f32 v165, v173, v233
		v_cvt_pk_bf16_f32 v166, v29, v235
		v_cvt_pk_bf16_f32 v167, v175, v237
		v_cvt_pk_bf16_f32 v168, v115, v239
		v_cvt_pk_bf16_f32 v169, v199, v241
		v_cvt_pk_bf16_f32 v170, v185, v243
		v_cvt_pk_bf16_f32 v171, v201, v245
		v_cvt_pk_bf16_f32 v172, v128, v142
		v_cvt_pk_bf16_f32 v173, v144, v146
		v_cvt_pk_bf16_f32 v174, v20, v148
		v_cvt_pk_bf16_f32 v175, v96, v150
		v_cvt_pk_bf16_f32 v184, v30, v152
		v_cvt_pk_bf16_f32 v185, v154, v156
		v_cvt_pk_bf16_f32 v186, v16, v160
		v_cvt_pk_bf16_f32 v187, v98, v176
		v_cvt_pk_bf16_f32 v192, v100, v188
		v_cvt_pk_bf16_f32 v193, v102, v196
		v_cvt_pk_bf16_f32 v194, v104, v202
		v_cvt_pk_bf16_f32 v195, v106, v204
		v_cvt_pk_bf16_f32 v216, v26, v206
		v_cvt_pk_bf16_f32 v217, v108, v208
		v_cvt_pk_bf16_f32 v218, v110, v210
		v_cvt_pk_bf16_f32 v219, v112, v212
		v_cvt_pk_bf16_f32 v220, v129, v143
		v_cvt_pk_bf16_f32 v221, v145, v147
		v_cvt_pk_bf16_f32 v222, v21, v149
		v_cvt_pk_bf16_f32 v223, v97, v151
		v_cvt_pk_bf16_f32 v128, v31, v153
		v_cvt_pk_bf16_f32 v129, v155, v157
		v_cvt_pk_bf16_f32 v130, v17, v161
		v_cvt_pk_bf16_f32 v131, v99, v177
		v_cvt_pk_bf16_f32 v16, v101, v189
		v_cvt_pk_bf16_f32 v17, v103, v197
		v_cvt_pk_bf16_f32 v18, v105, v203
		v_cvt_pk_bf16_f32 v19, v107, v205
		v_cvt_pk_bf16_f32 v28, v27, v207
		v_cvt_pk_bf16_f32 v29, v109, v209
		v_cvt_pk_bf16_f32 v30, v111, v211
		v_cvt_pk_bf16_f32 v31, v113, v213
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[116:119], v[32:47]
		s_add_i32 s19, s44, 0x80
		s_cmp_lt_i32 s19, s25
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[172:175], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[172:175], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[120:123], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[184:187], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[184:187], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[124:127], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[192:195], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[192:195], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[180:183], v[48:63]
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
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[28:31], v[64:79]
		s_mov_b32 s44, s19
		v_mov_b32_e32 v9, v140
		v_mov_b32_e32 v13, v141
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v4, v14
		v_rcp_f32_e32 v6, v15
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
		v_accvgpr_read_b32 v3, a8
		s_nop 0
		v_readfirstlane_b32 s19, v3
		s_mul_i32 s19, s19, s18
		s_lshl_b32 s19, s19, 9
		v_accvgpr_read_b32 v3, a2
		s_nop 0
		v_readfirstlane_b32 s23, v3
		v_mov_b32_e32 v3, s1
		s_nop 0
		v_readfirstlane_b32 s24, v3
		s_mul_i32 s23, s24, s23
		s_lshl_b32 s23, s23, 1
		s_add_i32 s24, s19, s23
		v_accvgpr_read_b32 v3, a3
		s_nop 0
		v_readfirstlane_b32 s25, v3
		v_mov_b32_e32 v3, s22
		s_nop 0
		v_readfirstlane_b32 s26, v3
		s_mul_i32 s25, s26, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s24, s24, s25
		v_accvgpr_read_b32 v3, a9
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v32, v3, 6, s24
		v_accvgpr_read_b32 v33, a12
		v_mul_lo_u32 v33, s18, v33
		v_lshl_add_u32 v32, v33, 1, v32
		v_accvgpr_read_b32 v34, a16
		v_mul_lo_u32 v34, s18, v34
		v_lshl_add_u32 v32, v34, 5, v32
		v_accvgpr_read_b32 v35, a52
		v_mul_lo_u32 v35, s18, v35
		v_lshl_add_u32 v32, v35, 4, v32
		v_accvgpr_read_b32 v36, a13
		v_mul_lo_u32 v36, s18, v36
		v_lshl_add_u32 v32, v36, 3, v32
		v_accvgpr_read_b32 v37, a14
		v_mul_lo_u32 v37, s18, v37
		v_lshl_add_u32 v32, v37, 2, v32
		v_accvgpr_read_b32 v38, a15
		v_lshl_add_u32 v32, v38, 4, v32
		v_accvgpr_read_b32 v38, a54
		s_nop 0
		v_readfirstlane_b32 s26, v38
		v_accvgpr_read_b32 v38, a55
		s_nop 0
		v_readfirstlane_b32 s27, v38
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
		v_lshl_add_u32 v32, v3, 6, s24
		v_lshl_add_u32 v32, v33, 1, v32
		v_lshl_add_u32 v32, v34, 5, v32
		v_lshl_add_u32 v32, v35, 4, v32
		v_lshl_add_u32 v32, v36, 3, v32
		v_lshl_add_u32 v32, v37, 2, v32
		v_accvgpr_read_b32 v38, a15
		v_lshl_add_u32 v32, v38, 4, v32
		v_accvgpr_read_b32 v38, a54
		s_nop 0
		v_readfirstlane_b32 s26, v38
		v_accvgpr_read_b32 v38, a55
		s_nop 0
		v_readfirstlane_b32 s27, v38
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
		v_lshl_add_u32 v8, v3, 6, s24
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v8, v9, 4, v8
		v_accvgpr_read_b32 v9, a54
		s_nop 0
		v_readfirstlane_b32 s26, v9
		v_accvgpr_read_b32 v9, a55
		s_nop 0
		v_readfirstlane_b32 s27, v9
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
		v_lshl_add_u32 v8, v3, 6, s24
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v8, v9, 4, v8
		v_accvgpr_read_b32 v9, a54
		s_nop 0
		v_readfirstlane_b32 s26, v9
		v_accvgpr_read_b32 v9, a55
		s_nop 0
		v_readfirstlane_b32 s27, v9
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
		v_lshl_add_u32 v8, v3, 6, s26
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v8, v9, 4, v8
		v_accvgpr_read_b32 v9, a56
		s_nop 0
		v_readfirstlane_b32 s26, v9
		v_accvgpr_read_b32 v9, a57
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
		v_lshl_add_u32 v8, v3, 6, s26
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v8, v9, 4, v8
		v_accvgpr_read_b32 v9, a56
		s_nop 0
		v_readfirstlane_b32 s26, v9
		v_accvgpr_read_b32 v9, a57
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
		v_lshl_add_u32 v4, v3, 6, s26
		v_lshl_add_u32 v4, v33, 1, v4
		v_lshl_add_u32 v4, v34, 5, v4
		v_lshl_add_u32 v4, v35, 4, v4
		v_lshl_add_u32 v4, v36, 3, v4
		v_lshl_add_u32 v4, v37, 2, v4
		v_accvgpr_read_b32 v5, a15
		v_lshl_add_u32 v4, v5, 4, v4
		v_accvgpr_read_b32 v5, a56
		s_nop 0
		v_readfirstlane_b32 s26, v5
		v_accvgpr_read_b32 v5, a57
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
		v_lshl_add_u32 v3, v3, 6, s19
		v_lshl_add_u32 v3, v33, 1, v3
		v_lshl_add_u32 v3, v34, 5, v3
		v_lshl_add_u32 v3, v35, 4, v3
		v_lshl_add_u32 v3, v36, 3, v3
		v_lshl_add_u32 v3, v37, 2, v3
		v_accvgpr_read_b32 v4, a15
		v_lshl_add_u32 v3, v4, 4, v3
		v_accvgpr_read_b32 v4, a56
		s_nop 0
		v_readfirstlane_b32 s24, v4
		v_accvgpr_read_b32 v4, a57
		s_nop 0
		v_readfirstlane_b32 s25, v4
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v3, s[28:31], 0 offen
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
		v_mov_b32_e32 v3, s19
		v_accvgpr_write_b32 a8, v3
		v_accvgpr_read_b32 v3, a8
		s_nop 0
		v_readfirstlane_b32 s19, v3
		s_mul_i32 s19, s19, 0x100
		v_and_b32_e32 v3, 1, v0
		v_lshrrev_b32_e32 v4, 1, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 2
		v_mul_lo_u32 v6, v6, v5
		v_lshrrev_b32_e32 v5, 2, v0
		v_and_b32_e32 v7, 1, v5
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v7
		v_bitop3_b32 v7, v3, v6, v8 bitop3:0x96
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
		v_accvgpr_write_b32 a9, v15
		v_accvgpr_read_b32 v15, a9
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 32
		v_mul_lo_u32 v16, v16, v15
		v_bitop3_b32 v7, v7, v14, v16 bitop3:0x96
		v_lshrrev_b32_e32 v17, 7, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v17
		v_xor_b32_e32 v7, v7, v18
		v_accvgpr_write_b32 a10, v7
		v_xor_b32_e32 v3, 0x80, v3
		v_xor_b32_e32 v3, v3, v6
		v_xor_b32_e32 v3, v3, v8
		v_bitop3_b32 v3, v3, v11, v14 bitop3:0x96
		v_bitop3_b32 v3, v3, v16, v18 bitop3:0x96
		v_accvgpr_write_b32 a11, v3
		v_mov_b32_e32 v3, 2
		v_mul_lo_u32 v3, v3, v13
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v7, 1, v6
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v7
		v_bitop3_b32 v11, v10, v3, v8 bitop3:0x96
		v_mov_b32_e32 v14, 8
		v_mul_lo_u32 v14, v14, v15
		v_xor_b32_e32 v11, v11, v14
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v17
		v_xad_u32 v11, v11, v16, s19
		v_bitop3_b32 v18, 32, v10, v3 bitop3:0x96
		v_bitop3_b32 v18, v18, v8, v14 bitop3:0x96
		v_xad_u32 v18, v18, v16, s19
		v_bitop3_b32 v19, 64, v10, v3 bitop3:0x96
		v_bitop3_b32 v19, v19, v8, v14 bitop3:0x96
		v_xad_u32 v19, v19, v16, s19
		v_xor_b32_e32 v20, 0x60, v10
		v_xor_b32_e32 v20, v20, v3
		v_xor_b32_e32 v20, v20, v8
		v_xor_b32_e32 v20, v20, v14
		v_xad_u32 v20, v20, v16, s19
		v_xor_b32_e32 v21, 0x80, v10
		v_xor_b32_e32 v21, v21, v3
		v_xor_b32_e32 v21, v21, v8
		v_xor_b32_e32 v21, v21, v14
		v_xad_u32 v21, v21, v16, s19
		v_xor_b32_e32 v22, 0xa0, v10
		v_xor_b32_e32 v22, v22, v3
		v_xor_b32_e32 v22, v22, v8
		v_xor_b32_e32 v22, v22, v14
		v_xad_u32 v22, v22, v16, s19
		v_xor_b32_e32 v23, 0xc0, v10
		v_xor_b32_e32 v23, v23, v3
		v_xor_b32_e32 v23, v23, v8
		v_xor_b32_e32 v23, v23, v14
		v_xad_u32 v23, v23, v16, s19
		v_xor_b32_e32 v24, 0xe0, v10
		v_xor_b32_e32 v3, v24, v3
		v_xor_b32_e32 v3, v3, v8
		v_xor_b32_e32 v3, v3, v14
		v_xad_u32 v3, v3, v16, s19
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v14, a4
		v_and_b32_e32 v14, 0xffff, v14
		v_lshlrev_b32_e32 v16, 16, v14
		v_or_b32_e32 v24, v14, v16
		v_mov_b32_e32 v25, v24
		v_mov_b32_e32 v26, v24
		v_mov_b32_e32 v27, v24
		v_accvgpr_read_b32 v14, a8
		s_nop 0
		v_readfirstlane_b32 s23, v14
		s_mul_i32 s23, s23, s12
		s_lshl_b32 s23, s23, 9
		v_mov_b32_e32 v14, s1
		v_accvgpr_write_b32 a12, v14
		v_accvgpr_read_b32 v14, a12
		s_nop 0
		v_readfirstlane_b32 s1, v14
		s_mul_i32 s1, s1, s10
		s_lshl_b32 s1, s1, 1
		s_add_i32 s28, s23, s1
		v_mov_b32_e32 v14, s22
		v_accvgpr_write_b32 a13, v14
		v_accvgpr_read_b32 v14, a13
		s_nop 0
		v_readfirstlane_b32 s22, v14
		s_mul_i32 s22, s22, s11
		s_lshl_b32 s22, s22, 1
		s_add_i32 s28, s28, s22
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
		s_add_i32 s28, s28, s22
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
		s_add_i32 s28, s28, s22
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
		s_add_i32 s28, s28, s22
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
		s_add_i32 s28, s28, s22
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
		s_add_i32 s28, s28, s22
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
		s_add_i32 s28, s28, s22
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
		s_add_i32 s1, s1, s22
		v_lshl_add_u32 v4, v14, 1, s1
		v_accvgpr_read_b32 v11, a14
		v_lshl_add_u32 v4, v11, 4, v4
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v4, v11, 6, v4
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v4, v11, 5, v4
		v_cmp_lt_i32_e64 vcc, v3, s20
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
		v_accvgpr_read_b32 v3, a9
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 2, v3
		v_and_b32_e32 v4, 1, v6
		v_accvgpr_write_b32 a17, v4
		v_accvgpr_read_b32 v4, a17
		v_lshlrev_b32_e32 v4, 1, v4
		v_and_b32_e32 v6, 1, v12
		v_accvgpr_write_b32 a18, v6
		v_accvgpr_read_b32 v6, a18
		v_xor_b32_e32 v6, v0, v6
		v_bitop3_b32 v3, v3, v4, v6 bitop3:0x96
		v_lshlrev_b32_e32 v3, 4, v3
		v_add_u32_e32 v3, 0x10000, v3
		ds_write_b128 v3, v[28:31] offset:18864
		ds_write_b128 v3, v[32:35] offset:22960
		ds_write_b128 v3, v[36:39] offset:27056
		ds_write_b128 v3, v[40:43] offset:31152
		v_accvgpr_read_b32 v4, a9
		v_lshlrev_b32_e32 v4, 12, v4
		v_add_u32_e32 v4, 0x10000, v4
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v11, 3, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v12, 6, v11
		v_add_u32_e32 v14, v4, v12
		v_lshrrev_b32_e32 v16, 2, v6
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v18, 5, v16
		v_add_u32_e32 v19, v14, v18
		v_lshrrev_b32_e32 v24, 5, v6
		v_accvgpr_write_b32 a19, v24
		v_lshrrev_b32_e32 v24, 4, v6
		v_and_b32_e32 v24, 1, v24
		v_lshlrev_b32_e32 v24, 7, v24
		v_lshrrev_b32_e32 v25, 1, v6
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v26, 4, v25
		v_and_b32_e32 v27, 1, v6
		v_lshlrev_b32_e32 v27, 3, v27
		v_accvgpr_read_b32 v28, a19
		v_add3_u32 v28, v28, v24, v12
		v_add3_u32 v28, v28, v18, v26
		v_add_u32_e32 v29, v27, v28
		v_xor_b32_e32 v29, v29, v25
		v_lshl_add_u32 v19, v29, 4, v19
		ds_read_b128 a[20:23], v19 offset:18864
		v_lshlrev_b32_e32 v16, 1, v16
		v_add3_u32 v29, v27, v28, 2
		v_bitop3_b32 v29, v16, v29, v25 bitop3:0x96
		v_lshl_add_u32 v14, v29, 4, v14
		ds_read_b128 a[24:27], v14 offset:18864
		v_add3_u32 v28, v27, v28, 4
		v_xad_u32 v28, v28, v25, v16
		v_lshlrev_b32_e32 v11, 2, v11
		v_xor_b32_e32 v28, v28, v11
		v_lshl_add_u32 v28, v28, 4, v4
		ds_read_b128 a[28:31], v28 offset:18864
		v_accvgpr_read_b32 v29, a19
		v_add3_u32 v24, 6, v29, v24
		v_add3_u32 v12, v24, v12, v18
		v_add3_u32 v12, v12, v26, v27
		v_xor_b32_e32 v12, v12, v25
		v_bitop3_b32 v11, v11, v16, v12 bitop3:0x96
		v_lshl_add_u32 v4, v11, 4, v4
		ds_read_b128 a[32:35], v4 offset:18864
		v_accvgpr_read_b32 v11, a8
		s_nop 0
		v_readfirstlane_b32 s1, v11
		s_add_i32 s1, s1, 1
		s_mul_i32 s1, s1, 0x100
		s_mov_b32 s22, 0x7f
		v_mov_b32_e32 v11, 64
		v_mul_lo_u32 v11, v11, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[44:47] offset:18864
		ds_write_b128 v3, v[48:51] offset:22960
		ds_write_b128 v3, v[20:23] offset:27056
		ds_write_b128 v3, v[52:55] offset:31152
		v_mov_b32_e32 v3, 32
		v_mul_lo_u32 v3, v3, v13
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v19 offset:18864
		ds_read_b128 a[40:43], v14 offset:18864
		ds_read_b128 a[44:47], v28 offset:18864
		ds_read_b128 a[48:51], v4 offset:18864
		v_accvgpr_write_b32 a52, v2
		v_accvgpr_read_b32 v4, a52
		s_nop 0
		v_readfirstlane_b32 s23, v4
		s_add_i32 s1, s1, s23
		s_cmp_lt_i32 s21, s1
		s_cselect_b32 s1, s21, s1
		s_add_i32 s23, s1, 0x7f
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s24, s22, 0
		s_add_i32 s23, s23, s24
		s_ashr_i32 s23, s23, 7
		v_accvgpr_read_b32 v4, a52
		s_nop 0
		v_readfirstlane_b32 s24, v4
		s_add_i32 s24, s19, s24
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s25, s22, 0
		s_add_i32 s24, s24, s25
		s_ashr_i32 s24, s24, 7
		s_cmp_lt_i32 s24, s23
		s_cselect_b32 s24, s24, s23
		s_cmp_gt_i32 s24, 0
		s_cselect_b32 s24, s24, 0
		v_bitop3_b32 v4, v11, v3, v12 bitop3:0x96
		v_mov_b32_e32 v13, 2
		v_mul_lo_u32 v13, v13, v17
		v_bitop3_b32 v4, v4, v15, v13 bitop3:0x96
		v_accvgpr_write_b32 a53, v4
		v_bitop3_b32 v4, 4, v11, v3 bitop3:0x96
		v_bitop3_b32 v14, 8, v11, v3 bitop3:0x96
		v_bitop3_b32 v11, 12, v11, v3 bitop3:0x96
		v_accvgpr_read_b32 v16, a53
		v_cmp_lt_i32_e64 s[36:37], v16, s21
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v10
		v_mov_b32_e32 v10, 64
		v_mul_lo_u32 v10, v10, v7
		v_bitop3_b32 v7, v16, v3, v10 bitop3:0x96
		v_bitop3_b32 v7, v7, v15, v13 bitop3:0x96
		v_accvgpr_write_b32 a54, v7
		v_bitop3_b32 v7, 4, v16, v3 bitop3:0x96
		v_bitop3_b32 v17, 8, v16, v3 bitop3:0x96
		v_bitop3_b32 v3, 12, v16, v3 bitop3:0x96
		v_accvgpr_read_b32 v16, a54
		v_cmp_lt_i32_e64 vcc, v16, s21
		v_readfirstlane_b32 s38, v0
		v_accvgpr_read_b32 v16, a9
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
		v_accvgpr_read_b32 v20, a12
		s_nop 0
		v_readfirstlane_b32 s25, v20
		s_mul_i32 s25, s25, s13
		s_lshl_b32 s25, s25, 1
		v_accvgpr_read_b32 v20, a13
		s_nop 0
		v_readfirstlane_b32 s39, v20
		s_mul_i32 s39, s39, s14
		s_lshl_b32 s39, s39, 1
		s_add_i32 s40, s25, s39
		v_add_u32_e32 v20, s40, v9
		v_mov_b32_e32 v21, 0x80000000
		v_cndmask_b32_e64 v20, v21, v20, s[36:37]
		s_lshr_b32 s40, s38, 6
		s_mul_i32 s41, 0x410, s40
		s_mov_b32 m0, s41
		v_accvgpr_read_b32 v22, a10
		v_add_u32_e32 v22, s19, v22
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v22, s20
		s_lshl_b32 s44, s15, 3
		s_add_i32 s44, s44, s25
		s_add_i32 s44, s44, s39
		v_add_u32_e32 v20, s44, v9
		v_cndmask_b32_e64 v20, v21, v20, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v22, a11
		v_add_u32_e32 v22, s19, v22
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v22, s20
		s_lshl_b32 s46, s15, 4
		s_add_i32 s46, s46, s25
		s_add_i32 s46, s46, s39
		v_add_u32_e32 v20, s46, v9
		v_cndmask_b32_e64 v20, v21, v20, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v4, v4, v12
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v4, v4, v15, v13 bitop3:0x96
		v_accvgpr_write_b32 a56, v4
		s_mul_i32 s46, 24, s15
		s_add_i32 s46, s46, s25
		s_add_i32 s46, s46, s39
		v_add_u32_e32 v4, s46, v9
		v_cndmask_b32_e64 v4, v21, v4, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v14, v14, v12
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_bitop3_b32 v4, v14, v15, v13 bitop3:0x96
		v_accvgpr_write_b32 a57, v4
		v_accvgpr_read_b32 v4, a9
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
		v_accvgpr_read_b32 v14, a12
		s_nop 0
		v_readfirstlane_b32 s37, v14
		s_mul_i32 s36, s37, s36
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v14, a1
		s_nop 0
		v_readfirstlane_b32 s37, v14
		v_accvgpr_read_b32 v14, a13
		s_nop 0
		v_readfirstlane_b32 s46, v14
		s_mul_i32 s37, s46, s37
		s_lshl_b32 s37, s37, 1
		s_add_i32 s46, s36, s37
		v_add_u32_e32 v14, s46, v4
		v_cndmask_b32_e32 v14, v21, v14, vcc
		s_mul_i32 s40, 0x440, s40
		s_add_i32 m0, s40, 0x81f0
		v_xor_b32_e32 v11, v11, v12
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_bitop3_b32 v11, v11, v15, v13 bitop3:0x96
		v_accvgpr_write_b32 a58, v11
		s_lshl_b32 s46, s17, 3
		s_add_i32 s46, s46, s36
		s_add_i32 s46, s46, s37
		v_add_u32_e32 v11, s46, v4
		v_cndmask_b32_e32 v11, v21, v11, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v7, v7, v10
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_bitop3_b32 v7, v7, v15, v13 bitop3:0x96
		v_accvgpr_write_b32 a59, v7
		s_lshl_b32 s46, s17, 4
		s_add_i32 s46, s46, s36
		s_add_i32 s46, s46, s37
		v_add_u32_e32 v7, s46, v4
		v_cndmask_b32_e32 v7, v21, v7, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v11, v17, v10
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		v_bitop3_b32 v7, v11, v15, v13 bitop3:0x96
		v_accvgpr_write_b32 a60, v7
		s_mul_i32 s46, 24, s17
		s_add_i32 s46, s46, s36
		s_add_i32 s46, s46, s37
		v_add_u32_e32 v7, s46, v4
		v_cndmask_b32_e32 v7, v21, v7, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v3, v3, v10
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v3, v15, v13 bitop3:0x96
		v_accvgpr_write_b32 a61, v3
		s_mul_i32 s46, s24, 0x80
		v_mbcnt_lo_u32_b32 v3, -1, 0
		v_mbcnt_hi_u32_b32 v3, -1, v3
		v_and_b32_e32 v7, 1, v3
		v_lshrrev_b32_e32 v10, 4, v3
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 4, v10
		v_lshrrev_b32_e32 v11, 3, v3
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 3, v11
		v_add3_u32 v12, v7, v10, v11
		v_lshrrev_b32_e32 v13, 2, v3
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshrrev_b32_e32 v3, 1, v3
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add3_u32 v12, v12, v13, v3
		v_add_u32_e32 v7, 32, v7
		v_bitop3_b32 v3, v13, v7, v3 bitop3:0x96
		v_bitop3_b32 v3, v10, v11, v3 bitop3:0x96
		v_mov_b32_e32 v10, 0x3e38aa3b
		v_mov_b32_e32 v11, 0x3e38aa3b
		s_mov_b32 s24, 0xff800000
		v_mov_b32_e32 v7, s24
		v_mov_b32_e32 v13, s24
		s_mov_b32 s24, 1.0
		v_mov_b32_e32 v14, s24
		v_mov_b32_e32 v15, s24
		s_mov_b32 s24, 0
		v_accvgpr_read_b32 v16, a19
		v_lshlrev_b32_e32 v16, 4, v16
		v_accvgpr_write_b32 a62, v16
		v_and_b32_e32 v6, 31, v6
		v_lshrrev_b32_e32 v16, 4, v6
		v_lshlrev_b32_e32 v16, 9, v16
		v_lshrrev_b32_e32 v17, 3, v6
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 0x2080
		v_mul_lo_u32 v18, v18, v17
		v_accvgpr_write_b32 a63, v18
		v_lshrrev_b32_e32 v17, 2, v6
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 0x1040
		v_mul_lo_u32 v18, v18, v17
		v_accvgpr_write_b32 a64, v18
		v_lshrrev_b32_e32 v17, 1, v6
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 0x820
		v_mul_lo_u32 v18, v18, v17
		v_accvgpr_write_b32 a65, v18
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v17, 0x410
		v_mul_lo_u32 v17, v17, v6
		v_accvgpr_write_b32 a66, v17
		v_and_b32_e32 v6, 3, v0
		v_accvgpr_write_b32 a67, v6
		v_accvgpr_read_b32 v6, a67
		v_lshlrev_b32_e32 v6, 3, v6
		v_accvgpr_write_b32 a68, v6
		v_accvgpr_read_b32 v6, a17
		v_mov_b32_e32 v17, 0x2200
		v_mul_lo_u32 v17, v17, v6
		v_accvgpr_write_b32 a69, v17
		v_accvgpr_read_b32 v6, a18
		v_lshlrev_b32_e32 v6, 5, v6
		v_accvgpr_write_b32 a70, v6
		v_and_b32_e32 v5, 3, v5
		v_mov_b32_e32 v6, 0x440
		v_mul_lo_u32 v6, v6, v5
		v_accvgpr_write_b32 a71, v6
		s_lshl_b32 s47, s15, 8
		s_add_i32 s47, s47, s25
		s_add_i32 s47, s47, s39
		s_mul_i32 s48, 0x108, s15
		s_add_i32 s48, s48, s25
		s_add_i32 s48, s48, s39
		s_mul_i32 s49, 0x110, s15
		s_add_i32 s49, s49, s25
		s_add_i32 s49, s49, s39
		s_mul_i32 s50, 0x118, s15
		s_add_i32 s25, s50, s25
		s_add_i32 s25, s25, s39
		s_lshl_b32 s39, s17, 8
		s_add_i32 s39, s39, s36
		s_add_i32 s50, s39, s37
		s_mul_i32 s39, 0x108, s17
		s_add_i32 s39, s39, s36
		s_add_i32 s51, s39, s37
		s_mul_i32 s39, 0x110, s17
		s_add_i32 s39, s39, s36
		s_add_i32 s52, s39, s37
		s_mul_i32 s39, 0x118, s17
		s_add_i32 s36, s39, s36
		s_add_i32 s36, s36, s37
		v_lshlrev_b32_e32 v5, 2, v12
		v_accvgpr_write_b32 a72, v5
		v_lshlrev_b32_e32 v3, 2, v3
		v_accvgpr_write_b32 a73, v3
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_3
.L_attn_fwd_persistent.loop_head_3:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s37, s24, 7
		s_and_b32 s39, s37, 1
		s_mul_i32 s53, 0x4100, s39
		v_accvgpr_read_b32 v3, a62
		v_add3_u32 v3, s53, v3, v16
		v_accvgpr_read_b32 v5, a63
		v_accvgpr_read_b32 v6, a64
		v_add3_u32 v3, v3, v5, v6
		v_accvgpr_read_b32 v5, a65
		v_accvgpr_read_b32 v6, a66
		v_add3_u32 v3, v3, v5, v6
		ds_read_b128 v[24:27], v3
		ds_read_b128 a[76:79], v3 offset:32
		ds_read_b128 a[80:83], v3 offset:64
		ds_read_b128 a[84:87], v3 offset:96
		ds_read_b128 v[28:31], v3 offset:256
		ds_read_b128 a[88:91], v3 offset:288
		ds_read_b128 a[92:95], v3 offset:320
		ds_read_b128 a[96:99], v3 offset:352
		ds_read_b128 a[100:103], v3 offset:128
		ds_read_b128 a[104:107], v3 offset:160
		ds_read_b128 a[108:111], v3 offset:192
		ds_read_b128 a[112:115], v3 offset:224
		ds_read_b128 v[96:99], v3 offset:384
		ds_read_b128 a[116:119], v3 offset:416
		ds_read_b128 a[120:123], v3 offset:448
		ds_read_b128 a[124:127], v3 offset:480
		s_mul_i32 s39, 0x4400, s39
		v_accvgpr_read_b32 v3, a68
		v_accvgpr_read_b32 v5, a69
		v_add3_u32 v3, s39, v3, v5
		v_accvgpr_read_b32 v5, a70
		v_accvgpr_read_b32 v6, a71
		v_add3_u32 v3, v3, v5, v6
		ds_read_b64_tr_b16 a[128:129], v3 offset:33264
		ds_read_b64_tr_b16 a[130:131], v3 offset:37616
		ds_read_b64_tr_b16 a[132:133], v3 offset:33392
		ds_read_b64_tr_b16 a[134:135], v3 offset:37744
		ds_read_b64_tr_b16 a[136:137], v3 offset:33520
		ds_read_b64_tr_b16 a[138:139], v3 offset:37872
		ds_read_b64_tr_b16 a[140:141], v3 offset:33648
		ds_read_b64_tr_b16 a[142:143], v3 offset:38000
		ds_read_b64_tr_b16 a[144:145], v3 offset:33776
		ds_read_b64_tr_b16 a[146:147], v3 offset:38128
		ds_read_b64_tr_b16 a[148:149], v3 offset:33904
		ds_read_b64_tr_b16 a[150:151], v3 offset:38256
		ds_read_b64_tr_b16 a[152:153], v3 offset:34032
		ds_read_b64_tr_b16 a[154:155], v3 offset:38384
		ds_read_b64_tr_b16 a[156:157], v3 offset:34160
		ds_read_b64_tr_b16 a[158:159], v3 offset:38512
		ds_read_b64_tr_b16 a[160:161], v3 offset:33328
		ds_read_b64_tr_b16 a[162:163], v3 offset:37680
		ds_read_b64_tr_b16 a[164:165], v3 offset:33456
		ds_read_b64_tr_b16 a[166:167], v3 offset:37808
		ds_read_b64_tr_b16 a[168:169], v3 offset:33584
		ds_read_b64_tr_b16 a[170:171], v3 offset:37936
		ds_read_b64_tr_b16 a[172:173], v3 offset:33712
		ds_read_b64_tr_b16 a[174:175], v3 offset:38064
		ds_read_b64_tr_b16 a[176:177], v3 offset:33840
		ds_read_b64_tr_b16 a[178:179], v3 offset:38192
		ds_read_b64_tr_b16 a[180:181], v3 offset:33968
		ds_read_b64_tr_b16 a[182:183], v3 offset:38320
		ds_read_b64_tr_b16 a[184:185], v3 offset:34096
		ds_read_b64_tr_b16 a[186:187], v3 offset:38448
		ds_read_b64_tr_b16 a[188:189], v3 offset:34224
		ds_read_b64_tr_b16 a[190:191], v3 offset:38576
		s_mul_i32 s39, s15, s24
		s_lshl_b32 s39, s39, 1
		s_add_i32 s53, s47, s39
		v_add_u32_e32 v3, s53, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v5, s39, v9
		s_add_i32 s37, s37, 1
		v_add_u32_e32 v6, s48, v5
		s_and_b32 s37, s37, 1
		v_add_u32_e32 v12, s49, v5
		s_mul_i32 s39, 0x4100, s37
		v_add_u32_e32 v5, s25, v5
		s_add_i32 s39, s41, s39
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[20:23], 0
		s_mov_b32 m0, s39
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[20:23], 0
		s_mul_i32 s39, s17, s24
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[20:23], 0
		s_add_i32 s24, s24, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[20:23], 0
		v_accvgpr_read_b32 v17, a53
		v_add_u32_e32 v17, s24, v17
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[36:39], 0
		v_accvgpr_read_b32 v18, a56
		v_add_u32_e32 v18, s24, v18
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[36:39], 0
		v_accvgpr_read_b32 v19, a57
		v_add_u32_e32 v19, s24, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[28:31], a[36:39], 0
		v_accvgpr_read_b32 v20, a58
		v_add_u32_e32 v20, s24, v20
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[36:39], 0
		v_cmp_lt_i32_e64 s[54:55], v17, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[24:27], v[112:127]
		v_accvgpr_read_b32 v17, a54
		v_add_u32_e32 v17, s24, v17
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[24:27], v[128:143]
		v_accvgpr_read_b32 v22, a59
		v_add_u32_e32 v22, s24, v22
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[24:27], v[144:159]
		v_accvgpr_read_b32 v23, a60
		v_add_u32_e32 v23, s24, v23
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[24:27], v[160:175]
		v_cmp_lt_i32_e64 s[56:57], v17, s21
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[40:43], v[176:191]
		v_cndmask_b32_e64 v3, v21, v3, s[54:55]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[96:111], a[76:79], a[40:43], v[96:111]
		v_cmp_lt_i32_e64 s[54:55], v18, s21
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[40:43], v[192:207]
		s_nop 0
		v_cndmask_b32_e64 v3, v21, v6, s[54:55]
		v_cmp_lt_i32_e64 s[54:55], v19, s21
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		v_cndmask_b32_e64 v6, v21, v12, s[54:55]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v20, s21
		s_nop 1
		v_cndmask_b32_e64 v3, v21, v5, s[54:55]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v5, a61
		v_add_u32_e32 v5, s24, v5
		s_lshl_b32 s39, s39, 1
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 s53, s50, s39
		v_add_u32_e32 v6, s53, v4
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v6, v21, v6, s[56:57]
		s_mul_i32 s37, 0x4400, s37
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v22, s21
		s_add_i32 s37, s40, s37
		v_add_u32_e32 v3, s39, v4
		s_add_i32 m0, s37, 0x81f0
		v_add_u32_e32 v12, s51, v3
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[40:43], v[208:223]
		v_cndmask_b32_e64 v6, v21, v12, s[54:55]
		v_cmp_lt_i32_e64 s[54:55], v23, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v12, s52, v3
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v6, v21, v12, s[54:55]
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v3, s36, v3
		v_cndmask_b32_e32 v3, v21, v3, vcc
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[28:31], v[112:127]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s24, s46
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[28:31], v[128:143]
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[120:123], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], a[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[92:95], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[108:111], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[112:115], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[124:127], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[48:51], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[96:99], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[48:51], v[208:223]
		s_nop 4
		v_max3_f32 v3, v112, v113, v114
		v_max3_f32 v5, v116, v117, v118
		v_max3_f32 v6, v120, v121, v122
		v_max3_f32 v12, v124, v125, v126
		v_max3_f32 v17, v128, v129, v130
		v_max3_f32 v18, v132, v133, v134
		v_max3_f32 v19, v136, v137, v138
		v_max3_f32 v20, v140, v141, v142
		v_max3_f32 v22, v144, v145, v146
		v_max3_f32 v23, v148, v149, v150
		v_max3_f32 v24, v152, v153, v154
		v_max3_f32 v25, v156, v157, v158
		v_max3_f32 v26, v160, v161, v162
		v_max3_f32 v27, v164, v165, v166
		v_max3_f32 v28, v168, v169, v170
		v_max3_f32 v29, v172, v173, v174
		v_max3_f32 v3, v3, v115, v5
		v_max3_f32 v5, v6, v123, v12
		v_max3_f32 v6, v17, v131, v18
		v_max3_f32 v12, v19, v139, v20
		v_max3_f32 v17, v22, v147, v23
		v_max3_f32 v18, v24, v155, v25
		v_max3_f32 v19, v26, v163, v27
		v_max3_f32 v20, v28, v171, v29
		v_max3_f32 v3, v3, v119, v5
		v_max3_f32 v5, v6, v135, v12
		v_max3_f32 v6, v17, v151, v18
		v_max3_f32 v12, v19, v167, v20
		v_max3_f32 v3, v3, v127, v5
		v_max3_f32 v5, v6, v159, v12
		v_max3_f32 v3, v3, v143, v5
		v_max_f32_e32 v3, v3, v175
		v_mov_b32_e32 v18, v3
		v_mov_b32_e32 v19, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v22, v18, v19
		v_max3_f32 v3, v96, v97, v98
		v_max3_f32 v5, v100, v101, v102
		v_max3_f32 v6, v104, v105, v106
		v_max3_f32 v12, v108, v109, v110
		v_max3_f32 v17, v192, v193, v194
		v_max3_f32 v18, v196, v197, v198
		v_max3_f32 v19, v200, v201, v202
		v_max3_f32 v20, v204, v205, v206
		v_max3_f32 v23, v208, v209, v210
		v_max3_f32 v24, v212, v213, v214
		v_max3_f32 v25, v216, v217, v218
		v_max3_f32 v26, v220, v221, v222
		v_max3_f32 v27, v176, v177, v178
		v_max3_f32 v28, v180, v181, v182
		v_max3_f32 v29, v184, v185, v186
		v_max3_f32 v30, v188, v189, v190
		v_max3_f32 v3, v3, v99, v5
		v_max3_f32 v5, v6, v107, v12
		v_max3_f32 v6, v17, v195, v18
		v_max3_f32 v12, v19, v203, v20
		v_max3_f32 v17, v23, v211, v24
		v_max3_f32 v18, v25, v219, v26
		v_max3_f32 v19, v27, v179, v28
		v_max3_f32 v20, v29, v187, v30
		v_max3_f32 v3, v3, v103, v5
		v_max3_f32 v5, v6, v199, v12
		v_max3_f32 v6, v17, v215, v18
		v_max3_f32 v12, v19, v183, v20
		v_max3_f32 v3, v3, v111, v5
		v_max3_f32 v5, v6, v223, v12
		v_max3_f32 v3, v3, v207, v5
		v_max_f32_e32 v3, v3, v191
		v_mov_b32_e32 v18, v3
		v_mov_b32_e32 v19, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v23, v18, v19
		v_pk_mul_f32 v[18:19], v[22:23], v[10:11]
		v_max_f32_e32 v22, v7, v18
		v_max_f32_e32 v23, v13, v19
		v_pk_fma_f32 v[18:19], v[112:113], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[114:115], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[116:117], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[118:119], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[120:121], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[122:123], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[124:125], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[126:127], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[128:129], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[130:131], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[132:133], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[134:135], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[136:137], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[138:139], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[140:141], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[142:143], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[144:145], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[146:147], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[148:149], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[150:151], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[152:153], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[154:155], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[156:157], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[158:159], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[160:161], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[162:163], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[164:165], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[166:167], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[168:169], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[170:171], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[172:173], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[174:175], v[10:11], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[96:97], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[192:193], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[194:195], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[196:197], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[198:199], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[200:201], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[202:203], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[204:205], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[206:207], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[208:209], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[210:211], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[212:213], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[214:215], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[216:217], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[218:219], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[220:221], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[222:223], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[176:177], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[10:11], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v18
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
		v_exp_f32_e32 v191, v134
		v_exp_f32_e32 v217, v135
		v_exp_f32_e32 v19, v136
		v_exp_f32_e32 v219, v137
		v_exp_f32_e32 v25, v138
		v_exp_f32_e32 v221, v139
		v_exp_f32_e32 v27, v140
		v_exp_f32_e32 v223, v141
		v_exp_f32_e32 v29, v142
		v_exp_f32_e32 v225, v143
		v_exp_f32_e32 v31, v144
		v_exp_f32_e32 v227, v145
		v_exp_f32_e32 v113, v146
		v_exp_f32_e32 v229, v147
		v_exp_f32_e32 v115, v148
		v_exp_f32_e32 v231, v149
		v_exp_f32_e32 v117, v150
		v_exp_f32_e32 v233, v151
		v_exp_f32_e32 v119, v152
		v_exp_f32_e32 v235, v153
		v_exp_f32_e32 v121, v154
		v_exp_f32_e32 v237, v155
		v_exp_f32_e32 v123, v156
		v_exp_f32_e32 v239, v157
		v_exp_f32_e32 v125, v158
		v_exp_f32_e32 v241, v159
		v_exp_f32_e32 v127, v160
		v_exp_f32_e32 v243, v161
		v_exp_f32_e32 v129, v162
		v_exp_f32_e32 v245, v163
		v_exp_f32_e32 v131, v164
		v_exp_f32_e32 v247, v165
		v_exp_f32_e32 v132, v166
		v_exp_f32_e32 v134, v167
		v_exp_f32_e32 v136, v96
		v_exp_f32_e32 v138, v97
		v_exp_f32_e32 v96, v98
		v_exp_f32_e32 v140, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v142, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v144, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v146, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v148, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v150, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v152, v111
		v_exp_f32_e32 v110, v168
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
		v_exp_f32_e32 v133, v198
		v_exp_f32_e32 v135, v199
		v_exp_f32_e32 v137, v200
		v_exp_f32_e32 v139, v201
		v_exp_f32_e32 v97, v202
		v_exp_f32_e32 v141, v203
		v_exp_f32_e32 v99, v204
		v_exp_f32_e32 v143, v205
		v_exp_f32_e32 v101, v206
		v_exp_f32_e32 v145, v207
		v_exp_f32_e32 v103, v208
		v_exp_f32_e32 v147, v209
		v_exp_f32_e32 v105, v210
		v_exp_f32_e32 v149, v211
		v_exp_f32_e32 v107, v212
		v_exp_f32_e32 v151, v213
		v_exp_f32_e32 v109, v214
		v_exp_f32_e32 v153, v215
		v_exp_f32_e32 v111, v176
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
		v_pk_add_f32 v[178:179], v[18:19], v[218:219]
		v_pk_add_f32 v[180:181], v[24:25], v[220:221]
		v_pk_add_f32 v[182:183], v[26:27], v[222:223]
		v_pk_add_f32 v[184:185], v[28:29], v[224:225]
		v_pk_add_f32 v[186:187], v[30:31], v[226:227]
		v_pk_add_f32 v[188:189], v[112:113], v[228:229]
		v_pk_add_f32 v[196:197], v[114:115], v[230:231]
		v_pk_add_f32 v[198:199], v[116:117], v[232:233]
		v_pk_add_f32 v[200:201], v[118:119], v[234:235]
		v_pk_add_f32 v[202:203], v[120:121], v[236:237]
		v_pk_add_f32 v[204:205], v[122:123], v[238:239]
		v_pk_add_f32 v[206:207], v[124:125], v[240:241]
		v_pk_add_f32 v[208:209], v[126:127], v[242:243]
		v_pk_add_f32 v[210:211], v[128:129], v[244:245]
		v_pk_add_f32 v[212:213], v[130:131], v[246:247]
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
		v_add_f32_e32 v3, v180, v181
		v_accvgpr_read_b32 v5, a72
		ds_bpermute_b32 v176, v5, v3
		v_accvgpr_read_b32 v5, a73
		ds_bpermute_b32 v178, v5, v3
		v_pk_add_f32 v[180:181], v[132:133], v[134:135]
		v_pk_add_f32 v[182:183], v[136:137], v[138:139]
		v_pk_add_f32 v[184:185], v[96:97], v[140:141]
		v_pk_add_f32 v[186:187], v[98:99], v[142:143]
		v_pk_add_f32 v[188:189], v[100:101], v[144:145]
		v_pk_add_f32 v[196:197], v[102:103], v[146:147]
		v_pk_add_f32 v[198:199], v[104:105], v[148:149]
		v_pk_add_f32 v[200:201], v[106:107], v[150:151]
		v_pk_add_f32 v[202:203], v[108:109], v[152:153]
		v_pk_add_f32 v[204:205], v[110:111], v[154:155]
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
		s_nop 1
		v_permlane32_swap_b32_e32 v176, v177
		v_add_f32_e32 v179, v176, v177
		v_sub_f32_e32 v3, v7, v22
		v_sub_f32_e32 v5, v13, v23
		v_exp_f32_e32 v6, v3
		v_exp_f32_e32 v12, v5
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[32:33], v[32:33], v[6:7]
		v_pk_mul_f32 v[34:35], v[34:35], v[6:7]
		v_pk_mul_f32 v[36:37], v[36:37], v[6:7]
		v_pk_mul_f32 v[38:39], v[38:39], v[6:7]
		v_pk_mul_f32 v[40:41], v[40:41], v[6:7]
		v_pk_mul_f32 v[42:43], v[42:43], v[6:7]
		v_pk_mul_f32 v[44:45], v[44:45], v[6:7]
		v_pk_mul_f32 v[46:47], v[46:47], v[6:7]
		v_pk_mul_f32 v[48:49], v[48:49], v[6:7]
		v_pk_mul_f32 v[50:51], v[50:51], v[6:7]
		v_pk_mul_f32 v[52:53], v[52:53], v[6:7]
		v_pk_mul_f32 v[54:55], v[54:55], v[6:7]
		v_pk_mul_f32 v[56:57], v[56:57], v[6:7]
		v_pk_mul_f32 v[58:59], v[58:59], v[6:7]
		v_pk_mul_f32 v[60:61], v[60:61], v[6:7]
		v_pk_mul_f32 v[62:63], v[62:63], v[6:7]
		v_mov_b32_e32 v13, v12
		v_pk_mul_f32 v[64:65], v[64:65], v[12:13]
		v_pk_mul_f32 v[66:67], v[66:67], v[12:13]
		v_pk_mul_f32 v[68:69], v[68:69], v[12:13]
		v_pk_mul_f32 v[70:71], v[70:71], v[12:13]
		v_pk_mul_f32 v[72:73], v[72:73], v[12:13]
		v_pk_mul_f32 v[74:75], v[74:75], v[12:13]
		v_pk_mul_f32 v[76:77], v[76:77], v[12:13]
		v_pk_mul_f32 v[78:79], v[78:79], v[12:13]
		v_pk_mul_f32 v[80:81], v[80:81], v[12:13]
		v_pk_mul_f32 v[82:83], v[82:83], v[12:13]
		v_pk_mul_f32 v[84:85], v[84:85], v[12:13]
		v_pk_mul_f32 v[86:87], v[86:87], v[12:13]
		v_pk_mul_f32 v[88:89], v[88:89], v[12:13]
		v_pk_mul_f32 v[90:91], v[90:91], v[12:13]
		v_pk_mul_f32 v[92:93], v[92:93], v[12:13]
		v_pk_mul_f32 v[94:95], v[94:95], v[12:13]
		v_mov_b32_e32 v176, v6
		v_mov_b32_e32 v177, v12
		v_mov_b32_e32 v178, v180
		v_mov_b64_e32 v[6:7], v[14:15]
		v_pk_fma_f32 v[14:15], v[6:7], v[176:177], v[178:179]
		v_cvt_pk_bf16_f32 v176, v190, v216
		v_cvt_pk_bf16_f32 v177, v18, v218
		v_cvt_pk_bf16_f32 v178, v24, v220
		v_cvt_pk_bf16_f32 v179, v26, v222
		v_cvt_pk_bf16_f32 v180, v28, v224
		v_cvt_pk_bf16_f32 v181, v30, v226
		v_cvt_pk_bf16_f32 v182, v112, v228
		v_cvt_pk_bf16_f32 v183, v114, v230
		v_cvt_pk_bf16_f32 v184, v116, v232
		v_cvt_pk_bf16_f32 v185, v118, v234
		v_cvt_pk_bf16_f32 v186, v120, v236
		v_cvt_pk_bf16_f32 v187, v122, v238
		v_cvt_pk_bf16_f32 v196, v124, v240
		v_cvt_pk_bf16_f32 v197, v126, v242
		v_cvt_pk_bf16_f32 v198, v128, v244
		v_cvt_pk_bf16_f32 v199, v130, v246
		v_cvt_pk_bf16_f32 v200, v191, v217
		v_cvt_pk_bf16_f32 v201, v19, v219
		v_cvt_pk_bf16_f32 v202, v25, v221
		v_cvt_pk_bf16_f32 v203, v27, v223
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
		v_cvt_pk_bf16_f32 v116, v132, v134
		v_cvt_pk_bf16_f32 v117, v136, v138
		v_cvt_pk_bf16_f32 v118, v96, v140
		v_cvt_pk_bf16_f32 v119, v98, v142
		v_cvt_pk_bf16_f32 v120, v100, v144
		v_cvt_pk_bf16_f32 v121, v102, v146
		v_cvt_pk_bf16_f32 v122, v104, v148
		v_cvt_pk_bf16_f32 v123, v106, v150
		v_cvt_pk_bf16_f32 v124, v108, v152
		v_cvt_pk_bf16_f32 v125, v110, v154
		v_cvt_pk_bf16_f32 v126, v156, v158
		v_cvt_pk_bf16_f32 v127, v160, v162
		v_cvt_pk_bf16_f32 v128, v164, v166
		v_cvt_pk_bf16_f32 v129, v168, v170
		v_cvt_pk_bf16_f32 v130, v172, v174
		v_cvt_pk_bf16_f32 v131, v192, v194
		v_cvt_pk_bf16_f32 v188, v133, v135
		v_cvt_pk_bf16_f32 v189, v137, v139
		v_cvt_pk_bf16_f32 v190, v97, v141
		v_cvt_pk_bf16_f32 v191, v99, v143
		v_cvt_pk_bf16_f32 v96, v101, v145
		v_cvt_pk_bf16_f32 v97, v103, v147
		v_cvt_pk_bf16_f32 v98, v105, v149
		v_cvt_pk_bf16_f32 v99, v107, v151
		v_cvt_pk_bf16_f32 v100, v109, v153
		v_cvt_pk_bf16_f32 v101, v111, v155
		v_cvt_pk_bf16_f32 v102, v157, v159
		v_cvt_pk_bf16_f32 v103, v161, v163
		v_cvt_pk_bf16_f32 v104, v165, v167
		v_cvt_pk_bf16_f32 v105, v169, v171
		v_cvt_pk_bf16_f32 v106, v173, v175
		v_cvt_pk_bf16_f32 v107, v193, v195
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[176:179], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[176:179], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[188:191], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[188:191], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[104:107], v[64:79]
		v_mov_b32_e32 v7, v22
		v_mov_b32_e32 v13, v23
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s23, s23, 0x80
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s24, v3
		v_accvgpr_read_b32 v3, a10
		s_nop 0
		v_add_u32_e32 v3, s24, v3
		v_add_u32_e32 v3, s19, v3
		v_accvgpr_read_b32 v5, a52
		s_nop 0
		v_readfirstlane_b32 s24, v5
		v_accvgpr_read_b32 v5, a11
		s_nop 0
		v_add_u32_e32 v5, s24, v5
		v_add_u32_e32 v5, s19, v5
		v_xor_b32_e32 v6, 1, v8
		v_accvgpr_write_b32 a10, v6
		v_xor_b32_e32 v6, 2, v8
		v_accvgpr_write_b32 a11, v6
		v_xor_b32_e32 v6, 3, v8
		v_accvgpr_write_b32 a52, v6
		v_xor_b32_e32 v6, 8, v8
		v_accvgpr_write_b32 a62, v6
		v_xor_b32_e32 v6, 9, v8
		v_accvgpr_write_b32 a68, v6
		v_xor_b32_e32 v6, 10, v8
		v_accvgpr_write_b32 a74, v6
		v_xor_b32_e32 v6, 11, v8
		v_accvgpr_write_b32 a75, v6
		v_xor_b32_e32 v6, 16, v8
		v_accvgpr_write_b32 a76, v6
		v_xor_b32_e32 v6, 17, v8
		v_accvgpr_write_b32 a77, v6
		v_xor_b32_e32 v6, 18, v8
		v_accvgpr_write_b32 a78, v6
		v_xor_b32_e32 v6, 19, v8
		v_accvgpr_write_b32 a79, v6
		v_xor_b32_e32 v6, 24, v8
		v_accvgpr_write_b32 a80, v6
		v_xor_b32_e32 v6, 25, v8
		v_accvgpr_write_b32 a81, v6
		v_xor_b32_e32 v6, 26, v8
		v_accvgpr_write_b32 a82, v6
		v_xor_b32_e32 v6, 27, v8
		v_accvgpr_write_b32 a83, v6
		v_xor_b32_e32 v6, 32, v8
		v_accvgpr_write_b32 a84, v6
		v_xor_b32_e32 v6, 33, v8
		v_accvgpr_write_b32 a85, v6
		v_xor_b32_e32 v6, 34, v8
		v_accvgpr_write_b32 a86, v6
		v_xor_b32_e32 v6, 35, v8
		v_accvgpr_write_b32 a87, v6
		v_xor_b32_e32 v6, 40, v8
		v_accvgpr_write_b32 a88, v6
		v_xor_b32_e32 v6, 41, v8
		v_accvgpr_write_b32 a89, v6
		v_xor_b32_e32 v6, 42, v8
		v_accvgpr_write_b32 a90, v6
		v_xor_b32_e32 v6, 43, v8
		v_accvgpr_write_b32 a91, v6
		v_xor_b32_e32 v6, 48, v8
		v_accvgpr_write_b32 a92, v6
		v_xor_b32_e32 v6, 49, v8
		v_accvgpr_write_b32 a93, v6
		v_xor_b32_e32 v6, 50, v8
		v_accvgpr_write_b32 a94, v6
		v_xor_b32_e32 v6, 51, v8
		v_accvgpr_write_b32 a95, v6
		v_xor_b32_e32 v6, 56, v8
		v_accvgpr_write_b32 a96, v6
		v_xor_b32_e32 v6, 57, v8
		v_accvgpr_write_b32 a97, v6
		v_xor_b32_e32 v6, 58, v8
		v_accvgpr_write_b32 a98, v6
		v_xor_b32_e32 v6, 59, v8
		v_accvgpr_write_b32 a99, v6
		v_xor_b32_e32 v6, 64, v8
		v_accvgpr_write_b32 a100, v6
		v_xor_b32_e32 v6, 0x41, v8
		v_accvgpr_write_b32 a101, v6
		v_xor_b32_e32 v6, 0x42, v8
		v_accvgpr_write_b32 a102, v6
		v_xor_b32_e32 v6, 0x43, v8
		v_accvgpr_write_b32 a103, v6
		v_xor_b32_e32 v6, 0x48, v8
		v_accvgpr_write_b32 a104, v6
		v_xor_b32_e32 v6, 0x49, v8
		v_accvgpr_write_b32 a105, v6
		v_xor_b32_e32 v6, 0x4a, v8
		v_accvgpr_write_b32 a106, v6
		v_xor_b32_e32 v6, 0x4b, v8
		v_accvgpr_write_b32 a107, v6
		v_xor_b32_e32 v6, 0x50, v8
		v_accvgpr_write_b32 a108, v6
		v_xor_b32_e32 v6, 0x51, v8
		v_accvgpr_write_b32 a109, v6
		v_xor_b32_e32 v6, 0x52, v8
		v_accvgpr_write_b32 a110, v6
		v_xor_b32_e32 v6, 0x53, v8
		v_accvgpr_write_b32 a111, v6
		v_xor_b32_e32 v6, 0x58, v8
		v_accvgpr_write_b32 a112, v6
		v_xor_b32_e32 v6, 0x59, v8
		v_accvgpr_write_b32 a113, v6
		v_xor_b32_e32 v6, 0x5a, v8
		v_accvgpr_write_b32 a114, v6
		v_xor_b32_e32 v6, 0x5b, v8
		v_accvgpr_write_b32 a115, v6
		v_xor_b32_e32 v6, 0x60, v8
		v_accvgpr_write_b32 a116, v6
		v_xor_b32_e32 v6, 0x61, v8
		v_accvgpr_write_b32 a117, v6
		v_xor_b32_e32 v6, 0x62, v8
		v_accvgpr_write_b32 a118, v6
		v_xor_b32_e32 v6, 0x63, v8
		v_accvgpr_write_b32 a119, v6
		v_xor_b32_e32 v6, 0x68, v8
		v_accvgpr_write_b32 a120, v6
		v_xor_b32_e32 v6, 0x69, v8
		v_accvgpr_write_b32 a121, v6
		v_xor_b32_e32 v6, 0x6a, v8
		v_accvgpr_write_b32 a122, v6
		v_xor_b32_e32 v6, 0x6b, v8
		v_accvgpr_write_b32 a123, v6
		v_xor_b32_e32 v6, 0x70, v8
		v_accvgpr_write_b32 a124, v6
		v_xor_b32_e32 v6, 0x71, v8
		v_accvgpr_write_b32 a125, v6
		v_xor_b32_e32 v6, 0x72, v8
		v_accvgpr_write_b32 a126, v6
		v_xor_b32_e32 v6, 0x73, v8
		v_accvgpr_write_b32 a127, v6
		v_xor_b32_e32 v6, 0x78, v8
		v_accvgpr_write_b32 a128, v6
		v_xor_b32_e32 v6, 0x79, v8
		v_accvgpr_write_b32 a129, v6
		v_xor_b32_e32 v6, 0x7a, v8
		v_accvgpr_write_b32 a130, v6
		v_xor_b32_e32 v6, 0x7b, v8
		v_accvgpr_write_b32 a131, v6
		v_accvgpr_read_b32 v6, a19
		v_lshl_add_u32 v6, v6, 4, v16
		v_accvgpr_read_b32 v12, a63
		v_accvgpr_read_b32 v16, a64
		v_add3_u32 v6, v6, v12, v16
		v_accvgpr_read_b32 v12, a65
		v_accvgpr_read_b32 v16, a66
		v_add3_u32 v6, v6, v12, v16
		v_accvgpr_write_b32 a19, v6
		v_accvgpr_read_b32 v6, a67
		v_accvgpr_read_b32 v12, a69
		v_lshl_add_u32 v6, v6, 3, v12
		v_accvgpr_read_b32 v12, a70
		v_accvgpr_read_b32 v16, a71
		v_add3_u32 v6, v6, v12, v16
		v_accvgpr_write_b32 a63, v6
		v_mov_b32_e32 v6, 0xff800000
		s_cmp_lt_i32 s46, s23
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s19, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s24, s22, 0
		s_add_i32 s24, s46, s24
		s_ashr_i32 s24, s24, 7
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s37, s16, 0
		s_add_i32 s37, s24, s37
		s_ashr_i32 s37, s37, 1
		s_lshl_b32 s37, s37, 1
		s_xor_b32 s37, s37, -1
		s_add_i32 s37, s37, 1
		s_add_i32 s37, s24, s37
		s_add_i32 s24, s24, 1
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s39, s16, 0
		s_add_i32 s39, s24, s39
		s_ashr_i32 s39, s39, 1
		s_lshl_b32 s39, s39, 1
		s_xor_b32 s39, s39, -1
		s_add_i32 s39, s39, 1
		s_add_i32 s40, s24, s39
		s_mul_i32 s24, 0x4100, s37
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, s24, v12
		ds_read_b128 a[64:67], v12
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
		ds_read_b128 v[16:19], v12 offset:384
		ds_read_b128 a[176:179], v12 offset:416
		ds_read_b128 a[180:183], v12 offset:448
		ds_read_b128 a[184:187], v12 offset:480
		s_mul_i32 s24, 0x4400, s37
		v_accvgpr_read_b32 v12, a63
		v_add_u32_e32 v12, s24, v12
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
		s_cmp_lt_i32 s19, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v12, a53
		v_add_u32_e32 v12, s19, v12
		v_cmp_lt_i32_e64 s[54:55], v12, s21
		v_accvgpr_read_b32 v12, a54
		v_add_u32_e32 v12, s19, v12
		v_cmp_lt_i32_e64 s[56:57], v12, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s24, s15, s46
		s_lshl_b32 s24, s24, 1
		s_add_i32 s37, s47, s24
		v_add_u32_e32 v12, s37, v9
		v_cndmask_b32_e64 v12, v21, v12, s[54:55]
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
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s41, -1, 0
		s_mov_b32 s58, 0x4100
		s_mov_b32 s59, 0
		s_mul_i32 s62, s58, s40
		s_mul_hi_u32 s63, s58, s40
		s_mul_i32 s37, s58, s41
		s_add_i32 s63, s63, s37
		s_mul_i32 s37, s59, s40
		s_add_i32 s63, s63, s37
		s_add_u32 s58, s60, s62
		s_addc_u32 s59, s61, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v20, a56
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v20, s21
		s_add_i32 s37, s48, s24
		v_add_u32_e32 v12, s37, v9
		v_cndmask_b32_e64 v12, v21, v12, s[58:59]
		s_add_u32 s58, s60, 0x1040
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v20, a57
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v20, s21
		s_add_i32 s37, s49, s24
		v_add_u32_e32 v12, s37, v9
		v_cndmask_b32_e64 v12, v21, v12, s[58:59]
		s_add_u32 s58, s60, 0x2080
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v20, a58
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v20, s21
		s_add_i32 s24, s25, s24
		v_add_u32_e32 v12, s24, v9
		v_cndmask_b32_e64 v12, v21, v12, s[58:59]
		s_add_u32 s58, s60, 0x30c0
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s60, s58, 0
		s_addc_u32 s61, s59, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v20, a59
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_mul_i32 s24, s17, s46
		s_lshl_b32 s24, s24, 1
		s_add_i32 s37, s50, s24
		v_add_u32_e32 v12, s37, v4
		v_cndmask_b32_e64 v12, v21, v12, s[56:57]
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
		s_mul_i32 s60, s56, s40
		s_mul_hi_u32 s61, s56, s40
		s_mul_i32 s37, s56, s41
		s_add_i32 s61, s61, s37
		s_mul_i32 s37, s57, s40
		s_add_i32 s61, s61, s37
		s_add_u32 s40, s54, s60
		s_addc_u32 s41, s55, s61
		s_add_u32 s54, s40, 0
		s_addc_u32 s55, s41, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v22, a60
		v_add_u32_e32 v22, s19, v22
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v20, s21
		s_add_i32 s37, s51, s24
		v_add_u32_e32 v12, s37, v4
		v_cndmask_b32_e64 v12, v21, v12, s[40:41]
		s_add_u32 s40, s58, 0x92f0
		s_addc_u32 s41, s59, 0
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s54, s40, 0
		s_addc_u32 s55, s41, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v20, a61
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v22, s21
		s_add_i32 s19, s52, s24
		v_add_u32_e32 v12, s19, v4
		s_add_u32 s54, s58, 0xa3f0
		s_addc_u32 s55, s59, 0
		s_add_u32 s54, s54, s60
		s_addc_u32 s55, s55, s61
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v12, v21, v12, s[40:41]
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_add_i32 s19, s36, s24
		v_cmp_lt_i32_e64 vcc, v20, s21
		v_add_u32_e32 v12, s19, v4
		s_add_u32 s40, s58, 0xb4f0
		s_addc_u32 s41, s59, 0
		v_cndmask_b32_e32 v12, v21, v12, vcc
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s54, s40, 0
		s_addc_u32 s55, s41, 0
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[64:67], a[20:23], 0
		v_add_u32_e32 v12, s46, v8
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[20:23], 0
		v_accvgpr_read_b32 v20, a10
		v_add_u32_e32 v20, s46, v20
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[20:23], 0
		v_accvgpr_read_b32 v22, a11
		v_add_u32_e32 v22, s46, v22
		v_mfma_f32_32x32x16_bf16 v[144:159], v[16:19], a[20:23], 0
		v_accvgpr_read_b32 v23, a52
		v_add_u32_e32 v23, s46, v23
		v_mfma_f32_32x32x16_bf16 v[160:175], v[16:19], a[36:39], 0
		v_accvgpr_read_b32 v16, a74
		v_add_u32_e32 v16, s46, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], a[64:67], a[36:39], 0
		v_accvgpr_read_b32 v17, a75
		v_add_u32_e32 v17, s46, v17
		v_mfma_f32_32x32x16_bf16 v[192:207], a[144:147], a[36:39], 0
		v_accvgpr_read_b32 v18, a78
		v_add_u32_e32 v18, s46, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[160:163], a[36:39], 0
		v_accvgpr_read_b32 v19, a79
		v_add_u32_e32 v19, s46, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[24:27], v[96:111]
		v_accvgpr_read_b32 v24, a82
		v_add_u32_e32 v24, s46, v24
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], v[112:127]
		v_accvgpr_read_b32 v25, a83
		v_add_u32_e32 v25, s46, v25
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], v[128:143]
		v_accvgpr_read_b32 v26, a86
		v_add_u32_e32 v26, s46, v26
		v_mfma_f32_32x32x16_bf16 v[144:159], a[176:179], a[24:27], v[144:159]
		v_accvgpr_read_b32 v27, a87
		v_add_u32_e32 v27, s46, v27
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[40:43], v[160:175]
		v_accvgpr_read_b32 v28, a90
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a64, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[40:43], v[176:191]
		v_accvgpr_read_b32 v28, a91
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a65, v28
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[40:43], v[192:207]
		v_accvgpr_read_b32 v28, a94
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a66, v28
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[40:43], v[208:223]
		v_accvgpr_read_b32 v28, a95
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a67, v28
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[28:31], v[96:111]
		v_accvgpr_read_b32 v28, a98
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a69, v28
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[28:31], v[112:127]
		v_accvgpr_read_b32 v28, a99
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a70, v28
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[28:31], v[128:143]
		v_accvgpr_read_b32 v28, a102
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a71, v28
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[28:31], v[144:159]
		v_accvgpr_read_b32 v28, a103
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a132, v28
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[44:47], v[160:175]
		v_accvgpr_read_b32 v28, a106
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a133, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[44:47], v[176:191]
		v_accvgpr_read_b32 v28, a107
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a134, v28
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[44:47], v[192:207]
		v_accvgpr_read_b32 v28, a110
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a135, v28
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[44:47], v[208:223]
		v_accvgpr_read_b32 v28, a111
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a136, v28
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_accvgpr_read_b32 v28, a114
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a137, v28
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_accvgpr_read_b32 v28, a115
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a138, v28
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[32:35], v[128:143]
		v_accvgpr_read_b32 v28, a118
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a139, v28
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[32:35], v[144:159]
		v_accvgpr_read_b32 v28, a119
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a144, v28
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[48:51], v[160:175]
		v_accvgpr_read_b32 v28, a122
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a145, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_accvgpr_read_b32 v28, a123
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a140, v28
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_accvgpr_read_b32 v28, a126
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a141, v28
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_accvgpr_read_b32 v28, a127
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a142, v28
		v_accvgpr_read_b32 v28, a130
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a143, v28
		v_accvgpr_read_b32 v28, a131
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a146, v28
		v_cmp_ge_i32_e64 s[40:41], v3, v12
		v_cmp_ge_i32_e64 s[54:55], v3, v20
		v_cmp_ge_i32_e64 s[56:57], v3, v22
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v28, a62
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_read_b32 v29, a68
		v_add_u32_e32 v29, s46, v29
		v_cndmask_b32_e32 v31, v6, v99, vcc
		v_cmp_ge_i32_e64 s[58:59], v3, v28
		v_cmp_ge_i32_e64 s[60:61], v3, v29
		v_cmp_ge_i32_e64 s[62:63], v3, v16
		v_cmp_ge_i32_e64 vcc, v3, v17
		v_accvgpr_read_b32 v30, a76
		v_add_u32_e32 v99, s46, v30
		v_accvgpr_read_b32 v30, a77
		v_add_u32_e32 v224, s46, v30
		v_cndmask_b32_e32 v227, v6, v103, vcc
		v_cmp_ge_i32_e64 s[64:65], v3, v99
		v_cmp_ge_i32_e64 s[66:67], v3, v224
		v_cmp_ge_i32_e64 s[68:69], v3, v18
		v_cmp_ge_i32_e64 vcc, v3, v19
		v_accvgpr_read_b32 v30, a80
		v_add_u32_e32 v103, s46, v30
		v_accvgpr_read_b32 v30, a81
		v_add_u32_e32 v225, s46, v30
		v_cndmask_b32_e32 v229, v6, v107, vcc
		v_cmp_ge_i32_e64 s[70:71], v3, v103
		v_cmp_ge_i32_e64 s[72:73], v3, v225
		v_cmp_ge_i32_e64 s[74:75], v3, v24
		v_cmp_ge_i32_e64 vcc, v3, v25
		v_accvgpr_read_b32 v30, a84
		v_add_u32_e32 v107, s46, v30
		v_accvgpr_read_b32 v30, a85
		v_add_u32_e32 v230, s46, v30
		v_cndmask_b32_e32 v233, v6, v111, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v107
		v_cmp_ge_i32_e64 s[78:79], v3, v230
		v_cmp_ge_i32_e64 s[80:81], v3, v26
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_accvgpr_read_b32 v30, a88
		v_add_u32_e32 v111, s46, v30
		v_accvgpr_read_b32 v30, a89
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a147, v30
		v_cndmask_b32_e32 v235, v6, v115, vcc
		v_cmp_ge_i32_e64 s[82:83], v3, v111
		v_accvgpr_read_b32 v30, a147
		v_cmp_ge_i32_e64 s[84:85], v3, v30
		v_accvgpr_read_b32 v30, a64
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v236, s86
		v_mov_b32_e32 v237, s87
		v_accvgpr_read_b32 v30, a65
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a92
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a148, v30
		v_accvgpr_read_b32 v30, a93
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a149, v30
		v_cndmask_b32_e32 v239, v6, v119, vcc
		v_accvgpr_read_b32 v30, a148
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_accvgpr_read_b32 v30, a149
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a152, v240
		v_accvgpr_write_b32 a153, v241
		v_accvgpr_read_b32 v30, a66
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a154, v240
		v_accvgpr_write_b32 a155, v241
		v_accvgpr_read_b32 v30, a67
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a96
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a156, v30
		v_accvgpr_read_b32 v30, a97
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a157, v30
		v_cndmask_b32_e32 v241, v6, v123, vcc
		v_accvgpr_read_b32 v30, a156
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a158, v242
		v_accvgpr_write_b32 a159, v243
		v_accvgpr_read_b32 v30, a157
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v30, a69
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a162, v242
		v_accvgpr_write_b32 a163, v243
		v_accvgpr_read_b32 v30, a70
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a100
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a164, v30
		v_accvgpr_read_b32 v30, a101
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a165, v30
		v_cndmask_b32_e32 v243, v6, v127, vcc
		v_accvgpr_read_b32 v30, a164
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v30, a165
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v30, a71
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a170, v244
		v_accvgpr_write_b32 a171, v245
		v_accvgpr_read_b32 v30, a132
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a104
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a172, v30
		v_accvgpr_read_b32 v30, a105
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a173, v30
		v_cndmask_b32_e32 v245, v6, v131, vcc
		v_accvgpr_read_b32 v30, a172
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v30, a173
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v30, a133
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a178, v246
		v_accvgpr_write_b32 a179, v247
		v_accvgpr_read_b32 v30, a134
		v_cmp_ge_i32_e64 vcc, v3, v30
		s_mov_b64 s[86:87], vcc
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_read_b32 v30, a108
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a180, v30
		v_accvgpr_read_b32 v30, a109
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a181, v30
		v_cndmask_b32_e32 v247, v6, v135, vcc
		v_accvgpr_read_b32 v30, a180
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v30, a181
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a184, v248
		v_accvgpr_write_b32 a185, v249
		v_accvgpr_read_b32 v30, a135
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a186, v248
		v_accvgpr_write_b32 a187, v249
		v_accvgpr_read_b32 v30, a136
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a112
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a252, v30
		v_accvgpr_read_b32 v30, a113
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a253, v30
		v_cndmask_b32_e32 v249, v6, v139, vcc
		v_accvgpr_read_b32 v30, a252
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		s_nop 1
		v_mov_b32_e32 v250, s86
		v_mov_b32_e32 v251, s87
		v_accvgpr_write_b32 a254, v250
		v_accvgpr_write_b32 a255, v251
		v_accvgpr_read_b32 v30, a253
		v_cmp_ge_i32_e64 s[86:87], v3, v30
		v_accvgpr_read_b32 v30, a137
		v_cmp_ge_i32_e64 s[88:89], v3, v30
		v_cndmask_b32_e64 v251, v6, v141, s[86:87]
		s_nop 0
		v_cndmask_b32_e64 v252, v6, v142, s[88:89]
		v_accvgpr_read_b32 v30, a138
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a116
		v_add_u32_e32 v115, s46, v30
		v_accvgpr_read_b32 v30, a117
		v_add_u32_e32 v119, s46, v30
		v_cndmask_b32_e32 v253, v6, v143, vcc
		v_cmp_ge_i32_e64 s[86:87], v3, v115
		v_cmp_ge_i32_e64 s[88:89], v3, v119
		v_accvgpr_read_b32 v30, a139
		v_cmp_ge_i32_e64 s[90:91], v3, v30
		v_cndmask_b32_e64 v142, v6, v144, s[86:87]
		v_cndmask_b32_e64 v143, v6, v145, s[88:89]
		v_cndmask_b32_e64 v144, v6, v146, s[90:91]
		v_accvgpr_read_b32 v30, a144
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a120
		v_add_u32_e32 v123, s46, v30
		v_accvgpr_read_b32 v30, a121
		v_add_u32_e32 v127, s46, v30
		v_cndmask_b32_e32 v145, v6, v147, vcc
		v_cmp_ge_i32_e64 s[86:87], v3, v123
		v_cmp_ge_i32_e64 s[88:89], v3, v127
		v_accvgpr_read_b32 v30, a145
		v_cmp_ge_i32_e64 s[90:91], v3, v30
		v_cndmask_b32_e64 v146, v6, v148, s[86:87]
		v_cndmask_b32_e64 v147, v6, v149, s[88:89]
		v_cndmask_b32_e64 v148, v6, v150, s[90:91]
		v_accvgpr_read_b32 v30, a140
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a124
		v_add_u32_e32 v131, s46, v30
		v_accvgpr_read_b32 v30, a125
		v_add_u32_e32 v135, s46, v30
		v_cndmask_b32_e32 v149, v6, v151, vcc
		v_cmp_ge_i32_e64 s[86:87], v3, v131
		v_cmp_ge_i32_e64 s[88:89], v3, v135
		v_accvgpr_read_b32 v30, a141
		v_cmp_ge_i32_e64 s[90:91], v3, v30
		v_cndmask_b32_e64 v150, v6, v152, s[86:87]
		v_cndmask_b32_e64 v151, v6, v153, s[88:89]
		v_cndmask_b32_e64 v152, v6, v154, s[90:91]
		v_accvgpr_read_b32 v30, a142
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_accvgpr_read_b32 v30, a128
		v_add_u32_e32 v139, s46, v30
		v_accvgpr_read_b32 v30, a129
		v_add_u32_e32 v141, s46, v30
		v_cndmask_b32_e32 v153, v6, v155, vcc
		v_cmp_ge_i32_e64 s[86:87], v3, v139
		v_cmp_ge_i32_e64 s[88:89], v3, v141
		v_accvgpr_read_b32 v30, a143
		v_cmp_ge_i32_e64 s[90:91], v3, v30
		v_cndmask_b32_e64 v154, v6, v156, s[86:87]
		v_cndmask_b32_e64 v155, v6, v157, s[88:89]
		v_cndmask_b32_e64 v156, v6, v158, s[90:91]
		v_accvgpr_read_b32 v30, a146
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_cndmask_b32_e64 v254, v6, v96, s[40:41]
		v_cndmask_b32_e64 v255, v6, v97, s[54:55]
		v_cndmask_b32_e32 v157, v6, v159, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v12
		v_cmp_ge_i32_e64 s[54:55], v5, v20
		v_cmp_ge_i32_e64 s[86:87], v5, v22
		v_cndmask_b32_e64 v96, v6, v176, s[40:41]
		v_cndmask_b32_e64 v97, v6, v177, s[54:55]
		v_cndmask_b32_e64 v158, v6, v178, s[86:87]
		v_cmp_ge_i32_e64 vcc, v5, v23
		v_cndmask_b32_e64 v30, v6, v98, s[56:57]
		v_cndmask_b32_e64 v22, v6, v100, s[58:59]
		v_cndmask_b32_e32 v159, v6, v179, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v28
		v_cmp_ge_i32_e64 s[54:55], v5, v29
		v_cmp_ge_i32_e64 s[56:57], v5, v16
		v_cndmask_b32_e64 v28, v6, v180, s[40:41]
		v_cndmask_b32_e64 v29, v6, v181, s[54:55]
		v_cndmask_b32_e64 v176, v6, v182, s[56:57]
		v_cmp_ge_i32_e64 vcc, v5, v17
		v_cndmask_b32_e64 v23, v6, v101, s[60:61]
		v_cndmask_b32_e64 v226, v6, v102, s[62:63]
		v_cndmask_b32_e32 v177, v6, v183, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v99
		v_cmp_ge_i32_e64 s[54:55], v5, v224
		v_cmp_ge_i32_e64 s[56:57], v5, v18
		v_cndmask_b32_e64 v16, v6, v184, s[40:41]
		v_cndmask_b32_e64 v17, v6, v185, s[54:55]
		v_cndmask_b32_e64 v98, v6, v186, s[56:57]
		v_cmp_ge_i32_e64 vcc, v5, v19
		v_cndmask_b32_e64 v18, v6, v104, s[64:65]
		v_cndmask_b32_e64 v19, v6, v105, s[66:67]
		v_cndmask_b32_e32 v99, v6, v187, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v103
		v_cmp_ge_i32_e64 s[54:55], v5, v225
		v_cmp_ge_i32_e64 s[56:57], v5, v24
		v_cndmask_b32_e64 v100, v6, v188, s[40:41]
		v_cndmask_b32_e64 v101, v6, v189, s[54:55]
		v_cndmask_b32_e64 v102, v6, v190, s[56:57]
		v_cmp_ge_i32_e64 vcc, v5, v25
		v_cndmask_b32_e64 v228, v6, v106, s[68:69]
		v_cndmask_b32_e64 v24, v6, v108, s[70:71]
		v_cndmask_b32_e32 v103, v6, v191, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v107
		v_cmp_ge_i32_e64 s[54:55], v5, v230
		v_cmp_ge_i32_e64 s[56:57], v5, v26
		v_cndmask_b32_e64 v104, v6, v192, s[40:41]
		v_cndmask_b32_e64 v105, v6, v193, s[54:55]
		v_cndmask_b32_e64 v106, v6, v194, s[56:57]
		v_cmp_ge_i32_e64 vcc, v5, v27
		v_cndmask_b32_e64 v25, v6, v109, s[72:73]
		v_cndmask_b32_e64 v232, v6, v110, s[74:75]
		v_cndmask_b32_e32 v107, v6, v195, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v111
		v_accvgpr_read_b32 v12, a147
		v_cmp_ge_i32_e64 s[54:55], v5, v12
		v_accvgpr_read_b32 v12, a64
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v26, v6, v196, s[40:41]
		v_cndmask_b32_e64 v27, v6, v197, s[54:55]
		v_cndmask_b32_e64 v108, v6, v198, s[56:57]
		v_accvgpr_read_b32 v12, a65
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_cndmask_b32_e64 v110, v6, v112, s[76:77]
		v_cndmask_b32_e64 v111, v6, v113, s[78:79]
		v_cndmask_b32_e32 v109, v6, v199, vcc
		v_accvgpr_read_b32 v12, a148
		v_cmp_ge_i32_e64 s[40:41], v5, v12
		v_accvgpr_read_b32 v12, a149
		v_cmp_ge_i32_e64 s[54:55], v5, v12
		v_accvgpr_read_b32 v12, a66
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v112, v6, v200, s[40:41]
		v_cndmask_b32_e64 v113, v6, v201, s[54:55]
		v_cndmask_b32_e64 v178, v6, v202, s[56:57]
		v_accvgpr_read_b32 v12, a67
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_cndmask_b32_e64 v234, v6, v114, s[80:81]
		v_cndmask_b32_e64 v180, v6, v116, s[82:83]
		v_cndmask_b32_e32 v179, v6, v203, vcc
		v_accvgpr_read_b32 v12, a156
		v_cmp_ge_i32_e64 s[40:41], v5, v12
		v_accvgpr_read_b32 v12, a157
		v_cmp_ge_i32_e64 s[54:55], v5, v12
		v_accvgpr_read_b32 v12, a69
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v182, v6, v204, s[40:41]
		v_cndmask_b32_e64 v183, v6, v205, s[54:55]
		v_cndmask_b32_e64 v184, v6, v206, s[56:57]
		v_accvgpr_read_b32 v12, a70
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_cndmask_b32_e64 v181, v6, v117, s[84:85]
		v_readfirstlane_b32 s40, v236
		v_readfirstlane_b32 s41, v237
		s_nop 1
		v_cndmask_b32_e64 v238, v6, v118, s[40:41]
		v_cndmask_b32_e32 v185, v6, v207, vcc
		v_accvgpr_read_b32 v12, a164
		v_cmp_ge_i32_e64 s[40:41], v5, v12
		v_accvgpr_read_b32 v12, a165
		v_cmp_ge_i32_e64 s[54:55], v5, v12
		v_accvgpr_read_b32 v12, a71
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v116, v6, v208, s[40:41]
		v_cndmask_b32_e64 v117, v6, v209, s[54:55]
		v_cndmask_b32_e64 v186, v6, v210, s[56:57]
		v_accvgpr_read_b32 v12, a132
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_accvgpr_read_b32 v12, a150
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a151
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v188, v6, v120, s[40:41]
		v_accvgpr_read_b32 v12, a152
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a153
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v189, v6, v121, s[40:41]
		v_cndmask_b32_e32 v187, v6, v211, vcc
		v_accvgpr_read_b32 v12, a172
		v_cmp_ge_i32_e64 s[40:41], v5, v12
		v_accvgpr_read_b32 v12, a173
		v_cmp_ge_i32_e64 s[54:55], v5, v12
		v_accvgpr_read_b32 v12, a133
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v120, v6, v212, s[40:41]
		v_cndmask_b32_e64 v121, v6, v213, s[54:55]
		v_cndmask_b32_e64 v190, v6, v214, s[56:57]
		v_accvgpr_read_b32 v12, a134
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_accvgpr_read_b32 v12, a154
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a155
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v240, v6, v122, s[40:41]
		v_accvgpr_read_b32 v12, a158
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a159
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v192, v6, v124, s[40:41]
		v_cndmask_b32_e32 v191, v6, v215, vcc
		v_accvgpr_read_b32 v12, a180
		v_cmp_ge_i32_e64 s[40:41], v5, v12
		v_accvgpr_read_b32 v12, a181
		v_cmp_ge_i32_e64 s[54:55], v5, v12
		v_accvgpr_read_b32 v12, a135
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v194, v6, v216, s[40:41]
		v_cndmask_b32_e64 v195, v6, v217, s[54:55]
		v_cndmask_b32_e64 v196, v6, v218, s[56:57]
		v_accvgpr_read_b32 v12, a136
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_accvgpr_read_b32 v12, a160
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a161
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v193, v6, v125, s[40:41]
		v_accvgpr_read_b32 v12, a162
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a163
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v242, v6, v126, s[40:41]
		v_cndmask_b32_e32 v197, v6, v219, vcc
		v_accvgpr_read_b32 v12, a252
		v_cmp_ge_i32_e64 s[40:41], v5, v12
		v_accvgpr_read_b32 v12, a253
		v_cmp_ge_i32_e64 s[54:55], v5, v12
		v_accvgpr_read_b32 v12, a137
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v124, v6, v220, s[40:41]
		v_cndmask_b32_e64 v125, v6, v221, s[54:55]
		v_cndmask_b32_e64 v198, v6, v222, s[56:57]
		v_accvgpr_read_b32 v12, a138
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_accvgpr_read_b32 v12, a166
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a167
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v200, v6, v128, s[40:41]
		v_accvgpr_read_b32 v12, a168
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a169
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v201, v6, v129, s[40:41]
		v_cndmask_b32_e32 v199, v6, v223, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v115
		v_cmp_ge_i32_e64 s[54:55], v5, v119
		v_accvgpr_read_b32 v12, a139
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v114, v6, v160, s[40:41]
		v_cndmask_b32_e64 v115, v6, v161, s[54:55]
		v_cndmask_b32_e64 v118, v6, v162, s[56:57]
		v_accvgpr_read_b32 v12, a144
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_accvgpr_read_b32 v12, a170
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a171
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v244, v6, v130, s[40:41]
		v_accvgpr_read_b32 v12, a174
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a175
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v128, v6, v132, s[40:41]
		v_cndmask_b32_e32 v119, v6, v163, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v123
		v_cmp_ge_i32_e64 s[54:55], v5, v127
		v_accvgpr_read_b32 v12, a145
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v122, v6, v164, s[40:41]
		v_cndmask_b32_e64 v123, v6, v165, s[54:55]
		v_cndmask_b32_e64 v126, v6, v166, s[56:57]
		v_accvgpr_read_b32 v12, a140
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_accvgpr_read_b32 v12, a176
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a177
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v129, v6, v133, s[40:41]
		v_accvgpr_read_b32 v12, a178
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a179
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v246, v6, v134, s[40:41]
		v_cndmask_b32_e32 v127, v6, v167, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v131
		v_cmp_ge_i32_e64 s[54:55], v5, v135
		v_accvgpr_read_b32 v12, a141
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v130, v6, v168, s[40:41]
		v_cndmask_b32_e64 v131, v6, v169, s[54:55]
		v_cndmask_b32_e64 v132, v6, v170, s[56:57]
		v_accvgpr_read_b32 v12, a142
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_accvgpr_read_b32 v12, a182
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a183
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v134, v6, v136, s[40:41]
		v_accvgpr_read_b32 v12, a184
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a185
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v135, v6, v137, s[40:41]
		v_cndmask_b32_e32 v133, v6, v171, vcc
		v_cmp_ge_i32_e64 s[40:41], v5, v139
		v_cmp_ge_i32_e64 s[54:55], v5, v141
		v_accvgpr_read_b32 v12, a143
		v_cmp_ge_i32_e64 s[56:57], v5, v12
		v_cndmask_b32_e64 v136, v6, v172, s[40:41]
		v_cndmask_b32_e64 v137, v6, v173, s[54:55]
		v_cndmask_b32_e64 v160, v6, v174, s[56:57]
		v_accvgpr_read_b32 v12, a146
		v_cmp_ge_i32_e64 vcc, v5, v12
		v_accvgpr_read_b32 v12, a186
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a187
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v248, v6, v138, s[40:41]
		v_accvgpr_read_b32 v12, a254
		s_nop 0
		v_readfirstlane_b32 s40, v12
		v_accvgpr_read_b32 v12, a255
		s_nop 0
		v_readfirstlane_b32 s41, v12
		s_nop 1
		v_cndmask_b32_e64 v250, v6, v140, s[40:41]
		v_cndmask_b32_e32 v161, v6, v175, vcc
		v_max3_f32 v12, v254, v255, v30
		v_max3_f32 v20, v22, v23, v226
		v_max3_f32 v138, v18, v19, v228
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
		v_max3_f32 v12, v12, v31, v20
		v_max3_f32 v20, v138, v229, v139
		v_max3_f32 v138, v140, v235, v141
		v_max3_f32 v139, v162, v241, v163
		v_max3_f32 v140, v164, v245, v165
		v_max3_f32 v141, v166, v249, v167
		v_max3_f32 v162, v168, v145, v169
		v_max3_f32 v163, v170, v153, v171
		v_max3_f32 v12, v12, v227, v20
		v_max3_f32 v20, v138, v239, v139
		v_max3_f32 v138, v140, v247, v141
		v_max3_f32 v139, v162, v149, v163
		v_max3_f32 v12, v12, v233, v20
		v_max3_f32 v20, v138, v253, v139
		v_max3_f32 v12, v12, v243, v20
		v_max_f32_e32 v12, v12, v157
		v_mov_b32_e32 v138, v12
		v_mov_b32_e32 v139, v12
		s_nop 1
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v140, v138, v139
		v_max3_f32 v12, v96, v97, v158
		v_max3_f32 v20, v28, v29, v176
		v_max3_f32 v138, v16, v17, v98
		v_max3_f32 v139, v100, v101, v102
		v_max3_f32 v141, v104, v105, v106
		v_max3_f32 v162, v26, v27, v108
		v_max3_f32 v163, v112, v113, v178
		v_max3_f32 v164, v182, v183, v184
		v_max3_f32 v165, v116, v117, v186
		v_max3_f32 v166, v120, v121, v190
		v_max3_f32 v167, v194, v195, v196
		v_max3_f32 v168, v124, v125, v198
		v_max3_f32 v169, v114, v115, v118
		v_max3_f32 v170, v122, v123, v126
		v_max3_f32 v171, v130, v131, v132
		v_max3_f32 v172, v136, v137, v160
		v_max3_f32 v12, v12, v159, v20
		v_max3_f32 v20, v138, v99, v139
		v_max3_f32 v138, v141, v107, v162
		v_max3_f32 v139, v163, v179, v164
		v_max3_f32 v141, v165, v187, v166
		v_max3_f32 v162, v167, v197, v168
		v_max3_f32 v163, v169, v119, v170
		v_max3_f32 v164, v171, v133, v172
		v_max3_f32 v12, v12, v177, v20
		v_max3_f32 v20, v138, v109, v139
		v_max3_f32 v138, v141, v191, v162
		v_max3_f32 v139, v163, v127, v164
		v_max3_f32 v12, v12, v103, v20
		v_max3_f32 v20, v138, v199, v139
		v_max3_f32 v12, v12, v185, v20
		v_max_f32_e32 v12, v12, v161
		v_mov_b32_e32 v138, v12
		v_mov_b32_e32 v139, v12
		s_nop 1
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v141, v138, v139
		v_pk_mul_f32 v[138:139], v[140:141], v[10:11]
		v_max_f32_e32 v140, v7, v138
		v_max_f32_e32 v141, v13, v139
		v_pk_fma_f32 v[138:139], v[254:255], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[30:31], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[22:23], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[226:227], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[18:19], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[228:229], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[24:25], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[232:233], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[110:111], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[234:235], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[180:181], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[238:239], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[188:189], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[240:241], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[242:243], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[200:201], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[244:245], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[128:129], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[246:247], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[134:135], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[248:249], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[142:143], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[10:11], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[96:97], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[158:159], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[28:29], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[176:177], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[16:17], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[98:99], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[26:27], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[108:109], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[112:113], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[178:179], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[182:183], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[116:117], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[186:187], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[120:121], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[190:191], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[194:195], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[124:125], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[198:199], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[114:115], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[160:161], v[10:11], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v160, v138
		v_exp_f32_e32 v214, v139
		v_exp_f32_e32 v138, v162
		v_exp_f32_e32 v216, v163
		v_exp_f32_e32 v162, v30
		v_exp_f32_e32 v218, v31
		v_exp_f32_e32 v30, v22
		v_exp_f32_e32 v220, v23
		v_exp_f32_e32 v22, v164
		v_exp_f32_e32 v222, v165
		v_exp_f32_e32 v164, v18
		v_exp_f32_e32 v224, v19
		v_exp_f32_e32 v18, v166
		v_exp_f32_e32 v226, v167
		v_exp_f32_e32 v166, v24
		v_exp_f32_e32 v228, v25
		v_exp_f32_e32 v24, v168
		v_exp_f32_e32 v230, v169
		v_exp_f32_e32 v168, v110
		v_exp_f32_e32 v232, v111
		v_exp_f32_e32 v110, v170
		v_exp_f32_e32 v234, v171
		v_exp_f32_e32 v170, v172
		v_exp_f32_e32 v236, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v238, v175
		v_exp_f32_e32 v174, v180
		v_exp_f32_e32 v240, v181
		v_exp_f32_e32 v180, v188
		v_exp_f32_e32 v242, v189
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v244, v193
		v_exp_f32_e32 v161, v202
		v_exp_f32_e32 v215, v203
		v_exp_f32_e32 v139, v200
		v_exp_f32_e32 v217, v201
		v_exp_f32_e32 v163, v204
		v_exp_f32_e32 v219, v205
		v_exp_f32_e32 v31, v128
		v_exp_f32_e32 v221, v129
		v_exp_f32_e32 v23, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v165, v134
		v_exp_f32_e32 v225, v135
		v_exp_f32_e32 v19, v208
		v_exp_f32_e32 v227, v209
		v_exp_f32_e32 v167, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v25, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v169, v142
		v_exp_f32_e32 v233, v143
		v_exp_f32_e32 v111, v144
		v_exp_f32_e32 v235, v145
		v_exp_f32_e32 v171, v146
		v_exp_f32_e32 v237, v147
		v_exp_f32_e32 v173, v148
		v_exp_f32_e32 v239, v149
		v_exp_f32_e32 v175, v150
		v_exp_f32_e32 v241, v151
		v_exp_f32_e32 v181, v152
		v_exp_f32_e32 v243, v153
		v_exp_f32_e32 v189, v154
		v_exp_f32_e32 v245, v155
		v_exp_f32_e32 v128, v156
		v_exp_f32_e32 v134, v157
		v_exp_f32_e32 v142, v96
		v_exp_f32_e32 v144, v97
		v_exp_f32_e32 v96, v158
		v_exp_f32_e32 v146, v159
		v_exp_f32_e32 v148, v28
		v_exp_f32_e32 v150, v29
		v_exp_f32_e32 v28, v176
		v_exp_f32_e32 v152, v177
		v_exp_f32_e32 v154, v16
		v_exp_f32_e32 v156, v17
		v_exp_f32_e32 v16, v98
		v_exp_f32_e32 v158, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v176, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v192, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v200, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v202, v107
		v_exp_f32_e32 v106, v26
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
		v_exp_f32_e32 v97, v186
		v_exp_f32_e32 v147, v187
		v_exp_f32_e32 v149, v120
		v_exp_f32_e32 v151, v121
		v_exp_f32_e32 v29, v190
		v_exp_f32_e32 v153, v191
		v_exp_f32_e32 v155, v194
		v_exp_f32_e32 v157, v195
		v_exp_f32_e32 v17, v196
		v_exp_f32_e32 v159, v197
		v_exp_f32_e32 v99, v124
		v_exp_f32_e32 v177, v125
		v_exp_f32_e32 v101, v198
		v_exp_f32_e32 v193, v199
		v_exp_f32_e32 v103, v114
		v_exp_f32_e32 v201, v115
		v_exp_f32_e32 v105, v118
		v_exp_f32_e32 v203, v119
		v_exp_f32_e32 v107, v122
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
		v_pk_add_f32 v[118:119], v[162:163], v[218:219]
		v_pk_add_f32 v[120:121], v[30:31], v[220:221]
		v_pk_add_f32 v[122:123], v[22:23], v[222:223]
		v_pk_add_f32 v[124:125], v[164:165], v[224:225]
		v_pk_add_f32 v[126:127], v[18:19], v[226:227]
		v_pk_add_f32 v[130:131], v[166:167], v[228:229]
		v_pk_add_f32 v[132:133], v[24:25], v[230:231]
		v_pk_add_f32 v[136:137], v[168:169], v[232:233]
		v_pk_add_f32 v[182:183], v[110:111], v[234:235]
		v_pk_add_f32 v[184:185], v[170:171], v[236:237]
		v_pk_add_f32 v[186:187], v[172:173], v[238:239]
		v_pk_add_f32 v[190:191], v[174:175], v[240:241]
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
		v_add_f32_e32 v12, v118, v119
		v_accvgpr_read_b32 v20, a72
		ds_bpermute_b32 v114, v20, v12
		v_accvgpr_read_b32 v20, a73
		ds_bpermute_b32 v116, v20, v12
		v_pk_add_f32 v[118:119], v[128:129], v[134:135]
		v_pk_add_f32 v[120:121], v[142:143], v[144:145]
		v_pk_add_f32 v[122:123], v[96:97], v[146:147]
		v_pk_add_f32 v[124:125], v[148:149], v[150:151]
		v_pk_add_f32 v[126:127], v[28:29], v[152:153]
		v_pk_add_f32 v[130:131], v[154:155], v[156:157]
		v_pk_add_f32 v[132:133], v[16:17], v[158:159]
		v_pk_add_f32 v[136:137], v[98:99], v[176:177]
		v_pk_add_f32 v[182:183], v[100:101], v[192:193]
		v_pk_add_f32 v[184:185], v[102:103], v[200:201]
		v_pk_add_f32 v[186:187], v[104:105], v[202:203]
		v_pk_add_f32 v[190:191], v[106:107], v[204:205]
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
		s_nop 1
		v_permlane32_swap_b32_e32 v114, v115
		v_add_f32_e32 v117, v114, v115
		v_sub_f32_e32 v7, v7, v140
		v_sub_f32_e32 v12, v13, v141
		v_exp_f32_e32 v114, v7
		v_exp_f32_e32 v120, v12
		v_mov_b32_e32 v115, v114
		v_pk_mul_f32 v[32:33], v[32:33], v[114:115]
		v_pk_mul_f32 v[34:35], v[34:35], v[114:115]
		v_pk_mul_f32 v[36:37], v[36:37], v[114:115]
		v_pk_mul_f32 v[38:39], v[38:39], v[114:115]
		v_pk_mul_f32 v[40:41], v[40:41], v[114:115]
		v_pk_mul_f32 v[42:43], v[42:43], v[114:115]
		v_pk_mul_f32 v[44:45], v[44:45], v[114:115]
		v_pk_mul_f32 v[46:47], v[46:47], v[114:115]
		v_pk_mul_f32 v[48:49], v[48:49], v[114:115]
		v_pk_mul_f32 v[50:51], v[50:51], v[114:115]
		v_pk_mul_f32 v[52:53], v[52:53], v[114:115]
		v_pk_mul_f32 v[54:55], v[54:55], v[114:115]
		v_pk_mul_f32 v[56:57], v[56:57], v[114:115]
		v_pk_mul_f32 v[58:59], v[58:59], v[114:115]
		v_pk_mul_f32 v[60:61], v[60:61], v[114:115]
		v_pk_mul_f32 v[62:63], v[62:63], v[114:115]
		v_mov_b32_e32 v121, v120
		v_pk_mul_f32 v[64:65], v[64:65], v[120:121]
		v_pk_mul_f32 v[66:67], v[66:67], v[120:121]
		v_pk_mul_f32 v[68:69], v[68:69], v[120:121]
		v_pk_mul_f32 v[70:71], v[70:71], v[120:121]
		v_pk_mul_f32 v[72:73], v[72:73], v[120:121]
		v_pk_mul_f32 v[74:75], v[74:75], v[120:121]
		v_pk_mul_f32 v[76:77], v[76:77], v[120:121]
		v_pk_mul_f32 v[78:79], v[78:79], v[120:121]
		v_pk_mul_f32 v[80:81], v[80:81], v[120:121]
		v_pk_mul_f32 v[82:83], v[82:83], v[120:121]
		v_pk_mul_f32 v[84:85], v[84:85], v[120:121]
		v_pk_mul_f32 v[86:87], v[86:87], v[120:121]
		v_pk_mul_f32 v[88:89], v[88:89], v[120:121]
		v_pk_mul_f32 v[90:91], v[90:91], v[120:121]
		v_pk_mul_f32 v[92:93], v[92:93], v[120:121]
		v_pk_mul_f32 v[94:95], v[94:95], v[120:121]
		v_mov_b32_e32 v12, v114
		v_mov_b32_e32 v13, v120
		v_mov_b32_e32 v116, v118
		v_mov_b64_e32 v[114:115], v[14:15]
		v_pk_fma_f32 v[14:15], v[114:115], v[12:13], v[116:117]
		v_cvt_pk_bf16_f32 v116, v160, v214
		v_cvt_pk_bf16_f32 v117, v138, v216
		v_cvt_pk_bf16_f32 v118, v162, v218
		v_cvt_pk_bf16_f32 v119, v30, v220
		v_cvt_pk_bf16_f32 v120, v22, v222
		v_cvt_pk_bf16_f32 v121, v164, v224
		v_cvt_pk_bf16_f32 v122, v18, v226
		v_cvt_pk_bf16_f32 v123, v166, v228
		v_cvt_pk_bf16_f32 v124, v24, v230
		v_cvt_pk_bf16_f32 v125, v168, v232
		v_cvt_pk_bf16_f32 v126, v110, v234
		v_cvt_pk_bf16_f32 v127, v170, v236
		v_cvt_pk_bf16_f32 v184, v172, v238
		v_cvt_pk_bf16_f32 v185, v174, v240
		v_cvt_pk_bf16_f32 v186, v180, v242
		v_cvt_pk_bf16_f32 v187, v188, v244
		v_cvt_pk_bf16_f32 v196, v161, v215
		v_cvt_pk_bf16_f32 v197, v139, v217
		v_cvt_pk_bf16_f32 v198, v163, v219
		v_cvt_pk_bf16_f32 v199, v31, v221
		v_cvt_pk_bf16_f32 v136, v23, v223
		v_cvt_pk_bf16_f32 v137, v165, v225
		v_cvt_pk_bf16_f32 v138, v19, v227
		v_cvt_pk_bf16_f32 v139, v167, v229
		v_cvt_pk_bf16_f32 v160, v25, v231
		v_cvt_pk_bf16_f32 v161, v169, v233
		v_cvt_pk_bf16_f32 v162, v111, v235
		v_cvt_pk_bf16_f32 v163, v171, v237
		v_cvt_pk_bf16_f32 v164, v173, v239
		v_cvt_pk_bf16_f32 v165, v175, v241
		v_cvt_pk_bf16_f32 v166, v181, v243
		v_cvt_pk_bf16_f32 v167, v189, v245
		v_cvt_pk_bf16_f32 v168, v128, v134
		v_cvt_pk_bf16_f32 v169, v142, v144
		v_cvt_pk_bf16_f32 v170, v96, v146
		v_cvt_pk_bf16_f32 v171, v148, v150
		v_cvt_pk_bf16_f32 v172, v28, v152
		v_cvt_pk_bf16_f32 v173, v154, v156
		v_cvt_pk_bf16_f32 v174, v16, v158
		v_cvt_pk_bf16_f32 v175, v98, v176
		v_cvt_pk_bf16_f32 v180, v100, v192
		v_cvt_pk_bf16_f32 v181, v102, v200
		v_cvt_pk_bf16_f32 v182, v104, v202
		v_cvt_pk_bf16_f32 v183, v106, v204
		v_cvt_pk_bf16_f32 v188, v26, v206
		v_cvt_pk_bf16_f32 v189, v108, v208
		v_cvt_pk_bf16_f32 v190, v112, v210
		v_cvt_pk_bf16_f32 v191, v178, v212
		v_cvt_pk_bf16_f32 v216, v129, v135
		v_cvt_pk_bf16_f32 v217, v143, v145
		v_cvt_pk_bf16_f32 v218, v97, v147
		v_cvt_pk_bf16_f32 v219, v149, v151
		v_cvt_pk_bf16_f32 v128, v29, v153
		v_cvt_pk_bf16_f32 v129, v155, v157
		v_cvt_pk_bf16_f32 v130, v17, v159
		v_cvt_pk_bf16_f32 v131, v99, v177
		v_cvt_pk_bf16_f32 v16, v101, v193
		v_cvt_pk_bf16_f32 v17, v103, v201
		v_cvt_pk_bf16_f32 v18, v105, v203
		v_cvt_pk_bf16_f32 v19, v107, v205
		v_cvt_pk_bf16_f32 v28, v27, v207
		v_cvt_pk_bf16_f32 v29, v109, v209
		v_cvt_pk_bf16_f32 v30, v113, v211
		v_cvt_pk_bf16_f32 v31, v179, v213
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[168:171], v[80:95]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[168:171], v[64:79]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[180:183], v[80:95]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[180:183], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		s_add_i32 s19, s46, 0x80
		s_cmp_lt_i32 s19, s23
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[188:191], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[188:191], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[160:163], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[160:163], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[28:31], v[64:79]
		s_mov_b32 s46, s19
		v_mov_b32_e32 v7, v140
		v_mov_b32_e32 v13, v141
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v4, v14
		v_rcp_f32_e32 v6, v15
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
		v_accvgpr_read_b32 v3, a8
		s_nop 0
		v_readfirstlane_b32 s1, v3
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v3, a2
		s_nop 0
		v_readfirstlane_b32 s19, v3
		v_accvgpr_read_b32 v3, a12
		s_nop 0
		v_readfirstlane_b32 s22, v3
		s_mul_i32 s19, s22, s19
		s_lshl_b32 s19, s19, 1
		s_add_i32 s22, s1, s19
		v_accvgpr_read_b32 v3, a3
		s_nop 0
		v_readfirstlane_b32 s23, v3
		v_accvgpr_read_b32 v3, a13
		s_nop 0
		v_readfirstlane_b32 s24, v3
		s_mul_i32 s23, s24, s23
		s_lshl_b32 s23, s23, 1
		s_add_i32 s22, s22, s23
		v_accvgpr_read_b32 v3, a9
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v32, v3, 6, s22
		v_accvgpr_read_b32 v33, a14
		v_mul_lo_u32 v33, s18, v33
		v_lshl_add_u32 v32, v33, 1, v32
		v_accvgpr_read_b32 v34, a18
		v_mul_lo_u32 v34, s18, v34
		v_lshl_add_u32 v32, v34, 5, v32
		v_accvgpr_read_b32 v35, a55
		v_mul_lo_u32 v35, s18, v35
		v_lshl_add_u32 v32, v35, 4, v32
		v_accvgpr_read_b32 v36, a15
		v_mul_lo_u32 v36, s18, v36
		v_lshl_add_u32 v32, v36, 3, v32
		v_accvgpr_read_b32 v37, a16
		v_mul_lo_u32 v37, s18, v37
		v_lshl_add_u32 v32, v37, 2, v32
		v_accvgpr_read_b32 v38, a17
		v_lshl_add_u32 v32, v38, 4, v32
		v_mov_b32_e32 v38, s42
		v_mov_b32_e32 v39, s43
		s_nop 0
		v_readfirstlane_b32 s24, v38
		v_readfirstlane_b32 s25, v39
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[72:75], v32, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s22, s1, 32
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v32, v3, 6, s22
		v_lshl_add_u32 v32, v33, 1, v32
		v_lshl_add_u32 v32, v34, 5, v32
		v_lshl_add_u32 v32, v35, 4, v32
		v_lshl_add_u32 v32, v36, 3, v32
		v_lshl_add_u32 v32, v37, 2, v32
		v_accvgpr_read_b32 v40, a17
		v_lshl_add_u32 v32, v40, 4, v32
		v_readfirstlane_b32 s24, v38
		v_readfirstlane_b32 s25, v39
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[8:11], v32, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s22, s1, 64
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v8, v3, 6, s22
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v8, v9, 4, v8
		v_readfirstlane_b32 s24, v38
		v_readfirstlane_b32 s25, v39
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[12:15], v8, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s22, s1, 0x60
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v8, v3, 6, s22
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v8, v9, 4, v8
		v_readfirstlane_b32 s24, v38
		v_readfirstlane_b32 s25, v39
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[16:19], v8, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s22, s18, 8
		s_add_i32 s24, s22, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v8, v3, 6, s24
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v8, v9, 4, v8
		v_mov_b32_e32 v10, s44
		v_mov_b32_e32 v11, s45
		s_nop 0
		v_readfirstlane_b32 s24, v10
		v_readfirstlane_b32 s25, v11
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[20:23], v8, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s24, s22, 32
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v8, v3, 6, s24
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v8, v9, 4, v8
		v_readfirstlane_b32 s24, v10
		v_readfirstlane_b32 s25, v11
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[4:7], v8, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s24, s22, 64
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v4, v3, 6, s24
		v_lshl_add_u32 v4, v33, 1, v4
		v_lshl_add_u32 v4, v34, 5, v4
		v_lshl_add_u32 v4, v35, 4, v4
		v_lshl_add_u32 v4, v36, 3, v4
		v_lshl_add_u32 v4, v37, 2, v4
		v_accvgpr_read_b32 v5, a17
		v_lshl_add_u32 v4, v5, 4, v4
		v_readfirstlane_b32 s24, v10
		v_readfirstlane_b32 s25, v11
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[24:27], v4, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s22, s22, 0x60
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s23
		v_lshl_add_u32 v3, v3, 6, s1
		v_lshl_add_u32 v3, v33, 1, v3
		v_lshl_add_u32 v3, v34, 5, v3
		v_lshl_add_u32 v3, v35, 4, v3
		v_lshl_add_u32 v3, v36, 3, v3
		v_lshl_add_u32 v3, v37, 2, v3
		v_accvgpr_read_b32 v4, a17
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s22, v10
		v_readfirstlane_b32 s23, v11
		s_and_saveexec_b64 s[92:93], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[28:31], v3, s[28:31], 0 offen
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
		s_add_i32 s0, s0, 32
		v_accvgpr_read_b32 v3, a7
		s_nop 0
		v_readfirstlane_b32 s1, v3
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
    wave.regalloc.iterations: 453
    wave.regalloc.agpr.dwords: 877
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
