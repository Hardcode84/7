	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	_attn_fwd_async_prefetch
	.p2align	8
	.type	_attn_fwd_async_prefetch,@function
_attn_fwd_async_prefetch:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .L_attn_fwd_async_prefetch.kernarg_preload_entry
	.p2align	8
.L_attn_fwd_async_prefetch.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_load_dword s18, s[0:1], 0x38
		s_load_dword s19, s[0:1], 0x3c
		s_load_dword s20, s[0:1], 0x40
		s_load_dword s21, s[0:1], 0x44
		s_load_dword s22, s[0:1], 0x48
		s_load_dword s23, s[0:1], 0x4c
		s_load_dword s24, s[0:1], 0x54
		s_load_dword s25, s[0:1], 0x58
		v_mov_b32_e32 v1, 0
		s_cmp_lt_i32 s17, 0
		s_cselect_b32 s0, 1, 0
		s_xor_b32 s1, s17, -1
		s_add_i32 s1, s1, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s1, s17
		s_cselect_b32 s1, 1, 0
		s_waitcnt lgkmcnt(0)
		s_xor_b32 s26, s24, -1
		s_add_i32 s26, s26, 1
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s26, s26, s24
		v_mov_b32_e32 v2, s26
		v_cvt_f32_u32_e32 v2, v2
		v_rcp_iflag_f32_e32 v2, v2
		v_mov_b32_e32 v3, 0x4f7ffffe
		v_mul_f32_e32 v2, v3, v2
		v_cvt_u32_f32_e32 v2, v2
		s_xor_b32 s27, s26, -1
		v_readfirstlane_b32 s28, v2
		s_add_i32 s27, s27, 1
		s_mul_i32 s29, s27, s28
		s_mul_hi_u32 s29, s28, s29
		s_add_i32 s28, s28, s29
		s_mul_hi_u32 s28, s0, s28
		s_mul_i32 s29, s28, s26
		s_xor_b32 s29, s29, -1
		s_add_i32 s29, s29, 1
		s_add_i32 s0, s0, s29
		s_cmp_ge_u32 s0, s26
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s28, 1
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s28, s30, s28
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s0, s27
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s0, s30, s0
		s_cmp_ge_u32 s0, s26
		s_cselect_b32 s26, 1, 0
		s_add_i32 s29, s28, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s26, s29, s28
		s_cselect_b32 s28, 1, 0
		s_xor_b32 s17, s17, s24
		s_xor_b32 s24, s26, -1
		s_add_i32 s24, s24, 1
		s_cmp_lt_i32 s17, 0
		s_cselect_b32 s17, s24, s26
		s_add_i32 s24, s0, s27
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s0, s24, s0
		s_xor_b32 s24, s0, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s0, s24, s0
		s_mul_i32 s1, s16, 0x100
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
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v11, 1, v9
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v11
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v14, 1, v13
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v14
		v_bitop3_b32 v6, v6, v12, v15 bitop3:0x96
		v_lshrrev_b32_e32 v16, 7, v0
		v_accvgpr_write_b32 a0, v16
		v_accvgpr_read_b32 v16, a0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 64
		v_mul_lo_u32 v17, v17, v16
		v_xad_u32 v6, v6, v17, s1
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v2, v7
		v_bitop3_b32 v2, v2, v10, v12 bitop3:0x96
		v_xor_b32_e32 v2, v2, v15
		v_xad_u32 v2, v2, v17, s1
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v2, s25
		s_mov_b64 s[28:29], vcc
		v_lshrrev_b32_e32 v2, 5, v0
		v_and_b32_e32 v5, 1, v2
		v_accvgpr_write_b32 a1, v5
		v_accvgpr_read_b32 v5, a1
		v_mov_b32_e32 v6, 2
		v_mul_lo_u32 v6, v6, v5
		v_mov_b32_e32 v5, 4
		v_mul_lo_u32 v5, v5, v14
		v_bitop3_b32 v7, v11, v6, v5 bitop3:0x96
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v16
		v_xad_u32 v7, v7, v10, s1
		v_bitop3_b32 v15, 16, v11, v6 bitop3:0x96
		v_xor_b32_e32 v15, v15, v5
		v_xad_u32 v15, v15, v10, s1
		v_bitop3_b32 v17, 32, v11, v6 bitop3:0x96
		v_xor_b32_e32 v17, v17, v5
		v_xad_u32 v17, v17, v10, s1
		v_bitop3_b32 v18, 48, v11, v6 bitop3:0x96
		v_xor_b32_e32 v18, v18, v5
		v_xad_u32 v18, v18, v10, s1
		v_bitop3_b32 v19, 64, v11, v6 bitop3:0x96
		v_xor_b32_e32 v19, v19, v5
		v_xad_u32 v19, v19, v10, s1
		v_xor_b32_e32 v20, 0x50, v11
		v_xor_b32_e32 v20, v20, v6
		v_xor_b32_e32 v20, v20, v5
		v_xad_u32 v20, v20, v10, s1
		v_xor_b32_e32 v21, 0x60, v11
		v_xor_b32_e32 v21, v21, v6
		v_xor_b32_e32 v21, v21, v5
		v_xad_u32 v21, v21, v10, s1
		v_xor_b32_e32 v22, 0x70, v11
		v_xor_b32_e32 v22, v22, v6
		v_xor_b32_e32 v22, v22, v5
		v_xad_u32 v22, v22, v10, s1
		v_xor_b32_e32 v23, 0x80, v11
		v_xor_b32_e32 v23, v23, v6
		v_xor_b32_e32 v23, v23, v5
		v_xad_u32 v23, v23, v10, s1
		v_xor_b32_e32 v24, 0x90, v11
		v_xor_b32_e32 v24, v24, v6
		v_xor_b32_e32 v24, v24, v5
		v_xad_u32 v24, v24, v10, s1
		v_xor_b32_e32 v25, 0xa0, v11
		v_xor_b32_e32 v25, v25, v6
		v_xor_b32_e32 v25, v25, v5
		v_xad_u32 v25, v25, v10, s1
		v_xor_b32_e32 v26, 0xb0, v11
		v_xor_b32_e32 v26, v26, v6
		v_xor_b32_e32 v26, v26, v5
		v_xad_u32 v26, v26, v10, s1
		v_xor_b32_e32 v27, 0xc0, v11
		v_xor_b32_e32 v27, v27, v6
		v_xor_b32_e32 v27, v27, v5
		v_xad_u32 v27, v27, v10, s1
		v_xor_b32_e32 v28, 0xd0, v11
		v_xor_b32_e32 v28, v28, v6
		v_xor_b32_e32 v28, v28, v5
		v_xad_u32 v28, v28, v10, s1
		v_xor_b32_e32 v29, 0xe0, v11
		v_xor_b32_e32 v29, v29, v6
		v_xor_b32_e32 v29, v29, v5
		v_xad_u32 v29, v29, v10, s1
		v_xor_b32_e32 v11, 0xf0, v11
		v_xor_b32_e32 v6, v11, v6
		v_xor_b32_e32 v5, v6, v5
		v_xad_u32 v5, v5, v10, s1
		s_mov_b32 s34, 0x7fffffff
		s_mov_b32 s35, 0x31016000
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		v_and_b32_e32 v1, 0xffff, v1
		v_lshlrev_b32_e32 v6, 16, v1
		v_or_b32_e32 v32, v1, v6
		v_mov_b32_e32 v33, v32
		v_mov_b32_e32 v34, v32
		v_mov_b32_e32 v35, v32
		s_mul_i32 s1, s16, s12
		s_lshl_b32 s1, s1, 9
		s_mul_i32 s2, s17, s10
		s_lshl_b32 s2, s2, 1
		s_add_i32 s1, s1, s2
		s_mul_i32 s2, s0, s11
		s_lshl_b32 s2, s2, 1
		s_add_i32 s1, s1, s2
		v_accvgpr_read_b32 v1, a0
		v_mul_lo_u32 v1, s12, v1
		v_lshl_add_u32 v1, v1, 4, s1
		v_and_b32_e32 v6, 1, v13
		v_accvgpr_write_b32 a2, v6
		v_accvgpr_read_b32 v6, a2
		v_mul_lo_u32 v6, s12, v6
		v_lshl_add_u32 v1, v6, 3, v1
		v_and_b32_e32 v2, 1, v2
		v_mul_lo_u32 v6, s12, v2
		v_lshl_add_u32 v1, v6, 2, v1
		v_and_b32_e32 v6, 1, v9
		v_mul_lo_u32 v9, s12, v6
		v_lshl_add_u32 v1, v9, 1, v1
		v_and_b32_e32 v9, 1, v0
		v_lshl_add_u32 v1, v9, 4, v1
		v_and_b32_e32 v8, 1, v8
		v_lshl_add_u32 v1, v8, 7, v1
		v_and_b32_e32 v10, 1, v4
		v_lshl_add_u32 v1, v10, 6, v1
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v1, v3, 5, v1
		v_cmp_lt_i32_e64 vcc, v7, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_0
		buffer_load_dwordx4 v[36:39], v1, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_0:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_0
		v_mov_b32_e32 v36, v32
		v_mov_b32_e32 v37, v33
		v_mov_b32_e32 v38, v34
		v_mov_b32_e32 v39, v35
.L_attn_fwd_async_prefetch.exec_endif_0:
		s_mov_b64 exec, s[82:83]
		v_accvgpr_read_b32 v1, a0
		v_lshlrev_b32_e32 v1, 3, v1
		v_accvgpr_read_b32 v7, a2
		v_lshlrev_b32_e32 v7, 2, v7
		v_add_u32_e32 v11, 16, v6
		v_lshlrev_b32_e32 v30, 1, v2
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v15, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_1
		buffer_load_dwordx4 v[40:43], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_1:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_1
		v_mov_b32_e32 v40, v32
		v_mov_b32_e32 v41, v33
		v_mov_b32_e32 v42, v34
		v_mov_b32_e32 v43, v35
.L_attn_fwd_async_prefetch.exec_endif_1:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 32, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v17, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_2
		buffer_load_dwordx4 v[44:47], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_2:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_2
		v_mov_b32_e32 v44, v32
		v_mov_b32_e32 v45, v33
		v_mov_b32_e32 v46, v34
		v_mov_b32_e32 v47, v35
.L_attn_fwd_async_prefetch.exec_endif_2:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 48, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v18, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_3
		buffer_load_dwordx4 v[48:51], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_3:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_3
		v_mov_b32_e32 v48, v32
		v_mov_b32_e32 v49, v33
		v_mov_b32_e32 v50, v34
		v_mov_b32_e32 v51, v35
.L_attn_fwd_async_prefetch.exec_endif_3:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 64, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v19, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_4
		buffer_load_dwordx4 v[52:55], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_4:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_4
		v_mov_b32_e32 v52, v32
		v_mov_b32_e32 v53, v33
		v_mov_b32_e32 v54, v34
		v_mov_b32_e32 v55, v35
.L_attn_fwd_async_prefetch.exec_endif_4:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0x50, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v20, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_5
		buffer_load_dwordx4 v[56:59], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_5:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_5
		v_mov_b32_e32 v56, v32
		v_mov_b32_e32 v57, v33
		v_mov_b32_e32 v58, v34
		v_mov_b32_e32 v59, v35
.L_attn_fwd_async_prefetch.exec_endif_5:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0x60, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v21, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_6
		buffer_load_dwordx4 v[60:63], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_6:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_6
		v_mov_b32_e32 v60, v32
		v_mov_b32_e32 v61, v33
		v_mov_b32_e32 v62, v34
		v_mov_b32_e32 v63, v35
.L_attn_fwd_async_prefetch.exec_endif_6:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0x70, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_7
		buffer_load_dwordx4 v[64:67], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_7:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_7
		v_mov_b32_e32 v64, v32
		v_mov_b32_e32 v65, v33
		v_mov_b32_e32 v66, v34
		v_mov_b32_e32 v67, v35
.L_attn_fwd_async_prefetch.exec_endif_7:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0x80, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v23, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_8
		buffer_load_dwordx4 v[20:23], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_8:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_8
		v_mov_b32_e32 v20, v32
		v_mov_b32_e32 v21, v33
		v_mov_b32_e32 v22, v34
		v_mov_b32_e32 v23, v35
.L_attn_fwd_async_prefetch.exec_endif_8:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0x90, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v24, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_9
		buffer_load_dwordx4 v[68:71], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_9:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_9
		v_mov_b32_e32 v68, v32
		v_mov_b32_e32 v69, v33
		v_mov_b32_e32 v70, v34
		v_mov_b32_e32 v71, v35
.L_attn_fwd_async_prefetch.exec_endif_9:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0xa0, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v25, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_10
		buffer_load_dwordx4 v[72:75], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_10:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_10
		v_mov_b32_e32 v72, v32
		v_mov_b32_e32 v73, v33
		v_mov_b32_e32 v74, v34
		v_mov_b32_e32 v75, v35
.L_attn_fwd_async_prefetch.exec_endif_10:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0xb0, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v26, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_11
		buffer_load_dwordx4 v[76:79], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_11:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_11
		v_mov_b32_e32 v76, v32
		v_mov_b32_e32 v77, v33
		v_mov_b32_e32 v78, v34
		v_mov_b32_e32 v79, v35
.L_attn_fwd_async_prefetch.exec_endif_11:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0xc0, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v27, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_12
		buffer_load_dwordx4 v[24:27], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_12:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_12
		v_mov_b32_e32 v24, v32
		v_mov_b32_e32 v25, v33
		v_mov_b32_e32 v26, v34
		v_mov_b32_e32 v27, v35
.L_attn_fwd_async_prefetch.exec_endif_12:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0xd0, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v28, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_13
		buffer_load_dwordx4 v[80:83], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_13:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_13
		v_mov_b32_e32 v80, v32
		v_mov_b32_e32 v81, v33
		v_mov_b32_e32 v82, v34
		v_mov_b32_e32 v83, v35
.L_attn_fwd_async_prefetch.exec_endif_13:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0xe0, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v29, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_14
		buffer_load_dwordx4 v[84:87], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_14:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_14
		v_mov_b32_e32 v84, v32
		v_mov_b32_e32 v85, v33
		v_mov_b32_e32 v86, v34
		v_mov_b32_e32 v87, v35
.L_attn_fwd_async_prefetch.exec_endif_14:
		s_mov_b64 exec, s[82:83]
		v_add_u32_e32 v11, 0xf0, v6
		v_xor_b32_e32 v11, v11, v30
		v_bitop3_b32 v11, v1, v7, v11 bitop3:0x96
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, s1
		v_lshl_add_u32 v11, v9, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v10, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v5, s25
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_15
		buffer_load_dwordx4 v[88:91], v11, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_15:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_15
		v_mov_b32_e32 v88, v32
		v_mov_b32_e32 v89, v33
		v_mov_b32_e32 v90, v34
		v_mov_b32_e32 v91, v35
