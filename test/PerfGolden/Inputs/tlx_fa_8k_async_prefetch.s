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
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v4, 2
		v_mul_lo_u32 v4, v4, v3
		v_lshrrev_b32_e32 v3, 2, v0
		v_and_b32_e32 v5, 1, v3
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v5, v2, v4, v6 bitop3:0x96
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v8, 8
		v_mul_lo_u32 v8, v8, v7
		v_xor_b32_e32 v5, v5, v8
		v_lshrrev_b32_e32 v7, 4, v0
		v_and_b32_e32 v9, 1, v7
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v9
		v_lshrrev_b32_e32 v11, 6, v0
		v_and_b32_e32 v12, 1, v11
		v_mov_b32_e32 v13, 32
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v5, v5, v10, v13 bitop3:0x96
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v15, 1, v14
		v_mov_b32_e32 v16, 64
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v4
		v_xor_b32_e32 v2, v2, v6
		v_bitop3_b32 v2, v2, v8, v10 bitop3:0x96
		v_xor_b32_e32 v2, v2, v13
		v_lshrrev_b32_e32 v4, 5, v0
		v_and_b32_e32 v6, 1, v4
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v6
		v_mov_b32_e32 v13, 4
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v17, v9, v8, v13 bitop3:0x96
		v_mov_b32_e32 v18, 8
		v_mul_lo_u32 v18, v18, v15
		v_xad_u32 v17, v17, v18, s1
		v_bitop3_b32 v19, 16, v9, v8 bitop3:0x96
		v_xor_b32_e32 v19, v19, v13
		v_xad_u32 v19, v19, v18, s1
		v_bitop3_b32 v20, 32, v9, v8 bitop3:0x96
		v_xor_b32_e32 v20, v20, v13
		v_xad_u32 v20, v20, v18, s1
		v_bitop3_b32 v21, 48, v9, v8 bitop3:0x96
		v_xor_b32_e32 v21, v21, v13
		v_xad_u32 v21, v21, v18, s1
		v_bitop3_b32 v22, 64, v9, v8 bitop3:0x96
		v_xor_b32_e32 v22, v22, v13
		v_xad_u32 v22, v22, v18, s1
		v_xor_b32_e32 v23, 0x50, v9
		v_xor_b32_e32 v23, v23, v8
		v_xor_b32_e32 v23, v23, v13
		v_xad_u32 v23, v23, v18, s1
		v_xor_b32_e32 v24, 0x60, v9
		v_xor_b32_e32 v24, v24, v8
		v_xor_b32_e32 v24, v24, v13
		v_xad_u32 v24, v24, v18, s1
		v_xor_b32_e32 v25, 0x70, v9
		v_xor_b32_e32 v25, v25, v8
		v_xor_b32_e32 v25, v25, v13
		v_xad_u32 v25, v25, v18, s1
		v_xor_b32_e32 v26, 0x80, v9
		v_xor_b32_e32 v26, v26, v8
		v_xor_b32_e32 v26, v26, v13
		v_xad_u32 v26, v26, v18, s1
		v_xor_b32_e32 v27, 0x90, v9
		v_xor_b32_e32 v27, v27, v8
		v_xor_b32_e32 v27, v27, v13
		v_xad_u32 v27, v27, v18, s1
		v_xor_b32_e32 v28, 0xa0, v9
		v_xor_b32_e32 v28, v28, v8
		v_xor_b32_e32 v28, v28, v13
		v_xad_u32 v28, v28, v18, s1
		v_xor_b32_e32 v29, 0xb0, v9
		v_xor_b32_e32 v29, v29, v8
		v_xor_b32_e32 v29, v29, v13
		v_xad_u32 v29, v29, v18, s1
		v_xor_b32_e32 v30, 0xc0, v9
		v_xor_b32_e32 v30, v30, v8
		v_xor_b32_e32 v30, v30, v13
		v_xad_u32 v30, v30, v18, s1
		v_xor_b32_e32 v31, 0xd0, v9
		v_xor_b32_e32 v31, v31, v8
		v_xor_b32_e32 v31, v31, v13
		v_xad_u32 v31, v31, v18, s1
		v_xor_b32_e32 v32, 0xe0, v9
		v_xor_b32_e32 v32, v32, v8
		v_xor_b32_e32 v32, v32, v13
		v_xad_u32 v32, v32, v18, s1
		v_xor_b32_e32 v9, 0xf0, v9
		v_xor_b32_e32 v8, v9, v8
		v_xor_b32_e32 v8, v8, v13
		v_xad_u32 v8, v8, v18, s1
		v_cmp_lt_i32_e64 s[26:27], v17, s25
		v_cmp_lt_i32_e64 s[28:29], v19, s25
		v_cmp_lt_i32_e64 s[30:31], v20, s25
		v_cmp_lt_i32_e64 s[32:33], v21, s25
		v_cmp_lt_i32_e64 s[34:35], v22, s25
		v_cmp_lt_i32_e64 s[36:37], v23, s25
		v_cmp_lt_i32_e64 s[38:39], v24, s25
		v_cmp_lt_i32_e64 s[40:41], v25, s25
		v_cmp_lt_i32_e64 s[42:43], v26, s25
		v_cmp_lt_i32_e64 s[44:45], v27, s25
		v_cmp_lt_i32_e64 s[46:47], v28, s25
		v_cmp_lt_i32_e64 s[48:49], v29, s25
		v_cmp_lt_i32_e64 s[50:51], v30, s25
		v_cmp_lt_i32_e64 s[52:53], v31, s25
		v_cmp_lt_i32_e64 s[54:55], v32, s25
		s_mov_b32 s58, 0x7fffffff
		s_mov_b32 s59, 0x31016000
		s_mov_b32 s56, s2
		s_mov_b32 s57, s3
		v_lshlrev_b32_e32 v9, 16, v1
		v_or_b32_e32 v20, v1, v9
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
		v_mul_lo_u32 v1, s12, v7
		v_lshl_add_u32 v9, v1, 1, s10
		v_and_b32_e32 v13, 15, v0
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_0
		buffer_load_dwordx4 v[24:27], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_1
		buffer_load_dwordx4 v[28:31], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_2
		buffer_load_dwordx4 v[32:35], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_3
		buffer_load_dwordx4 v[36:39], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_4
		buffer_load_dwordx4 v[40:43], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_5
		buffer_load_dwordx4 v[44:47], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_6
		buffer_load_dwordx4 v[48:51], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_7
		buffer_load_dwordx4 v[52:55], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_8
		buffer_load_dwordx4 v[56:59], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_9
		buffer_load_dwordx4 v[60:63], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_10
		buffer_load_dwordx4 v[64:67], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_11
		buffer_load_dwordx4 v[68:71], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_12
		buffer_load_dwordx4 v[72:75], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_13
		buffer_load_dwordx4 v[76:79], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v9, v1, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[60:61], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_14
		buffer_load_dwordx4 v[80:83], v9, s[56:59], 0 offen
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
		v_lshl_add_u32 v1, v13, 4, v1
		v_cmp_lt_i32_e64 vcc, v8, s25
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
		v_and_b32_e32 v1, 1, v4
		v_lshlrev_b32_e32 v4, 1, v1
		v_and_b32_e32 v8, 1, v11
		v_lshlrev_b32_e32 v8, 2, v8
		v_lshlrev_b32_e32 v9, 3, v14
		v_and_b32_e32 v7, 1, v7
		v_bitop3_b32 v8, v8, v9, v7 bitop3:0x96
		v_bitop3_b32 v4, v0, v4, v8 bitop3:0x96
		v_lshlrev_b32_e32 v4, 4, v4
		v_add_u32_e32 v4, 0x10000, v4
		s_waitcnt vmcnt(0)
		ds_write_b128 v4, v[24:27] offset:2480
		ds_write_b128 v4, v[28:31] offset:6576
		ds_write_b128 v4, v[32:35] offset:10672
		ds_write_b128 v4, v[36:39] offset:14768
		ds_write_b128 v4, v[40:43] offset:18864
		ds_write_b128 v4, v[44:47] offset:22960
		ds_write_b128 v4, v[48:51] offset:27056
		ds_write_b128 v4, v[52:55] offset:31152
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v15
		v_lshlrev_b32_e32 v9, 4, v13
		s_mul_i32 s2, s17, s13
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v13, 13, v11
		v_add_u32_e32 v13, 0x10000, v13
		v_and_b32_e32 v14, 63, v0
		v_lshrrev_b32_e32 v15, 4, v14
		v_and_b32_e32 v15, 1, v15
		v_lshl_add_u32 v13, v15, 12, v13
		v_lshrrev_b32_e32 v15, 5, v14
		v_and_b32_e32 v17, 15, v14
		v_lshl_add_u32 v18, v17, 4, v15
		v_and_b32_e32 v19, 3, v14
		v_lshrrev_b32_e32 v20, 1, v19
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v21, 2, v14
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 2, v21
		v_lshrrev_b32_e32 v22, 3, v17
		v_lshlrev_b32_e32 v22, 3, v22
		v_and_b32_e32 v23, 1, v19
		v_bitop3_b32 v22, v21, v22, v23 bitop3:0x96
		v_bitop3_b32 v18, v18, v20, v22 bitop3:0x96
		v_lshl_add_u32 v18, v18, 4, v13
		ds_read_b128 a[0:3], v18 offset:2480
		v_add_u32_e32 v20, 2, v15
		v_lshl_add_u32 v22, v17, 4, v20
		v_lshl_add_u32 v20, v19, 4, v20
		v_lshrrev_b32_e32 v20, 5, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v23, 7, v22
		v_lshlrev_b32_e32 v23, 3, v23
		v_and_b32_e32 v24, 1, v0
		v_bitop3_b32 v23, v21, v23, v24 bitop3:0x96
		v_bitop3_b32 v20, v22, v20, v23 bitop3:0x96
		v_lshl_add_u32 v20, v20, 4, v13
		ds_read_b128 a[4:7], v20 offset:2480
		v_add_u32_e32 v22, 4, v15
		v_lshl_add_u32 v23, v17, 4, v22
		v_lshl_add_u32 v22, v19, 4, v22
		v_lshrrev_b32_e32 v22, 5, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v25, 7, v23
		v_lshlrev_b32_e32 v25, 3, v25
		v_bitop3_b32 v25, v21, v25, v24 bitop3:0x96
		v_bitop3_b32 v22, v23, v22, v25 bitop3:0x96
		v_lshl_add_u32 v22, v22, 4, v13
		ds_read_b128 a[8:11], v22 offset:2480
		v_add_u32_e32 v23, 6, v15
		v_lshl_add_u32 v25, v17, 4, v23
		v_lshl_add_u32 v23, v19, 4, v23
		v_lshrrev_b32_e32 v23, 5, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_lshrrev_b32_e32 v26, 7, v25
		v_lshlrev_b32_e32 v26, 3, v26
		v_bitop3_b32 v26, v21, v26, v24 bitop3:0x96
		v_bitop3_b32 v23, v25, v23, v26 bitop3:0x96
		v_lshl_add_u32 v23, v23, 4, v13
		ds_read_b128 a[12:15], v23 offset:2480
		v_add_u32_e32 v25, 8, v15
		v_lshl_add_u32 v26, v17, 4, v25
		v_lshl_add_u32 v25, v19, 4, v25
		v_lshrrev_b32_e32 v25, 5, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_lshrrev_b32_e32 v27, 7, v26
		v_lshlrev_b32_e32 v27, 3, v27
		v_bitop3_b32 v27, v21, v27, v24 bitop3:0x96
		v_bitop3_b32 v25, v26, v25, v27 bitop3:0x96
		v_lshl_add_u32 v25, v25, 4, v13
		ds_read_b128 a[16:19], v25 offset:2480
		v_add_u32_e32 v26, 10, v15
		v_lshl_add_u32 v27, v17, 4, v26
		v_lshl_add_u32 v26, v19, 4, v26
		v_lshrrev_b32_e32 v26, 5, v26
		v_lshlrev_b32_e32 v26, 1, v26
		v_lshrrev_b32_e32 v28, 7, v27
		v_lshlrev_b32_e32 v28, 3, v28
		v_bitop3_b32 v28, v21, v28, v24 bitop3:0x96
		v_bitop3_b32 v26, v27, v26, v28 bitop3:0x96
		v_lshl_add_u32 v26, v26, 4, v13
		ds_read_b128 a[20:23], v26 offset:2480
		v_add_u32_e32 v27, 12, v15
		v_lshl_add_u32 v28, v17, 4, v27
		v_lshl_add_u32 v27, v19, 4, v27
		v_lshrrev_b32_e32 v27, 5, v27
		v_lshlrev_b32_e32 v27, 1, v27
		v_lshrrev_b32_e32 v29, 7, v28
		v_lshlrev_b32_e32 v29, 3, v29
		v_bitop3_b32 v29, v21, v29, v24 bitop3:0x96
		v_bitop3_b32 v27, v28, v27, v29 bitop3:0x96
		v_lshl_add_u32 v27, v27, 4, v13
		ds_read_b128 a[24:27], v27 offset:2480
		v_add_u32_e32 v28, 14, v15
		v_lshl_add_u32 v17, v17, 4, v28
		v_lshl_add_u32 v19, v19, 4, v28
		v_lshrrev_b32_e32 v19, 5, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v28, 7, v17
		v_lshlrev_b32_e32 v28, 3, v28
		v_bitop3_b32 v21, v21, v28, v24 bitop3:0x96
		v_bitop3_b32 v17, v17, v19, v21 bitop3:0x96
		v_lshl_add_u32 v13, v17, 4, v13
		ds_read_b128 a[28:31], v13 offset:2480
		s_mov_b32 s3, 63
		v_readfirstlane_b32 s4, v0
		s_mul_i32 s5, s0, s14
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[56:59] offset:2480
		ds_write_b128 v4, v[60:63] offset:6576
		ds_write_b128 v4, v[64:67] offset:10672
		ds_write_b128 v4, v[68:71] offset:14768
		ds_write_b128 v4, v[72:75] offset:18864
		ds_write_b128 v4, v[76:79] offset:22960
		ds_write_b128 v4, v[80:83] offset:27056
		ds_write_b128 v4, v[84:87] offset:31152
		v_and_b32_e32 v3, 3, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[32:35], v18 offset:2480
		ds_read_b128 a[36:39], v20 offset:2480
		ds_read_b128 a[40:43], v22 offset:2480
		ds_read_b128 a[44:47], v23 offset:2480
		ds_read_b128 a[48:51], v25 offset:2480
		ds_read_b128 a[52:55], v26 offset:2480
		ds_read_b128 a[56:59], v27 offset:2480
		ds_read_b128 a[60:63], v13 offset:2480
		s_add_i32 s6, s25, 63
		s_cmp_lt_i32 s6, 0
		s_cselect_b32 s3, s3, 0
		s_add_i32 s3, s6, s3
		s_ashr_i32 s3, s3, 6
		s_add_i32 s3, s3, -1
		s_cmp_gt_i32 s3, 0
		s_cselect_b32 s3, s3, 0
		v_mov_b32_e32 v4, 32
		v_mul_lo_u32 v4, v4, v6
		v_bitop3_b32 v13, v10, v4, v12 bitop3:0x96
		v_xor_b32_e32 v13, v13, v8
		v_bitop3_b32 v17, 4, v10, v4 bitop3:0x96
		v_bitop3_b32 v18, 8, v10, v4 bitop3:0x96
		v_bitop3_b32 v4, 12, v10, v4 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v13, s25
		v_mul_lo_u32 v10, s15, v11
		v_mul_lo_u32 v19, s15, v1
		v_lshlrev_b32_e32 v19, 6, v19
		v_lshl_add_u32 v10, v10, 1, v19
		v_mul_lo_u32 v19, s15, v7
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v10, v10, v19, v9
		s_lshl_b32 s2, s2, 1
		s_lshl_b32 s5, s5, 1
		s_add_i32 s6, s2, s5
		v_add_u32_e32 v19, s6, v10
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e32 v19, v20, v19, vcc
		s_lshr_b32 s4, s4, 6
		s_mul_i32 s6, 0x410, s4
		s_mov_b32 m0, s6
		v_xad_u32 v5, v5, v16, s1
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_lshl_b32 s7, s15, 3
		s_add_i32 s7, s7, s2
		s_add_i32 s7, s7, s5
		v_add_u32_e32 v19, s7, v10
		v_cndmask_b32_e32 v19, v20, v19, vcc
		s_add_i32 m0, m0, 0x1040
		v_xad_u32 v2, v2, v16, s1
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_lshl_b32 s1, s15, 4
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s5
		v_add_u32_e32 v16, s1, v10
		v_cndmask_b32_e32 v16, v20, v16, vcc
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s1, 24, s15
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s5
		v_add_u32_e32 v16, s1, v10
		v_cndmask_b32_e32 v16, v20, v16, vcc
		s_add_i32 m0, m0, 0x1040
		v_and_b32_e32 v14, 31, v14
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		v_bitop3_b32 v16, v18, v12, v8 bitop3:0x96
		v_mul_lo_u32 v18, s20, v11
		v_mul_lo_u32 v19, s20, v1
		v_lshlrev_b32_e32 v19, 6, v19
		v_lshl_add_u32 v18, v18, 1, v19
		v_mul_lo_u32 v19, s20, v7
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v9, v18, v19, v9
		s_mul_i32 s1, s17, s18
		s_lshl_b32 s1, s1, 1
		s_mul_i32 s7, s0, s19
		s_lshl_b32 s7, s7, 1
		s_add_i32 s10, s1, s7
		v_add_u32_e32 v18, s10, v9
		v_cndmask_b32_e32 v18, v20, v18, vcc
		s_mul_i32 s4, 0x440, s4
		s_add_i32 m0, s4, 0x81f0
		v_mov_b32_e32 v19, 0x440
		v_mul_lo_u32 v19, v19, v3
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v4, v12, v8 bitop3:0x96
		s_lshl_b32 s10, s20, 3
		s_add_i32 s10, s10, s1
		s_add_i32 s10, s10, s7
		v_add_u32_e32 v4, s10, v9
		v_cndmask_b32_e32 v4, v20, v4, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[10:11], v5, s25
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_lshl_b32 s12, s20, 4
		s_add_i32 s12, s12, s1
		s_add_i32 s12, s12, s7
		v_add_u32_e32 v4, s12, v9
		v_cndmask_b32_e32 v4, v20, v4, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[12:13], v2, s25
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_mul_i32 s14, 24, s20
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s7
		v_add_u32_e32 v2, s14, v9
		v_cndmask_b32_e32 v2, v20, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v4, v17, v12, v8 bitop3:0x96
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		s_mul_i32 s14, s3, 64
		v_mov_b32_e32 v2, 0xff800000
		v_mbcnt_lo_u32_b32 v5, -1, 0
		v_mbcnt_hi_u32_b32 v5, -1, v5
		v_and_b32_e32 v5, 31, v5
		v_add_u32_e32 v8, 32, v5
		v_mov_b32_e32 v22, 0x3e0293ee
		v_mov_b32_e32 v23, 0x3e0293ee
		s_mov_b32 s18, 0
		v_lshlrev_b32_e32 v12, 4, v15
		v_lshrrev_b32_e32 v17, 4, v14
		v_lshlrev_b32_e32 v17, 8, v17
		v_and_b32_e32 v14, 15, v14
		v_mov_b32_e32 v18, 0x410
		v_mul_lo_u32 v18, v18, v14
		v_and_b32_e32 v14, 3, v0
		v_lshlrev_b32_e32 v14, 3, v14
		v_mov_b32_e32 v21, 0x2200
		v_mul_lo_u32 v21, v21, v1
		v_lshlrev_b32_e32 v7, 5, v7
		s_lshl_b32 s19, s15, 7
		s_add_i32 s19, s19, s2
		s_add_i32 s19, s19, s5
		s_mul_i32 s24, 0x88, s15
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s5
		s_mul_i32 s26, 0x90, s15
		s_add_i32 s26, s26, s2
		s_add_i32 s26, s26, s5
		s_mul_i32 s27, 0x98, s15
		s_add_i32 s2, s27, s2
		s_add_i32 s2, s2, s5
		s_lshl_b32 s5, s20, 7
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s7
		s_mul_i32 s27, 0x88, s20
		s_add_i32 s27, s27, s1
		s_add_i32 s27, s27, s7
		s_mul_i32 s36, 0x90, s20
		s_add_i32 s36, s36, s1
		s_add_i32 s36, s36, s7
		s_mul_i32 s37, 0x98, s20
		s_add_i32 s1, s37, s1
		s_add_i32 s1, s1, s7
		v_lshlrev_b32_e32 v5, 2, v5
		v_lshlrev_b32_e32 v8, 2, v8
		s_cmp_lt_i32 0, s14
		v_mov_b32_e32 v24, 1.0
		v_mov_b32_e32 v25, 1.0
		v_mov_b32_e32 v26, 0xff800000
		v_mov_b32_e32 v27, 0xff800000
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
		s_cbranch_scc0 .L_attn_fwd_async_prefetch.loop_exit_0
