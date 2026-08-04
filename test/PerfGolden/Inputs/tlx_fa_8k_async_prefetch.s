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
		v_and_b32_e32 v1, 0xffff, v1
		v_readfirstlane_b32 s27, v2
		s_xor_b32 s28, s26, -1
		s_add_i32 s28, s28, 1
		s_mul_i32 s29, s28, s27
		s_mul_hi_u32 s29, s27, s29
		s_add_i32 s27, s27, s29
		s_mul_hi_u32 s27, s0, s27
		s_mul_i32 s29, s27, s26
		s_xor_b32 s29, s29, -1
		s_add_i32 s29, s29, 1
		s_add_i32 s0, s0, s29
		s_cmp_ge_u32 s0, s26
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s27, 1
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s27, s30, s27
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s0, s28
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s0, s30, s0
		s_cmp_ge_u32 s0, s26
		s_cselect_b32 s26, 1, 0
		s_add_i32 s29, s27, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s26, s29, s27
		s_cselect_b32 s27, 1, 0
		s_xor_b32 s17, s17, s24
		s_xor_b32 s24, s26, -1
		s_add_i32 s24, s24, 1
		s_cmp_lt_i32 s17, 0
		s_cselect_b32 s17, s24, s26
		s_add_i32 s24, s0, s28
		s_cmp_lg_u32 s27, 0
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
		v_and_b32_e32 v17, 1, v16
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v17
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v2, v7
		v_bitop3_b32 v2, v2, v10, v12 bitop3:0x96
		v_xor_b32_e32 v2, v2, v15
		v_lshrrev_b32_e32 v5, 5, v0
		v_and_b32_e32 v7, 1, v5
		v_mov_b32_e32 v10, 2
		v_mul_lo_u32 v10, v10, v7
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v14
		v_bitop3_b32 v19, v11, v10, v15 bitop3:0x96
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v17
		v_xad_u32 v19, v19, v20, s1
		v_bitop3_b32 v21, 16, v11, v10 bitop3:0x96
		v_xor_b32_e32 v21, v21, v15
		v_xad_u32 v21, v21, v20, s1
		v_bitop3_b32 v22, 32, v11, v10 bitop3:0x96
		v_xor_b32_e32 v22, v22, v15
		v_xad_u32 v22, v22, v20, s1
		v_bitop3_b32 v23, 48, v11, v10 bitop3:0x96
		v_xor_b32_e32 v23, v23, v15
		v_xad_u32 v23, v23, v20, s1
		v_bitop3_b32 v24, 64, v11, v10 bitop3:0x96
		v_xor_b32_e32 v24, v24, v15
		v_xad_u32 v24, v24, v20, s1
		v_xor_b32_e32 v25, 0x50, v11
		v_xor_b32_e32 v25, v25, v10
		v_xor_b32_e32 v25, v25, v15
		v_xad_u32 v25, v25, v20, s1
		v_xor_b32_e32 v26, 0x60, v11
		v_xor_b32_e32 v26, v26, v10
		v_xor_b32_e32 v26, v26, v15
		v_xad_u32 v26, v26, v20, s1
		v_xor_b32_e32 v27, 0x70, v11
		v_xor_b32_e32 v27, v27, v10
		v_xor_b32_e32 v27, v27, v15
		v_xad_u32 v27, v27, v20, s1
		v_xor_b32_e32 v28, 0x80, v11
		v_xor_b32_e32 v28, v28, v10
		v_xor_b32_e32 v28, v28, v15
		v_xad_u32 v28, v28, v20, s1
		v_xor_b32_e32 v29, 0x90, v11
		v_xor_b32_e32 v29, v29, v10
		v_xor_b32_e32 v29, v29, v15
		v_xad_u32 v29, v29, v20, s1
		v_xor_b32_e32 v30, 0xa0, v11
		v_xor_b32_e32 v30, v30, v10
		v_xor_b32_e32 v30, v30, v15
		v_xad_u32 v30, v30, v20, s1
		v_xor_b32_e32 v31, 0xb0, v11
		v_xor_b32_e32 v31, v31, v10
		v_xor_b32_e32 v31, v31, v15
		v_xad_u32 v31, v31, v20, s1
		v_xor_b32_e32 v32, 0xc0, v11
		v_xor_b32_e32 v32, v32, v10
		v_xor_b32_e32 v32, v32, v15
		v_xad_u32 v32, v32, v20, s1
		v_xor_b32_e32 v33, 0xd0, v11
		v_xor_b32_e32 v33, v33, v10
		v_xor_b32_e32 v33, v33, v15
		v_xad_u32 v33, v33, v20, s1
		v_xor_b32_e32 v34, 0xe0, v11
		v_xor_b32_e32 v34, v34, v10
		v_xor_b32_e32 v34, v34, v15
		v_xad_u32 v34, v34, v20, s1
		v_xor_b32_e32 v11, 0xf0, v11
		v_xor_b32_e32 v10, v11, v10
		v_xor_b32_e32 v10, v10, v15
		v_xad_u32 v10, v10, v20, s1
		v_cmp_lt_i32_e64 s[26:27], v19, s25
		v_cmp_lt_i32_e64 s[28:29], v21, s25
		v_cmp_lt_i32_e64 s[30:31], v22, s25
		v_cmp_lt_i32_e64 s[32:33], v23, s25
		v_cmp_lt_i32_e64 s[34:35], v24, s25
		v_cmp_lt_i32_e64 s[36:37], v25, s25
		v_cmp_lt_i32_e64 s[38:39], v26, s25
		v_cmp_lt_i32_e64 s[40:41], v27, s25
		v_cmp_lt_i32_e64 s[42:43], v28, s25
		v_cmp_lt_i32_e64 s[44:45], v29, s25
		v_cmp_lt_i32_e64 s[46:47], v30, s25
		v_cmp_lt_i32_e64 s[48:49], v31, s25
		v_cmp_lt_i32_e64 s[50:51], v32, s25
		v_cmp_lt_i32_e64 s[52:53], v33, s25
		v_cmp_lt_i32_e64 s[54:55], v34, s25
		s_mov_b32 s58, 0x7fffffff
		s_mov_b32 s59, 0x31016000
		s_mov_b32 s56, s2
		s_mov_b32 s57, s3
		v_lshlrev_b32_e32 v11, 16, v1
		v_or_b32_e32 v20, v1, v11
		v_mov_b32_e32 v21, v20
		v_mov_b32_e32 v22, v20
		v_mov_b32_e32 v23, v20
		s_mul_i32 s2, s16, s12
		s_lshl_b32 s2, s2, 9
		s_mul_i32 s3, s17, s10
		s_lshl_b32 s3, s3, 1
		s_add_i32 s10, s2, s3
		s_mul_i32 s11, s0, s11
		s_lshl_b32 s11, s11, 1
		s_add_i32 s10, s10, s11
		v_mul_lo_u32 v1, s12, v9
		v_lshl_add_u32 v11, v1, 1, s10
		v_and_b32_e32 v15, 1, v0
		v_lshl_add_u32 v11, v15, 4, v11
		v_and_b32_e32 v8, 1, v8
		v_lshl_add_u32 v11, v8, 7, v11
		v_and_b32_e32 v19, 1, v4
		v_lshl_add_u32 v11, v19, 6, v11
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_0
		buffer_load_dwordx4 v[24:27], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_0:
		s_andn2_b64 exec, s[60:61], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_0
		v_mov_b32_e32 v24, v20
		v_mov_b32_e32 v25, v21
		v_mov_b32_e32 v26, v22
		v_mov_b32_e32 v27, v23
.L_attn_fwd_async_prefetch.exec_endif_0:
		s_mov_b64 exec, s[60:61]
		s_lshl_b32 s10, s12, 5
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_1
		buffer_load_dwordx4 v[28:31], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_1:
		s_andn2_b64 exec, s[60:61], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_1
		v_mov_b32_e32 v28, v20
		v_mov_b32_e32 v29, v21
		v_mov_b32_e32 v30, v22
		v_mov_b32_e32 v31, v23
.L_attn_fwd_async_prefetch.exec_endif_1:
		s_mov_b64 exec, s[60:61]
		s_lshl_b32 s10, s12, 6
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_2
		buffer_load_dwordx4 v[32:35], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_2:
		s_andn2_b64 exec, s[60:61], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_2
		v_mov_b32_e32 v32, v20
		v_mov_b32_e32 v33, v21
		v_mov_b32_e32 v34, v22
		v_mov_b32_e32 v35, v23
.L_attn_fwd_async_prefetch.exec_endif_2:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0x60, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_3
		buffer_load_dwordx4 v[36:39], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_3:
		s_andn2_b64 exec, s[60:61], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_3
		v_mov_b32_e32 v36, v20
		v_mov_b32_e32 v37, v21
		v_mov_b32_e32 v38, v22
		v_mov_b32_e32 v39, v23
.L_attn_fwd_async_prefetch.exec_endif_3:
		s_mov_b64 exec, s[60:61]
		s_lshl_b32 s10, s12, 7
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_4
		buffer_load_dwordx4 v[40:43], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_4:
		s_andn2_b64 exec, s[60:61], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_4
		v_mov_b32_e32 v40, v20
		v_mov_b32_e32 v41, v21
		v_mov_b32_e32 v42, v22
		v_mov_b32_e32 v43, v23
.L_attn_fwd_async_prefetch.exec_endif_4:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0xa0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_5
		buffer_load_dwordx4 v[44:47], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_5:
		s_andn2_b64 exec, s[60:61], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_5
		v_mov_b32_e32 v44, v20
		v_mov_b32_e32 v45, v21
		v_mov_b32_e32 v46, v22
		v_mov_b32_e32 v47, v23
.L_attn_fwd_async_prefetch.exec_endif_5:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0xc0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_6
		buffer_load_dwordx4 v[48:51], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_6:
		s_andn2_b64 exec, s[60:61], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_6
		v_mov_b32_e32 v48, v20
		v_mov_b32_e32 v49, v21
		v_mov_b32_e32 v50, v22
		v_mov_b32_e32 v51, v23
.L_attn_fwd_async_prefetch.exec_endif_6:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0xe0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_7
		buffer_load_dwordx4 v[52:55], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_7:
		s_andn2_b64 exec, s[60:61], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_7
		v_mov_b32_e32 v52, v20
		v_mov_b32_e32 v53, v21
		v_mov_b32_e32 v54, v22
		v_mov_b32_e32 v55, v23
.L_attn_fwd_async_prefetch.exec_endif_7:
		s_mov_b64 exec, s[60:61]
		s_lshl_b32 s10, s12, 8
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_8
		buffer_load_dwordx4 v[56:59], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_8:
		s_andn2_b64 exec, s[60:61], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_8
		v_mov_b32_e32 v56, v20
		v_mov_b32_e32 v57, v21
		v_mov_b32_e32 v58, v22
		v_mov_b32_e32 v59, v23