.L_attn_fwd_async_prefetch.exec_endif_15:
		s_mov_b64 exec, s[82:83]
		s_mov_b32 s36, s4
		s_mov_b32 s37, s5
		s_mov_b32 s38, s34
		s_mov_b32 s39, s35
		s_mov_b32 s40, s6
		s_mov_b32 s41, s7
		s_mov_b32 s42, s34
		s_mov_b32 s43, s35
		v_bitop3_b32 v5, v30, v0, v6 bitop3:0x96
		v_bitop3_b32 v1, v1, v7, v5 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		s_waitcnt vmcnt(0)
		ds_write_b128 v1, v[36:39] offset:2480
		ds_write_b128 v1, v[40:43] offset:6576
		ds_write_b128 v1, v[44:47] offset:10672
		ds_write_b128 v1, v[48:51] offset:14768
		ds_write_b128 v1, v[52:55] offset:18864
		ds_write_b128 v1, v[56:59] offset:22960
		ds_write_b128 v1, v[60:63] offset:27056
		ds_write_b128 v1, v[64:67] offset:31152
		v_lshlrev_b32_e32 v5, 13, v13
		v_add_u32_e32 v5, 0x10000, v5
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v11, 4, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v11, 1, v11
		v_lshl_add_u32 v5, v11, 12, v5
		v_lshrrev_b32_e32 v13, 3, v7
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v15, 3, v13
		v_lshrrev_b32_e32 v17, 2, v7
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v18, 2, v17
		v_lshrrev_b32_e32 v19, 1, v7
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_and_b32_e32 v28, 1, v7
		v_lshlrev_b32_e32 v28, 4, v28
		v_add_u32_e32 v29, v19, v28
		v_lshrrev_b32_e32 v30, 5, v7
		v_xor_b32_e32 v29, v29, v30
		v_lshrrev_b32_e32 v31, 5, v29
		v_lshlrev_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v17, 6, v17
		v_lshl_add_u32 v13, v13, 7, v17
		v_add_u32_e32 v17, v13, v29
		v_lshrrev_b32_e32 v29, 4, v29
		v_and_b32_e32 v29, 1, v29
		v_bitop3_b32 v17, v31, v17, v29 bitop3:0x96
		v_bitop3_b32 v17, v15, v18, v17 bitop3:0x96
		v_lshlrev_b32_e32 v17, 4, v17
		v_add_u32_e32 v29, v5, v17
		ds_read_b128 a[4:7], v29 offset:2480
		v_add3_u32 v29, 2, v19, v28
		v_xor_b32_e32 v29, v29, v30
		v_lshrrev_b32_e32 v31, 5, v29
		v_lshlrev_b32_e32 v31, 1, v31
		v_add_u32_e32 v32, v13, v29
		v_lshrrev_b32_e32 v29, 4, v29
		v_and_b32_e32 v29, 1, v29
		v_bitop3_b32 v29, v31, v32, v29 bitop3:0x96
		v_bitop3_b32 v29, v15, v18, v29 bitop3:0x96
		v_lshlrev_b32_e32 v29, 4, v29
		v_add_u32_e32 v31, v5, v29
		ds_read_b128 a[8:11], v31 offset:2480
		v_add3_u32 v31, 4, v19, v28
		v_xor_b32_e32 v31, v31, v30
		v_lshrrev_b32_e32 v32, 5, v31
		v_lshlrev_b32_e32 v32, 1, v32
		v_add_u32_e32 v33, v13, v31
		v_lshrrev_b32_e32 v31, 4, v31
		v_and_b32_e32 v31, 1, v31
		v_bitop3_b32 v31, v32, v33, v31 bitop3:0x96
		v_bitop3_b32 v31, v15, v18, v31 bitop3:0x96
		v_lshlrev_b32_e32 v31, 4, v31
		v_add_u32_e32 v32, v5, v31
		ds_read_b128 a[12:15], v32 offset:2480
		v_add3_u32 v32, 6, v19, v28
		v_xor_b32_e32 v32, v32, v30
		v_lshrrev_b32_e32 v33, 5, v32
		v_lshlrev_b32_e32 v33, 1, v33
		v_add_u32_e32 v34, v13, v32
		v_lshrrev_b32_e32 v32, 4, v32
		v_and_b32_e32 v32, 1, v32
		v_bitop3_b32 v32, v33, v34, v32 bitop3:0x96
		v_bitop3_b32 v32, v15, v18, v32 bitop3:0x96
		v_lshlrev_b32_e32 v32, 4, v32
		v_add_u32_e32 v33, v5, v32
		ds_read_b128 a[16:19], v33 offset:2480
		v_add3_u32 v33, 8, v19, v28
		v_xor_b32_e32 v33, v33, v30
		v_lshrrev_b32_e32 v34, 5, v33
		v_lshlrev_b32_e32 v34, 1, v34
		v_add_u32_e32 v35, v13, v33
		v_lshrrev_b32_e32 v33, 4, v33
		v_and_b32_e32 v33, 1, v33
		v_bitop3_b32 v33, v34, v35, v33 bitop3:0x96
		v_bitop3_b32 v33, v15, v18, v33 bitop3:0x96
		v_lshlrev_b32_e32 v33, 4, v33
		v_add_u32_e32 v34, v5, v33
		ds_read_b128 a[20:23], v34 offset:2480
		v_add3_u32 v34, 10, v19, v28
		v_xor_b32_e32 v34, v34, v30
		v_lshrrev_b32_e32 v35, 5, v34
		v_lshlrev_b32_e32 v35, 1, v35
		v_add_u32_e32 v36, v13, v34
		v_lshrrev_b32_e32 v34, 4, v34
		v_and_b32_e32 v34, 1, v34
		v_bitop3_b32 v34, v35, v36, v34 bitop3:0x96
		v_bitop3_b32 v34, v15, v18, v34 bitop3:0x96
		v_lshlrev_b32_e32 v34, 4, v34
		v_add_u32_e32 v35, v5, v34
		ds_read_b128 a[24:27], v35 offset:2480
		v_add3_u32 v35, 12, v19, v28
		v_xor_b32_e32 v35, v35, v30
		v_lshrrev_b32_e32 v36, 5, v35
		v_lshlrev_b32_e32 v36, 1, v36
		v_add_u32_e32 v37, v13, v35
		v_lshrrev_b32_e32 v35, 4, v35
		v_and_b32_e32 v35, 1, v35
		v_bitop3_b32 v35, v36, v37, v35 bitop3:0x96
		v_bitop3_b32 v35, v15, v18, v35 bitop3:0x96
		v_lshlrev_b32_e32 v35, 4, v35
		v_add_u32_e32 v36, v5, v35
		ds_read_b128 a[28:31], v36 offset:2480
		v_add3_u32 v19, 14, v19, v28
		v_xor_b32_e32 v19, v19, v30
		v_lshrrev_b32_e32 v28, 5, v19
		v_lshlrev_b32_e32 v28, 1, v28
		v_add_u32_e32 v13, v13, v19
		v_lshrrev_b32_e32 v19, 4, v19
		v_and_b32_e32 v19, 1, v19
		v_bitop3_b32 v13, v28, v13, v19 bitop3:0x96
		v_bitop3_b32 v13, v15, v18, v13 bitop3:0x96
		v_lshlrev_b32_e32 v13, 4, v13
		v_add_u32_e32 v5, v5, v13
		ds_read_b128 a[32:35], v5 offset:2480
		v_accvgpr_read_b32 v5, a0
		v_lshlrev_b32_e32 v5, 5, v5
		v_lshl_add_u32 v11, v11, 3, 64
		v_accvgpr_read_b32 v15, a2
		v_lshlrev_b32_e32 v15, 4, v15
		v_bitop3_b32 v5, v5, v11, v15 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[20:23] offset:2480
		ds_write_b128 v1, v[68:71] offset:6576
		ds_write_b128 v1, v[72:75] offset:10672
		ds_write_b128 v1, v[76:79] offset:14768
		ds_write_b128 v1, v[24:27] offset:18864
		ds_write_b128 v1, v[80:83] offset:22960
		ds_write_b128 v1, v[84:87] offset:27056
		ds_write_b128 v1, v[88:91] offset:31152
		v_lshrrev_b32_e32 v1, 3, v5
		v_lshl_add_u32 v5, v1, 12, v17
		v_lshl_add_u32 v11, v1, 12, v29
		v_lshl_add_u32 v15, v1, 12, v31
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v5 offset:35248
		ds_read_b128 a[40:43], v11 offset:35248
		ds_read_b128 a[44:47], v15 offset:35248
		v_lshl_add_u32 v5, v1, 12, v32
		ds_read_b128 a[48:51], v5 offset:35248
		v_lshl_add_u32 v5, v1, 12, v33
		ds_read_b128 a[52:55], v5 offset:35248
		v_lshl_add_u32 v5, v1, 12, v34
		ds_read_b128 a[56:59], v5 offset:35248
		v_lshl_add_u32 v5, v1, 12, v35
		ds_read_b128 a[60:63], v5 offset:35248
		v_lshl_add_u32 v1, v1, 12, v13
		ds_read_b128 a[64:67], v1 offset:35248
		s_add_i32 s1, s25, 63
		s_mov_b32 s2, 63
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s2, s2, 0
		s_add_i32 s1, s1, s2
		s_ashr_i32 s1, s1, 6
		s_add_i32 s1, s1, -1
		s_cmp_gt_i32 s1, 0
		s_cselect_b32 s1, s1, 0
		v_accvgpr_read_b32 v1, a1
		v_mov_b32_e32 v5, 32
		v_mul_lo_u32 v5, v5, v1
		v_bitop3_b32 v1, v12, v5, v14 bitop3:0x96
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v16
		v_xor_b32_e32 v1, v1, v11
		v_bitop3_b32 v13, 4, v12, v5 bitop3:0x96
		v_bitop3_b32 v13, v13, v14, v11 bitop3:0x96
		v_bitop3_b32 v15, 8, v12, v5 bitop3:0x96
		v_bitop3_b32 v15, v15, v14, v11 bitop3:0x96
		v_bitop3_b32 v5, 12, v12, v5 bitop3:0x96
		v_bitop3_b32 v5, v5, v14, v11 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v1, s25
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v13, s25
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v15, s25
		s_mov_b64 s[6:7], vcc
		v_cmp_lt_i32_e64 vcc, v5, s25
		v_readfirstlane_b32 s10, v0
		v_accvgpr_read_b32 v11, a0
		v_lshlrev_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v12, 4, v6
		v_accvgpr_write_b32 a3, v12
		v_accvgpr_read_b32 v12, a3
		v_lshl_add_u32 v12, v2, 5, v12
		v_accvgpr_read_b32 v14, a2
		v_bitop3_b32 v11, v11, v12, v14 bitop3:0x96
		v_mul_lo_u32 v12, s15, v11
		v_lshlrev_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v14, 4, v9
		v_lshlrev_b32_e32 v16, 7, v8
		v_add3_u32 v12, v12, v14, v16
		v_lshlrev_b32_e32 v17, 6, v10
		v_lshlrev_b32_e32 v18, 5, v3
		v_add3_u32 v12, v12, v17, v18
		s_mul_i32 s11, s17, s13
		s_lshl_b32 s11, s11, 1
		s_mul_i32 s12, s0, s14
		s_lshl_b32 s12, s12, 1
		s_add_i32 s13, s11, s12
		v_add_u32_e32 v19, s13, v12
		v_mov_b32_e32 v20, 0x80000000
		s_lshr_b32 s10, s10, 6
		s_mul_i32 s14, 0x410, s10
		s_mov_b32 m0, s14
		v_cndmask_b32_e64 v19, v20, v19, s[2:3]
		buffer_load_dwordx4 v19, s[36:39], 0 offen lds
		v_xor_b32_e32 v19, 4, v11
		v_mul_lo_u32 v21, s15, v19
		v_lshlrev_b32_e32 v21, 1, v21
		v_add3_u32 v21, v21, v14, v16
		v_add3_u32 v21, v21, v17, v18
		v_add_u32_e32 v22, s13, v21
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v22, v20, v22, s[4:5]
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		v_xor_b32_e32 v22, 8, v11
		v_mul_lo_u32 v23, s15, v22
		v_lshlrev_b32_e32 v23, 1, v23
		v_add3_u32 v23, v23, v14, v16
		v_add3_u32 v23, v23, v17, v18
		v_add_u32_e32 v24, s13, v23
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v24, v20, v24, s[6:7]
		buffer_load_dwordx4 v24, s[36:39], 0 offen lds
		v_xor_b32_e32 v24, 8, v19
		v_mul_lo_u32 v25, s15, v24
		v_lshlrev_b32_e32 v25, 1, v25
		v_add3_u32 v25, v25, v14, v16
		v_add3_u32 v25, v25, v17, v18
		v_add_u32_e32 v26, s13, v25
		v_cndmask_b32_e32 v26, v20, v26, vcc
		s_add_i32 m0, m0, 0x1040
		v_mul_lo_u32 v11, s20, v11
		buffer_load_dwordx4 v26, s[36:39], 0 offen lds
		v_lshlrev_b32_e32 v11, 1, v11
		v_add3_u32 v11, v11, v14, v16
		v_add3_u32 v11, v11, v17, v18
		s_mul_i32 s13, s17, s18
		s_lshl_b32 s13, s13, 1
		s_mul_i32 s18, s0, s19
		s_lshl_b32 s18, s18, 1
		s_add_i32 s19, s13, s18
		v_add_u32_e32 v26, s19, v11
		s_mul_i32 s10, 0x440, s10
		s_add_i32 m0, s10, 0x81f0
		v_cndmask_b32_e64 v26, v20, v26, s[2:3]
		buffer_load_dwordx4 v26, s[40:43], 0 offen lds
		v_mul_lo_u32 v19, s20, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_add3_u32 v19, v19, v14, v16
		v_add3_u32 v19, v19, v17, v18
		v_add_u32_e32 v26, s19, v19
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v26, v20, v26, s[4:5]
		buffer_load_dwordx4 v26, s[40:43], 0 offen lds
		v_mul_lo_u32 v22, s20, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add3_u32 v22, v22, v14, v16
		v_add3_u32 v22, v22, v17, v18
		v_add_u32_e32 v26, s19, v22
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v26, v20, v26, s[6:7]
		buffer_load_dwordx4 v26, s[40:43], 0 offen lds
		v_mul_lo_u32 v24, s20, v24
		v_lshlrev_b32_e32 v24, 1, v24
		v_add3_u32 v14, v24, v14, v16
		v_add3_u32 v14, v14, v17, v18
		v_add_u32_e32 v16, s19, v14
		v_cndmask_b32_e32 v16, v20, v16, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s2, s1, 64
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
		v_mbcnt_lo_u32_b32 v16, -1, 0
		v_mbcnt_hi_u32_b32 v16, -1, v16
		v_and_b32_e32 v17, 1, v16
		v_lshrrev_b32_e32 v18, 4, v16
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 4, v18
		v_lshrrev_b32_e32 v24, 3, v16
		v_and_b32_e32 v24, 1, v24
		v_lshlrev_b32_e32 v24, 3, v24
		v_add3_u32 v26, v17, v18, v24
		v_lshrrev_b32_e32 v27, 2, v16
		v_and_b32_e32 v27, 1, v27
		v_lshlrev_b32_e32 v27, 2, v27
		v_lshrrev_b32_e32 v16, 1, v16
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add3_u32 v26, v26, v27, v16
		v_add_u32_e32 v17, 32, v17
		v_bitop3_b32 v16, v27, v17, v16 bitop3:0x96
		v_bitop3_b32 v16, v18, v24, v16 bitop3:0x96
		v_mov_b32_e32 v28, 0x3e0293ee
		v_mov_b32_e32 v29, 0x3e0293ee
		s_mov_b32 s3, 0xff800000
		v_mov_b32_e32 v17, s3
		s_mov_b32 s4, 0
		v_lshlrev_b32_e32 v18, 4, v30
		v_and_b32_e32 v7, 31, v7
		v_lshrrev_b32_e32 v24, 4, v7
		v_accvgpr_write_b32 a68, v24
		v_accvgpr_read_b32 v24, a68
		v_lshlrev_b32_e32 v24, 8, v24
		v_lshrrev_b32_e32 v27, 3, v7
		v_and_b32_e32 v27, 1, v27
		v_mov_b32_e32 v31, 0x2080
		v_mul_lo_u32 v31, v31, v27
		v_lshrrev_b32_e32 v27, 2, v7
		v_and_b32_e32 v27, 1, v27
		v_mov_b32_e32 v32, 0x1040
		v_mul_lo_u32 v32, v32, v27
		v_lshrrev_b32_e32 v27, 1, v7
		v_and_b32_e32 v27, 1, v27
		v_mov_b32_e32 v33, 0x820
		v_mul_lo_u32 v33, v33, v27
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v27, 0x410
		v_mul_lo_u32 v27, v27, v7
		v_and_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 3, v0
		v_mov_b32_e32 v7, 0x2200
		v_mul_lo_u32 v7, v7, v2
		v_lshlrev_b32_e32 v34, 5, v6
		v_and_b32_e32 v4, 3, v4
		v_mov_b32_e32 v35, 0x440
		v_mul_lo_u32 v35, v35, v4
		s_lshl_b32 s5, s15, 7
		s_add_i32 s5, s5, s11
		s_add_i32 s5, s5, s12
		s_lshl_b32 s6, s20, 7
		s_add_i32 s6, s6, s13
		s_add_i32 s6, s6, s18
		v_lshlrev_b32_e32 v4, 2, v26
		v_lshlrev_b32_e32 v16, 2, v16
		s_cmp_lt_i32 0, s2
		v_mov_b32_e32 v36, 1.0
		v_mov_b32_e32 v37, 1.0
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		v_mov_b32_e32 v26, s3
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
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
		v_mov_b64_e32 v[112:113], 0
		v_mov_b64_e32 v[114:115], 0
		v_mov_b64_e32 v[116:117], 0
		v_mov_b64_e32 v[118:119], 0
		v_mov_b64_e32 v[120:121], 0
		v_mov_b64_e32 v[122:123], 0
		v_mov_b64_e32 v[124:125], 0
		v_mov_b64_e32 v[126:127], 0
		v_mov_b64_e32 v[128:129], 0
		v_mov_b64_e32 v[130:131], 0
		v_mov_b64_e32 v[132:133], 0
		v_mov_b64_e32 v[134:135], 0
		v_mov_b64_e32 v[136:137], 0
		v_mov_b64_e32 v[138:139], 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_mov_b64_e32 v[144:145], 0
		v_mov_b64_e32 v[146:147], 0
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		v_mov_b64_e32 v[152:153], 0
		v_mov_b64_e32 v[154:155], 0
		v_mov_b64_e32 v[156:157], 0
		v_mov_b64_e32 v[158:159], 0
		v_mov_b64_e32 v[160:161], 0
		v_mov_b64_e32 v[162:163], 0
		v_mov_b64_e32 v[164:165], 0
		v_mov_b64_e32 v[166:167], 0
		v_mov_b64_e32 v[168:169], 0
		v_mov_b64_e32 v[170:171], 0
		v_mov_b64_e32 v[172:173], 0
		v_mov_b64_e32 v[174:175], 0
		s_cbranch_scc0 .L_attn_fwd_async_prefetch.loop_exit_0