.L_attn_fwd_async_prefetch.loop_head_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s7, s18, 6
		s_and_b32 s37, s7, 1
		s_mul_i32 s38, 0x4100, s37
		v_add_u32_e32 v28, s38, v12
		v_add3_u32 v28, v28, v17, v18
		ds_read_b128 v[160:163], v28
		ds_read_b128 v[164:167], v28 offset:32
		ds_read_b128 v[168:171], v28 offset:64
		ds_read_b128 v[172:175], v28 offset:96
		ds_read_b128 v[176:179], v28 offset:128
		ds_read_b128 v[180:183], v28 offset:160
		ds_read_b128 v[184:187], v28 offset:192
		ds_read_b128 a[64:67], v28 offset:224
		ds_read_b128 v[188:191], v28 offset:512
		ds_read_b128 v[192:195], v28 offset:544
		ds_read_b128 v[196:199], v28 offset:576
		ds_read_b128 v[200:203], v28 offset:608
		ds_read_b128 v[204:207], v28 offset:640
		ds_read_b128 a[68:71], v28 offset:672
		ds_read_b128 a[72:75], v28 offset:704
		ds_read_b128 a[76:79], v28 offset:736
		s_mul_i32 s37, 0x4400, s37
		v_add3_u32 v28, s37, v14, v21
		v_add3_u32 v28, v28, v7, v19
		ds_read_b64_tr_b16 a[80:81], v28 offset:33264
		ds_read_b64_tr_b16 a[82:83], v28 offset:37616
		ds_read_b64_tr_b16 a[84:85], v28 offset:33520
		ds_read_b64_tr_b16 a[86:87], v28 offset:37872
		ds_read_b64_tr_b16 a[88:89], v28 offset:33776
		ds_read_b64_tr_b16 a[90:91], v28 offset:38128
		ds_read_b64_tr_b16 a[92:93], v28 offset:34032
		ds_read_b64_tr_b16 a[94:95], v28 offset:38384
		ds_read_b64_tr_b16 a[96:97], v28 offset:33328
		ds_read_b64_tr_b16 a[98:99], v28 offset:37680
		ds_read_b64_tr_b16 a[100:101], v28 offset:33584
		ds_read_b64_tr_b16 a[102:103], v28 offset:37936
		ds_read_b64_tr_b16 a[104:105], v28 offset:33840
		ds_read_b64_tr_b16 a[106:107], v28 offset:38192
		ds_read_b64_tr_b16 a[108:109], v28 offset:34096
		ds_read_b64_tr_b16 a[110:111], v28 offset:38448
		ds_read_b64_tr_b16 a[112:113], v28 offset:33392
		ds_read_b64_tr_b16 a[114:115], v28 offset:37744
		ds_read_b64_tr_b16 a[116:117], v28 offset:33648
		ds_read_b64_tr_b16 a[118:119], v28 offset:38000
		ds_read_b64_tr_b16 a[120:121], v28 offset:33904
		ds_read_b64_tr_b16 a[122:123], v28 offset:38256
		ds_read_b64_tr_b16 a[124:125], v28 offset:34160
		ds_read_b64_tr_b16 a[126:127], v28 offset:38512
		ds_read_b64_tr_b16 a[128:129], v28 offset:33456
		ds_read_b64_tr_b16 a[130:131], v28 offset:37808
		ds_read_b64_tr_b16 a[132:133], v28 offset:33712
		ds_read_b64_tr_b16 a[134:135], v28 offset:38064
		ds_read_b64_tr_b16 a[136:137], v28 offset:33968
		ds_read_b64_tr_b16 a[138:139], v28 offset:38320
		ds_read_b64_tr_b16 a[140:141], v28 offset:34224
		ds_read_b64_tr_b16 a[142:143], v28 offset:38576
		s_mul_i32 s37, s15, s18
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s19, s37
		v_add_u32_e32 v28, s38, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v29, s37, v10
		s_add_i32 s7, s7, 1
		v_add_u32_e32 v30, s24, v29
		s_and_b32 s7, s7, 1
		v_add_u32_e32 v31, s26, v29
		s_mul_i32 s37, 0x4100, s7
		v_add_u32_e32 v29, s2, v29
		s_add_i32 s37, s6, s37
		v_mfma_f32_32x32x16_bf16 v[208:223], v[160:163], a[0:3], 0
		s_mov_b32 m0, s37
		v_mfma_f32_32x32x16_bf16 v[208:223], v[164:167], a[4:7], v[208:223]
		s_mul_i32 s37, s20, s18
		v_mfma_f32_32x32x16_bf16 v[208:223], v[168:171], a[8:11], v[208:223]
		s_add_i32 s18, s18, 64
		v_mfma_f32_32x32x16_bf16 v[208:223], v[172:175], a[12:15], v[208:223]
		v_add_u32_e32 v224, s18, v13
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[16:19], v[208:223]
		v_add_u32_e32 v225, s18, v4
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[20:23], v[208:223]
		v_add_u32_e32 v226, s18, v16
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[24:27], v[208:223]
		v_add_u32_e32 v227, s18, v3
		v_mfma_f32_32x32x16_bf16 v[240:255], v[160:163], a[32:35], 0
		v_cmp_lt_i32_e64 s[38:39], v224, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[164:167], a[36:39], v[240:255]
		v_cmp_lt_i32_e64 vcc, v227, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[168:171], a[40:43], v[240:255]
		v_cndmask_b32_e64 v28, v20, v28, s[38:39]
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[172:175], a[44:47], v[240:255]
		v_cmp_lt_i32_e64 s[40:41], v225, s25
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[42:43], v226, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[176:179], a[48:51], v[240:255]
		v_cndmask_b32_e64 v28, v20, v30, s[40:41]
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v28, v20, v31, s[42:43]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[180:183], a[52:55], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v29, v20, v29, vcc
		s_lshl_b32 s37, s37, 1
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_add_i32 s44, s5, s37
		v_mfma_f32_32x32x16_bf16 v[240:255], v[184:187], a[56:59], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v28, s44, v9
		s_mul_i32 s7, 0x4400, s7
		buffer_load_dwordx4 v29, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v28, v20, v28, s[38:39]
		s_add_i32 s7, s4, s7
		v_add_u32_e32 v29, s37, v9
		s_add_i32 m0, s7, 0x81f0
		v_add_u32_e32 v30, s27, v29
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v28, v20, v30, s[40:41]
		v_add_u32_e32 v30, s36, v29
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v30, v20, v30, s[42:43]
		v_add_u32_e32 v29, s1, v29
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		v_cndmask_b32_e32 v28, v20, v29, vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], v[188:191], a[0:3], 0
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[160:175], v[192:195], a[4:7], v[160:175]
		buffer_load_dwordx4 v30, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[196:199], a[8:11], v[160:175]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s18, s14
		v_mfma_f32_32x32x16_bf16 v[160:175], v[200:203], a[12:15], v[160:175]
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[192:195], a[36:39], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[196:199], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[200:203], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[204:207], a[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[204:207], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[68:71], a[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[68:71], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[72:75], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[72:75], a[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[64:67], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[76:79], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[60:63], v[240:255]
		s_nop 8
		v_max3_f32 v28, v208, v209, v210
		v_max3_f32 v29, v212, v213, v214
		v_max3_f32 v30, v216, v217, v218
		v_max3_f32 v31, v220, v221, v222
		v_max3_f32 v176, v160, v161, v162
		v_max3_f32 v177, v164, v165, v166
		v_max3_f32 v178, v168, v169, v170
		v_max3_f32 v179, v172, v173, v174
		v_max3_f32 v28, v28, v211, v29
		v_max3_f32 v29, v30, v219, v31
		v_max3_f32 v30, v176, v163, v177
		v_max3_f32 v31, v178, v171, v179
		v_max3_f32 v28, v28, v215, v29
		v_max3_f32 v29, v30, v167, v31
		v_max3_f32 v28, v28, v223, v29
		v_max_f32_e32 v30, v28, v175
		v_mov_b32_e32 v31, v30
		v_max3_f32 v28, v240, v241, v242
		v_max3_f32 v29, v244, v245, v246
		v_max3_f32 v176, v248, v249, v250
		v_max3_f32 v177, v252, v253, v254
		v_max3_f32 v178, v224, v225, v226
		v_max3_f32 v179, v228, v229, v230
		v_max3_f32 v180, v232, v233, v234
		v_max3_f32 v181, v236, v237, v238
		v_max3_f32 v28, v28, v243, v29
		v_max3_f32 v29, v176, v251, v177
		v_max3_f32 v176, v178, v227, v179
		v_max3_f32 v177, v180, v235, v181
		v_max3_f32 v28, v28, v247, v29
		v_max3_f32 v29, v176, v231, v177
		v_max3_f32 v28, v28, v255, v29
		v_max_f32_e32 v176, v28, v239
		v_permlane32_swap_b32_e32 v30, v31
		v_mov_b32_e32 v177, v176
		v_max_f32_e32 v28, v30, v31
		s_nop 0
		v_permlane32_swap_b32_e32 v176, v177
		v_max_f32_e32 v29, v176, v177
		v_pk_mul_f32 v[30:31], v[28:29], v[22:23]
		v_max_f32_e32 v28, v26, v30
		v_max_f32_e32 v29, v27, v31
		v_pk_fma_f32 v[30:31], v[208:209], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[210:211], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[212:213], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[214:215], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[216:217], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[218:219], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[220:221], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[222:223], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[160:161], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[22:23], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[240:241], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[242:243], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[244:245], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[246:247], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[248:249], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[250:251], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[252:253], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[254:255], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[224:225], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[226:227], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[228:229], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[230:231], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[232:233], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[234:235], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[236:237], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[238:239], v[22:23], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v222, v30
		v_exp_f32_e32 v224, v31
		v_exp_f32_e32 v30, v176
		v_exp_f32_e32 v226, v177
		v_exp_f32_e32 v176, v178
		v_exp_f32_e32 v228, v179
		v_exp_f32_e32 v178, v180
		v_exp_f32_e32 v230, v181
		v_exp_f32_e32 v180, v182
		v_exp_f32_e32 v232, v183
		v_exp_f32_e32 v182, v184
		v_exp_f32_e32 v234, v185
		v_exp_f32_e32 v184, v186
		v_exp_f32_e32 v236, v187
		v_exp_f32_e32 v186, v188
		v_exp_f32_e32 v238, v189
		v_exp_f32_e32 v223, v190
		v_exp_f32_e32 v225, v191
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v227, v161
		v_exp_f32_e32 v177, v162
		v_exp_f32_e32 v229, v163
		v_exp_f32_e32 v179, v164
		v_exp_f32_e32 v231, v165
		v_exp_f32_e32 v181, v166
		v_exp_f32_e32 v233, v167
		v_exp_f32_e32 v183, v168
		v_exp_f32_e32 v235, v169
		v_exp_f32_e32 v185, v170
		v_exp_f32_e32 v237, v171
		v_exp_f32_e32 v187, v172
		v_exp_f32_e32 v239, v173
		v_exp_f32_e32 v160, v174
		v_exp_f32_e32 v162, v175
		v_exp_f32_e32 v164, v192
		v_exp_f32_e32 v166, v193
		v_exp_f32_e32 v168, v194
		v_exp_f32_e32 v170, v195
		v_exp_f32_e32 v172, v196
		v_exp_f32_e32 v174, v197
		v_exp_f32_e32 v188, v198
		v_exp_f32_e32 v190, v199
		v_exp_f32_e32 v192, v200
		v_exp_f32_e32 v194, v201
		v_exp_f32_e32 v196, v202
		v_exp_f32_e32 v198, v203
		v_exp_f32_e32 v200, v204
		v_exp_f32_e32 v202, v205
		v_exp_f32_e32 v161, v206
		v_exp_f32_e32 v163, v207
		v_exp_f32_e32 v165, v208
		v_exp_f32_e32 v167, v209
		v_exp_f32_e32 v169, v210
		v_exp_f32_e32 v171, v211
		v_exp_f32_e32 v173, v212
		v_exp_f32_e32 v175, v213
		v_exp_f32_e32 v189, v214
		v_exp_f32_e32 v191, v215
		v_exp_f32_e32 v193, v216
		v_exp_f32_e32 v195, v217
		v_exp_f32_e32 v197, v218
		v_exp_f32_e32 v199, v219
		v_exp_f32_e32 v201, v220
		v_exp_f32_e32 v203, v221
		v_pk_add_f32 v[204:205], v[222:223], v[224:225]
		v_pk_add_f32 v[206:207], v[30:31], v[226:227]
		v_pk_add_f32 v[208:209], v[176:177], v[228:229]
		v_pk_add_f32 v[210:211], v[178:179], v[230:231]
		v_pk_add_f32 v[212:213], v[180:181], v[232:233]
		v_pk_add_f32 v[214:215], v[182:183], v[234:235]
		v_pk_add_f32 v[216:217], v[184:185], v[236:237]
		v_pk_add_f32 v[218:219], v[186:187], v[238:239]
		v_pk_add_f32 v[204:205], v[204:205], v[206:207]
		v_pk_add_f32 v[206:207], v[208:209], v[210:211]
		v_pk_add_f32 v[208:209], v[212:213], v[214:215]
		v_pk_add_f32 v[210:211], v[216:217], v[218:219]
		v_pk_add_f32 v[204:205], v[204:205], v[206:207]
		v_pk_add_f32 v[206:207], v[208:209], v[210:211]
		v_pk_add_f32 v[208:209], v[204:205], v[206:207]
		v_add_f32_e32 v204, v208, v209
		ds_bpermute_b32 v206, v5, v204
		ds_bpermute_b32 v208, v8, v204
		v_pk_add_f32 v[204:205], v[160:161], v[162:163]
		v_pk_add_f32 v[210:211], v[164:165], v[166:167]
		v_pk_add_f32 v[212:213], v[168:169], v[170:171]
		v_pk_add_f32 v[214:215], v[172:173], v[174:175]
		v_pk_add_f32 v[216:217], v[188:189], v[190:191]
		v_pk_add_f32 v[218:219], v[192:193], v[194:195]
		v_pk_add_f32 v[220:221], v[196:197], v[198:199]
		v_pk_add_f32 v[240:241], v[200:201], v[202:203]
		v_pk_add_f32 v[204:205], v[204:205], v[210:211]
		v_pk_add_f32 v[210:211], v[212:213], v[214:215]
		v_pk_add_f32 v[212:213], v[216:217], v[218:219]
		v_pk_add_f32 v[214:215], v[220:221], v[240:241]
		v_pk_add_f32 v[204:205], v[204:205], v[210:211]
		v_pk_add_f32 v[210:211], v[212:213], v[214:215]
		v_pk_add_f32 v[212:213], v[204:205], v[210:211]
		v_mov_b32_e32 v209, v213
		v_mov_b32_e32 v207, v212
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[204:205], v[206:207], v[208:209]
		v_mov_b32_e32 v206, v205
		v_mov_b32_e32 v207, v205
		v_pk_add_f32 v[208:209], v[26:27], v[28:29] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v212, v222, v224
		v_permlane32_swap_b32_e32 v206, v207
		v_add_f32_e32 v27, v206, v207
		v_exp_f32_e32 v206, v208
		v_exp_f32_e32 v207, v209
		v_cvt_pk_bf16_f32 v213, v30, v226
		v_mov_b32_e32 v26, v204
		v_pk_fma_f32 v[24:25], v[24:25], v[206:207], v[26:27]
		v_cvt_pk_bf16_f32 v214, v176, v228
		v_cvt_pk_bf16_f32 v215, v178, v230
		v_cvt_pk_bf16_f32 v208, v180, v232
		v_cvt_pk_bf16_f32 v209, v182, v234
		v_cvt_pk_bf16_f32 v210, v184, v236
		v_cvt_pk_bf16_f32 v211, v186, v238
		v_cvt_pk_bf16_f32 v216, v223, v225
		v_cvt_pk_bf16_f32 v217, v31, v227
		v_cvt_pk_bf16_f32 v218, v177, v229
		v_cvt_pk_bf16_f32 v219, v179, v231
		v_cvt_pk_bf16_f32 v176, v181, v233
		v_cvt_pk_bf16_f32 v177, v183, v235
		v_cvt_pk_bf16_f32 v178, v185, v237
		v_cvt_pk_bf16_f32 v179, v187, v239
		v_pk_mul_f32 v[32:33], v[32:33], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[66:67], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[68:69], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[70:71], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[72:73], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[74:75], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[76:77], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[78:79], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[80:81], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[82:83], v[82:83], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[84:85], v[84:85], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[86:87], v[86:87], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[88:89], v[88:89], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[90:91], v[90:91], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[92:93], v[92:93], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[94:95], v[94:95], v[206:207] op_sel_hi:[1,0]
		v_pk_mul_f32 v[96:97], v[96:97], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[98:99], v[98:99], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[100:101], v[100:101], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[102:103], v[102:103], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[104:105], v[104:105], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[106:107], v[106:107], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[108:109], v[108:109], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[110:111], v[110:111], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[112:113], v[112:113], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[114:115], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[116:117], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[118:119], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[120:121], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[122:123], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[124:125], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[126:127], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[128:129], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[130:131], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[132:133], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[134:135], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[136:137], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[138:139], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[140:141], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[142:143], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[144:145], v[144:145], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[146:147], v[146:147], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[148:149], v[148:149], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[150:151], v[150:151], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[152:153], v[152:153], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[154:155], v[154:155], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[156:157], v[156:157], v[206:207] op_sel:[0,1]
		v_pk_mul_f32 v[158:159], v[158:159], v[206:207] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v180, v160, v162
		v_cvt_pk_bf16_f32 v181, v164, v166
		v_cvt_pk_bf16_f32 v182, v168, v170
		v_cvt_pk_bf16_f32 v183, v172, v174
		v_cvt_pk_bf16_f32 v184, v188, v190
		v_cvt_pk_bf16_f32 v185, v192, v194
		v_cvt_pk_bf16_f32 v186, v196, v198
		v_cvt_pk_bf16_f32 v187, v200, v202
		v_cvt_pk_bf16_f32 v204, v161, v163
		v_cvt_pk_bf16_f32 v205, v165, v167
		v_cvt_pk_bf16_f32 v206, v169, v171
		v_cvt_pk_bf16_f32 v207, v173, v175
		v_cvt_pk_bf16_f32 v160, v189, v191
		v_cvt_pk_bf16_f32 v161, v193, v195
		v_cvt_pk_bf16_f32 v162, v197, v199
		v_cvt_pk_bf16_f32 v163, v201, v203
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[32:47], a[80:83], v[212:215], v[32:47]
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[212:215], v[48:63]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[212:215], v[64:79]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[212:215], v[80:95]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], v[180:183], v[144:159]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], v[180:183], v[96:111]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], v[180:183], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], v[180:183], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[84:87], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[100:103], v[208:211], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[208:211], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[132:135], v[184:187], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], v[184:187], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[100:103], v[184:187], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[116:119], v[184:187], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[88:91], v[216:219], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[104:107], v[216:219], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[136:139], v[204:207], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[88:91], v[204:207], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[104:107], v[204:207], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[120:123], v[204:207], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[176:179], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[108:111], v[176:179], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[176:179], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[176:179], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[140:143], v[160:163], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[92:95], v[160:163], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[108:111], v[160:163], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[124:127], v[160:163], v[128:143]
		v_mov_b32_e32 v26, v28
		v_mov_b32_e32 v27, v29
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s58
		s_mov_b32 s7, s59
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s3, 1
		s_mul_i32 s2, 0x4100, s1
		v_lshl_add_u32 v3, v15, 4, s2
		v_add3_u32 v3, v3, v17, v18
		ds_read_b128 v[28:31], v3
		ds_read_b128 v[160:163], v3 offset:32
		ds_read_b128 v[164:167], v3 offset:64
		ds_read_b128 v[168:171], v3 offset:96
		ds_read_b128 a[64:67], v3 offset:128
		ds_read_b128 a[68:71], v3 offset:160
		ds_read_b128 a[72:75], v3 offset:192
		ds_read_b128 a[76:79], v3 offset:224
		ds_read_b128 v[172:175], v3 offset:512
		ds_read_b128 v[176:179], v3 offset:544
		ds_read_b128 v[180:183], v3 offset:576
		ds_read_b128 v[184:187], v3 offset:608
		ds_read_b128 v[188:191], v3 offset:640
		ds_read_b128 a[80:83], v3 offset:672
		ds_read_b128 a[84:87], v3 offset:704
		ds_read_b128 a[88:91], v3 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_add3_u32 v3, s1, v14, v21
		v_add3_u32 v3, v3, v7, v19
		ds_read_b64_tr_b16 a[92:93], v3 offset:33264
		ds_read_b64_tr_b16 a[94:95], v3 offset:37616
		ds_read_b64_tr_b16 a[96:97], v3 offset:33520
		ds_read_b64_tr_b16 a[98:99], v3 offset:37872
		ds_read_b64_tr_b16 a[100:101], v3 offset:33776
		ds_read_b64_tr_b16 a[102:103], v3 offset:38128
		ds_read_b64_tr_b16 a[104:105], v3 offset:34032
		ds_read_b64_tr_b16 a[106:107], v3 offset:38384
		ds_read_b64_tr_b16 a[108:109], v3 offset:33328
		ds_read_b64_tr_b16 a[110:111], v3 offset:37680
		ds_read_b64_tr_b16 a[112:113], v3 offset:33584
		ds_read_b64_tr_b16 a[114:115], v3 offset:37936
		ds_read_b64_tr_b16 a[116:117], v3 offset:33840
		ds_read_b64_tr_b16 a[118:119], v3 offset:38192
		ds_read_b64_tr_b16 a[120:121], v3 offset:34096
		ds_read_b64_tr_b16 a[122:123], v3 offset:38448
		ds_read_b64_tr_b16 a[124:125], v3 offset:33392
		ds_read_b64_tr_b16 a[126:127], v3 offset:37744
		ds_read_b64_tr_b16 a[128:129], v3 offset:33648
		ds_read_b64_tr_b16 a[130:131], v3 offset:38000
		ds_read_b64_tr_b16 a[132:133], v3 offset:33904
		ds_read_b64_tr_b16 a[134:135], v3 offset:38256
		ds_read_b64_tr_b16 a[136:137], v3 offset:34160
		ds_read_b64_tr_b16 a[138:139], v3 offset:38512
		ds_read_b64_tr_b16 a[140:141], v3 offset:33456
		ds_read_b64_tr_b16 a[142:143], v3 offset:37808
		ds_read_b64_tr_b16 a[144:145], v3 offset:33712
		ds_read_b64_tr_b16 a[146:147], v3 offset:38064
		ds_read_b64_tr_b16 a[148:149], v3 offset:33968
		ds_read_b64_tr_b16 a[150:151], v3 offset:38320
		ds_read_b64_tr_b16 a[152:153], v3 offset:34224
		ds_read_b64_tr_b16 a[154:155], v3 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[28:31], a[0:3], 0
		s_mul_i32 s1, s16, s23
		v_mfma_f32_32x32x16_bf16 v[208:223], v[172:175], a[0:3], 0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[172:175], a[32:35], 0
		v_and_b32_e32 v0, 31, v0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[28:31], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[160:163], a[4:7], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[4:7], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[36:39], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[160:163], a[36:39], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[164:167], a[8:11], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[8:11], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[164:167], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[168:171], a[12:15], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[168:171], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[16:19], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[20:23], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[60:63], v[240:255]
		v_mov_b32_e32 v3, 4
		v_mul_lo_u32 v3, v3, v6
		v_add_u32_e32 v4, s14, v3
		v_xad_u32 v6, 16, v3, s14
		v_xad_u32 v7, 32, v3, s14
		v_xad_u32 v3, 48, v3, s14
		v_cmp_lt_i32_e64 s[2:3], v4, s25
		v_cmp_lt_i32_e64 s[8:9], v6, s25
		v_cmp_lt_i32_e64 s[14:15], v7, s25
		v_cmp_lt_i32_e64 vcc, v3, s25
		v_cndmask_b32_e64 v6, v2, v192, s[2:3]
		v_cndmask_b32_e64 v7, v2, v193, s[2:3]
		v_cndmask_b32_e64 v12, v2, v194, s[2:3]
		v_cndmask_b32_e64 v13, v2, v195, s[2:3]
		v_cndmask_b32_e64 v14, v2, v196, s[2:3]
		v_cndmask_b32_e64 v15, v2, v197, s[2:3]
		v_cndmask_b32_e64 v16, v2, v198, s[2:3]
		v_cndmask_b32_e64 v17, v2, v199, s[2:3]
		v_cndmask_b32_e64 v18, v2, v200, s[8:9]
		v_cndmask_b32_e64 v19, v2, v201, s[8:9]
		v_cndmask_b32_e64 v20, v2, v202, s[8:9]
		v_cndmask_b32_e64 v21, v2, v203, s[8:9]
		v_cndmask_b32_e64 v28, v2, v204, s[8:9]
		v_cndmask_b32_e64 v29, v2, v205, s[8:9]
		v_cndmask_b32_e64 v30, v2, v206, s[8:9]
		v_cndmask_b32_e64 v31, v2, v207, s[8:9]
		v_cndmask_b32_e64 v160, v2, v208, s[14:15]
		v_cndmask_b32_e64 v161, v2, v209, s[14:15]
		v_cndmask_b32_e64 v162, v2, v210, s[14:15]
		v_cndmask_b32_e64 v163, v2, v211, s[14:15]
		v_cndmask_b32_e64 v164, v2, v212, s[14:15]
		v_cndmask_b32_e64 v165, v2, v213, s[14:15]
		v_cndmask_b32_e64 v166, v2, v214, s[14:15]
		v_cndmask_b32_e64 v167, v2, v215, s[14:15]
		v_cndmask_b32_e32 v168, v2, v216, vcc
		v_cndmask_b32_e32 v169, v2, v217, vcc
		v_cndmask_b32_e32 v170, v2, v218, vcc
		v_cndmask_b32_e32 v171, v2, v219, vcc
		v_cndmask_b32_e32 v172, v2, v220, vcc
		v_cndmask_b32_e32 v173, v2, v221, vcc
		v_cndmask_b32_e32 v174, v2, v222, vcc
		v_cndmask_b32_e32 v175, v2, v223, vcc
		v_cndmask_b32_e64 v176, v2, v242, s[2:3]
		v_cndmask_b32_e64 v177, v2, v243, s[2:3]
		v_cndmask_b32_e64 v178, v2, v244, s[2:3]
		v_cndmask_b32_e64 v179, v2, v245, s[2:3]
		v_cndmask_b32_e64 v180, v2, v246, s[2:3]
		v_cndmask_b32_e64 v181, v2, v247, s[2:3]
		v_cndmask_b32_e64 v182, v2, v248, s[8:9]
		v_cndmask_b32_e64 v183, v2, v249, s[8:9]
		v_cndmask_b32_e64 v184, v2, v250, s[8:9]
		v_cndmask_b32_e64 v185, v2, v251, s[8:9]
		v_cndmask_b32_e64 v186, v2, v252, s[8:9]
		v_cndmask_b32_e64 v187, v2, v253, s[8:9]
		v_cndmask_b32_e64 v188, v2, v254, s[8:9]
		v_cndmask_b32_e64 v189, v2, v255, s[8:9]
		v_cndmask_b32_e64 v190, v2, v224, s[14:15]
		v_cndmask_b32_e64 v191, v2, v225, s[14:15]
		v_cndmask_b32_e64 v192, v2, v226, s[14:15]
		v_cndmask_b32_e64 v193, v2, v227, s[14:15]
		v_cndmask_b32_e64 v194, v2, v228, s[14:15]
		v_cndmask_b32_e64 v195, v2, v229, s[14:15]
		v_cndmask_b32_e64 v196, v2, v230, s[14:15]
		v_cndmask_b32_e64 v197, v2, v231, s[14:15]
		v_cndmask_b32_e32 v198, v2, v232, vcc
		v_cndmask_b32_e32 v199, v2, v233, vcc
		v_cndmask_b32_e32 v200, v2, v234, vcc
		v_cndmask_b32_e32 v201, v2, v235, vcc
		v_cndmask_b32_e32 v202, v2, v236, vcc
		v_cndmask_b32_e32 v203, v2, v237, vcc
		v_cndmask_b32_e32 v204, v2, v238, vcc
		v_cndmask_b32_e32 v205, v2, v239, vcc
		v_max3_f32 v3, v6, v7, v12
		v_max3_f32 v4, v14, v15, v16
		v_max3_f32 v9, v18, v19, v20
		v_max3_f32 v10, v28, v29, v30
		v_max3_f32 v206, v160, v161, v162
		v_max3_f32 v207, v164, v165, v166
		v_max3_f32 v208, v168, v169, v170
		v_max3_f32 v209, v172, v173, v174
		v_max3_f32 v3, v3, v13, v4
		v_max3_f32 v4, v9, v21, v10
		v_max3_f32 v9, v206, v163, v207
		v_max3_f32 v10, v208, v171, v209
		v_max3_f32 v3, v3, v17, v4
		v_max3_f32 v4, v9, v167, v10
		v_max3_f32 v3, v3, v31, v4
		v_max_f32_e32 v206, v3, v175
		v_mov_b32_e32 v207, v206
		v_cndmask_b32_e64 v208, v2, v240, s[2:3]
		v_cndmask_b32_e64 v209, v2, v241, s[2:3]
		v_permlane32_swap_b32_e32 v206, v207
		v_max3_f32 v2, v208, v209, v176
		v_max3_f32 v3, v178, v179, v180
		v_max3_f32 v4, v182, v183, v184
		v_max3_f32 v9, v186, v187, v188
		v_max3_f32 v10, v190, v191, v192
		v_max3_f32 v210, v194, v195, v196
		v_max3_f32 v211, v198, v199, v200
		v_max3_f32 v212, v202, v203, v204
		v_max3_f32 v2, v2, v177, v3
		v_max3_f32 v3, v4, v185, v9
		v_max3_f32 v4, v10, v193, v210
		v_max3_f32 v9, v211, v201, v212
		v_max3_f32 v2, v2, v181, v3
		v_max3_f32 v3, v4, v197, v9
		v_max3_f32 v2, v2, v189, v3
		v_max_f32_e32 v210, v2, v205
		v_mov_b32_e32 v211, v210
		v_max_f32_e32 v2, v206, v207
		s_lshl_b32 s1, s1, 9
		v_permlane32_swap_b32_e32 v210, v211
		v_max_f32_e32 v3, v210, v211
		v_pk_mul_f32 v[206:207], v[2:3], v[22:23]
		v_max_f32_e32 v2, v26, v206
		v_max_f32_e32 v3, v27, v207
		v_pk_fma_f32 v[206:207], v[6:7], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[6:7], v[12:13], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[14:15], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[14:15], v[16:17], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[18:19], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[20:21], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[28:29], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[30:31], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[160:161], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[22:23], v[2:3] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[208:209], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[176:177], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[22:23], v[2:3] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v22, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v206, v6
		v_exp_f32_e32 v210, v7
		v_exp_f32_e32 v6, v12
		v_exp_f32_e32 v212, v13
		v_exp_f32_e32 v12, v14
		v_exp_f32_e32 v214, v15
		v_exp_f32_e32 v14, v16
		v_exp_f32_e32 v216, v17
		v_exp_f32_e32 v16, v18
		v_exp_f32_e32 v218, v19
		v_exp_f32_e32 v18, v20
		v_exp_f32_e32 v220, v21
		v_exp_f32_e32 v20, v28
		v_exp_f32_e32 v222, v29
		v_exp_f32_e32 v23, v30
		v_exp_f32_e32 v205, v31
		v_exp_f32_e32 v207, v160
		v_exp_f32_e32 v211, v161
		v_exp_f32_e32 v7, v162
		v_exp_f32_e32 v213, v163
		v_exp_f32_e32 v13, v164
		v_exp_f32_e32 v215, v165
		v_exp_f32_e32 v15, v166
		v_exp_f32_e32 v217, v167
		v_exp_f32_e32 v17, v168
		v_exp_f32_e32 v219, v169
		v_exp_f32_e32 v19, v170
		v_exp_f32_e32 v221, v171
		v_exp_f32_e32 v21, v172
		v_exp_f32_e32 v223, v173
		v_exp_f32_e32 v28, v174
		v_exp_f32_e32 v30, v175
		v_exp_f32_e32 v160, v208
		v_exp_f32_e32 v162, v209
		v_exp_f32_e32 v164, v176
		v_exp_f32_e32 v166, v177
		v_exp_f32_e32 v168, v178
		v_exp_f32_e32 v170, v179
		v_exp_f32_e32 v172, v180
		v_exp_f32_e32 v174, v181
		v_exp_f32_e32 v176, v182
		v_exp_f32_e32 v178, v183
		v_exp_f32_e32 v180, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v184, v186
		v_exp_f32_e32 v208, v187
		v_exp_f32_e32 v29, v188
		v_exp_f32_e32 v31, v189
		v_exp_f32_e32 v161, v190
		v_exp_f32_e32 v163, v191
		v_exp_f32_e32 v165, v192
		v_exp_f32_e32 v167, v193
		v_exp_f32_e32 v169, v194
		v_exp_f32_e32 v171, v195
		v_exp_f32_e32 v173, v196
		v_exp_f32_e32 v175, v197
		v_exp_f32_e32 v177, v198
		v_exp_f32_e32 v179, v199
		v_exp_f32_e32 v181, v200
		v_exp_f32_e32 v183, v201
		v_exp_f32_e32 v185, v202
		v_exp_f32_e32 v209, v203
		v_pk_add_f32 v[186:187], v[22:23], v[204:205]
		v_pk_add_f32 v[188:189], v[206:207], v[210:211]
		v_pk_add_f32 v[190:191], v[6:7], v[212:213]
		v_pk_add_f32 v[192:193], v[12:13], v[214:215]
		v_pk_add_f32 v[194:195], v[14:15], v[216:217]
		v_pk_add_f32 v[196:197], v[16:17], v[218:219]
		v_pk_add_f32 v[198:199], v[18:19], v[220:221]
		v_pk_add_f32 v[200:201], v[20:21], v[222:223]
		v_pk_add_f32 v[186:187], v[186:187], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[186:187], v[186:187], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[186:187], v[188:189]
		v_add_f32_e32 v4, v190, v191
		ds_bpermute_b32 v186, v5, v4
		ds_bpermute_b32 v188, v8, v4
		v_pk_add_f32 v[4:5], v[28:29], v[30:31]
		v_pk_add_f32 v[8:9], v[160:161], v[162:163]
		v_pk_add_f32 v[190:191], v[164:165], v[166:167]
		v_pk_add_f32 v[192:193], v[168:169], v[170:171]
		v_pk_add_f32 v[194:195], v[172:173], v[174:175]
		v_pk_add_f32 v[196:197], v[176:177], v[178:179]
		v_pk_add_f32 v[198:199], v[180:181], v[182:183]
		v_pk_add_f32 v[200:201], v[184:185], v[208:209]
		v_pk_add_f32 v[4:5], v[4:5], v[8:9]
		v_pk_add_f32 v[8:9], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[4:5], v[4:5], v[8:9]
		v_pk_add_f32 v[8:9], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[4:5], v[8:9]
		v_mov_b32_e32 v189, v191
		v_mov_b32_e32 v187, v190
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[4:5], v[186:187], v[188:189]
		v_mov_b32_e32 v8, v5
		v_mov_b32_e32 v9, v5
		v_pk_add_f32 v[186:187], v[26:27], v[2:3] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v188, v22, v204
		v_permlane32_swap_b32_e32 v8, v9
		v_add_f32_e32 v3, v8, v9
		v_exp_f32_e32 v8, v186
		v_exp_f32_e32 v9, v187
		v_cvt_pk_bf16_f32 v189, v206, v210
		v_pk_mul_f32 v[224:225], v[32:33], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[226:227], v[34:35], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[228:229], v[36:37], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[230:231], v[38:39], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[232:233], v[40:41], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[234:235], v[42:43], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[236:237], v[44:45], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[238:239], v[46:47], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[32:33], v[48:49], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[50:51], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[52:53], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[54:55], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[56:57], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[58:59], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[60:61], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[62:63], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[64:65], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[66:67], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[68:69], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[70:71], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[72:73], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[74:75], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[76:77], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[78:79], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[80:81], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[82:83], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[84:85], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[86:87], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[88:89], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[90:91], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[92:93], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[94:95], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[96:97], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[98:99], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[100:101], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[102:103], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[104:105], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[106:107], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[108:109], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[110:111], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[96:97], v[112:113], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[98:99], v[114:115], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[100:101], v[116:117], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[102:103], v[118:119], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[104:105], v[120:121], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[106:107], v[122:123], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[108:109], v[124:125], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[110:111], v[126:127], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[112:113], v[128:129], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[130:131], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[132:133], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[134:135], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[136:137], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[138:139], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[140:141], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[142:143], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[144:145], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[146:147], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[148:149], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[150:151], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[152:153], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[154:155], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[156:157], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[158:159], v[8:9] op_sel:[0,1]
		v_mov_b32_e32 v2, v4
		v_pk_fma_f32 v[4:5], v[24:25], v[8:9], v[2:3]
		v_cvt_pk_bf16_f32 v190, v6, v212
		v_cvt_pk_bf16_f32 v191, v12, v214
		v_cvt_pk_bf16_f32 v24, v14, v216
		v_cvt_pk_bf16_f32 v25, v16, v218
		v_cvt_pk_bf16_f32 v26, v18, v220
		v_cvt_pk_bf16_f32 v27, v20, v222
		v_cvt_pk_bf16_f32 v144, v23, v205
		v_cvt_pk_bf16_f32 v145, v207, v211
		v_cvt_pk_bf16_f32 v146, v7, v213
		v_cvt_pk_bf16_f32 v147, v13, v215
		v_cvt_pk_bf16_f32 v148, v15, v217
		v_cvt_pk_bf16_f32 v149, v17, v219
		v_cvt_pk_bf16_f32 v150, v19, v221
		v_cvt_pk_bf16_f32 v151, v21, v223
		v_cvt_pk_bf16_f32 v12, v28, v30
		v_cvt_pk_bf16_f32 v13, v160, v162
		v_cvt_pk_bf16_f32 v14, v164, v166
		v_cvt_pk_bf16_f32 v15, v168, v170
		v_cvt_pk_bf16_f32 v16, v172, v174
		v_cvt_pk_bf16_f32 v17, v176, v178
		v_cvt_pk_bf16_f32 v18, v180, v182
		v_cvt_pk_bf16_f32 v19, v184, v208
		v_cvt_pk_bf16_f32 v20, v29, v31
		v_cvt_pk_bf16_f32 v21, v161, v163
		v_cvt_pk_bf16_f32 v22, v165, v167
		v_cvt_pk_bf16_f32 v23, v169, v171
		v_cvt_pk_bf16_f32 v28, v173, v175
		v_cvt_pk_bf16_f32 v29, v177, v179
		v_cvt_pk_bf16_f32 v30, v181, v183
		v_cvt_pk_bf16_f32 v31, v185, v209
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], v[188:191], v[224:239]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		s_mul_i32 s2, s17, s21
		s_lshl_b32 s2, s2, 1
		s_add_i32 s3, s1, s2
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[188:191], v[48:63]
		s_mul_i32 s0, s0, s22
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[188:191], v[64:79]
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[12:15], v[128:143]
		s_add_i32 s3, s3, s0
		v_mfma_f32_32x32x16_bf16 v[80:95], a[92:95], v[12:15], v[80:95]
		v_mul_lo_u32 v2, s23, v11
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[12:15], v[96:111]
		v_mul_lo_u32 v0, s23, v0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[12:15], v[112:127]
		v_lshl_add_u32 v3, v2, 6, s3
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], v[24:27], v[224:239]
		v_lshl_add_u32 v3, v0, 1, v3
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[24:27], v[32:47]
		v_lshl_add_u32 v3, v1, 4, v3
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], v[16:19], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[96:99], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[112:115], v[16:19], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], v[16:19], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], v[144:147], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[144:147], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], v[20:23], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[100:103], v[20:23], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[116:119], v[20:23], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], v[20:23], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], v[148:151], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[148:151], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[148:151], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], v[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[104:107], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[120:123], v[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], v[28:31], v[112:127]
		v_rcp_f32_e32 v6, v4
		v_rcp_f32_e32 v8, v5
		v_mov_b32_e32 v7, v6
		s_nop 1
		v_pk_mul_f32 v[4:5], v[224:225], v[6:7]
		v_pk_mul_f32 v[10:11], v[226:227], v[6:7]
		v_pk_mul_f32 v[12:13], v[228:229], v[6:7]
		v_pk_mul_f32 v[14:15], v[230:231], v[6:7]
		v_pk_mul_f32 v[16:17], v[232:233], v[6:7]
		v_pk_mul_f32 v[18:19], v[234:235], v[6:7]
		v_pk_mul_f32 v[20:21], v[236:237], v[6:7]
		v_pk_mul_f32 v[22:23], v[238:239], v[6:7]
		v_pk_mul_f32 v[24:25], v[32:33], v[6:7]
		v_pk_mul_f32 v[26:27], v[34:35], v[6:7]
		v_pk_mul_f32 v[28:29], v[36:37], v[6:7]
		v_pk_mul_f32 v[30:31], v[38:39], v[6:7]
		v_pk_mul_f32 v[32:33], v[40:41], v[6:7]
		v_pk_mul_f32 v[34:35], v[42:43], v[6:7]
		v_pk_mul_f32 v[36:37], v[44:45], v[6:7]
		v_pk_mul_f32 v[38:39], v[46:47], v[6:7]
		v_pk_mul_f32 v[40:41], v[48:49], v[6:7]
		v_pk_mul_f32 v[42:43], v[50:51], v[6:7]
		v_pk_mul_f32 v[44:45], v[52:53], v[6:7]
		v_pk_mul_f32 v[46:47], v[54:55], v[6:7]
		v_pk_mul_f32 v[48:49], v[56:57], v[6:7]
		v_pk_mul_f32 v[50:51], v[58:59], v[6:7]
		v_pk_mul_f32 v[52:53], v[60:61], v[6:7]
		v_pk_mul_f32 v[54:55], v[62:63], v[6:7]
		v_pk_mul_f32 v[56:57], v[64:65], v[6:7]
		v_pk_mul_f32 v[58:59], v[66:67], v[6:7]
		v_pk_mul_f32 v[60:61], v[68:69], v[6:7]
		v_pk_mul_f32 v[62:63], v[70:71], v[6:7]
		v_pk_mul_f32 v[64:65], v[72:73], v[6:7]
		v_pk_mul_f32 v[66:67], v[74:75], v[6:7]
		v_pk_mul_f32 v[68:69], v[76:77], v[6:7]
		v_pk_mul_f32 v[70:71], v[78:79], v[6:7]
		v_mov_b32_e32 v9, v8
		v_pk_mul_f32 v[6:7], v[80:81], v[8:9]
		v_pk_mul_f32 v[72:73], v[82:83], v[8:9]
		v_pk_mul_f32 v[74:75], v[84:85], v[8:9]
		v_pk_mul_f32 v[76:77], v[86:87], v[8:9]
		v_pk_mul_f32 v[78:79], v[88:89], v[8:9]
		v_pk_mul_f32 v[80:81], v[90:91], v[8:9]
		v_pk_mul_f32 v[82:83], v[92:93], v[8:9]
		v_pk_mul_f32 v[84:85], v[94:95], v[8:9]
		v_pk_mul_f32 v[86:87], v[96:97], v[8:9]
		v_pk_mul_f32 v[88:89], v[98:99], v[8:9]
		v_pk_mul_f32 v[90:91], v[100:101], v[8:9]
		v_pk_mul_f32 v[92:93], v[102:103], v[8:9]
		v_pk_mul_f32 v[94:95], v[104:105], v[8:9]
		v_pk_mul_f32 v[96:97], v[106:107], v[8:9]
		v_pk_mul_f32 v[98:99], v[108:109], v[8:9]
		v_pk_mul_f32 v[100:101], v[110:111], v[8:9]
		v_pk_mul_f32 v[102:103], v[112:113], v[8:9]
		v_pk_mul_f32 v[104:105], v[114:115], v[8:9]
		v_pk_mul_f32 v[106:107], v[116:117], v[8:9]
		v_pk_mul_f32 v[108:109], v[118:119], v[8:9]
		v_pk_mul_f32 v[110:111], v[120:121], v[8:9]
		v_pk_mul_f32 v[112:113], v[122:123], v[8:9]
		v_pk_mul_f32 v[114:115], v[124:125], v[8:9]
		v_pk_mul_f32 v[116:117], v[126:127], v[8:9]
		v_pk_mul_f32 v[118:119], v[128:129], v[8:9]
		v_pk_mul_f32 v[120:121], v[130:131], v[8:9]
		v_pk_mul_f32 v[122:123], v[132:133], v[8:9]
		v_pk_mul_f32 v[124:125], v[134:135], v[8:9]
		v_pk_mul_f32 v[126:127], v[136:137], v[8:9]
		v_pk_mul_f32 v[128:129], v[138:139], v[8:9]
		v_pk_mul_f32 v[130:131], v[140:141], v[8:9]
		v_pk_mul_f32 v[132:133], v[142:143], v[8:9]
		v_cvt_pk_bf16_f32 v136, v4, v5
		v_cvt_pk_bf16_f32 v137, v10, v11
		v_cvt_pk_bf16_f32 v138, v12, v13
		v_cvt_pk_bf16_f32 v139, v14, v15
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
		v_cvt_pk_bf16_f32 v20, v40, v41
		v_cvt_pk_bf16_f32 v21, v42, v43
		v_cvt_pk_bf16_f32 v22, v44, v45
		v_cvt_pk_bf16_f32 v23, v46, v47
		v_cvt_pk_bf16_f32 v24, v48, v49
		v_cvt_pk_bf16_f32 v25, v50, v51
		v_cvt_pk_bf16_f32 v26, v52, v53
		v_cvt_pk_bf16_f32 v27, v54, v55
		v_cvt_pk_bf16_f32 v28, v56, v57
		v_cvt_pk_bf16_f32 v29, v58, v59
		v_cvt_pk_bf16_f32 v30, v60, v61
		v_cvt_pk_bf16_f32 v31, v62, v63
		v_cvt_pk_bf16_f32 v32, v64, v65
		v_cvt_pk_bf16_f32 v33, v66, v67
		v_cvt_pk_bf16_f32 v34, v68, v69
		v_cvt_pk_bf16_f32 v35, v70, v71
		v_cvt_pk_bf16_f32 v36, v6, v7
		v_cvt_pk_bf16_f32 v37, v72, v73
		v_cvt_pk_bf16_f32 v38, v74, v75
		v_cvt_pk_bf16_f32 v39, v76, v77
		v_cvt_pk_bf16_f32 v4, v78, v79
		v_cvt_pk_bf16_f32 v5, v80, v81
		v_cvt_pk_bf16_f32 v6, v82, v83
		v_cvt_pk_bf16_f32 v7, v84, v85
		v_cvt_pk_bf16_f32 v40, v86, v87
		v_cvt_pk_bf16_f32 v41, v88, v89
		v_cvt_pk_bf16_f32 v42, v90, v91
		v_cvt_pk_bf16_f32 v43, v92, v93
		v_cvt_pk_bf16_f32 v44, v94, v95
		v_cvt_pk_bf16_f32 v45, v96, v97
		v_cvt_pk_bf16_f32 v46, v98, v99
		v_cvt_pk_bf16_f32 v47, v100, v101
		v_cvt_pk_bf16_f32 v48, v102, v103
		v_cvt_pk_bf16_f32 v49, v104, v105
		v_cvt_pk_bf16_f32 v50, v106, v107
		v_cvt_pk_bf16_f32 v51, v108, v109
		v_cvt_pk_bf16_f32 v52, v110, v111
		v_cvt_pk_bf16_f32 v53, v112, v113
		v_cvt_pk_bf16_f32 v54, v114, v115
		v_cvt_pk_bf16_f32 v55, v116, v117
		v_cvt_pk_bf16_f32 v56, v118, v119
		v_cvt_pk_bf16_f32 v57, v120, v121
		v_cvt_pk_bf16_f32 v58, v122, v123
		v_cvt_pk_bf16_f32 v59, v124, v125
		v_cvt_pk_bf16_f32 v60, v126, v127
		v_cvt_pk_bf16_f32 v61, v128, v129
		v_cvt_pk_bf16_f32 v62, v130, v131
		v_cvt_pk_bf16_f32 v63, v132, v133
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
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
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v56, v58
		v_permlane32_swap_b32_e32 v57, v59
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_16
		buffer_store_dwordx4 v[136:139], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_16:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_16
.L_attn_fwd_async_prefetch.exec_endif_16:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s3, s1, 32
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v3, v2, 6, s3
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_17
		buffer_store_dwordx4 v[8:11], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_17:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_17
.L_attn_fwd_async_prefetch.exec_endif_17:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s3, s1, 64
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v3, v2, 6, s3
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_18
		buffer_store_dwordx4 v[12:15], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_18:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_18
.L_attn_fwd_async_prefetch.exec_endif_18:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s3, s1, 0x60
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v3, v2, 6, s3
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_19
		buffer_store_dwordx4 v[16:19], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_19:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_19
.L_attn_fwd_async_prefetch.exec_endif_19:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s3, s1, 0x80
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v3, v2, 6, s3
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_20
		buffer_store_dwordx4 v[20:23], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_20:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_20
.L_attn_fwd_async_prefetch.exec_endif_20:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s3, s1, 0xa0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v3, v2, 6, s3
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_21
		buffer_store_dwordx4 v[24:27], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_21:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_21
.L_attn_fwd_async_prefetch.exec_endif_21:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s3, s1, 0xc0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v3, v2, 6, s3
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_22
		buffer_store_dwordx4 v[28:31], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_22:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_22
.L_attn_fwd_async_prefetch.exec_endif_22:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s3, s1, 0xe0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v3, v2, 6, s3
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_23
		buffer_store_dwordx4 v[32:35], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_23:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_23
.L_attn_fwd_async_prefetch.exec_endif_23:
		s_mov_b64 exec, s[60:61]
		s_lshl_b32 s3, s23, 8
		s_add_i32 s8, s3, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v3, v2, 6, s8
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_24
		buffer_store_dwordx4 v[36:39], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_24:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_24
.L_attn_fwd_async_prefetch.exec_endif_24:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s3, 32
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v3, v2, 6, s8
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_25
		buffer_store_dwordx4 v[4:7], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_25:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_25
.L_attn_fwd_async_prefetch.exec_endif_25:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s3, 64
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v3, v2, 6, s8
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_26
		buffer_store_dwordx4 v[40:43], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_26:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_26
.L_attn_fwd_async_prefetch.exec_endif_26:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s3, 0x60
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v3, v2, 6, s8
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_27
		buffer_store_dwordx4 v[44:47], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_27:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_27
.L_attn_fwd_async_prefetch.exec_endif_27:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s3, 0x80
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v3, v2, 6, s8
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_28
		buffer_store_dwordx4 v[48:51], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_28:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_28
.L_attn_fwd_async_prefetch.exec_endif_28:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s3, 0xa0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v3, v2, 6, s8
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_29
		buffer_store_dwordx4 v[52:55], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_29:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_29
.L_attn_fwd_async_prefetch.exec_endif_29:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s3, 0xc0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v3, v2, 6, s8
		v_lshl_add_u32 v3, v0, 1, v3
		v_lshl_add_u32 v3, v1, 4, v3
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_30
		buffer_store_dwordx4 v[56:59], v3, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_30:
		s_andn2_b64 exec, s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_30
.L_attn_fwd_async_prefetch.exec_endif_30:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s3, s3, 0xe0
		s_add_i32 s1, s3, s1
		s_add_i32 s1, s1, s2
		s_add_i32 s0, s1, s0
		v_lshl_add_u32 v2, v2, 6, s0
		v_lshl_add_u32 v0, v0, 1, v2
		v_lshl_add_u32 v0, v1, 4, v0
		s_and_saveexec_b64 s[60:61], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_31
		buffer_store_dwordx4 v[60:63], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_31:
		s_andn2_b64 exec, s[60:61], s[12:13]
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
		.amdhsa_next_free_vgpr 412
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
	.set .L_attn_fwd_async_prefetch.num_agpr, 156
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
    .vgpr_count:     412
    .agpr_count:     156
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 60
    wave.regalloc.agpr.dwords: 236
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