.L_attn_fwd_async_prefetch.exec_endif_8:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0x120, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_9
		buffer_load_dwordx4 v[60:63], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_9:
		s_andn2_b64 exec, s[60:61], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_9
		v_mov_b32_e32 v60, v20
		v_mov_b32_e32 v61, v21
		v_mov_b32_e32 v62, v22
		v_mov_b32_e32 v63, v23
.L_attn_fwd_async_prefetch.exec_endif_9:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0x140, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_10
		buffer_load_dwordx4 v[64:67], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_10:
		s_andn2_b64 exec, s[60:61], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_10
		v_mov_b32_e32 v64, v20
		v_mov_b32_e32 v65, v21
		v_mov_b32_e32 v66, v22
		v_mov_b32_e32 v67, v23
.L_attn_fwd_async_prefetch.exec_endif_10:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0x160, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_11
		buffer_load_dwordx4 v[68:71], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_11:
		s_andn2_b64 exec, s[60:61], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_11
		v_mov_b32_e32 v68, v20
		v_mov_b32_e32 v69, v21
		v_mov_b32_e32 v70, v22
		v_mov_b32_e32 v71, v23
.L_attn_fwd_async_prefetch.exec_endif_11:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0x180, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_12
		buffer_load_dwordx4 v[72:75], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_12:
		s_andn2_b64 exec, s[60:61], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_12
		v_mov_b32_e32 v72, v20
		v_mov_b32_e32 v73, v21
		v_mov_b32_e32 v74, v22
		v_mov_b32_e32 v75, v23
.L_attn_fwd_async_prefetch.exec_endif_12:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0x1a0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_13
		buffer_load_dwordx4 v[76:79], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_13:
		s_andn2_b64 exec, s[60:61], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_13
		v_mov_b32_e32 v76, v20
		v_mov_b32_e32 v77, v21
		v_mov_b32_e32 v78, v22
		v_mov_b32_e32 v79, v23
.L_attn_fwd_async_prefetch.exec_endif_13:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0x1c0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v19, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		s_and_saveexec_b64 s[60:61], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_14
		buffer_load_dwordx4 v[80:83], v11, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_14:
		s_andn2_b64 exec, s[60:61], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_14
		v_mov_b32_e32 v80, v20
		v_mov_b32_e32 v81, v21
		v_mov_b32_e32 v82, v22
		v_mov_b32_e32 v83, v23
.L_attn_fwd_async_prefetch.exec_endif_14:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s10, 0x1e0, s12
		s_add_i32 s2, s10, s2
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s11
		v_lshl_add_u32 v1, v1, 1, s2
		v_lshl_add_u32 v1, v15, 4, v1
		v_lshl_add_u32 v1, v8, 7, v1
		v_lshl_add_u32 v1, v19, 6, v1
		v_lshl_add_u32 v1, v3, 5, v1
		v_cmp_lt_i32_e64 vcc, v10, s25
		s_and_saveexec_b64 s[60:61], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_15
		buffer_load_dwordx4 v[84:87], v1, s[56:59], 0 offen
.L_attn_fwd_async_prefetch.exec_else_15:
		s_andn2_b64 exec, s[60:61], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_15
		v_mov_b32_e32 v84, v20
		v_mov_b32_e32 v85, v21
		v_mov_b32_e32 v86, v22
		v_mov_b32_e32 v87, v23