.L_attn_fwd_async_prefetch.loop_head_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s3, s4, 6
		s_and_b32 s7, s3, 1
		s_mul_i32 s11, 0x4100, s7
		v_add3_u32 v38, s11, v18, v24
		v_add3_u32 v38, v38, v31, v32
		v_add3_u32 v38, v38, v33, v27
		ds_read_b128 v[40:43], v38
		ds_read_b128 v[44:47], v38 offset:32
		ds_read_b128 a[72:75], v38 offset:64
		ds_read_b128 a[76:79], v38 offset:96
		ds_read_b128 a[80:83], v38 offset:128
		ds_read_b128 a[84:87], v38 offset:160
		ds_read_b128 a[88:91], v38 offset:192
		ds_read_b128 a[92:95], v38 offset:224
		ds_read_b128 v[176:179], v38 offset:512
		ds_read_b128 v[180:183], v38 offset:544
		ds_read_b128 a[96:99], v38 offset:576
		ds_read_b128 a[100:103], v38 offset:608
		ds_read_b128 a[104:107], v38 offset:640
		ds_read_b128 a[108:111], v38 offset:672
		ds_read_b128 a[112:115], v38 offset:704
		ds_read_b128 a[116:119], v38 offset:736
		s_mul_i32 s7, 0x4400, s7
		v_add3_u32 v38, s7, v0, v7
		v_add3_u32 v38, v38, v34, v35
		ds_read_b64_tr_b16 a[120:121], v38 offset:33264
		ds_read_b64_tr_b16 a[122:123], v38 offset:37616
		ds_read_b64_tr_b16 a[124:125], v38 offset:33520
		ds_read_b64_tr_b16 a[126:127], v38 offset:37872
		ds_read_b64_tr_b16 a[128:129], v38 offset:33776
		ds_read_b64_tr_b16 a[130:131], v38 offset:38128
		ds_read_b64_tr_b16 a[132:133], v38 offset:34032
		ds_read_b64_tr_b16 a[134:135], v38 offset:38384
		ds_read_b64_tr_b16 a[136:137], v38 offset:33328
		ds_read_b64_tr_b16 a[138:139], v38 offset:37680
		ds_read_b64_tr_b16 a[140:141], v38 offset:33584
		ds_read_b64_tr_b16 a[142:143], v38 offset:37936
		ds_read_b64_tr_b16 a[144:145], v38 offset:33840
		ds_read_b64_tr_b16 a[146:147], v38 offset:38192
		ds_read_b64_tr_b16 a[148:149], v38 offset:34096
		ds_read_b64_tr_b16 a[150:151], v38 offset:38448
		ds_read_b64_tr_b16 a[152:153], v38 offset:33392
		ds_read_b64_tr_b16 a[154:155], v38 offset:37744
		ds_read_b64_tr_b16 a[156:157], v38 offset:33648
		ds_read_b64_tr_b16 a[158:159], v38 offset:38000
		ds_read_b64_tr_b16 a[160:161], v38 offset:33904
		ds_read_b64_tr_b16 a[162:163], v38 offset:38256
		ds_read_b64_tr_b16 a[164:165], v38 offset:34160
		ds_read_b64_tr_b16 a[166:167], v38 offset:38512
		ds_read_b64_tr_b16 a[168:169], v38 offset:33456
		ds_read_b64_tr_b16 a[170:171], v38 offset:37808
		ds_read_b64_tr_b16 a[172:173], v38 offset:33712
		ds_read_b64_tr_b16 a[174:175], v38 offset:38064
		ds_read_b64_tr_b16 a[176:177], v38 offset:33968
		ds_read_b64_tr_b16 a[178:179], v38 offset:38320
		ds_read_b64_tr_b16 a[180:181], v38 offset:34224
		ds_read_b64_tr_b16 a[182:183], v38 offset:38576
		s_mul_i32 s7, s15, s4
		s_lshl_b32 s7, s7, 1
		s_add_i32 s7, s5, s7
		v_add_u32_e32 v38, s7, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v39, s7, v21
		s_add_i32 s3, s3, 1
		v_add_u32_e32 v184, s7, v23
		s_and_b32 s3, s3, 1
		v_add_u32_e32 v185, s7, v25
		s_mul_i32 s7, 0x4100, s3
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[4:7], 0
		s_add_i32 s7, s14, s7
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[4:7], 0
		s_mov_b32 m0, s7
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[36:39], 0
		s_mul_i32 s7, s20, s4
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[36:39], 0
		s_add_i32 s4, s4, 64
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], a[8:11], v[192:207]
		v_add_u32_e32 v40, s4, v1
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[8:11], v[208:223]
		v_add_u32_e32 v41, s4, v13
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[40:43], v[224:239]
		v_add_u32_e32 v42, s4, v15
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[40:43], v[240:255]
		v_add_u32_e32 v43, s4, v5
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[12:15], v[192:207]
		v_cmp_lt_i32_e64 vcc, v40, s25
		s_mov_b64 s[12:13], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[12:15], v[208:223]
		v_cmp_lt_i32_e64 vcc, v41, s25
		s_mov_b64 s[18:19], vcc
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[44:47], v[224:239]
		v_cmp_lt_i32_e64 vcc, v42, s25
		s_mov_b64 s[30:31], vcc
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[44:47], v[240:255]
		v_cmp_lt_i32_e64 vcc, v43, s25
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[16:19], v[192:207]
		v_cndmask_b32_e64 v38, v20, v38, s[12:13]
		buffer_load_dwordx4 v38, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v38, v20, v39, s[18:19]
		v_cndmask_b32_e64 v39, v20, v184, s[30:31]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v40, v20, v185, vcc
		s_lshl_b32 s7, s7, 1
		buffer_load_dwordx4 v38, s[36:39], 0 offen lds
		s_add_i32 s7, s6, s7
		v_add_u32_e32 v38, s7, v11
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s3, 0x4400, s3
		s_add_i32 s3, s10, s3
		buffer_load_dwordx4 v39, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v38, v20, v38, s[12:13]
		v_add_u32_e32 v39, s7, v19
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v39, v20, v39, s[18:19]
		v_add_u32_e32 v41, s7, v22
		buffer_load_dwordx4 v40, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v40, v20, v41, s[30:31]
		v_add_u32_e32 v41, s7, v14
		s_add_i32 m0, s3, 0x81f0
		v_cndmask_b32_e32 v41, v20, v41, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[16:19], v[208:223]
		buffer_load_dwordx4 v38, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[48:51], v[224:239]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[20:23], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[20:23], v[208:223]
		buffer_load_dwordx4 v39, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[52:55], v[224:239]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[108:111], a[24:27], v[208:223]
		buffer_load_dwordx4 v40, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], a[56:59], v[224:239]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s4, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], a[84:87], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[112:115], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[88:91], a[60:63], v[240:255]
		buffer_load_dwordx4 v41, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[92:95], a[32:35], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[116:119], a[32:35], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[116:119], a[64:67], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[92:95], a[64:67], v[240:255]
		s_nop 8
		v_max_f32_e32 v38, v192, v193
		v_max_f32_e32 v39, v194, v195
		v_max_f32_e32 v40, v196, v197
		v_max_f32_e32 v41, v198, v199
		v_max_f32_e32 v42, v200, v201
		v_max_f32_e32 v43, v202, v203
		v_max_f32_e32 v44, v204, v205
		v_max_f32_e32 v45, v206, v207
		v_max_f32_e32 v46, v208, v209
		v_max_f32_e32 v47, v210, v211
		v_max_f32_e32 v176, v212, v213
		v_max_f32_e32 v177, v214, v215
		v_max_f32_e32 v178, v216, v217
		v_max_f32_e32 v179, v218, v219
		v_max_f32_e32 v180, v220, v221
		v_max_f32_e32 v181, v222, v223
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v42, v46, v47
		v_max_f32_e32 v43, v176, v177
		v_max_f32_e32 v44, v178, v179
		v_max_f32_e32 v45, v180, v181
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v38, v38, v39
		ds_bpermute_b32 v39, v4, v38
		ds_bpermute_b32 v40, v16, v38
		v_max_f32_e32 v38, v240, v241
		v_max_f32_e32 v41, v242, v243
		v_max_f32_e32 v42, v244, v245
		v_max_f32_e32 v43, v246, v247
		v_max_f32_e32 v44, v248, v249
		v_max_f32_e32 v45, v250, v251
		v_max_f32_e32 v46, v252, v253
		v_max_f32_e32 v47, v254, v255
		v_max_f32_e32 v176, v224, v225
		v_max_f32_e32 v177, v226, v227
		v_max_f32_e32 v178, v228, v229
		v_max_f32_e32 v179, v230, v231
		v_max_f32_e32 v180, v232, v233
		v_max_f32_e32 v181, v234, v235
		v_max_f32_e32 v182, v236, v237
		v_max_f32_e32 v183, v238, v239
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v184, v39, v40
		v_max_f32_e32 v38, v38, v41
		v_max_f32_e32 v39, v42, v43
		v_max_f32_e32 v40, v44, v45
		v_max_f32_e32 v41, v46, v47
		v_max_f32_e32 v42, v176, v177
		v_max_f32_e32 v43, v178, v179
		v_max_f32_e32 v44, v180, v181
		v_max_f32_e32 v45, v182, v183
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v38, v38, v39
		ds_bpermute_b32 v39, v4, v38
		ds_bpermute_b32 v40, v16, v38
		v_pk_mul_f32 v[42:43], v[192:193], v[28:29]
		v_pk_mul_f32 v[44:45], v[194:195], v[28:29]
		v_pk_mul_f32 v[46:47], v[196:197], v[28:29]
		v_pk_mul_f32 v[176:177], v[198:199], v[28:29]
		v_pk_mul_f32 v[178:179], v[200:201], v[28:29]
		v_pk_mul_f32 v[180:181], v[202:203], v[28:29]
		v_pk_mul_f32 v[182:183], v[204:205], v[28:29]
		v_pk_mul_f32 v[186:187], v[206:207], v[28:29]
		v_pk_mul_f32 v[188:189], v[208:209], v[28:29]
		v_pk_mul_f32 v[190:191], v[210:211], v[28:29]
		v_pk_mul_f32 v[192:193], v[212:213], v[28:29]
		v_pk_mul_f32 v[194:195], v[214:215], v[28:29]
		v_pk_mul_f32 v[196:197], v[216:217], v[28:29]
		v_pk_mul_f32 v[198:199], v[218:219], v[28:29]
		v_pk_mul_f32 v[200:201], v[220:221], v[28:29]
		v_pk_mul_f32 v[202:203], v[222:223], v[28:29]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v185, v39, v40
		v_pk_mul_f32 v[38:39], v[184:185], v[28:29]
		v_max_f32_e32 v38, v17, v38
		v_max_f32_e32 v39, v26, v39
		v_pk_mul_f32 v[40:41], v[240:241], v[28:29]
		v_pk_mul_f32 v[184:185], v[242:243], v[28:29]
		v_pk_mul_f32 v[204:205], v[244:245], v[28:29]
		v_pk_mul_f32 v[206:207], v[246:247], v[28:29]
		v_pk_mul_f32 v[208:209], v[248:249], v[28:29]
		v_pk_mul_f32 v[210:211], v[250:251], v[28:29]
		v_pk_mul_f32 v[212:213], v[252:253], v[28:29]
		v_pk_mul_f32 v[214:215], v[254:255], v[28:29]
		v_pk_mul_f32 v[216:217], v[224:225], v[28:29]
		v_pk_mul_f32 v[218:219], v[226:227], v[28:29]
		v_pk_mul_f32 v[220:221], v[228:229], v[28:29]
		v_pk_mul_f32 v[222:223], v[230:231], v[28:29]
		v_pk_mul_f32 v[224:225], v[232:233], v[28:29]
		v_pk_mul_f32 v[226:227], v[234:235], v[28:29]
		v_pk_mul_f32 v[228:229], v[236:237], v[28:29]
		v_pk_mul_f32 v[230:231], v[238:239], v[28:29]
		v_sub_f32_e32 v42, v42, v38
		v_sub_f32_e32 v43, v43, v38
		v_sub_f32_e32 v44, v44, v38
		v_sub_f32_e32 v45, v45, v38
		v_sub_f32_e32 v46, v46, v38
		v_sub_f32_e32 v47, v47, v38
		v_sub_f32_e32 v176, v176, v38
		v_sub_f32_e32 v177, v177, v38
		v_sub_f32_e32 v178, v178, v38
		v_sub_f32_e32 v179, v179, v38
		v_sub_f32_e32 v180, v180, v38
		v_sub_f32_e32 v181, v181, v38
		v_sub_f32_e32 v182, v182, v38
		v_sub_f32_e32 v183, v183, v38
		v_sub_f32_e32 v186, v186, v38
		v_sub_f32_e32 v187, v187, v38
		v_sub_f32_e32 v188, v188, v38
		v_sub_f32_e32 v189, v189, v38
		v_sub_f32_e32 v190, v190, v38
		v_sub_f32_e32 v191, v191, v38
		v_sub_f32_e32 v192, v192, v38
		v_sub_f32_e32 v193, v193, v38
		v_sub_f32_e32 v194, v194, v38
		v_sub_f32_e32 v195, v195, v38
		v_sub_f32_e32 v196, v196, v38
		v_sub_f32_e32 v197, v197, v38
		v_sub_f32_e32 v198, v198, v38
		v_sub_f32_e32 v199, v199, v38
		v_sub_f32_e32 v200, v200, v38
		v_sub_f32_e32 v201, v201, v38
		v_sub_f32_e32 v202, v202, v38
		v_sub_f32_e32 v203, v203, v38
		v_sub_f32_e32 v40, v40, v39
		v_sub_f32_e32 v41, v41, v39
		v_sub_f32_e32 v184, v184, v39
		v_sub_f32_e32 v185, v185, v39
		v_sub_f32_e32 v204, v204, v39
		v_sub_f32_e32 v205, v205, v39
		v_sub_f32_e32 v206, v206, v39
		v_sub_f32_e32 v207, v207, v39
		v_sub_f32_e32 v208, v208, v39
		v_sub_f32_e32 v209, v209, v39
		v_sub_f32_e32 v210, v210, v39
		v_sub_f32_e32 v211, v211, v39
		v_sub_f32_e32 v212, v212, v39
		v_sub_f32_e32 v213, v213, v39
		v_sub_f32_e32 v214, v214, v39
		v_sub_f32_e32 v215, v215, v39
		v_sub_f32_e32 v216, v216, v39
		v_sub_f32_e32 v217, v217, v39
		v_sub_f32_e32 v218, v218, v39
		v_sub_f32_e32 v219, v219, v39
		v_sub_f32_e32 v220, v220, v39
		v_sub_f32_e32 v221, v221, v39
		v_sub_f32_e32 v222, v222, v39
		v_sub_f32_e32 v223, v223, v39
		v_sub_f32_e32 v224, v224, v39
		v_sub_f32_e32 v225, v225, v39
		v_sub_f32_e32 v226, v226, v39
		v_sub_f32_e32 v227, v227, v39
		v_sub_f32_e32 v228, v228, v39
		v_sub_f32_e32 v229, v229, v39
		v_sub_f32_e32 v230, v230, v39
		v_sub_f32_e32 v231, v231, v39
		v_exp_f32_e32 v232, v42
		v_exp_f32_e32 v234, v43
		v_exp_f32_e32 v233, v44
		v_exp_f32_e32 v235, v45
		v_exp_f32_e32 v42, v46
		v_exp_f32_e32 v44, v47
		v_exp_f32_e32 v43, v176
		v_exp_f32_e32 v45, v177
		v_exp_f32_e32 v46, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v47, v180
		v_exp_f32_e32 v177, v181
		v_exp_f32_e32 v178, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v179, v186
		v_exp_f32_e32 v181, v187
		v_exp_f32_e32 v182, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v183, v190
		v_exp_f32_e32 v187, v191
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v189, v194
		v_exp_f32_e32 v191, v195
		v_exp_f32_e32 v192, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v193, v198
		v_exp_f32_e32 v195, v199
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v197, v202
		v_exp_f32_e32 v199, v203
		v_exp_f32_e32 v201, v40
		v_exp_f32_e32 v203, v41
		v_exp_f32_e32 v40, v184
		v_exp_f32_e32 v236, v185
		v_exp_f32_e32 v41, v204
		v_exp_f32_e32 v237, v205
		v_exp_f32_e32 v184, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v185, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v206, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v207, v212
		v_exp_f32_e32 v209, v213
		v_exp_f32_e32 v210, v214
		v_exp_f32_e32 v212, v215
		v_exp_f32_e32 v211, v216
		v_exp_f32_e32 v213, v217
		v_exp_f32_e32 v214, v218
		v_exp_f32_e32 v216, v219
		v_exp_f32_e32 v215, v220
		v_exp_f32_e32 v217, v221
		v_exp_f32_e32 v218, v222
		v_exp_f32_e32 v220, v223
		v_exp_f32_e32 v219, v224
		v_exp_f32_e32 v221, v225
		v_exp_f32_e32 v222, v226
		v_exp_f32_e32 v224, v227
		v_exp_f32_e32 v223, v228
		v_exp_f32_e32 v225, v229
		v_exp_f32_e32 v226, v230
		v_exp_f32_e32 v228, v231
		v_pk_add_f32 v[230:231], v[232:233], v[234:235]
		v_pk_add_f32 v[238:239], v[42:43], v[44:45]
		v_pk_add_f32 v[240:241], v[46:47], v[176:177]
		v_pk_add_f32 v[242:243], v[178:179], v[180:181]
		v_pk_add_f32 v[244:245], v[182:183], v[186:187]
		v_pk_add_f32 v[246:247], v[188:189], v[190:191]
		v_pk_add_f32 v[248:249], v[192:193], v[194:195]
		v_pk_add_f32 v[250:251], v[196:197], v[198:199]
		v_mov_b32_e32 v252, v231
		v_mov_b32_e32 v253, v239
		v_mov_b32_e32 v254, v230
		v_mov_b32_e32 v255, v238
		v_pk_add_f32 v[230:231], v[254:255], v[252:253]
		v_mov_b32_e32 v238, v241
		v_mov_b32_e32 v239, v243
		v_mov_b32_e32 v252, v240
		v_mov_b32_e32 v253, v242
		v_pk_add_f32 v[240:241], v[252:253], v[238:239]
		v_mov_b32_e32 v238, v245
		v_mov_b32_e32 v239, v247
		v_mov_b32_e32 v242, v244
		v_mov_b32_e32 v243, v246
		v_pk_add_f32 v[244:245], v[242:243], v[238:239]
		v_mov_b32_e32 v238, v249
		v_mov_b32_e32 v239, v251
		v_mov_b32_e32 v242, v248
		v_mov_b32_e32 v243, v250
		v_pk_add_f32 v[246:247], v[242:243], v[238:239]
		v_mov_b32_e32 v238, v231
		v_mov_b32_e32 v239, v241
		v_mov_b32_e32 v242, v230
		v_mov_b32_e32 v243, v240
		v_pk_add_f32 v[230:231], v[242:243], v[238:239]
		v_mov_b32_e32 v238, v245
		v_mov_b32_e32 v239, v247
		v_mov_b32_e32 v240, v244
		v_mov_b32_e32 v241, v246
		v_pk_add_f32 v[242:243], v[240:241], v[238:239]
		v_mov_b32_e32 v238, v231
		v_mov_b32_e32 v239, v243
		v_mov_b32_e32 v240, v230
		v_mov_b32_e32 v241, v242
		v_pk_add_f32 v[230:231], v[240:241], v[238:239]
		v_add_f32_e32 v227, v230, v231
		ds_bpermute_b32 v200, v4, v227
		ds_bpermute_b32 v202, v16, v227
		v_pk_add_f32 v[230:231], v[40:41], v[236:237]
		v_pk_add_f32 v[238:239], v[184:185], v[204:205]
		v_pk_add_f32 v[240:241], v[206:207], v[208:209]
		v_pk_add_f32 v[242:243], v[210:211], v[212:213]
		v_pk_add_f32 v[244:245], v[214:215], v[216:217]
		v_pk_add_f32 v[246:247], v[218:219], v[220:221]
		v_pk_add_f32 v[248:249], v[222:223], v[224:225]
		v_mov_b32_e32 v250, v231
		v_mov_b32_e32 v251, v240
		v_pk_add_f32 v[252:253], v[250:251], v[238:239]
		v_mov_b32_e32 v238, v241
		v_mov_b32_e32 v239, v244
		v_pk_add_f32 v[238:239], v[238:239], v[242:243]
		v_mov_b32_e32 v240, v245
		v_mov_b32_e32 v241, v248
		v_pk_add_f32 v[242:243], v[240:241], v[246:247]
		v_mov_b32_e32 v240, v253
		v_mov_b32_e32 v241, v242
		v_pk_add_f32 v[244:245], v[240:241], v[238:239]
		v_sub_f32_e32 v17, v17, v38
		v_sub_f32_e32 v26, v26, v39
		v_exp_f32_e32 v238, v17
		v_exp_f32_e32 v240, v26
		v_mov_b32_e32 v239, v238
		v_pk_mul_f32 v[48:49], v[48:49], v[238:239]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[246:247], v[200:201], v[202:203]
		v_mov_b32_e32 v227, v247
		v_mov_b32_e32 v229, v230
		v_pk_add_f32 v[230:231], v[226:227], v[228:229]
		v_mov_b32_e32 v250, v249
		v_mov_b32_e32 v251, v252
		v_pk_add_f32 v[230:231], v[250:251], v[230:231]
		v_mov_b32_e32 v248, v243
		v_mov_b32_e32 v249, v244
		v_pk_add_f32 v[242:243], v[248:249], v[230:231]
		v_add_f32_e32 v17, v245, v242
		v_add_f32_e32 v17, v243, v17
		ds_bpermute_b32 v26, v4, v17
		ds_bpermute_b32 v200, v16, v17
		v_pk_mul_f32 v[50:51], v[50:51], v[238:239]
		v_pk_mul_f32 v[52:53], v[52:53], v[238:239]
		v_pk_mul_f32 v[54:55], v[54:55], v[238:239]
		v_pk_mul_f32 v[56:57], v[56:57], v[238:239]
		v_pk_mul_f32 v[58:59], v[58:59], v[238:239]
		v_pk_mul_f32 v[60:61], v[60:61], v[238:239]
		v_pk_mul_f32 v[62:63], v[62:63], v[238:239]
		v_pk_mul_f32 v[64:65], v[64:65], v[238:239]
		v_pk_mul_f32 v[66:67], v[66:67], v[238:239]
		v_pk_mul_f32 v[68:69], v[68:69], v[238:239]
		v_pk_mul_f32 v[70:71], v[70:71], v[238:239]
		v_pk_mul_f32 v[72:73], v[72:73], v[238:239]
		v_pk_mul_f32 v[74:75], v[74:75], v[238:239]
		v_pk_mul_f32 v[76:77], v[76:77], v[238:239]
		v_pk_mul_f32 v[78:79], v[78:79], v[238:239]
		v_pk_mul_f32 v[80:81], v[80:81], v[238:239]
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v231, v26, v200
		v_pk_mul_f32 v[82:83], v[82:83], v[238:239]
		v_pk_mul_f32 v[84:85], v[84:85], v[238:239]
		v_pk_mul_f32 v[86:87], v[86:87], v[238:239]
		v_pk_mul_f32 v[88:89], v[88:89], v[238:239]
		v_pk_mul_f32 v[90:91], v[90:91], v[238:239]
		v_pk_mul_f32 v[92:93], v[92:93], v[238:239]
		v_pk_mul_f32 v[94:95], v[94:95], v[238:239]
		v_pk_mul_f32 v[96:97], v[96:97], v[238:239]
		v_pk_mul_f32 v[98:99], v[98:99], v[238:239]
		v_pk_mul_f32 v[100:101], v[100:101], v[238:239]
		v_pk_mul_f32 v[102:103], v[102:103], v[238:239]
		v_pk_mul_f32 v[104:105], v[104:105], v[238:239]
		v_pk_mul_f32 v[106:107], v[106:107], v[238:239]
		v_pk_mul_f32 v[108:109], v[108:109], v[238:239]
		v_pk_mul_f32 v[110:111], v[110:111], v[238:239]
		v_mov_b32_e32 v241, v240
		v_pk_mul_f32 v[112:113], v[112:113], v[240:241]
		v_pk_mul_f32 v[114:115], v[114:115], v[240:241]
		v_pk_mul_f32 v[116:117], v[116:117], v[240:241]
		v_pk_mul_f32 v[118:119], v[118:119], v[240:241]
		v_pk_mul_f32 v[120:121], v[120:121], v[240:241]
		v_pk_mul_f32 v[122:123], v[122:123], v[240:241]
		v_pk_mul_f32 v[124:125], v[124:125], v[240:241]
		v_pk_mul_f32 v[126:127], v[126:127], v[240:241]
		v_pk_mul_f32 v[128:129], v[128:129], v[240:241]
		v_pk_mul_f32 v[130:131], v[130:131], v[240:241]
		v_pk_mul_f32 v[132:133], v[132:133], v[240:241]
		v_pk_mul_f32 v[134:135], v[134:135], v[240:241]
		v_pk_mul_f32 v[136:137], v[136:137], v[240:241]
		v_pk_mul_f32 v[138:139], v[138:139], v[240:241]
		v_pk_mul_f32 v[140:141], v[140:141], v[240:241]
		v_pk_mul_f32 v[142:143], v[142:143], v[240:241]
		v_pk_mul_f32 v[144:145], v[144:145], v[240:241]
		v_pk_mul_f32 v[146:147], v[146:147], v[240:241]
		v_pk_mul_f32 v[148:149], v[148:149], v[240:241]
		v_pk_mul_f32 v[150:151], v[150:151], v[240:241]
		v_pk_mul_f32 v[152:153], v[152:153], v[240:241]
		v_pk_mul_f32 v[154:155], v[154:155], v[240:241]
		v_pk_mul_f32 v[156:157], v[156:157], v[240:241]
		v_pk_mul_f32 v[158:159], v[158:159], v[240:241]
		v_pk_mul_f32 v[160:161], v[160:161], v[240:241]
		v_pk_mul_f32 v[162:163], v[162:163], v[240:241]
		v_pk_mul_f32 v[164:165], v[164:165], v[240:241]
		v_pk_mul_f32 v[166:167], v[166:167], v[240:241]
		v_pk_mul_f32 v[168:169], v[168:169], v[240:241]
		v_pk_mul_f32 v[170:171], v[170:171], v[240:241]
		v_pk_mul_f32 v[172:173], v[172:173], v[240:241]
		v_pk_mul_f32 v[174:175], v[174:175], v[240:241]
		v_mov_b32_e32 v230, v246
		v_mov_b32_e32 v242, v238
		v_mov_b32_e32 v243, v240
		v_pk_fma_f32 v[36:37], v[36:37], v[242:243], v[230:231]
		v_cvt_pk_bf16_f32 v240, v232, v234
		v_cvt_pk_bf16_f32 v241, v233, v235
		v_cvt_pk_bf16_f32 v242, v42, v44
		v_cvt_pk_bf16_f32 v243, v43, v45
		v_cvt_pk_bf16_f32 v232, v46, v176
		v_cvt_pk_bf16_f32 v233, v47, v177
		v_cvt_pk_bf16_f32 v234, v178, v180
		v_cvt_pk_bf16_f32 v235, v179, v181
		v_cvt_pk_bf16_f32 v44, v182, v186
		v_cvt_pk_bf16_f32 v45, v183, v187
		v_cvt_pk_bf16_f32 v46, v188, v190
		v_cvt_pk_bf16_f32 v47, v189, v191
		v_cvt_pk_bf16_f32 v176, v192, v194
		v_cvt_pk_bf16_f32 v177, v193, v195
		v_cvt_pk_bf16_f32 v178, v196, v198
		v_cvt_pk_bf16_f32 v179, v197, v199
		v_cvt_pk_bf16_f32 v180, v201, v203
		v_cvt_pk_bf16_f32 v181, v40, v236
		v_cvt_pk_bf16_f32 v182, v41, v237
		v_cvt_pk_bf16_f32 v183, v184, v204
		v_cvt_pk_bf16_f32 v40, v185, v205
		v_cvt_pk_bf16_f32 v41, v206, v208
		v_cvt_pk_bf16_f32 v42, v207, v209
		v_cvt_pk_bf16_f32 v43, v210, v212
		v_cvt_pk_bf16_f32 v184, v211, v213
		v_cvt_pk_bf16_f32 v185, v214, v216
		v_cvt_pk_bf16_f32 v186, v215, v217
		v_cvt_pk_bf16_f32 v187, v218, v220
		v_cvt_pk_bf16_f32 v188, v219, v221
		v_cvt_pk_bf16_f32 v189, v222, v224
		v_cvt_pk_bf16_f32 v190, v223, v225
		v_cvt_pk_bf16_f32 v191, v226, v228
		v_permlane32_swap_b32_e32 v240, v242
		v_permlane32_swap_b32_e32 v241, v243
		v_permlane32_swap_b32_e32 v232, v234
		v_permlane32_swap_b32_e32 v233, v235
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[240:243], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[240:243], v[64:79]
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[240:243], v[80:95]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[96:111], a[168:171], v[240:243], v[96:111]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[232:235], v[48:63]
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_mfma_f32_32x32x16_bf16 v[160:175], a[168:171], v[180:183], v[160:175]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[180:183], v[112:127]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[180:183], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[180:183], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[232:235], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[232:235], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[172:175], v[232:235], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[172:175], v[40:43], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[44:47], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[44:47], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[44:47], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[176:179], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], v[184:187], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], v[184:187], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], v[184:187], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], v[184:187], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[176:179], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[176:179], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[176:179], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[180:183], v[176:179], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], v[188:191], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], v[188:191], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], v[188:191], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], v[188:191], v[144:159]
		v_mov_b32_e32 v17, v38
		v_mov_b32_e32 v26, v39
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s34
		s_mov_b32 s7, s35
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s1, 1
		s_mul_i32 s3, 0x4100, s1
		v_lshl_add_u32 v1, v30, 4, s3
		v_accvgpr_read_b32 v5, a68
		v_lshl_add_u32 v1, v5, 8, v1
		v_add3_u32 v1, v1, v31, v32
		v_add3_u32 v1, v1, v33, v27
		ds_read_b128 v[12:15], v1
		ds_read_b128 v[20:23], v1 offset:32
		ds_read_b128 v[40:43], v1 offset:64
		ds_read_b128 a[68:71], v1 offset:96
		ds_read_b128 a[72:75], v1 offset:128
		ds_read_b128 a[76:79], v1 offset:160
		ds_read_b128 a[80:83], v1 offset:192
		ds_read_b128 a[84:87], v1 offset:224
		ds_read_b128 v[44:47], v1 offset:512
		ds_read_b128 v[176:179], v1 offset:544
		ds_read_b128 v[180:183], v1 offset:576
		ds_read_b128 a[88:91], v1 offset:608
		ds_read_b128 a[92:95], v1 offset:640
		ds_read_b128 a[96:99], v1 offset:672
		ds_read_b128 a[100:103], v1 offset:704
		ds_read_b128 a[104:107], v1 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_add3_u32 v0, s1, v0, v7
		v_add3_u32 v0, v0, v34, v35
		ds_read_b64_tr_b16 a[108:109], v0 offset:33264
		ds_read_b64_tr_b16 a[110:111], v0 offset:37616
		ds_read_b64_tr_b16 a[112:113], v0 offset:33520
		ds_read_b64_tr_b16 a[114:115], v0 offset:37872
		ds_read_b64_tr_b16 a[116:117], v0 offset:33776
		ds_read_b64_tr_b16 a[118:119], v0 offset:38128
		ds_read_b64_tr_b16 a[120:121], v0 offset:34032
		ds_read_b64_tr_b16 a[122:123], v0 offset:38384
		ds_read_b64_tr_b16 a[124:125], v0 offset:33328
		ds_read_b64_tr_b16 a[126:127], v0 offset:37680
		ds_read_b64_tr_b16 a[128:129], v0 offset:33584
		ds_read_b64_tr_b16 a[130:131], v0 offset:37936
		ds_read_b64_tr_b16 a[132:133], v0 offset:33840
		ds_read_b64_tr_b16 a[134:135], v0 offset:38192
		ds_read_b64_tr_b16 a[136:137], v0 offset:34096
		ds_read_b64_tr_b16 a[138:139], v0 offset:38448
		ds_read_b64_tr_b16 a[140:141], v0 offset:33392
		ds_read_b64_tr_b16 a[142:143], v0 offset:37744
		ds_read_b64_tr_b16 a[144:145], v0 offset:33648
		ds_read_b64_tr_b16 a[146:147], v0 offset:38000
		ds_read_b64_tr_b16 a[148:149], v0 offset:33904
		ds_read_b64_tr_b16 a[150:151], v0 offset:38256
		ds_read_b64_tr_b16 a[152:153], v0 offset:34160
		ds_read_b64_tr_b16 a[154:155], v0 offset:38512
		ds_read_b64_tr_b16 a[156:157], v0 offset:33456
		ds_read_b64_tr_b16 a[158:159], v0 offset:37808
		ds_read_b64_tr_b16 a[160:161], v0 offset:33712
		ds_read_b64_tr_b16 a[162:163], v0 offset:38064
		ds_read_b64_tr_b16 a[164:165], v0 offset:33968
		ds_read_b64_tr_b16 a[166:167], v0 offset:38320
		ds_read_b64_tr_b16 a[168:169], v0 offset:34224
		ds_read_b64_tr_b16 a[170:171], v0 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[12:15], a[4:7], 0
		v_accvgpr_read_b32 v0, a1
		v_mov_b32_e32 v1, 4
		v_mul_lo_u32 v1, v1, v0
		v_add_u32_e32 v0, s2, v1
		v_xad_u32 v5, 1, v1, s2
		v_xad_u32 v7, 2, v1, s2
		v_xad_u32 v11, 3, v1, s2
		v_xad_u32 v18, 8, v1, s2
		v_mfma_f32_32x32x16_bf16 v[208:223], v[44:47], a[4:7], 0
		v_xad_u32 v19, 9, v1, s2
		v_xad_u32 v24, 10, v1, s2
		v_xad_u32 v25, 11, v1, s2
		v_xad_u32 v27, 16, v1, s2
		v_xad_u32 v30, 17, v1, s2
		v_xad_u32 v31, 18, v1, s2
		v_xad_u32 v32, 19, v1, s2
		v_mfma_f32_32x32x16_bf16 v[224:239], v[44:47], a[36:39], 0
		v_xad_u32 v33, 24, v1, s2
		v_xad_u32 v34, 25, v1, s2
		v_xad_u32 v35, 26, v1, s2
		v_xad_u32 v38, 27, v1, s2
		v_xad_u32 v39, 32, v1, s2
		v_xad_u32 v44, 33, v1, s2
		v_xad_u32 v45, 34, v1, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], v[12:15], a[36:39], 0
		v_xad_u32 v12, 35, v1, s2
		v_xad_u32 v13, 40, v1, s2
		v_xad_u32 v14, 41, v1, s2
		v_xad_u32 v15, 42, v1, s2
		v_xad_u32 v46, 43, v1, s2
		v_xad_u32 v47, 48, v1, s2
		v_xad_u32 v184, 49, v1, s2
		v_mfma_f32_32x32x16_bf16 v[192:207], v[20:23], a[8:11], v[192:207]
		v_xad_u32 v185, 50, v1, s2
		v_xad_u32 v186, 51, v1, s2
		v_xad_u32 v187, 56, v1, s2
		v_xad_u32 v188, 57, v1, s2
		v_xad_u32 v189, 58, v1, s2
		v_xad_u32 v1, 59, v1, s2
		v_cmp_lt_i32_e64 vcc, v0, s25
		s_mov_b64 s[2:3], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[8:11], v[208:223]
		v_cmp_lt_i32_e64 vcc, v5, s25
		s_mov_b64 s[8:9], vcc
		v_cmp_lt_i32_e64 vcc, v7, s25
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v11, s25
		s_mov_b64 s[12:13], vcc
		v_cmp_lt_i32_e64 vcc, v18, s25
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v19, s25
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v24, s25
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v25, s25
		s_mov_b64 s[32:33], vcc
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[40:43], v[224:239]
		v_cmp_lt_i32_e64 vcc, v27, s25
		s_mov_b64 s[34:35], vcc
		v_cmp_lt_i32_e64 vcc, v30, s25
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v31, s25
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v32, s25
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v33, s25
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v34, s25
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v35, s25
		s_mov_b64 s[46:47], vcc
		v_mfma_f32_32x32x16_bf16 v[240:255], v[20:23], a[40:43], v[240:255]
		v_cmp_lt_i32_e64 vcc, v38, s25
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v39, s25
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v44, s25
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v45, s25
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v12, s25
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v13, s25
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v14, s25
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[12:15], v[192:207]
		v_cmp_lt_i32_e64 vcc, v15, s25
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v46, s25
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v47, s25
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v184, s25
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v185, s25
		s_mov_b64 s[70:71], vcc
		v_cmp_lt_i32_e64 vcc, v186, s25
		s_mov_b64 s[72:73], vcc
		v_cmp_lt_i32_e64 vcc, v187, s25
		s_mov_b64 s[74:75], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[12:15], v[208:223]
		v_cmp_lt_i32_e64 vcc, v188, s25
		s_mov_b64 s[76:77], vcc
		v_cmp_lt_i32_e64 vcc, v189, s25
		s_mov_b64 s[78:79], vcc
		v_cmp_lt_i32_e64 vcc, v1, s25
		v_mov_b32_e32 v0, 0xff800000
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[16:19], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[20:23], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[60:63], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[32:35], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[32:35], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[64:67], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[84:87], a[64:67], v[240:255]
		v_accvgpr_read_b32 v1, a1
		v_mov_b32_e32 v5, 8
		v_mul_lo_u32 v5, v5, v1
		v_xor_b32_e32 v1, 16, v5
		v_xor_b32_e32 v7, 32, v5
		v_xor_b32_e32 v11, 48, v5
		v_xor_b32_e32 v12, 64, v5
		v_xor_b32_e32 v13, 0x50, v5
		v_xor_b32_e32 v14, 0x60, v5
		v_xor_b32_e32 v15, 0x70, v5
		v_cndmask_b32_e64 v18, v0, v192, s[2:3]
		v_cndmask_b32_e64 v19, v0, v193, s[8:9]
		v_cndmask_b32_e64 v20, v0, v194, s[10:11]
		v_cndmask_b32_e64 v21, v0, v195, s[12:13]
		v_cndmask_b32_e64 v22, v0, v196, s[14:15]
		v_cndmask_b32_e64 v23, v0, v197, s[18:19]
		v_cndmask_b32_e64 v24, v0, v198, s[30:31]
		v_cndmask_b32_e64 v25, v0, v199, s[32:33]
		v_cndmask_b32_e64 v30, v0, v200, s[34:35]
		v_cndmask_b32_e64 v31, v0, v201, s[36:37]
		v_cndmask_b32_e64 v32, v0, v202, s[38:39]
		v_cndmask_b32_e64 v33, v0, v203, s[40:41]
		v_cndmask_b32_e64 v34, v0, v204, s[42:43]
		v_cndmask_b32_e64 v35, v0, v205, s[44:45]
		v_cndmask_b32_e64 v38, v0, v206, s[46:47]
		v_cndmask_b32_e64 v39, v0, v207, s[48:49]
		v_cndmask_b32_e64 v40, v0, v208, s[50:51]
		v_cndmask_b32_e64 v41, v0, v209, s[52:53]
		v_cndmask_b32_e64 v42, v0, v210, s[54:55]
		v_cndmask_b32_e64 v43, v0, v211, s[56:57]
		v_cndmask_b32_e64 v44, v0, v212, s[58:59]
		v_cndmask_b32_e64 v45, v0, v213, s[60:61]
		v_cndmask_b32_e64 v46, v0, v214, s[62:63]
		v_cndmask_b32_e64 v47, v0, v215, s[64:65]
		v_cndmask_b32_e64 v176, v0, v216, s[66:67]
		v_cndmask_b32_e64 v177, v0, v217, s[68:69]
		v_cndmask_b32_e64 v178, v0, v218, s[70:71]
		v_cndmask_b32_e64 v179, v0, v219, s[72:73]
		v_cndmask_b32_e64 v180, v0, v220, s[74:75]
		v_cndmask_b32_e64 v181, v0, v221, s[76:77]
		v_cndmask_b32_e64 v182, v0, v222, s[78:79]
		v_cndmask_b32_e32 v183, v0, v223, vcc
		v_cndmask_b32_e64 v184, v0, v240, s[2:3]
		v_cndmask_b32_e64 v185, v0, v241, s[8:9]
		v_cndmask_b32_e64 v186, v0, v242, s[10:11]
		v_cndmask_b32_e64 v187, v0, v243, s[12:13]
		v_cndmask_b32_e64 v188, v0, v244, s[14:15]
		v_cndmask_b32_e64 v189, v0, v245, s[18:19]
		v_cndmask_b32_e64 v190, v0, v246, s[30:31]
		v_cndmask_b32_e64 v191, v0, v247, s[32:33]
		v_cndmask_b32_e64 v192, v0, v248, s[34:35]
		v_cndmask_b32_e64 v193, v0, v249, s[36:37]
		v_cndmask_b32_e64 v194, v0, v250, s[38:39]
		v_cndmask_b32_e64 v195, v0, v251, s[40:41]
		v_cndmask_b32_e64 v196, v0, v252, s[42:43]
		v_cndmask_b32_e64 v197, v0, v253, s[44:45]
		v_cndmask_b32_e64 v198, v0, v254, s[46:47]
		v_cndmask_b32_e64 v199, v0, v255, s[48:49]
		v_cndmask_b32_e64 v200, v0, v224, s[50:51]
		v_cndmask_b32_e64 v201, v0, v225, s[52:53]
		v_cndmask_b32_e64 v202, v0, v226, s[54:55]
		v_cndmask_b32_e64 v203, v0, v227, s[56:57]
		v_cndmask_b32_e64 v204, v0, v228, s[58:59]
		v_cndmask_b32_e64 v205, v0, v229, s[60:61]
		v_cndmask_b32_e64 v206, v0, v230, s[62:63]
		v_cndmask_b32_e64 v207, v0, v231, s[64:65]
		v_cndmask_b32_e64 v208, v0, v232, s[66:67]
		v_cndmask_b32_e64 v209, v0, v233, s[68:69]
		v_cndmask_b32_e64 v210, v0, v234, s[70:71]
		v_cndmask_b32_e64 v211, v0, v235, s[72:73]
		v_cndmask_b32_e64 v212, v0, v236, s[74:75]
		v_cndmask_b32_e64 v213, v0, v237, s[76:77]
		v_cndmask_b32_e64 v214, v0, v238, s[78:79]
		v_cndmask_b32_e32 v215, v0, v239, vcc
		v_max_f32_e32 v0, v18, v19
		v_max_f32_e32 v27, v20, v21
		v_max_f32_e32 v216, v22, v23
		v_max_f32_e32 v217, v24, v25
		v_max_f32_e32 v218, v30, v31
		v_max_f32_e32 v219, v32, v33
		v_max_f32_e32 v220, v34, v35
		v_max_f32_e32 v221, v38, v39
		v_max_f32_e32 v222, v40, v41
		v_max_f32_e32 v223, v42, v43
		v_max_f32_e32 v224, v44, v45
		v_max_f32_e32 v225, v46, v47
		v_max_f32_e32 v226, v176, v177
		v_max_f32_e32 v227, v178, v179
		v_max_f32_e32 v228, v180, v181
		v_max_f32_e32 v229, v182, v183
		v_max_f32_e32 v0, v0, v27
		v_max_f32_e32 v27, v216, v217
		v_max_f32_e32 v216, v218, v219
		v_max_f32_e32 v217, v220, v221
		v_max_f32_e32 v218, v222, v223
		v_max_f32_e32 v219, v224, v225
		v_max_f32_e32 v220, v226, v227
		v_max_f32_e32 v221, v228, v229
		v_max_f32_e32 v0, v0, v27
		v_max_f32_e32 v27, v216, v217
		v_max_f32_e32 v216, v218, v219
		v_max_f32_e32 v217, v220, v221
		v_max_f32_e32 v0, v0, v27
		v_max_f32_e32 v27, v216, v217
		v_max_f32_e32 v0, v0, v27
		ds_bpermute_b32 v27, v4, v0
		ds_bpermute_b32 v216, v16, v0
		v_max_f32_e32 v0, v184, v185
		v_max_f32_e32 v217, v186, v187
		v_max_f32_e32 v218, v188, v189
		v_max_f32_e32 v219, v190, v191
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v220, v27, v216
		v_max_f32_e32 v27, v192, v193
		v_max_f32_e32 v216, v194, v195
		v_max_f32_e32 v221, v196, v197
		v_max_f32_e32 v222, v198, v199
		v_max_f32_e32 v223, v200, v201
		v_max_f32_e32 v224, v202, v203
		v_max_f32_e32 v225, v204, v205
		v_max_f32_e32 v226, v206, v207
		v_max_f32_e32 v227, v208, v209
		v_max_f32_e32 v228, v210, v211
		v_max_f32_e32 v229, v212, v213
		v_max_f32_e32 v230, v214, v215
		v_max_f32_e32 v0, v0, v217
		v_max_f32_e32 v217, v218, v219
		v_max_f32_e32 v27, v27, v216
		v_max_f32_e32 v216, v221, v222
		v_max_f32_e32 v218, v223, v224
		v_max_f32_e32 v219, v225, v226
		v_max_f32_e32 v221, v227, v228
		v_max_f32_e32 v222, v229, v230
		v_max_f32_e32 v0, v0, v217
		v_max_f32_e32 v27, v27, v216
		v_max_f32_e32 v216, v218, v219
		v_max_f32_e32 v217, v221, v222
		v_max_f32_e32 v0, v0, v27
		v_max_f32_e32 v27, v216, v217
		v_max_f32_e32 v0, v0, v27
		ds_bpermute_b32 v27, v4, v0
		ds_bpermute_b32 v216, v16, v0
		v_pk_mul_f32 v[218:219], v[18:19], v[28:29]
		v_pk_mul_f32 v[18:19], v[20:21], v[28:29]
		v_pk_mul_f32 v[20:21], v[22:23], v[28:29]
		v_pk_mul_f32 v[22:23], v[24:25], v[28:29]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v221, v27, v216
		v_pk_mul_f32 v[24:25], v[220:221], v[28:29]
		v_max_f32_e32 v0, v17, v24
		v_max_f32_e32 v24, v26, v25
		v_pk_mul_f32 v[216:217], v[30:31], v[28:29]
		v_pk_mul_f32 v[30:31], v[32:33], v[28:29]
		v_pk_mul_f32 v[32:33], v[34:35], v[28:29]
		v_pk_mul_f32 v[34:35], v[38:39], v[28:29]
		v_pk_mul_f32 v[38:39], v[40:41], v[28:29]
		v_pk_mul_f32 v[40:41], v[42:43], v[28:29]
		v_pk_mul_f32 v[42:43], v[44:45], v[28:29]
		v_pk_mul_f32 v[44:45], v[46:47], v[28:29]
		v_pk_mul_f32 v[46:47], v[176:177], v[28:29]
		v_pk_mul_f32 v[176:177], v[178:179], v[28:29]
		v_pk_mul_f32 v[178:179], v[180:181], v[28:29]
		v_pk_mul_f32 v[180:181], v[182:183], v[28:29]
		v_pk_mul_f32 v[182:183], v[184:185], v[28:29]
		v_pk_mul_f32 v[184:185], v[186:187], v[28:29]
		v_pk_mul_f32 v[186:187], v[188:189], v[28:29]
		v_pk_mul_f32 v[188:189], v[190:191], v[28:29]
		v_pk_mul_f32 v[190:191], v[192:193], v[28:29]
		v_pk_mul_f32 v[192:193], v[194:195], v[28:29]
		v_pk_mul_f32 v[194:195], v[196:197], v[28:29]
		v_pk_mul_f32 v[196:197], v[198:199], v[28:29]
		v_pk_mul_f32 v[198:199], v[200:201], v[28:29]
		v_pk_mul_f32 v[200:201], v[202:203], v[28:29]
		v_pk_mul_f32 v[202:203], v[204:205], v[28:29]
		v_pk_mul_f32 v[204:205], v[206:207], v[28:29]
		v_pk_mul_f32 v[206:207], v[208:209], v[28:29]
		v_pk_mul_f32 v[208:209], v[210:211], v[28:29]
		v_pk_mul_f32 v[210:211], v[212:213], v[28:29]
		v_pk_mul_f32 v[212:213], v[214:215], v[28:29]
		v_sub_f32_e32 v25, v218, v0
		v_sub_f32_e32 v27, v219, v0
		v_sub_f32_e32 v18, v18, v0
		v_sub_f32_e32 v19, v19, v0
		v_sub_f32_e32 v20, v20, v0
		v_sub_f32_e32 v21, v21, v0
		v_sub_f32_e32 v22, v22, v0
		v_sub_f32_e32 v23, v23, v0
		v_sub_f32_e32 v28, v216, v0
		v_sub_f32_e32 v29, v217, v0
		v_sub_f32_e32 v30, v30, v0
		v_sub_f32_e32 v31, v31, v0
		v_sub_f32_e32 v32, v32, v0
		v_sub_f32_e32 v33, v33, v0
		v_sub_f32_e32 v34, v34, v0
		v_sub_f32_e32 v35, v35, v0
		v_sub_f32_e32 v38, v38, v0
		v_sub_f32_e32 v39, v39, v0
		v_sub_f32_e32 v40, v40, v0
		v_sub_f32_e32 v41, v41, v0
		v_sub_f32_e32 v42, v42, v0
		v_sub_f32_e32 v43, v43, v0
		v_sub_f32_e32 v44, v44, v0
		v_sub_f32_e32 v45, v45, v0
		v_sub_f32_e32 v46, v46, v0
		v_sub_f32_e32 v47, v47, v0
		v_sub_f32_e32 v176, v176, v0
		v_sub_f32_e32 v177, v177, v0
		v_sub_f32_e32 v178, v178, v0
		v_sub_f32_e32 v179, v179, v0
		v_sub_f32_e32 v180, v180, v0
		v_sub_f32_e32 v181, v181, v0
		v_sub_f32_e32 v182, v182, v24
		v_sub_f32_e32 v183, v183, v24
		v_sub_f32_e32 v184, v184, v24
		v_sub_f32_e32 v185, v185, v24
		v_sub_f32_e32 v186, v186, v24
		v_sub_f32_e32 v187, v187, v24
		v_sub_f32_e32 v188, v188, v24
		v_sub_f32_e32 v189, v189, v24
		v_sub_f32_e32 v190, v190, v24
		v_sub_f32_e32 v191, v191, v24
		v_sub_f32_e32 v192, v192, v24
		v_sub_f32_e32 v193, v193, v24
		v_sub_f32_e32 v194, v194, v24
		v_sub_f32_e32 v195, v195, v24
		v_sub_f32_e32 v196, v196, v24
		v_sub_f32_e32 v197, v197, v24
		v_sub_f32_e32 v198, v198, v24
		v_sub_f32_e32 v199, v199, v24
		v_sub_f32_e32 v200, v200, v24
		v_sub_f32_e32 v201, v201, v24
		v_sub_f32_e32 v202, v202, v24
		v_sub_f32_e32 v203, v203, v24
		v_sub_f32_e32 v204, v204, v24
		v_sub_f32_e32 v205, v205, v24
		v_sub_f32_e32 v206, v206, v24
		v_sub_f32_e32 v207, v207, v24
		v_sub_f32_e32 v208, v208, v24
		v_sub_f32_e32 v209, v209, v24
		v_sub_f32_e32 v210, v210, v24
		v_sub_f32_e32 v211, v211, v24
		v_sub_f32_e32 v212, v212, v24
		v_sub_f32_e32 v213, v213, v24
		v_exp_f32_e32 v214, v25
		v_exp_f32_e32 v216, v27
		v_exp_f32_e32 v215, v18
		v_exp_f32_e32 v217, v19
		v_exp_f32_e32 v18, v20
		v_exp_f32_e32 v218, v21
		v_exp_f32_e32 v19, v22
		v_exp_f32_e32 v219, v23
		v_exp_f32_e32 v20, v28
		v_exp_f32_e32 v22, v29
		v_exp_f32_e32 v21, v30
		v_exp_f32_e32 v23, v31
		v_exp_f32_e32 v28, v32
		v_exp_f32_e32 v30, v33
		v_exp_f32_e32 v29, v34
		v_exp_f32_e32 v31, v35
		v_exp_f32_e32 v32, v38
		v_exp_f32_e32 v34, v39
		v_exp_f32_e32 v33, v40
		v_exp_f32_e32 v35, v41
		v_exp_f32_e32 v38, v42
		v_exp_f32_e32 v40, v43
		v_exp_f32_e32 v39, v44
		v_exp_f32_e32 v41, v45
		v_exp_f32_e32 v42, v46
		v_exp_f32_e32 v44, v47
		v_exp_f32_e32 v43, v176
		v_exp_f32_e32 v45, v177
		v_exp_f32_e32 v46, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v47, v180
		v_exp_f32_e32 v177, v181
		v_exp_f32_e32 v179, v182
		v_exp_f32_e32 v181, v183
		v_exp_f32_e32 v182, v184
		v_exp_f32_e32 v220, v185
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v221, v187
		v_exp_f32_e32 v184, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v185, v190
		v_exp_f32_e32 v187, v191
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v189, v194
		v_exp_f32_e32 v191, v195
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
		v_pk_add_f32 v[212:213], v[214:215], v[216:217]
		v_pk_add_f32 v[222:223], v[18:19], v[218:219]
		v_pk_add_f32 v[224:225], v[20:21], v[22:23]
		v_pk_add_f32 v[226:227], v[28:29], v[30:31]
		v_pk_add_f32 v[228:229], v[32:33], v[34:35]
		v_pk_add_f32 v[230:231], v[38:39], v[40:41]
		v_pk_add_f32 v[232:233], v[42:43], v[44:45]
		v_pk_add_f32 v[234:235], v[46:47], v[176:177]
		v_mov_b32_e32 v236, v213
		v_mov_b32_e32 v237, v223
		v_mov_b32_e32 v238, v212
		v_mov_b32_e32 v239, v222
		v_pk_add_f32 v[212:213], v[238:239], v[236:237]
		v_mov_b32_e32 v222, v225
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v236, v224
		v_mov_b32_e32 v237, v226
		v_pk_add_f32 v[224:225], v[236:237], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v226, v228
		v_mov_b32_e32 v227, v230
		v_pk_add_f32 v[228:229], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v233
		v_mov_b32_e32 v223, v235
		v_mov_b32_e32 v226, v232
		v_mov_b32_e32 v227, v234
		v_pk_add_f32 v[230:231], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v213
		v_mov_b32_e32 v223, v225
		v_mov_b32_e32 v226, v212
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[212:213], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v213
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v212
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[212:213], v[224:225], v[222:223]
		v_add_f32_e32 v25, v212, v213
		ds_bpermute_b32 v178, v4, v25
		ds_bpermute_b32 v180, v16, v25
		v_pk_add_f32 v[212:213], v[182:183], v[220:221]
		v_pk_add_f32 v[222:223], v[184:185], v[186:187]
		v_pk_add_f32 v[224:225], v[188:189], v[190:191]
		v_pk_add_f32 v[226:227], v[192:193], v[194:195]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[228:229], v[178:179], v[180:181]
		v_pk_add_f32 v[230:231], v[196:197], v[198:199]
		v_pk_add_f32 v[232:233], v[200:201], v[202:203]
		v_pk_add_f32 v[234:235], v[204:205], v[206:207]
		v_mov_b32_e32 v209, v229
		v_mov_b32_e32 v211, v212
		v_pk_add_f32 v[236:237], v[208:209], v[210:211]
		v_mov_b32_e32 v238, v213
		v_mov_b32_e32 v239, v224
		v_pk_add_f32 v[212:213], v[238:239], v[222:223]
		v_mov_b32_e32 v222, v225
		v_mov_b32_e32 v223, v230
		v_pk_add_f32 v[222:223], v[222:223], v[226:227]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[226:227], v[224:225], v[232:233]
		v_mov_b32_e32 v224, v235
		v_mov_b32_e32 v225, v212
		v_pk_add_f32 v[224:225], v[224:225], v[236:237]
		v_mov_b32_e32 v230, v213
		v_mov_b32_e32 v231, v226
		v_pk_add_f32 v[212:213], v[230:231], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v212
		v_pk_add_f32 v[226:227], v[222:223], v[224:225]
		v_add_f32_e32 v25, v213, v226
		v_add_f32_e32 v25, v227, v25
		ds_bpermute_b32 v27, v4, v25
		ds_bpermute_b32 v4, v16, v25
		v_sub_f32_e32 v0, v17, v0
		v_sub_f32_e32 v16, v26, v24
		v_exp_f32_e32 v24, v0
		v_exp_f32_e32 v212, v16
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v17, v27, v4
		v_mov_b32_e32 v25, v24
		v_pk_mul_f32 v[240:241], v[48:49], v[24:25]
		v_pk_mul_f32 v[242:243], v[50:51], v[24:25]
		v_pk_mul_f32 v[244:245], v[52:53], v[24:25]
		v_pk_mul_f32 v[246:247], v[54:55], v[24:25]
		v_pk_mul_f32 v[248:249], v[56:57], v[24:25]
		v_pk_mul_f32 v[250:251], v[58:59], v[24:25]
		v_pk_mul_f32 v[252:253], v[60:61], v[24:25]
		v_pk_mul_f32 v[254:255], v[62:63], v[24:25]
		v_pk_mul_f32 v[48:49], v[64:65], v[24:25]
		v_pk_mul_f32 v[50:51], v[66:67], v[24:25]
		v_pk_mul_f32 v[52:53], v[68:69], v[24:25]
		v_pk_mul_f32 v[54:55], v[70:71], v[24:25]
		v_pk_mul_f32 v[56:57], v[72:73], v[24:25]
		v_pk_mul_f32 v[58:59], v[74:75], v[24:25]
		v_pk_mul_f32 v[60:61], v[76:77], v[24:25]
		v_pk_mul_f32 v[62:63], v[78:79], v[24:25]
		v_pk_mul_f32 v[64:65], v[80:81], v[24:25]
		v_pk_mul_f32 v[66:67], v[82:83], v[24:25]
		v_pk_mul_f32 v[68:69], v[84:85], v[24:25]
		v_pk_mul_f32 v[70:71], v[86:87], v[24:25]
		v_pk_mul_f32 v[72:73], v[88:89], v[24:25]
		v_pk_mul_f32 v[74:75], v[90:91], v[24:25]
		v_pk_mul_f32 v[76:77], v[92:93], v[24:25]
		v_pk_mul_f32 v[78:79], v[94:95], v[24:25]
		v_pk_mul_f32 v[80:81], v[96:97], v[24:25]
		v_pk_mul_f32 v[82:83], v[98:99], v[24:25]
		v_pk_mul_f32 v[84:85], v[100:101], v[24:25]
		v_pk_mul_f32 v[86:87], v[102:103], v[24:25]
		v_pk_mul_f32 v[88:89], v[104:105], v[24:25]
		v_pk_mul_f32 v[90:91], v[106:107], v[24:25]
		v_pk_mul_f32 v[92:93], v[108:109], v[24:25]
		v_pk_mul_f32 v[94:95], v[110:111], v[24:25]
		v_mov_b32_e32 v213, v212
		v_pk_mul_f32 v[96:97], v[112:113], v[212:213]
		v_pk_mul_f32 v[98:99], v[114:115], v[212:213]
		v_pk_mul_f32 v[100:101], v[116:117], v[212:213]
		v_pk_mul_f32 v[102:103], v[118:119], v[212:213]
		v_pk_mul_f32 v[104:105], v[120:121], v[212:213]
		v_pk_mul_f32 v[106:107], v[122:123], v[212:213]
		v_pk_mul_f32 v[108:109], v[124:125], v[212:213]
		v_pk_mul_f32 v[110:111], v[126:127], v[212:213]
		v_pk_mul_f32 v[112:113], v[128:129], v[212:213]
		v_pk_mul_f32 v[114:115], v[130:131], v[212:213]
		v_pk_mul_f32 v[116:117], v[132:133], v[212:213]
		v_pk_mul_f32 v[118:119], v[134:135], v[212:213]
		v_pk_mul_f32 v[120:121], v[136:137], v[212:213]
		v_pk_mul_f32 v[122:123], v[138:139], v[212:213]
		v_pk_mul_f32 v[124:125], v[140:141], v[212:213]
		v_pk_mul_f32 v[126:127], v[142:143], v[212:213]
		v_pk_mul_f32 v[128:129], v[144:145], v[212:213]
		v_pk_mul_f32 v[130:131], v[146:147], v[212:213]
		v_pk_mul_f32 v[132:133], v[148:149], v[212:213]
		v_pk_mul_f32 v[134:135], v[150:151], v[212:213]
		v_pk_mul_f32 v[136:137], v[152:153], v[212:213]
		v_pk_mul_f32 v[138:139], v[154:155], v[212:213]
		v_pk_mul_f32 v[140:141], v[156:157], v[212:213]
		v_pk_mul_f32 v[142:143], v[158:159], v[212:213]
		v_pk_mul_f32 v[144:145], v[160:161], v[212:213]
		v_pk_mul_f32 v[146:147], v[162:163], v[212:213]
		v_pk_mul_f32 v[148:149], v[164:165], v[212:213]
		v_pk_mul_f32 v[150:151], v[166:167], v[212:213]
		v_pk_mul_f32 v[152:153], v[168:169], v[212:213]
		v_pk_mul_f32 v[154:155], v[170:171], v[212:213]
		v_pk_mul_f32 v[156:157], v[172:173], v[212:213]
		v_pk_mul_f32 v[158:159], v[174:175], v[212:213]
		v_mov_b32_e32 v16, v228
		v_mov_b32_e32 v26, v24
		v_mov_b32_e32 v27, v212
		v_pk_fma_f32 v[24:25], v[36:37], v[26:27], v[16:17]
		v_cvt_pk_bf16_f32 v160, v214, v216
		v_cvt_pk_bf16_f32 v161, v215, v217
		v_cvt_pk_bf16_f32 v162, v18, v218
		v_cvt_pk_bf16_f32 v163, v19, v219
		v_cvt_pk_bf16_f32 v16, v20, v22
		v_cvt_pk_bf16_f32 v17, v21, v23
		v_cvt_pk_bf16_f32 v18, v28, v30
		v_cvt_pk_bf16_f32 v19, v29, v31
		v_cvt_pk_bf16_f32 v20, v32, v34
		v_cvt_pk_bf16_f32 v21, v33, v35
		v_cvt_pk_bf16_f32 v22, v38, v40
		v_cvt_pk_bf16_f32 v23, v39, v41
		v_cvt_pk_bf16_f32 v28, v42, v44
		v_cvt_pk_bf16_f32 v29, v43, v45
		v_cvt_pk_bf16_f32 v30, v46, v176
		v_cvt_pk_bf16_f32 v31, v47, v177
		v_cvt_pk_bf16_f32 v32, v179, v181
		v_cvt_pk_bf16_f32 v33, v182, v220
		v_cvt_pk_bf16_f32 v34, v183, v221
		v_cvt_pk_bf16_f32 v35, v184, v186
		v_cvt_pk_bf16_f32 v36, v185, v187
		v_cvt_pk_bf16_f32 v37, v188, v190
		v_cvt_pk_bf16_f32 v38, v189, v191
		v_cvt_pk_bf16_f32 v39, v192, v194
		v_cvt_pk_bf16_f32 v40, v193, v195
		v_cvt_pk_bf16_f32 v41, v196, v198
		v_cvt_pk_bf16_f32 v42, v197, v199
		v_cvt_pk_bf16_f32 v43, v200, v202
		v_cvt_pk_bf16_f32 v44, v201, v203
		v_cvt_pk_bf16_f32 v45, v204, v206
		v_cvt_pk_bf16_f32 v46, v205, v207
		v_cvt_pk_bf16_f32 v47, v208, v210
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[240:255], a[108:111], v[160:163], v[240:255]
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[160:163], v[48:63]
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_rcp_f32_e32 v26, v24
		v_rcp_f32_e32 v164, v25
		s_mov_b32 s1, 0x80
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[160:163], v[64:79]
		v_cmp_lt_i32_e64 vcc, v5, s1
		s_mov_b64 s[2:3], vcc
		s_and_b32 s8, s26, s2
		s_and_b32 s9, s27, s3
		v_cmp_lt_i32_e64 vcc, v1, s1
		s_mov_b64 s[10:11], vcc
		s_and_b32 s12, s26, s10
		s_and_b32 s13, s27, s11
		v_cmp_lt_i32_e64 vcc, v7, s1
		s_mov_b64 s[14:15], vcc
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[160:163], v[80:95]
		s_and_b32 s18, s26, s14
		s_and_b32 s19, s27, s15
		v_cmp_lt_i32_e64 vcc, v11, s1
		s_mov_b64 s[24:25], vcc
		s_and_b32 s30, s26, s24
		s_and_b32 s31, s27, s25
		v_cmp_lt_i32_e64 vcc, v12, s1
		s_mov_b64 s[32:33], vcc
		s_and_b32 s34, s26, s32
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[32:35], v[144:159]
		s_and_b32 s35, s27, s33
		v_cmp_lt_i32_e64 vcc, v13, s1
		s_mov_b64 s[36:37], vcc
		s_and_b32 s38, s26, s36
		s_and_b32 s39, s27, s37
		v_cmp_lt_i32_e64 vcc, v14, s1
		s_mov_b64 s[40:41], vcc
		s_and_b32 s42, s26, s40
		s_and_b32 s43, s27, s41
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[32:35], v[96:111]
		v_cmp_lt_i32_e64 vcc, v15, s1
		s_mov_b64 s[44:45], vcc
		s_and_b32 s46, s26, s44
		s_and_b32 s47, s27, s45
		s_and_b32 s26, s28, s2
		s_and_b32 s27, s29, s3
		s_and_b32 s2, s28, s10
		s_and_b32 s3, s29, s11
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[32:35], v[112:127]
		s_and_b32 s10, s28, s14
		s_and_b32 s11, s29, s15
		s_and_b32 s14, s28, s24
		s_and_b32 s15, s29, s25
		s_and_b32 s24, s28, s32
		s_and_b32 s25, s29, s33
		s_and_b32 s32, s28, s36
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[32:35], v[128:143]
		s_and_b32 s33, s29, s37
		s_and_b32 s36, s28, s40
		s_and_b32 s37, s29, s41
		s_and_b32 s40, s28, s44
		s_and_b32 s41, s29, s45
		s_mul_i32 s1, s16, s23
		s_lshl_b32 s1, s1, 9
		v_mfma_f32_32x32x16_bf16 v[240:255], a[112:115], v[16:19], v[240:255]
		s_mul_i32 s16, s17, s21
		s_lshl_b32 s16, s16, 1
		s_add_i32 s17, s1, s16
		s_mul_i32 s0, s0, s22
		s_lshl_b32 s0, s0, 1
		s_add_i32 s17, s17, s0
		v_accvgpr_read_b32 v0, a0
		v_mul_lo_u32 v0, s23, v0
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[16:19], v[48:63]
		v_lshl_add_u32 v1, v0, 7, s17
		v_mul_lo_u32 v4, s23, v9
		v_lshl_add_u32 v1, v4, 1, v1
		v_accvgpr_read_b32 v5, a2
		v_mul_lo_u32 v5, s23, v5
		v_lshl_add_u32 v1, v5, 6, v1
		v_mul_lo_u32 v6, s23, v6
		v_lshl_add_u32 v1, v6, 5, v1
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[16:19], v[64:79]
		v_mul_lo_u32 v7, s23, v8
		v_lshl_add_u32 v1, v7, 4, v1
		v_mul_lo_u32 v11, s23, v10
		v_lshl_add_u32 v1, v11, 3, v1
		v_mul_lo_u32 v12, s23, v3
		v_lshl_add_u32 v1, v12, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], v[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[112:115], v[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], v[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], v[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[116:119], v[20:23], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[20:23], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[20:23], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[20:23], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], v[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[116:119], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], v[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], v[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[120:123], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], v[44:47], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[120:123], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], v[44:47], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], v[44:47], v[128:143]
		v_mov_b32_e32 v27, v26
		s_nop 3
		v_pk_mul_f32 v[14:15], v[240:241], v[26:27]
		v_pk_mul_f32 v[16:17], v[242:243], v[26:27]
		v_pk_mul_f32 v[18:19], v[244:245], v[26:27]
		v_pk_mul_f32 v[20:21], v[246:247], v[26:27]
		v_pk_mul_f32 v[22:23], v[248:249], v[26:27]
		v_pk_mul_f32 v[24:25], v[250:251], v[26:27]
		v_pk_mul_f32 v[28:29], v[252:253], v[26:27]
		v_pk_mul_f32 v[30:31], v[254:255], v[26:27]
		v_pk_mul_f32 v[32:33], v[48:49], v[26:27]
		v_pk_mul_f32 v[34:35], v[50:51], v[26:27]
		v_pk_mul_f32 v[36:37], v[52:53], v[26:27]
		v_pk_mul_f32 v[38:39], v[54:55], v[26:27]
		v_pk_mul_f32 v[40:41], v[56:57], v[26:27]
		v_pk_mul_f32 v[42:43], v[58:59], v[26:27]
		v_pk_mul_f32 v[44:45], v[60:61], v[26:27]
		v_pk_mul_f32 v[46:47], v[62:63], v[26:27]
		v_pk_mul_f32 v[48:49], v[64:65], v[26:27]
		v_pk_mul_f32 v[50:51], v[66:67], v[26:27]
		v_pk_mul_f32 v[52:53], v[68:69], v[26:27]
		v_pk_mul_f32 v[54:55], v[70:71], v[26:27]
		v_pk_mul_f32 v[56:57], v[72:73], v[26:27]
		v_pk_mul_f32 v[58:59], v[74:75], v[26:27]
		v_pk_mul_f32 v[60:61], v[76:77], v[26:27]
		v_pk_mul_f32 v[62:63], v[78:79], v[26:27]
		v_pk_mul_f32 v[64:65], v[80:81], v[26:27]
		v_pk_mul_f32 v[66:67], v[82:83], v[26:27]
		v_pk_mul_f32 v[68:69], v[84:85], v[26:27]
		v_pk_mul_f32 v[70:71], v[86:87], v[26:27]
		v_pk_mul_f32 v[72:73], v[88:89], v[26:27]
		v_pk_mul_f32 v[74:75], v[90:91], v[26:27]
		v_pk_mul_f32 v[76:77], v[92:93], v[26:27]
		v_pk_mul_f32 v[78:79], v[94:95], v[26:27]
		v_mov_b32_e32 v165, v164
		v_pk_mul_f32 v[26:27], v[96:97], v[164:165]
		v_pk_mul_f32 v[80:81], v[98:99], v[164:165]
		v_pk_mul_f32 v[82:83], v[100:101], v[164:165]
		v_pk_mul_f32 v[84:85], v[102:103], v[164:165]
		v_pk_mul_f32 v[86:87], v[104:105], v[164:165]
		v_pk_mul_f32 v[88:89], v[106:107], v[164:165]
		v_pk_mul_f32 v[90:91], v[108:109], v[164:165]
		v_pk_mul_f32 v[92:93], v[110:111], v[164:165]
		v_pk_mul_f32 v[94:95], v[112:113], v[164:165]
		v_pk_mul_f32 v[96:97], v[114:115], v[164:165]
		v_pk_mul_f32 v[98:99], v[116:117], v[164:165]
		v_pk_mul_f32 v[100:101], v[118:119], v[164:165]
		v_pk_mul_f32 v[102:103], v[120:121], v[164:165]
		v_pk_mul_f32 v[104:105], v[122:123], v[164:165]
		v_pk_mul_f32 v[106:107], v[124:125], v[164:165]
		v_pk_mul_f32 v[108:109], v[126:127], v[164:165]
		v_pk_mul_f32 v[110:111], v[128:129], v[164:165]
		v_pk_mul_f32 v[112:113], v[130:131], v[164:165]
		v_pk_mul_f32 v[114:115], v[132:133], v[164:165]
		v_pk_mul_f32 v[116:117], v[134:135], v[164:165]
		v_pk_mul_f32 v[118:119], v[136:137], v[164:165]
		v_pk_mul_f32 v[120:121], v[138:139], v[164:165]
		v_pk_mul_f32 v[122:123], v[140:141], v[164:165]
		v_pk_mul_f32 v[124:125], v[142:143], v[164:165]
		v_pk_mul_f32 v[126:127], v[144:145], v[164:165]
		v_pk_mul_f32 v[128:129], v[146:147], v[164:165]
		v_pk_mul_f32 v[130:131], v[148:149], v[164:165]
		v_pk_mul_f32 v[132:133], v[150:151], v[164:165]
		v_pk_mul_f32 v[134:135], v[152:153], v[164:165]
		v_pk_mul_f32 v[136:137], v[154:155], v[164:165]
		v_pk_mul_f32 v[138:139], v[156:157], v[164:165]
		v_pk_mul_f32 v[140:141], v[158:159], v[164:165]
		v_cvt_pk_bf16_f32 v144, v14, v15
		v_cvt_pk_bf16_f32 v145, v16, v17
		v_cvt_pk_bf16_f32 v146, v18, v19
		v_cvt_pk_bf16_f32 v147, v20, v21
		v_cvt_pk_bf16_f32 v16, v22, v23
		v_cvt_pk_bf16_f32 v17, v24, v25
		v_cvt_pk_bf16_f32 v18, v28, v29
		v_cvt_pk_bf16_f32 v19, v30, v31
		v_cvt_pk_bf16_f32 v20, v32, v33
		v_cvt_pk_bf16_f32 v21, v34, v35
		v_cvt_pk_bf16_f32 v22, v36, v37
		v_cvt_pk_bf16_f32 v23, v38, v39
		v_cvt_pk_bf16_f32 v28, v40, v41
		v_cvt_pk_bf16_f32 v29, v42, v43
		v_cvt_pk_bf16_f32 v30, v44, v45
		v_cvt_pk_bf16_f32 v31, v46, v47
		v_cvt_pk_bf16_f32 v32, v48, v49
		v_cvt_pk_bf16_f32 v33, v50, v51
		v_cvt_pk_bf16_f32 v34, v52, v53
		v_cvt_pk_bf16_f32 v35, v54, v55
		v_cvt_pk_bf16_f32 v36, v56, v57
		v_cvt_pk_bf16_f32 v37, v58, v59
		v_cvt_pk_bf16_f32 v38, v60, v61
		v_cvt_pk_bf16_f32 v39, v62, v63
		v_cvt_pk_bf16_f32 v40, v64, v65
		v_cvt_pk_bf16_f32 v41, v66, v67
		v_cvt_pk_bf16_f32 v42, v68, v69
		v_cvt_pk_bf16_f32 v43, v70, v71
		v_cvt_pk_bf16_f32 v44, v72, v73
		v_cvt_pk_bf16_f32 v45, v74, v75
		v_cvt_pk_bf16_f32 v46, v76, v77
		v_cvt_pk_bf16_f32 v47, v78, v79
		v_cvt_pk_bf16_f32 v48, v26, v27
		v_cvt_pk_bf16_f32 v49, v80, v81
		v_cvt_pk_bf16_f32 v50, v82, v83
		v_cvt_pk_bf16_f32 v51, v84, v85
		v_cvt_pk_bf16_f32 v24, v86, v87
		v_cvt_pk_bf16_f32 v25, v88, v89
		v_cvt_pk_bf16_f32 v26, v90, v91
		v_cvt_pk_bf16_f32 v27, v92, v93
		v_cvt_pk_bf16_f32 v52, v94, v95
		v_cvt_pk_bf16_f32 v53, v96, v97
		v_cvt_pk_bf16_f32 v54, v98, v99
		v_cvt_pk_bf16_f32 v55, v100, v101
		v_cvt_pk_bf16_f32 v56, v102, v103
		v_cvt_pk_bf16_f32 v57, v104, v105
		v_cvt_pk_bf16_f32 v58, v106, v107
		v_cvt_pk_bf16_f32 v59, v108, v109
		v_cvt_pk_bf16_f32 v60, v110, v111
		v_cvt_pk_bf16_f32 v61, v112, v113
		v_cvt_pk_bf16_f32 v62, v114, v115
		v_cvt_pk_bf16_f32 v63, v116, v117
		v_cvt_pk_bf16_f32 v64, v118, v119
		v_cvt_pk_bf16_f32 v65, v120, v121
		v_cvt_pk_bf16_f32 v66, v122, v123
		v_cvt_pk_bf16_f32 v67, v124, v125
		v_cvt_pk_bf16_f32 v68, v126, v127
		v_cvt_pk_bf16_f32 v69, v128, v129
		v_cvt_pk_bf16_f32 v70, v130, v131
		v_cvt_pk_bf16_f32 v71, v132, v133
		v_cvt_pk_bf16_f32 v72, v134, v135
		v_cvt_pk_bf16_f32 v73, v136, v137
		v_cvt_pk_bf16_f32 v74, v138, v139
		v_cvt_pk_bf16_f32 v75, v140, v141
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v56, v58
		v_permlane32_swap_b32_e32 v57, v59
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		v_permlane32_swap_b32_e32 v64, v66
		v_permlane32_swap_b32_e32 v65, v67
		v_permlane32_swap_b32_e32 v68, v70
		v_permlane32_swap_b32_e32 v69, v71
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		s_and_saveexec_b64 s[82:83], s[8:9]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_16
		buffer_store_dwordx4 v[144:147], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_16:
		s_andn2_b64 exec, s[82:83], s[8:9]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_16
