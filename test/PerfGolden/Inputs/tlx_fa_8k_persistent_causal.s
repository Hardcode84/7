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
		s_add_i32 s24, s22, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s22, s24, s22
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		v_mov_b32_e32 v2, s22
		v_accvgpr_write_b32 a10, v2
		s_mul_i32 s19, s19, 2
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
		v_accvgpr_read_b32 v6, a13
		v_add_u32_e32 v6, s19, v6
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v2, v7
		v_bitop3_b32 v2, v2, v10, v13 bitop3:0x96
		v_bitop3_b32 v2, v2, v15, v17 bitop3:0x96
		v_accvgpr_write_b32 a14, v2
		v_accvgpr_read_b32 v2, a14
		v_add_u32_e32 v2, s19, v2
		v_cmp_lt_i32_e64 vcc, v6, s20
		s_mov_b64 s[22:23], vcc
		v_mov_b32_e32 v6, s22
		v_mov_b32_e32 v7, s23
		v_accvgpr_write_b32 a16, v6
		v_accvgpr_write_b32 a17, v7
		v_cmp_lt_i32_e64 vcc, v2, s20
		s_mov_b64 s[22:23], vcc
		v_mov_b32_e32 v6, s22
		v_mov_b32_e32 v7, s23
		v_accvgpr_write_b32 a18, v6
		v_accvgpr_write_b32 a19, v7
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
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v13, a6
		v_and_b32_e32 v13, 0xffff, v13
		v_lshlrev_b32_e32 v15, 16, v13
		v_or_b32_e32 v24, v13, v15
		v_mov_b32_e32 v25, v24
		v_mov_b32_e32 v26, v24
		v_mov_b32_e32 v27, v24
		v_accvgpr_read_b32 v13, a11
		s_nop 0
		v_readfirstlane_b32 s22, v13
		s_mul_i32 s22, s22, s12
		s_lshl_b32 s22, s22, 9
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s23, s23, s10
		s_lshl_b32 s23, s23, 1
		s_add_i32 s28, s22, s23
		v_accvgpr_read_b32 v13, a10
		s_nop 0
		v_readfirstlane_b32 s29, v13
		s_mul_i32 s29, s29, s11
		s_lshl_b32 s29, s29, 1
		s_add_i32 s28, s28, s29
		v_mul_lo_u32 v13, s12, v8
		v_lshl_add_u32 v15, v13, 1, s28
		v_and_b32_e32 v23, 1, v0
		v_accvgpr_write_b32 a15, v23
		v_accvgpr_read_b32 v23, a15
		v_lshl_add_u32 v15, v23, 4, v15
		v_and_b32_e32 v23, 1, v4
		v_accvgpr_write_b32 a20, v23
		v_accvgpr_read_b32 v23, a20
		v_lshl_add_u32 v15, v23, 6, v15
		v_and_b32_e32 v3, 1, v3
		v_accvgpr_write_b32 a21, v3
		v_accvgpr_read_b32 v3, a21
		v_lshl_add_u32 v3, v3, 5, v15
		v_cmp_lt_i32_e64 vcc, v10, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[28:31], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v28, v24
		v_mov_b32_e32 v29, v25
		v_mov_b32_e32 v30, v26
		v_mov_b32_e32 v31, v27
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s28, s12, 6
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v3, v13, 1, s28
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a20
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a21
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v17, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[32:35], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v32, v24
		v_mov_b32_e32 v33, v25
		v_mov_b32_e32 v34, v26
		v_mov_b32_e32 v35, v27
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s28, s12, 7
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v3, v13, 1, s28
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a20
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a21
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v18, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[36:39], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v36, v24
		v_mov_b32_e32 v37, v25
		v_mov_b32_e32 v38, v26
		v_mov_b32_e32 v39, v27
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s28, 0xc0, s12
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v3, v13, 1, s28
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a20
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a21
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v19, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[40:43], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v40, v24
		v_mov_b32_e32 v41, v25
		v_mov_b32_e32 v42, v26
		v_mov_b32_e32 v43, v27
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s28, s12, 8
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v3, v13, 1, s28
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a20
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a21
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v20, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[44:47], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v44, v24
		v_mov_b32_e32 v45, v25
		v_mov_b32_e32 v46, v26
		v_mov_b32_e32 v47, v27
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s28, 0x140, s12
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v3, v13, 1, s28
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a20
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a21
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v21, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[48:51], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v48, v24
		v_mov_b32_e32 v49, v25
		v_mov_b32_e32 v50, v26
		v_mov_b32_e32 v51, v27
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s28, 0x180, s12
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v3, v13, 1, s28
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a20
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a21
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v22, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[20:23], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v20, v24
		v_mov_b32_e32 v21, v25
		v_mov_b32_e32 v22, v26
		v_mov_b32_e32 v23, v27
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s28, 0x1c0, s12
		s_add_i32 s22, s28, s22
		s_add_i32 s22, s22, s23
		s_add_i32 s22, s22, s29
		v_lshl_add_u32 v3, v13, 1, s22
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a20
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a21
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v2, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[52:55], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v52, v24
		v_mov_b32_e32 v53, v25
		v_mov_b32_e32 v54, v26
		v_mov_b32_e32 v55, v27
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[90:91]
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
		v_accvgpr_read_b32 v2, a12
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 2, v2
		v_and_b32_e32 v3, 1, v5
		v_accvgpr_write_b32 a22, v3
		v_accvgpr_read_b32 v3, a22
		v_lshlrev_b32_e32 v3, 1, v3
		v_and_b32_e32 v5, 1, v11
		v_accvgpr_write_b32 a23, v5
		v_accvgpr_read_b32 v5, a23
		v_xor_b32_e32 v5, v0, v5
		v_bitop3_b32 v2, v2, v3, v5 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v2
		v_add_u32_e32 v2, 0x10000, v2
		ds_write_b128 v2, v[28:31] offset:2480
		ds_write_b128 v2, v[32:35] offset:6576
		ds_write_b128 v2, v[36:39] offset:10672
		ds_write_b128 v2, v[40:43] offset:14768
		v_accvgpr_read_b32 v3, a12
		v_lshlrev_b32_e32 v3, 12, v3
		v_add_u32_e32 v3, 0x10000, v3
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v10, 3, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v11, 6, v10
		v_add_u32_e32 v13, v3, v11
		v_lshrrev_b32_e32 v15, 2, v5
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v17, 5, v15
		v_add_u32_e32 v18, v13, v17
		v_lshrrev_b32_e32 v19, 5, v5
		v_accvgpr_write_b32 a24, v19
		v_lshrrev_b32_e32 v19, 4, v5
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 7, v19
		v_lshrrev_b32_e32 v24, 1, v5
		v_and_b32_e32 v24, 1, v24
		v_lshlrev_b32_e32 v25, 4, v24
		v_and_b32_e32 v26, 1, v5
		v_lshlrev_b32_e32 v26, 3, v26
		v_accvgpr_read_b32 v27, a24
		v_add3_u32 v27, v27, v19, v11
		v_add3_u32 v27, v27, v17, v25
		v_add_u32_e32 v28, v26, v27
		v_xor_b32_e32 v28, v28, v24
		v_lshl_add_u32 v18, v28, 4, v18
		ds_read_b128 a[28:31], v18 offset:2480
		v_lshlrev_b32_e32 v15, 1, v15
		v_add3_u32 v28, v26, v27, 2
		v_bitop3_b32 v28, v15, v28, v24 bitop3:0x96
		v_lshl_add_u32 v13, v28, 4, v13
		ds_read_b128 a[32:35], v13 offset:2480
		v_add3_u32 v27, v26, v27, 4
		v_xad_u32 v27, v27, v24, v15
		v_lshlrev_b32_e32 v10, 2, v10
		v_xor_b32_e32 v27, v27, v10
		v_lshl_add_u32 v27, v27, 4, v3
		ds_read_b128 a[36:39], v27 offset:2480
		v_accvgpr_read_b32 v28, a24
		v_add3_u32 v19, 6, v28, v19
		v_add3_u32 v11, v19, v11, v17
		v_add3_u32 v11, v11, v25, v26
		v_xor_b32_e32 v11, v11, v24
		v_bitop3_b32 v10, v10, v15, v11 bitop3:0x96
		v_lshl_add_u32 v3, v10, 4, v3
		ds_read_b128 a[40:43], v3 offset:2480
		v_accvgpr_read_b32 v10, a11
		s_nop 0
		v_readfirstlane_b32 s22, v10
		s_add_i32 s22, s22, 1
		s_mul_i32 s22, s22, 0x100
		s_mov_b32 s23, 0x7f
		v_mov_b32_e32 v10, 64
		v_mul_lo_u32 v10, v10, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[44:47] offset:2480
		ds_write_b128 v2, v[48:51] offset:6576
		ds_write_b128 v2, v[20:23] offset:10672
		ds_write_b128 v2, v[52:55] offset:14768
		v_mov_b32_e32 v2, 32
		v_mul_lo_u32 v2, v2, v12
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[44:47], v18 offset:2480
		ds_read_b128 a[48:51], v13 offset:2480
		ds_read_b128 a[52:55], v27 offset:2480
		ds_read_b128 a[56:59], v3 offset:2480
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s24, v3
		s_add_i32 s22, s22, s24
		s_cmp_lt_i32 s21, s22
		s_cselect_b32 s22, s21, s22
		s_add_i32 s24, s22, 0x7f
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s25, s23, 0
		s_add_i32 s24, s24, s25
		s_ashr_i32 s24, s24, 7
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_add_i32 s25, s19, s25
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s36, s23, 0
		s_add_i32 s25, s25, s36
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, s24
		s_cselect_b32 s25, s25, s24
		s_cmp_gt_i32 s25, 0
		s_cselect_b32 s25, s25, 0
		v_bitop3_b32 v3, v10, v2, v11 bitop3:0x96
		v_mov_b32_e32 v12, 2
		v_mul_lo_u32 v12, v12, v16
		v_bitop3_b32 v3, v3, v14, v12 bitop3:0x96
		v_accvgpr_write_b32 a25, v3
		v_bitop3_b32 v3, 4, v10, v2 bitop3:0x96
		v_bitop3_b32 v13, 8, v10, v2 bitop3:0x96
		v_bitop3_b32 v10, 12, v10, v2 bitop3:0x96
		v_accvgpr_read_b32 v15, a25
		v_cmp_lt_i32_e64 vcc, v15, s21
		s_mov_b64 s[36:37], vcc
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v9
		v_mov_b32_e32 v9, 64
		v_mul_lo_u32 v9, v9, v6
		v_bitop3_b32 v6, v15, v2, v9 bitop3:0x96
		v_bitop3_b32 v6, v6, v14, v12 bitop3:0x96
		v_accvgpr_write_b32 a26, v6
		v_bitop3_b32 v6, 4, v15, v2 bitop3:0x96
		v_bitop3_b32 v16, 8, v15, v2 bitop3:0x96
		v_bitop3_b32 v2, 12, v15, v2 bitop3:0x96
		v_accvgpr_read_b32 v15, a26
		v_cmp_lt_i32_e64 vcc, v15, s21
		v_readfirstlane_b32 s38, v0
		v_accvgpr_read_b32 v15, a12
		v_mul_lo_u32 v15, s15, v15
		v_accvgpr_read_b32 v17, a22
		v_mul_lo_u32 v17, s15, v17
		v_lshlrev_b32_e32 v17, 5, v17
		v_lshl_add_u32 v15, v15, 1, v17
		v_accvgpr_read_b32 v17, a23
		v_mul_lo_u32 v17, s15, v17
		v_lshl_add_u32 v15, v17, 6, v15
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a27, v8
		v_accvgpr_read_b32 v8, a27
		v_mul_lo_u32 v8, s15, v8
		v_lshlrev_b32_e32 v8, 7, v8
		v_accvgpr_read_b32 v17, a15
		v_lshlrev_b32_e32 v17, 4, v17
		v_add3_u32 v8, v15, v8, v17
		v_accvgpr_read_b32 v15, a20
		v_lshlrev_b32_e32 v15, 6, v15
		v_accvgpr_read_b32 v18, a21
		v_lshlrev_b32_e32 v18, 5, v18
		v_add3_u32 v8, v8, v15, v18
		v_readfirstlane_b32 s39, v1
		s_mul_i32 s39, s39, s13
		s_lshl_b32 s39, s39, 1
		v_accvgpr_read_b32 v19, a10
		s_nop 0
		v_readfirstlane_b32 s40, v19
		s_mul_i32 s40, s40, s14
		s_lshl_b32 s40, s40, 1
		s_add_i32 s41, s39, s40
		v_add_u32_e32 v19, s41, v8
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e64 v19, v20, v19, s[36:37]
		s_lshr_b32 s41, s38, 6
		s_mul_i32 s42, 0x410, s41
		s_mov_b32 m0, s42
		v_xor_b32_e32 v3, v3, v11
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_lshl_b32 s43, s15, 3
		s_add_i32 s43, s43, s39
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v19, s43, v8
		v_cndmask_b32_e64 v19, v20, v19, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v13, v13, v11
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_lshl_b32 s43, s15, 4
		s_add_i32 s43, s43, s39
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v19, s43, v8
		v_cndmask_b32_e64 v19, v20, v19, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v10, v10, v11
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_bitop3_b32 v10, v10, v14, v12 bitop3:0x96
		v_accvgpr_write_b32 a60, v10
		s_mul_i32 s43, 24, s15
		s_add_i32 s43, s43, s39
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v10, s43, v8
		v_cndmask_b32_e64 v10, v20, v10, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v6, v6, v9
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v6, v14, v12 bitop3:0x96
		v_accvgpr_write_b32 a61, v6
		v_accvgpr_read_b32 v6, a12
		v_mul_lo_u32 v6, s17, v6
		v_accvgpr_read_b32 v10, a22
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 7, v10
		v_lshl_add_u32 v6, v6, 1, v10
		v_accvgpr_read_b32 v10, a23
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v6, v10, 6, v6
		v_accvgpr_read_b32 v10, a27
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v6, v6, v10, v17
		v_add3_u32 v6, v6, v15, v18
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
		v_add_u32_e32 v1, s43, v6
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_mul_i32 s41, 0x440, s41
		s_add_i32 m0, s41, 0x81f0
		v_xor_b32_e32 v10, v16, v9
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v10, v14, v12 bitop3:0x96
		v_accvgpr_write_b32 a62, v1
		s_lshl_b32 s43, s17, 3
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v1, s43, v6
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v2, v9
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v2, v14, v12 bitop3:0x96
		v_accvgpr_write_b32 a63, v1
		s_lshl_b32 s43, s17, 4
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v1, s43, v6
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v2, v3, v14, v12 bitop3:0x96
		v_accvgpr_write_b32 a64, v2
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		s_mul_i32 s43, 24, s17
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v1, s43, v6
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v2, v13, v14, v12 bitop3:0x96
		v_accvgpr_write_b32 a65, v2
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		s_mul_i32 s43, s25, 0x80
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v2, 1, v1
		v_lshrrev_b32_e32 v3, 4, v1
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 4, v3
		v_lshrrev_b32_e32 v9, 3, v1
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_add3_u32 v10, v2, v3, v9
		v_lshrrev_b32_e32 v11, 2, v1
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 2, v11
		v_lshrrev_b32_e32 v1, 1, v1
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_add3_u32 v10, v10, v11, v1
		v_add_u32_e32 v2, 32, v2
		v_bitop3_b32 v1, v11, v2, v1 bitop3:0x96
		v_bitop3_b32 v1, v3, v9, v1 bitop3:0x96
		v_mov_b32_e32 v2, 0x3e38aa3b
		v_mov_b32_e32 v3, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v9, s25
		v_mov_b32_e32 v11, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v12, s25
		v_mov_b32_e32 v13, s25
		s_mov_b32 s25, 0
		v_accvgpr_read_b32 v14, a24
		v_lshlrev_b32_e32 v14, 4, v14
		v_accvgpr_write_b32 a66, v14
		v_and_b32_e32 v5, 31, v5
		v_lshrrev_b32_e32 v14, 4, v5
		v_lshlrev_b32_e32 v14, 9, v14
		v_accvgpr_write_b32 a67, v14
		v_lshrrev_b32_e32 v14, 3, v5
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 0x2080
		v_mul_lo_u32 v15, v15, v14
		v_accvgpr_write_b32 a68, v15
		v_lshrrev_b32_e32 v14, 2, v5
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 0x1040
		v_mul_lo_u32 v15, v15, v14
		v_accvgpr_write_b32 a69, v15
		v_lshrrev_b32_e32 v14, 1, v5
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 0x820
		v_mul_lo_u32 v15, v15, v14
		v_accvgpr_write_b32 a70, v15
		v_and_b32_e32 v5, 1, v5
		v_mov_b32_e32 v14, 0x410
		v_mul_lo_u32 v14, v14, v5
		v_accvgpr_write_b32 a71, v14
		v_and_b32_e32 v5, 3, v0
		v_accvgpr_write_b32 a72, v5
		v_accvgpr_read_b32 v5, a72
		v_lshlrev_b32_e32 v5, 3, v5
		v_accvgpr_write_b32 a73, v5
		v_accvgpr_read_b32 v5, a22
		v_mov_b32_e32 v14, 0x2200
		v_mul_lo_u32 v14, v14, v5
		v_accvgpr_write_b32 a74, v14
		v_accvgpr_read_b32 v5, a23
		v_lshlrev_b32_e32 v5, 5, v5
		v_accvgpr_write_b32 a75, v5
		v_and_b32_e32 v4, 3, v4
		v_mov_b32_e32 v5, 0x440
		v_mul_lo_u32 v5, v5, v4
		v_accvgpr_write_b32 a76, v5
		s_lshl_b32 s44, s15, 8
		s_add_i32 s44, s44, s39
		s_add_i32 s44, s44, s40
		s_mul_i32 s45, 0x108, s15
		s_add_i32 s45, s45, s39
		s_add_i32 s45, s45, s40
		s_mul_i32 s46, 0x110, s15
		s_add_i32 s46, s46, s39
		s_add_i32 s46, s46, s40
		s_mul_i32 s47, 0x118, s15
		s_add_i32 s39, s47, s39
		s_add_i32 s40, s39, s40
		s_lshl_b32 s39, s17, 8
		s_add_i32 s39, s39, s36
		s_add_i32 s47, s39, s37
		s_mul_i32 s39, 0x108, s17
		s_add_i32 s39, s39, s36
		s_add_i32 s48, s39, s37
		s_mul_i32 s39, 0x110, s17
		s_add_i32 s39, s39, s36
		s_add_i32 s49, s39, s37
		s_mul_i32 s39, 0x118, s17
		s_add_i32 s36, s39, s36
		s_add_i32 s36, s36, s37
		v_lshlrev_b32_e32 v4, 2, v10
		v_accvgpr_write_b32 a77, v4
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a78, v1
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
		s_lshr_b32 s37, s25, 7
		s_and_b32 s39, s37, 1
		s_mul_i32 s50, 0x4100, s39
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v4, a67
		v_add3_u32 v1, s50, v1, v4
		v_accvgpr_read_b32 v4, a68
		v_accvgpr_read_b32 v5, a69
		v_add3_u32 v1, v1, v4, v5
		v_accvgpr_read_b32 v4, a70
		v_accvgpr_read_b32 v5, a71
		v_add3_u32 v1, v1, v4, v5
		ds_read_b128 v[16:19], v1
		ds_read_b128 a[80:83], v1 offset:32
		ds_read_b128 a[84:87], v1 offset:64
		ds_read_b128 a[88:91], v1 offset:96
		ds_read_b128 v[24:27], v1 offset:256
		ds_read_b128 a[92:95], v1 offset:288
		ds_read_b128 a[96:99], v1 offset:320
		ds_read_b128 a[100:103], v1 offset:352
		ds_read_b128 v[28:31], v1 offset:128
		ds_read_b128 a[104:107], v1 offset:160
		ds_read_b128 a[108:111], v1 offset:192
		ds_read_b128 a[112:115], v1 offset:224
		ds_read_b128 v[96:99], v1 offset:384
		ds_read_b128 a[116:119], v1 offset:416
		ds_read_b128 a[120:123], v1 offset:448
		ds_read_b128 a[124:127], v1 offset:480
		s_mul_i32 s39, 0x4400, s39
		v_accvgpr_read_b32 v1, a73
		v_accvgpr_read_b32 v4, a74
		v_add3_u32 v1, s39, v1, v4
		v_accvgpr_read_b32 v4, a75
		v_accvgpr_read_b32 v5, a76
		v_add3_u32 v1, v1, v4, v5
		ds_read_b64_tr_b16 a[128:129], v1 offset:33264
		ds_read_b64_tr_b16 a[130:131], v1 offset:37616
		ds_read_b64_tr_b16 a[132:133], v1 offset:33392
		ds_read_b64_tr_b16 a[134:135], v1 offset:37744
		ds_read_b64_tr_b16 a[136:137], v1 offset:33520
		ds_read_b64_tr_b16 a[138:139], v1 offset:37872
		ds_read_b64_tr_b16 a[140:141], v1 offset:33648
		ds_read_b64_tr_b16 a[142:143], v1 offset:38000
		ds_read_b64_tr_b16 a[144:145], v1 offset:33776
		ds_read_b64_tr_b16 a[146:147], v1 offset:38128
		ds_read_b64_tr_b16 a[148:149], v1 offset:33904
		ds_read_b64_tr_b16 a[150:151], v1 offset:38256
		ds_read_b64_tr_b16 a[152:153], v1 offset:34032
		ds_read_b64_tr_b16 a[154:155], v1 offset:38384
		ds_read_b64_tr_b16 a[156:157], v1 offset:34160
		ds_read_b64_tr_b16 a[158:159], v1 offset:38512
		ds_read_b64_tr_b16 a[160:161], v1 offset:33328
		ds_read_b64_tr_b16 a[162:163], v1 offset:37680
		ds_read_b64_tr_b16 a[164:165], v1 offset:33456
		ds_read_b64_tr_b16 a[166:167], v1 offset:37808
		ds_read_b64_tr_b16 a[168:169], v1 offset:33584
		ds_read_b64_tr_b16 a[170:171], v1 offset:37936
		ds_read_b64_tr_b16 a[172:173], v1 offset:33712
		ds_read_b64_tr_b16 a[174:175], v1 offset:38064
		ds_read_b64_tr_b16 a[176:177], v1 offset:33840
		ds_read_b64_tr_b16 a[178:179], v1 offset:38192
		ds_read_b64_tr_b16 a[180:181], v1 offset:33968
		ds_read_b64_tr_b16 a[182:183], v1 offset:38320
		ds_read_b64_tr_b16 a[184:185], v1 offset:34096
		ds_read_b64_tr_b16 a[186:187], v1 offset:38448
		ds_read_b64_tr_b16 a[188:189], v1 offset:34224
		ds_read_b64_tr_b16 a[190:191], v1 offset:38576
		s_mul_i32 s39, s15, s25
		s_lshl_b32 s39, s39, 1
		s_add_i32 s50, s44, s39
		v_add_u32_e32 v1, s50, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v4, s39, v8
		s_add_i32 s37, s37, 1
		v_add_u32_e32 v5, s45, v4
		s_and_b32 s37, s37, 1
		v_add_u32_e32 v10, s46, v4
		s_mul_i32 s39, 0x4100, s37
		v_add_u32_e32 v4, s40, v4
		s_add_i32 s39, s42, s39
		v_mfma_f32_32x32x16_bf16 v[112:127], v[16:19], a[28:31], 0
		s_mov_b32 m0, s39
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[28:31], 0
		s_mul_i32 s39, s17, s25
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[28:31], 0
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[28:31], 0
		v_accvgpr_read_b32 v14, a25
		v_add_u32_e32 v14, s25, v14
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[44:47], 0
		v_accvgpr_read_b32 v15, a64
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[96:111], v[16:19], a[44:47], 0
		v_accvgpr_read_b32 v16, a65
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[44:47], 0
		v_accvgpr_read_b32 v17, a60
		v_add_u32_e32 v17, s25, v17
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[44:47], 0
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[32:35], v[112:127]
		v_cmp_lt_i32_e64 vcc, v15, s21
		s_mov_b64 s[52:53], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[32:35], v[128:143]
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_mov_b64 s[54:55], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[32:35], v[144:159]
		v_cmp_lt_i32_e64 vcc, v17, s21
		s_mov_b64 s[56:57], vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[32:35], v[160:175]
		v_accvgpr_read_b32 v14, a26
		v_add_u32_e32 v14, s25, v14
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[48:51], v[176:191]
		v_accvgpr_read_b32 v15, a61
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], a[48:51], v[96:111]
		v_accvgpr_read_b32 v16, a62
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], a[92:95], a[48:51], v[192:207]
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[48:51], v[208:223]
		v_cmp_lt_i32_e64 vcc, v15, s21
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[36:39], v[112:127]
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_mov_b64 s[62:63], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[36:39], v[128:143]
		v_cndmask_b32_e64 v1, v20, v1, s[50:51]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[36:39], v[144:159]
		v_accvgpr_read_b32 v1, a63
		v_add_u32_e32 v1, s25, v1
		v_cndmask_b32_e64 v5, v20, v5, s[52:53]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v10, v20, v10, s[54:55]
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v4, v20, v4, s[56:57]
		v_cmp_lt_i32_e64 vcc, v1, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s39, s39, 1
		s_add_i32 s50, s47, s39
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_add_u32_e32 v1, s50, v6
		v_cndmask_b32_e64 v1, v20, v1, s[58:59]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s37, 0x4400, s37
		s_add_i32 s37, s41, s37
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_add_u32_e32 v4, s39, v6
		v_add_u32_e32 v5, s48, v4
		s_add_i32 m0, s37, 0x81f0
		v_cndmask_b32_e64 v5, v20, v5, s[60:61]
		v_add_u32_e32 v10, s49, v4
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v1, v20, v10, s[62:63]
		v_add_u32_e32 v4, s36, v4
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v4, v20, v4, vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[36:39], v[160:175]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[120:123], a[52:55], v[176:191]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[52:55], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[96:99], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[108:111], a[52:55], v[208:223]
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[40:43], v[112:127]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s25, s43
		v_mfma_f32_32x32x16_bf16 v[128:143], a[100:103], a[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[112:115], a[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[40:43], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[124:127], a[56:59], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[88:91], a[56:59], v[96:111]
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[100:103], a[56:59], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[56:59], v[208:223]
		s_nop 1
		v_max3_f32 v1, v112, v113, v114
		v_max3_f32 v4, v116, v117, v118
		v_max3_f32 v5, v120, v121, v122
		v_max3_f32 v10, v124, v125, v126
		v_max3_f32 v14, v128, v129, v130
		v_max3_f32 v15, v132, v133, v134
		v_max3_f32 v16, v136, v137, v138
		v_max3_f32 v17, v140, v141, v142
		v_max3_f32 v18, v144, v145, v146
		v_max3_f32 v19, v148, v149, v150
		v_max3_f32 v21, v152, v153, v154
		v_max3_f32 v22, v156, v157, v158
		v_max3_f32 v23, v160, v161, v162
		v_max3_f32 v24, v164, v165, v166
		v_max3_f32 v25, v168, v169, v170
		v_max3_f32 v26, v172, v173, v174
		v_max3_f32 v1, v1, v115, v4
		v_max3_f32 v4, v5, v123, v10
		v_max3_f32 v5, v14, v131, v15
		v_max3_f32 v10, v16, v139, v17
		v_max3_f32 v14, v18, v147, v19
		v_max3_f32 v15, v21, v155, v22
		v_max3_f32 v16, v23, v163, v24
		v_max3_f32 v17, v25, v171, v26
		v_max3_f32 v1, v1, v119, v4
		v_max3_f32 v4, v5, v135, v10
		v_max3_f32 v5, v14, v151, v15
		v_max3_f32 v10, v16, v167, v17
		v_max3_f32 v1, v1, v127, v4
		v_max3_f32 v4, v5, v159, v10
		v_max3_f32 v1, v1, v143, v4
		v_max_f32_e32 v1, v1, v175
		v_mov_b32_e32 v4, v1
		v_mov_b32_e32 v5, v1
		s_nop 1
		v_permlane32_swap_b32_e32 v4, v5
		v_max_f32_e32 v14, v4, v5
		v_max3_f32 v1, v96, v97, v98
		v_max3_f32 v4, v100, v101, v102
		v_max3_f32 v5, v104, v105, v106
		v_max3_f32 v10, v108, v109, v110
		v_max3_f32 v15, v192, v193, v194
		v_max3_f32 v16, v196, v197, v198
		v_max3_f32 v17, v200, v201, v202
		v_max3_f32 v18, v204, v205, v206
		v_max3_f32 v19, v208, v209, v210
		v_max3_f32 v21, v212, v213, v214
		v_max3_f32 v22, v216, v217, v218
		v_max3_f32 v23, v220, v221, v222
		v_max3_f32 v24, v176, v177, v178
		v_max3_f32 v25, v180, v181, v182
		v_max3_f32 v26, v184, v185, v186
		v_max3_f32 v27, v188, v189, v190
		v_max3_f32 v1, v1, v99, v4
		v_max3_f32 v4, v5, v107, v10
		v_max3_f32 v5, v15, v195, v16
		v_max3_f32 v10, v17, v203, v18
		v_max3_f32 v15, v19, v211, v21
		v_max3_f32 v16, v22, v219, v23
		v_max3_f32 v17, v24, v179, v25
		v_max3_f32 v18, v26, v187, v27
		v_max3_f32 v1, v1, v103, v4
		v_max3_f32 v4, v5, v199, v10
		v_max3_f32 v5, v15, v215, v16
		v_max3_f32 v10, v17, v183, v18
		v_max3_f32 v1, v1, v111, v4
		v_max3_f32 v4, v5, v223, v10
		v_max3_f32 v1, v1, v207, v4
		v_max_f32_e32 v1, v1, v191
		v_mov_b32_e32 v4, v1
		v_mov_b32_e32 v5, v1
		s_nop 1
		v_permlane32_swap_b32_e32 v4, v5
		v_max_f32_e32 v15, v4, v5
		v_pk_mul_f32 v[4:5], v[14:15], v[2:3]
		v_max_f32_e32 v14, v9, v4
		v_max_f32_e32 v15, v11, v5
		v_pk_fma_f32 v[4:5], v[112:113], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[114:115], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[116:117], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[118:119], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[120:121], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[122:123], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[124:125], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[126:127], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[128:129], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[130:131], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[132:133], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[134:135], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[136:137], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[138:139], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[140:141], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[142:143], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[144:145], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[146:147], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[148:149], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[150:151], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[152:153], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[154:155], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[156:157], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[158:159], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[160:161], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[162:163], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[164:165], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[166:167], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[168:169], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[170:171], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[172:173], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[174:175], v[2:3], v[14:15] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[96:97], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[192:193], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[194:195], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[196:197], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[198:199], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[200:201], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[202:203], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[204:205], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[206:207], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[208:209], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[210:211], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[212:213], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[214:215], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[216:217], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[218:219], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[220:221], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[222:223], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[176:177], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[2:3], v[14:15] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v4
		v_exp_f32_e32 v210, v5
		v_exp_f32_e32 v191, v16
		v_exp_f32_e32 v211, v17
		v_exp_f32_e32 v4, v18
		v_exp_f32_e32 v16, v19
		v_exp_f32_e32 v5, v22
		v_exp_f32_e32 v17, v23
		v_exp_f32_e32 v18, v24
		v_exp_f32_e32 v22, v25
		v_exp_f32_e32 v19, v26
		v_exp_f32_e32 v23, v27
		v_exp_f32_e32 v24, v28
		v_exp_f32_e32 v26, v29
		v_exp_f32_e32 v25, v30
		v_exp_f32_e32 v27, v31
		v_exp_f32_e32 v28, v112
		v_exp_f32_e32 v30, v113
		v_exp_f32_e32 v29, v114
		v_exp_f32_e32 v31, v115
		v_exp_f32_e32 v112, v116
		v_exp_f32_e32 v114, v117
		v_exp_f32_e32 v113, v118
		v_exp_f32_e32 v115, v119
		v_exp_f32_e32 v116, v120
		v_exp_f32_e32 v118, v121
		v_exp_f32_e32 v117, v122
		v_exp_f32_e32 v119, v123
		v_exp_f32_e32 v120, v124
		v_exp_f32_e32 v122, v125
		v_exp_f32_e32 v121, v126
		v_exp_f32_e32 v123, v127
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v126, v129
		v_exp_f32_e32 v125, v130
		v_exp_f32_e32 v127, v131
		v_exp_f32_e32 v128, v132
		v_exp_f32_e32 v130, v133
		v_exp_f32_e32 v129, v134
		v_exp_f32_e32 v131, v135
		v_exp_f32_e32 v132, v136
		v_exp_f32_e32 v134, v137
		v_exp_f32_e32 v133, v138
		v_exp_f32_e32 v135, v139
		v_exp_f32_e32 v136, v140
		v_exp_f32_e32 v138, v141
		v_exp_f32_e32 v137, v142
		v_exp_f32_e32 v139, v143
		v_exp_f32_e32 v140, v144
		v_exp_f32_e32 v142, v145
		v_exp_f32_e32 v141, v146
		v_exp_f32_e32 v143, v147
		v_exp_f32_e32 v144, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v145, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v149, v154
		v_exp_f32_e32 v151, v155
		v_exp_f32_e32 v152, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v153, v158
		v_exp_f32_e32 v155, v159
		v_exp_f32_e32 v157, v160
		v_exp_f32_e32 v159, v161
		v_exp_f32_e32 v160, v96
		v_exp_f32_e32 v212, v97
		v_exp_f32_e32 v161, v98
		v_exp_f32_e32 v213, v99
		v_exp_f32_e32 v96, v100
		v_exp_f32_e32 v98, v101
		v_exp_f32_e32 v97, v102
		v_exp_f32_e32 v99, v103
		v_exp_f32_e32 v100, v104
		v_exp_f32_e32 v102, v105
		v_exp_f32_e32 v101, v106
		v_exp_f32_e32 v103, v107
		v_exp_f32_e32 v104, v108
		v_exp_f32_e32 v106, v109
		v_exp_f32_e32 v105, v110
		v_exp_f32_e32 v107, v111
		v_exp_f32_e32 v108, v162
		v_exp_f32_e32 v110, v163
		v_exp_f32_e32 v109, v164
		v_exp_f32_e32 v111, v165
		v_exp_f32_e32 v162, v166
		v_exp_f32_e32 v164, v167
		v_exp_f32_e32 v163, v168
		v_exp_f32_e32 v165, v169
		v_exp_f32_e32 v166, v170
		v_exp_f32_e32 v168, v171
		v_exp_f32_e32 v167, v172
		v_exp_f32_e32 v169, v173
		v_exp_f32_e32 v170, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v171, v192
		v_exp_f32_e32 v173, v193
		v_exp_f32_e32 v174, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v175, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v195, v200
		v_exp_f32_e32 v197, v201
		v_exp_f32_e32 v198, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v199, v204
		v_exp_f32_e32 v201, v205
		v_exp_f32_e32 v202, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v203, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v206, v176
		v_exp_f32_e32 v208, v177
		v_exp_f32_e32 v207, v178
		v_exp_f32_e32 v209, v179
		v_exp_f32_e32 v176, v180
		v_exp_f32_e32 v178, v181
		v_exp_f32_e32 v177, v182
		v_exp_f32_e32 v179, v183
		v_exp_f32_e32 v180, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v181, v186
		v_exp_f32_e32 v183, v187
		v_exp_f32_e32 v184, v188
		v_exp_f32_e32 v186, v189
		v_pk_add_f32 v[188:189], v[190:191], v[210:211]
		v_pk_add_f32 v[214:215], v[4:5], v[16:17]
		v_pk_add_f32 v[216:217], v[18:19], v[22:23]
		v_pk_add_f32 v[218:219], v[24:25], v[26:27]
		v_pk_add_f32 v[220:221], v[28:29], v[30:31]
		v_pk_add_f32 v[222:223], v[112:113], v[114:115]
		v_pk_add_f32 v[224:225], v[116:117], v[118:119]
		v_pk_add_f32 v[226:227], v[120:121], v[122:123]
		v_pk_add_f32 v[228:229], v[124:125], v[126:127]
		v_pk_add_f32 v[230:231], v[128:129], v[130:131]
		v_pk_add_f32 v[232:233], v[132:133], v[134:135]
		v_pk_add_f32 v[234:235], v[136:137], v[138:139]
		v_pk_add_f32 v[236:237], v[140:141], v[142:143]
		v_pk_add_f32 v[238:239], v[144:145], v[146:147]
		v_pk_add_f32 v[240:241], v[148:149], v[150:151]
		v_pk_add_f32 v[242:243], v[152:153], v[154:155]
		v_mov_b32_e32 v244, v189
		v_mov_b32_e32 v245, v215
		v_mov_b32_e32 v246, v188
		v_mov_b32_e32 v247, v214
		v_pk_add_f32 v[188:189], v[246:247], v[244:245]
		v_mov_b32_e32 v214, v217
		v_mov_b32_e32 v215, v219
		v_mov_b32_e32 v244, v216
		v_mov_b32_e32 v245, v218
		v_pk_add_f32 v[216:217], v[244:245], v[214:215]
		v_mov_b32_e32 v214, v221
		v_mov_b32_e32 v215, v223
		v_mov_b32_e32 v218, v220
		v_mov_b32_e32 v219, v222
		v_pk_add_f32 v[220:221], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v225
		v_mov_b32_e32 v215, v227
		v_mov_b32_e32 v218, v224
		v_mov_b32_e32 v219, v226
		v_pk_add_f32 v[222:223], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v229
		v_mov_b32_e32 v215, v231
		v_mov_b32_e32 v218, v228
		v_mov_b32_e32 v219, v230
		v_pk_add_f32 v[224:225], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v233
		v_mov_b32_e32 v215, v235
		v_mov_b32_e32 v218, v232
		v_mov_b32_e32 v219, v234
		v_pk_add_f32 v[226:227], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v237
		v_mov_b32_e32 v215, v239
		v_mov_b32_e32 v218, v236
		v_mov_b32_e32 v219, v238
		v_pk_add_f32 v[228:229], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v241
		v_mov_b32_e32 v215, v243
		v_mov_b32_e32 v218, v240
		v_mov_b32_e32 v219, v242
		v_pk_add_f32 v[230:231], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v189
		v_mov_b32_e32 v215, v217
		v_mov_b32_e32 v218, v188
		v_mov_b32_e32 v219, v216
		v_pk_add_f32 v[188:189], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v221
		v_mov_b32_e32 v215, v223
		v_mov_b32_e32 v216, v220
		v_mov_b32_e32 v217, v222
		v_pk_add_f32 v[218:219], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v225
		v_mov_b32_e32 v215, v227
		v_mov_b32_e32 v216, v224
		v_mov_b32_e32 v217, v226
		v_pk_add_f32 v[220:221], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v229
		v_mov_b32_e32 v215, v231
		v_mov_b32_e32 v216, v228
		v_mov_b32_e32 v217, v230
		v_pk_add_f32 v[222:223], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v189
		v_mov_b32_e32 v215, v219
		v_mov_b32_e32 v216, v188
		v_mov_b32_e32 v217, v218
		v_pk_add_f32 v[188:189], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v221
		v_mov_b32_e32 v215, v223
		v_mov_b32_e32 v216, v220
		v_mov_b32_e32 v217, v222
		v_pk_add_f32 v[218:219], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v189
		v_mov_b32_e32 v215, v219
		v_mov_b32_e32 v216, v188
		v_mov_b32_e32 v217, v218
		v_pk_add_f32 v[188:189], v[216:217], v[214:215]
		v_add_f32_e32 v1, v188, v189
		v_accvgpr_read_b32 v10, a77
		ds_bpermute_b32 v156, v10, v1
		v_accvgpr_read_b32 v10, a78
		ds_bpermute_b32 v158, v10, v1
		v_pk_add_f32 v[188:189], v[160:161], v[212:213]
		v_pk_add_f32 v[214:215], v[96:97], v[98:99]
		v_pk_add_f32 v[216:217], v[100:101], v[102:103]
		v_pk_add_f32 v[218:219], v[104:105], v[106:107]
		v_pk_add_f32 v[220:221], v[108:109], v[110:111]
		v_pk_add_f32 v[222:223], v[162:163], v[164:165]
		v_pk_add_f32 v[224:225], v[166:167], v[168:169]
		v_pk_add_f32 v[226:227], v[170:171], v[172:173]
		v_pk_add_f32 v[228:229], v[174:175], v[192:193]
		v_pk_add_f32 v[230:231], v[194:195], v[196:197]
		v_pk_add_f32 v[232:233], v[198:199], v[200:201]
		v_pk_add_f32 v[234:235], v[202:203], v[204:205]
		v_pk_add_f32 v[236:237], v[206:207], v[208:209]
		v_pk_add_f32 v[238:239], v[176:177], v[178:179]
		v_pk_add_f32 v[240:241], v[180:181], v[182:183]
		v_mov_b32_e32 v242, v189
		v_mov_b32_e32 v243, v216
		v_pk_add_f32 v[244:245], v[242:243], v[214:215]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[214:215], v[156:157], v[158:159]
		v_mov_b32_e32 v185, v215
		v_mov_b32_e32 v187, v188
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_mov_b32_e32 v242, v217
		v_mov_b32_e32 v243, v220
		v_pk_add_f32 v[216:217], v[242:243], v[218:219]
		v_mov_b32_e32 v218, v221
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[222:223]
		v_mov_b32_e32 v218, v225
		v_mov_b32_e32 v219, v228
		v_pk_add_f32 v[218:219], v[218:219], v[226:227]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[224:225], v[222:223], v[230:231]
		v_mov_b32_e32 v222, v233
		v_mov_b32_e32 v223, v236
		v_pk_add_f32 v[222:223], v[222:223], v[234:235]
		v_mov_b32_e32 v226, v237
		v_mov_b32_e32 v227, v240
		v_pk_add_f32 v[228:229], v[226:227], v[238:239]
		v_mov_b32_e32 v226, v241
		v_mov_b32_e32 v227, v244
		v_pk_add_f32 v[188:189], v[226:227], v[188:189]
		v_mov_b32_e32 v226, v245
		v_mov_b32_e32 v227, v220
		v_pk_add_f32 v[230:231], v[226:227], v[216:217]
		v_mov_b32_e32 v216, v221
		v_mov_b32_e32 v217, v224
		v_pk_add_f32 v[216:217], v[216:217], v[218:219]
		v_mov_b32_e32 v218, v225
		v_mov_b32_e32 v219, v228
		v_pk_add_f32 v[220:221], v[218:219], v[222:223]
		v_mov_b32_e32 v218, v229
		v_mov_b32_e32 v219, v230
		v_pk_add_f32 v[188:189], v[218:219], v[188:189]
		v_mov_b32_e32 v218, v231
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[222:223], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v221
		v_mov_b32_e32 v217, v222
		v_pk_add_f32 v[218:219], v[216:217], v[188:189]
		v_add_f32_e32 v1, v223, v218
		v_add_f32_e32 v1, v219, v1
		v_mov_b32_e32 v188, v1
		v_mov_b32_e32 v189, v1
		s_nop 1
		v_permlane32_swap_b32_e32 v188, v189
		v_add_f32_e32 v217, v188, v189
		v_sub_f32_e32 v1, v9, v14
		v_sub_f32_e32 v9, v11, v15
		v_exp_f32_e32 v10, v1
		v_exp_f32_e32 v188, v9
		v_mov_b32_e32 v11, v10
		v_pk_mul_f32 v[32:33], v[32:33], v[10:11]
		v_pk_mul_f32 v[34:35], v[34:35], v[10:11]
		v_pk_mul_f32 v[36:37], v[36:37], v[10:11]
		v_pk_mul_f32 v[38:39], v[38:39], v[10:11]
		v_pk_mul_f32 v[40:41], v[40:41], v[10:11]
		v_pk_mul_f32 v[42:43], v[42:43], v[10:11]
		v_pk_mul_f32 v[44:45], v[44:45], v[10:11]
		v_pk_mul_f32 v[46:47], v[46:47], v[10:11]
		v_pk_mul_f32 v[48:49], v[48:49], v[10:11]
		v_pk_mul_f32 v[50:51], v[50:51], v[10:11]
		v_pk_mul_f32 v[52:53], v[52:53], v[10:11]
		v_pk_mul_f32 v[54:55], v[54:55], v[10:11]
		v_pk_mul_f32 v[56:57], v[56:57], v[10:11]
		v_pk_mul_f32 v[58:59], v[58:59], v[10:11]
		v_pk_mul_f32 v[60:61], v[60:61], v[10:11]
		v_pk_mul_f32 v[62:63], v[62:63], v[10:11]
		v_mov_b32_e32 v189, v188
		v_pk_mul_f32 v[64:65], v[64:65], v[188:189]
		v_pk_mul_f32 v[66:67], v[66:67], v[188:189]
		v_pk_mul_f32 v[68:69], v[68:69], v[188:189]
		v_pk_mul_f32 v[70:71], v[70:71], v[188:189]
		v_pk_mul_f32 v[72:73], v[72:73], v[188:189]
		v_pk_mul_f32 v[74:75], v[74:75], v[188:189]
		v_pk_mul_f32 v[76:77], v[76:77], v[188:189]
		v_pk_mul_f32 v[78:79], v[78:79], v[188:189]
		v_pk_mul_f32 v[80:81], v[80:81], v[188:189]
		v_pk_mul_f32 v[82:83], v[82:83], v[188:189]
		v_pk_mul_f32 v[84:85], v[84:85], v[188:189]
		v_pk_mul_f32 v[86:87], v[86:87], v[188:189]
		v_pk_mul_f32 v[88:89], v[88:89], v[188:189]
		v_pk_mul_f32 v[90:91], v[90:91], v[188:189]
		v_pk_mul_f32 v[92:93], v[92:93], v[188:189]
		v_pk_mul_f32 v[94:95], v[94:95], v[188:189]
		v_mov_b32_e32 v218, v10
		v_mov_b32_e32 v219, v188
		v_mov_b32_e32 v216, v214
		v_mov_b64_e32 v[10:11], v[12:13]
		v_pk_fma_f32 v[12:13], v[10:11], v[218:219], v[216:217]
		v_cvt_pk_bf16_f32 v216, v190, v210
		v_cvt_pk_bf16_f32 v217, v191, v211
		v_cvt_pk_bf16_f32 v218, v4, v16
		v_cvt_pk_bf16_f32 v219, v5, v17
		v_cvt_pk_bf16_f32 v188, v18, v22
		v_cvt_pk_bf16_f32 v189, v19, v23
		v_cvt_pk_bf16_f32 v190, v24, v26
		v_cvt_pk_bf16_f32 v191, v25, v27
		v_cvt_pk_bf16_f32 v16, v28, v30
		v_cvt_pk_bf16_f32 v17, v29, v31
		v_cvt_pk_bf16_f32 v18, v112, v114
		v_cvt_pk_bf16_f32 v19, v113, v115
		v_cvt_pk_bf16_f32 v24, v116, v118
		v_cvt_pk_bf16_f32 v25, v117, v119
		v_cvt_pk_bf16_f32 v26, v120, v122
		v_cvt_pk_bf16_f32 v27, v121, v123
		v_cvt_pk_bf16_f32 v28, v124, v126
		v_cvt_pk_bf16_f32 v29, v125, v127
		v_cvt_pk_bf16_f32 v30, v128, v130
		v_cvt_pk_bf16_f32 v31, v129, v131
		v_cvt_pk_bf16_f32 v112, v132, v134
		v_cvt_pk_bf16_f32 v113, v133, v135
		v_cvt_pk_bf16_f32 v114, v136, v138
		v_cvt_pk_bf16_f32 v115, v137, v139
		v_cvt_pk_bf16_f32 v116, v140, v142
		v_cvt_pk_bf16_f32 v117, v141, v143
		v_cvt_pk_bf16_f32 v118, v144, v146
		v_cvt_pk_bf16_f32 v119, v145, v147
		v_cvt_pk_bf16_f32 v120, v148, v150
		v_cvt_pk_bf16_f32 v121, v149, v151
		v_cvt_pk_bf16_f32 v122, v152, v154
		v_cvt_pk_bf16_f32 v123, v153, v155
		v_cvt_pk_bf16_f32 v124, v157, v159
		v_cvt_pk_bf16_f32 v125, v160, v212
		v_cvt_pk_bf16_f32 v126, v161, v213
		v_cvt_pk_bf16_f32 v127, v96, v98
		v_cvt_pk_bf16_f32 v128, v97, v99
		v_cvt_pk_bf16_f32 v129, v100, v102
		v_cvt_pk_bf16_f32 v130, v101, v103
		v_cvt_pk_bf16_f32 v131, v104, v106
		v_cvt_pk_bf16_f32 v96, v105, v107
		v_cvt_pk_bf16_f32 v97, v108, v110
		v_cvt_pk_bf16_f32 v98, v109, v111
		v_cvt_pk_bf16_f32 v99, v162, v164
		v_cvt_pk_bf16_f32 v100, v163, v165
		v_cvt_pk_bf16_f32 v101, v166, v168
		v_cvt_pk_bf16_f32 v102, v167, v169
		v_cvt_pk_bf16_f32 v103, v170, v172
		v_cvt_pk_bf16_f32 v104, v171, v173
		v_cvt_pk_bf16_f32 v105, v174, v192
		v_cvt_pk_bf16_f32 v106, v175, v193
		v_cvt_pk_bf16_f32 v107, v194, v196
		v_cvt_pk_bf16_f32 v108, v195, v197
		v_cvt_pk_bf16_f32 v109, v198, v200
		v_cvt_pk_bf16_f32 v110, v199, v201
		v_cvt_pk_bf16_f32 v111, v202, v204
		v_cvt_pk_bf16_f32 v132, v203, v205
		v_cvt_pk_bf16_f32 v133, v206, v208
		v_cvt_pk_bf16_f32 v134, v207, v209
		v_cvt_pk_bf16_f32 v135, v176, v178
		v_cvt_pk_bf16_f32 v136, v177, v179
		v_cvt_pk_bf16_f32 v137, v180, v182
		v_cvt_pk_bf16_f32 v138, v181, v183
		v_cvt_pk_bf16_f32 v139, v184, v186
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[216:219], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[216:219], v[48:63]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[16:19], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[16:19], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[24:27], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[24:27], v[48:63]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[128:131], v[80:95]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[128:131], v[64:79]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[96:99], v[80:95]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[96:99], v[64:79]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[104:107], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[116:119], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[120:123], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[136:139], v[64:79]
		v_mov_b32_e32 v9, v14
		v_mov_b32_e32 v11, v15
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s24, s24, 0x80
		v_accvgpr_read_b32 v1, a13
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_nop 1
		v_add_u32_e32 v1, s25, v1
		v_add_u32_e32 v1, s19, v1
		v_accvgpr_read_b32 v2, a14
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_nop 1
		v_add_u32_e32 v2, s25, v2
		v_add_u32_e32 v2, s19, v2
		v_xor_b32_e32 v3, 1, v7
		v_accvgpr_write_b32 a13, v3
		v_xor_b32_e32 v3, 2, v7
		v_accvgpr_write_b32 a14, v3
		v_xor_b32_e32 v3, 3, v7
		v_accvgpr_write_b32 a66, v3
		v_xor_b32_e32 v3, 8, v7
		v_accvgpr_write_b32 a73, v3
		v_xor_b32_e32 v3, 9, v7
		v_accvgpr_write_b32 a79, v3
		v_xor_b32_e32 v3, 10, v7
		v_accvgpr_write_b32 a80, v3
		v_xor_b32_e32 v3, 11, v7
		v_accvgpr_write_b32 a81, v3
		v_xor_b32_e32 v3, 16, v7
		v_accvgpr_write_b32 a82, v3
		v_xor_b32_e32 v3, 17, v7
		v_accvgpr_write_b32 a83, v3
		v_xor_b32_e32 v3, 18, v7
		v_accvgpr_write_b32 a84, v3
		v_xor_b32_e32 v3, 19, v7
		v_accvgpr_write_b32 a85, v3
		v_xor_b32_e32 v3, 24, v7
		v_accvgpr_write_b32 a86, v3
		v_xor_b32_e32 v3, 25, v7
		v_accvgpr_write_b32 a87, v3
		v_xor_b32_e32 v3, 26, v7
		v_accvgpr_write_b32 a88, v3
		v_xor_b32_e32 v3, 27, v7
		v_accvgpr_write_b32 a89, v3
		v_xor_b32_e32 v3, 32, v7
		v_accvgpr_write_b32 a90, v3
		v_xor_b32_e32 v3, 33, v7
		v_accvgpr_write_b32 a91, v3
		v_xor_b32_e32 v3, 34, v7
		v_accvgpr_write_b32 a92, v3
		v_xor_b32_e32 v3, 35, v7
		v_accvgpr_write_b32 a93, v3
		v_xor_b32_e32 v3, 40, v7
		v_accvgpr_write_b32 a94, v3
		v_xor_b32_e32 v3, 41, v7
		v_accvgpr_write_b32 a95, v3
		v_xor_b32_e32 v3, 42, v7
		v_accvgpr_write_b32 a96, v3
		v_xor_b32_e32 v3, 43, v7
		v_accvgpr_write_b32 a97, v3
		v_xor_b32_e32 v3, 48, v7
		v_accvgpr_write_b32 a98, v3
		v_xor_b32_e32 v3, 49, v7
		v_accvgpr_write_b32 a99, v3
		v_xor_b32_e32 v3, 50, v7
		v_accvgpr_write_b32 a100, v3
		v_xor_b32_e32 v3, 51, v7
		v_accvgpr_write_b32 a101, v3
		v_xor_b32_e32 v3, 56, v7
		v_accvgpr_write_b32 a102, v3
		v_xor_b32_e32 v3, 57, v7
		v_accvgpr_write_b32 a103, v3
		v_xor_b32_e32 v3, 58, v7
		v_accvgpr_write_b32 a104, v3
		v_xor_b32_e32 v3, 59, v7
		v_accvgpr_write_b32 a105, v3
		v_xor_b32_e32 v3, 64, v7
		v_accvgpr_write_b32 a106, v3
		v_xor_b32_e32 v3, 0x41, v7
		v_accvgpr_write_b32 a107, v3
		v_xor_b32_e32 v3, 0x42, v7
		v_accvgpr_write_b32 a108, v3
		v_xor_b32_e32 v3, 0x43, v7
		v_accvgpr_write_b32 a109, v3
		v_xor_b32_e32 v3, 0x48, v7
		v_accvgpr_write_b32 a110, v3
		v_xor_b32_e32 v3, 0x49, v7
		v_accvgpr_write_b32 a111, v3
		v_xor_b32_e32 v3, 0x4a, v7
		v_accvgpr_write_b32 a112, v3
		v_xor_b32_e32 v3, 0x4b, v7
		v_accvgpr_write_b32 a113, v3
		v_xor_b32_e32 v3, 0x50, v7
		v_accvgpr_write_b32 a114, v3
		v_xor_b32_e32 v3, 0x51, v7
		v_accvgpr_write_b32 a115, v3
		v_xor_b32_e32 v3, 0x52, v7
		v_accvgpr_write_b32 a116, v3
		v_xor_b32_e32 v3, 0x53, v7
		v_accvgpr_write_b32 a117, v3
		v_xor_b32_e32 v3, 0x58, v7
		v_accvgpr_write_b32 a118, v3
		v_xor_b32_e32 v3, 0x59, v7
		v_accvgpr_write_b32 a119, v3
		v_xor_b32_e32 v3, 0x5a, v7
		v_accvgpr_write_b32 a120, v3
		v_xor_b32_e32 v3, 0x5b, v7
		v_accvgpr_write_b32 a121, v3
		v_xor_b32_e32 v3, 0x60, v7
		v_accvgpr_write_b32 a122, v3
		v_xor_b32_e32 v3, 0x61, v7
		v_accvgpr_write_b32 a123, v3
		v_xor_b32_e32 v3, 0x62, v7
		v_accvgpr_write_b32 a124, v3
		v_xor_b32_e32 v3, 0x63, v7
		v_accvgpr_write_b32 a125, v3
		v_xor_b32_e32 v3, 0x68, v7
		v_accvgpr_write_b32 a126, v3
		v_xor_b32_e32 v3, 0x69, v7
		v_accvgpr_write_b32 a127, v3
		v_xor_b32_e32 v3, 0x6a, v7
		v_accvgpr_write_b32 a128, v3
		v_xor_b32_e32 v3, 0x6b, v7
		v_accvgpr_write_b32 a129, v3
		v_xor_b32_e32 v3, 0x70, v7
		v_accvgpr_write_b32 a130, v3
		v_xor_b32_e32 v3, 0x71, v7
		v_accvgpr_write_b32 a131, v3
		v_xor_b32_e32 v3, 0x72, v7
		v_accvgpr_write_b32 a132, v3
		v_xor_b32_e32 v3, 0x73, v7
		v_accvgpr_write_b32 a133, v3
		v_xor_b32_e32 v3, 0x78, v7
		v_accvgpr_write_b32 a134, v3
		v_xor_b32_e32 v3, 0x79, v7
		v_accvgpr_write_b32 a135, v3
		v_xor_b32_e32 v3, 0x7a, v7
		v_accvgpr_write_b32 a136, v3
		v_xor_b32_e32 v3, 0x7b, v7
		v_accvgpr_write_b32 a137, v3
		v_accvgpr_read_b32 v3, a24
		v_accvgpr_read_b32 v4, a67
		v_lshl_add_u32 v3, v3, 4, v4
		v_accvgpr_read_b32 v4, a68
		v_accvgpr_read_b32 v5, a69
		v_add3_u32 v3, v3, v4, v5
		v_accvgpr_read_b32 v4, a70
		v_accvgpr_read_b32 v5, a71
		v_add3_u32 v3, v3, v4, v5
		v_accvgpr_write_b32 a24, v3
		v_accvgpr_read_b32 v3, a72
		v_accvgpr_read_b32 v4, a74
		v_lshl_add_u32 v3, v3, 3, v4
		v_accvgpr_read_b32 v4, a75
		v_accvgpr_read_b32 v5, a76
		v_add3_u32 v3, v3, v4, v5
		v_accvgpr_write_b32 a67, v3
		v_mov_b32_e32 v3, 0xff800000
		s_cmp_lt_i32 s43, s24
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
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
		s_add_i32 s50, s25, s39
		s_mul_i32 s25, 0x4100, s37
		v_accvgpr_read_b32 v4, a24
		v_add_u32_e32 v4, s25, v4
		ds_read_b128 v[16:19], v4
		ds_read_b128 a[68:71], v4 offset:32
		ds_read_b128 a[140:143], v4 offset:64
		ds_read_b128 a[144:147], v4 offset:96
		ds_read_b128 a[148:151], v4 offset:256
		ds_read_b128 a[152:155], v4 offset:288
		ds_read_b128 a[156:159], v4 offset:320
		ds_read_b128 a[160:163], v4 offset:352
		ds_read_b128 a[164:167], v4 offset:128
		ds_read_b128 a[168:171], v4 offset:160
		ds_read_b128 a[172:175], v4 offset:192
		ds_read_b128 a[176:179], v4 offset:224
		ds_read_b128 v[24:27], v4 offset:384
		ds_read_b128 a[180:183], v4 offset:416
		ds_read_b128 a[184:187], v4 offset:448
		ds_read_b128 a[188:191], v4 offset:480
		s_mul_i32 s25, 0x4400, s37
		v_accvgpr_read_b32 v4, a67
		v_add_u32_e32 v4, s25, v4
		ds_read_b64_tr_b16 a[192:193], v4 offset:33264
		ds_read_b64_tr_b16 a[194:195], v4 offset:37616
		ds_read_b64_tr_b16 a[196:197], v4 offset:33392
		ds_read_b64_tr_b16 a[198:199], v4 offset:37744
		ds_read_b64_tr_b16 a[200:201], v4 offset:33520
		ds_read_b64_tr_b16 a[202:203], v4 offset:37872
		ds_read_b64_tr_b16 a[204:205], v4 offset:33648
		ds_read_b64_tr_b16 a[206:207], v4 offset:38000
		ds_read_b64_tr_b16 a[208:209], v4 offset:33776
		ds_read_b64_tr_b16 a[210:211], v4 offset:38128
		ds_read_b64_tr_b16 a[212:213], v4 offset:33904
		ds_read_b64_tr_b16 a[214:215], v4 offset:38256
		ds_read_b64_tr_b16 a[216:217], v4 offset:34032
		ds_read_b64_tr_b16 a[218:219], v4 offset:38384
		ds_read_b64_tr_b16 a[220:221], v4 offset:34160
		ds_read_b64_tr_b16 a[222:223], v4 offset:38512
		ds_read_b64_tr_b16 a[224:225], v4 offset:33328
		ds_read_b64_tr_b16 a[226:227], v4 offset:37680
		ds_read_b64_tr_b16 a[228:229], v4 offset:33456
		ds_read_b64_tr_b16 a[230:231], v4 offset:37808
		ds_read_b64_tr_b16 a[232:233], v4 offset:33584
		ds_read_b64_tr_b16 a[234:235], v4 offset:37936
		ds_read_b64_tr_b16 a[236:237], v4 offset:33712
		ds_read_b64_tr_b16 a[238:239], v4 offset:38064
		ds_read_b64_tr_b16 a[240:241], v4 offset:33840
		ds_read_b64_tr_b16 a[242:243], v4 offset:38192
		ds_read_b64_tr_b16 a[244:245], v4 offset:33968
		ds_read_b64_tr_b16 a[246:247], v4 offset:38320
		ds_read_b64_tr_b16 a[248:249], v4 offset:34096
		ds_read_b64_tr_b16 a[250:251], v4 offset:38448
		ds_read_b64_tr_b16 a[252:253], v4 offset:34224
		ds_read_b64_tr_b16 a[254:255], v4 offset:38576
		s_cmp_lt_i32 s19, s22
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v4, a25
		v_add_u32_e32 v4, s19, v4
		v_accvgpr_read_b32 v5, a64
		v_add_u32_e32 v5, s19, v5
		v_accvgpr_read_b32 v10, a65
		v_add_u32_e32 v10, s19, v10
		v_accvgpr_read_b32 v14, a60
		v_add_u32_e32 v14, s19, v14
		v_cmp_lt_i32_e64 vcc, v4, s21
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v10, s21
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v4, a26
		v_add_u32_e32 v4, s19, v4
		v_accvgpr_read_b32 v5, a61
		v_add_u32_e32 v5, s19, v5
		v_accvgpr_read_b32 v10, a62
		v_add_u32_e32 v10, s19, v10
		v_cmp_lt_i32_e64 vcc, v4, s21
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v10, s21
		s_mov_b64 s[64:65], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s43
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s44, s25
		v_add_u32_e32 v4, s37, v8
		s_mov_b32 s66, 1
		s_mov_b32 s67, 0
		s_mov_b32 s39, 0
		s_mul_i32 s68, s66, s38
		s_mul_hi_u32 s69, s66, s38
		s_mul_i32 s37, s66, s39
		s_add_i32 s69, s69, s37
		s_mul_i32 s37, s67, s38
		s_add_i32 s69, s69, s37
		s_lshr_b64 s[66:67], s[68:69], 6
		s_mov_b32 s68, 0x410
		s_mov_b32 s69, 0
		s_mul_i32 s70, s68, s66
		s_mul_hi_u32 s71, s68, s66
		s_mul_i32 s37, s68, s67
		s_add_i32 s71, s71, s37
		s_mul_i32 s37, s69, s66
		s_add_i32 s71, s71, s37
		s_cmp_lt_i32 s50, 0
		s_cselect_b32 s51, -1, 0
		s_mov_b32 s68, 0x4100
		s_mov_b32 s69, 0
		s_mul_i32 s72, s68, s50
		s_mul_hi_u32 s73, s68, s50
		s_mul_i32 s37, s68, s51
		s_add_i32 s73, s73, s37
		s_mul_i32 s37, s69, s50
		s_add_i32 s73, s73, s37
		s_add_u32 s68, s70, s72
		s_addc_u32 s69, s71, s73
		s_add_u32 s74, s68, 0
		s_addc_u32 s75, s69, 0
		s_mov_b32 m0, s74
		v_cndmask_b32_e64 v4, v20, v4, s[52:53]
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v4, a63
		v_add_u32_e32 v4, s19, v4
		s_add_i32 s19, s45, s25
		v_add_u32_e32 v5, s19, v8
		s_add_u32 s52, s70, 0x1040
		s_addc_u32 s53, s71, 0
		s_add_u32 s52, s52, s72
		s_addc_u32 s53, s53, s73
		s_add_u32 s68, s52, 0
		s_addc_u32 s69, s53, 0
		s_mov_b32 m0, s68
		v_cndmask_b32_e64 v5, v20, v5, s[54:55]
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 s19, s46, s25
		v_add_u32_e32 v5, s19, v8
		s_add_u32 s52, s70, 0x2080
		s_addc_u32 s53, s71, 0
		s_add_u32 s52, s52, s72
		s_addc_u32 s53, s53, s73
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v5, v20, v5, s[56:57]
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 s19, s40, s25
		v_add_u32_e32 v5, s19, v8
		s_add_u32 s52, s70, 0x30c0
		s_addc_u32 s53, s71, 0
		s_add_u32 s52, s52, s72
		s_addc_u32 s53, s53, s73
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v5, v20, v5, s[58:59]
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_mul_i32 s19, s17, s43
		s_lshl_b32 s19, s19, 1
		s_add_i32 s25, s47, s19
		v_add_u32_e32 v5, s25, v6
		s_mov_b32 s52, 0x440
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s66
		s_mul_hi_u32 s55, s52, s66
		s_mul_i32 s25, s52, s67
		s_add_i32 s55, s55, s25
		s_mul_i32 s25, s53, s66
		s_add_i32 s55, s55, s25
		s_add_u32 s52, s54, 0x81f0
		s_addc_u32 s53, s55, 0
		s_mov_b32 s56, 0x4400
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s50
		s_mul_hi_u32 s59, s56, s50
		s_mul_i32 s25, s56, s51
		s_add_i32 s59, s59, s25
		s_mul_i32 s25, s57, s50
		s_add_i32 s59, s59, s25
		s_add_u32 s50, s52, s58
		s_addc_u32 s51, s53, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v5, v20, v5, s[60:61]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s25, s48, s19
		v_add_u32_e32 v5, s25, v6
		s_add_u32 s50, s54, 0x92f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v5, v20, v5, s[62:63]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s25, s49, s19
		v_add_u32_e32 v5, s25, v6
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v5, v20, v5, s[64:65]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s19, s36, s19
		v_cmp_lt_i32_e64 vcc, v4, s21
		v_add_u32_e32 v4, s19, v6
		s_add_u32 s50, s54, 0xb4f0
		s_addc_u32 s51, s55, 0
		v_cndmask_b32_e32 v4, v20, v4, vcc
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[16:19], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[16:19], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[68:71], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[52:55], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[56:59], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[56:59], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[56:59], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[56:59], v[208:223]
		v_add_u32_e32 v4, s43, v7
		v_accvgpr_read_b32 v5, a13
		v_add_u32_e32 v5, s43, v5
		v_accvgpr_read_b32 v10, a14
		v_add_u32_e32 v10, s43, v10
		v_accvgpr_read_b32 v14, a66
		v_add_u32_e32 v14, s43, v14
		v_accvgpr_read_b32 v15, a80
		v_add_u32_e32 v15, s43, v15
		v_accvgpr_read_b32 v16, a81
		v_add_u32_e32 v16, s43, v16
		v_accvgpr_read_b32 v17, a84
		v_add_u32_e32 v17, s43, v17
		v_accvgpr_read_b32 v18, a85
		v_add_u32_e32 v18, s43, v18
		v_accvgpr_read_b32 v19, a88
		v_add_u32_e32 v19, s43, v19
		v_accvgpr_read_b32 v21, a89
		v_add_u32_e32 v21, s43, v21
		v_accvgpr_read_b32 v22, a92
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_read_b32 v23, a93
		v_add_u32_e32 v23, s43, v23
		v_accvgpr_read_b32 v24, a96
		v_add_u32_e32 v24, s43, v24
		v_accvgpr_read_b32 v25, a97
		v_add_u32_e32 v25, s43, v25
		v_accvgpr_read_b32 v26, a100
		v_add_u32_e32 v26, s43, v26
		v_accvgpr_read_b32 v27, a101
		v_add_u32_e32 v27, s43, v27
		v_accvgpr_read_b32 v28, a104
		v_add_u32_e32 v28, s43, v28
		v_accvgpr_read_b32 v29, a105
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a68, v29
		v_accvgpr_read_b32 v29, a108
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a69, v29
		v_accvgpr_read_b32 v29, a109
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a70, v29
		v_accvgpr_read_b32 v29, a112
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a71, v29
		v_accvgpr_read_b32 v29, a113
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a72, v29
		v_accvgpr_read_b32 v29, a116
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a74, v29
		v_accvgpr_read_b32 v29, a117
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a75, v29
		v_accvgpr_read_b32 v29, a120
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a76, v29
		v_accvgpr_read_b32 v29, a121
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a138, v29
		v_accvgpr_read_b32 v29, a124
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a139, v29
		v_accvgpr_read_b32 v29, a125
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a140, v29
		v_accvgpr_read_b32 v29, a128
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a141, v29
		v_accvgpr_read_b32 v29, a129
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a142, v29
		v_accvgpr_read_b32 v29, a132
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a143, v29
		v_accvgpr_read_b32 v29, a133
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a144, v29
		v_accvgpr_read_b32 v29, a136
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a145, v29
		v_accvgpr_read_b32 v29, a137
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a146, v29
		v_cmp_ge_i32_e64 vcc, v1, v4
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v1, v5
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v10
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v1, v14
		v_accvgpr_read_b32 v29, a73
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_read_b32 v30, a79
		v_add_u32_e32 v30, s43, v30
		v_cndmask_b32_e32 v225, v3, v99, vcc
		v_cmp_ge_i32_e64 vcc, v1, v29
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v1, v30
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v1, v15
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_accvgpr_read_b32 v31, a82
		v_add_u32_e32 v31, s43, v31
		v_accvgpr_read_b32 v99, a83
		v_add_u32_e32 v99, s43, v99
		v_cndmask_b32_e32 v227, v3, v103, vcc
		v_cmp_ge_i32_e64 vcc, v1, v31
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v1, v99
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v1, v17
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v1, v18
		v_accvgpr_read_b32 v103, a86
		v_add_u32_e32 v103, s43, v103
		v_accvgpr_read_b32 v224, a87
		v_add_u32_e32 v228, s43, v224
		v_cndmask_b32_e32 v231, v3, v107, vcc
		v_cmp_ge_i32_e64 vcc, v1, v103
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v1, v228
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v1, v19
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v1, v21
		v_accvgpr_read_b32 v107, a90
		v_add_u32_e32 v107, s43, v107
		v_accvgpr_read_b32 v224, a91
		v_add_u32_e32 v229, s43, v224
		v_cndmask_b32_e32 v233, v3, v111, vcc
		v_cmp_ge_i32_e64 vcc, v1, v107
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v1, v229
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v1, v22
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v1, v23
		v_accvgpr_read_b32 v111, a94
		v_add_u32_e32 v111, s43, v111
		v_accvgpr_read_b32 v224, a95
		v_add_u32_e32 v234, s43, v224
		v_cndmask_b32_e32 v237, v3, v115, vcc
		v_cmp_ge_i32_e64 vcc, v1, v111
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v1, v234
		s_mov_b64 s[82:83], vcc
		v_cmp_ge_i32_e64 vcc, v1, v24
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_write_b32 a148, v238
		v_accvgpr_write_b32 a149, v239
		v_cmp_ge_i32_e64 vcc, v1, v25
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_read_b32 v115, a98
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_read_b32 v224, a99
		v_add_u32_e32 v235, s43, v224
		v_cndmask_b32_e32 v239, v3, v119, vcc
		v_cmp_ge_i32_e64 vcc, v1, v115
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_cmp_ge_i32_e64 vcc, v1, v235
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a152, v240
		v_accvgpr_write_b32 a153, v241
		v_cmp_ge_i32_e64 vcc, v1, v26
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a154, v240
		v_accvgpr_write_b32 a155, v241
		v_cmp_ge_i32_e64 vcc, v1, v27
		v_accvgpr_read_b32 v119, a102
		v_add_u32_e32 v119, s43, v119
		v_accvgpr_read_b32 v224, a103
		v_add_u32_e32 v238, s43, v224
		v_cndmask_b32_e32 v241, v3, v123, vcc
		v_cmp_ge_i32_e64 vcc, v1, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a156, v242
		v_accvgpr_write_b32 a157, v243
		v_cmp_ge_i32_e64 vcc, v1, v238
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a158, v242
		v_accvgpr_write_b32 a159, v243
		v_cmp_ge_i32_e64 vcc, v1, v28
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v123, a68
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_read_b32 v123, a106
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_write_b32 a147, v123
		v_accvgpr_read_b32 v123, a107
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_write_b32 a162, v123
		v_cndmask_b32_e32 v243, v3, v127, vcc
		v_accvgpr_read_b32 v123, a147
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_accvgpr_read_b32 v123, a162
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v123, a69
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v123, a70
		v_cmp_ge_i32_e64 vcc, v1, v123
		v_accvgpr_read_b32 v123, a110
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_write_b32 a163, v123
		v_accvgpr_read_b32 v123, a111
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_write_b32 a170, v123
		v_cndmask_b32_e32 v245, v3, v131, vcc
		v_accvgpr_read_b32 v123, a163
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a172, v246
		v_accvgpr_write_b32 a173, v247
		v_accvgpr_read_b32 v123, a170
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v123, a71
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v123, a72
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_read_b32 v123, a114
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_write_b32 a171, v123
		v_accvgpr_read_b32 v123, a115
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_write_b32 a178, v123
		v_cndmask_b32_e32 v247, v3, v135, vcc
		v_accvgpr_read_b32 v123, a171
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a180, v248
		v_accvgpr_write_b32 a181, v249
		v_accvgpr_read_b32 v123, a178
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v123, a74
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a184, v248
		v_accvgpr_write_b32 a185, v249
		v_accvgpr_read_b32 v123, a75
		v_cmp_ge_i32_e64 vcc, v1, v123
		v_accvgpr_read_b32 v123, a118
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_write_b32 a179, v123
		v_accvgpr_read_b32 v123, a119
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_write_b32 a186, v123
		v_cndmask_b32_e32 v249, v3, v139, vcc
		v_accvgpr_read_b32 v123, a179
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v250, s84
		v_mov_b32_e32 v251, s85
		v_accvgpr_write_b32 a188, v250
		v_accvgpr_write_b32 a189, v251
		v_accvgpr_read_b32 v123, a186
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v123, a76
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[86:87], vcc
		v_cndmask_b32_e64 v251, v3, v141, s[84:85]
		v_cndmask_b32_e64 v252, v3, v142, s[86:87]
		v_accvgpr_read_b32 v123, a138
		v_cmp_ge_i32_e64 vcc, v1, v123
		v_accvgpr_read_b32 v123, a122
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_read_b32 v127, a123
		v_add_u32_e32 v127, s43, v127
		v_cndmask_b32_e32 v253, v3, v143, vcc
		v_cmp_ge_i32_e64 vcc, v1, v123
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v1, v127
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v131, a139
		v_cmp_ge_i32_e64 vcc, v1, v131
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v142, v3, v144, s[84:85]
		v_cndmask_b32_e64 v143, v3, v145, s[86:87]
		v_cndmask_b32_e64 v144, v3, v146, s[88:89]
		v_accvgpr_read_b32 v131, a140
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a126
		v_add_u32_e32 v131, s43, v131
		v_accvgpr_read_b32 v135, a127
		v_add_u32_e32 v135, s43, v135
		v_cndmask_b32_e32 v145, v3, v147, vcc
		v_cmp_ge_i32_e64 vcc, v1, v131
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v1, v135
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v139, a141
		v_cmp_ge_i32_e64 vcc, v1, v139
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v146, v3, v148, s[84:85]
		v_cndmask_b32_e64 v147, v3, v149, s[86:87]
		v_cndmask_b32_e64 v148, v3, v150, s[88:89]
		v_accvgpr_read_b32 v139, a142
		v_cmp_ge_i32_e64 vcc, v1, v139
		v_accvgpr_read_b32 v139, a130
		v_add_u32_e32 v139, s43, v139
		v_accvgpr_read_b32 v141, a131
		v_add_u32_e32 v141, s43, v141
		v_accvgpr_write_b32 a187, v141
		v_cndmask_b32_e32 v149, v3, v151, vcc
		v_cmp_ge_i32_e64 vcc, v1, v139
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v141, a187
		v_cmp_ge_i32_e64 vcc, v1, v141
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v141, a143
		v_cmp_ge_i32_e64 vcc, v1, v141
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v150, v3, v152, s[84:85]
		v_cndmask_b32_e64 v151, v3, v153, s[86:87]
		v_cndmask_b32_e64 v152, v3, v154, s[88:89]
		v_accvgpr_read_b32 v141, a144
		v_cmp_ge_i32_e64 vcc, v1, v141
		v_accvgpr_read_b32 v141, a134
		v_add_u32_e32 v141, s43, v141
		v_accvgpr_write_b32 a190, v141
		v_accvgpr_read_b32 v141, a135
		v_add_u32_e32 v141, s43, v141
		v_accvgpr_write_b32 a191, v141
		v_cndmask_b32_e32 v153, v3, v155, vcc
		v_accvgpr_read_b32 v141, a190
		v_cmp_ge_i32_e64 vcc, v1, v141
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v141, a191
		v_cmp_ge_i32_e64 vcc, v1, v141
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v141, a145
		v_cmp_ge_i32_e64 vcc, v1, v141
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v154, v3, v156, s[84:85]
		v_cndmask_b32_e64 v155, v3, v157, s[86:87]
		v_cndmask_b32_e64 v156, v3, v158, s[88:89]
		v_accvgpr_read_b32 v141, a146
		v_cmp_ge_i32_e64 vcc, v1, v141
		v_mov_b32_e32 v141, 0xff800000
		v_cndmask_b32_e64 v254, v141, v96, s[50:51]
		v_cndmask_b32_e64 v255, v141, v97, s[52:53]
		v_cndmask_b32_e32 v157, v141, v159, vcc
		v_cmp_ge_i32_e64 vcc, v2, v4
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v5
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[84:85], vcc
		v_cndmask_b32_e64 v4, v141, v176, s[50:51]
		v_cndmask_b32_e64 v5, v141, v177, s[52:53]
		v_cndmask_b32_e64 v96, v141, v178, s[84:85]
		v_cmp_ge_i32_e64 vcc, v2, v14
		v_cndmask_b32_e64 v224, v141, v98, s[54:55]
		v_cndmask_b32_e64 v158, v141, v100, s[56:57]
		v_cndmask_b32_e32 v97, v141, v179, vcc
		v_cmp_ge_i32_e64 vcc, v2, v29
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v30
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v2, v15
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v14, v141, v180, s[50:51]
		v_cndmask_b32_e64 v15, v141, v181, s[52:53]
		v_cndmask_b32_e64 v176, v141, v182, s[54:55]
		v_cmp_ge_i32_e64 vcc, v2, v16
		v_cndmask_b32_e64 v159, v141, v101, s[58:59]
		v_cndmask_b32_e64 v226, v141, v102, s[60:61]
		v_cndmask_b32_e32 v177, v141, v183, vcc
		v_cmp_ge_i32_e64 vcc, v2, v31
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v99
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v2, v17
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v16, v141, v184, s[50:51]
		v_cndmask_b32_e64 v17, v141, v185, s[52:53]
		v_cndmask_b32_e64 v30, v141, v186, s[54:55]
		v_cmp_ge_i32_e64 vcc, v2, v18
		v_cndmask_b32_e64 v98, v141, v104, s[62:63]
		v_cndmask_b32_e64 v99, v141, v105, s[64:65]
		v_cndmask_b32_e32 v31, v141, v187, vcc
		v_cmp_ge_i32_e64 vcc, v2, v103
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v228
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v2, v19
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v18, v141, v188, s[50:51]
		v_cndmask_b32_e64 v19, v141, v189, s[52:53]
		v_cndmask_b32_e64 v100, v141, v190, s[54:55]
		v_cmp_ge_i32_e64 vcc, v2, v21
		v_cndmask_b32_e64 v230, v141, v106, s[66:67]
		v_cndmask_b32_e64 v102, v141, v108, s[68:69]
		v_cndmask_b32_e32 v101, v141, v191, vcc
		v_cmp_ge_i32_e64 vcc, v2, v107
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v229
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v2, v22
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v104, v141, v192, s[50:51]
		v_cndmask_b32_e64 v105, v141, v193, s[52:53]
		v_cndmask_b32_e64 v106, v141, v194, s[54:55]
		v_cmp_ge_i32_e64 vcc, v2, v23
		v_cndmask_b32_e64 v103, v141, v109, s[70:71]
		v_cndmask_b32_e64 v232, v141, v110, s[72:73]
		v_cndmask_b32_e32 v107, v141, v195, vcc
		v_cmp_ge_i32_e64 vcc, v2, v111
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v234
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v2, v24
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v22, v141, v196, s[50:51]
		v_cndmask_b32_e64 v23, v141, v197, s[52:53]
		v_cndmask_b32_e64 v108, v141, v198, s[54:55]
		v_cmp_ge_i32_e64 vcc, v2, v25
		v_cndmask_b32_e64 v24, v141, v112, s[74:75]
		v_cndmask_b32_e64 v25, v141, v113, s[76:77]
		v_cndmask_b32_e32 v109, v141, v199, vcc
		v_cmp_ge_i32_e64 vcc, v2, v115
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v235
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v2, v26
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v110, v141, v200, s[50:51]
		v_cndmask_b32_e64 v111, v141, v201, s[52:53]
		v_cndmask_b32_e64 v112, v141, v202, s[54:55]
		v_cmp_ge_i32_e64 vcc, v2, v27
		v_cndmask_b32_e64 v236, v141, v114, s[78:79]
		v_cndmask_b32_e64 v26, v141, v116, s[80:81]
		v_cndmask_b32_e32 v113, v141, v203, vcc
		v_cmp_ge_i32_e64 vcc, v2, v119
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v238
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v2, v28
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v28, v141, v204, s[50:51]
		v_cndmask_b32_e64 v29, v141, v205, s[52:53]
		v_cndmask_b32_e64 v114, v141, v206, s[54:55]
		v_accvgpr_read_b32 v10, a68
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_cndmask_b32_e64 v27, v141, v117, s[82:83]
		v_accvgpr_read_b32 v10, a148
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a149
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v238, v141, v118, s[50:51]
		v_cndmask_b32_e32 v115, v141, v207, vcc
		v_accvgpr_read_b32 v10, a147
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a162
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v10, a69
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v116, v141, v208, s[50:51]
		v_cndmask_b32_e64 v117, v141, v209, s[52:53]
		v_cndmask_b32_e64 v118, v141, v210, s[54:55]
		v_accvgpr_read_b32 v10, a70
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_accvgpr_read_b32 v10, a150
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a151
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v178, v141, v120, s[50:51]
		v_accvgpr_read_b32 v10, a152
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a153
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v179, v141, v121, s[50:51]
		v_cndmask_b32_e32 v119, v141, v211, vcc
		v_accvgpr_read_b32 v10, a163
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a170
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v10, a71
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v120, v141, v212, s[50:51]
		v_cndmask_b32_e64 v121, v141, v213, s[52:53]
		v_cndmask_b32_e64 v180, v141, v214, s[54:55]
		v_accvgpr_read_b32 v10, a72
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_accvgpr_read_b32 v10, a154
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a155
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v240, v141, v122, s[50:51]
		v_accvgpr_read_b32 v10, a156
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a157
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v182, v141, v124, s[50:51]
		v_cndmask_b32_e32 v181, v141, v215, vcc
		v_accvgpr_read_b32 v10, a171
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a178
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v10, a74
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v184, v141, v216, s[50:51]
		v_cndmask_b32_e64 v185, v141, v217, s[52:53]
		v_cndmask_b32_e64 v186, v141, v218, s[54:55]
		v_accvgpr_read_b32 v10, a75
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_accvgpr_read_b32 v10, a158
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a159
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v183, v141, v125, s[50:51]
		v_accvgpr_read_b32 v10, a160
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a161
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v242, v141, v126, s[50:51]
		v_cndmask_b32_e32 v187, v141, v219, vcc
		v_accvgpr_read_b32 v10, a179
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a186
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v10, a76
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v124, v141, v220, s[50:51]
		v_cndmask_b32_e64 v125, v141, v221, s[52:53]
		v_cndmask_b32_e64 v188, v141, v222, s[54:55]
		v_accvgpr_read_b32 v10, a138
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_accvgpr_read_b32 v10, a164
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a165
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v190, v141, v128, s[50:51]
		v_accvgpr_read_b32 v10, a166
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a167
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v191, v141, v129, s[50:51]
		v_cndmask_b32_e32 v189, v141, v223, vcc
		v_cmp_ge_i32_e64 vcc, v2, v123
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v127
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v10, a139
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v122, v141, v160, s[50:51]
		v_cndmask_b32_e64 v123, v141, v161, s[52:53]
		v_cndmask_b32_e64 v126, v141, v162, s[54:55]
		v_accvgpr_read_b32 v10, a140
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_accvgpr_read_b32 v10, a168
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a169
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v244, v141, v130, s[50:51]
		v_accvgpr_read_b32 v10, a172
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a173
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v128, v141, v132, s[50:51]
		v_cndmask_b32_e32 v127, v141, v163, vcc
		v_cmp_ge_i32_e64 vcc, v2, v131
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v2, v135
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v10, a141
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v130, v141, v164, s[50:51]
		v_cndmask_b32_e64 v131, v141, v165, s[52:53]
		v_cndmask_b32_e64 v160, v141, v166, s[54:55]
		v_accvgpr_read_b32 v10, a142
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_accvgpr_read_b32 v10, a174
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a175
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v129, v141, v133, s[50:51]
		v_accvgpr_read_b32 v10, a176
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a177
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v246, v141, v134, s[50:51]
		v_cndmask_b32_e32 v161, v141, v167, vcc
		v_cmp_ge_i32_e64 vcc, v2, v139
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a187
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v10, a143
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v132, v141, v168, s[50:51]
		v_cndmask_b32_e64 v133, v141, v169, s[52:53]
		v_cndmask_b32_e64 v134, v141, v170, s[54:55]
		v_accvgpr_read_b32 v10, a144
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_accvgpr_read_b32 v10, a180
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a181
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v162, v141, v136, s[50:51]
		v_accvgpr_read_b32 v10, a182
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a183
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v163, v141, v137, s[50:51]
		v_cndmask_b32_e32 v135, v141, v171, vcc
		v_accvgpr_read_b32 v10, a190
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a191
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v10, a145
		v_cmp_ge_i32_e64 vcc, v2, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v136, v141, v172, s[50:51]
		v_cndmask_b32_e64 v137, v141, v173, s[52:53]
		v_cndmask_b32_e64 v164, v141, v174, s[54:55]
		v_accvgpr_read_b32 v10, a146
		v_cmp_ge_i32_e64 vcc, v2, v10
		v_accvgpr_read_b32 v10, a184
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a185
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v248, v141, v138, s[50:51]
		v_accvgpr_read_b32 v10, a188
		s_nop 0
		v_readfirstlane_b32 s50, v10
		v_accvgpr_read_b32 v10, a189
		s_nop 0
		v_readfirstlane_b32 s51, v10
		s_nop 1
		v_cndmask_b32_e64 v250, v141, v140, s[50:51]
		v_cndmask_b32_e32 v165, v141, v175, vcc
		v_max3_f32 v10, v254, v255, v224
		v_max3_f32 v21, v158, v159, v226
		v_max3_f32 v138, v98, v99, v230
		v_max3_f32 v139, v102, v103, v232
		v_max3_f32 v140, v24, v25, v236
		v_max3_f32 v141, v26, v27, v238
		v_max3_f32 v166, v178, v179, v240
		v_max3_f32 v167, v182, v183, v242
		v_max3_f32 v168, v190, v191, v244
		v_max3_f32 v169, v128, v129, v246
		v_max3_f32 v170, v162, v163, v248
		v_max3_f32 v171, v250, v251, v252
		v_max3_f32 v172, v142, v143, v144
		v_max3_f32 v173, v146, v147, v148
		v_max3_f32 v174, v150, v151, v152
		v_max3_f32 v175, v154, v155, v156
		v_max3_f32 v10, v10, v225, v21
		v_max3_f32 v21, v138, v231, v139
		v_max3_f32 v138, v140, v237, v141
		v_max3_f32 v139, v166, v241, v167
		v_max3_f32 v140, v168, v245, v169
		v_max3_f32 v141, v170, v249, v171
		v_max3_f32 v166, v172, v145, v173
		v_max3_f32 v167, v174, v153, v175
		v_max3_f32 v10, v10, v227, v21
		v_max3_f32 v21, v138, v239, v139
		v_max3_f32 v138, v140, v247, v141
		v_max3_f32 v139, v166, v149, v167
		v_max3_f32 v10, v10, v233, v21
		v_max3_f32 v21, v138, v253, v139
		v_max3_f32 v10, v10, v243, v21
		v_max_f32_e32 v10, v10, v157
		v_mov_b32_e32 v138, v10
		v_mov_b32_e32 v139, v10
		s_nop 1
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v140, v138, v139
		v_max3_f32 v10, v4, v5, v96
		v_max3_f32 v21, v14, v15, v176
		v_max3_f32 v138, v16, v17, v30
		v_max3_f32 v139, v18, v19, v100
		v_max3_f32 v141, v104, v105, v106
		v_max3_f32 v166, v22, v23, v108
		v_max3_f32 v167, v110, v111, v112
		v_max3_f32 v168, v28, v29, v114
		v_max3_f32 v169, v116, v117, v118
		v_max3_f32 v170, v120, v121, v180
		v_max3_f32 v171, v184, v185, v186
		v_max3_f32 v172, v124, v125, v188
		v_max3_f32 v173, v122, v123, v126
		v_max3_f32 v174, v130, v131, v160
		v_max3_f32 v175, v132, v133, v134
		v_max3_f32 v192, v136, v137, v164
		v_max3_f32 v10, v10, v97, v21
		v_max3_f32 v21, v138, v31, v139
		v_max3_f32 v138, v141, v107, v166
		v_max3_f32 v139, v167, v113, v168
		v_max3_f32 v141, v169, v119, v170
		v_max3_f32 v166, v171, v187, v172
		v_max3_f32 v167, v173, v127, v174
		v_max3_f32 v168, v175, v135, v192
		v_max3_f32 v10, v10, v177, v21
		v_max3_f32 v21, v138, v109, v139
		v_max3_f32 v138, v141, v181, v166
		v_max3_f32 v139, v167, v161, v168
		v_max3_f32 v10, v10, v101, v21
		v_max3_f32 v21, v138, v189, v139
		v_max3_f32 v10, v10, v115, v21
		v_max_f32_e32 v10, v10, v165
		v_mov_b32_e32 v138, v10
		v_mov_b32_e32 v139, v10
		s_nop 1
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v141, v138, v139
		v_mov_b32_e32 v138, 0x3e38aa3b
		v_mov_b32_e32 v139, 0x3e38aa3b
		v_pk_mul_f32 v[166:167], v[140:141], v[138:139]
		v_max_f32_e32 v140, v9, v166
		v_max_f32_e32 v141, v11, v167
		v_pk_fma_f32 v[166:167], v[254:255], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[224:225], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[158:159], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[226:227], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[98:99], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[230:231], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[102:103], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[232:233], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[24:25], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[236:237], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[26:27], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[238:239], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[178:179], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[240:241], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[182:183], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[242:243], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[190:191], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[244:245], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[128:129], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[246:247], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[162:163], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[248:249], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[250:251], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[252:253], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[142:143], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[4:5], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[4:5], v[96:97], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[14:15], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[14:15], v[176:177], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[16:17], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[30:31], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[18:19], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[100:101], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[104:105], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[22:23], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[108:109], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[28:29], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[114:115], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[180:181], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[184:185], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[124:125], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[188:189], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[122:123], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[160:161], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[132:133], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[134:135], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[164:165], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v138, v166
		v_exp_f32_e32 v164, v167
		v_exp_f32_e32 v139, v168
		v_exp_f32_e32 v165, v169
		v_exp_f32_e32 v166, v170
		v_exp_f32_e32 v168, v171
		v_exp_f32_e32 v167, v158
		v_exp_f32_e32 v169, v159
		v_exp_f32_e32 v158, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v159, v98
		v_exp_f32_e32 v171, v99
		v_exp_f32_e32 v98, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v99, v102
		v_exp_f32_e32 v173, v103
		v_exp_f32_e32 v102, v192
		v_exp_f32_e32 v174, v193
		v_exp_f32_e32 v103, v24
		v_exp_f32_e32 v175, v25
		v_exp_f32_e32 v24, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v25, v26
		v_exp_f32_e32 v193, v27
		v_exp_f32_e32 v26, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v27, v178
		v_exp_f32_e32 v195, v179
		v_exp_f32_e32 v178, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v179, v182
		v_exp_f32_e32 v197, v183
		v_exp_f32_e32 v182, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v183, v190
		v_exp_f32_e32 v199, v191
		v_exp_f32_e32 v190, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v191, v128
		v_exp_f32_e32 v201, v129
		v_exp_f32_e32 v128, v204
		v_exp_f32_e32 v202, v205
		v_exp_f32_e32 v129, v162
		v_exp_f32_e32 v203, v163
		v_exp_f32_e32 v162, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v163, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v206, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v207, v142
		v_exp_f32_e32 v209, v143
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v210, v145
		v_exp_f32_e32 v143, v146
		v_exp_f32_e32 v211, v147
		v_exp_f32_e32 v144, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v145, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v149, v154
		v_exp_f32_e32 v151, v155
		v_exp_f32_e32 v153, v156
		v_exp_f32_e32 v155, v157
		v_exp_f32_e32 v156, v4
		v_exp_f32_e32 v212, v5
		v_exp_f32_e32 v157, v96
		v_exp_f32_e32 v213, v97
		v_exp_f32_e32 v4, v14
		v_exp_f32_e32 v96, v15
		v_exp_f32_e32 v5, v176
		v_exp_f32_e32 v97, v177
		v_exp_f32_e32 v14, v16
		v_exp_f32_e32 v176, v17
		v_exp_f32_e32 v15, v30
		v_exp_f32_e32 v177, v31
		v_exp_f32_e32 v16, v18
		v_exp_f32_e32 v30, v19
		v_exp_f32_e32 v17, v100
		v_exp_f32_e32 v31, v101
		v_exp_f32_e32 v18, v104
		v_exp_f32_e32 v100, v105
		v_exp_f32_e32 v19, v106
		v_exp_f32_e32 v101, v107
		v_exp_f32_e32 v104, v22
		v_exp_f32_e32 v106, v23
		v_exp_f32_e32 v105, v108
		v_exp_f32_e32 v107, v109
		v_exp_f32_e32 v22, v110
		v_exp_f32_e32 v108, v111
		v_exp_f32_e32 v23, v112
		v_exp_f32_e32 v109, v113
		v_exp_f32_e32 v110, v28
		v_exp_f32_e32 v112, v29
		v_exp_f32_e32 v111, v114
		v_exp_f32_e32 v113, v115
		v_exp_f32_e32 v28, v116
		v_exp_f32_e32 v114, v117
		v_exp_f32_e32 v29, v118
		v_exp_f32_e32 v115, v119
		v_exp_f32_e32 v116, v120
		v_exp_f32_e32 v118, v121
		v_exp_f32_e32 v117, v180
		v_exp_f32_e32 v119, v181
		v_exp_f32_e32 v120, v184
		v_exp_f32_e32 v180, v185
		v_exp_f32_e32 v121, v186
		v_exp_f32_e32 v181, v187
		v_exp_f32_e32 v184, v124
		v_exp_f32_e32 v186, v125
		v_exp_f32_e32 v185, v188
		v_exp_f32_e32 v187, v189
		v_exp_f32_e32 v124, v122
		v_exp_f32_e32 v188, v123
		v_exp_f32_e32 v125, v126
		v_exp_f32_e32 v189, v127
		v_exp_f32_e32 v122, v130
		v_exp_f32_e32 v126, v131
		v_exp_f32_e32 v123, v160
		v_exp_f32_e32 v127, v161
		v_exp_f32_e32 v130, v132
		v_exp_f32_e32 v160, v133
		v_exp_f32_e32 v131, v134
		v_exp_f32_e32 v161, v135
		v_exp_f32_e32 v132, v136
		v_exp_f32_e32 v134, v137
		v_pk_add_f32 v[136:137], v[138:139], v[164:165]
		v_pk_add_f32 v[214:215], v[166:167], v[168:169]
		v_pk_add_f32 v[216:217], v[158:159], v[170:171]
		v_pk_add_f32 v[218:219], v[98:99], v[172:173]
		v_pk_add_f32 v[220:221], v[102:103], v[174:175]
		v_pk_add_f32 v[222:223], v[24:25], v[192:193]
		v_pk_add_f32 v[224:225], v[26:27], v[194:195]
		v_pk_add_f32 v[226:227], v[178:179], v[196:197]
		v_pk_add_f32 v[228:229], v[182:183], v[198:199]
		v_pk_add_f32 v[230:231], v[190:191], v[200:201]
		v_pk_add_f32 v[232:233], v[128:129], v[202:203]
		v_pk_add_f32 v[234:235], v[162:163], v[204:205]
		v_pk_add_f32 v[236:237], v[206:207], v[208:209]
		v_pk_add_f32 v[238:239], v[142:143], v[210:211]
		v_pk_add_f32 v[240:241], v[144:145], v[146:147]
		v_pk_add_f32 v[242:243], v[148:149], v[150:151]
		v_mov_b32_e32 v244, v137
		v_mov_b32_e32 v245, v215
		v_mov_b32_e32 v246, v136
		v_mov_b32_e32 v247, v214
		v_pk_add_f32 v[136:137], v[246:247], v[244:245]
		v_mov_b32_e32 v214, v217
		v_mov_b32_e32 v215, v219
		v_mov_b32_e32 v244, v216
		v_mov_b32_e32 v245, v218
		v_pk_add_f32 v[216:217], v[244:245], v[214:215]
		v_mov_b32_e32 v214, v221
		v_mov_b32_e32 v215, v223
		v_mov_b32_e32 v218, v220
		v_mov_b32_e32 v219, v222
		v_pk_add_f32 v[220:221], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v225
		v_mov_b32_e32 v215, v227
		v_mov_b32_e32 v218, v224
		v_mov_b32_e32 v219, v226
		v_pk_add_f32 v[222:223], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v229
		v_mov_b32_e32 v215, v231
		v_mov_b32_e32 v218, v228
		v_mov_b32_e32 v219, v230
		v_pk_add_f32 v[224:225], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v233
		v_mov_b32_e32 v215, v235
		v_mov_b32_e32 v218, v232
		v_mov_b32_e32 v219, v234
		v_pk_add_f32 v[226:227], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v237
		v_mov_b32_e32 v215, v239
		v_mov_b32_e32 v218, v236
		v_mov_b32_e32 v219, v238
		v_pk_add_f32 v[228:229], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v241
		v_mov_b32_e32 v215, v243
		v_mov_b32_e32 v218, v240
		v_mov_b32_e32 v219, v242
		v_pk_add_f32 v[230:231], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v137
		v_mov_b32_e32 v215, v217
		v_mov_b32_e32 v218, v136
		v_mov_b32_e32 v219, v216
		v_pk_add_f32 v[136:137], v[218:219], v[214:215]
		v_mov_b32_e32 v214, v221
		v_mov_b32_e32 v215, v223
		v_mov_b32_e32 v216, v220
		v_mov_b32_e32 v217, v222
		v_pk_add_f32 v[218:219], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v225
		v_mov_b32_e32 v215, v227
		v_mov_b32_e32 v216, v224
		v_mov_b32_e32 v217, v226
		v_pk_add_f32 v[220:221], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v229
		v_mov_b32_e32 v215, v231
		v_mov_b32_e32 v216, v228
		v_mov_b32_e32 v217, v230
		v_pk_add_f32 v[222:223], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v137
		v_mov_b32_e32 v215, v219
		v_mov_b32_e32 v216, v136
		v_mov_b32_e32 v217, v218
		v_pk_add_f32 v[136:137], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v221
		v_mov_b32_e32 v215, v223
		v_mov_b32_e32 v216, v220
		v_mov_b32_e32 v217, v222
		v_pk_add_f32 v[218:219], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v137
		v_mov_b32_e32 v215, v219
		v_mov_b32_e32 v216, v136
		v_mov_b32_e32 v217, v218
		v_pk_add_f32 v[136:137], v[216:217], v[214:215]
		v_add_f32_e32 v10, v136, v137
		v_accvgpr_read_b32 v21, a77
		ds_bpermute_b32 v152, v21, v10
		v_accvgpr_read_b32 v21, a78
		ds_bpermute_b32 v154, v21, v10
		v_pk_add_f32 v[136:137], v[156:157], v[212:213]
		v_pk_add_f32 v[214:215], v[4:5], v[96:97]
		v_pk_add_f32 v[216:217], v[14:15], v[176:177]
		v_pk_add_f32 v[218:219], v[16:17], v[30:31]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[220:221], v[152:153], v[154:155]
		v_pk_add_f32 v[222:223], v[18:19], v[100:101]
		v_pk_add_f32 v[224:225], v[104:105], v[106:107]
		v_pk_add_f32 v[226:227], v[22:23], v[108:109]
		v_pk_add_f32 v[228:229], v[110:111], v[112:113]
		v_pk_add_f32 v[230:231], v[28:29], v[114:115]
		v_pk_add_f32 v[232:233], v[116:117], v[118:119]
		v_pk_add_f32 v[234:235], v[120:121], v[180:181]
		v_pk_add_f32 v[236:237], v[184:185], v[186:187]
		v_pk_add_f32 v[238:239], v[124:125], v[188:189]
		v_pk_add_f32 v[240:241], v[122:123], v[126:127]
		v_pk_add_f32 v[242:243], v[130:131], v[160:161]
		v_mov_b32_e32 v133, v221
		v_mov_b32_e32 v135, v136
		v_pk_add_f32 v[244:245], v[132:133], v[134:135]
		v_mov_b32_e32 v246, v137
		v_mov_b32_e32 v247, v216
		v_pk_add_f32 v[136:137], v[246:247], v[214:215]
		v_mov_b32_e32 v214, v217
		v_mov_b32_e32 v215, v222
		v_pk_add_f32 v[214:215], v[214:215], v[218:219]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v226
		v_pk_add_f32 v[218:219], v[216:217], v[224:225]
		v_mov_b32_e32 v216, v227
		v_mov_b32_e32 v217, v230
		v_pk_add_f32 v[216:217], v[216:217], v[228:229]
		v_mov_b32_e32 v222, v231
		v_mov_b32_e32 v223, v234
		v_pk_add_f32 v[224:225], v[222:223], v[232:233]
		v_mov_b32_e32 v222, v235
		v_mov_b32_e32 v223, v238
		v_pk_add_f32 v[222:223], v[222:223], v[236:237]
		v_mov_b32_e32 v226, v239
		v_mov_b32_e32 v227, v242
		v_pk_add_f32 v[228:229], v[226:227], v[240:241]
		v_mov_b32_e32 v226, v243
		v_mov_b32_e32 v227, v136
		v_pk_add_f32 v[226:227], v[226:227], v[244:245]
		v_mov_b32_e32 v230, v137
		v_mov_b32_e32 v231, v218
		v_pk_add_f32 v[136:137], v[230:231], v[214:215]
		v_mov_b32_e32 v214, v219
		v_mov_b32_e32 v215, v224
		v_pk_add_f32 v[214:215], v[214:215], v[216:217]
		v_mov_b32_e32 v216, v225
		v_mov_b32_e32 v217, v228
		v_pk_add_f32 v[218:219], v[216:217], v[222:223]
		v_mov_b32_e32 v216, v229
		v_mov_b32_e32 v217, v136
		v_pk_add_f32 v[216:217], v[216:217], v[226:227]
		v_mov_b32_e32 v222, v137
		v_mov_b32_e32 v223, v218
		v_pk_add_f32 v[136:137], v[222:223], v[214:215]
		v_mov_b32_e32 v214, v219
		v_mov_b32_e32 v215, v136
		v_pk_add_f32 v[218:219], v[214:215], v[216:217]
		v_add_f32_e32 v10, v137, v218
		v_add_f32_e32 v10, v219, v10
		v_mov_b32_e32 v136, v10
		v_mov_b32_e32 v137, v10
		s_nop 1
		v_permlane32_swap_b32_e32 v136, v137
		v_add_f32_e32 v215, v136, v137
		v_sub_f32_e32 v9, v9, v140
		v_sub_f32_e32 v10, v11, v141
		v_exp_f32_e32 v136, v9
		v_exp_f32_e32 v216, v10
		v_mov_b32_e32 v137, v136
		v_pk_mul_f32 v[32:33], v[32:33], v[136:137]
		v_pk_mul_f32 v[34:35], v[34:35], v[136:137]
		v_pk_mul_f32 v[36:37], v[36:37], v[136:137]
		v_pk_mul_f32 v[38:39], v[38:39], v[136:137]
		v_pk_mul_f32 v[40:41], v[40:41], v[136:137]
		v_pk_mul_f32 v[42:43], v[42:43], v[136:137]
		v_pk_mul_f32 v[44:45], v[44:45], v[136:137]
		v_pk_mul_f32 v[46:47], v[46:47], v[136:137]
		v_pk_mul_f32 v[48:49], v[48:49], v[136:137]
		v_pk_mul_f32 v[50:51], v[50:51], v[136:137]
		v_pk_mul_f32 v[52:53], v[52:53], v[136:137]
		v_pk_mul_f32 v[54:55], v[54:55], v[136:137]
		v_pk_mul_f32 v[56:57], v[56:57], v[136:137]
		v_pk_mul_f32 v[58:59], v[58:59], v[136:137]
		v_pk_mul_f32 v[60:61], v[60:61], v[136:137]
		v_pk_mul_f32 v[62:63], v[62:63], v[136:137]
		v_mov_b32_e32 v217, v216
		v_pk_mul_f32 v[64:65], v[64:65], v[216:217]
		v_pk_mul_f32 v[66:67], v[66:67], v[216:217]
		v_pk_mul_f32 v[68:69], v[68:69], v[216:217]
		v_pk_mul_f32 v[70:71], v[70:71], v[216:217]
		v_pk_mul_f32 v[72:73], v[72:73], v[216:217]
		v_pk_mul_f32 v[74:75], v[74:75], v[216:217]
		v_pk_mul_f32 v[76:77], v[76:77], v[216:217]
		v_pk_mul_f32 v[78:79], v[78:79], v[216:217]
		v_pk_mul_f32 v[80:81], v[80:81], v[216:217]
		v_pk_mul_f32 v[82:83], v[82:83], v[216:217]
		v_pk_mul_f32 v[84:85], v[84:85], v[216:217]
		v_pk_mul_f32 v[86:87], v[86:87], v[216:217]
		v_pk_mul_f32 v[88:89], v[88:89], v[216:217]
		v_pk_mul_f32 v[90:91], v[90:91], v[216:217]
		v_pk_mul_f32 v[92:93], v[92:93], v[216:217]
		v_pk_mul_f32 v[94:95], v[94:95], v[216:217]
		v_mov_b32_e32 v10, v136
		v_mov_b32_e32 v11, v216
		v_mov_b32_e32 v214, v220
		v_mov_b64_e32 v[136:137], v[12:13]
		v_pk_fma_f32 v[12:13], v[136:137], v[10:11], v[214:215]
		v_cvt_pk_bf16_f32 v216, v138, v164
		v_cvt_pk_bf16_f32 v217, v139, v165
		v_cvt_pk_bf16_f32 v218, v166, v168
		v_cvt_pk_bf16_f32 v219, v167, v169
		v_cvt_pk_bf16_f32 v136, v158, v170
		v_cvt_pk_bf16_f32 v137, v159, v171
		v_cvt_pk_bf16_f32 v138, v98, v172
		v_cvt_pk_bf16_f32 v139, v99, v173
		v_cvt_pk_bf16_f32 v164, v102, v174
		v_cvt_pk_bf16_f32 v165, v103, v175
		v_cvt_pk_bf16_f32 v166, v24, v192
		v_cvt_pk_bf16_f32 v167, v25, v193
		v_cvt_pk_bf16_f32 v168, v26, v194
		v_cvt_pk_bf16_f32 v169, v27, v195
		v_cvt_pk_bf16_f32 v170, v178, v196
		v_cvt_pk_bf16_f32 v171, v179, v197
		v_cvt_pk_bf16_f32 v24, v182, v198
		v_cvt_pk_bf16_f32 v25, v183, v199
		v_cvt_pk_bf16_f32 v26, v190, v200
		v_cvt_pk_bf16_f32 v27, v191, v201
		v_cvt_pk_bf16_f32 v172, v128, v202
		v_cvt_pk_bf16_f32 v173, v129, v203
		v_cvt_pk_bf16_f32 v174, v162, v204
		v_cvt_pk_bf16_f32 v175, v163, v205
		v_cvt_pk_bf16_f32 v192, v206, v208
		v_cvt_pk_bf16_f32 v193, v207, v209
		v_cvt_pk_bf16_f32 v194, v142, v210
		v_cvt_pk_bf16_f32 v195, v143, v211
		v_cvt_pk_bf16_f32 v196, v144, v146
		v_cvt_pk_bf16_f32 v197, v145, v147
		v_cvt_pk_bf16_f32 v198, v148, v150
		v_cvt_pk_bf16_f32 v199, v149, v151
		v_cvt_pk_bf16_f32 v144, v153, v155
		v_cvt_pk_bf16_f32 v145, v156, v212
		v_cvt_pk_bf16_f32 v146, v157, v213
		v_cvt_pk_bf16_f32 v147, v4, v96
		v_cvt_pk_bf16_f32 v148, v5, v97
		v_cvt_pk_bf16_f32 v149, v14, v176
		v_cvt_pk_bf16_f32 v150, v15, v177
		v_cvt_pk_bf16_f32 v151, v16, v30
		v_cvt_pk_bf16_f32 v96, v17, v31
		v_cvt_pk_bf16_f32 v97, v18, v100
		v_cvt_pk_bf16_f32 v98, v19, v101
		v_cvt_pk_bf16_f32 v99, v104, v106
		v_cvt_pk_bf16_f32 v16, v105, v107
		v_cvt_pk_bf16_f32 v17, v22, v108
		v_cvt_pk_bf16_f32 v18, v23, v109
		v_cvt_pk_bf16_f32 v19, v110, v112
		v_cvt_pk_bf16_f32 v100, v111, v113
		v_cvt_pk_bf16_f32 v101, v28, v114
		v_cvt_pk_bf16_f32 v102, v29, v115
		v_cvt_pk_bf16_f32 v103, v116, v118
		v_cvt_pk_bf16_f32 v28, v117, v119
		v_cvt_pk_bf16_f32 v29, v120, v180
		v_cvt_pk_bf16_f32 v30, v121, v181
		v_cvt_pk_bf16_f32 v31, v184, v186
		v_cvt_pk_bf16_f32 v104, v185, v187
		v_cvt_pk_bf16_f32 v105, v124, v188
		v_cvt_pk_bf16_f32 v106, v125, v189
		v_cvt_pk_bf16_f32 v107, v122, v126
		v_cvt_pk_bf16_f32 v108, v123, v127
		v_cvt_pk_bf16_f32 v109, v130, v160
		v_cvt_pk_bf16_f32 v110, v131, v161
		v_cvt_pk_bf16_f32 v111, v132, v134
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[216:219], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[216:219], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[168:171], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[168:171], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[172:175], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[104:107], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[108:111], v[64:79]
		s_add_i32 s19, s43, 0x80
		s_cmp_lt_i32 s19, s24
		s_mov_b32 s43, s19
		v_mov_b32_e32 v9, v140
		v_mov_b32_e32 v11, v141
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v2, v12
		v_rcp_f32_e32 v4, v13
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[6:7], v[32:33], v[2:3]
		v_pk_mul_f32 v[8:9], v[34:35], v[2:3]
		v_pk_mul_f32 v[10:11], v[36:37], v[2:3]
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
		v_mov_b32_e32 v5, v4
		v_pk_mul_f32 v[2:3], v[64:65], v[4:5]
		v_pk_mul_f32 v[38:39], v[66:67], v[4:5]
		v_pk_mul_f32 v[40:41], v[68:69], v[4:5]
		v_pk_mul_f32 v[42:43], v[70:71], v[4:5]
		v_pk_mul_f32 v[44:45], v[72:73], v[4:5]
		v_pk_mul_f32 v[46:47], v[74:75], v[4:5]
		v_pk_mul_f32 v[48:49], v[76:77], v[4:5]
		v_pk_mul_f32 v[50:51], v[78:79], v[4:5]
		v_pk_mul_f32 v[52:53], v[80:81], v[4:5]
		v_pk_mul_f32 v[54:55], v[82:83], v[4:5]
		v_pk_mul_f32 v[56:57], v[84:85], v[4:5]
		v_pk_mul_f32 v[58:59], v[86:87], v[4:5]
		v_pk_mul_f32 v[60:61], v[88:89], v[4:5]
		v_pk_mul_f32 v[62:63], v[90:91], v[4:5]
		v_pk_mul_f32 v[64:65], v[92:93], v[4:5]
		v_pk_mul_f32 v[66:67], v[94:95], v[4:5]
		v_cvt_pk_bf16_f32 v68, v6, v7
		v_cvt_pk_bf16_f32 v69, v8, v9
		v_cvt_pk_bf16_f32 v70, v10, v11
		v_cvt_pk_bf16_f32 v71, v12, v13
		v_cvt_pk_bf16_f32 v4, v14, v15
		v_cvt_pk_bf16_f32 v5, v16, v17
		v_cvt_pk_bf16_f32 v6, v18, v19
		v_cvt_pk_bf16_f32 v7, v20, v21
		v_cvt_pk_bf16_f32 v8, v22, v23
		v_cvt_pk_bf16_f32 v9, v24, v25
		v_cvt_pk_bf16_f32 v10, v26, v27
		v_cvt_pk_bf16_f32 v11, v28, v29
		v_cvt_pk_bf16_f32 v12, v30, v31
		v_cvt_pk_bf16_f32 v13, v32, v33
		v_cvt_pk_bf16_f32 v14, v34, v35
		v_cvt_pk_bf16_f32 v15, v36, v37
		v_cvt_pk_bf16_f32 v16, v2, v3
		v_cvt_pk_bf16_f32 v17, v38, v39
		v_cvt_pk_bf16_f32 v18, v40, v41
		v_cvt_pk_bf16_f32 v19, v42, v43
		v_cvt_pk_bf16_f32 v20, v44, v45
		v_cvt_pk_bf16_f32 v21, v46, v47
		v_cvt_pk_bf16_f32 v22, v48, v49
		v_cvt_pk_bf16_f32 v23, v50, v51
		v_cvt_pk_bf16_f32 v24, v52, v53
		v_cvt_pk_bf16_f32 v25, v54, v55
		v_cvt_pk_bf16_f32 v26, v56, v57
		v_cvt_pk_bf16_f32 v27, v58, v59
		v_cvt_pk_bf16_f32 v28, v60, v61
		v_cvt_pk_bf16_f32 v29, v62, v63
		v_cvt_pk_bf16_f32 v30, v64, v65
		v_cvt_pk_bf16_f32 v31, v66, v67
		v_permlane32_swap_b32_e32 v68, v70
		v_permlane32_swap_b32_e32 v69, v71
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s19, v1
		s_mul_i32 s19, s19, s18
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
		v_readfirstlane_b32 s24, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 1
		s_add_i32 s23, s23, s24
		v_accvgpr_read_b32 v1, a12
		v_mul_lo_u32 v1, s18, v1
		v_lshl_add_u32 v2, v1, 6, s23
		v_accvgpr_read_b32 v3, a15
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v32, a23
		v_mul_lo_u32 v32, s18, v32
		v_lshl_add_u32 v2, v32, 5, v2
		v_accvgpr_read_b32 v33, a27
		v_mul_lo_u32 v33, s18, v33
		v_lshl_add_u32 v2, v33, 4, v2
		v_accvgpr_read_b32 v34, a20
		v_mul_lo_u32 v34, s18, v34
		v_lshl_add_u32 v2, v34, 3, v2
		v_accvgpr_read_b32 v35, a21
		v_mul_lo_u32 v35, s18, v35
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v36, a22
		v_lshl_add_u32 v2, v36, 4, v2
		v_accvgpr_read_b32 v36, a16
		s_nop 0
		v_readfirstlane_b32 s26, v36
		v_accvgpr_read_b32 v36, a17
		s_nop 0
		v_readfirstlane_b32 s27, v36
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[68:71], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s23, s19, 32
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s24
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v36, a22
		v_lshl_add_u32 v2, v36, 4, v2
		v_accvgpr_read_b32 v36, a16
		s_nop 0
		v_readfirstlane_b32 s26, v36
		v_accvgpr_read_b32 v36, a17
		s_nop 0
		v_readfirstlane_b32 s27, v36
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[4:7], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s23, s19, 64
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s24
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a16
		s_nop 0
		v_readfirstlane_b32 s26, v4
		v_accvgpr_read_b32 v4, a17
		s_nop 0
		v_readfirstlane_b32 s27, v4
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[8:11], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s23, s19, 0x60
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s24
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a16
		s_nop 0
		v_readfirstlane_b32 s26, v4
		v_accvgpr_read_b32 v4, a17
		s_nop 0
		v_readfirstlane_b32 s27, v4
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[12:15], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s23, s18, 8
		s_add_i32 s25, s23, s19
		s_add_i32 s25, s25, s22
		s_add_i32 s25, s25, s24
		v_lshl_add_u32 v2, v1, 6, s25
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a18
		s_nop 0
		v_readfirstlane_b32 s26, v4
		v_accvgpr_read_b32 v4, a19
		s_nop 0
		v_readfirstlane_b32 s27, v4
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[16:19], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s25, s23, 32
		s_add_i32 s25, s25, s19
		s_add_i32 s25, s25, s22
		s_add_i32 s25, s25, s24
		v_lshl_add_u32 v2, v1, 6, s25
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a18
		s_nop 0
		v_readfirstlane_b32 s26, v4
		v_accvgpr_read_b32 v4, a19
		s_nop 0
		v_readfirstlane_b32 s27, v4
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[20:23], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s25, s23, 64
		s_add_i32 s25, s25, s19
		s_add_i32 s25, s25, s22
		s_add_i32 s25, s25, s24
		v_lshl_add_u32 v2, v1, 6, s25
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a18
		s_nop 0
		v_readfirstlane_b32 s26, v4
		v_accvgpr_read_b32 v4, a19
		s_nop 0
		v_readfirstlane_b32 s27, v4
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[24:27], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s23, s23, 0x60
		s_add_i32 s19, s23, s19
		s_add_i32 s19, s19, s22
		s_add_i32 s19, s19, s24
		v_lshl_add_u32 v1, v1, 6, s19
		v_lshl_add_u32 v1, v3, 1, v1
		v_lshl_add_u32 v1, v32, 5, v1
		v_lshl_add_u32 v1, v33, 4, v1
		v_lshl_add_u32 v1, v34, 3, v1
		v_lshl_add_u32 v1, v35, 2, v1
		v_accvgpr_read_b32 v2, a22
		v_lshl_add_u32 v1, v2, 4, v1
		v_accvgpr_read_b32 v2, a18
		s_nop 0
		v_readfirstlane_b32 s22, v2
		v_accvgpr_read_b32 v2, a19
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_and_saveexec_b64 s[90:91], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v1, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[90:91], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[90:91]
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
		s_mul_i32 s22, s19, 0x100
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
		v_accvgpr_write_b32 a11, v13
		v_accvgpr_read_b32 v13, a11
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v13
		v_bitop3_b32 v5, v5, v12, v14 bitop3:0x96
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 64
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v5, v5, v16
		v_accvgpr_write_b32 a12, v5
		v_accvgpr_read_b32 v5, a12
		v_add_u32_e32 v5, s22, v5
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v4
		v_xor_b32_e32 v1, v1, v6
		v_bitop3_b32 v1, v1, v9, v12 bitop3:0x96
		v_bitop3_b32 v1, v1, v14, v16 bitop3:0x96
		v_accvgpr_write_b32 a13, v1
		v_accvgpr_read_b32 v1, a13
		v_add_u32_e32 v1, s22, v1
		v_cmp_lt_i32_e64 vcc, v5, s20
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_i32_e64 vcc, v1, s20
		s_mov_b64 s[26:27], vcc
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
		v_xad_u32 v9, v9, v14, s22
		v_bitop3_b32 v16, 32, v8, v1 bitop3:0x96
		v_bitop3_b32 v16, v16, v6, v12 bitop3:0x96
		v_xad_u32 v16, v16, v14, s22
		v_bitop3_b32 v17, 64, v8, v1 bitop3:0x96
		v_bitop3_b32 v17, v17, v6, v12 bitop3:0x96
		v_xad_u32 v17, v17, v14, s22
		v_xor_b32_e32 v18, 0x60, v8
		v_xor_b32_e32 v18, v18, v1
		v_xor_b32_e32 v18, v18, v6
		v_xor_b32_e32 v18, v18, v12
		v_xad_u32 v18, v18, v14, s22
		v_xor_b32_e32 v19, 0x80, v8
		v_xor_b32_e32 v19, v19, v1
		v_xor_b32_e32 v19, v19, v6
		v_xor_b32_e32 v19, v19, v12
		v_xad_u32 v19, v19, v14, s22
		v_xor_b32_e32 v20, 0xa0, v8
		v_xor_b32_e32 v20, v20, v1
		v_xor_b32_e32 v20, v20, v6
		v_xor_b32_e32 v20, v20, v12
		v_xad_u32 v20, v20, v14, s22
		v_xor_b32_e32 v21, 0xc0, v8
		v_xor_b32_e32 v21, v21, v1
		v_xor_b32_e32 v21, v21, v6
		v_xor_b32_e32 v21, v21, v12
		v_xad_u32 v21, v21, v14, s22
		v_xor_b32_e32 v22, 0xe0, v8
		v_xor_b32_e32 v1, v22, v1
		v_xor_b32_e32 v1, v1, v6
		v_xor_b32_e32 v1, v1, v12
		v_xad_u32 v1, v1, v14, s22
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		v_accvgpr_read_b32 v12, a6
		v_and_b32_e32 v12, 0xffff, v12
		v_lshlrev_b32_e32 v14, 16, v12
		v_or_b32_e32 v24, v12, v14
		v_mov_b32_e32 v25, v24
		v_mov_b32_e32 v26, v24
		v_mov_b32_e32 v27, v24
		s_mul_i32 s23, s19, s12
		s_lshl_b32 s23, s23, 9
		v_mov_b32_e32 v12, s1
		v_accvgpr_write_b32 a14, v12
		v_accvgpr_read_b32 v12, a14
		s_nop 0
		v_readfirstlane_b32 s1, v12
		s_mul_i32 s1, s1, s10
		s_lshl_b32 s1, s1, 1
		s_add_i32 s32, s23, s1
		v_accvgpr_read_b32 v12, a10
		s_nop 0
		v_readfirstlane_b32 s33, v12
		s_mul_i32 s33, s33, s11
		s_lshl_b32 s33, s33, 1
		s_add_i32 s32, s32, s33
		v_mul_lo_u32 v12, s12, v7
		v_lshl_add_u32 v14, v12, 1, s32
		v_and_b32_e32 v22, 1, v0
		v_accvgpr_write_b32 a15, v22
		v_accvgpr_read_b32 v22, a15
		v_lshl_add_u32 v14, v22, 4, v14
		v_and_b32_e32 v22, 1, v3
		v_accvgpr_write_b32 a16, v22
		v_accvgpr_read_b32 v22, a16
		v_lshl_add_u32 v14, v22, 6, v14
		v_and_b32_e32 v2, 1, v2
		v_accvgpr_write_b32 a17, v2
		v_accvgpr_read_b32 v2, a17
		v_lshl_add_u32 v2, v2, 5, v14
		v_cmp_lt_i32_e64 vcc, v9, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[28:31], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v28, v24
		v_mov_b32_e32 v29, v25
		v_mov_b32_e32 v30, v26
		v_mov_b32_e32 v31, v27
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s32, s12, 6
		s_add_i32 s32, s32, s23
		s_add_i32 s32, s32, s1
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v12, 1, s32
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v2, v9, 4, v2
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v2, v9, 6, v2
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v2, v9, 5, v2
		v_cmp_lt_i32_e64 vcc, v16, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[32:35], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v32, v24
		v_mov_b32_e32 v33, v25
		v_mov_b32_e32 v34, v26
		v_mov_b32_e32 v35, v27
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s32, s12, 7
		s_add_i32 s32, s32, s23
		s_add_i32 s32, s32, s1
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v12, 1, s32
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v2, v9, 4, v2
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v2, v9, 6, v2
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v2, v9, 5, v2
		v_cmp_lt_i32_e64 vcc, v17, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[36:39], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v36, v24
		v_mov_b32_e32 v37, v25
		v_mov_b32_e32 v38, v26
		v_mov_b32_e32 v39, v27
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s32, 0xc0, s12
		s_add_i32 s32, s32, s23
		s_add_i32 s32, s32, s1
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v12, 1, s32
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v2, v9, 4, v2
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v2, v9, 6, v2
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v2, v9, 5, v2
		v_cmp_lt_i32_e64 vcc, v18, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[40:43], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v40, v24
		v_mov_b32_e32 v41, v25
		v_mov_b32_e32 v42, v26
		v_mov_b32_e32 v43, v27
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s32, s12, 8
		s_add_i32 s32, s32, s23
		s_add_i32 s32, s32, s1
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v12, 1, s32
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v2, v9, 4, v2
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v2, v9, 6, v2
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v2, v9, 5, v2
		v_cmp_lt_i32_e64 vcc, v19, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[16:19], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v16, v24
		v_mov_b32_e32 v17, v25
		v_mov_b32_e32 v18, v26
		v_mov_b32_e32 v19, v27
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s32, 0x140, s12
		s_add_i32 s32, s32, s23
		s_add_i32 s32, s32, s1
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v12, 1, s32
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v2, v9, 4, v2
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v2, v9, 6, v2
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v2, v9, 5, v2
		v_cmp_lt_i32_e64 vcc, v20, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[44:47], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v44, v24
		v_mov_b32_e32 v45, v25
		v_mov_b32_e32 v46, v26
		v_mov_b32_e32 v47, v27
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s32, 0x180, s12
		s_add_i32 s32, s32, s23
		s_add_i32 s32, s32, s1
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v12, 1, s32
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v2, v9, 4, v2
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v2, v9, 6, v2
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v2, v9, 5, v2
		v_cmp_lt_i32_e64 vcc, v21, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[20:23], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v20, v24
		v_mov_b32_e32 v21, v25
		v_mov_b32_e32 v22, v26
		v_mov_b32_e32 v23, v27
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s32, 0x1c0, s12
		s_add_i32 s23, s32, s23
		s_add_i32 s1, s23, s1
		s_add_i32 s1, s1, s33
		v_lshl_add_u32 v2, v12, 1, s1
		v_accvgpr_read_b32 v9, a15
		v_lshl_add_u32 v2, v9, 4, v2
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v2, v9, 6, v2
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v2, v9, 5, v2
		v_cmp_lt_i32_e64 vcc, v1, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[48:51], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v48, v24
		v_mov_b32_e32 v49, v25
		v_mov_b32_e32 v50, v26
		v_mov_b32_e32 v51, v27
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[90:91]
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		s_mov_b32 s36, s6
		s_mov_b32 s37, s7
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		s_waitcnt vmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v1, a11
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 2, v1
		v_and_b32_e32 v2, 1, v4
		v_accvgpr_write_b32 a18, v2
		v_accvgpr_read_b32 v2, a18
		v_lshlrev_b32_e32 v2, 1, v2
		v_and_b32_e32 v4, 1, v10
		v_accvgpr_write_b32 a19, v4
		v_accvgpr_read_b32 v4, a19
		v_xor_b32_e32 v4, v0, v4
		v_bitop3_b32 v1, v1, v2, v4 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[28:31] offset:18864
		ds_write_b128 v1, v[32:35] offset:22960
		ds_write_b128 v1, v[36:39] offset:27056
		ds_write_b128 v1, v[40:43] offset:31152
		v_accvgpr_read_b32 v2, a11
		v_lshlrev_b32_e32 v2, 12, v2
		v_add_u32_e32 v2, 0x10000, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v9, 3, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v10, 6, v9
		v_add_u32_e32 v12, v2, v10
		v_lshrrev_b32_e32 v14, 2, v4
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v24, 5, v14
		v_add_u32_e32 v25, v12, v24
		v_lshrrev_b32_e32 v26, 5, v4
		v_accvgpr_write_b32 a20, v26
		v_lshrrev_b32_e32 v26, 4, v4
		v_and_b32_e32 v26, 1, v26
		v_lshlrev_b32_e32 v26, 7, v26
		v_lshrrev_b32_e32 v27, 1, v4
		v_and_b32_e32 v27, 1, v27
		v_lshlrev_b32_e32 v28, 4, v27
		v_and_b32_e32 v29, 1, v4
		v_lshlrev_b32_e32 v29, 3, v29
		v_accvgpr_read_b32 v30, a20
		v_add3_u32 v30, v30, v26, v10
		v_add3_u32 v30, v30, v24, v28
		v_add_u32_e32 v31, v29, v30
		v_xor_b32_e32 v31, v31, v27
		v_lshl_add_u32 v25, v31, 4, v25
		ds_read_b128 a[24:27], v25 offset:18864
		v_lshlrev_b32_e32 v14, 1, v14
		v_add3_u32 v31, v29, v30, 2
		v_bitop3_b32 v31, v14, v31, v27 bitop3:0x96
		v_lshl_add_u32 v12, v31, 4, v12
		ds_read_b128 a[28:31], v12 offset:18864
		v_add3_u32 v30, v29, v30, 4
		v_xad_u32 v30, v30, v27, v14
		v_lshlrev_b32_e32 v9, 2, v9
		v_xor_b32_e32 v30, v30, v9
		v_lshl_add_u32 v30, v30, 4, v2
		ds_read_b128 a[32:35], v30 offset:18864
		v_accvgpr_read_b32 v31, a20
		v_add3_u32 v26, 6, v31, v26
		v_add3_u32 v10, v26, v10, v24
		v_add3_u32 v10, v10, v28, v29
		v_xor_b32_e32 v10, v10, v27
		v_bitop3_b32 v9, v9, v14, v10 bitop3:0x96
		v_lshl_add_u32 v2, v9, 4, v2
		ds_read_b128 a[36:39], v2 offset:18864
		s_add_i32 s1, s19, 1
		s_mul_i32 s1, s1, 0x100
		s_mov_b32 s23, 0x7f
		v_mov_b32_e32 v9, 64
		v_mul_lo_u32 v9, v9, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[16:19] offset:18864
		ds_write_b128 v1, v[44:47] offset:22960
		ds_write_b128 v1, v[20:23] offset:27056
		ds_write_b128 v1, v[48:51] offset:31152
		v_mov_b32_e32 v1, 32
		v_mul_lo_u32 v1, v1, v11
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[40:43], v25 offset:18864
		ds_read_b128 a[44:47], v12 offset:18864
		ds_read_b128 a[48:51], v30 offset:18864
		ds_read_b128 a[52:55], v2 offset:18864
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s28, v2
		s_add_i32 s1, s1, s28
		s_cmp_lt_i32 s21, s1
		s_cselect_b32 s1, s21, s1
		s_add_i32 s28, s1, 0x7f
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s28, 0
		s_cselect_b32 s29, s23, 0
		s_add_i32 s28, s28, s29
		s_ashr_i32 s28, s28, 7
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s29, v2
		s_add_i32 s29, s22, s29
		s_cmp_lt_i32 s29, 0
		s_cselect_b32 s40, s23, 0
		s_add_i32 s29, s29, s40
		s_ashr_i32 s29, s29, 7
		s_cmp_lt_i32 s29, s28
		s_cselect_b32 s29, s29, s28
		s_cmp_gt_i32 s29, 0
		s_cselect_b32 s29, s29, 0
		v_bitop3_b32 v2, v9, v1, v10 bitop3:0x96
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v15
		v_bitop3_b32 v2, v2, v13, v11 bitop3:0x96
		v_bitop3_b32 v12, 4, v9, v1 bitop3:0x96
		v_bitop3_b32 v14, 8, v9, v1 bitop3:0x96
		v_bitop3_b32 v9, 12, v9, v1 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[40:41], vcc
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v8
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v5
		v_bitop3_b32 v5, v15, v1, v8 bitop3:0x96
		v_bitop3_b32 v5, v5, v13, v11 bitop3:0x96
		v_bitop3_b32 v16, 4, v15, v1 bitop3:0x96
		v_bitop3_b32 v17, 8, v15, v1 bitop3:0x96
		v_bitop3_b32 v1, 12, v15, v1 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v5, s21
		v_readfirstlane_b32 s42, v0
		v_accvgpr_read_b32 v15, a11
		v_mul_lo_u32 v15, s15, v15
		v_accvgpr_read_b32 v18, a18
		v_mul_lo_u32 v18, s15, v18
		v_lshlrev_b32_e32 v18, 5, v18
		v_lshl_add_u32 v15, v15, 1, v18
		v_accvgpr_read_b32 v18, a19
		v_mul_lo_u32 v18, s15, v18
		v_lshl_add_u32 v15, v18, 6, v15
		v_and_b32_e32 v7, 1, v7
		v_accvgpr_write_b32 a21, v7
		v_accvgpr_read_b32 v7, a21
		v_mul_lo_u32 v7, s15, v7
		v_lshlrev_b32_e32 v7, 7, v7
		v_accvgpr_read_b32 v18, a15
		v_lshlrev_b32_e32 v18, 4, v18
		v_add3_u32 v7, v15, v7, v18
		v_accvgpr_read_b32 v15, a16
		v_lshlrev_b32_e32 v15, 6, v15
		v_accvgpr_read_b32 v19, a17
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v7, v7, v15, v19
		v_accvgpr_read_b32 v20, a14
		s_nop 0
		v_readfirstlane_b32 s43, v20
		s_mul_i32 s43, s43, s13
		s_lshl_b32 s43, s43, 1
		v_accvgpr_read_b32 v20, a10
		s_nop 0
		v_readfirstlane_b32 s44, v20
		s_mul_i32 s44, s44, s14
		s_lshl_b32 s44, s44, 1
		s_add_i32 s45, s43, s44
		v_add_u32_e32 v20, s45, v7
		v_mov_b32_e32 v21, 0x80000000
		v_cndmask_b32_e64 v20, v21, v20, s[40:41]
		s_lshr_b32 s45, s42, 6
		s_mul_i32 s46, 0x410, s45
		s_mov_b32 m0, s46
		v_xor_b32_e32 v12, v12, v10
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		s_lshl_b32 s47, s15, 3
		s_add_i32 s47, s47, s43
		s_add_i32 s47, s47, s44
		v_add_u32_e32 v20, s47, v7
		v_cndmask_b32_e64 v20, v21, v20, s[40:41]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v14, v14, v10
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		s_lshl_b32 s47, s15, 4
		s_add_i32 s47, s47, s43
		s_add_i32 s47, s47, s44
		v_add_u32_e32 v20, s47, v7
		v_cndmask_b32_e64 v20, v21, v20, s[40:41]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v9, v9, v10
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		v_bitop3_b32 v9, v9, v13, v11 bitop3:0x96
		v_accvgpr_write_b32 a22, v9
		s_mul_i32 s47, 24, s15
		s_add_i32 s47, s47, s43
		s_add_i32 s47, s47, s44
		v_add_u32_e32 v9, s47, v7
		v_cndmask_b32_e64 v9, v21, v9, s[40:41]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v10, v16, v8
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_bitop3_b32 v9, v10, v13, v11 bitop3:0x96
		v_accvgpr_write_b32 a23, v9
		v_accvgpr_read_b32 v9, a11
		v_mul_lo_u32 v9, s17, v9
		v_accvgpr_read_b32 v10, a18
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 7, v10
		v_lshl_add_u32 v9, v9, 1, v10
		v_accvgpr_read_b32 v10, a19
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v9, v10, 6, v9
		v_accvgpr_read_b32 v10, a21
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v9, v9, v10, v18
		v_add3_u32 v9, v9, v15, v19
		v_accvgpr_read_b32 v10, a0
		s_nop 0
		v_readfirstlane_b32 s40, v10
		v_accvgpr_read_b32 v10, a14
		s_nop 0
		v_readfirstlane_b32 s41, v10
		s_mul_i32 s40, s41, s40
		s_lshl_b32 s40, s40, 1
		v_accvgpr_read_b32 v10, a1
		s_nop 0
		v_readfirstlane_b32 s41, v10
		v_accvgpr_read_b32 v10, a10
		s_nop 0
		v_readfirstlane_b32 s47, v10
		s_mul_i32 s41, s47, s41
		s_lshl_b32 s41, s41, 1
		s_add_i32 s47, s40, s41
		v_add_u32_e32 v10, s47, v9
		v_cndmask_b32_e32 v10, v21, v10, vcc
		s_mul_i32 s45, 0x440, s45
		s_add_i32 m0, s45, 0x81f0
		v_xor_b32_e32 v15, v17, v8
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		v_bitop3_b32 v10, v15, v13, v11 bitop3:0x96
		v_accvgpr_write_b32 a56, v10
		s_lshl_b32 s47, s17, 3
		s_add_i32 s47, s47, s40
		s_add_i32 s47, s47, s41
		v_add_u32_e32 v10, s47, v9
		v_cndmask_b32_e32 v10, v21, v10, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v1, v1, v8
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		v_bitop3_b32 v1, v1, v13, v11 bitop3:0x96
		v_accvgpr_write_b32 a57, v1
		s_lshl_b32 s47, s17, 4
		s_add_i32 s47, s47, s40
		s_add_i32 s47, s47, s41
		v_add_u32_e32 v1, s47, v9
		v_cndmask_b32_e32 v1, v21, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v8, v12, v13, v11 bitop3:0x96
		buffer_load_dwordx4 v1, s[36:39], 0 offen lds
		s_mul_i32 s47, 24, s17
		s_add_i32 s47, s47, s40
		s_add_i32 s47, s47, s41
		v_add_u32_e32 v1, s47, v9
		v_cndmask_b32_e32 v1, v21, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v10, v14, v13, v11 bitop3:0x96
		buffer_load_dwordx4 v1, s[36:39], 0 offen lds
		s_mul_i32 s47, s29, 0x80
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v11, 1, v1
		v_lshrrev_b32_e32 v12, 4, v1
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 4, v12
		v_lshrrev_b32_e32 v13, 3, v1
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 3, v13
		v_add3_u32 v14, v11, v12, v13
		v_lshrrev_b32_e32 v15, 2, v1
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 2, v15
		v_lshrrev_b32_e32 v1, 1, v1
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_add3_u32 v14, v14, v15, v1
		v_add_u32_e32 v11, 32, v11
		v_bitop3_b32 v1, v15, v11, v1 bitop3:0x96
		v_bitop3_b32 v1, v12, v13, v1 bitop3:0x96
		v_mov_b32_e32 v12, 0x3e38aa3b
		v_mov_b32_e32 v13, 0x3e38aa3b
		s_mov_b32 s29, 0xff800000
		v_mov_b32_e32 v11, s29
		v_mov_b32_e32 v15, s29
		s_mov_b32 s29, 1.0
		v_mov_b32_e32 v16, s29
		v_mov_b32_e32 v17, s29
		s_mov_b32 s29, 0
		v_accvgpr_read_b32 v18, a20
		v_lshlrev_b32_e32 v18, 4, v18
		v_accvgpr_write_b32 a58, v18
		v_and_b32_e32 v4, 31, v4
		v_lshrrev_b32_e32 v18, 4, v4
		v_lshlrev_b32_e32 v18, 9, v18
		v_accvgpr_write_b32 a59, v18
		v_lshrrev_b32_e32 v18, 3, v4
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 0x2080
		v_mul_lo_u32 v19, v19, v18
		v_accvgpr_write_b32 a60, v19
		v_lshrrev_b32_e32 v18, 2, v4
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 0x1040
		v_mul_lo_u32 v19, v19, v18
		v_accvgpr_write_b32 a61, v19
		v_lshrrev_b32_e32 v18, 1, v4
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 0x820
		v_mul_lo_u32 v19, v19, v18
		v_accvgpr_write_b32 a62, v19
		v_and_b32_e32 v4, 1, v4
		v_mov_b32_e32 v18, 0x410
		v_mul_lo_u32 v18, v18, v4
		v_accvgpr_write_b32 a63, v18
		v_and_b32_e32 v4, 3, v0
		v_accvgpr_write_b32 a64, v4
		v_accvgpr_read_b32 v4, a64
		v_lshlrev_b32_e32 v4, 3, v4
		v_accvgpr_write_b32 a65, v4
		v_accvgpr_read_b32 v4, a18
		v_mov_b32_e32 v18, 0x2200
		v_mul_lo_u32 v18, v18, v4
		v_accvgpr_write_b32 a66, v18
		v_accvgpr_read_b32 v4, a19
		v_lshlrev_b32_e32 v4, 5, v4
		v_accvgpr_write_b32 a67, v4
		v_and_b32_e32 v3, 3, v3
		v_mov_b32_e32 v4, 0x440
		v_mul_lo_u32 v4, v4, v3
		v_accvgpr_write_b32 a68, v4
		s_lshl_b32 s48, s15, 8
		s_add_i32 s48, s48, s43
		s_add_i32 s48, s48, s44
		s_mul_i32 s49, 0x108, s15
		s_add_i32 s49, s49, s43
		s_add_i32 s49, s49, s44
		s_mul_i32 s50, 0x110, s15
		s_add_i32 s50, s50, s43
		s_add_i32 s50, s50, s44
		s_mul_i32 s51, 0x118, s15
		s_add_i32 s43, s51, s43
		s_add_i32 s44, s43, s44
		s_lshl_b32 s43, s17, 8
		s_add_i32 s43, s43, s40
		s_add_i32 s51, s43, s41
		s_mul_i32 s43, 0x108, s17
		s_add_i32 s43, s43, s40
		s_add_i32 s52, s43, s41
		s_mul_i32 s43, 0x110, s17
		s_add_i32 s43, s43, s40
		s_add_i32 s53, s43, s41
		s_mul_i32 s43, 0x118, s17
		s_add_i32 s40, s43, s40
		s_add_i32 s40, s40, s41
		v_lshlrev_b32_e32 v3, 2, v14
		v_accvgpr_write_b32 a69, v3
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a70, v1
		s_cmp_lt_i32 0, s47
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
		s_lshr_b32 s41, s29, 7
		s_and_b32 s43, s41, 1
		s_mul_i32 s54, 0x4100, s43
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v3, a59
		v_add3_u32 v1, s54, v1, v3
		v_accvgpr_read_b32 v3, a60
		v_accvgpr_read_b32 v4, a61
		v_add3_u32 v1, v1, v3, v4
		v_accvgpr_read_b32 v3, a62
		v_accvgpr_read_b32 v4, a63
		v_add3_u32 v1, v1, v3, v4
		ds_read_b128 v[24:27], v1
		ds_read_b128 a[72:75], v1 offset:32
		ds_read_b128 a[76:79], v1 offset:64
		ds_read_b128 a[80:83], v1 offset:96
		ds_read_b128 v[28:31], v1 offset:256
		ds_read_b128 a[84:87], v1 offset:288
		ds_read_b128 a[88:91], v1 offset:320
		ds_read_b128 a[92:95], v1 offset:352
		ds_read_b128 v[96:99], v1 offset:128
		ds_read_b128 a[96:99], v1 offset:160
		ds_read_b128 a[100:103], v1 offset:192
		ds_read_b128 a[104:107], v1 offset:224
		ds_read_b128 v[100:103], v1 offset:384
		ds_read_b128 a[108:111], v1 offset:416
		ds_read_b128 a[112:115], v1 offset:448
		ds_read_b128 a[116:119], v1 offset:480
		s_mul_i32 s43, 0x4400, s43
		v_accvgpr_read_b32 v1, a65
		v_accvgpr_read_b32 v3, a66
		v_add3_u32 v1, s43, v1, v3
		v_accvgpr_read_b32 v3, a67
		v_accvgpr_read_b32 v4, a68
		v_add3_u32 v1, v1, v3, v4
		ds_read_b64_tr_b16 a[120:121], v1 offset:33264
		ds_read_b64_tr_b16 a[122:123], v1 offset:37616
		ds_read_b64_tr_b16 a[124:125], v1 offset:33392
		ds_read_b64_tr_b16 a[126:127], v1 offset:37744
		ds_read_b64_tr_b16 a[128:129], v1 offset:33520
		ds_read_b64_tr_b16 a[130:131], v1 offset:37872
		ds_read_b64_tr_b16 a[132:133], v1 offset:33648
		ds_read_b64_tr_b16 a[134:135], v1 offset:38000
		ds_read_b64_tr_b16 a[136:137], v1 offset:33776
		ds_read_b64_tr_b16 a[138:139], v1 offset:38128
		ds_read_b64_tr_b16 a[140:141], v1 offset:33904
		ds_read_b64_tr_b16 a[142:143], v1 offset:38256
		ds_read_b64_tr_b16 a[144:145], v1 offset:34032
		ds_read_b64_tr_b16 a[146:147], v1 offset:38384
		ds_read_b64_tr_b16 a[148:149], v1 offset:34160
		ds_read_b64_tr_b16 a[150:151], v1 offset:38512
		ds_read_b64_tr_b16 a[152:153], v1 offset:33328
		ds_read_b64_tr_b16 a[154:155], v1 offset:37680
		ds_read_b64_tr_b16 a[156:157], v1 offset:33456
		ds_read_b64_tr_b16 a[158:159], v1 offset:37808
		ds_read_b64_tr_b16 a[160:161], v1 offset:33584
		ds_read_b64_tr_b16 a[162:163], v1 offset:37936
		ds_read_b64_tr_b16 a[164:165], v1 offset:33712
		ds_read_b64_tr_b16 a[166:167], v1 offset:38064
		ds_read_b64_tr_b16 a[168:169], v1 offset:33840
		ds_read_b64_tr_b16 a[170:171], v1 offset:38192
		ds_read_b64_tr_b16 a[172:173], v1 offset:33968
		ds_read_b64_tr_b16 a[174:175], v1 offset:38320
		ds_read_b64_tr_b16 a[176:177], v1 offset:34096
		ds_read_b64_tr_b16 a[178:179], v1 offset:38448
		ds_read_b64_tr_b16 a[180:181], v1 offset:34224
		ds_read_b64_tr_b16 a[182:183], v1 offset:38576
		s_mul_i32 s43, s15, s29
		s_lshl_b32 s43, s43, 1
		s_add_i32 s54, s48, s43
		v_add_u32_e32 v1, s54, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v3, s43, v7
		s_add_i32 s41, s41, 1
		v_add_u32_e32 v4, s49, v3
		s_and_b32 s41, s41, 1
		v_add_u32_e32 v14, s50, v3
		s_mul_i32 s43, 0x4100, s41
		v_add_u32_e32 v3, s44, v3
		s_add_i32 s43, s46, s43
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[24:27], 0
		s_mov_b32 m0, s43
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[24:27], 0
		s_mul_i32 s43, s17, s29
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], 0
		s_add_i32 s29, s29, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[24:27], 0
		v_add_u32_e32 v18, s29, v2
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[40:43], 0
		v_add_u32_e32 v19, s29, v8
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[40:43], 0
		v_add_u32_e32 v20, s29, v10
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[40:43], 0
		v_accvgpr_read_b32 v22, a22
		v_add_u32_e32 v22, s29, v22
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], a[40:43], 0
		v_cmp_lt_i32_e64 vcc, v18, s21
		s_mov_b64 s[54:55], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[72:75], a[28:31], v[112:127]
		v_cmp_lt_i32_e64 vcc, v19, s21
		s_mov_b64 s[56:57], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[84:87], a[28:31], v[128:143]
		v_cmp_lt_i32_e64 vcc, v20, s21
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[96:99], a[28:31], v[144:159]
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[108:111], a[28:31], v[160:175]
		v_add_u32_e32 v18, s29, v5
		v_mfma_f32_32x32x16_bf16 v[176:191], a[108:111], a[44:47], v[176:191]
		v_accvgpr_read_b32 v19, a23
		v_add_u32_e32 v19, s29, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[44:47], v[192:207]
		v_accvgpr_read_b32 v20, a56
		v_add_u32_e32 v20, s29, v20
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[44:47], v[208:223]
		v_cmp_lt_i32_e64 vcc, v18, s21
		s_mov_b64 s[62:63], vcc
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[44:47], v[224:239]
		v_cmp_lt_i32_e64 vcc, v19, s21
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[32:35], v[112:127]
		v_cmp_lt_i32_e64 vcc, v20, s21
		s_mov_b64 s[66:67], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[32:35], v[128:143]
		v_cndmask_b32_e64 v1, v21, v1, s[54:55]
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[32:35], v[144:159]
		v_accvgpr_read_b32 v1, a57
		v_add_u32_e32 v1, s29, v1
		v_cndmask_b32_e64 v4, v21, v4, s[56:57]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v14, v21, v14, s[58:59]
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v3, v21, v3, s[60:61]
		v_cmp_lt_i32_e64 vcc, v1, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s43, s43, 1
		s_add_i32 s54, s51, s43
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_add_u32_e32 v1, s54, v9
		v_cndmask_b32_e64 v1, v21, v1, s[62:63]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s41, 0x4400, s41
		s_add_i32 s41, s45, s41
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_add_u32_e32 v3, s43, v9
		v_add_u32_e32 v4, s52, v3
		s_add_i32 m0, s41, 0x81f0
		v_cndmask_b32_e64 v4, v21, v4, s[64:65]
		v_add_u32_e32 v14, s53, v3
		buffer_load_dwordx4 v1, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v1, v21, v14, s[66:67]
		v_add_u32_e32 v3, s40, v3
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v3, v21, v3, vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[112:115], a[32:35], v[160:175]
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[112:115], a[48:51], v[176:191]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[48:51], v[224:239]
		buffer_load_dwordx4 v1, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[36:39], v[112:127]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s29, s47
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[52:55], v[192:207]
		buffer_load_dwordx4 v3, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[52:55], v[224:239]
		s_nop 1
		v_max3_f32 v1, v112, v113, v114
		v_max3_f32 v3, v116, v117, v118
		v_max3_f32 v4, v120, v121, v122
		v_max3_f32 v14, v124, v125, v126
		v_max3_f32 v18, v128, v129, v130
		v_max3_f32 v19, v132, v133, v134
		v_max3_f32 v20, v136, v137, v138
		v_max3_f32 v22, v140, v141, v142
		v_max3_f32 v23, v144, v145, v146
		v_max3_f32 v24, v148, v149, v150
		v_max3_f32 v25, v152, v153, v154
		v_max3_f32 v26, v156, v157, v158
		v_max3_f32 v27, v160, v161, v162
		v_max3_f32 v28, v164, v165, v166
		v_max3_f32 v29, v168, v169, v170
		v_max3_f32 v30, v172, v173, v174
		v_max3_f32 v1, v1, v115, v3
		v_max3_f32 v3, v4, v123, v14
		v_max3_f32 v4, v18, v131, v19
		v_max3_f32 v14, v20, v139, v22
		v_max3_f32 v18, v23, v147, v24
		v_max3_f32 v19, v25, v155, v26
		v_max3_f32 v20, v27, v163, v28
		v_max3_f32 v22, v29, v171, v30
		v_max3_f32 v1, v1, v119, v3
		v_max3_f32 v3, v4, v135, v14
		v_max3_f32 v4, v18, v151, v19
		v_max3_f32 v14, v20, v167, v22
		v_max3_f32 v1, v1, v127, v3
		v_max3_f32 v3, v4, v159, v14
		v_max3_f32 v1, v1, v143, v3
		v_max_f32_e32 v1, v1, v175
		v_mov_b32_e32 v18, v1
		v_mov_b32_e32 v19, v1
		s_nop 1
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v22, v18, v19
		v_max3_f32 v1, v192, v193, v194
		v_max3_f32 v3, v196, v197, v198
		v_max3_f32 v4, v200, v201, v202
		v_max3_f32 v14, v204, v205, v206
		v_max3_f32 v18, v208, v209, v210
		v_max3_f32 v19, v212, v213, v214
		v_max3_f32 v20, v216, v217, v218
		v_max3_f32 v23, v220, v221, v222
		v_max3_f32 v24, v224, v225, v226
		v_max3_f32 v25, v228, v229, v230
		v_max3_f32 v26, v232, v233, v234
		v_max3_f32 v27, v236, v237, v238
		v_max3_f32 v28, v176, v177, v178
		v_max3_f32 v29, v180, v181, v182
		v_max3_f32 v30, v184, v185, v186
		v_max3_f32 v31, v188, v189, v190
		v_max3_f32 v1, v1, v195, v3
		v_max3_f32 v3, v4, v203, v14
		v_max3_f32 v4, v18, v211, v19
		v_max3_f32 v14, v20, v219, v23
		v_max3_f32 v18, v24, v227, v25
		v_max3_f32 v19, v26, v235, v27
		v_max3_f32 v20, v28, v179, v29
		v_max3_f32 v23, v30, v187, v31
		v_max3_f32 v1, v1, v199, v3
		v_max3_f32 v3, v4, v215, v14
		v_max3_f32 v4, v18, v231, v19
		v_max3_f32 v14, v20, v183, v23
		v_max3_f32 v1, v1, v207, v3
		v_max3_f32 v3, v4, v239, v14
		v_max3_f32 v1, v1, v223, v3
		v_max_f32_e32 v1, v1, v191
		v_mov_b32_e32 v18, v1
		v_mov_b32_e32 v19, v1
		s_nop 1
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v23, v18, v19
		v_pk_mul_f32 v[18:19], v[22:23], v[12:13]
		v_max_f32_e32 v22, v11, v18
		v_max_f32_e32 v23, v15, v19
		v_pk_fma_f32 v[18:19], v[112:113], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[114:115], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[116:117], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[118:119], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[120:121], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[122:123], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[124:125], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[126:127], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[128:129], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[130:131], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[132:133], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[134:135], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[136:137], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[138:139], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[140:141], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[142:143], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[144:145], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[146:147], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[148:149], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[150:151], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[152:153], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[154:155], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[156:157], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[158:159], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[160:161], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[164:165], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[166:167], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[168:169], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[170:171], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[172:173], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[174:175], v[12:13], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[192:193], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[194:195], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[196:197], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[198:199], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[200:201], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[202:203], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[204:205], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[206:207], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[208:209], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[210:211], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[212:213], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[214:215], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[216:217], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[224:225], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[226:227], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[228:229], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[230:231], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[232:233], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[234:235], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[236:237], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[238:239], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[176:177], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[12:13], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v18
		v_exp_f32_e32 v216, v19
		v_exp_f32_e32 v191, v24
		v_exp_f32_e32 v217, v25
		v_exp_f32_e32 v18, v26
		v_exp_f32_e32 v24, v27
		v_exp_f32_e32 v19, v28
		v_exp_f32_e32 v25, v29
		v_exp_f32_e32 v26, v30
		v_exp_f32_e32 v28, v31
		v_exp_f32_e32 v27, v96
		v_exp_f32_e32 v29, v97
		v_exp_f32_e32 v30, v98
		v_exp_f32_e32 v96, v99
		v_exp_f32_e32 v31, v100
		v_exp_f32_e32 v97, v101
		v_exp_f32_e32 v98, v102
		v_exp_f32_e32 v100, v103
		v_exp_f32_e32 v99, v104
		v_exp_f32_e32 v101, v105
		v_exp_f32_e32 v102, v106
		v_exp_f32_e32 v104, v107
		v_exp_f32_e32 v103, v108
		v_exp_f32_e32 v105, v109
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v108, v111
		v_exp_f32_e32 v107, v112
		v_exp_f32_e32 v109, v113
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v112, v115
		v_exp_f32_e32 v111, v116
		v_exp_f32_e32 v113, v117
		v_exp_f32_e32 v114, v118
		v_exp_f32_e32 v116, v119
		v_exp_f32_e32 v115, v120
		v_exp_f32_e32 v117, v121
		v_exp_f32_e32 v118, v122
		v_exp_f32_e32 v120, v123
		v_exp_f32_e32 v119, v124
		v_exp_f32_e32 v121, v125
		v_exp_f32_e32 v122, v126
		v_exp_f32_e32 v124, v127
		v_exp_f32_e32 v123, v128
		v_exp_f32_e32 v125, v129
		v_exp_f32_e32 v126, v130
		v_exp_f32_e32 v128, v131
		v_exp_f32_e32 v127, v132
		v_exp_f32_e32 v129, v133
		v_exp_f32_e32 v130, v134
		v_exp_f32_e32 v132, v135
		v_exp_f32_e32 v131, v136
		v_exp_f32_e32 v133, v137
		v_exp_f32_e32 v134, v138
		v_exp_f32_e32 v136, v139
		v_exp_f32_e32 v135, v140
		v_exp_f32_e32 v137, v141
		v_exp_f32_e32 v138, v142
		v_exp_f32_e32 v140, v143
		v_exp_f32_e32 v139, v144
		v_exp_f32_e32 v141, v145
		v_exp_f32_e32 v142, v146
		v_exp_f32_e32 v144, v147
		v_exp_f32_e32 v143, v148
		v_exp_f32_e32 v145, v149
		v_exp_f32_e32 v147, v150
		v_exp_f32_e32 v149, v151
		v_exp_f32_e32 v150, v152
		v_exp_f32_e32 v218, v153
		v_exp_f32_e32 v151, v154
		v_exp_f32_e32 v219, v155
		v_exp_f32_e32 v152, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v153, v158
		v_exp_f32_e32 v155, v159
		v_exp_f32_e32 v156, v160
		v_exp_f32_e32 v158, v161
		v_exp_f32_e32 v157, v162
		v_exp_f32_e32 v159, v163
		v_exp_f32_e32 v160, v164
		v_exp_f32_e32 v162, v165
		v_exp_f32_e32 v161, v166
		v_exp_f32_e32 v163, v167
		v_exp_f32_e32 v164, v168
		v_exp_f32_e32 v166, v169
		v_exp_f32_e32 v165, v170
		v_exp_f32_e32 v167, v171
		v_exp_f32_e32 v168, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v169, v174
		v_exp_f32_e32 v171, v175
		v_exp_f32_e32 v172, v192
		v_exp_f32_e32 v174, v193
		v_exp_f32_e32 v173, v194
		v_exp_f32_e32 v175, v195
		v_exp_f32_e32 v192, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v193, v198
		v_exp_f32_e32 v195, v199
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v197, v202
		v_exp_f32_e32 v199, v203
		v_exp_f32_e32 v200, v204
		v_exp_f32_e32 v202, v205
		v_exp_f32_e32 v201, v206
		v_exp_f32_e32 v203, v207
		v_exp_f32_e32 v204, v208
		v_exp_f32_e32 v206, v209
		v_exp_f32_e32 v205, v210
		v_exp_f32_e32 v207, v211
		v_exp_f32_e32 v208, v212
		v_exp_f32_e32 v210, v213
		v_exp_f32_e32 v209, v214
		v_exp_f32_e32 v211, v215
		v_exp_f32_e32 v212, v176
		v_exp_f32_e32 v214, v177
		v_exp_f32_e32 v213, v178
		v_exp_f32_e32 v215, v179
		v_exp_f32_e32 v176, v180
		v_exp_f32_e32 v178, v181
		v_exp_f32_e32 v177, v182
		v_exp_f32_e32 v179, v183
		v_exp_f32_e32 v180, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v181, v186
		v_exp_f32_e32 v183, v187
		v_exp_f32_e32 v184, v188
		v_exp_f32_e32 v186, v189
		v_pk_add_f32 v[188:189], v[190:191], v[216:217]
		v_pk_add_f32 v[220:221], v[18:19], v[24:25]
		v_pk_add_f32 v[222:223], v[26:27], v[28:29]
		v_pk_add_f32 v[224:225], v[30:31], v[96:97]
		v_pk_add_f32 v[226:227], v[98:99], v[100:101]
		v_pk_add_f32 v[228:229], v[102:103], v[104:105]
		v_pk_add_f32 v[230:231], v[106:107], v[108:109]
		v_pk_add_f32 v[232:233], v[110:111], v[112:113]
		v_pk_add_f32 v[234:235], v[114:115], v[116:117]
		v_pk_add_f32 v[236:237], v[118:119], v[120:121]
		v_pk_add_f32 v[238:239], v[122:123], v[124:125]
		v_pk_add_f32 v[240:241], v[126:127], v[128:129]
		v_pk_add_f32 v[242:243], v[130:131], v[132:133]
		v_pk_add_f32 v[244:245], v[134:135], v[136:137]
		v_pk_add_f32 v[246:247], v[138:139], v[140:141]
		v_pk_add_f32 v[248:249], v[142:143], v[144:145]
		v_mov_b32_e32 v250, v189
		v_mov_b32_e32 v251, v221
		v_mov_b32_e32 v252, v188
		v_mov_b32_e32 v253, v220
		v_pk_add_f32 v[188:189], v[252:253], v[250:251]
		v_mov_b32_e32 v220, v223
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v250, v222
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[222:223], v[250:251], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v224, v226
		v_mov_b32_e32 v225, v228
		v_pk_add_f32 v[226:227], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v233
		v_mov_b32_e32 v224, v230
		v_mov_b32_e32 v225, v232
		v_pk_add_f32 v[228:229], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v235
		v_mov_b32_e32 v221, v237
		v_mov_b32_e32 v224, v234
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[230:231], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v239
		v_mov_b32_e32 v221, v241
		v_mov_b32_e32 v224, v238
		v_mov_b32_e32 v225, v240
		v_pk_add_f32 v[232:233], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v243
		v_mov_b32_e32 v221, v245
		v_mov_b32_e32 v224, v242
		v_mov_b32_e32 v225, v244
		v_pk_add_f32 v[234:235], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v247
		v_mov_b32_e32 v221, v249
		v_mov_b32_e32 v224, v246
		v_mov_b32_e32 v225, v248
		v_pk_add_f32 v[236:237], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v189
		v_mov_b32_e32 v221, v223
		v_mov_b32_e32 v224, v188
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[188:189], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v233
		v_mov_b32_e32 v222, v230
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[226:227], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v235
		v_mov_b32_e32 v221, v237
		v_mov_b32_e32 v222, v234
		v_mov_b32_e32 v223, v236
		v_pk_add_f32 v[228:229], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v189
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v188
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[188:189], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v189
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v188
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[188:189], v[222:223], v[220:221]
		v_add_f32_e32 v1, v188, v189
		v_accvgpr_read_b32 v3, a69
		ds_bpermute_b32 v146, v3, v1
		v_accvgpr_read_b32 v3, a70
		ds_bpermute_b32 v148, v3, v1
		v_pk_add_f32 v[188:189], v[150:151], v[218:219]
		v_pk_add_f32 v[220:221], v[152:153], v[154:155]
		v_pk_add_f32 v[222:223], v[156:157], v[158:159]
		v_pk_add_f32 v[224:225], v[160:161], v[162:163]
		v_pk_add_f32 v[226:227], v[164:165], v[166:167]
		v_pk_add_f32 v[228:229], v[168:169], v[170:171]
		v_pk_add_f32 v[230:231], v[172:173], v[174:175]
		v_pk_add_f32 v[232:233], v[192:193], v[194:195]
		v_pk_add_f32 v[234:235], v[196:197], v[198:199]
		v_pk_add_f32 v[236:237], v[200:201], v[202:203]
		v_pk_add_f32 v[238:239], v[204:205], v[206:207]
		v_pk_add_f32 v[240:241], v[208:209], v[210:211]
		v_pk_add_f32 v[242:243], v[212:213], v[214:215]
		v_pk_add_f32 v[244:245], v[176:177], v[178:179]
		v_pk_add_f32 v[246:247], v[180:181], v[182:183]
		v_mov_b32_e32 v248, v189
		v_mov_b32_e32 v249, v222
		v_pk_add_f32 v[250:251], v[248:249], v[220:221]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[220:221], v[146:147], v[148:149]
		v_mov_b32_e32 v185, v221
		v_mov_b32_e32 v187, v188
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_mov_b32_e32 v248, v223
		v_mov_b32_e32 v249, v226
		v_pk_add_f32 v[222:223], v[248:249], v[224:225]
		v_mov_b32_e32 v224, v227
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[228:229]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[224:225], v[224:225], v[232:233]
		v_mov_b32_e32 v228, v235
		v_mov_b32_e32 v229, v238
		v_pk_add_f32 v[230:231], v[228:229], v[236:237]
		v_mov_b32_e32 v228, v239
		v_mov_b32_e32 v229, v242
		v_pk_add_f32 v[228:229], v[228:229], v[240:241]
		v_mov_b32_e32 v232, v243
		v_mov_b32_e32 v233, v246
		v_pk_add_f32 v[234:235], v[232:233], v[244:245]
		v_mov_b32_e32 v232, v247
		v_mov_b32_e32 v233, v250
		v_pk_add_f32 v[188:189], v[232:233], v[188:189]
		v_mov_b32_e32 v232, v251
		v_mov_b32_e32 v233, v226
		v_pk_add_f32 v[236:237], v[232:233], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v230
		v_pk_add_f32 v[222:223], v[222:223], v[224:225]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[226:227], v[224:225], v[228:229]
		v_mov_b32_e32 v224, v235
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[188:189], v[224:225], v[188:189]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[228:229], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[188:189]
		v_add_f32_e32 v1, v229, v224
		v_add_f32_e32 v1, v225, v1
		v_mov_b32_e32 v188, v1
		v_mov_b32_e32 v189, v1
		s_nop 1
		v_permlane32_swap_b32_e32 v188, v189
		v_add_f32_e32 v223, v188, v189
		v_sub_f32_e32 v1, v11, v22
		v_sub_f32_e32 v3, v15, v23
		v_exp_f32_e32 v14, v1
		v_exp_f32_e32 v188, v3
		v_mov_b32_e32 v15, v14
		v_pk_mul_f32 v[32:33], v[32:33], v[14:15]
		v_pk_mul_f32 v[34:35], v[34:35], v[14:15]
		v_pk_mul_f32 v[36:37], v[36:37], v[14:15]
		v_pk_mul_f32 v[38:39], v[38:39], v[14:15]
		v_pk_mul_f32 v[40:41], v[40:41], v[14:15]
		v_pk_mul_f32 v[42:43], v[42:43], v[14:15]
		v_pk_mul_f32 v[44:45], v[44:45], v[14:15]
		v_pk_mul_f32 v[46:47], v[46:47], v[14:15]
		v_pk_mul_f32 v[48:49], v[48:49], v[14:15]
		v_pk_mul_f32 v[50:51], v[50:51], v[14:15]
		v_pk_mul_f32 v[52:53], v[52:53], v[14:15]
		v_pk_mul_f32 v[54:55], v[54:55], v[14:15]
		v_pk_mul_f32 v[56:57], v[56:57], v[14:15]
		v_pk_mul_f32 v[58:59], v[58:59], v[14:15]
		v_pk_mul_f32 v[60:61], v[60:61], v[14:15]
		v_pk_mul_f32 v[62:63], v[62:63], v[14:15]
		v_mov_b32_e32 v189, v188
		v_pk_mul_f32 v[64:65], v[64:65], v[188:189]
		v_pk_mul_f32 v[66:67], v[66:67], v[188:189]
		v_pk_mul_f32 v[68:69], v[68:69], v[188:189]
		v_pk_mul_f32 v[70:71], v[70:71], v[188:189]
		v_pk_mul_f32 v[72:73], v[72:73], v[188:189]
		v_pk_mul_f32 v[74:75], v[74:75], v[188:189]
		v_pk_mul_f32 v[76:77], v[76:77], v[188:189]
		v_pk_mul_f32 v[78:79], v[78:79], v[188:189]
		v_pk_mul_f32 v[80:81], v[80:81], v[188:189]
		v_pk_mul_f32 v[82:83], v[82:83], v[188:189]
		v_pk_mul_f32 v[84:85], v[84:85], v[188:189]
		v_pk_mul_f32 v[86:87], v[86:87], v[188:189]
		v_pk_mul_f32 v[88:89], v[88:89], v[188:189]
		v_pk_mul_f32 v[90:91], v[90:91], v[188:189]
		v_pk_mul_f32 v[92:93], v[92:93], v[188:189]
		v_pk_mul_f32 v[94:95], v[94:95], v[188:189]
		v_mov_b32_e32 v224, v14
		v_mov_b32_e32 v225, v188
		v_mov_b32_e32 v222, v220
		v_mov_b64_e32 v[14:15], v[16:17]
		v_pk_fma_f32 v[16:17], v[14:15], v[224:225], v[222:223]
		v_cvt_pk_bf16_f32 v220, v190, v216
		v_cvt_pk_bf16_f32 v221, v191, v217
		v_cvt_pk_bf16_f32 v222, v18, v24
		v_cvt_pk_bf16_f32 v223, v19, v25
		v_cvt_pk_bf16_f32 v188, v26, v28
		v_cvt_pk_bf16_f32 v189, v27, v29
		v_cvt_pk_bf16_f32 v190, v30, v96
		v_cvt_pk_bf16_f32 v191, v31, v97
		v_cvt_pk_bf16_f32 v24, v98, v100
		v_cvt_pk_bf16_f32 v25, v99, v101
		v_cvt_pk_bf16_f32 v26, v102, v104
		v_cvt_pk_bf16_f32 v27, v103, v105
		v_cvt_pk_bf16_f32 v28, v106, v108
		v_cvt_pk_bf16_f32 v29, v107, v109
		v_cvt_pk_bf16_f32 v30, v110, v112
		v_cvt_pk_bf16_f32 v31, v111, v113
		v_cvt_pk_bf16_f32 v96, v114, v116
		v_cvt_pk_bf16_f32 v97, v115, v117
		v_cvt_pk_bf16_f32 v98, v118, v120
		v_cvt_pk_bf16_f32 v99, v119, v121
		v_cvt_pk_bf16_f32 v100, v122, v124
		v_cvt_pk_bf16_f32 v101, v123, v125
		v_cvt_pk_bf16_f32 v102, v126, v128
		v_cvt_pk_bf16_f32 v103, v127, v129
		v_cvt_pk_bf16_f32 v104, v130, v132
		v_cvt_pk_bf16_f32 v105, v131, v133
		v_cvt_pk_bf16_f32 v106, v134, v136
		v_cvt_pk_bf16_f32 v107, v135, v137
		v_cvt_pk_bf16_f32 v108, v138, v140
		v_cvt_pk_bf16_f32 v109, v139, v141
		v_cvt_pk_bf16_f32 v110, v142, v144
		v_cvt_pk_bf16_f32 v111, v143, v145
		v_cvt_pk_bf16_f32 v112, v147, v149
		v_cvt_pk_bf16_f32 v113, v150, v218
		v_cvt_pk_bf16_f32 v114, v151, v219
		v_cvt_pk_bf16_f32 v115, v152, v154
		v_cvt_pk_bf16_f32 v116, v153, v155
		v_cvt_pk_bf16_f32 v117, v156, v158
		v_cvt_pk_bf16_f32 v118, v157, v159
		v_cvt_pk_bf16_f32 v119, v160, v162
		v_cvt_pk_bf16_f32 v120, v161, v163
		v_cvt_pk_bf16_f32 v121, v164, v166
		v_cvt_pk_bf16_f32 v122, v165, v167
		v_cvt_pk_bf16_f32 v123, v168, v170
		v_cvt_pk_bf16_f32 v124, v169, v171
		v_cvt_pk_bf16_f32 v125, v172, v174
		v_cvt_pk_bf16_f32 v126, v173, v175
		v_cvt_pk_bf16_f32 v127, v192, v194
		v_cvt_pk_bf16_f32 v128, v193, v195
		v_cvt_pk_bf16_f32 v129, v196, v198
		v_cvt_pk_bf16_f32 v130, v197, v199
		v_cvt_pk_bf16_f32 v131, v200, v202
		v_cvt_pk_bf16_f32 v132, v201, v203
		v_cvt_pk_bf16_f32 v133, v204, v206
		v_cvt_pk_bf16_f32 v134, v205, v207
		v_cvt_pk_bf16_f32 v135, v208, v210
		v_cvt_pk_bf16_f32 v136, v209, v211
		v_cvt_pk_bf16_f32 v137, v212, v214
		v_cvt_pk_bf16_f32 v138, v213, v215
		v_cvt_pk_bf16_f32 v139, v176, v178
		v_cvt_pk_bf16_f32 v140, v177, v179
		v_cvt_pk_bf16_f32 v141, v180, v182
		v_cvt_pk_bf16_f32 v142, v181, v183
		v_cvt_pk_bf16_f32 v143, v184, v186
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[24:27], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[24:27], v[48:63]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[28:31], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[96:99], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[112:115], v[80:95]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[112:115], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[140:143], v[64:79]
		v_mov_b32_e32 v11, v22
		v_mov_b32_e32 v15, v23
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s28, s28, 0x80
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s29, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_add_u32_e32 v1, s29, v1
		v_add_u32_e32 v1, s22, v1
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s29, v3
		v_accvgpr_read_b32 v3, a13
		s_nop 0
		v_add_u32_e32 v3, s29, v3
		v_add_u32_e32 v3, s22, v3
		v_xor_b32_e32 v4, 1, v6
		v_accvgpr_write_b32 a12, v4
		v_xor_b32_e32 v4, 2, v6
		v_accvgpr_write_b32 a13, v4
		v_xor_b32_e32 v4, 3, v6
		v_accvgpr_write_b32 a58, v4
		v_xor_b32_e32 v4, 8, v6
		v_accvgpr_write_b32 a65, v4
		v_xor_b32_e32 v4, 9, v6
		v_accvgpr_write_b32 a71, v4
		v_xor_b32_e32 v4, 10, v6
		v_accvgpr_write_b32 a72, v4
		v_xor_b32_e32 v4, 11, v6
		v_accvgpr_write_b32 a73, v4
		v_xor_b32_e32 v4, 16, v6
		v_accvgpr_write_b32 a74, v4
		v_xor_b32_e32 v4, 17, v6
		v_accvgpr_write_b32 a75, v4
		v_xor_b32_e32 v4, 18, v6
		v_accvgpr_write_b32 a76, v4
		v_xor_b32_e32 v4, 19, v6
		v_accvgpr_write_b32 a77, v4
		v_xor_b32_e32 v4, 24, v6
		v_accvgpr_write_b32 a78, v4
		v_xor_b32_e32 v4, 25, v6
		v_accvgpr_write_b32 a79, v4
		v_xor_b32_e32 v4, 26, v6
		v_accvgpr_write_b32 a80, v4
		v_xor_b32_e32 v4, 27, v6
		v_accvgpr_write_b32 a81, v4
		v_xor_b32_e32 v4, 32, v6
		v_accvgpr_write_b32 a82, v4
		v_xor_b32_e32 v4, 33, v6
		v_accvgpr_write_b32 a83, v4
		v_xor_b32_e32 v4, 34, v6
		v_accvgpr_write_b32 a84, v4
		v_xor_b32_e32 v4, 35, v6
		v_accvgpr_write_b32 a85, v4
		v_xor_b32_e32 v4, 40, v6
		v_accvgpr_write_b32 a86, v4
		v_xor_b32_e32 v4, 41, v6
		v_accvgpr_write_b32 a87, v4
		v_xor_b32_e32 v4, 42, v6
		v_accvgpr_write_b32 a88, v4
		v_xor_b32_e32 v4, 43, v6
		v_accvgpr_write_b32 a89, v4
		v_xor_b32_e32 v4, 48, v6
		v_accvgpr_write_b32 a90, v4
		v_xor_b32_e32 v4, 49, v6
		v_accvgpr_write_b32 a91, v4
		v_xor_b32_e32 v4, 50, v6
		v_accvgpr_write_b32 a92, v4
		v_xor_b32_e32 v4, 51, v6
		v_accvgpr_write_b32 a93, v4
		v_xor_b32_e32 v4, 56, v6
		v_accvgpr_write_b32 a94, v4
		v_xor_b32_e32 v4, 57, v6
		v_accvgpr_write_b32 a95, v4
		v_xor_b32_e32 v4, 58, v6
		v_accvgpr_write_b32 a96, v4
		v_xor_b32_e32 v4, 59, v6
		v_accvgpr_write_b32 a97, v4
		v_xor_b32_e32 v4, 64, v6
		v_accvgpr_write_b32 a98, v4
		v_xor_b32_e32 v4, 0x41, v6
		v_accvgpr_write_b32 a99, v4
		v_xor_b32_e32 v4, 0x42, v6
		v_accvgpr_write_b32 a100, v4
		v_xor_b32_e32 v4, 0x43, v6
		v_accvgpr_write_b32 a101, v4
		v_xor_b32_e32 v4, 0x48, v6
		v_accvgpr_write_b32 a102, v4
		v_xor_b32_e32 v4, 0x49, v6
		v_accvgpr_write_b32 a103, v4
		v_xor_b32_e32 v4, 0x4a, v6
		v_accvgpr_write_b32 a104, v4
		v_xor_b32_e32 v4, 0x4b, v6
		v_accvgpr_write_b32 a105, v4
		v_xor_b32_e32 v4, 0x50, v6
		v_accvgpr_write_b32 a106, v4
		v_xor_b32_e32 v4, 0x51, v6
		v_accvgpr_write_b32 a107, v4
		v_xor_b32_e32 v4, 0x52, v6
		v_accvgpr_write_b32 a108, v4
		v_xor_b32_e32 v4, 0x53, v6
		v_accvgpr_write_b32 a109, v4
		v_xor_b32_e32 v4, 0x58, v6
		v_accvgpr_write_b32 a110, v4
		v_xor_b32_e32 v4, 0x59, v6
		v_accvgpr_write_b32 a111, v4
		v_xor_b32_e32 v4, 0x5a, v6
		v_accvgpr_write_b32 a112, v4
		v_xor_b32_e32 v4, 0x5b, v6
		v_accvgpr_write_b32 a113, v4
		v_xor_b32_e32 v4, 0x60, v6
		v_accvgpr_write_b32 a114, v4
		v_xor_b32_e32 v4, 0x61, v6
		v_accvgpr_write_b32 a115, v4
		v_xor_b32_e32 v4, 0x62, v6
		v_accvgpr_write_b32 a116, v4
		v_xor_b32_e32 v4, 0x63, v6
		v_accvgpr_write_b32 a117, v4
		v_xor_b32_e32 v4, 0x68, v6
		v_accvgpr_write_b32 a118, v4
		v_xor_b32_e32 v4, 0x69, v6
		v_accvgpr_write_b32 a119, v4
		v_xor_b32_e32 v4, 0x6a, v6
		v_accvgpr_write_b32 a120, v4
		v_xor_b32_e32 v4, 0x6b, v6
		v_accvgpr_write_b32 a121, v4
		v_xor_b32_e32 v4, 0x70, v6
		v_accvgpr_write_b32 a122, v4
		v_xor_b32_e32 v4, 0x71, v6
		v_accvgpr_write_b32 a123, v4
		v_xor_b32_e32 v4, 0x72, v6
		v_accvgpr_write_b32 a124, v4
		v_xor_b32_e32 v4, 0x73, v6
		v_accvgpr_write_b32 a125, v4
		v_xor_b32_e32 v4, 0x78, v6
		v_accvgpr_write_b32 a126, v4
		v_xor_b32_e32 v4, 0x79, v6
		v_accvgpr_write_b32 a127, v4
		v_xor_b32_e32 v4, 0x7a, v6
		v_accvgpr_write_b32 a128, v4
		v_xor_b32_e32 v4, 0x7b, v6
		v_accvgpr_write_b32 a129, v4
		v_accvgpr_read_b32 v4, a20
		v_accvgpr_read_b32 v14, a59
		v_lshl_add_u32 v4, v4, 4, v14
		v_accvgpr_read_b32 v14, a60
		v_accvgpr_read_b32 v18, a61
		v_add3_u32 v4, v4, v14, v18
		v_accvgpr_read_b32 v14, a62
		v_accvgpr_read_b32 v18, a63
		v_add3_u32 v4, v4, v14, v18
		v_accvgpr_write_b32 a20, v4
		v_accvgpr_read_b32 v4, a64
		v_accvgpr_read_b32 v14, a66
		v_lshl_add_u32 v4, v4, 3, v14
		v_accvgpr_read_b32 v14, a67
		v_accvgpr_read_b32 v18, a68
		v_add3_u32 v4, v4, v14, v18
		v_accvgpr_write_b32 a59, v4
		v_mov_b32_e32 v4, 0xff800000
		s_cmp_lt_i32 s47, s28
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s22, s47, 0x80
		s_cmp_lt_i32 s47, 0
		s_cselect_b32 s29, s23, 0
		s_add_i32 s29, s47, s29
		s_ashr_i32 s29, s29, 7
		s_cmp_lt_i32 s29, 0
		s_cselect_b32 s41, s16, 0
		s_add_i32 s41, s29, s41
		s_ashr_i32 s41, s41, 1
		s_lshl_b32 s41, s41, 1
		s_xor_b32 s41, s41, -1
		s_add_i32 s41, s41, 1
		s_add_i32 s41, s29, s41
		s_add_i32 s29, s29, 1
		s_cmp_lt_i32 s29, 0
		s_cselect_b32 s43, s16, 0
		s_add_i32 s43, s29, s43
		s_ashr_i32 s43, s43, 1
		s_lshl_b32 s43, s43, 1
		s_xor_b32 s43, s43, -1
		s_add_i32 s43, s43, 1
		s_add_i32 s54, s29, s43
		s_mul_i32 s29, 0x4100, s41
		v_accvgpr_read_b32 v14, a20
		v_add_u32_e32 v14, s29, v14
		ds_read_b128 a[60:63], v14
		ds_read_b128 a[132:135], v14 offset:32
		ds_read_b128 a[136:139], v14 offset:64
		ds_read_b128 a[140:143], v14 offset:96
		ds_read_b128 a[144:147], v14 offset:256
		ds_read_b128 a[148:151], v14 offset:288
		ds_read_b128 a[152:155], v14 offset:320
		ds_read_b128 a[156:159], v14 offset:352
		ds_read_b128 a[160:163], v14 offset:128
		ds_read_b128 a[164:167], v14 offset:160
		ds_read_b128 a[168:171], v14 offset:192
		ds_read_b128 a[172:175], v14 offset:224
		ds_read_b128 a[176:179], v14 offset:384
		ds_read_b128 a[180:183], v14 offset:416
		ds_read_b128 a[184:187], v14 offset:448
		ds_read_b128 a[188:191], v14 offset:480
		s_mul_i32 s29, 0x4400, s41
		v_accvgpr_read_b32 v14, a59
		v_add_u32_e32 v14, s29, v14
		ds_read_b64_tr_b16 a[192:193], v14 offset:33264
		ds_read_b64_tr_b16 a[194:195], v14 offset:37616
		ds_read_b64_tr_b16 a[196:197], v14 offset:33392
		ds_read_b64_tr_b16 a[198:199], v14 offset:37744
		ds_read_b64_tr_b16 a[200:201], v14 offset:33520
		ds_read_b64_tr_b16 a[202:203], v14 offset:37872
		ds_read_b64_tr_b16 a[204:205], v14 offset:33648
		ds_read_b64_tr_b16 a[206:207], v14 offset:38000
		ds_read_b64_tr_b16 a[208:209], v14 offset:33776
		ds_read_b64_tr_b16 a[210:211], v14 offset:38128
		ds_read_b64_tr_b16 a[212:213], v14 offset:33904
		ds_read_b64_tr_b16 a[214:215], v14 offset:38256
		ds_read_b64_tr_b16 a[216:217], v14 offset:34032
		ds_read_b64_tr_b16 a[218:219], v14 offset:38384
		ds_read_b64_tr_b16 a[220:221], v14 offset:34160
		ds_read_b64_tr_b16 a[222:223], v14 offset:38512
		ds_read_b64_tr_b16 a[224:225], v14 offset:33328
		ds_read_b64_tr_b16 a[226:227], v14 offset:37680
		ds_read_b64_tr_b16 a[228:229], v14 offset:33456
		ds_read_b64_tr_b16 a[230:231], v14 offset:37808
		ds_read_b64_tr_b16 a[232:233], v14 offset:33584
		ds_read_b64_tr_b16 a[234:235], v14 offset:37936
		ds_read_b64_tr_b16 a[236:237], v14 offset:33712
		ds_read_b64_tr_b16 a[238:239], v14 offset:38064
		ds_read_b64_tr_b16 a[240:241], v14 offset:33840
		ds_read_b64_tr_b16 a[242:243], v14 offset:38192
		ds_read_b64_tr_b16 a[244:245], v14 offset:33968
		ds_read_b64_tr_b16 a[246:247], v14 offset:38320
		ds_read_b64_tr_b16 a[248:249], v14 offset:34096
		ds_read_b64_tr_b16 a[250:251], v14 offset:38448
		ds_read_b64_tr_b16 a[252:253], v14 offset:34224
		ds_read_b64_tr_b16 a[254:255], v14 offset:38576
		s_cmp_lt_i32 s22, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_add_u32_e32 v14, s22, v2
		v_add_u32_e32 v18, s22, v8
		v_add_u32_e32 v19, s22, v10
		v_accvgpr_read_b32 v20, a22
		v_add_u32_e32 v20, s22, v20
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v18, s21
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v19, s21
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v20, s21
		s_mov_b64 s[62:63], vcc
		v_add_u32_e32 v14, s22, v5
		v_accvgpr_read_b32 v18, a23
		v_add_u32_e32 v18, s22, v18
		v_accvgpr_read_b32 v19, a56
		v_add_u32_e32 v19, s22, v19
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v18, s21
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v19, s21
		s_mov_b64 s[68:69], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s29, s15, s47
		s_lshl_b32 s29, s29, 1
		s_add_i32 s41, s48, s29
		v_add_u32_e32 v14, s41, v7
		s_mov_b32 s70, 1
		s_mov_b32 s71, 0
		s_mov_b32 s43, 0
		s_mul_i32 s72, s70, s42
		s_mul_hi_u32 s73, s70, s42
		s_mul_i32 s41, s70, s43
		s_add_i32 s73, s73, s41
		s_mul_i32 s41, s71, s42
		s_add_i32 s73, s73, s41
		s_lshr_b64 s[70:71], s[72:73], 6
		s_mov_b32 s72, 0x410
		s_mov_b32 s73, 0
		s_mul_i32 s74, s72, s70
		s_mul_hi_u32 s75, s72, s70
		s_mul_i32 s41, s72, s71
		s_add_i32 s75, s75, s41
		s_mul_i32 s41, s73, s70
		s_add_i32 s75, s75, s41
		s_cmp_lt_i32 s54, 0
		s_cselect_b32 s55, -1, 0
		s_mov_b32 s72, 0x4100
		s_mov_b32 s73, 0
		s_mul_i32 s76, s72, s54
		s_mul_hi_u32 s77, s72, s54
		s_mul_i32 s41, s72, s55
		s_add_i32 s77, s77, s41
		s_mul_i32 s41, s73, s54
		s_add_i32 s77, s77, s41
		s_add_u32 s72, s74, s76
		s_addc_u32 s73, s75, s77
		s_add_u32 s78, s72, 0
		s_addc_u32 s79, s73, 0
		s_mov_b32 m0, s78
		v_cndmask_b32_e64 v14, v21, v14, s[56:57]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v14, a57
		v_add_u32_e32 v14, s22, v14
		s_add_i32 s41, s49, s29
		v_add_u32_e32 v18, s41, v7
		s_add_u32 s56, s74, 0x1040
		s_addc_u32 s57, s75, 0
		s_add_u32 s56, s56, s76
		s_addc_u32 s57, s57, s77
		s_add_u32 s72, s56, 0
		s_addc_u32 s73, s57, 0
		s_mov_b32 m0, s72
		v_cndmask_b32_e64 v18, v21, v18, s[58:59]
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_add_i32 s41, s50, s29
		v_add_u32_e32 v18, s41, v7
		s_add_u32 s56, s74, 0x2080
		s_addc_u32 s57, s75, 0
		s_add_u32 s56, s56, s76
		s_addc_u32 s57, s57, s77
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v18, v21, v18, s[60:61]
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_add_i32 s29, s44, s29
		v_add_u32_e32 v18, s29, v7
		s_add_u32 s56, s74, 0x30c0
		s_addc_u32 s57, s75, 0
		s_add_u32 s56, s56, s76
		s_addc_u32 s57, s57, s77
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v18, v21, v18, s[62:63]
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_mul_i32 s29, s17, s47
		s_lshl_b32 s29, s29, 1
		s_add_i32 s41, s51, s29
		v_add_u32_e32 v18, s41, v9
		s_mov_b32 s56, 0x440
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s70
		s_mul_hi_u32 s59, s56, s70
		s_mul_i32 s41, s56, s71
		s_add_i32 s59, s59, s41
		s_mul_i32 s41, s57, s70
		s_add_i32 s59, s59, s41
		s_add_u32 s56, s58, 0x81f0
		s_addc_u32 s57, s59, 0
		s_mov_b32 s60, 0x4400
		s_mov_b32 s61, 0
		s_mul_i32 s62, s60, s54
		s_mul_hi_u32 s63, s60, s54
		s_mul_i32 s41, s60, s55
		s_add_i32 s63, s63, s41
		s_mul_i32 s41, s61, s54
		s_add_i32 s63, s63, s41
		s_add_u32 s54, s56, s62
		s_addc_u32 s55, s57, s63
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v18, v21, v18, s[64:65]
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
		s_add_i32 s41, s52, s29
		v_add_u32_e32 v18, s41, v9
		s_add_u32 s54, s58, 0x92f0
		s_addc_u32 s55, s59, 0
		s_add_u32 s54, s54, s62
		s_addc_u32 s55, s55, s63
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v18, v21, v18, s[66:67]
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
		s_add_i32 s41, s53, s29
		v_add_u32_e32 v18, s41, v9
		s_add_u32 s54, s58, 0xa3f0
		s_addc_u32 s55, s59, 0
		s_add_u32 s54, s54, s62
		s_addc_u32 s55, s55, s63
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v18, v21, v18, s[68:69]
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
		s_add_i32 s29, s40, s29
		v_cmp_lt_i32_e64 vcc, v14, s21
		v_add_u32_e32 v14, s29, v9
		s_add_u32 s54, s58, 0xb4f0
		s_addc_u32 s55, s59, 0
		v_cndmask_b32_e32 v14, v21, v14, vcc
		s_add_u32 s54, s54, s62
		s_addc_u32 s55, s55, s63
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[60:63], a[24:27], 0
		v_add_u32_e32 v14, s47, v6
		v_accvgpr_read_b32 v18, a12
		v_add_u32_e32 v18, s47, v18
		v_accvgpr_read_b32 v19, a13
		v_add_u32_e32 v19, s47, v19
		v_accvgpr_read_b32 v20, a58
		v_add_u32_e32 v20, s47, v20
		v_accvgpr_read_b32 v22, a72
		v_add_u32_e32 v22, s47, v22
		v_accvgpr_read_b32 v23, a73
		v_add_u32_e32 v23, s47, v23
		v_accvgpr_read_b32 v24, a76
		v_add_u32_e32 v24, s47, v24
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[24:27], 0
		v_accvgpr_read_b32 v25, a77
		v_add_u32_e32 v25, s47, v25
		v_accvgpr_read_b32 v26, a80
		v_add_u32_e32 v26, s47, v26
		v_accvgpr_read_b32 v27, a81
		v_add_u32_e32 v27, s47, v27
		v_accvgpr_read_b32 v28, a84
		v_add_u32_e32 v28, s47, v28
		v_accvgpr_read_b32 v29, a85
		v_add_u32_e32 v29, s47, v29
		v_accvgpr_read_b32 v30, a88
		v_add_u32_e32 v30, s47, v30
		v_accvgpr_read_b32 v31, a89
		v_add_u32_e32 v31, s47, v31
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[24:27], 0
		v_accvgpr_read_b32 v144, a92
		v_add_u32_e32 v144, s47, v144
		v_accvgpr_read_b32 v145, a93
		v_add_u32_e32 v145, s47, v145
		v_accvgpr_read_b32 v146, a96
		v_add_u32_e32 v146, s47, v146
		v_accvgpr_read_b32 v147, a97
		v_add_u32_e32 v147, s47, v147
		v_accvgpr_read_b32 v148, a100
		v_add_u32_e32 v148, s47, v148
		v_accvgpr_read_b32 v149, a101
		v_add_u32_e32 v149, s47, v149
		v_accvgpr_read_b32 v150, a104
		v_add_u32_e32 v150, s47, v150
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[24:27], 0
		v_accvgpr_read_b32 v151, a105
		v_add_u32_e32 v151, s47, v151
		v_accvgpr_read_b32 v152, a108
		v_add_u32_e32 v152, s47, v152
		v_accvgpr_read_b32 v153, a109
		v_add_u32_e32 v153, s47, v153
		v_accvgpr_read_b32 v154, a112
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a64, v154
		v_accvgpr_read_b32 v154, a113
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a66, v154
		v_accvgpr_read_b32 v154, a116
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a67, v154
		v_accvgpr_read_b32 v154, a117
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a68, v154
		v_mfma_f32_32x32x16_bf16 v[176:191], a[176:179], a[40:43], 0
		v_accvgpr_read_b32 v154, a120
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a130, v154
		v_accvgpr_read_b32 v154, a121
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a131, v154
		v_accvgpr_read_b32 v154, a124
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a176, v154
		v_accvgpr_read_b32 v154, a125
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a177, v154
		v_accvgpr_read_b32 v154, a128
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a178, v154
		v_accvgpr_read_b32 v154, a129
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_write_b32 a179, v154
		v_cmp_ge_i32_e64 vcc, v1, v14
		s_mov_b64 s[54:55], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], a[60:63], a[40:43], 0
		v_cmp_ge_i32_e64 vcc, v1, v18
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v1, v19
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v1, v20
		v_accvgpr_read_b32 v154, a65
		v_add_u32_e32 v154, s47, v154
		v_accvgpr_read_b32 v155, a71
		v_add_u32_e32 v155, s47, v155
		v_accvgpr_read_b32 v156, a74
		v_add_u32_e32 v156, s47, v156
		v_accvgpr_read_b32 v157, a75
		v_add_u32_e32 v157, s47, v157
		v_mfma_f32_32x32x16_bf16 v[208:223], a[144:147], a[40:43], 0
		v_accvgpr_read_b32 v158, a78
		v_add_u32_e32 v158, s47, v158
		v_accvgpr_read_b32 v159, a79
		v_add_u32_e32 v159, s47, v159
		v_accvgpr_read_b32 v224, a82
		v_add_u32_e32 v224, s47, v224
		v_accvgpr_read_b32 v225, a83
		v_add_u32_e32 v225, s47, v225
		v_accvgpr_read_b32 v226, a86
		v_add_u32_e32 v226, s47, v226
		v_accvgpr_read_b32 v227, a87
		v_add_u32_e32 v227, s47, v227
		v_accvgpr_read_b32 v228, a90
		v_add_u32_e32 v228, s47, v228
		v_mfma_f32_32x32x16_bf16 v[240:255], a[160:163], a[40:43], 0
		v_accvgpr_read_b32 v229, a91
		v_add_u32_e32 v229, s47, v229
		v_accvgpr_read_b32 v230, a94
		v_add_u32_e32 v230, s47, v230
		v_accvgpr_read_b32 v231, a95
		v_add_u32_e32 v231, s47, v231
		v_accvgpr_read_b32 v232, a98
		v_add_u32_e32 v232, s47, v232
		v_accvgpr_read_b32 v233, a99
		v_add_u32_e32 v233, s47, v233
		v_accvgpr_read_b32 v234, a102
		v_add_u32_e32 v234, s47, v234
		v_accvgpr_read_b32 v235, a103
		v_add_u32_e32 v235, s47, v235
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[28:31], v[96:111]
		v_accvgpr_read_b32 v236, a106
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a60, v236
		v_accvgpr_read_b32 v236, a107
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a61, v236
		v_accvgpr_read_b32 v236, a110
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a62, v236
		v_accvgpr_read_b32 v236, a111
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a63, v236
		v_accvgpr_read_b32 v236, a114
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a144, v236
		v_accvgpr_read_b32 v236, a115
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a145, v236
		v_accvgpr_read_b32 v236, a118
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a146, v236
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[28:31], v[112:127]
		v_accvgpr_read_b32 v236, a119
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a147, v236
		v_accvgpr_read_b32 v236, a122
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a160, v236
		v_accvgpr_read_b32 v236, a123
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a161, v236
		v_accvgpr_read_b32 v236, a126
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a162, v236
		v_accvgpr_read_b32 v236, a127
		v_add_u32_e32 v236, s47, v236
		v_accvgpr_write_b32 a163, v236
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[132:135], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[148:151], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[164:167], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[184:187], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[136:139], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[152:155], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[168:171], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[188:191], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[140:143], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[156:159], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[172:175], a[52:55], v[240:255]
		s_cmp_lt_i32 s22, s28
		s_nop 3
		v_cndmask_b32_e32 v99, v4, v99, vcc
		v_accvgpr_write_b32 a133, v99
		v_cmp_ge_i32_e64 vcc, v1, v154
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v1, v155
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v1, v22
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v1, v23
		v_cndmask_b32_e64 v236, v4, v96, s[54:55]
		v_cndmask_b32_e64 v237, v4, v97, s[56:57]
		v_cndmask_b32_e32 v97, v4, v103, vcc
		v_cmp_ge_i32_e64 vcc, v1, v156
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v1, v157
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v1, v24
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v1, v25
		v_cndmask_b32_e64 v96, v4, v98, s[58:59]
		v_accvgpr_write_b32 a132, v96
		v_cndmask_b32_e64 v98, v4, v100, s[46:47]
		v_cndmask_b32_e32 v96, v4, v107, vcc
		v_accvgpr_write_b32 a135, v96
		v_cmp_ge_i32_e64 vcc, v1, v158
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v1, v159
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v1, v26
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v1, v27
		v_cndmask_b32_e64 v99, v4, v101, s[60:61]
		v_cndmask_b32_e64 v96, v4, v102, s[62:63]
		v_cndmask_b32_e32 v101, v4, v111, vcc
		v_cmp_ge_i32_e64 vcc, v1, v224
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v1, v225
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v1, v28
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v1, v29
		v_cndmask_b32_e64 v102, v4, v104, s[54:55]
		v_cndmask_b32_e64 v103, v4, v105, s[56:57]
		v_cndmask_b32_e32 v100, v4, v115, vcc
		v_accvgpr_write_b32 a137, v100
		v_cmp_ge_i32_e64 vcc, v1, v226
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v1, v227
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v1, v30
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v1, v31
		v_cndmask_b32_e64 v100, v4, v106, s[64:65]
		v_accvgpr_write_b32 a134, v100
		v_cndmask_b32_e64 v104, v4, v108, s[46:47]
		v_cndmask_b32_e32 v100, v4, v119, vcc
		v_accvgpr_write_b32 a139, v100
		v_cmp_ge_i32_e64 vcc, v1, v228
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v1, v229
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v1, v144
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v1, v145
		v_cndmask_b32_e64 v105, v4, v109, s[58:59]
		v_cndmask_b32_e64 v100, v4, v110, s[66:67]
		v_cndmask_b32_e32 v107, v4, v123, vcc
		v_cmp_ge_i32_e64 vcc, v1, v230
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v1, v231
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v1, v146
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v1, v147
		v_cndmask_b32_e64 v108, v4, v112, s[60:61]
		v_cndmask_b32_e64 v109, v4, v113, s[62:63]
		v_cndmask_b32_e32 v111, v4, v127, vcc
		v_cmp_ge_i32_e64 vcc, v1, v232
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v1, v233
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v1, v148
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v1, v149
		v_cndmask_b32_e64 v106, v4, v114, s[68:69]
		v_accvgpr_write_b32 a136, v106
		v_cndmask_b32_e64 v112, v4, v116, s[54:55]
		v_cndmask_b32_e32 v115, v4, v131, vcc
		v_cmp_ge_i32_e64 vcc, v1, v234
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v1, v235
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v1, v150
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v1, v151
		v_cndmask_b32_e64 v113, v4, v117, s[56:57]
		v_cndmask_b32_e64 v106, v4, v118, s[70:71]
		v_accvgpr_write_b32 a138, v106
		v_cndmask_b32_e32 v117, v4, v135, vcc
		v_accvgpr_read_b32 v106, a60
		v_cmp_ge_i32_e64 vcc, v1, v106
		s_mov_b64 s[56:57], vcc
		v_accvgpr_read_b32 v106, a61
		v_cmp_ge_i32_e64 vcc, v1, v106
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v1, v152
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v1, v153
		v_cndmask_b32_e64 v106, v4, v120, s[46:47]
		v_accvgpr_write_b32 a140, v106
		v_cndmask_b32_e64 v106, v4, v121, s[64:65]
		v_accvgpr_write_b32 a141, v106
		v_cndmask_b32_e32 v119, v4, v139, vcc
		v_accvgpr_read_b32 v106, a62
		v_cmp_ge_i32_e64 vcc, v1, v106
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v106, a63
		v_cmp_ge_i32_e64 vcc, v1, v106
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v106, a64
		v_cmp_ge_i32_e64 vcc, v1, v106
		s_mov_b64 s[82:83], vcc
		v_cndmask_b32_e64 v121, v4, v141, s[64:65]
		v_cndmask_b32_e64 v238, v4, v142, s[82:83]
		v_accvgpr_read_b32 v106, a66
		v_cmp_ge_i32_e64 vcc, v1, v106
		v_cndmask_b32_e64 v106, v4, v122, s[72:73]
		v_cndmask_b32_e64 v122, v4, v124, s[58:59]
		v_cndmask_b32_e32 v239, v4, v143, vcc
		v_accvgpr_read_b32 v110, a144
		v_cmp_ge_i32_e64 vcc, v1, v110
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v110, a145
		v_cmp_ge_i32_e64 vcc, v1, v110
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v110, a67
		v_cmp_ge_i32_e64 vcc, v1, v110
		s_mov_b64 s[72:73], vcc
		v_cndmask_b32_e64 v142, v4, v160, s[58:59]
		v_cndmask_b32_e64 v143, v4, v161, s[64:65]
		v_cndmask_b32_e64 v160, v4, v162, s[72:73]
		v_accvgpr_read_b32 v110, a68
		v_cmp_ge_i32_e64 vcc, v1, v110
		v_cndmask_b32_e64 v123, v4, v125, s[66:67]
		v_cndmask_b32_e64 v110, v4, v126, s[74:75]
		v_cndmask_b32_e32 v161, v4, v163, vcc
		v_accvgpr_read_b32 v114, a146
		v_cmp_ge_i32_e64 vcc, v1, v114
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v114, a147
		v_cmp_ge_i32_e64 vcc, v1, v114
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v114, a130
		v_cmp_ge_i32_e64 vcc, v1, v114
		s_mov_b64 s[66:67], vcc
		v_cndmask_b32_e64 v124, v4, v164, s[58:59]
		v_cndmask_b32_e64 v125, v4, v165, s[64:65]
		v_cndmask_b32_e64 v126, v4, v166, s[66:67]
		v_accvgpr_read_b32 v114, a131
		v_cmp_ge_i32_e64 vcc, v1, v114
		v_cndmask_b32_e64 v162, v4, v128, s[60:61]
		v_cndmask_b32_e64 v163, v4, v129, s[62:63]
		v_cndmask_b32_e32 v127, v4, v167, vcc
		v_accvgpr_read_b32 v114, a160
		v_cmp_ge_i32_e64 vcc, v1, v114
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v114, a161
		v_cmp_ge_i32_e64 vcc, v1, v114
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v114, a176
		v_cmp_ge_i32_e64 vcc, v1, v114
		s_mov_b64 s[62:63], vcc
		v_cndmask_b32_e64 v128, v4, v168, s[58:59]
		v_cndmask_b32_e64 v129, v4, v169, s[60:61]
		v_cndmask_b32_e64 v164, v4, v170, s[62:63]
		v_accvgpr_read_b32 v114, a177
		v_cmp_ge_i32_e64 vcc, v1, v114
		v_cndmask_b32_e64 v114, v4, v130, s[76:77]
		v_cndmask_b32_e64 v130, v4, v132, s[54:55]
		v_cndmask_b32_e32 v165, v4, v171, vcc
		v_accvgpr_read_b32 v116, a162
		v_cmp_ge_i32_e64 vcc, v1, v116
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v116, a163
		v_cmp_ge_i32_e64 vcc, v1, v116
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v116, a178
		v_cmp_ge_i32_e64 vcc, v1, v116
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v166, v4, v172, s[54:55]
		v_cndmask_b32_e64 v167, v4, v173, s[58:59]
		v_cndmask_b32_e64 v168, v4, v174, s[60:61]
		v_accvgpr_read_b32 v116, a179
		v_cmp_ge_i32_e64 vcc, v1, v116
		v_cndmask_b32_e64 v131, v4, v133, s[68:69]
		v_cndmask_b32_e64 v116, v4, v134, s[78:79]
		v_cndmask_b32_e32 v169, v4, v175, vcc
		v_cmp_ge_i32_e64 vcc, v3, v14
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v18
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v3, v19
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v18, v4, v192, s[54:55]
		v_cndmask_b32_e64 v19, v4, v193, s[58:59]
		v_cndmask_b32_e64 v132, v4, v194, s[60:61]
		v_cmp_ge_i32_e64 vcc, v3, v20
		v_cndmask_b32_e64 v134, v4, v136, s[56:57]
		v_cndmask_b32_e64 v135, v4, v137, s[70:71]
		v_cndmask_b32_e32 v133, v4, v195, vcc
		v_cmp_ge_i32_e64 vcc, v3, v154
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v155
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v3, v22
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v136, v4, v196, s[54:55]
		v_cndmask_b32_e64 v137, v4, v197, s[56:57]
		v_cndmask_b32_e64 v154, v4, v198, s[58:59]
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v118, v4, v138, s[80:81]
		v_cndmask_b32_e64 v120, v4, v140, s[46:47]
		v_cndmask_b32_e32 v155, v4, v199, vcc
		v_cmp_ge_i32_e64 vcc, v3, v156
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v3, v157
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v24
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v22, v4, v200, s[46:47]
		v_cndmask_b32_e64 v23, v4, v201, s[54:55]
		v_cndmask_b32_e64 v138, v4, v202, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v25
		v_accvgpr_read_b32 v14, a132
		v_max3_f32 v14, v236, v237, v14
		v_max3_f32 v20, v98, v99, v96
		v_cndmask_b32_e32 v139, v4, v203, vcc
		v_cmp_ge_i32_e64 vcc, v3, v158
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v3, v159
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v26
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v24, v4, v204, s[46:47]
		v_cndmask_b32_e64 v25, v4, v205, s[54:55]
		v_cndmask_b32_e64 v140, v4, v206, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_accvgpr_read_b32 v26, a134
		v_max3_f32 v26, v102, v103, v26
		v_max3_f32 v27, v104, v105, v100
		v_cndmask_b32_e32 v141, v4, v207, vcc
		v_cmp_ge_i32_e64 vcc, v3, v224
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v3, v225
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v28
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v156, v4, v208, s[46:47]
		v_cndmask_b32_e64 v157, v4, v209, s[54:55]
		v_cndmask_b32_e64 v158, v4, v210, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v29
		v_accvgpr_read_b32 v28, a136
		v_max3_f32 v28, v108, v109, v28
		v_accvgpr_read_b32 v29, a138
		v_max3_f32 v29, v112, v113, v29
		v_cndmask_b32_e32 v159, v4, v211, vcc
		v_cmp_ge_i32_e64 vcc, v3, v226
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v3, v227
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v30
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v170, v4, v212, s[46:47]
		v_cndmask_b32_e64 v171, v4, v213, s[54:55]
		v_cndmask_b32_e64 v172, v4, v214, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_accvgpr_read_b32 v30, a140
		v_accvgpr_read_b32 v31, a141
		v_max3_f32 v30, v30, v31, v106
		v_max3_f32 v31, v122, v123, v110
		v_cndmask_b32_e32 v173, v4, v215, vcc
		v_cmp_ge_i32_e64 vcc, v3, v228
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v3, v229
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v144
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v174, v4, v216, s[46:47]
		v_cndmask_b32_e64 v175, v4, v217, s[54:55]
		v_cndmask_b32_e64 v192, v4, v218, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v145
		v_max3_f32 v144, v162, v163, v114
		v_max3_f32 v145, v130, v131, v116
		v_cndmask_b32_e32 v193, v4, v219, vcc
		v_cmp_ge_i32_e64 vcc, v3, v230
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v3, v231
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v146
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v194, v4, v220, s[46:47]
		v_cndmask_b32_e64 v195, v4, v221, s[54:55]
		v_cndmask_b32_e64 v196, v4, v222, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v147
		v_max3_f32 v146, v134, v135, v118
		v_max3_f32 v147, v120, v121, v238
		v_cndmask_b32_e32 v197, v4, v223, vcc
		v_cmp_ge_i32_e64 vcc, v3, v232
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v3, v233
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v148
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v198, v4, v240, s[46:47]
		v_cndmask_b32_e64 v199, v4, v241, s[54:55]
		v_cndmask_b32_e64 v200, v4, v242, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v149
		v_max3_f32 v148, v142, v143, v160
		v_max3_f32 v149, v124, v125, v126
		v_cndmask_b32_e32 v201, v4, v243, vcc
		v_cmp_ge_i32_e64 vcc, v3, v234
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v3, v235
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v150
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v202, v4, v244, s[46:47]
		v_cndmask_b32_e64 v203, v4, v245, s[54:55]
		v_cndmask_b32_e64 v204, v4, v246, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v151
		v_max3_f32 v150, v128, v129, v164
		v_max3_f32 v151, v166, v167, v168
		v_cndmask_b32_e32 v205, v4, v247, vcc
		v_accvgpr_read_b32 v206, a60
		v_cmp_ge_i32_e64 vcc, v3, v206
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v206, a61
		v_cmp_ge_i32_e64 vcc, v3, v206
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v152
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v206, v4, v248, s[46:47]
		v_cndmask_b32_e64 v207, v4, v249, s[54:55]
		v_cndmask_b32_e64 v208, v4, v250, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v153
		v_accvgpr_read_b32 v152, a133
		v_max3_f32 v14, v14, v152, v20
		v_accvgpr_read_b32 v20, a135
		v_max3_f32 v20, v26, v20, v27
		v_cndmask_b32_e32 v209, v4, v251, vcc
		v_accvgpr_read_b32 v26, a62
		v_cmp_ge_i32_e64 vcc, v3, v26
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v26, a63
		v_cmp_ge_i32_e64 vcc, v3, v26
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v26, a64
		v_cmp_ge_i32_e64 vcc, v3, v26
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v26, v4, v252, s[46:47]
		v_cndmask_b32_e64 v27, v4, v253, s[54:55]
		v_cndmask_b32_e64 v152, v4, v254, s[56:57]
		v_accvgpr_read_b32 v153, a66
		v_cmp_ge_i32_e64 vcc, v3, v153
		v_accvgpr_read_b32 v153, a137
		v_max3_f32 v28, v28, v153, v29
		v_max3_f32 v29, v30, v107, v31
		v_cndmask_b32_e32 v153, v4, v255, vcc
		v_accvgpr_read_b32 v30, a144
		v_cmp_ge_i32_e64 vcc, v3, v30
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v30, a145
		v_cmp_ge_i32_e64 vcc, v3, v30
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v30, a67
		v_cmp_ge_i32_e64 vcc, v3, v30
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v30, v4, v176, s[46:47]
		v_cndmask_b32_e64 v31, v4, v177, s[54:55]
		v_cndmask_b32_e64 v176, v4, v178, s[56:57]
		v_accvgpr_read_b32 v177, a68
		v_cmp_ge_i32_e64 vcc, v3, v177
		v_max3_f32 v144, v144, v115, v145
		v_max3_f32 v145, v146, v119, v147
		v_cndmask_b32_e32 v177, v4, v179, vcc
		v_accvgpr_read_b32 v146, a146
		v_cmp_ge_i32_e64 vcc, v3, v146
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v146, a147
		v_cmp_ge_i32_e64 vcc, v3, v146
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v146, a130
		v_cmp_ge_i32_e64 vcc, v3, v146
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v146, v4, v180, s[46:47]
		v_cndmask_b32_e64 v147, v4, v181, s[54:55]
		v_cndmask_b32_e64 v178, v4, v182, s[56:57]
		v_accvgpr_read_b32 v179, a131
		v_cmp_ge_i32_e64 vcc, v3, v179
		v_max3_f32 v148, v148, v161, v149
		v_max3_f32 v149, v150, v165, v151
		v_cndmask_b32_e32 v179, v4, v183, vcc
		v_accvgpr_read_b32 v150, a160
		v_cmp_ge_i32_e64 vcc, v3, v150
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v150, a161
		v_cmp_ge_i32_e64 vcc, v3, v150
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v150, a176
		v_cmp_ge_i32_e64 vcc, v3, v150
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v150, v4, v184, s[46:47]
		v_cndmask_b32_e64 v151, v4, v185, s[54:55]
		v_cndmask_b32_e64 v180, v4, v186, s[56:57]
		v_accvgpr_read_b32 v181, a177
		v_cmp_ge_i32_e64 vcc, v3, v181
		v_max3_f32 v14, v14, v97, v20
		v_accvgpr_read_b32 v20, a139
		v_max3_f32 v20, v28, v20, v29
		v_cndmask_b32_e32 v181, v4, v187, vcc
		v_accvgpr_read_b32 v28, a162
		v_cmp_ge_i32_e64 vcc, v3, v28
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v28, a163
		v_cmp_ge_i32_e64 vcc, v3, v28
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v28, a178
		v_cmp_ge_i32_e64 vcc, v3, v28
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v28, v4, v188, s[46:47]
		v_cndmask_b32_e64 v29, v4, v189, s[54:55]
		v_cndmask_b32_e64 v182, v4, v190, s[56:57]
		v_accvgpr_read_b32 v183, a179
		v_cmp_ge_i32_e64 vcc, v3, v183
		v_max3_f32 v144, v144, v117, v145
		v_max3_f32 v145, v148, v127, v149
		v_cndmask_b32_e32 v183, v4, v191, vcc
		v_max3_f32 v14, v14, v101, v20
		v_max3_f32 v20, v144, v239, v145
		v_max3_f32 v14, v14, v111, v20
		v_max_f32_e32 v14, v14, v169
		v_mov_b32_e32 v144, v14
		v_mov_b32_e32 v145, v14
		s_nop 1
		v_permlane32_swap_b32_e32 v144, v145
		v_max_f32_e32 v148, v144, v145
		v_max3_f32 v14, v18, v19, v132
		v_max3_f32 v20, v136, v137, v154
		v_max3_f32 v144, v22, v23, v138
		v_max3_f32 v145, v24, v25, v140
		v_max3_f32 v149, v156, v157, v158
		v_max3_f32 v184, v170, v171, v172
		v_max3_f32 v185, v174, v175, v192
		v_max3_f32 v186, v194, v195, v196
		v_max3_f32 v187, v198, v199, v200
		v_max3_f32 v188, v202, v203, v204
		v_max3_f32 v189, v206, v207, v208
		v_max3_f32 v190, v26, v27, v152
		v_max3_f32 v191, v30, v31, v176
		v_max3_f32 v210, v146, v147, v178
		v_max3_f32 v211, v150, v151, v180
		v_max3_f32 v212, v28, v29, v182
		v_max3_f32 v14, v14, v133, v20
		v_max3_f32 v20, v144, v139, v145
		v_max3_f32 v144, v149, v159, v184
		v_max3_f32 v145, v185, v193, v186
		v_max3_f32 v149, v187, v201, v188
		v_max3_f32 v184, v189, v209, v190
		v_max3_f32 v185, v191, v177, v210
		v_max3_f32 v186, v211, v181, v212
		v_max3_f32 v14, v14, v155, v20
		v_max3_f32 v20, v144, v173, v145
		v_max3_f32 v144, v149, v205, v184
		v_max3_f32 v145, v185, v179, v186
		v_max3_f32 v14, v14, v141, v20
		v_max3_f32 v20, v144, v153, v145
		v_max3_f32 v14, v14, v197, v20
		v_max_f32_e32 v14, v14, v183
		v_mov_b32_e32 v144, v14
		v_mov_b32_e32 v145, v14
		s_nop 1
		v_permlane32_swap_b32_e32 v144, v145
		v_max_f32_e32 v149, v144, v145
		v_pk_mul_f32 v[144:145], v[148:149], v[12:13]
		v_max_f32_e32 v148, v11, v144
		v_max_f32_e32 v149, v15, v145
		v_pk_fma_f32 v[144:145], v[236:237], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v184, a132
		v_accvgpr_read_b32 v185, a133
		v_pk_fma_f32 v[186:187], v[184:185], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[98:99], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[96:97], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[102:103], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v102, a134
		v_accvgpr_read_b32 v103, a135
		v_pk_fma_f32 v[188:189], v[102:103], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[100:101], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[108:109], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v108, a136
		v_accvgpr_read_b32 v109, a137
		v_pk_fma_f32 v[190:191], v[108:109], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[112:113], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v112, a138
		v_accvgpr_read_b32 v113, a139
		v_pk_fma_f32 v[210:211], v[112:113], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v112, a140
		v_accvgpr_read_b32 v113, a141
		v_pk_fma_f32 v[212:213], v[112:113], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[106:107], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[122:123], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[110:111], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[162:163], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[114:115], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[130:131], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[116:117], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[134:135], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[118:119], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[238:239], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[142:143], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[160:161], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[124:125], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[164:165], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[12:13], v[148:149] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[18:19], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[132:133], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[154:155], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[22:23], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[138:139], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[24:25], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[140:141], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[156:157], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[158:159], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[170:171], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[192:193], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[206:207], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[208:209], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[26:27], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[152:153], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[30:31], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[176:177], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[146:147], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[178:179], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[150:151], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[180:181], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[28:29], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[182:183], v[12:13], v[148:149] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v182, v144
		v_exp_f32_e32 v216, v145
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v217, v187
		v_exp_f32_e32 v144, v184
		v_exp_f32_e32 v186, v185
		v_exp_f32_e32 v145, v98
		v_exp_f32_e32 v187, v99
		v_exp_f32_e32 v98, v96
		v_exp_f32_e32 v184, v97
		v_exp_f32_e32 v99, v188
		v_exp_f32_e32 v185, v189
		v_exp_f32_e32 v96, v102
		v_exp_f32_e32 v188, v103
		v_exp_f32_e32 v97, v104
		v_exp_f32_e32 v189, v105
		v_exp_f32_e32 v102, v100
		v_exp_f32_e32 v104, v101
		v_exp_f32_e32 v103, v190
		v_exp_f32_e32 v105, v191
		v_exp_f32_e32 v100, v108
		v_exp_f32_e32 v190, v109
		v_exp_f32_e32 v101, v210
		v_exp_f32_e32 v191, v211
		v_exp_f32_e32 v108, v212
		v_exp_f32_e32 v210, v213
		v_exp_f32_e32 v109, v112
		v_exp_f32_e32 v211, v113
		v_exp_f32_e32 v112, v106
		v_exp_f32_e32 v212, v107
		v_exp_f32_e32 v113, v122
		v_exp_f32_e32 v213, v123
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v122, v111
		v_exp_f32_e32 v107, v162
		v_exp_f32_e32 v123, v163
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v162, v115
		v_exp_f32_e32 v111, v130
		v_exp_f32_e32 v163, v131
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v130, v117
		v_exp_f32_e32 v115, v134
		v_exp_f32_e32 v131, v135
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v134, v119
		v_exp_f32_e32 v117, v120
		v_exp_f32_e32 v135, v121
		v_exp_f32_e32 v118, v214
		v_exp_f32_e32 v120, v215
		v_exp_f32_e32 v119, v142
		v_exp_f32_e32 v121, v143
		v_exp_f32_e32 v142, v160
		v_exp_f32_e32 v214, v161
		v_exp_f32_e32 v143, v124
		v_exp_f32_e32 v215, v125
		v_exp_f32_e32 v124, v126
		v_exp_f32_e32 v160, v127
		v_exp_f32_e32 v125, v128
		v_exp_f32_e32 v161, v129
		v_exp_f32_e32 v126, v164
		v_exp_f32_e32 v128, v165
		v_exp_f32_e32 v127, v166
		v_exp_f32_e32 v129, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v167, v169
		v_exp_f32_e32 v168, v18
		v_exp_f32_e32 v218, v19
		v_exp_f32_e32 v169, v132
		v_exp_f32_e32 v219, v133
		v_exp_f32_e32 v18, v136
		v_exp_f32_e32 v132, v137
		v_exp_f32_e32 v19, v154
		v_exp_f32_e32 v133, v155
		v_exp_f32_e32 v136, v22
		v_exp_f32_e32 v154, v23
		v_exp_f32_e32 v137, v138
		v_exp_f32_e32 v155, v139
		v_exp_f32_e32 v22, v24
		v_exp_f32_e32 v138, v25
		v_exp_f32_e32 v23, v140
		v_exp_f32_e32 v139, v141
		v_exp_f32_e32 v24, v156
		v_exp_f32_e32 v140, v157
		v_exp_f32_e32 v25, v158
		v_exp_f32_e32 v141, v159
		v_exp_f32_e32 v156, v170
		v_exp_f32_e32 v158, v171
		v_exp_f32_e32 v157, v172
		v_exp_f32_e32 v159, v173
		v_exp_f32_e32 v170, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v171, v192
		v_exp_f32_e32 v173, v193
		v_exp_f32_e32 v174, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v175, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v195, v200
		v_exp_f32_e32 v197, v201
		v_exp_f32_e32 v198, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v199, v204
		v_exp_f32_e32 v201, v205
		v_exp_f32_e32 v202, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v203, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v206, v26
		v_exp_f32_e32 v208, v27
		v_exp_f32_e32 v207, v152
		v_exp_f32_e32 v209, v153
		v_exp_f32_e32 v26, v30
		v_exp_f32_e32 v152, v31
		v_exp_f32_e32 v27, v176
		v_exp_f32_e32 v153, v177
		v_exp_f32_e32 v30, v146
		v_exp_f32_e32 v176, v147
		v_exp_f32_e32 v31, v178
		v_exp_f32_e32 v177, v179
		v_exp_f32_e32 v146, v150
		v_exp_f32_e32 v178, v151
		v_exp_f32_e32 v147, v180
		v_exp_f32_e32 v179, v181
		v_exp_f32_e32 v150, v28
		v_exp_f32_e32 v180, v29
		v_pk_add_f32 v[28:29], v[182:183], v[216:217]
		v_pk_add_f32 v[220:221], v[144:145], v[186:187]
		v_pk_add_f32 v[222:223], v[98:99], v[184:185]
		v_pk_add_f32 v[224:225], v[96:97], v[188:189]
		v_pk_add_f32 v[226:227], v[102:103], v[104:105]
		v_pk_add_f32 v[228:229], v[100:101], v[190:191]
		v_pk_add_f32 v[230:231], v[108:109], v[210:211]
		v_pk_add_f32 v[232:233], v[112:113], v[212:213]
		v_pk_add_f32 v[234:235], v[106:107], v[122:123]
		v_pk_add_f32 v[236:237], v[110:111], v[162:163]
		v_pk_add_f32 v[238:239], v[114:115], v[130:131]
		v_pk_add_f32 v[240:241], v[116:117], v[134:135]
		v_pk_add_f32 v[242:243], v[118:119], v[120:121]
		v_pk_add_f32 v[244:245], v[142:143], v[214:215]
		v_pk_add_f32 v[246:247], v[124:125], v[160:161]
		v_pk_add_f32 v[248:249], v[126:127], v[128:129]
		v_mov_b32_e32 v250, v29
		v_mov_b32_e32 v251, v221
		v_mov_b32_e32 v252, v28
		v_mov_b32_e32 v253, v220
		v_pk_add_f32 v[28:29], v[252:253], v[250:251]
		v_mov_b32_e32 v220, v223
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v250, v222
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[222:223], v[250:251], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v224, v226
		v_mov_b32_e32 v225, v228
		v_pk_add_f32 v[226:227], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v233
		v_mov_b32_e32 v224, v230
		v_mov_b32_e32 v225, v232
		v_pk_add_f32 v[228:229], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v235
		v_mov_b32_e32 v221, v237
		v_mov_b32_e32 v224, v234
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[230:231], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v239
		v_mov_b32_e32 v221, v241
		v_mov_b32_e32 v224, v238
		v_mov_b32_e32 v225, v240
		v_pk_add_f32 v[232:233], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v243
		v_mov_b32_e32 v221, v245
		v_mov_b32_e32 v224, v242
		v_mov_b32_e32 v225, v244
		v_pk_add_f32 v[234:235], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v247
		v_mov_b32_e32 v221, v249
		v_mov_b32_e32 v224, v246
		v_mov_b32_e32 v225, v248
		v_pk_add_f32 v[236:237], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v29
		v_mov_b32_e32 v221, v223
		v_mov_b32_e32 v224, v28
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[28:29], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v233
		v_mov_b32_e32 v222, v230
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[226:227], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v235
		v_mov_b32_e32 v221, v237
		v_mov_b32_e32 v222, v234
		v_mov_b32_e32 v223, v236
		v_pk_add_f32 v[228:229], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v29
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v28
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[28:29], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v29
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v28
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[28:29], v[222:223], v[220:221]
		v_add_f32_e32 v14, v28, v29
		v_accvgpr_read_b32 v20, a69
		ds_bpermute_b32 v164, v20, v14
		v_accvgpr_read_b32 v20, a70
		ds_bpermute_b32 v166, v20, v14
		v_pk_add_f32 v[28:29], v[168:169], v[218:219]
		v_pk_add_f32 v[220:221], v[18:19], v[132:133]
		v_pk_add_f32 v[222:223], v[136:137], v[154:155]
		v_pk_add_f32 v[224:225], v[22:23], v[138:139]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[226:227], v[164:165], v[166:167]
		v_pk_add_f32 v[228:229], v[24:25], v[140:141]
		v_pk_add_f32 v[230:231], v[156:157], v[158:159]
		v_pk_add_f32 v[232:233], v[170:171], v[172:173]
		v_pk_add_f32 v[234:235], v[174:175], v[192:193]
		v_pk_add_f32 v[236:237], v[194:195], v[196:197]
		v_pk_add_f32 v[238:239], v[198:199], v[200:201]
		v_pk_add_f32 v[240:241], v[202:203], v[204:205]
		v_pk_add_f32 v[242:243], v[206:207], v[208:209]
		v_pk_add_f32 v[244:245], v[26:27], v[152:153]
		v_pk_add_f32 v[246:247], v[30:31], v[176:177]
		v_pk_add_f32 v[248:249], v[146:147], v[178:179]
		v_mov_b32_e32 v151, v227
		v_mov_b32_e32 v181, v28
		v_pk_add_f32 v[250:251], v[150:151], v[180:181]
		v_mov_b32_e32 v252, v29
		v_mov_b32_e32 v253, v222
		v_pk_add_f32 v[28:29], v[252:253], v[220:221]
		v_mov_b32_e32 v220, v223
		v_mov_b32_e32 v221, v228
		v_pk_add_f32 v[220:221], v[220:221], v[224:225]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[224:225], v[222:223], v[230:231]
		v_mov_b32_e32 v222, v233
		v_mov_b32_e32 v223, v236
		v_pk_add_f32 v[222:223], v[222:223], v[234:235]
		v_mov_b32_e32 v228, v237
		v_mov_b32_e32 v229, v240
		v_pk_add_f32 v[230:231], v[228:229], v[238:239]
		v_mov_b32_e32 v228, v241
		v_mov_b32_e32 v229, v244
		v_pk_add_f32 v[228:229], v[228:229], v[242:243]
		v_mov_b32_e32 v232, v245
		v_mov_b32_e32 v233, v248
		v_pk_add_f32 v[234:235], v[232:233], v[246:247]
		v_mov_b32_e32 v232, v249
		v_mov_b32_e32 v233, v28
		v_pk_add_f32 v[232:233], v[232:233], v[250:251]
		v_mov_b32_e32 v236, v29
		v_mov_b32_e32 v237, v224
		v_pk_add_f32 v[28:29], v[236:237], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[220:221], v[220:221], v[222:223]
		v_mov_b32_e32 v222, v231
		v_mov_b32_e32 v223, v234
		v_pk_add_f32 v[224:225], v[222:223], v[228:229]
		v_mov_b32_e32 v222, v235
		v_mov_b32_e32 v223, v28
		v_pk_add_f32 v[222:223], v[222:223], v[232:233]
		v_mov_b32_e32 v228, v29
		v_mov_b32_e32 v229, v224
		v_pk_add_f32 v[28:29], v[228:229], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v28
		v_pk_add_f32 v[224:225], v[220:221], v[222:223]
		v_add_f32_e32 v14, v29, v224
		v_add_f32_e32 v14, v225, v14
		v_mov_b32_e32 v28, v14
		v_mov_b32_e32 v29, v14
		s_nop 1
		v_permlane32_swap_b32_e32 v28, v29
		v_add_f32_e32 v221, v28, v29
		v_sub_f32_e32 v11, v11, v148
		v_sub_f32_e32 v14, v15, v149
		v_exp_f32_e32 v28, v11
		v_exp_f32_e32 v222, v14
		v_mov_b32_e32 v29, v28
		v_pk_mul_f32 v[32:33], v[32:33], v[28:29]
		v_pk_mul_f32 v[34:35], v[34:35], v[28:29]
		v_pk_mul_f32 v[36:37], v[36:37], v[28:29]
		v_pk_mul_f32 v[38:39], v[38:39], v[28:29]
		v_pk_mul_f32 v[40:41], v[40:41], v[28:29]
		v_pk_mul_f32 v[42:43], v[42:43], v[28:29]
		v_pk_mul_f32 v[44:45], v[44:45], v[28:29]
		v_pk_mul_f32 v[46:47], v[46:47], v[28:29]
		v_pk_mul_f32 v[48:49], v[48:49], v[28:29]
		v_pk_mul_f32 v[50:51], v[50:51], v[28:29]
		v_pk_mul_f32 v[52:53], v[52:53], v[28:29]
		v_pk_mul_f32 v[54:55], v[54:55], v[28:29]
		v_pk_mul_f32 v[56:57], v[56:57], v[28:29]
		v_pk_mul_f32 v[58:59], v[58:59], v[28:29]
		v_pk_mul_f32 v[60:61], v[60:61], v[28:29]
		v_pk_mul_f32 v[62:63], v[62:63], v[28:29]
		v_mov_b32_e32 v223, v222
		v_pk_mul_f32 v[64:65], v[64:65], v[222:223]
		v_pk_mul_f32 v[66:67], v[66:67], v[222:223]
		v_pk_mul_f32 v[68:69], v[68:69], v[222:223]
		v_pk_mul_f32 v[70:71], v[70:71], v[222:223]
		v_pk_mul_f32 v[72:73], v[72:73], v[222:223]
		v_pk_mul_f32 v[74:75], v[74:75], v[222:223]
		v_pk_mul_f32 v[76:77], v[76:77], v[222:223]
		v_pk_mul_f32 v[78:79], v[78:79], v[222:223]
		v_pk_mul_f32 v[80:81], v[80:81], v[222:223]
		v_pk_mul_f32 v[82:83], v[82:83], v[222:223]
		v_pk_mul_f32 v[84:85], v[84:85], v[222:223]
		v_pk_mul_f32 v[86:87], v[86:87], v[222:223]
		v_pk_mul_f32 v[88:89], v[88:89], v[222:223]
		v_pk_mul_f32 v[90:91], v[90:91], v[222:223]
		v_pk_mul_f32 v[92:93], v[92:93], v[222:223]
		v_pk_mul_f32 v[94:95], v[94:95], v[222:223]
		v_mov_b32_e32 v14, v28
		v_mov_b32_e32 v15, v222
		v_mov_b32_e32 v220, v226
		v_mov_b64_e32 v[28:29], v[16:17]
		v_pk_fma_f32 v[16:17], v[28:29], v[14:15], v[220:221]
		v_cvt_pk_bf16_f32 v220, v182, v216
		v_cvt_pk_bf16_f32 v221, v183, v217
		v_cvt_pk_bf16_f32 v222, v144, v186
		v_cvt_pk_bf16_f32 v223, v145, v187
		v_cvt_pk_bf16_f32 v224, v98, v184
		v_cvt_pk_bf16_f32 v225, v99, v185
		v_cvt_pk_bf16_f32 v226, v96, v188
		v_cvt_pk_bf16_f32 v227, v97, v189
		v_cvt_pk_bf16_f32 v96, v102, v104
		v_cvt_pk_bf16_f32 v97, v103, v105
		v_cvt_pk_bf16_f32 v98, v100, v190
		v_cvt_pk_bf16_f32 v99, v101, v191
		v_cvt_pk_bf16_f32 v100, v108, v210
		v_cvt_pk_bf16_f32 v101, v109, v211
		v_cvt_pk_bf16_f32 v102, v112, v212
		v_cvt_pk_bf16_f32 v103, v113, v213
		v_cvt_pk_bf16_f32 v184, v106, v122
		v_cvt_pk_bf16_f32 v185, v107, v123
		v_cvt_pk_bf16_f32 v186, v110, v162
		v_cvt_pk_bf16_f32 v187, v111, v163
		v_cvt_pk_bf16_f32 v104, v114, v130
		v_cvt_pk_bf16_f32 v105, v115, v131
		v_cvt_pk_bf16_f32 v106, v116, v134
		v_cvt_pk_bf16_f32 v107, v117, v135
		v_cvt_pk_bf16_f32 v108, v118, v120
		v_cvt_pk_bf16_f32 v109, v119, v121
		v_cvt_pk_bf16_f32 v110, v142, v214
		v_cvt_pk_bf16_f32 v111, v143, v215
		v_cvt_pk_bf16_f32 v112, v124, v160
		v_cvt_pk_bf16_f32 v113, v125, v161
		v_cvt_pk_bf16_f32 v114, v126, v128
		v_cvt_pk_bf16_f32 v115, v127, v129
		v_cvt_pk_bf16_f32 v116, v165, v167
		v_cvt_pk_bf16_f32 v117, v168, v218
		v_cvt_pk_bf16_f32 v118, v169, v219
		v_cvt_pk_bf16_f32 v119, v18, v132
		v_cvt_pk_bf16_f32 v120, v19, v133
		v_cvt_pk_bf16_f32 v121, v136, v154
		v_cvt_pk_bf16_f32 v122, v137, v155
		v_cvt_pk_bf16_f32 v123, v22, v138
		v_cvt_pk_bf16_f32 v124, v23, v139
		v_cvt_pk_bf16_f32 v125, v24, v140
		v_cvt_pk_bf16_f32 v126, v25, v141
		v_cvt_pk_bf16_f32 v127, v156, v158
		v_cvt_pk_bf16_f32 v128, v157, v159
		v_cvt_pk_bf16_f32 v129, v170, v172
		v_cvt_pk_bf16_f32 v130, v171, v173
		v_cvt_pk_bf16_f32 v131, v174, v192
		v_cvt_pk_bf16_f32 v132, v175, v193
		v_cvt_pk_bf16_f32 v133, v194, v196
		v_cvt_pk_bf16_f32 v134, v195, v197
		v_cvt_pk_bf16_f32 v135, v198, v200
		v_cvt_pk_bf16_f32 v136, v199, v201
		v_cvt_pk_bf16_f32 v137, v202, v204
		v_cvt_pk_bf16_f32 v138, v203, v205
		v_cvt_pk_bf16_f32 v139, v206, v208
		v_cvt_pk_bf16_f32 v140, v207, v209
		v_cvt_pk_bf16_f32 v141, v26, v152
		v_cvt_pk_bf16_f32 v142, v27, v153
		v_cvt_pk_bf16_f32 v143, v30, v176
		v_cvt_pk_bf16_f32 v24, v31, v177
		v_cvt_pk_bf16_f32 v25, v146, v178
		v_cvt_pk_bf16_f32 v26, v147, v179
		v_cvt_pk_bf16_f32 v27, v150, v180
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[224:227], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[96:99], v[32:47]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[96:99], v[48:63]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[100:103], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[100:103], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[24:27], v[64:79]
		s_mov_b32 s47, s22
		v_mov_b32_e32 v11, v148
		v_mov_b32_e32 v15, v149
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s32, s8
		s_mov_b32 s33, s9
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_rcp_f32_e32 v2, v16
		v_rcp_f32_e32 v4, v17
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[6:7], v[32:33], v[2:3]
		v_pk_mul_f32 v[8:9], v[34:35], v[2:3]
		v_pk_mul_f32 v[10:11], v[36:37], v[2:3]
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
		v_mov_b32_e32 v5, v4
		v_pk_mul_f32 v[2:3], v[64:65], v[4:5]
		v_pk_mul_f32 v[38:39], v[66:67], v[4:5]
		v_pk_mul_f32 v[40:41], v[68:69], v[4:5]
		v_pk_mul_f32 v[42:43], v[70:71], v[4:5]
		v_pk_mul_f32 v[44:45], v[72:73], v[4:5]
		v_pk_mul_f32 v[46:47], v[74:75], v[4:5]
		v_pk_mul_f32 v[48:49], v[76:77], v[4:5]
		v_pk_mul_f32 v[50:51], v[78:79], v[4:5]
		v_pk_mul_f32 v[52:53], v[80:81], v[4:5]
		v_pk_mul_f32 v[54:55], v[82:83], v[4:5]
		v_pk_mul_f32 v[56:57], v[84:85], v[4:5]
		v_pk_mul_f32 v[58:59], v[86:87], v[4:5]
		v_pk_mul_f32 v[60:61], v[88:89], v[4:5]
		v_pk_mul_f32 v[62:63], v[90:91], v[4:5]
		v_pk_mul_f32 v[64:65], v[92:93], v[4:5]
		v_pk_mul_f32 v[66:67], v[94:95], v[4:5]
		v_cvt_pk_bf16_f32 v68, v6, v7
		v_cvt_pk_bf16_f32 v69, v8, v9
		v_cvt_pk_bf16_f32 v70, v10, v11
		v_cvt_pk_bf16_f32 v71, v12, v13
		v_cvt_pk_bf16_f32 v4, v14, v15
		v_cvt_pk_bf16_f32 v5, v16, v17
		v_cvt_pk_bf16_f32 v6, v18, v19
		v_cvt_pk_bf16_f32 v7, v20, v21
		v_cvt_pk_bf16_f32 v8, v22, v23
		v_cvt_pk_bf16_f32 v9, v24, v25
		v_cvt_pk_bf16_f32 v10, v26, v27
		v_cvt_pk_bf16_f32 v11, v28, v29
		v_cvt_pk_bf16_f32 v12, v30, v31
		v_cvt_pk_bf16_f32 v13, v32, v33
		v_cvt_pk_bf16_f32 v14, v34, v35
		v_cvt_pk_bf16_f32 v15, v36, v37
		v_cvt_pk_bf16_f32 v16, v2, v3
		v_cvt_pk_bf16_f32 v17, v38, v39
		v_cvt_pk_bf16_f32 v18, v40, v41
		v_cvt_pk_bf16_f32 v19, v42, v43
		v_cvt_pk_bf16_f32 v20, v44, v45
		v_cvt_pk_bf16_f32 v21, v46, v47
		v_cvt_pk_bf16_f32 v22, v48, v49
		v_cvt_pk_bf16_f32 v23, v50, v51
		v_cvt_pk_bf16_f32 v24, v52, v53
		v_cvt_pk_bf16_f32 v25, v54, v55
		v_cvt_pk_bf16_f32 v26, v56, v57
		v_cvt_pk_bf16_f32 v27, v58, v59
		v_cvt_pk_bf16_f32 v28, v60, v61
		v_cvt_pk_bf16_f32 v29, v62, v63
		v_cvt_pk_bf16_f32 v30, v64, v65
		v_cvt_pk_bf16_f32 v31, v66, v67
		v_permlane32_swap_b32_e32 v68, v70
		v_permlane32_swap_b32_e32 v69, v71
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		s_mul_i32 s1, s19, s18
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s19, v1
		v_accvgpr_read_b32 v1, a14
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
		v_accvgpr_read_b32 v1, a11
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
		s_and_saveexec_b64 s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[68:71], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[90:91]
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
		s_and_saveexec_b64 s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[4:7], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s1, 64
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[8:11], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s1, 0x60
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[12:15], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[90:91]
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
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[16:19], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[90:91]
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
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[20:23], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[90:91]
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
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[24:27], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[90:91]
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
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[28:31], v1, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_31:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_31
.L_attn_fwd_persistent.exec_endif_31:
		s_mov_b64 exec, s[90:91]
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
		.amdhsa_next_free_sgpr 92
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
	.set .L_attn_fwd_persistent.numbered_sgpr, 92
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
    .sgpr_count:     92
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 419
    wave.regalloc.agpr.dwords: 835
    wave.regalloc.remat.dwords: 6
    wave.regalloc.sgpr_to_vgpr.dwords: 56
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