.L_attn_fwd_async_prefetch.exec_endif_15:
		s_mov_b64 exec, s[60:61]
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s58
		s_mov_b32 s31, s59
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s58
		s_mov_b32 s35, s59
		v_and_b32_e32 v1, 1, v5
		v_lshlrev_b32_e32 v5, 1, v1
		v_and_b32_e32 v10, 1, v13
		v_lshlrev_b32_e32 v10, 2, v10
		v_lshlrev_b32_e32 v11, 3, v16
		v_and_b32_e32 v9, 1, v9
		v_bitop3_b32 v10, v10, v11, v9 bitop3:0x96
		v_bitop3_b32 v5, v0, v5, v10 bitop3:0x96
		v_lshlrev_b32_e32 v5, 4, v5
		v_add_u32_e32 v5, 0x10000, v5
		s_waitcnt vmcnt(0)
		ds_write_b128 v5, v[24:27] offset:2480
		ds_write_b128 v5, v[28:31] offset:6576
		ds_write_b128 v5, v[32:35] offset:10672
		ds_write_b128 v5, v[36:39] offset:14768
		ds_write_b128 v5, v[40:43] offset:18864
		ds_write_b128 v5, v[44:47] offset:22960
		ds_write_b128 v5, v[48:51] offset:27056
		ds_write_b128 v5, v[52:55] offset:31152
		v_mov_b32_e32 v10, 2
		v_mul_lo_u32 v10, v10, v17
		s_mul_i32 s2, s17, s13
		s_mul_i32 s3, s0, s14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v11, 13, v13
		v_add_u32_e32 v11, 0x10000, v11
		v_and_b32_e32 v16, 63, v0
		v_lshrrev_b32_e32 v17, 4, v16
		v_and_b32_e32 v17, 1, v17
		v_lshl_add_u32 v11, v17, 12, v11
		v_lshrrev_b32_e32 v17, 5, v16
		v_lshrrev_b32_e32 v20, 3, v16
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v21, 7, v20
		v_lshrrev_b32_e32 v22, 2, v16
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v23, 6, v22
		v_add3_u32 v24, v17, v21, v23
		v_lshrrev_b32_e32 v25, 1, v16
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v26, 5, v25
		v_and_b32_e32 v27, 1, v16
		v_lshlrev_b32_e32 v28, 4, v27
		v_add3_u32 v24, v24, v26, v28
		v_lshlrev_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v22, 2, v22
		v_lshlrev_b32_e32 v20, 3, v20
		v_xor_b32_e32 v20, v20, v27
		v_bitop3_b32 v20, v25, v22, v20 bitop3:0x96
		v_xor_b32_e32 v22, v24, v20
		v_lshl_add_u32 v22, v22, 4, v11
		ds_read_b128 a[0:3], v22 offset:2480
		v_add_u32_e32 v24, 2, v17
		v_add3_u32 v24, v24, v21, v23
		v_add3_u32 v24, v24, v26, v28
		v_xor_b32_e32 v24, v24, v20
		v_lshl_add_u32 v24, v24, 4, v11
		ds_read_b128 a[4:7], v24 offset:2480
		v_add3_u32 v25, v17, v21, v23
		v_add_u32_e32 v25, v25, v26
		v_add3_u32 v27, v28, v25, 4
		v_xor_b32_e32 v27, v27, v20
		v_lshl_add_u32 v27, v27, 4, v11
		ds_read_b128 a[8:11], v27 offset:2480
		v_add3_u32 v29, v28, v25, 6
		v_xor_b32_e32 v29, v29, v20
		v_lshl_add_u32 v29, v29, 4, v11
		ds_read_b128 a[12:15], v29 offset:2480
		v_add3_u32 v25, v28, v25, 8
		v_xor_b32_e32 v25, v25, v20
		v_lshl_add_u32 v25, v25, 4, v11
		ds_read_b128 a[16:19], v25 offset:2480
		v_add3_u32 v21, v17, v21, v23
		v_add_u32_e32 v21, v21, v26
		v_add3_u32 v23, v28, v21, 10
		v_xor_b32_e32 v23, v23, v20
		v_lshl_add_u32 v23, v23, 4, v11
		ds_read_b128 a[20:23], v23 offset:2480
		v_add3_u32 v26, v28, v21, 12
		v_xor_b32_e32 v26, v26, v20
		v_lshl_add_u32 v26, v26, 4, v11
		ds_read_b128 a[24:27], v26 offset:2480
		v_add3_u32 v21, v28, v21, 14
		v_xor_b32_e32 v20, v21, v20
		v_lshl_add_u32 v11, v20, 4, v11
		ds_read_b128 a[28:31], v11 offset:2480
		s_mov_b32 s4, 63
		v_readfirstlane_b32 s5, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v5, v[56:59] offset:2480
		ds_write_b128 v5, v[60:63] offset:6576
		ds_write_b128 v5, v[64:67] offset:10672
		ds_write_b128 v5, v[68:71] offset:14768
		ds_write_b128 v5, v[72:75] offset:18864
		ds_write_b128 v5, v[76:79] offset:22960
		ds_write_b128 v5, v[80:83] offset:27056
		ds_write_b128 v5, v[84:87] offset:31152
		v_and_b32_e32 v0, 3, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[32:35], v22 offset:2480
		ds_read_b128 a[36:39], v24 offset:2480
		ds_read_b128 a[40:43], v27 offset:2480
		ds_read_b128 a[44:47], v29 offset:2480
		ds_read_b128 a[48:51], v25 offset:2480
		ds_read_b128 a[52:55], v23 offset:2480
		ds_read_b128 a[56:59], v26 offset:2480
		ds_read_b128 a[60:63], v11 offset:2480
		s_add_i32 s6, s25, 63
		s_cmp_lt_i32 s6, 0
		s_cselect_b32 s4, s4, 0
		s_add_i32 s4, s6, s4
		s_ashr_i32 s4, s4, 6
		s_add_i32 s4, s4, -1
		s_cmp_gt_i32 s4, 0
		s_cselect_b32 s4, s4, 0
		v_mov_b32_e32 v5, 32
		v_mul_lo_u32 v5, v5, v7
		v_bitop3_b32 v11, v12, v5, v14 bitop3:0x96
		v_xor_b32_e32 v11, v11, v10
		v_bitop3_b32 v20, 4, v12, v5 bitop3:0x96
		v_bitop3_b32 v21, 8, v12, v5 bitop3:0x96
		v_bitop3_b32 v5, 12, v12, v5 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v11, s25
		v_mul_lo_u32 v12, s15, v13
		v_mul_lo_u32 v22, s15, v1
		v_lshlrev_b32_e32 v22, 6, v22
		v_lshl_add_u32 v12, v12, 1, v22
		v_mul_lo_u32 v22, s15, v9
		v_lshl_add_u32 v12, v22, 5, v12
		v_lshlrev_b32_e32 v22, 4, v15
		v_lshlrev_b32_e32 v23, 7, v8
		v_add3_u32 v12, v12, v22, v23
		v_lshlrev_b32_e32 v24, 6, v19
		v_lshlrev_b32_e32 v25, 5, v3
		v_add3_u32 v12, v12, v24, v25
		s_lshl_b32 s2, s2, 1
		s_lshl_b32 s3, s3, 1
		s_add_i32 s6, s2, s3
		v_add_u32_e32 v26, s6, v12
		v_mov_b32_e32 v27, 0x80000000
		v_cndmask_b32_e32 v26, v27, v26, vcc
		s_lshr_b32 s5, s5, 6
		s_mul_i32 s6, 0x410, s5
		s_mov_b32 m0, s6
		v_xad_u32 v6, v6, v18, s1
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		s_lshl_b32 s7, s15, 3
		s_add_i32 s7, s7, s2
		s_add_i32 s7, s7, s3
		v_add_u32_e32 v26, s7, v12
		v_cndmask_b32_e32 v26, v27, v26, vcc
		s_add_i32 m0, m0, 0x1040
		v_xad_u32 v2, v2, v18, s1
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		s_lshl_b32 s1, s15, 4
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s3
		v_add_u32_e32 v18, s1, v12
		v_cndmask_b32_e32 v18, v27, v18, vcc
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s1, 24, s15
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_bitop3_b32 v18, v20, v14, v10 bitop3:0x96
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s3
		v_add_u32_e32 v20, s1, v12
		v_cndmask_b32_e32 v20, v27, v20, vcc
		s_add_i32 m0, m0, 0x1040
		s_mov_b32 s1, 0
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v20, v21, v14, v10 bitop3:0x96
		v_mul_lo_u32 v21, s20, v13
		v_mul_lo_u32 v26, s20, v1
		v_lshlrev_b32_e32 v26, 6, v26
		v_lshl_add_u32 v21, v21, 1, v26
		v_mul_lo_u32 v26, s20, v9
		v_lshl_add_u32 v21, v26, 5, v21
		v_add3_u32 v21, v21, v22, v23
		v_add3_u32 v21, v21, v24, v25
		s_mul_i32 s7, s17, s18
		s_lshl_b32 s7, s7, 1
		s_mul_i32 s10, s0, s19
		s_lshl_b32 s10, s10, 1
		s_add_i32 s11, s7, s10
		v_add_u32_e32 v22, s11, v21
		v_cndmask_b32_e32 v22, v27, v22, vcc
		s_mul_i32 s5, 0x440, s5
		s_add_i32 m0, s5, 0x81f0
		v_and_b32_e32 v16, 31, v16
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		v_bitop3_b32 v5, v5, v14, v10 bitop3:0x96
		s_lshl_b32 s11, s20, 3
		s_add_i32 s11, s11, s7
		s_add_i32 s11, s11, s10
		v_add_u32_e32 v10, s11, v21
		v_cndmask_b32_e32 v10, v27, v10, vcc
		s_add_i32 m0, m0, 0x1100
		v_lshlrev_b32_e32 v0, 3, v0
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_lshl_b32 s11, s20, 4
		s_add_i32 s11, s11, s7
		s_add_i32 s11, s11, s10
		v_add_u32_e32 v10, s11, v21
		v_cndmask_b32_e32 v10, v27, v10, vcc
		s_add_i32 m0, m0, 0x1100
		v_and_b32_e32 v4, 3, v4
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_mul_i32 s11, 24, s20
		s_add_i32 s11, s11, s7
		s_add_i32 s11, s11, s10
		v_add_u32_e32 v10, s11, v21
		v_cndmask_b32_e32 v10, v27, v10, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[12:13], v6, s25
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_mul_i32 s11, s4, 64
		v_mov_b32_e32 v6, 0xff800000
		v_mbcnt_lo_u32_b32 v10, -1, 0
		v_mbcnt_hi_u32_b32 v10, -1, v10
		v_and_b32_e32 v14, 1, v10
		v_lshrrev_b32_e32 v22, 4, v10
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 4, v22
		v_lshrrev_b32_e32 v23, 3, v10
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 3, v23
		v_add3_u32 v24, v14, v22, v23
		v_lshrrev_b32_e32 v25, 2, v10
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 2, v25
		v_lshrrev_b32_e32 v10, 1, v10
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add3_u32 v24, v24, v25, v10
		v_add_u32_e32 v14, 32, v14
		v_bitop3_b32 v22, v25, v23, v22 bitop3:0x96
		v_bitop3_b32 v10, v14, v10, v22 bitop3:0x96
		v_mov_b32_e32 v22, 0x3e0293ee
		v_mov_b32_e32 v23, 0x3e0293ee
		v_lshlrev_b32_e32 v14, 4, v17
		v_lshrrev_b32_e32 v25, 4, v16
		v_lshlrev_b32_e32 v26, 8, v25
		v_lshrrev_b32_e32 v28, 3, v16
		v_and_b32_e32 v28, 1, v28
		v_mov_b32_e32 v29, 0x2080
		v_mul_lo_u32 v29, v29, v28
		v_lshrrev_b32_e32 v28, 2, v16
		v_and_b32_e32 v28, 1, v28
		v_mov_b32_e32 v30, 0x1040
		v_mul_lo_u32 v30, v30, v28
		v_lshrrev_b32_e32 v28, 1, v16
		v_and_b32_e32 v28, 1, v28
		v_mov_b32_e32 v31, 0x820
		v_mul_lo_u32 v31, v31, v28
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v28, 0x410
		v_mul_lo_u32 v28, v28, v16
		v_mov_b32_e32 v16, 0x2200
		v_mul_lo_u32 v16, v16, v1
		v_lshlrev_b32_e32 v32, 5, v9
		v_mov_b32_e32 v33, 0x440
		v_mul_lo_u32 v33, v33, v4
		s_lshl_b32 s14, s15, 7
		s_add_i32 s14, s14, s2
		s_add_i32 s14, s14, s3
		s_mul_i32 s18, 0x88, s15
		s_add_i32 s18, s18, s2
		s_add_i32 s18, s18, s3
		s_mul_i32 s19, 0x90, s15
		s_add_i32 s19, s19, s2
		s_add_i32 s19, s19, s3
		s_mul_i32 s24, 0x98, s15
		s_add_i32 s2, s24, s2
		s_add_i32 s2, s2, s3
		s_lshl_b32 s3, s20, 7
		s_add_i32 s3, s3, s7
		s_add_i32 s3, s3, s10
		s_mul_i32 s24, 0x88, s20
		s_add_i32 s24, s24, s7
		s_add_i32 s24, s24, s10
		s_mul_i32 s26, 0x90, s20
		s_add_i32 s26, s26, s7
		s_add_i32 s26, s26, s10
		s_mul_i32 s27, 0x98, s20
		s_add_i32 s7, s27, s7
		s_add_i32 s7, s7, s10
		v_lshlrev_b32_e32 v4, 2, v24
		v_lshlrev_b32_e32 v10, 2, v10
		s_cmp_lt_i32 0, s11
		v_mov_b32_e32 v34, 1.0
		v_mov_b32_e32 v35, 1.0
		v_mov_b32_e32 v36, 0xff800000
		v_mov_b32_e32 v37, 0xff800000
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
		s_lshr_b32 s10, s1, 6
		s_and_b32 s27, s10, 1
		s_mul_i32 s36, 0x4100, s27
		v_add3_u32 v24, s36, v14, v26
		v_add3_u32 v24, v24, v29, v30
		v_add3_u32 v24, v24, v31, v28
		ds_read_b128 v[40:43], v24
		ds_read_b128 v[44:47], v24 offset:32
		ds_read_b128 v[176:179], v24 offset:64
		ds_read_b128 v[180:183], v24 offset:96
		ds_read_b128 v[184:187], v24 offset:128
		ds_read_b128 v[188:191], v24 offset:160
		ds_read_b128 v[192:195], v24 offset:192
		ds_read_b128 a[64:67], v24 offset:224
		ds_read_b128 v[196:199], v24 offset:512
		ds_read_b128 v[200:203], v24 offset:544
		ds_read_b128 v[204:207], v24 offset:576
		ds_read_b128 a[68:71], v24 offset:608
		ds_read_b128 a[72:75], v24 offset:640
		ds_read_b128 a[76:79], v24 offset:672
		ds_read_b128 a[80:83], v24 offset:704
		ds_read_b128 a[84:87], v24 offset:736
		s_mul_i32 s27, 0x4400, s27
		v_add3_u32 v24, s27, v0, v16
		v_add3_u32 v24, v24, v32, v33
		ds_read_b64_tr_b16 a[88:89], v24 offset:33264
		ds_read_b64_tr_b16 a[90:91], v24 offset:37616
		ds_read_b64_tr_b16 a[92:93], v24 offset:33520
		ds_read_b64_tr_b16 a[94:95], v24 offset:37872
		ds_read_b64_tr_b16 a[96:97], v24 offset:33776
		ds_read_b64_tr_b16 a[98:99], v24 offset:38128
		ds_read_b64_tr_b16 a[100:101], v24 offset:34032
		ds_read_b64_tr_b16 a[102:103], v24 offset:38384
		ds_read_b64_tr_b16 a[104:105], v24 offset:33328
		ds_read_b64_tr_b16 a[106:107], v24 offset:37680
		ds_read_b64_tr_b16 a[108:109], v24 offset:33584
		ds_read_b64_tr_b16 a[110:111], v24 offset:37936
		ds_read_b64_tr_b16 a[112:113], v24 offset:33840
		ds_read_b64_tr_b16 a[114:115], v24 offset:38192
		ds_read_b64_tr_b16 a[116:117], v24 offset:34096
		ds_read_b64_tr_b16 a[118:119], v24 offset:38448
		ds_read_b64_tr_b16 a[120:121], v24 offset:33392
		ds_read_b64_tr_b16 a[122:123], v24 offset:37744
		ds_read_b64_tr_b16 a[124:125], v24 offset:33648
		ds_read_b64_tr_b16 a[126:127], v24 offset:38000
		ds_read_b64_tr_b16 a[128:129], v24 offset:33904
		ds_read_b64_tr_b16 a[130:131], v24 offset:38256
		ds_read_b64_tr_b16 a[132:133], v24 offset:34160
		ds_read_b64_tr_b16 a[134:135], v24 offset:38512
		ds_read_b64_tr_b16 a[136:137], v24 offset:33456
		ds_read_b64_tr_b16 a[138:139], v24 offset:37808
		ds_read_b64_tr_b16 a[140:141], v24 offset:33712
		ds_read_b64_tr_b16 a[142:143], v24 offset:38064
		ds_read_b64_tr_b16 a[144:145], v24 offset:33968
		ds_read_b64_tr_b16 a[146:147], v24 offset:38320
		ds_read_b64_tr_b16 a[148:149], v24 offset:34224
		ds_read_b64_tr_b16 a[150:151], v24 offset:38576
		s_mul_i32 s27, s15, s1
		s_lshl_b32 s27, s27, 1
		s_add_i32 s36, s14, s27
		v_add_u32_e32 v24, s36, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v38, s27, v12
		s_add_i32 s10, s10, 1
		v_add_u32_e32 v39, s18, v38
		s_and_b32 s10, s10, 1
		v_add_u32_e32 v208, s19, v38
		s_mul_i32 s27, 0x4100, s10
		v_add_u32_e32 v38, s2, v38
		s_add_i32 s27, s6, s27
		v_mfma_f32_32x32x16_bf16 v[224:239], v[40:43], a[0:3], 0
		s_mov_b32 m0, s27
		v_mfma_f32_32x32x16_bf16 v[224:239], v[44:47], a[4:7], v[224:239]
		s_mul_i32 s27, s20, s1
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[8:11], v[224:239]
		s_add_i32 s1, s1, 64
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[12:15], v[224:239]
		v_add_u32_e32 v209, s1, v11
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[16:19], v[224:239]
		v_add_u32_e32 v210, s1, v18
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[20:23], v[224:239]
		v_add_u32_e32 v211, s1, v20
		v_mfma_f32_32x32x16_bf16 v[224:239], v[192:195], a[24:27], v[224:239]
		v_add_u32_e32 v212, s1, v5
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[32:35], 0
		v_cmp_lt_i32_e64 s[36:37], v209, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[36:39], v[240:255]
		v_cmp_lt_i32_e64 vcc, v212, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[176:179], a[40:43], v[240:255]
		v_cndmask_b32_e64 v24, v27, v24, s[36:37]
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[180:183], a[44:47], v[240:255]
		v_cmp_lt_i32_e64 s[38:39], v210, s25
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[40:41], v211, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[184:187], a[48:51], v[240:255]
		v_cndmask_b32_e64 v24, v27, v39, s[38:39]
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v24, v27, v208, s[40:41]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[188:191], a[52:55], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v38, v27, v38, vcc
		s_lshl_b32 s27, s27, 1
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_add_i32 s42, s3, s27
		v_mfma_f32_32x32x16_bf16 v[240:255], v[192:195], a[56:59], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v24, s42, v21
		s_mul_i32 s10, 0x4400, s10
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v24, v27, v24, s[36:37]
		s_add_i32 s10, s5, s10
		v_add_u32_e32 v38, s27, v21
		s_add_i32 m0, s10, 0x81f0
		v_add_u32_e32 v39, s24, v38
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v24, v27, v39, s[38:39]
		v_add_u32_e32 v39, s26, v38
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v39, v27, v39, s[40:41]
		v_add_u32_e32 v38, s7, v38
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		v_cndmask_b32_e32 v24, v27, v38, vcc
		v_mfma_f32_32x32x16_bf16 v[176:191], v[196:199], a[0:3], 0
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], v[200:203], a[4:7], v[176:191]
		buffer_load_dwordx4 v39, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], v[204:207], a[8:11], v[176:191]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s1, s11
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[12:15], v[176:191]
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[196:199], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[200:203], a[36:39], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[204:207], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[68:71], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[16:19], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[72:75], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[76:79], a[20:23], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[76:79], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[24:27], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[56:59], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[64:67], a[28:31], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[28:31], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[60:63], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[60:63], v[240:255]
		s_nop 8
		v_max3_f32 v24, v224, v225, v226
		v_max3_f32 v38, v228, v229, v230
		v_max3_f32 v39, v232, v233, v234
		v_max3_f32 v40, v236, v237, v238
		v_max3_f32 v41, v176, v177, v178
		v_max3_f32 v42, v180, v181, v182
		v_max3_f32 v43, v184, v185, v186
		v_max3_f32 v44, v188, v189, v190
		v_max3_f32 v24, v24, v227, v38
		v_max3_f32 v38, v39, v235, v40
		v_max3_f32 v39, v41, v179, v42
		v_max3_f32 v40, v43, v187, v44
		v_max3_f32 v24, v24, v231, v38
		v_max3_f32 v38, v39, v183, v40
		v_max3_f32 v24, v24, v239, v38
		v_max_f32_e32 v38, v24, v191
		v_mov_b32_e32 v39, v38
		v_max3_f32 v24, v240, v241, v242
		v_max3_f32 v40, v244, v245, v246
		v_max3_f32 v41, v248, v249, v250
		v_max3_f32 v42, v252, v253, v254
		v_max3_f32 v43, v208, v209, v210
		v_max3_f32 v44, v212, v213, v214
		v_max3_f32 v45, v216, v217, v218
		v_max3_f32 v46, v220, v221, v222
		v_max3_f32 v24, v24, v243, v40
		v_max3_f32 v40, v41, v251, v42
		v_max3_f32 v41, v43, v211, v44
		v_max3_f32 v42, v45, v219, v46
		v_max3_f32 v24, v24, v247, v40
		v_max3_f32 v40, v41, v215, v42
		v_max3_f32 v24, v24, v255, v40
		v_max_f32_e32 v40, v24, v223
		v_permlane32_swap_b32_e32 v38, v39
		v_mov_b32_e32 v41, v40
		v_max_f32_e32 v42, v38, v39
		s_nop 0
		v_permlane32_swap_b32_e32 v40, v41
		v_max_f32_e32 v43, v40, v41
		v_pk_mul_f32 v[38:39], v[42:43], v[22:23]
		v_max_f32_e32 v40, v36, v38
		v_max_f32_e32 v41, v37, v39
		v_pk_fma_f32 v[38:39], v[224:225], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[226:227], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[228:229], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[230:231], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[232:233], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[234:235], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[236:237], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[238:239], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[176:177], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[22:23], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[240:241], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[242:243], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[244:245], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[246:247], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[224:225], v[248:249], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[226:227], v[250:251], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[228:229], v[252:253], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[230:231], v[254:255], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[232:233], v[208:209], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[210:211], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[212:213], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[214:215], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[216:217], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[218:219], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[220:221], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[222:223], v[22:23], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v222, v38
		v_exp_f32_e32 v234, v39
		v_exp_f32_e32 v38, v42
		v_exp_f32_e32 v236, v43
		v_exp_f32_e32 v42, v44
		v_exp_f32_e32 v238, v45
		v_exp_f32_e32 v44, v46
		v_exp_f32_e32 v240, v47
		v_exp_f32_e32 v46, v192
		v_exp_f32_e32 v242, v193
		v_exp_f32_e32 v192, v194
		v_exp_f32_e32 v244, v195
		v_exp_f32_e32 v194, v196
		v_exp_f32_e32 v246, v197
		v_exp_f32_e32 v196, v198
		v_exp_f32_e32 v248, v199
		v_exp_f32_e32 v223, v200
		v_exp_f32_e32 v235, v201
		v_exp_f32_e32 v39, v176
		v_exp_f32_e32 v237, v177
		v_exp_f32_e32 v43, v178
		v_exp_f32_e32 v239, v179
		v_exp_f32_e32 v45, v180
		v_exp_f32_e32 v241, v181
		v_exp_f32_e32 v47, v182
		v_exp_f32_e32 v243, v183
		v_exp_f32_e32 v193, v184
		v_exp_f32_e32 v245, v185
		v_exp_f32_e32 v195, v186
		v_exp_f32_e32 v247, v187
		v_exp_f32_e32 v197, v188
		v_exp_f32_e32 v249, v189
		v_exp_f32_e32 v176, v190
		v_exp_f32_e32 v178, v191
		v_exp_f32_e32 v180, v202
		v_exp_f32_e32 v182, v203
		v_exp_f32_e32 v184, v204
		v_exp_f32_e32 v186, v205
		v_exp_f32_e32 v188, v206
		v_exp_f32_e32 v190, v207
		v_exp_f32_e32 v198, v224
		v_exp_f32_e32 v200, v225
		v_exp_f32_e32 v202, v226
		v_exp_f32_e32 v204, v227
		v_exp_f32_e32 v206, v228
		v_exp_f32_e32 v224, v229
		v_exp_f32_e32 v226, v230
		v_exp_f32_e32 v228, v231
		v_exp_f32_e32 v177, v232
		v_exp_f32_e32 v179, v233
		v_exp_f32_e32 v181, v208
		v_exp_f32_e32 v183, v209
		v_exp_f32_e32 v185, v210
		v_exp_f32_e32 v187, v211
		v_exp_f32_e32 v189, v212
		v_exp_f32_e32 v191, v213
		v_exp_f32_e32 v199, v214
		v_exp_f32_e32 v201, v215
		v_exp_f32_e32 v203, v216
		v_exp_f32_e32 v205, v217
		v_exp_f32_e32 v207, v218
		v_exp_f32_e32 v225, v219
		v_exp_f32_e32 v227, v220
		v_exp_f32_e32 v229, v221
		v_pk_add_f32 v[208:209], v[222:223], v[234:235]
		v_pk_add_f32 v[210:211], v[38:39], v[236:237]
		v_pk_add_f32 v[212:213], v[42:43], v[238:239]
		v_pk_add_f32 v[214:215], v[44:45], v[240:241]
		v_pk_add_f32 v[216:217], v[46:47], v[242:243]
		v_pk_add_f32 v[218:219], v[192:193], v[244:245]
		v_pk_add_f32 v[220:221], v[194:195], v[246:247]
		v_pk_add_f32 v[230:231], v[196:197], v[248:249]
		v_pk_add_f32 v[208:209], v[208:209], v[210:211]
		v_pk_add_f32 v[210:211], v[212:213], v[214:215]
		v_pk_add_f32 v[212:213], v[216:217], v[218:219]
		v_pk_add_f32 v[214:215], v[220:221], v[230:231]
		v_pk_add_f32 v[208:209], v[208:209], v[210:211]
		v_pk_add_f32 v[210:211], v[212:213], v[214:215]
		v_pk_add_f32 v[212:213], v[208:209], v[210:211]
		v_add_f32_e32 v24, v212, v213
		ds_bpermute_b32 v208, v4, v24
		ds_bpermute_b32 v210, v10, v24
		v_pk_add_f32 v[212:213], v[176:177], v[178:179]
		v_pk_add_f32 v[214:215], v[180:181], v[182:183]
		v_pk_add_f32 v[216:217], v[184:185], v[186:187]
		v_pk_add_f32 v[218:219], v[188:189], v[190:191]
		v_pk_add_f32 v[220:221], v[198:199], v[200:201]
		v_pk_add_f32 v[230:231], v[202:203], v[204:205]
		v_pk_add_f32 v[232:233], v[206:207], v[224:225]
		v_pk_add_f32 v[250:251], v[226:227], v[228:229]
		v_pk_add_f32 v[212:213], v[212:213], v[214:215]
		v_pk_add_f32 v[214:215], v[216:217], v[218:219]
		v_pk_add_f32 v[216:217], v[220:221], v[230:231]
		v_pk_add_f32 v[218:219], v[232:233], v[250:251]
		v_pk_add_f32 v[212:213], v[212:213], v[214:215]
		v_pk_add_f32 v[214:215], v[216:217], v[218:219]
		v_pk_add_f32 v[216:217], v[212:213], v[214:215]
		v_mov_b32_e32 v211, v217
		v_mov_b32_e32 v209, v216
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[212:213], v[208:209], v[210:211]
		v_mov_b32_e32 v208, v213
		v_mov_b32_e32 v209, v213
		v_pk_add_f32 v[210:211], v[36:37], v[40:41] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v216, v222, v234
		v_permlane32_swap_b32_e32 v208, v209
		v_add_f32_e32 v37, v208, v209
		v_exp_f32_e32 v208, v210
		v_exp_f32_e32 v209, v211
		v_cvt_pk_bf16_f32 v217, v38, v236
		v_mov_b32_e32 v36, v212
		v_pk_fma_f32 v[34:35], v[34:35], v[208:209], v[36:37]
		v_cvt_pk_bf16_f32 v218, v42, v238
		v_cvt_pk_bf16_f32 v219, v44, v240
		v_cvt_pk_bf16_f32 v212, v46, v242
		v_cvt_pk_bf16_f32 v213, v192, v244
		v_cvt_pk_bf16_f32 v214, v194, v246
		v_cvt_pk_bf16_f32 v215, v196, v248
		v_cvt_pk_bf16_f32 v252, v223, v235
		v_cvt_pk_bf16_f32 v253, v39, v237
		v_cvt_pk_bf16_f32 v254, v43, v239
		v_cvt_pk_bf16_f32 v255, v45, v241
		v_cvt_pk_bf16_f32 v36, v47, v243
		v_cvt_pk_bf16_f32 v37, v193, v245
		v_cvt_pk_bf16_f32 v38, v195, v247
		v_cvt_pk_bf16_f32 v39, v197, v249
		v_pk_mul_f32 v[48:49], v[48:49], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[66:67], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[68:69], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[70:71], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[72:73], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[74:75], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[76:77], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[78:79], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[80:81], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[82:83], v[82:83], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[84:85], v[84:85], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[86:87], v[86:87], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[88:89], v[88:89], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[90:91], v[90:91], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[92:93], v[92:93], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[94:95], v[94:95], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[96:97], v[96:97], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[98:99], v[98:99], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[100:101], v[100:101], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[102:103], v[102:103], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[104:105], v[104:105], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[106:107], v[106:107], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[108:109], v[108:109], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[110:111], v[110:111], v[208:209] op_sel_hi:[1,0]
		v_pk_mul_f32 v[112:113], v[112:113], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[114:115], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[116:117], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[118:119], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[120:121], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[122:123], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[124:125], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[126:127], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[128:129], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[130:131], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[132:133], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[134:135], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[136:137], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[138:139], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[140:141], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[142:143], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[144:145], v[144:145], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[146:147], v[146:147], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[148:149], v[148:149], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[150:151], v[150:151], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[152:153], v[152:153], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[154:155], v[154:155], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[156:157], v[156:157], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[158:159], v[158:159], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[160:161], v[160:161], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[162:163], v[162:163], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[164:165], v[164:165], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[166:167], v[166:167], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[168:169], v[168:169], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[170:171], v[170:171], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[172:173], v[172:173], v[208:209] op_sel:[0,1]
		v_pk_mul_f32 v[174:175], v[174:175], v[208:209] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v44, v176, v178
		v_cvt_pk_bf16_f32 v45, v180, v182
		v_cvt_pk_bf16_f32 v46, v184, v186
		v_cvt_pk_bf16_f32 v47, v188, v190
		v_cvt_pk_bf16_f32 v192, v198, v200
		v_cvt_pk_bf16_f32 v193, v202, v204
		v_cvt_pk_bf16_f32 v194, v206, v224
		v_cvt_pk_bf16_f32 v195, v226, v228
		v_cvt_pk_bf16_f32 v208, v177, v179
		v_cvt_pk_bf16_f32 v209, v181, v183
		v_cvt_pk_bf16_f32 v210, v185, v187
		v_cvt_pk_bf16_f32 v211, v189, v191
		v_cvt_pk_bf16_f32 v176, v199, v201
		v_cvt_pk_bf16_f32 v177, v203, v205
		v_cvt_pk_bf16_f32 v178, v207, v225
		v_cvt_pk_bf16_f32 v179, v227, v229
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[216:219], v[48:63]
		v_permlane32_swap_b32_e32 v252, v254
		v_permlane32_swap_b32_e32 v253, v255
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[216:219], v[64:79]
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[216:219], v[80:95]
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], v[216:219], v[96:111]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[160:175], a[136:139], v[44:47], v[160:175]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], v[44:47], v[112:127]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], v[44:47], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[120:123], v[44:47], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[212:215], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], v[212:215], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[140:143], v[192:195], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], v[192:195], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[108:111], v[192:195], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[124:127], v[192:195], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[252:255], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[252:255], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[252:255], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], v[252:255], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[144:147], v[208:211], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], v[208:211], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], v[208:211], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], v[208:211], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[100:103], v[36:39], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[36:39], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[36:39], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[148:151], v[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[148:151], v[176:179], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[100:103], v[176:179], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[116:119], v[176:179], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[132:135], v[176:179], v[144:159]
		v_mov_b32_e32 v36, v40
		v_mov_b32_e32 v37, v41
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s58
		s_mov_b32 s31, s59
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s4, 1
		s_mul_i32 s2, 0x4100, s1
		v_lshl_add_u32 v5, v17, 4, s2
		v_lshl_add_u32 v5, v25, 8, v5
		v_add3_u32 v5, v5, v29, v30
		v_add3_u32 v5, v5, v31, v28
		ds_read_b128 v[24:27], v5
		ds_read_b128 v[28:31], v5 offset:32
		ds_read_b128 v[40:43], v5 offset:64
		ds_read_b128 v[44:47], v5 offset:96
		ds_read_b128 a[64:67], v5 offset:128
		ds_read_b128 a[68:71], v5 offset:160
		ds_read_b128 a[72:75], v5 offset:192
		ds_read_b128 a[76:79], v5 offset:224
		ds_read_b128 v[176:179], v5 offset:512
		ds_read_b128 v[180:183], v5 offset:544
		ds_read_b128 v[184:187], v5 offset:576
		ds_read_b128 v[188:191], v5 offset:608
		ds_read_b128 a[80:83], v5 offset:640
		ds_read_b128 a[84:87], v5 offset:672
		ds_read_b128 a[88:91], v5 offset:704
		ds_read_b128 a[92:95], v5 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_add3_u32 v0, s1, v0, v16
		v_add3_u32 v0, v0, v32, v33
		ds_read_b64_tr_b16 a[96:97], v0 offset:33264
		ds_read_b64_tr_b16 a[98:99], v0 offset:37616
		ds_read_b64_tr_b16 a[100:101], v0 offset:33520
		ds_read_b64_tr_b16 a[102:103], v0 offset:37872
		ds_read_b64_tr_b16 a[104:105], v0 offset:33776
		ds_read_b64_tr_b16 a[106:107], v0 offset:38128
		ds_read_b64_tr_b16 a[108:109], v0 offset:34032
		ds_read_b64_tr_b16 a[110:111], v0 offset:38384
		ds_read_b64_tr_b16 a[112:113], v0 offset:33328
		ds_read_b64_tr_b16 a[114:115], v0 offset:37680
		ds_read_b64_tr_b16 a[116:117], v0 offset:33584
		ds_read_b64_tr_b16 a[118:119], v0 offset:37936
		ds_read_b64_tr_b16 a[120:121], v0 offset:33840
		ds_read_b64_tr_b16 a[122:123], v0 offset:38192
		ds_read_b64_tr_b16 a[124:125], v0 offset:34096
		ds_read_b64_tr_b16 a[126:127], v0 offset:38448
		ds_read_b64_tr_b16 a[128:129], v0 offset:33392
		ds_read_b64_tr_b16 a[130:131], v0 offset:37744
		ds_read_b64_tr_b16 a[132:133], v0 offset:33648
		ds_read_b64_tr_b16 a[134:135], v0 offset:38000
		ds_read_b64_tr_b16 a[136:137], v0 offset:33904
		ds_read_b64_tr_b16 a[138:139], v0 offset:38256
		ds_read_b64_tr_b16 a[140:141], v0 offset:34160
		ds_read_b64_tr_b16 a[142:143], v0 offset:38512
		ds_read_b64_tr_b16 a[144:145], v0 offset:33456
		ds_read_b64_tr_b16 a[146:147], v0 offset:37808
		ds_read_b64_tr_b16 a[148:149], v0 offset:33712
		ds_read_b64_tr_b16 a[150:151], v0 offset:38064
		ds_read_b64_tr_b16 a[152:153], v0 offset:33968
		ds_read_b64_tr_b16 a[154:155], v0 offset:38320
		ds_read_b64_tr_b16 a[156:157], v0 offset:34224
		ds_read_b64_tr_b16 a[158:159], v0 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[0:3], 0
		s_mul_i32 s1, s16, s23
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
		s_lshl_b32 s1, s1, 9
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[24:27], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[28:31], a[4:7], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[36:39], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[28:31], a[36:39], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[8:11], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[8:11], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], a[12:15], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[16:19], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[20:23], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[60:63], v[240:255]
		v_mov_b32_e32 v0, 4
		v_mul_lo_u32 v0, v0, v7
		v_add_u32_e32 v5, s11, v0
		v_xad_u32 v7, 16, v0, s11
		v_xad_u32 v11, 32, v0, s11
		v_xad_u32 v0, 48, v0, s11
		v_cmp_lt_i32_e64 s[2:3], v5, s25
		v_cmp_lt_i32_e64 s[4:5], v7, s25
		v_cmp_lt_i32_e64 s[6:7], v11, s25
		v_cmp_lt_i32_e64 vcc, v0, s25
		v_cndmask_b32_e64 v16, v6, v192, s[2:3]
		v_cndmask_b32_e64 v17, v6, v193, s[2:3]
		v_cndmask_b32_e64 v20, v6, v194, s[2:3]
		v_cndmask_b32_e64 v21, v6, v195, s[2:3]
		v_cndmask_b32_e64 v24, v6, v196, s[2:3]
		v_cndmask_b32_e64 v25, v6, v197, s[2:3]
		v_cndmask_b32_e64 v26, v6, v198, s[2:3]
		v_cndmask_b32_e64 v27, v6, v199, s[2:3]
		v_cndmask_b32_e64 v28, v6, v200, s[4:5]
		v_cndmask_b32_e64 v29, v6, v201, s[4:5]
		v_cndmask_b32_e64 v30, v6, v202, s[4:5]
		v_cndmask_b32_e64 v31, v6, v203, s[4:5]
		v_cndmask_b32_e64 v32, v6, v204, s[4:5]
		v_cndmask_b32_e64 v33, v6, v205, s[4:5]
		v_cndmask_b32_e64 v38, v6, v206, s[4:5]
		v_cndmask_b32_e64 v39, v6, v207, s[4:5]
		v_cndmask_b32_e64 v40, v6, v208, s[6:7]
		v_cndmask_b32_e64 v41, v6, v209, s[6:7]
		v_cndmask_b32_e64 v42, v6, v210, s[6:7]
		v_cndmask_b32_e64 v43, v6, v211, s[6:7]
		v_cndmask_b32_e64 v44, v6, v212, s[6:7]
		v_cndmask_b32_e64 v45, v6, v213, s[6:7]
		v_cndmask_b32_e64 v46, v6, v214, s[6:7]
		v_cndmask_b32_e64 v47, v6, v215, s[6:7]
		v_cndmask_b32_e32 v176, v6, v216, vcc
		v_cndmask_b32_e32 v177, v6, v217, vcc
		v_cndmask_b32_e32 v178, v6, v218, vcc
		v_cndmask_b32_e32 v179, v6, v219, vcc
		v_cndmask_b32_e32 v180, v6, v220, vcc
		v_cndmask_b32_e32 v181, v6, v221, vcc
		v_cndmask_b32_e32 v182, v6, v222, vcc
		v_cndmask_b32_e32 v183, v6, v223, vcc
		v_cndmask_b32_e64 v184, v6, v242, s[2:3]
		v_cndmask_b32_e64 v185, v6, v243, s[2:3]
		v_cndmask_b32_e64 v186, v6, v244, s[2:3]
		v_cndmask_b32_e64 v187, v6, v245, s[2:3]
		v_cndmask_b32_e64 v188, v6, v246, s[2:3]
		v_cndmask_b32_e64 v189, v6, v247, s[2:3]
		v_cndmask_b32_e64 v190, v6, v248, s[4:5]
		v_cndmask_b32_e64 v191, v6, v249, s[4:5]
		v_cndmask_b32_e64 v192, v6, v250, s[4:5]
		v_cndmask_b32_e64 v193, v6, v251, s[4:5]
		v_cndmask_b32_e64 v194, v6, v252, s[4:5]
		v_cndmask_b32_e64 v195, v6, v253, s[4:5]
		v_cndmask_b32_e64 v196, v6, v254, s[4:5]
		v_cndmask_b32_e64 v197, v6, v255, s[4:5]
		v_cndmask_b32_e64 v198, v6, v224, s[6:7]
		v_cndmask_b32_e64 v199, v6, v225, s[6:7]
		v_cndmask_b32_e64 v200, v6, v226, s[6:7]
		v_cndmask_b32_e64 v201, v6, v227, s[6:7]
		v_cndmask_b32_e64 v202, v6, v228, s[6:7]
		v_cndmask_b32_e64 v203, v6, v229, s[6:7]
		v_cndmask_b32_e64 v204, v6, v230, s[6:7]
		v_cndmask_b32_e64 v205, v6, v231, s[6:7]
		v_cndmask_b32_e32 v206, v6, v232, vcc
		v_cndmask_b32_e32 v207, v6, v233, vcc
		v_cndmask_b32_e32 v208, v6, v234, vcc
		v_cndmask_b32_e32 v209, v6, v235, vcc
		v_cndmask_b32_e32 v210, v6, v236, vcc
		v_cndmask_b32_e32 v211, v6, v237, vcc
		v_cndmask_b32_e32 v212, v6, v238, vcc
		v_cndmask_b32_e32 v213, v6, v239, vcc
		v_max3_f32 v0, v16, v17, v20
		v_max3_f32 v5, v24, v25, v26
		v_max3_f32 v7, v28, v29, v30
		v_max3_f32 v11, v32, v33, v38
		v_max3_f32 v12, v40, v41, v42
		v_max3_f32 v14, v44, v45, v46
		v_max3_f32 v18, v176, v177, v178
		v_max3_f32 v214, v180, v181, v182
		v_max3_f32 v0, v0, v21, v5
		v_max3_f32 v5, v7, v31, v11
		v_max3_f32 v7, v12, v43, v14
		v_max3_f32 v11, v18, v179, v214
		v_max3_f32 v0, v0, v27, v5
		v_max3_f32 v5, v7, v47, v11
		v_max3_f32 v0, v0, v39, v5
		v_max_f32_e32 v214, v0, v183
		v_mov_b32_e32 v215, v214
		v_cndmask_b32_e64 v216, v6, v240, s[2:3]
		v_cndmask_b32_e64 v217, v6, v241, s[2:3]
		v_permlane32_swap_b32_e32 v214, v215
		v_max3_f32 v0, v216, v217, v184
		v_max3_f32 v5, v186, v187, v188
		v_max3_f32 v6, v190, v191, v192
		v_max3_f32 v7, v194, v195, v196
		v_max3_f32 v11, v198, v199, v200
		v_max3_f32 v12, v202, v203, v204
		v_max3_f32 v14, v206, v207, v208
		v_max3_f32 v18, v210, v211, v212
		v_max3_f32 v0, v0, v185, v5
		v_max3_f32 v5, v6, v193, v7
		v_max3_f32 v6, v11, v201, v12
		v_max3_f32 v7, v14, v209, v18
		v_max3_f32 v0, v0, v189, v5
		v_max3_f32 v5, v6, v205, v7
		v_max3_f32 v0, v0, v197, v5
		v_max_f32_e32 v6, v0, v213
		v_mov_b32_e32 v7, v6
		v_max_f32_e32 v218, v214, v215
		v_cmp_lt_i32_e64 s[2:3], v2, s25
		v_permlane32_swap_b32_e32 v6, v7
		v_max_f32_e32 v219, v6, v7
		v_pk_mul_f32 v[6:7], v[218:219], v[22:23]
		v_max_f32_e32 v214, v36, v6
		v_max_f32_e32 v215, v37, v7
		v_pk_fma_f32 v[6:7], v[16:17], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[20:21], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[24:25], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[26:27], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[28:29], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[30:31], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[32:33], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[32:33], v[38:39], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[38:39], v[40:41], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[40:41], v[42:43], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[44:45], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[46:47], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[176:177], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[22:23], v[214:215] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[216:217], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[184:185], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[206:207], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[208:209], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[210:211], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[212:213], v[22:23], v[214:215] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v22, v6
		v_exp_f32_e32 v212, v7
		v_exp_f32_e32 v6, v16
		v_exp_f32_e32 v218, v17
		v_exp_f32_e32 v16, v20
		v_exp_f32_e32 v220, v21
		v_exp_f32_e32 v20, v24
		v_exp_f32_e32 v222, v25
		v_exp_f32_e32 v24, v26
		v_exp_f32_e32 v224, v27
		v_exp_f32_e32 v26, v28
		v_exp_f32_e32 v226, v29
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v228, v31
		v_exp_f32_e32 v30, v32
		v_exp_f32_e32 v230, v33
		v_exp_f32_e32 v23, v38
		v_exp_f32_e32 v213, v39
		v_exp_f32_e32 v7, v40
		v_exp_f32_e32 v219, v41
		v_exp_f32_e32 v17, v42
		v_exp_f32_e32 v221, v43
		v_exp_f32_e32 v21, v44
		v_exp_f32_e32 v223, v45
		v_exp_f32_e32 v25, v46
		v_exp_f32_e32 v225, v47
		v_exp_f32_e32 v27, v176
		v_exp_f32_e32 v227, v177
		v_exp_f32_e32 v29, v178
		v_exp_f32_e32 v229, v179
		v_exp_f32_e32 v31, v180
		v_exp_f32_e32 v231, v181
		v_exp_f32_e32 v32, v182
		v_exp_f32_e32 v38, v183
		v_exp_f32_e32 v40, v216
		v_exp_f32_e32 v42, v217
		v_exp_f32_e32 v44, v184
		v_exp_f32_e32 v46, v185
		v_exp_f32_e32 v176, v186
		v_exp_f32_e32 v178, v187
		v_exp_f32_e32 v180, v188
		v_exp_f32_e32 v182, v189
		v_exp_f32_e32 v184, v190
		v_exp_f32_e32 v186, v191
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v192, v194
		v_exp_f32_e32 v216, v195
		v_exp_f32_e32 v33, v196
		v_exp_f32_e32 v39, v197
		v_exp_f32_e32 v41, v198
		v_exp_f32_e32 v43, v199
		v_exp_f32_e32 v45, v200
		v_exp_f32_e32 v47, v201
		v_exp_f32_e32 v177, v202
		v_exp_f32_e32 v179, v203
		v_exp_f32_e32 v181, v204
		v_exp_f32_e32 v183, v205
		v_exp_f32_e32 v185, v206
		v_exp_f32_e32 v187, v207
		v_exp_f32_e32 v189, v208
		v_exp_f32_e32 v191, v209
		v_exp_f32_e32 v193, v210
		v_exp_f32_e32 v217, v211
		v_pk_add_f32 v[194:195], v[22:23], v[212:213]
		v_pk_add_f32 v[196:197], v[6:7], v[218:219]
		v_pk_add_f32 v[198:199], v[16:17], v[220:221]
		v_pk_add_f32 v[200:201], v[20:21], v[222:223]
		v_pk_add_f32 v[202:203], v[24:25], v[224:225]
		v_pk_add_f32 v[204:205], v[26:27], v[226:227]
		v_pk_add_f32 v[206:207], v[28:29], v[228:229]
		v_pk_add_f32 v[208:209], v[30:31], v[230:231]
		v_pk_add_f32 v[194:195], v[194:195], v[196:197]
		v_pk_add_f32 v[196:197], v[198:199], v[200:201]
		v_pk_add_f32 v[198:199], v[202:203], v[204:205]
		v_pk_add_f32 v[200:201], v[206:207], v[208:209]
		v_pk_add_f32 v[194:195], v[194:195], v[196:197]
		v_pk_add_f32 v[196:197], v[198:199], v[200:201]
		v_pk_add_f32 v[198:199], v[194:195], v[196:197]
		v_add_f32_e32 v0, v198, v199
		ds_bpermute_b32 v194, v4, v0
		ds_bpermute_b32 v4, v10, v0
		v_pk_add_f32 v[10:11], v[32:33], v[38:39]
		v_pk_add_f32 v[196:197], v[40:41], v[42:43]
		v_pk_add_f32 v[198:199], v[44:45], v[46:47]
		v_pk_add_f32 v[200:201], v[176:177], v[178:179]
		v_pk_add_f32 v[202:203], v[180:181], v[182:183]
		v_pk_add_f32 v[204:205], v[184:185], v[186:187]
		v_pk_add_f32 v[206:207], v[188:189], v[190:191]
		v_pk_add_f32 v[208:209], v[192:193], v[216:217]
		v_pk_add_f32 v[10:11], v[10:11], v[196:197]
		v_pk_add_f32 v[196:197], v[198:199], v[200:201]
		v_pk_add_f32 v[198:199], v[202:203], v[204:205]
		v_pk_add_f32 v[200:201], v[206:207], v[208:209]
		v_pk_add_f32 v[10:11], v[10:11], v[196:197]
		v_pk_add_f32 v[196:197], v[198:199], v[200:201]
		v_pk_add_f32 v[198:199], v[10:11], v[196:197]
		v_mov_b32_e32 v5, v199
		v_mov_b32_e32 v195, v198
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[10:11], v[194:195], v[4:5]
		v_mov_b32_e32 v4, v11
		v_mov_b32_e32 v5, v11
		v_pk_add_f32 v[194:195], v[36:37], v[214:215] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v196, v22, v212
		v_permlane32_swap_b32_e32 v4, v5
		v_add_f32_e32 v37, v4, v5
		v_exp_f32_e32 v4, v194
		v_exp_f32_e32 v5, v195
		v_cvt_pk_bf16_f32 v197, v6, v218
		v_pk_mul_f32 v[240:241], v[48:49], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[242:243], v[50:51], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[244:245], v[52:53], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[246:247], v[54:55], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[248:249], v[56:57], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[250:251], v[58:59], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[252:253], v[60:61], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[254:255], v[62:63], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[64:65], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[66:67], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[68:69], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[70:71], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[72:73], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[74:75], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[76:77], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[78:79], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[80:81], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[82:83], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[84:85], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[86:87], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[88:89], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[90:91], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[92:93], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[94:95], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[96:97], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[82:83], v[98:99], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[84:85], v[100:101], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[86:87], v[102:103], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[88:89], v[104:105], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[90:91], v[106:107], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[92:93], v[108:109], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[94:95], v[110:111], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[96:97], v[112:113], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[98:99], v[114:115], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[100:101], v[116:117], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[102:103], v[118:119], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[104:105], v[120:121], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[106:107], v[122:123], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[108:109], v[124:125], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[110:111], v[126:127], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[112:113], v[128:129], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[130:131], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[132:133], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[134:135], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[136:137], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[138:139], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[140:141], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[142:143], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[144:145], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[146:147], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[148:149], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[150:151], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[152:153], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[154:155], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[156:157], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[158:159], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[144:145], v[160:161], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[146:147], v[162:163], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[148:149], v[164:165], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[150:151], v[166:167], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[152:153], v[168:169], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[154:155], v[170:171], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[156:157], v[172:173], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[158:159], v[174:175], v[4:5] op_sel:[0,1]
		v_mov_b32_e32 v36, v10
		v_pk_fma_f32 v[10:11], v[34:35], v[4:5], v[36:37]
		v_cvt_pk_bf16_f32 v198, v16, v220
		v_cvt_pk_bf16_f32 v199, v20, v222
		v_cvt_pk_bf16_f32 v160, v24, v224
		v_cvt_pk_bf16_f32 v161, v26, v226
		v_cvt_pk_bf16_f32 v162, v28, v228
		v_cvt_pk_bf16_f32 v163, v30, v230
		v_cvt_pk_bf16_f32 v164, v23, v213
		v_cvt_pk_bf16_f32 v165, v7, v219
		v_cvt_pk_bf16_f32 v166, v17, v221
		v_cvt_pk_bf16_f32 v167, v21, v223
		v_cvt_pk_bf16_f32 v4, v25, v225
		v_cvt_pk_bf16_f32 v5, v27, v227
		v_cvt_pk_bf16_f32 v6, v29, v229
		v_cvt_pk_bf16_f32 v7, v31, v231
		v_cvt_pk_bf16_f32 v20, v32, v38
		v_cvt_pk_bf16_f32 v21, v40, v42
		v_cvt_pk_bf16_f32 v22, v44, v46
		v_cvt_pk_bf16_f32 v23, v176, v178
		v_cvt_pk_bf16_f32 v24, v180, v182
		v_cvt_pk_bf16_f32 v25, v184, v186
		v_cvt_pk_bf16_f32 v26, v188, v190
		v_cvt_pk_bf16_f32 v27, v192, v216
		v_cvt_pk_bf16_f32 v28, v33, v39
		v_cvt_pk_bf16_f32 v29, v41, v43
		v_cvt_pk_bf16_f32 v30, v45, v47
		v_cvt_pk_bf16_f32 v31, v177, v179
		v_cvt_pk_bf16_f32 v32, v181, v183
		v_cvt_pk_bf16_f32 v33, v185, v187
		v_cvt_pk_bf16_f32 v34, v189, v191
		v_cvt_pk_bf16_f32 v35, v193, v217
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[240:255], a[96:99], v[196:199], v[240:255]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		s_mul_i32 s4, s17, s21
		s_lshl_b32 s4, s4, 1
		s_add_i32 s5, s1, s4
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[196:199], v[64:79]
		s_mul_i32 s0, s0, s22
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[196:199], v[80:95]
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[20:23], v[144:159]
		s_add_i32 s5, s5, s0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], v[20:23], v[96:111]
		v_mul_lo_u32 v0, s23, v13
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[20:23], v[112:127]
		v_mul_lo_u32 v2, s23, v15
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[20:23], v[128:143]
		v_mul_lo_u32 v9, s23, v9
		v_mfma_f32_32x32x16_bf16 v[240:255], a[100:103], v[160:163], v[240:255]
		v_mul_lo_u32 v8, s23, v8
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[160:163], v[48:63]
		v_mul_lo_u32 v12, s23, v19
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[160:163], v[64:79]
		v_mul_lo_u32 v3, s23, v3
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[160:163], v[80:95]
		v_lshl_add_u32 v13, v0, 6, s5
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[24:27], v[144:159]
		v_lshl_add_u32 v13, v2, 1, v13
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], v[24:27], v[96:111]
		v_lshl_add_u32 v13, v9, 5, v13
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[24:27], v[112:127]
		v_lshl_add_u32 v13, v8, 4, v13
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[24:27], v[128:143]
		v_lshl_add_u32 v13, v12, 3, v13
		v_mfma_f32_32x32x16_bf16 v[240:255], a[104:107], v[164:167], v[240:255]
		v_lshl_add_u32 v13, v3, 2, v13
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[164:167], v[48:63]
		v_lshl_add_u32 v13, v1, 4, v13
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], v[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[108:111], v[4:7], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[4:7], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[4:7], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[4:7], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[32:35], v[128:143]
		v_rcp_f32_e32 v4, v10
		v_rcp_f32_e32 v6, v11
		v_mov_b32_e32 v5, v4
		s_nop 1
		v_pk_mul_f32 v[10:11], v[240:241], v[4:5]
		v_pk_mul_f32 v[14:15], v[242:243], v[4:5]
		v_pk_mul_f32 v[16:17], v[244:245], v[4:5]
		v_pk_mul_f32 v[18:19], v[246:247], v[4:5]
		v_pk_mul_f32 v[20:21], v[248:249], v[4:5]
		v_pk_mul_f32 v[22:23], v[250:251], v[4:5]
		v_pk_mul_f32 v[24:25], v[252:253], v[4:5]
		v_pk_mul_f32 v[26:27], v[254:255], v[4:5]
		v_pk_mul_f32 v[28:29], v[48:49], v[4:5]
		v_pk_mul_f32 v[30:31], v[50:51], v[4:5]
		v_pk_mul_f32 v[32:33], v[52:53], v[4:5]
		v_pk_mul_f32 v[34:35], v[54:55], v[4:5]
		v_pk_mul_f32 v[36:37], v[56:57], v[4:5]
		v_pk_mul_f32 v[38:39], v[58:59], v[4:5]
		v_pk_mul_f32 v[40:41], v[60:61], v[4:5]
		v_pk_mul_f32 v[42:43], v[62:63], v[4:5]
		v_pk_mul_f32 v[44:45], v[64:65], v[4:5]
		v_pk_mul_f32 v[46:47], v[66:67], v[4:5]
		v_pk_mul_f32 v[48:49], v[68:69], v[4:5]
		v_pk_mul_f32 v[50:51], v[70:71], v[4:5]
		v_pk_mul_f32 v[52:53], v[72:73], v[4:5]
		v_pk_mul_f32 v[54:55], v[74:75], v[4:5]
		v_pk_mul_f32 v[56:57], v[76:77], v[4:5]
		v_pk_mul_f32 v[58:59], v[78:79], v[4:5]
		v_pk_mul_f32 v[60:61], v[80:81], v[4:5]
		v_pk_mul_f32 v[62:63], v[82:83], v[4:5]
		v_pk_mul_f32 v[64:65], v[84:85], v[4:5]
		v_pk_mul_f32 v[66:67], v[86:87], v[4:5]
		v_pk_mul_f32 v[68:69], v[88:89], v[4:5]
		v_pk_mul_f32 v[70:71], v[90:91], v[4:5]
		v_pk_mul_f32 v[72:73], v[92:93], v[4:5]
		v_pk_mul_f32 v[74:75], v[94:95], v[4:5]
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[4:5], v[96:97], v[6:7]
		v_pk_mul_f32 v[76:77], v[98:99], v[6:7]
		v_pk_mul_f32 v[78:79], v[100:101], v[6:7]
		v_pk_mul_f32 v[80:81], v[102:103], v[6:7]
		v_pk_mul_f32 v[82:83], v[104:105], v[6:7]
		v_pk_mul_f32 v[84:85], v[106:107], v[6:7]
		v_pk_mul_f32 v[86:87], v[108:109], v[6:7]
		v_pk_mul_f32 v[88:89], v[110:111], v[6:7]
		v_pk_mul_f32 v[90:91], v[112:113], v[6:7]
		v_pk_mul_f32 v[92:93], v[114:115], v[6:7]
		v_pk_mul_f32 v[94:95], v[116:117], v[6:7]
		v_pk_mul_f32 v[96:97], v[118:119], v[6:7]
		v_pk_mul_f32 v[98:99], v[120:121], v[6:7]
		v_pk_mul_f32 v[100:101], v[122:123], v[6:7]
		v_pk_mul_f32 v[102:103], v[124:125], v[6:7]
		v_pk_mul_f32 v[104:105], v[126:127], v[6:7]
		v_pk_mul_f32 v[106:107], v[128:129], v[6:7]
		v_pk_mul_f32 v[108:109], v[130:131], v[6:7]
		v_pk_mul_f32 v[110:111], v[132:133], v[6:7]
		v_pk_mul_f32 v[112:113], v[134:135], v[6:7]
		v_pk_mul_f32 v[114:115], v[136:137], v[6:7]
		v_pk_mul_f32 v[116:117], v[138:139], v[6:7]
		v_pk_mul_f32 v[118:119], v[140:141], v[6:7]
		v_pk_mul_f32 v[120:121], v[142:143], v[6:7]
		v_pk_mul_f32 v[122:123], v[144:145], v[6:7]
		v_pk_mul_f32 v[124:125], v[146:147], v[6:7]
		v_pk_mul_f32 v[126:127], v[148:149], v[6:7]
		v_pk_mul_f32 v[128:129], v[150:151], v[6:7]
		v_pk_mul_f32 v[130:131], v[152:153], v[6:7]
		v_pk_mul_f32 v[132:133], v[154:155], v[6:7]
		v_pk_mul_f32 v[134:135], v[156:157], v[6:7]
		v_pk_mul_f32 v[136:137], v[158:159], v[6:7]
		v_cvt_pk_bf16_f32 v140, v10, v11
		v_cvt_pk_bf16_f32 v141, v14, v15
		v_cvt_pk_bf16_f32 v142, v16, v17
		v_cvt_pk_bf16_f32 v143, v18, v19
		v_cvt_pk_bf16_f32 v16, v20, v21
		v_cvt_pk_bf16_f32 v17, v22, v23
		v_cvt_pk_bf16_f32 v18, v24, v25
		v_cvt_pk_bf16_f32 v19, v26, v27
		v_cvt_pk_bf16_f32 v20, v28, v29
		v_cvt_pk_bf16_f32 v21, v30, v31
		v_cvt_pk_bf16_f32 v22, v32, v33
		v_cvt_pk_bf16_f32 v23, v34, v35
		v_cvt_pk_bf16_f32 v24, v36, v37
		v_cvt_pk_bf16_f32 v25, v38, v39
		v_cvt_pk_bf16_f32 v26, v40, v41
		v_cvt_pk_bf16_f32 v27, v42, v43
		v_cvt_pk_bf16_f32 v28, v44, v45
		v_cvt_pk_bf16_f32 v29, v46, v47
		v_cvt_pk_bf16_f32 v30, v48, v49
		v_cvt_pk_bf16_f32 v31, v50, v51
		v_cvt_pk_bf16_f32 v32, v52, v53
		v_cvt_pk_bf16_f32 v33, v54, v55
		v_cvt_pk_bf16_f32 v34, v56, v57
		v_cvt_pk_bf16_f32 v35, v58, v59
		v_cvt_pk_bf16_f32 v36, v60, v61
		v_cvt_pk_bf16_f32 v37, v62, v63
		v_cvt_pk_bf16_f32 v38, v64, v65
		v_cvt_pk_bf16_f32 v39, v66, v67
		v_cvt_pk_bf16_f32 v40, v68, v69
		v_cvt_pk_bf16_f32 v41, v70, v71
		v_cvt_pk_bf16_f32 v42, v72, v73
		v_cvt_pk_bf16_f32 v43, v74, v75
		v_cvt_pk_bf16_f32 v44, v4, v5
		v_cvt_pk_bf16_f32 v45, v76, v77
		v_cvt_pk_bf16_f32 v46, v78, v79
		v_cvt_pk_bf16_f32 v47, v80, v81
		v_cvt_pk_bf16_f32 v4, v82, v83
		v_cvt_pk_bf16_f32 v5, v84, v85
		v_cvt_pk_bf16_f32 v6, v86, v87
		v_cvt_pk_bf16_f32 v7, v88, v89
		v_cvt_pk_bf16_f32 v48, v90, v91
		v_cvt_pk_bf16_f32 v49, v92, v93
		v_cvt_pk_bf16_f32 v50, v94, v95
		v_cvt_pk_bf16_f32 v51, v96, v97
		v_cvt_pk_bf16_f32 v52, v98, v99
		v_cvt_pk_bf16_f32 v53, v100, v101
		v_cvt_pk_bf16_f32 v54, v102, v103
		v_cvt_pk_bf16_f32 v55, v104, v105
		v_cvt_pk_bf16_f32 v56, v106, v107
		v_cvt_pk_bf16_f32 v57, v108, v109
		v_cvt_pk_bf16_f32 v58, v110, v111
		v_cvt_pk_bf16_f32 v59, v112, v113
		v_cvt_pk_bf16_f32 v60, v114, v115
		v_cvt_pk_bf16_f32 v61, v116, v117
		v_cvt_pk_bf16_f32 v62, v118, v119
		v_cvt_pk_bf16_f32 v63, v120, v121
		v_cvt_pk_bf16_f32 v64, v122, v123
		v_cvt_pk_bf16_f32 v65, v124, v125
		v_cvt_pk_bf16_f32 v66, v126, v127
		v_cvt_pk_bf16_f32 v67, v128, v129
		v_cvt_pk_bf16_f32 v68, v130, v131
		v_cvt_pk_bf16_f32 v69, v132, v133
		v_cvt_pk_bf16_f32 v70, v134, v135
		v_cvt_pk_bf16_f32 v71, v136, v137
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
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
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
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
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_16
		buffer_store_dwordx4 v[140:143], v13, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_16:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_16
.L_attn_fwd_async_prefetch.exec_endif_16:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s5, s1, 32
		s_add_i32 s5, s5, s4
		s_add_i32 s5, s5, s0
		v_lshl_add_u32 v10, v0, 6, s5
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_17
		buffer_store_dwordx4 v[16:19], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_17:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_17
.L_attn_fwd_async_prefetch.exec_endif_17:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s5, s1, 64
		s_add_i32 s5, s5, s4
		s_add_i32 s5, s5, s0
		v_lshl_add_u32 v10, v0, 6, s5
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_18
		buffer_store_dwordx4 v[20:23], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_18:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_18
.L_attn_fwd_async_prefetch.exec_endif_18:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s5, s1, 0x60
		s_add_i32 s5, s5, s4
		s_add_i32 s5, s5, s0
		v_lshl_add_u32 v10, v0, 6, s5
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_19
		buffer_store_dwordx4 v[24:27], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_19:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_19
.L_attn_fwd_async_prefetch.exec_endif_19:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s5, s1, 0x80
		s_add_i32 s5, s5, s4
		s_add_i32 s5, s5, s0
		v_lshl_add_u32 v10, v0, 6, s5
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_20
		buffer_store_dwordx4 v[28:31], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_20:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_20
.L_attn_fwd_async_prefetch.exec_endif_20:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s5, s1, 0xa0
		s_add_i32 s5, s5, s4
		s_add_i32 s5, s5, s0
		v_lshl_add_u32 v10, v0, 6, s5
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_21
		buffer_store_dwordx4 v[32:35], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_21:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_21
.L_attn_fwd_async_prefetch.exec_endif_21:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s5, s1, 0xc0
		s_add_i32 s5, s5, s4
		s_add_i32 s5, s5, s0
		v_lshl_add_u32 v10, v0, 6, s5
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_22
		buffer_store_dwordx4 v[36:39], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_22:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_22
.L_attn_fwd_async_prefetch.exec_endif_22:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s5, s1, 0xe0
		s_add_i32 s5, s5, s4
		s_add_i32 s5, s5, s0
		v_lshl_add_u32 v10, v0, 6, s5
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_23
		buffer_store_dwordx4 v[40:43], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_23:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_23
.L_attn_fwd_async_prefetch.exec_endif_23:
		s_mov_b64 exec, s[60:61]
		s_lshl_b32 s5, s23, 8
		s_add_i32 s6, s5, s1
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s0
		v_lshl_add_u32 v10, v0, 6, s6
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_24
		buffer_store_dwordx4 v[44:47], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_24:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_24
.L_attn_fwd_async_prefetch.exec_endif_24:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s6, s5, 32
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s0
		v_lshl_add_u32 v10, v0, 6, s6
		v_lshl_add_u32 v10, v2, 1, v10
		v_lshl_add_u32 v10, v9, 5, v10
		v_lshl_add_u32 v10, v8, 4, v10
		v_lshl_add_u32 v10, v12, 3, v10
		v_lshl_add_u32 v10, v3, 2, v10
		v_lshl_add_u32 v10, v1, 4, v10
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_25
		buffer_store_dwordx4 v[4:7], v10, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_25:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_25
.L_attn_fwd_async_prefetch.exec_endif_25:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s6, s5, 64
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s0
		v_lshl_add_u32 v4, v0, 6, s6
		v_lshl_add_u32 v4, v2, 1, v4
		v_lshl_add_u32 v4, v9, 5, v4
		v_lshl_add_u32 v4, v8, 4, v4
		v_lshl_add_u32 v4, v12, 3, v4
		v_lshl_add_u32 v4, v3, 2, v4
		v_lshl_add_u32 v4, v1, 4, v4
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_26
		buffer_store_dwordx4 v[48:51], v4, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_26:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_26
.L_attn_fwd_async_prefetch.exec_endif_26:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s6, s5, 0x60
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s0
		v_lshl_add_u32 v4, v0, 6, s6
		v_lshl_add_u32 v4, v2, 1, v4
		v_lshl_add_u32 v4, v9, 5, v4
		v_lshl_add_u32 v4, v8, 4, v4
		v_lshl_add_u32 v4, v12, 3, v4
		v_lshl_add_u32 v4, v3, 2, v4
		v_lshl_add_u32 v4, v1, 4, v4
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_27
		buffer_store_dwordx4 v[52:55], v4, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_27:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_27
.L_attn_fwd_async_prefetch.exec_endif_27:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s6, s5, 0x80
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s0
		v_lshl_add_u32 v4, v0, 6, s6
		v_lshl_add_u32 v4, v2, 1, v4
		v_lshl_add_u32 v4, v9, 5, v4
		v_lshl_add_u32 v4, v8, 4, v4
		v_lshl_add_u32 v4, v12, 3, v4
		v_lshl_add_u32 v4, v3, 2, v4
		v_lshl_add_u32 v4, v1, 4, v4
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_28
		buffer_store_dwordx4 v[56:59], v4, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_28:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_28
.L_attn_fwd_async_prefetch.exec_endif_28:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s6, s5, 0xa0
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s0
		v_lshl_add_u32 v4, v0, 6, s6
		v_lshl_add_u32 v4, v2, 1, v4
		v_lshl_add_u32 v4, v9, 5, v4
		v_lshl_add_u32 v4, v8, 4, v4
		v_lshl_add_u32 v4, v12, 3, v4
		v_lshl_add_u32 v4, v3, 2, v4
		v_lshl_add_u32 v4, v1, 4, v4
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_29
		buffer_store_dwordx4 v[60:63], v4, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_29:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_29
.L_attn_fwd_async_prefetch.exec_endif_29:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s6, s5, 0xc0
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s0
		v_lshl_add_u32 v4, v0, 6, s6
		v_lshl_add_u32 v4, v2, 1, v4
		v_lshl_add_u32 v4, v9, 5, v4
		v_lshl_add_u32 v4, v8, 4, v4
		v_lshl_add_u32 v4, v12, 3, v4
		v_lshl_add_u32 v4, v3, 2, v4
		v_lshl_add_u32 v4, v1, 4, v4
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_30
		buffer_store_dwordx4 v[64:67], v4, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_30:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_30
.L_attn_fwd_async_prefetch.exec_endif_30:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s5, s5, 0xe0
		s_add_i32 s1, s5, s1
		s_add_i32 s1, s1, s4
		s_add_i32 s0, s1, s0
		v_lshl_add_u32 v0, v0, 6, s0
		v_lshl_add_u32 v0, v2, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v1, 4, v0
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_31
		buffer_store_dwordx4 v[68:71], v0, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_31:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_31
.L_attn_fwd_async_prefetch.exec_endif_31:
		s_mov_b64 exec, s[60:61]
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
		.amdhsa_next_free_vgpr 416
		.amdhsa_next_free_sgpr 62
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
	.set .L_attn_fwd_async_prefetch.num_agpr, 160
	.set .L_attn_fwd_async_prefetch.numbered_sgpr, 62
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
    .sgpr_count:     62
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_async_prefetch.kd
    .uses_dynamic_stack: false
    .vgpr_count:     416
    .agpr_count:     160
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 63
    wave.regalloc.agpr.dwords: 248
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