.L_attn_fwd_async_prefetch.exec_endif_16:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s8, s1, 32
		s_add_i32 s8, s8, s16
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 7, s8
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 6, v1
		v_lshl_add_u32 v1, v6, 5, v1
		v_lshl_add_u32 v1, v7, 4, v1
		v_lshl_add_u32 v1, v11, 3, v1
		v_lshl_add_u32 v1, v12, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_17
		buffer_store_dwordx4 v[16:19], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_17:
		s_andn2_b64 exec, s[82:83], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_17
.L_attn_fwd_async_prefetch.exec_endif_17:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s9, s1, 64
		s_add_i32 s9, s9, s16
		s_add_i32 s9, s9, s0
		v_lshl_add_u32 v1, v0, 7, s9
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 6, v1
		v_lshl_add_u32 v1, v6, 5, v1
		v_lshl_add_u32 v1, v7, 4, v1
		v_lshl_add_u32 v1, v11, 3, v1
		v_lshl_add_u32 v1, v12, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[18:19]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_18
		buffer_store_dwordx4 v[20:23], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_18:
		s_andn2_b64 exec, s[82:83], s[18:19]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_18
.L_attn_fwd_async_prefetch.exec_endif_18:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s12, s1, 0x60
		s_add_i32 s12, s12, s16
		s_add_i32 s12, s12, s0
		v_lshl_add_u32 v1, v0, 7, s12
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 6, v1
		v_lshl_add_u32 v1, v6, 5, v1
		v_lshl_add_u32 v1, v7, 4, v1
		v_lshl_add_u32 v1, v11, 3, v1
		v_lshl_add_u32 v1, v12, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_19
		buffer_store_dwordx4 v[28:31], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_19:
		s_andn2_b64 exec, s[82:83], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_19
.L_attn_fwd_async_prefetch.exec_endif_19:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s13, s1, 0x80
		s_add_i32 s13, s13, s16
		s_add_i32 s13, s13, s0
		v_lshl_add_u32 v1, v0, 7, s13
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 6, v1
		v_lshl_add_u32 v1, v6, 5, v1
		v_lshl_add_u32 v1, v7, 4, v1
		v_lshl_add_u32 v1, v11, 3, v1
		v_lshl_add_u32 v1, v12, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_20
		buffer_store_dwordx4 v[32:35], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_20:
		s_andn2_b64 exec, s[82:83], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_20
.L_attn_fwd_async_prefetch.exec_endif_20:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s18, s1, 0xa0
		s_add_i32 s18, s18, s16
		s_add_i32 s18, s18, s0
		v_lshl_add_u32 v1, v0, 7, s18
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 6, v1
		v_lshl_add_u32 v1, v6, 5, v1
		v_lshl_add_u32 v1, v7, 4, v1
		v_lshl_add_u32 v1, v11, 3, v1
		v_lshl_add_u32 v1, v12, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_21
		buffer_store_dwordx4 v[36:39], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_21:
		s_andn2_b64 exec, s[82:83], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_21
.L_attn_fwd_async_prefetch.exec_endif_21:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s19, s1, 0xc0
		s_add_i32 s19, s19, s16
		s_add_i32 s19, s19, s0
		v_lshl_add_u32 v1, v0, 7, s19
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 6, v1
		v_lshl_add_u32 v1, v6, 5, v1
		v_lshl_add_u32 v1, v7, 4, v1
		v_lshl_add_u32 v1, v11, 3, v1
		v_lshl_add_u32 v1, v12, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_22
		buffer_store_dwordx4 v[40:43], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_22:
		s_andn2_b64 exec, s[82:83], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_22
.L_attn_fwd_async_prefetch.exec_endif_22:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s1, s1, 0xe0
		s_add_i32 s1, s1, s16
		s_add_i32 s0, s1, s0
		v_lshl_add_u32 v0, v0, 7, s0
		v_lshl_add_u32 v0, v4, 1, v0
		v_lshl_add_u32 v0, v5, 6, v0
		v_lshl_add_u32 v0, v6, 5, v0
		v_lshl_add_u32 v0, v7, 4, v0
		v_lshl_add_u32 v0, v11, 3, v0
		v_lshl_add_u32 v0, v12, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[82:83], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_23
		buffer_store_dwordx4 v[44:47], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_23:
		s_andn2_b64 exec, s[82:83], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_23
.L_attn_fwd_async_prefetch.exec_endif_23:
		s_mov_b64 exec, s[82:83]
		v_accvgpr_read_b32 v0, a0
		v_lshlrev_b32_e32 v0, 6, v0
		v_accvgpr_read_b32 v1, a2
		v_lshlrev_b32_e32 v1, 5, v1
		v_lshlrev_b32_e32 v4, 3, v8
		v_lshlrev_b32_e32 v5, 2, v10
		v_add_u32_e32 v6, 0x80, v9
		v_lshlrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v3, v5, v6, v3 bitop3:0x96
		v_accvgpr_read_b32 v5, a3
		v_bitop3_b32 v3, v5, v4, v3 bitop3:0x96
		v_bitop3_b32 v0, v0, v1, v3 bitop3:0x96
		v_mul_lo_u32 v0, s23, v0
		v_lshl_add_u32 v1, v0, 1, s17
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_24
		buffer_store_dwordx4 v[48:51], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_24:
		s_andn2_b64 exec, s[82:83], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_24
.L_attn_fwd_async_prefetch.exec_endif_24:
		s_mov_b64 exec, s[82:83]
		v_lshl_add_u32 v1, v0, 1, s8
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_25
		buffer_store_dwordx4 v[24:27], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_25:
		s_andn2_b64 exec, s[82:83], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_25
.L_attn_fwd_async_prefetch.exec_endif_25:
		s_mov_b64 exec, s[82:83]
		v_lshl_add_u32 v1, v0, 1, s9
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_26
		buffer_store_dwordx4 v[52:55], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_26:
		s_andn2_b64 exec, s[82:83], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_26
.L_attn_fwd_async_prefetch.exec_endif_26:
		s_mov_b64 exec, s[82:83]
		v_lshl_add_u32 v1, v0, 1, s12
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[14:15]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_27
		buffer_store_dwordx4 v[56:59], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_27:
		s_andn2_b64 exec, s[82:83], s[14:15]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_27
.L_attn_fwd_async_prefetch.exec_endif_27:
		s_mov_b64 exec, s[82:83]
		v_lshl_add_u32 v1, v0, 1, s13
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[24:25]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_28
		buffer_store_dwordx4 v[60:63], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_28:
		s_andn2_b64 exec, s[82:83], s[24:25]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_28
.L_attn_fwd_async_prefetch.exec_endif_28:
		s_mov_b64 exec, s[82:83]
		v_lshl_add_u32 v1, v0, 1, s18
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_29
		buffer_store_dwordx4 v[64:67], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_29:
		s_andn2_b64 exec, s[82:83], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_29
.L_attn_fwd_async_prefetch.exec_endif_29:
		s_mov_b64 exec, s[82:83]
		v_lshl_add_u32 v1, v0, 1, s19
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_30
		buffer_store_dwordx4 v[68:71], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_30:
		s_andn2_b64 exec, s[82:83], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_30
.L_attn_fwd_async_prefetch.exec_endif_30:
		s_mov_b64 exec, s[82:83]
		v_lshl_add_u32 v0, v0, 1, s0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[82:83], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_31
		buffer_store_dwordx4 v[72:75], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_31:
		s_andn2_b64 exec, s[82:83], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_31
.L_attn_fwd_async_prefetch.exec_endif_31:
		s_mov_b64 exec, s[82:83]
		s_endpgm
	.size	_attn_fwd_async_prefetch, .-_attn_fwd_async_prefetch
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _attn_fwd_async_prefetch
		.amdhsa_group_segment_fixed_size 100784
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 96
		.amdhsa_user_sgpr_count 16
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 14
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 440
		.amdhsa_next_free_sgpr 84
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
	.set .L_attn_fwd_async_prefetch.num_vgpr, 256
	.set .L_attn_fwd_async_prefetch.num_agpr, 184
	.set .L_attn_fwd_async_prefetch.numbered_sgpr, 84
	.set .L_attn_fwd_async_prefetch.num_named_barrier, 0
	.set .L_attn_fwd_async_prefetch.private_seg_size, 0
	.set .L_attn_fwd_async_prefetch.uses_vcc, 1
	.set .L_attn_fwd_async_prefetch.uses_flat_scratch, 0
	.set .L_attn_fwd_async_prefetch.has_dyn_sized_stack, 0
	.set .L_attn_fwd_async_prefetch.has_recursion, 0
	.set .L_attn_fwd_async_prefetch.has_indirect_call, 0
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
    .group_segment_fixed_size: 100784
    .kernarg_segment_align: 8
    .kernarg_segment_size: 96
    .max_flat_workgroup_size: 256
    .name:           _attn_fwd_async_prefetch
    .private_segment_fixed_size: 0
    .sgpr_count:     84
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_async_prefetch.kd
    .uses_dynamic_stack: false
    .vgpr_count:     440
    .agpr_count:     184
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 76
    wave.regalloc.agpr.dwords: 285
    wave.regalloc.remat.dwords: 0
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
