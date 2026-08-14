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
		v_mov_b32_e32 v1, s26
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s27, s26, -1
		v_readfirstlane_b32 s28, v1
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
		v_and_b32_e32 v1, 1, v0
		v_lshrrev_b32_e32 v2, 1, v0
		v_and_b32_e32 v2, 1, v2
		v_mov_b32_e32 v3, 2
		v_mul_lo_u32 v3, v3, v2
		v_lshrrev_b32_e32 v2, 2, v0
		v_and_b32_e32 v4, 1, v2
		v_mov_b32_e32 v5, 4
		v_mul_lo_u32 v5, v5, v4
		v_bitop3_b32 v4, v1, v3, v5 bitop3:0x96
		v_lshrrev_b32_e32 v6, 3, v0
		v_and_b32_e32 v7, 1, v6
		v_mov_b32_e32 v8, 8
		v_mul_lo_u32 v8, v8, v7
		v_xor_b32_e32 v4, v4, v8
		v_lshrrev_b32_e32 v7, 4, v0
		v_and_b32_e32 v9, 1, v7
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v9
		v_lshrrev_b32_e32 v11, 6, v0
		v_and_b32_e32 v12, 1, v11
		v_mov_b32_e32 v13, 32
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v4, v4, v10, v13 bitop3:0x96
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v3
		v_xor_b32_e32 v1, v1, v5
		v_bitop3_b32 v1, v1, v8, v10 bitop3:0x96
		v_xor_b32_e32 v1, v1, v13
		v_lshrrev_b32_e32 v3, 5, v0
		v_and_b32_e32 v5, 1, v3
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v5
		v_mov_b32_e32 v13, 4
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v16, v9, v8, v13 bitop3:0x96
		v_mov_b32_e32 v17, 8
		v_mul_lo_u32 v17, v17, v14
		v_xad_u32 v16, v16, v17, s1
		v_bitop3_b32 v18, 16, v9, v8 bitop3:0x96
		v_xor_b32_e32 v18, v18, v13
		v_xad_u32 v18, v18, v17, s1
		v_bitop3_b32 v19, 32, v9, v8 bitop3:0x96
		v_xor_b32_e32 v19, v19, v13
		v_xad_u32 v19, v19, v17, s1
		v_bitop3_b32 v20, 48, v9, v8 bitop3:0x96
		v_xor_b32_e32 v20, v20, v13
		v_xad_u32 v20, v20, v17, s1
		v_bitop3_b32 v21, 64, v9, v8 bitop3:0x96
		v_xor_b32_e32 v21, v21, v13
		v_xad_u32 v21, v21, v17, s1
		v_xor_b32_e32 v22, 0x50, v9
		v_xor_b32_e32 v22, v22, v8
		v_xor_b32_e32 v22, v22, v13
		v_xad_u32 v22, v22, v17, s1
		v_xor_b32_e32 v23, 0x60, v9
		v_xor_b32_e32 v23, v23, v8
		v_xor_b32_e32 v23, v23, v13
		v_xad_u32 v23, v23, v17, s1
		v_xor_b32_e32 v24, 0x70, v9
		v_xor_b32_e32 v24, v24, v8
		v_xor_b32_e32 v24, v24, v13
		v_xad_u32 v24, v24, v17, s1
		v_xor_b32_e32 v25, 0x80, v9
		v_xor_b32_e32 v25, v25, v8
		v_xor_b32_e32 v25, v25, v13
		v_xad_u32 v25, v25, v17, s1
		v_xor_b32_e32 v26, 0x90, v9
		v_xor_b32_e32 v26, v26, v8
		v_xor_b32_e32 v26, v26, v13
		v_xad_u32 v26, v26, v17, s1
		v_xor_b32_e32 v27, 0xa0, v9
		v_xor_b32_e32 v27, v27, v8
		v_xor_b32_e32 v27, v27, v13
		v_xad_u32 v27, v27, v17, s1
		v_xor_b32_e32 v28, 0xb0, v9
		v_xor_b32_e32 v28, v28, v8
		v_xor_b32_e32 v28, v28, v13
		v_xad_u32 v28, v28, v17, s1
		v_xor_b32_e32 v29, 0xc0, v9
		v_xor_b32_e32 v29, v29, v8
		v_xor_b32_e32 v29, v29, v13
		v_xad_u32 v29, v29, v17, s1
		v_xor_b32_e32 v30, 0xd0, v9
		v_xor_b32_e32 v30, v30, v8
		v_xor_b32_e32 v30, v30, v13
		v_xad_u32 v30, v30, v17, s1
		v_xor_b32_e32 v31, 0xe0, v9
		v_xor_b32_e32 v31, v31, v8
		v_xor_b32_e32 v31, v31, v13
		v_xad_u32 v31, v31, v17, s1
		v_xor_b32_e32 v9, 0xf0, v9
		v_xor_b32_e32 v8, v9, v8
		v_xor_b32_e32 v8, v8, v13
		v_xad_u32 v8, v8, v17, s1
		v_cmp_lt_i32_e64 s[26:27], v16, s25
		v_cmp_lt_i32_e64 s[28:29], v18, s25
		v_cmp_lt_i32_e64 s[30:31], v19, s25
		v_cmp_lt_i32_e64 s[32:33], v20, s25
		v_cmp_lt_i32_e64 s[34:35], v21, s25
		v_cmp_lt_i32_e64 s[36:37], v22, s25
		v_cmp_lt_i32_e64 s[38:39], v23, s25
		v_cmp_lt_i32_e64 s[40:41], v24, s25
		v_cmp_lt_i32_e64 s[42:43], v25, s25
		v_cmp_lt_i32_e64 s[44:45], v26, s25
		v_cmp_lt_i32_e64 s[46:47], v27, s25
		v_cmp_lt_i32_e64 s[48:49], v28, s25
		v_cmp_lt_i32_e64 s[50:51], v29, s25
		v_cmp_lt_i32_e64 s[52:53], v30, s25
		v_cmp_lt_i32_e64 s[54:55], v31, s25
		v_cmp_lt_i32_e64 s[56:57], v8, s25
		s_mov_b32 s62, 0x7fffffff
		s_mov_b32 s63, 0x31016000
		s_mov_b32 s60, s2
		s_mov_b32 s61, s3
		s_mul_i32 s2, s16, s12
		s_lshl_b32 s2, s2, 9
		s_mul_i32 s3, s17, s10
		s_lshl_b32 s3, s3, 1
		s_add_i32 s10, s2, s3
		s_mul_i32 s11, s0, s11
		s_lshl_b32 s11, s11, 1
		s_add_i32 s10, s10, s11
		v_mul_lo_u32 v8, s12, v7
		v_lshl_add_u32 v9, v8, 1, s10
		v_and_b32_e32 v13, 15, v0
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_0
		buffer_load_ushort v16, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_0:
		s_andn2_b64 exec, s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_0
		v_mov_b32_e32 v16, 0
.L_attn_fwd_async_prefetch.exec_endif_0:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s2, 2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_1
		buffer_load_ushort v17, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_1:
		s_andn2_b64 exec, s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_1
		v_mov_b32_e32 v17, 0
.L_attn_fwd_async_prefetch.exec_endif_1:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s2, 4
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_2
		buffer_load_ushort v18, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_2:
		s_andn2_b64 exec, s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_2
		v_mov_b32_e32 v18, 0
.L_attn_fwd_async_prefetch.exec_endif_2:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s2, 6
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_3
		buffer_load_ushort v19, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_3:
		s_andn2_b64 exec, s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_3
		v_mov_b32_e32 v19, 0
.L_attn_fwd_async_prefetch.exec_endif_3:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s2, 8
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_4
		buffer_load_ushort v20, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_4:
		s_andn2_b64 exec, s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_4
		v_mov_b32_e32 v20, 0
.L_attn_fwd_async_prefetch.exec_endif_4:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s2, 10
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_5
		buffer_load_ushort v21, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_5:
		s_andn2_b64 exec, s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_5
		v_mov_b32_e32 v21, 0
.L_attn_fwd_async_prefetch.exec_endif_5:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s2, 12
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_6
		buffer_load_ushort v22, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_6:
		s_andn2_b64 exec, s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_6
		v_mov_b32_e32 v22, 0
.L_attn_fwd_async_prefetch.exec_endif_6:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s2, 14
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_7
		buffer_load_ushort v23, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_7:
		s_andn2_b64 exec, s[64:65], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_7
		v_mov_b32_e32 v23, 0
.L_attn_fwd_async_prefetch.exec_endif_7:
		s_mov_b64 exec, s[64:65]
		s_lshl_b32 s10, s12, 5
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_8
		buffer_load_ushort v24, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_8:
		s_andn2_b64 exec, s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_8
		v_mov_b32_e32 v24, 0
.L_attn_fwd_async_prefetch.exec_endif_8:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_9
		buffer_load_ushort v25, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_9:
		s_andn2_b64 exec, s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_9
		v_mov_b32_e32 v25, 0
.L_attn_fwd_async_prefetch.exec_endif_9:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_10
		buffer_load_ushort v26, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_10:
		s_andn2_b64 exec, s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_10
		v_mov_b32_e32 v26, 0
.L_attn_fwd_async_prefetch.exec_endif_10:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_11
		buffer_load_ushort v27, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_11:
		s_andn2_b64 exec, s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_11
		v_mov_b32_e32 v27, 0
.L_attn_fwd_async_prefetch.exec_endif_11:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_12
		buffer_load_ushort v28, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_12:
		s_andn2_b64 exec, s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_12
		v_mov_b32_e32 v28, 0
.L_attn_fwd_async_prefetch.exec_endif_12:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_13
		buffer_load_ushort v29, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_13:
		s_andn2_b64 exec, s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_13
		v_mov_b32_e32 v29, 0
.L_attn_fwd_async_prefetch.exec_endif_13:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_14
		buffer_load_ushort v30, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_14:
		s_andn2_b64 exec, s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_14
		v_mov_b32_e32 v30, 0
.L_attn_fwd_async_prefetch.exec_endif_14:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_15
		buffer_load_ushort v31, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_15:
		s_andn2_b64 exec, s[64:65], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_15
		v_mov_b32_e32 v31, 0
.L_attn_fwd_async_prefetch.exec_endif_15:
		s_mov_b64 exec, s[64:65]
		s_lshl_b32 s10, s12, 6
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_16
		buffer_load_ushort v32, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_16:
		s_andn2_b64 exec, s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_16
		v_mov_b32_e32 v32, 0
.L_attn_fwd_async_prefetch.exec_endif_16:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_17
		buffer_load_ushort v33, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_17:
		s_andn2_b64 exec, s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_17
		v_mov_b32_e32 v33, 0
.L_attn_fwd_async_prefetch.exec_endif_17:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_18
		buffer_load_ushort v34, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_18:
		s_andn2_b64 exec, s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_18
		v_mov_b32_e32 v34, 0
.L_attn_fwd_async_prefetch.exec_endif_18:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_19
		buffer_load_ushort v35, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_19:
		s_andn2_b64 exec, s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_19
		v_mov_b32_e32 v35, 0
.L_attn_fwd_async_prefetch.exec_endif_19:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_20
		buffer_load_ushort v36, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_20:
		s_andn2_b64 exec, s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_20
		v_mov_b32_e32 v36, 0
.L_attn_fwd_async_prefetch.exec_endif_20:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_21
		buffer_load_ushort v37, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_21:
		s_andn2_b64 exec, s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_21
		v_mov_b32_e32 v37, 0
.L_attn_fwd_async_prefetch.exec_endif_21:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_22
		buffer_load_ushort v38, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_22:
		s_andn2_b64 exec, s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_22
		v_mov_b32_e32 v38, 0
.L_attn_fwd_async_prefetch.exec_endif_22:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_23
		buffer_load_ushort v39, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_23:
		s_andn2_b64 exec, s[64:65], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_23
		v_mov_b32_e32 v39, 0
.L_attn_fwd_async_prefetch.exec_endif_23:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0x60, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_24
		buffer_load_ushort v40, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_24:
		s_andn2_b64 exec, s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_24
		v_mov_b32_e32 v40, 0
.L_attn_fwd_async_prefetch.exec_endif_24:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_25
		buffer_load_ushort v41, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_25:
		s_andn2_b64 exec, s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_25
		v_mov_b32_e32 v41, 0
.L_attn_fwd_async_prefetch.exec_endif_25:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_26
		buffer_load_ushort v42, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_26:
		s_andn2_b64 exec, s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_26
		v_mov_b32_e32 v42, 0
.L_attn_fwd_async_prefetch.exec_endif_26:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_27
		buffer_load_ushort v43, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_27:
		s_andn2_b64 exec, s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_27
		v_mov_b32_e32 v43, 0
.L_attn_fwd_async_prefetch.exec_endif_27:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_28
		buffer_load_ushort v44, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_28:
		s_andn2_b64 exec, s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_28
		v_mov_b32_e32 v44, 0
.L_attn_fwd_async_prefetch.exec_endif_28:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_29
		buffer_load_ushort v45, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_29:
		s_andn2_b64 exec, s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_29
		v_mov_b32_e32 v45, 0
.L_attn_fwd_async_prefetch.exec_endif_29:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_30
		buffer_load_ushort v46, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_30:
		s_andn2_b64 exec, s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_30
		v_mov_b32_e32 v46, 0
.L_attn_fwd_async_prefetch.exec_endif_30:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_31
		buffer_load_ushort v47, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_31:
		s_andn2_b64 exec, s[64:65], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_31
		v_mov_b32_e32 v47, 0
.L_attn_fwd_async_prefetch.exec_endif_31:
		s_mov_b64 exec, s[64:65]
		s_lshl_b32 s10, s12, 7
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_32
		buffer_load_ushort v48, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_32:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_32
		v_mov_b32_e32 v48, 0
.L_attn_fwd_async_prefetch.exec_endif_32:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_33
		buffer_load_ushort v49, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_33:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_33
		v_mov_b32_e32 v49, 0
.L_attn_fwd_async_prefetch.exec_endif_33:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_34
		buffer_load_ushort v50, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_34:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_34
		v_mov_b32_e32 v50, 0
.L_attn_fwd_async_prefetch.exec_endif_34:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_35
		buffer_load_ushort v51, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_35:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_35
		v_mov_b32_e32 v51, 0
.L_attn_fwd_async_prefetch.exec_endif_35:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_36
		buffer_load_ushort v52, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_36:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_36
		v_mov_b32_e32 v52, 0
.L_attn_fwd_async_prefetch.exec_endif_36:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_37
		buffer_load_ushort v53, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_37:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_37
		v_mov_b32_e32 v53, 0
.L_attn_fwd_async_prefetch.exec_endif_37:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_38
		buffer_load_ushort v54, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_38:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_38
		v_mov_b32_e32 v54, 0
.L_attn_fwd_async_prefetch.exec_endif_38:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_39
		buffer_load_ushort v55, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_39:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_39
		v_mov_b32_e32 v55, 0
.L_attn_fwd_async_prefetch.exec_endif_39:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0xa0, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_40
		buffer_load_ushort v56, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_40:
		s_andn2_b64 exec, s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_40
		v_mov_b32_e32 v56, 0
.L_attn_fwd_async_prefetch.exec_endif_40:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_41
		buffer_load_ushort v57, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_41:
		s_andn2_b64 exec, s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_41
		v_mov_b32_e32 v57, 0
.L_attn_fwd_async_prefetch.exec_endif_41:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_42
		buffer_load_ushort v58, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_42:
		s_andn2_b64 exec, s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_42
		v_mov_b32_e32 v58, 0
.L_attn_fwd_async_prefetch.exec_endif_42:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_43
		buffer_load_ushort v59, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_43:
		s_andn2_b64 exec, s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_43
		v_mov_b32_e32 v59, 0
.L_attn_fwd_async_prefetch.exec_endif_43:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_44
		buffer_load_ushort v60, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_44:
		s_andn2_b64 exec, s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_44
		v_mov_b32_e32 v60, 0
.L_attn_fwd_async_prefetch.exec_endif_44:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_45
		buffer_load_ushort v61, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_45:
		s_andn2_b64 exec, s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_45
		v_mov_b32_e32 v61, 0
.L_attn_fwd_async_prefetch.exec_endif_45:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_46
		buffer_load_ushort v62, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_46:
		s_andn2_b64 exec, s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_46
		v_mov_b32_e32 v62, 0
.L_attn_fwd_async_prefetch.exec_endif_46:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_47
		buffer_load_ushort v63, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_47:
		s_andn2_b64 exec, s[64:65], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_47
		v_mov_b32_e32 v63, 0
.L_attn_fwd_async_prefetch.exec_endif_47:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0xc0, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_48
		buffer_load_ushort v64, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_48:
		s_andn2_b64 exec, s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_48
		v_mov_b32_e32 v64, 0
.L_attn_fwd_async_prefetch.exec_endif_48:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_49
		buffer_load_ushort v65, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_49:
		s_andn2_b64 exec, s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_49
		v_mov_b32_e32 v65, 0
.L_attn_fwd_async_prefetch.exec_endif_49:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_50
		buffer_load_ushort v66, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_50:
		s_andn2_b64 exec, s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_50
		v_mov_b32_e32 v66, 0
.L_attn_fwd_async_prefetch.exec_endif_50:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_51
		buffer_load_ushort v67, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_51:
		s_andn2_b64 exec, s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_51
		v_mov_b32_e32 v67, 0
.L_attn_fwd_async_prefetch.exec_endif_51:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_52
		buffer_load_ushort v68, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_52:
		s_andn2_b64 exec, s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_52
		v_mov_b32_e32 v68, 0
.L_attn_fwd_async_prefetch.exec_endif_52:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_53
		buffer_load_ushort v69, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_53:
		s_andn2_b64 exec, s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_53
		v_mov_b32_e32 v69, 0
.L_attn_fwd_async_prefetch.exec_endif_53:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_54
		buffer_load_ushort v70, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_54:
		s_andn2_b64 exec, s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_54
		v_mov_b32_e32 v70, 0
.L_attn_fwd_async_prefetch.exec_endif_54:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_55
		buffer_load_ushort v71, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_55:
		s_andn2_b64 exec, s[64:65], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_55
		v_mov_b32_e32 v71, 0
.L_attn_fwd_async_prefetch.exec_endif_55:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0xe0, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_56
		buffer_load_ushort v72, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_56:
		s_andn2_b64 exec, s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_56
		v_mov_b32_e32 v72, 0
.L_attn_fwd_async_prefetch.exec_endif_56:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_57
		buffer_load_ushort v73, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_57:
		s_andn2_b64 exec, s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_57
		v_mov_b32_e32 v73, 0
.L_attn_fwd_async_prefetch.exec_endif_57:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_58
		buffer_load_ushort v74, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_58:
		s_andn2_b64 exec, s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_58
		v_mov_b32_e32 v74, 0
.L_attn_fwd_async_prefetch.exec_endif_58:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_59
		buffer_load_ushort v75, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_59:
		s_andn2_b64 exec, s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_59
		v_mov_b32_e32 v75, 0
.L_attn_fwd_async_prefetch.exec_endif_59:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_60
		buffer_load_ushort v76, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_60:
		s_andn2_b64 exec, s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_60
		v_mov_b32_e32 v76, 0
.L_attn_fwd_async_prefetch.exec_endif_60:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_61
		buffer_load_ushort v77, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_61:
		s_andn2_b64 exec, s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_61
		v_mov_b32_e32 v77, 0
.L_attn_fwd_async_prefetch.exec_endif_61:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_62
		buffer_load_ushort v78, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_62:
		s_andn2_b64 exec, s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_62
		v_mov_b32_e32 v78, 0
.L_attn_fwd_async_prefetch.exec_endif_62:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_63
		buffer_load_ushort v79, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_63:
		s_andn2_b64 exec, s[64:65], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_63
		v_mov_b32_e32 v79, 0
.L_attn_fwd_async_prefetch.exec_endif_63:
		s_mov_b64 exec, s[64:65]
		s_lshl_b32 s10, s12, 8
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_64
		buffer_load_ushort v80, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_64:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_64
		v_mov_b32_e32 v80, 0
.L_attn_fwd_async_prefetch.exec_endif_64:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_65
		buffer_load_ushort v81, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_65:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_65
		v_mov_b32_e32 v81, 0
.L_attn_fwd_async_prefetch.exec_endif_65:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_66
		buffer_load_ushort v82, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_66:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_66
		v_mov_b32_e32 v82, 0
.L_attn_fwd_async_prefetch.exec_endif_66:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_67
		buffer_load_ushort v83, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_67:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_67
		v_mov_b32_e32 v83, 0
.L_attn_fwd_async_prefetch.exec_endif_67:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_68
		buffer_load_ushort v84, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_68:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_68
		v_mov_b32_e32 v84, 0
.L_attn_fwd_async_prefetch.exec_endif_68:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_69
		buffer_load_ushort v85, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_69:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_69
		v_mov_b32_e32 v85, 0
.L_attn_fwd_async_prefetch.exec_endif_69:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_70
		buffer_load_ushort v86, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_70:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_70
		v_mov_b32_e32 v86, 0
.L_attn_fwd_async_prefetch.exec_endif_70:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_71
		buffer_load_ushort v87, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_71:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_71
		v_mov_b32_e32 v87, 0
.L_attn_fwd_async_prefetch.exec_endif_71:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0x120, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_72
		buffer_load_ushort v88, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_72:
		s_andn2_b64 exec, s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_72
		v_mov_b32_e32 v88, 0
.L_attn_fwd_async_prefetch.exec_endif_72:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_73
		buffer_load_ushort v89, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_73:
		s_andn2_b64 exec, s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_73
		v_mov_b32_e32 v89, 0
.L_attn_fwd_async_prefetch.exec_endif_73:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_74
		buffer_load_ushort v90, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_74:
		s_andn2_b64 exec, s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_74
		v_mov_b32_e32 v90, 0
.L_attn_fwd_async_prefetch.exec_endif_74:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_75
		buffer_load_ushort v91, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_75:
		s_andn2_b64 exec, s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_75
		v_mov_b32_e32 v91, 0
.L_attn_fwd_async_prefetch.exec_endif_75:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_76
		buffer_load_ushort v92, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_76:
		s_andn2_b64 exec, s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_76
		v_mov_b32_e32 v92, 0
.L_attn_fwd_async_prefetch.exec_endif_76:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_77
		buffer_load_ushort v93, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_77:
		s_andn2_b64 exec, s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_77
		v_mov_b32_e32 v93, 0
.L_attn_fwd_async_prefetch.exec_endif_77:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_78
		buffer_load_ushort v94, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_78:
		s_andn2_b64 exec, s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_78
		v_mov_b32_e32 v94, 0
.L_attn_fwd_async_prefetch.exec_endif_78:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_79
		buffer_load_ushort v95, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_79:
		s_andn2_b64 exec, s[64:65], s[44:45]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_79
		v_mov_b32_e32 v95, 0
.L_attn_fwd_async_prefetch.exec_endif_79:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0x140, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_80
		buffer_load_ushort v96, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_80:
		s_andn2_b64 exec, s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_80
		v_mov_b32_e32 v96, 0
.L_attn_fwd_async_prefetch.exec_endif_80:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_81
		buffer_load_ushort v97, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_81:
		s_andn2_b64 exec, s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_81
		v_mov_b32_e32 v97, 0
.L_attn_fwd_async_prefetch.exec_endif_81:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_82
		buffer_load_ushort v98, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_82:
		s_andn2_b64 exec, s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_82
		v_mov_b32_e32 v98, 0
.L_attn_fwd_async_prefetch.exec_endif_82:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_83
		buffer_load_ushort v99, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_83:
		s_andn2_b64 exec, s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_83
		v_mov_b32_e32 v99, 0
.L_attn_fwd_async_prefetch.exec_endif_83:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_84
		buffer_load_ushort v100, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_84:
		s_andn2_b64 exec, s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_84
		v_mov_b32_e32 v100, 0
.L_attn_fwd_async_prefetch.exec_endif_84:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_85
		buffer_load_ushort v101, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_85:
		s_andn2_b64 exec, s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_85
		v_mov_b32_e32 v101, 0
.L_attn_fwd_async_prefetch.exec_endif_85:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_86
		buffer_load_ushort v102, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_86:
		s_andn2_b64 exec, s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_86
		v_mov_b32_e32 v102, 0
.L_attn_fwd_async_prefetch.exec_endif_86:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_87
		buffer_load_ushort v103, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_87:
		s_andn2_b64 exec, s[64:65], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_87
		v_mov_b32_e32 v103, 0
.L_attn_fwd_async_prefetch.exec_endif_87:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0x160, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_88
		buffer_load_ushort v104, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_88:
		s_andn2_b64 exec, s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_88
		v_mov_b32_e32 v104, 0
.L_attn_fwd_async_prefetch.exec_endif_88:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_89
		buffer_load_ushort v105, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_89:
		s_andn2_b64 exec, s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_89
		v_mov_b32_e32 v105, 0
.L_attn_fwd_async_prefetch.exec_endif_89:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_90
		buffer_load_ushort v106, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_90:
		s_andn2_b64 exec, s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_90
		v_mov_b32_e32 v106, 0
.L_attn_fwd_async_prefetch.exec_endif_90:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_91
		buffer_load_ushort v107, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_91:
		s_andn2_b64 exec, s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_91
		v_mov_b32_e32 v107, 0
.L_attn_fwd_async_prefetch.exec_endif_91:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_92
		buffer_load_ushort v108, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_92:
		s_andn2_b64 exec, s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_92
		v_mov_b32_e32 v108, 0
.L_attn_fwd_async_prefetch.exec_endif_92:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_93
		buffer_load_ushort v109, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_93:
		s_andn2_b64 exec, s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_93
		v_mov_b32_e32 v109, 0
.L_attn_fwd_async_prefetch.exec_endif_93:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_94
		buffer_load_ushort v110, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_94:
		s_andn2_b64 exec, s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_94
		v_mov_b32_e32 v110, 0
.L_attn_fwd_async_prefetch.exec_endif_94:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_95
		buffer_load_ushort v111, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_95:
		s_andn2_b64 exec, s[64:65], s[48:49]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_95
		v_mov_b32_e32 v111, 0
.L_attn_fwd_async_prefetch.exec_endif_95:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0x180, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_96
		buffer_load_ushort v112, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_96:
		s_andn2_b64 exec, s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_96
		v_mov_b32_e32 v112, 0
.L_attn_fwd_async_prefetch.exec_endif_96:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_97
		buffer_load_ushort v113, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_97:
		s_andn2_b64 exec, s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_97
		v_mov_b32_e32 v113, 0
.L_attn_fwd_async_prefetch.exec_endif_97:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_98
		buffer_load_ushort v114, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_98:
		s_andn2_b64 exec, s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_98
		v_mov_b32_e32 v114, 0
.L_attn_fwd_async_prefetch.exec_endif_98:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_99
		buffer_load_ushort v115, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_99:
		s_andn2_b64 exec, s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_99
		v_mov_b32_e32 v115, 0
.L_attn_fwd_async_prefetch.exec_endif_99:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_100
		buffer_load_ushort v116, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_100:
		s_andn2_b64 exec, s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_100
		v_mov_b32_e32 v116, 0
.L_attn_fwd_async_prefetch.exec_endif_100:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_101
		buffer_load_ushort v117, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_101:
		s_andn2_b64 exec, s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_101
		v_mov_b32_e32 v117, 0
.L_attn_fwd_async_prefetch.exec_endif_101:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_102
		buffer_load_ushort v118, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_102:
		s_andn2_b64 exec, s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_102
		v_mov_b32_e32 v118, 0
.L_attn_fwd_async_prefetch.exec_endif_102:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_103
		buffer_load_ushort v119, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_103:
		s_andn2_b64 exec, s[64:65], s[50:51]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_103
		v_mov_b32_e32 v119, 0
.L_attn_fwd_async_prefetch.exec_endif_103:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0x1a0, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_104
		buffer_load_ushort v120, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_104:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_104
		v_mov_b32_e32 v120, 0
.L_attn_fwd_async_prefetch.exec_endif_104:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_105
		buffer_load_ushort v121, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_105:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_105
		v_mov_b32_e32 v121, 0
.L_attn_fwd_async_prefetch.exec_endif_105:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_106
		buffer_load_ushort v122, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_106:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_106
		v_mov_b32_e32 v122, 0
.L_attn_fwd_async_prefetch.exec_endif_106:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_107
		buffer_load_ushort v123, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_107:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_107
		v_mov_b32_e32 v123, 0
.L_attn_fwd_async_prefetch.exec_endif_107:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_108
		buffer_load_ushort v124, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_108:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_108
		v_mov_b32_e32 v124, 0
.L_attn_fwd_async_prefetch.exec_endif_108:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_109
		buffer_load_ushort v125, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_109:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_109
		v_mov_b32_e32 v125, 0
.L_attn_fwd_async_prefetch.exec_endif_109:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_110
		buffer_load_ushort v126, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_110:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_110
		v_mov_b32_e32 v126, 0
.L_attn_fwd_async_prefetch.exec_endif_110:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_111
		buffer_load_ushort v127, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_111:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_111
		v_mov_b32_e32 v127, 0
.L_attn_fwd_async_prefetch.exec_endif_111:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0x1c0, s12
		s_add_i32 s24, s10, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_112
		buffer_load_ushort v128, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_112:
		s_andn2_b64 exec, s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_112
		v_mov_b32_e32 v128, 0
.L_attn_fwd_async_prefetch.exec_endif_112:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 2
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_113
		buffer_load_ushort v129, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_113:
		s_andn2_b64 exec, s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_113
		v_mov_b32_e32 v129, 0
.L_attn_fwd_async_prefetch.exec_endif_113:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 4
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_114
		buffer_load_ushort v130, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_114:
		s_andn2_b64 exec, s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_114
		v_mov_b32_e32 v130, 0
.L_attn_fwd_async_prefetch.exec_endif_114:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 6
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_115
		buffer_load_ushort v131, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_115:
		s_andn2_b64 exec, s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_115
		v_mov_b32_e32 v131, 0
.L_attn_fwd_async_prefetch.exec_endif_115:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 8
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_116
		buffer_load_ushort v132, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_116:
		s_andn2_b64 exec, s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_116
		v_mov_b32_e32 v132, 0
.L_attn_fwd_async_prefetch.exec_endif_116:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 10
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_117
		buffer_load_ushort v133, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_117:
		s_andn2_b64 exec, s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_117
		v_mov_b32_e32 v133, 0
.L_attn_fwd_async_prefetch.exec_endif_117:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s24, s10, 12
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s11
		v_lshl_add_u32 v9, v8, 1, s24
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_118
		buffer_load_ushort v134, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_118:
		s_andn2_b64 exec, s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_118
		v_mov_b32_e32 v134, 0
.L_attn_fwd_async_prefetch.exec_endif_118:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v9, v8, 1, s10
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_119
		buffer_load_ushort v135, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_119:
		s_andn2_b64 exec, s[64:65], s[54:55]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_119
		v_mov_b32_e32 v135, 0
.L_attn_fwd_async_prefetch.exec_endif_119:
		s_mov_b64 exec, s[64:65]
		s_mul_i32 s10, 0x1e0, s12
		s_add_i32 s12, s10, s2
		s_add_i32 s12, s12, s3
		s_add_i32 s12, s12, s11
		v_lshl_add_u32 v9, v8, 1, s12
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_120
		buffer_load_ushort v136, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_120:
		s_andn2_b64 exec, s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_120
		v_mov_b32_e32 v136, 0
.L_attn_fwd_async_prefetch.exec_endif_120:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s12, s10, 2
		s_add_i32 s12, s12, s2
		s_add_i32 s12, s12, s3
		s_add_i32 s12, s12, s11
		v_lshl_add_u32 v9, v8, 1, s12
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_121
		buffer_load_ushort v137, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_121:
		s_andn2_b64 exec, s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_121
		v_mov_b32_e32 v137, 0
.L_attn_fwd_async_prefetch.exec_endif_121:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s12, s10, 4
		s_add_i32 s12, s12, s2
		s_add_i32 s12, s12, s3
		s_add_i32 s12, s12, s11
		v_lshl_add_u32 v9, v8, 1, s12
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_122
		buffer_load_ushort v138, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_122:
		s_andn2_b64 exec, s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_122
		v_mov_b32_e32 v138, 0
.L_attn_fwd_async_prefetch.exec_endif_122:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s12, s10, 6
		s_add_i32 s12, s12, s2
		s_add_i32 s12, s12, s3
		s_add_i32 s12, s12, s11
		v_lshl_add_u32 v9, v8, 1, s12
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_123
		buffer_load_ushort v139, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_123:
		s_andn2_b64 exec, s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_123
		v_mov_b32_e32 v139, 0
.L_attn_fwd_async_prefetch.exec_endif_123:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s12, s10, 8
		s_add_i32 s12, s12, s2
		s_add_i32 s12, s12, s3
		s_add_i32 s12, s12, s11
		v_lshl_add_u32 v9, v8, 1, s12
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_124
		buffer_load_ushort v140, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_124:
		s_andn2_b64 exec, s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_124
		v_mov_b32_e32 v140, 0
.L_attn_fwd_async_prefetch.exec_endif_124:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s12, s10, 10
		s_add_i32 s12, s12, s2
		s_add_i32 s12, s12, s3
		s_add_i32 s12, s12, s11
		v_lshl_add_u32 v9, v8, 1, s12
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_125
		buffer_load_ushort v141, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_125:
		s_andn2_b64 exec, s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_125
		v_mov_b32_e32 v141, 0
.L_attn_fwd_async_prefetch.exec_endif_125:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s12, s10, 12
		s_add_i32 s12, s12, s2
		s_add_i32 s12, s12, s3
		s_add_i32 s12, s12, s11
		v_lshl_add_u32 v9, v8, 1, s12
		v_lshl_add_u32 v9, v13, 4, v9
		s_and_saveexec_b64 s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_126
		buffer_load_ushort v142, v9, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_126:
		s_andn2_b64 exec, s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_126
		v_mov_b32_e32 v142, 0
.L_attn_fwd_async_prefetch.exec_endif_126:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s10, s10, 14
		s_add_i32 s2, s10, s2
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s11
		v_lshl_add_u32 v8, v8, 1, s2
		v_lshl_add_u32 v8, v13, 4, v8
		s_and_saveexec_b64 s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_127
		buffer_load_ushort v9, v8, s[60:63], 0 offen
.L_attn_fwd_async_prefetch.exec_else_127:
		s_andn2_b64 exec, s[64:65], s[56:57]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_127
		v_mov_b32_e32 v9, 0
.L_attn_fwd_async_prefetch.exec_endif_127:
		s_mov_b64 exec, s[64:65]
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s62
		s_mov_b32 s31, s63
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s62
		s_mov_b32 s35, s63
		s_mov_b32 s2, 0x5040100
		s_waitcnt vmcnt(0)
		v_perm_b32 v144, v17, v16, s2
		v_perm_b32 v145, v19, v18, s2
		v_perm_b32 v146, v21, v20, s2
		v_perm_b32 v147, v23, v22, s2
		v_perm_b32 v16, v25, v24, s2
		v_perm_b32 v17, v27, v26, s2
		v_perm_b32 v18, v29, v28, s2
		v_perm_b32 v19, v31, v30, s2
		v_perm_b32 v20, v33, v32, s2
		v_perm_b32 v21, v35, v34, s2
		v_perm_b32 v22, v37, v36, s2
		v_perm_b32 v23, v39, v38, s2
		v_perm_b32 v24, v41, v40, s2
		v_perm_b32 v25, v43, v42, s2
		v_perm_b32 v26, v45, v44, s2
		v_perm_b32 v27, v47, v46, s2
		v_perm_b32 v28, v49, v48, s2
		v_perm_b32 v29, v51, v50, s2
		v_perm_b32 v30, v53, v52, s2
		v_perm_b32 v31, v55, v54, s2
		v_perm_b32 v32, v57, v56, s2
		v_perm_b32 v33, v59, v58, s2
		v_perm_b32 v34, v61, v60, s2
		v_perm_b32 v35, v63, v62, s2
		v_perm_b32 v36, v65, v64, s2
		v_perm_b32 v37, v67, v66, s2
		v_perm_b32 v38, v69, v68, s2
		v_perm_b32 v39, v71, v70, s2
		v_perm_b32 v40, v73, v72, s2
		v_perm_b32 v41, v75, v74, s2
		v_perm_b32 v42, v77, v76, s2
		v_perm_b32 v43, v79, v78, s2
		v_perm_b32 v44, v81, v80, s2
		v_perm_b32 v45, v83, v82, s2
		v_perm_b32 v46, v85, v84, s2
		v_perm_b32 v47, v87, v86, s2
		v_perm_b32 v48, v89, v88, s2
		v_perm_b32 v49, v91, v90, s2
		v_perm_b32 v50, v93, v92, s2
		v_perm_b32 v51, v95, v94, s2
		v_perm_b32 v52, v97, v96, s2
		v_perm_b32 v53, v99, v98, s2
		v_perm_b32 v54, v101, v100, s2
		v_perm_b32 v55, v103, v102, s2
		v_perm_b32 v56, v105, v104, s2
		v_perm_b32 v57, v107, v106, s2
		v_perm_b32 v58, v109, v108, s2
		v_perm_b32 v59, v111, v110, s2
		v_perm_b32 v60, v113, v112, s2
		v_perm_b32 v61, v115, v114, s2
		v_perm_b32 v62, v117, v116, s2
		v_perm_b32 v63, v119, v118, s2
		v_perm_b32 v64, v121, v120, s2
		v_perm_b32 v65, v123, v122, s2
		v_perm_b32 v66, v125, v124, s2
		v_perm_b32 v67, v127, v126, s2
		v_perm_b32 v68, v129, v128, s2
		v_perm_b32 v69, v131, v130, s2
		v_perm_b32 v70, v133, v132, s2
		v_perm_b32 v71, v135, v134, s2
		v_perm_b32 v72, v137, v136, s2
		v_perm_b32 v73, v139, v138, s2
		v_perm_b32 v74, v141, v140, s2
		v_perm_b32 v75, v9, v142, s2
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v8, 1, v3
		v_and_b32_e32 v9, 1, v11
		v_lshlrev_b32_e32 v9, 2, v9
		v_and_b32_e32 v7, 1, v7
		v_xor_b32_e32 v9, v9, v7
		v_bitop3_b32 v8, v0, v8, v9 bitop3:0x96
		v_lshlrev_b32_e32 v8, 4, v8
		v_add_u32_e32 v8, 0x10000, v8
		ds_write_b128 v8, v[144:147] offset:2480
		ds_write_b128 v8, v[16:19] offset:6576
		ds_write_b128 v8, v[20:23] offset:10672
		ds_write_b128 v8, v[24:27] offset:14768
		ds_write_b128 v8, v[28:31] offset:18864
		ds_write_b128 v8, v[32:35] offset:22960
		ds_write_b128 v8, v[36:39] offset:27056
		ds_write_b128 v8, v[40:43] offset:31152
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v14
		s_mul_i32 s2, s17, s13
		s_mul_i32 s3, s0, s14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v14, 13, v11
		v_add_u32_e32 v14, 0x10000, v14
		v_and_b32_e32 v16, 63, v0
		v_and_b32_e32 v17, 3, v16
		v_lshrrev_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v18, 5, v17
		v_lshrrev_b32_e32 v19, 4, v16
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 12, v19
		v_add3_u32 v18, v14, v18, v19
		v_lshrrev_b32_e32 v20, 2, v16
		v_bitop3_b32 v20, v20, 3, 1 bitop3:0x80
		v_lshl_add_u32 v21, v20, 6, v18
		v_lshrrev_b32_e32 v22, 5, v16
		v_and_b32_e32 v23, 15, v16
		v_lshlrev_b32_e32 v23, 4, v23
		v_add_u32_e32 v24, v22, v23
		v_and_b32_e32 v25, 1, v0
		v_xor_b32_e32 v24, v24, v25
		v_lshl_add_u32 v24, v24, 4, v21
		ds_read_b128 a[0:3], v24 offset:2480
		v_add_u32_e32 v14, v14, v19
		v_lshl_add_u32 v19, v20, 6, v14
		v_add3_u32 v26, 2, v22, v23
		v_lshlrev_b32_e32 v17, 1, v17
		v_xor_b32_e32 v27, v17, v25
		v_xor_b32_e32 v26, v26, v27
		v_lshl_add_u32 v26, v26, 4, v19
		ds_read_b128 a[4:7], v26 offset:2480
		v_add3_u32 v28, 4, v22, v23
		v_lshlrev_b32_e32 v20, 2, v20
		v_xor_b32_e32 v20, v20, v25
		v_xor_b32_e32 v28, v28, v20
		v_lshl_add_u32 v28, v28, 4, v18
		ds_read_b128 a[8:11], v28 offset:2480
		v_add3_u32 v29, 6, v22, v23
		v_xor_b32_e32 v17, v17, v20
		v_xor_b32_e32 v29, v29, v17
		v_lshl_add_u32 v29, v29, 4, v14
		ds_read_b128 a[12:15], v29 offset:2480
		v_add3_u32 v30, 8, v22, v23
		v_xor_b32_e32 v25, v30, v25
		v_lshl_add_u32 v21, v25, 4, v21
		ds_read_b128 a[16:19], v21 offset:2480
		v_add3_u32 v25, 10, v22, v23
		v_xor_b32_e32 v25, v25, v27
		v_lshl_add_u32 v19, v25, 4, v19
		ds_read_b128 a[20:23], v19 offset:2480
		v_add3_u32 v25, 12, v22, v23
		v_xor_b32_e32 v20, v25, v20
		v_lshl_add_u32 v18, v20, 4, v18
		ds_read_b128 a[24:27], v18 offset:2480
		v_add3_u32 v20, 14, v22, v23
		v_xor_b32_e32 v17, v20, v17
		v_lshl_add_u32 v14, v17, 4, v14
		ds_read_b128 a[28:31], v14 offset:2480
		s_mov_b32 s4, 63
		v_readfirstlane_b32 s5, v0
		v_lshlrev_b32_e32 v13, 4, v13
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v8, v[44:47] offset:2480
		ds_write_b128 v8, v[48:51] offset:6576
		ds_write_b128 v8, v[52:55] offset:10672
		ds_write_b128 v8, v[56:59] offset:14768
		ds_write_b128 v8, v[60:63] offset:18864
		ds_write_b128 v8, v[64:67] offset:22960
		ds_write_b128 v8, v[68:71] offset:27056
		ds_write_b128 v8, v[72:75] offset:31152
		v_and_b32_e32 v6, 1, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[32:35], v24 offset:2480
		ds_read_b128 a[36:39], v26 offset:2480
		ds_read_b128 a[40:43], v28 offset:2480
		ds_read_b128 a[44:47], v29 offset:2480
		ds_read_b128 a[48:51], v21 offset:2480
		ds_read_b128 a[52:55], v19 offset:2480
		ds_read_b128 a[56:59], v18 offset:2480
		ds_read_b128 a[60:63], v14 offset:2480
		s_add_i32 s6, s25, 63
		s_cmp_lt_i32 s6, 0
		s_cselect_b32 s4, s4, 0
		s_add_i32 s4, s6, s4
		s_ashr_i32 s4, s4, 6
		s_add_i32 s4, s4, -1
		s_cmp_gt_i32 s4, 0
		s_cselect_b32 s4, s4, 0
		v_mov_b32_e32 v8, 32
		v_mul_lo_u32 v8, v8, v5
		v_bitop3_b32 v14, v10, v8, v12 bitop3:0x96
		v_xor_b32_e32 v14, v14, v9
		v_bitop3_b32 v17, 4, v10, v8 bitop3:0x96
		v_bitop3_b32 v18, 8, v10, v8 bitop3:0x96
		v_bitop3_b32 v8, 12, v10, v8 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v14, s25
		s_lshl_b32 s2, s2, 1
		s_lshl_b32 s3, s3, 1
		s_add_i32 s6, s2, s3
		v_mul_lo_u32 v10, s15, v11
		v_lshlrev_b32_e32 v10, 1, v10
		v_mul_lo_u32 v19, s15, v3
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v20, s6, v10, v19
		v_mul_lo_u32 v21, s15, v7
		v_lshlrev_b32_e32 v21, 5, v21
		v_add3_u32 v20, v20, v21, v13
		v_mov_b32_e32 v23, 0x80000000
		v_cndmask_b32_e32 v20, v23, v20, vcc
		s_lshr_b32 s5, s5, 6
		s_mul_i32 s6, 0x410, s5
		s_mov_b32 m0, s6
		v_xad_u32 v4, v4, v15, s1
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_lshl_b32 s7, s15, 3
		s_add_i32 s7, s7, s2
		s_add_i32 s7, s7, s3
		v_add3_u32 v20, s7, v10, v19
		v_add3_u32 v20, v20, v21, v13
		v_cndmask_b32_e32 v20, v23, v20, vcc
		s_add_i32 m0, m0, 0x1040
		v_xad_u32 v1, v1, v15, s1
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_lshl_b32 s1, s15, 4
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s3
		v_add3_u32 v15, s1, v10, v19
		v_add3_u32 v15, v15, v21, v13
		v_cndmask_b32_e32 v15, v23, v15, vcc
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s1, 24, s15
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s3
		v_add3_u32 v15, s1, v10, v19
		v_add3_u32 v15, v15, v21, v13
		v_cndmask_b32_e32 v15, v23, v15, vcc
		s_add_i32 m0, m0, 0x1040
		v_and_b32_e32 v16, 31, v16
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		v_bitop3_b32 v15, v18, v12, v9 bitop3:0x96
		s_mul_i32 s1, s17, s18
		s_lshl_b32 s1, s1, 1
		s_mul_i32 s7, s0, s19
		s_lshl_b32 s7, s7, 1
		s_add_i32 s10, s1, s7
		v_mul_lo_u32 v18, s20, v11
		v_lshlrev_b32_e32 v18, 1, v18
		v_mul_lo_u32 v20, s20, v3
		v_lshlrev_b32_e32 v20, 6, v20
		v_add3_u32 v24, s10, v18, v20
		v_mul_lo_u32 v25, s20, v7
		v_lshlrev_b32_e32 v25, 5, v25
		v_add3_u32 v24, v24, v25, v13
		v_cndmask_b32_e32 v24, v23, v24, vcc
		s_mul_i32 s5, 0x440, s5
		s_add_i32 m0, s5, 0x81f0
		v_mov_b32_e32 v26, 0x880
		v_mul_lo_u32 v26, v26, v6
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		v_bitop3_b32 v6, v8, v12, v9 bitop3:0x96
		s_lshl_b32 s10, s20, 3
		s_add_i32 s10, s10, s1
		s_add_i32 s10, s10, s7
		v_add3_u32 v8, s10, v18, v20
		v_add3_u32 v8, v8, v25, v13
		v_cndmask_b32_e32 v8, v23, v8, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[10:11], v4, s25
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_lshl_b32 s12, s20, 4
		s_add_i32 s12, s12, s1
		s_add_i32 s12, s12, s7
		v_add3_u32 v4, s12, v18, v20
		v_add3_u32 v4, v4, v25, v13
		v_cndmask_b32_e32 v4, v23, v4, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[12:13], v1, s25
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_mul_i32 s14, 24, s20
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s7
		v_add3_u32 v1, s14, v18, v20
		v_add3_u32 v1, v1, v25, v13
		v_cndmask_b32_e32 v1, v23, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v4, v17, v12, v9 bitop3:0x96
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		s_mul_i32 s14, s4, 64
		v_mov_b32_e32 v1, 0xff800000
		v_mbcnt_lo_u32_b32 v8, -1, 0
		v_mbcnt_hi_u32_b32 v8, -1, v8
		v_and_b32_e32 v8, 31, v8
		v_add_u32_e32 v9, 32, v8
		v_mov_b32_e32 v28, 0x3e0293ee
		v_mov_b32_e32 v29, 0x3e0293ee
		s_mov_b32 s18, 0
		v_lshlrev_b32_e32 v12, 4, v22
		v_lshrrev_b32_e32 v17, 4, v16
		v_lshlrev_b32_e32 v17, 8, v17
		v_and_b32_e32 v16, 15, v16
		v_mov_b32_e32 v24, 0x410
		v_mul_lo_u32 v24, v24, v16
		v_and_b32_e32 v16, 3, v0
		v_lshlrev_b32_e32 v16, 3, v16
		v_mov_b32_e32 v27, 0x2200
		v_mul_lo_u32 v27, v27, v3
		v_lshlrev_b32_e32 v30, 5, v7
		v_and_b32_e32 v2, 1, v2
		v_mov_b32_e32 v31, 0x440
		v_mul_lo_u32 v31, v31, v2
		s_lshl_b32 s19, s15, 7
		s_add_i32 s19, s19, s2
		s_add_i32 s19, s19, s3
		s_mul_i32 s24, 0x88, s15
		s_add_i32 s24, s24, s2
		s_add_i32 s24, s24, s3
		s_mul_i32 s26, 0x90, s15
		s_add_i32 s26, s26, s2
		s_add_i32 s26, s26, s3
		s_mul_i32 s27, 0x98, s15
		s_add_i32 s2, s27, s2
		s_add_i32 s2, s2, s3
		s_lshl_b32 s3, s20, 7
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s7
		s_mul_i32 s27, 0x88, s20
		s_add_i32 s27, s27, s1
		s_add_i32 s27, s27, s7
		s_mul_i32 s36, 0x90, s20
		s_add_i32 s36, s36, s1
		s_add_i32 s36, s36, s7
		s_mul_i32 s37, 0x98, s20
		s_add_i32 s1, s37, s1
		s_add_i32 s1, s1, s7
		v_lshlrev_b32_e32 v2, 2, v8
		v_lshlrev_b32_e32 v8, 2, v9
		v_add3_u32 v9, v10, v19, v21
		v_add3_u32 v32, v18, v20, v25
		s_cmp_lt_i32 0, s14
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
		s_lshr_b32 s7, s18, 6
		s_and_b32 s37, s7, 1
		s_mul_i32 s38, 0x4100, s37
		v_add_u32_e32 v33, s38, v12
		v_add3_u32 v33, v33, v17, v24
		ds_read_b128 v[40:43], v33
		ds_read_b128 v[44:47], v33 offset:32
		ds_read_b128 v[176:179], v33 offset:64
		ds_read_b128 v[180:183], v33 offset:96
		ds_read_b128 v[184:187], v33 offset:128
		ds_read_b128 v[188:191], v33 offset:160
		ds_read_b128 v[192:195], v33 offset:192
		ds_read_b128 a[64:67], v33 offset:224
		ds_read_b128 v[196:199], v33 offset:512
		ds_read_b128 v[200:203], v33 offset:544
		ds_read_b128 v[204:207], v33 offset:576
		ds_read_b128 a[68:71], v33 offset:608
		ds_read_b128 a[72:75], v33 offset:640
		ds_read_b128 a[76:79], v33 offset:672
		ds_read_b128 a[80:83], v33 offset:704
		ds_read_b128 a[84:87], v33 offset:736
		s_mul_i32 s37, 0x4400, s37
		v_add_u32_e32 v33, s37, v16
		v_add3_u32 v33, v33, v27, v30
		v_add3_u32 v33, v33, v26, v31
		ds_read_b64_tr_b16 a[88:89], v33 offset:33264
		ds_read_b64_tr_b16 a[90:91], v33 offset:37616
		ds_read_b64_tr_b16 a[92:93], v33 offset:33520
		ds_read_b64_tr_b16 a[94:95], v33 offset:37872
		ds_read_b64_tr_b16 a[96:97], v33 offset:33776
		ds_read_b64_tr_b16 a[98:99], v33 offset:38128
		ds_read_b64_tr_b16 a[100:101], v33 offset:34032
		ds_read_b64_tr_b16 a[102:103], v33 offset:38384
		ds_read_b64_tr_b16 a[104:105], v33 offset:33328
		ds_read_b64_tr_b16 a[106:107], v33 offset:37680
		ds_read_b64_tr_b16 a[108:109], v33 offset:33584
		ds_read_b64_tr_b16 a[110:111], v33 offset:37936
		ds_read_b64_tr_b16 a[112:113], v33 offset:33840
		ds_read_b64_tr_b16 a[114:115], v33 offset:38192
		ds_read_b64_tr_b16 a[116:117], v33 offset:34096
		ds_read_b64_tr_b16 a[118:119], v33 offset:38448
		ds_read_b64_tr_b16 a[120:121], v33 offset:33392
		ds_read_b64_tr_b16 a[122:123], v33 offset:37744
		ds_read_b64_tr_b16 a[124:125], v33 offset:33648
		ds_read_b64_tr_b16 a[126:127], v33 offset:38000
		ds_read_b64_tr_b16 a[128:129], v33 offset:33904
		ds_read_b64_tr_b16 a[130:131], v33 offset:38256
		ds_read_b64_tr_b16 a[132:133], v33 offset:34160
		ds_read_b64_tr_b16 a[134:135], v33 offset:38512
		ds_read_b64_tr_b16 a[136:137], v33 offset:33456
		ds_read_b64_tr_b16 a[138:139], v33 offset:37808
		ds_read_b64_tr_b16 a[140:141], v33 offset:33712
		ds_read_b64_tr_b16 a[142:143], v33 offset:38064
		ds_read_b64_tr_b16 a[144:145], v33 offset:33968
		ds_read_b64_tr_b16 a[146:147], v33 offset:38320
		ds_read_b64_tr_b16 a[148:149], v33 offset:34224
		ds_read_b64_tr_b16 a[150:151], v33 offset:38576
		s_mul_i32 s37, s15, s18
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s19, s37
		v_add3_u32 v33, s38, v10, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[208:223], v[40:43], a[0:3], 0
		v_add3_u32 v33, v33, v21, v13
		v_mfma_f32_32x32x16_bf16 v[208:223], v[44:47], a[4:7], v[208:223]
		s_add_i32 s7, s7, 1
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[8:11], v[208:223]
		s_and_b32 s7, s7, 1
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[12:15], v[208:223]
		s_mul_i32 s38, 0x4100, s7
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[16:19], v[208:223]
		s_add_i32 s38, s6, s38
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[20:23], v[208:223]
		s_mov_b32 m0, s38
		v_mfma_f32_32x32x16_bf16 v[208:223], v[192:195], a[24:27], v[208:223]
		s_add_i32 s38, s24, s37
		v_mfma_f32_32x32x16_bf16 v[224:239], v[40:43], a[32:35], 0
		v_add3_u32 v38, v13, v9, s38
		v_mfma_f32_32x32x16_bf16 v[224:239], v[44:47], a[36:39], v[224:239]
		s_add_i32 s38, s26, s37
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[40:43], v[224:239]
		v_add3_u32 v39, v13, v9, s38
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[44:47], v[224:239]
		s_add_i32 s37, s2, s37
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[48:51], v[224:239]
		v_add3_u32 v40, v13, v9, s37
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[52:55], v[224:239]
		s_mul_i32 s37, s20, s18
		v_mfma_f32_32x32x16_bf16 v[224:239], v[192:195], a[56:59], v[224:239]
		s_add_i32 s18, s18, 64
		v_mfma_f32_32x32x16_bf16 v[176:191], v[196:199], a[0:3], 0
		v_add_u32_e32 v41, s18, v14
		v_mfma_f32_32x32x16_bf16 v[176:191], v[200:203], a[4:7], v[176:191]
		v_add_u32_e32 v42, s18, v4
		v_mfma_f32_32x32x16_bf16 v[176:191], v[204:207], a[8:11], v[176:191]
		v_add_u32_e32 v43, s18, v15
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[12:15], v[176:191]
		v_add_u32_e32 v44, s18, v6
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[16:19], v[176:191]
		v_cmp_lt_i32_e64 s[38:39], v41, s25
		v_mfma_f32_32x32x16_bf16 v[176:191], a[76:79], a[20:23], v[176:191]
		v_cmp_lt_i32_e64 vcc, v44, s25
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[24:27], v[176:191]
		v_cndmask_b32_e64 v33, v23, v33, s[38:39]
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[196:199], a[32:35], 0
		v_cmp_lt_i32_e64 s[40:41], v42, s25
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[42:43], v43, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[200:203], a[36:39], v[240:255]
		v_cndmask_b32_e64 v33, v23, v38, s[40:41]
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v33, v23, v39, s[42:43]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[204:207], a[40:43], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v38, v23, v40, vcc
		s_lshl_b32 s37, s37, 1
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
		s_add_i32 s44, s3, s37
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[44:47], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_add3_u32 v33, s44, v18, v20
		v_add3_u32 v33, v33, v25, v13
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[48:51], v[240:255]
		s_mul_i32 s7, 0x4400, s7
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[52:55], v[240:255]
		s_add_i32 s7, s5, s7
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[56:59], v[240:255]
		s_add_i32 m0, s7, 0x81f0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[64:67], a[28:31], v[208:223]
		v_cndmask_b32_e64 v33, v23, v33, s[38:39]
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[64:67], a[60:63], v[224:239]
		s_add_i32 s7, s27, s37
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[28:31], v[176:191]
		v_add3_u32 v33, v13, v32, s7
		v_cndmask_b32_e64 v33, v23, v33, s[40:41]
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s7, s36, s37
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[84:87], a[60:63], v[240:255]
		v_add3_u32 v33, v13, v32, s7
		v_max3_f32 v38, v208, v209, v210
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v33, v23, v33, s[42:43]
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		v_max3_f32 v33, v212, v213, v214
		s_add_i32 s7, s1, s37
		v_add3_u32 v39, v13, v32, s7
		v_cndmask_b32_e32 v39, v23, v39, vcc
		v_max3_f32 v40, v216, v217, v218
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v41, v220, v221, v222
		v_max3_f32 v42, v176, v177, v178
		v_max3_f32 v43, v180, v181, v182
		v_max3_f32 v44, v184, v185, v186
		v_max3_f32 v45, v188, v189, v190
		v_max3_f32 v33, v38, v211, v33
		v_max3_f32 v38, v40, v219, v41
		v_max3_f32 v40, v42, v179, v43
		v_max3_f32 v41, v44, v187, v45
		v_max3_f32 v33, v33, v215, v38
		v_max3_f32 v38, v40, v183, v41
		v_max3_f32 v33, v33, v223, v38
		v_max3_f32 v38, v224, v225, v226
		v_max3_f32 v40, v228, v229, v230
		v_max3_f32 v41, v232, v233, v234
		v_max3_f32 v42, v236, v237, v238
		buffer_load_dwordx4 v39, s[32:35], 0 offen lds
		v_max_f32_e32 v44, v33, v191
		v_mov_b32_e32 v45, v44
		v_max3_f32 v33, v240, v241, v242
		v_max3_f32 v39, v244, v245, v246
		v_max3_f32 v43, v248, v249, v250
		v_max3_f32 v46, v252, v253, v254
		v_max3_f32 v38, v38, v227, v40
		v_max3_f32 v40, v41, v235, v42
		v_max3_f32 v33, v33, v243, v39
		v_max3_f32 v39, v43, v251, v46
		v_max3_f32 v38, v38, v231, v40
		v_max3_f32 v33, v33, v247, v39
		v_max3_f32 v33, v38, v239, v33
		v_max_f32_e32 v38, v33, v255
		s_cmp_lt_i32 s18, s14
		v_mov_b32_e32 v39, v38
		v_permlane32_swap_b32_e32 v44, v45
		v_max_f32_e32 v40, v44, v45
		v_permlane32_swap_b32_e32 v38, v39
		v_max_f32_e32 v41, v38, v39
		v_pk_mul_f32 v[38:39], v[40:41], v[28:29]
		v_max_f32_e32 v40, v36, v38
		v_max_f32_e32 v41, v37, v39
		v_pk_fma_f32 v[38:39], v[208:209], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[210:211], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[212:213], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[214:215], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[216:217], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[218:219], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[220:221], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[222:223], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[176:177], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[28:29], v[40:41] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[224:225], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[226:227], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[228:229], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[230:231], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[232:233], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[234:235], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[236:237], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[238:239], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[240:241], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[242:243], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[244:245], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[246:247], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[224:225], v[248:249], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[226:227], v[250:251], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[228:229], v[252:253], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[230:231], v[254:255], v[28:29], v[40:41] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v232, v38
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
		v_exp_f32_e32 v233, v200
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
		v_exp_f32_e32 v198, v208
		v_exp_f32_e32 v200, v209
		v_exp_f32_e32 v202, v210
		v_exp_f32_e32 v204, v211
		v_exp_f32_e32 v206, v212
		v_exp_f32_e32 v208, v213
		v_exp_f32_e32 v210, v214
		v_exp_f32_e32 v212, v215
		v_exp_f32_e32 v177, v216
		v_exp_f32_e32 v179, v217
		v_exp_f32_e32 v181, v218
		v_exp_f32_e32 v183, v219
		v_exp_f32_e32 v185, v220
		v_exp_f32_e32 v187, v221
		v_exp_f32_e32 v189, v222
		v_exp_f32_e32 v191, v223
		v_exp_f32_e32 v199, v224
		v_exp_f32_e32 v201, v225
		v_exp_f32_e32 v203, v226
		v_exp_f32_e32 v205, v227
		v_exp_f32_e32 v207, v228
		v_exp_f32_e32 v209, v229
		v_exp_f32_e32 v211, v230
		v_exp_f32_e32 v213, v231
		v_pk_add_f32 v[214:215], v[232:233], v[234:235]
		v_pk_add_f32 v[216:217], v[38:39], v[236:237]
		v_pk_add_f32 v[218:219], v[42:43], v[238:239]
		v_pk_add_f32 v[220:221], v[44:45], v[240:241]
		v_pk_add_f32 v[222:223], v[46:47], v[242:243]
		v_pk_add_f32 v[224:225], v[192:193], v[244:245]
		v_pk_add_f32 v[226:227], v[194:195], v[246:247]
		v_pk_add_f32 v[228:229], v[196:197], v[248:249]
		v_pk_add_f32 v[214:215], v[214:215], v[216:217]
		v_pk_add_f32 v[216:217], v[218:219], v[220:221]
		v_pk_add_f32 v[218:219], v[222:223], v[224:225]
		v_pk_add_f32 v[220:221], v[226:227], v[228:229]
		v_pk_add_f32 v[214:215], v[214:215], v[216:217]
		v_pk_add_f32 v[216:217], v[218:219], v[220:221]
		v_pk_add_f32 v[218:219], v[214:215], v[216:217]
		v_add_f32_e32 v33, v218, v219
		ds_bpermute_b32 v214, v2, v33
		ds_bpermute_b32 v216, v8, v33
		v_pk_add_f32 v[218:219], v[176:177], v[178:179]
		v_pk_add_f32 v[220:221], v[180:181], v[182:183]
		v_pk_add_f32 v[222:223], v[184:185], v[186:187]
		v_pk_add_f32 v[224:225], v[188:189], v[190:191]
		v_pk_add_f32 v[226:227], v[198:199], v[200:201]
		v_pk_add_f32 v[228:229], v[202:203], v[204:205]
		v_pk_add_f32 v[230:231], v[206:207], v[208:209]
		v_pk_add_f32 v[250:251], v[210:211], v[212:213]
		v_pk_add_f32 v[218:219], v[218:219], v[220:221]
		v_pk_add_f32 v[220:221], v[222:223], v[224:225]
		v_pk_add_f32 v[222:223], v[226:227], v[228:229]
		v_pk_add_f32 v[224:225], v[230:231], v[250:251]
		v_pk_add_f32 v[218:219], v[218:219], v[220:221]
		v_pk_add_f32 v[220:221], v[222:223], v[224:225]
		v_pk_add_f32 v[222:223], v[218:219], v[220:221]
		v_mov_b32_e32 v217, v223
		v_mov_b32_e32 v215, v222
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[218:219], v[214:215], v[216:217]
		v_mov_b32_e32 v214, v219
		v_mov_b32_e32 v215, v219
		v_pk_add_f32 v[216:217], v[36:37], v[40:41] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v220, v232, v234
		v_permlane32_swap_b32_e32 v214, v215
		v_add_f32_e32 v37, v214, v215
		v_exp_f32_e32 v214, v216
		v_exp_f32_e32 v215, v217
		v_cvt_pk_bf16_f32 v221, v38, v236
		v_mov_b32_e32 v36, v218
		v_pk_fma_f32 v[34:35], v[34:35], v[214:215], v[36:37]
		v_cvt_pk_bf16_f32 v222, v42, v238
		v_cvt_pk_bf16_f32 v223, v44, v240
		v_cvt_pk_bf16_f32 v216, v46, v242
		v_cvt_pk_bf16_f32 v217, v192, v244
		v_cvt_pk_bf16_f32 v218, v194, v246
		v_cvt_pk_bf16_f32 v219, v196, v248
		v_cvt_pk_bf16_f32 v224, v233, v235
		v_cvt_pk_bf16_f32 v225, v39, v237
		v_cvt_pk_bf16_f32 v226, v43, v239
		v_cvt_pk_bf16_f32 v227, v45, v241
		v_cvt_pk_bf16_f32 v36, v47, v243
		v_cvt_pk_bf16_f32 v37, v193, v245
		v_cvt_pk_bf16_f32 v38, v195, v247
		v_cvt_pk_bf16_f32 v39, v197, v249
		v_pk_mul_f32 v[48:49], v[48:49], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[66:67], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[68:69], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[70:71], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[72:73], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[74:75], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[76:77], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[78:79], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[80:81], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[82:83], v[82:83], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[84:85], v[84:85], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[86:87], v[86:87], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[88:89], v[88:89], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[90:91], v[90:91], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[92:93], v[92:93], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[94:95], v[94:95], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[96:97], v[96:97], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[98:99], v[98:99], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[100:101], v[100:101], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[102:103], v[102:103], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[104:105], v[104:105], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[106:107], v[106:107], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[108:109], v[108:109], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[110:111], v[110:111], v[214:215] op_sel_hi:[1,0]
		v_pk_mul_f32 v[112:113], v[112:113], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[114:115], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[116:117], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[118:119], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[120:121], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[122:123], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[124:125], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[126:127], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[128:129], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[130:131], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[132:133], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[134:135], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[136:137], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[138:139], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[140:141], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[142:143], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[144:145], v[144:145], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[146:147], v[146:147], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[148:149], v[148:149], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[150:151], v[150:151], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[152:153], v[152:153], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[154:155], v[154:155], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[156:157], v[156:157], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[158:159], v[158:159], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[160:161], v[160:161], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[162:163], v[162:163], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[164:165], v[164:165], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[166:167], v[166:167], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[168:169], v[168:169], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[170:171], v[170:171], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[172:173], v[172:173], v[214:215] op_sel:[0,1]
		v_pk_mul_f32 v[174:175], v[174:175], v[214:215] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v44, v176, v178
		v_cvt_pk_bf16_f32 v45, v180, v182
		v_cvt_pk_bf16_f32 v46, v184, v186
		v_cvt_pk_bf16_f32 v47, v188, v190
		v_cvt_pk_bf16_f32 v192, v198, v200
		v_cvt_pk_bf16_f32 v193, v202, v204
		v_cvt_pk_bf16_f32 v194, v206, v208
		v_cvt_pk_bf16_f32 v195, v210, v212
		v_cvt_pk_bf16_f32 v228, v177, v179
		v_cvt_pk_bf16_f32 v229, v181, v183
		v_cvt_pk_bf16_f32 v230, v185, v187
		v_cvt_pk_bf16_f32 v231, v189, v191
		v_cvt_pk_bf16_f32 v176, v199, v201
		v_cvt_pk_bf16_f32 v177, v203, v205
		v_cvt_pk_bf16_f32 v178, v207, v209
		v_cvt_pk_bf16_f32 v179, v211, v213
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[220:223], v[64:79]
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[220:223], v[80:95]
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], v[220:223], v[96:111]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[160:175], a[136:139], v[44:47], v[160:175]
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], v[44:47], v[112:127]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], v[44:47], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[120:123], v[44:47], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[216:219], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], v[216:219], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[140:143], v[192:195], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], v[192:195], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[108:111], v[192:195], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[124:127], v[192:195], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[224:227], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], v[224:227], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[144:147], v[228:231], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], v[228:231], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], v[228:231], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], v[228:231], v[144:159]
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
		s_mov_b32 s30, s62
		s_mov_b32 s31, s63
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s4, 1
		s_mul_i32 s2, 0x4100, s1
		v_lshl_add_u32 v4, v22, 4, s2
		v_add3_u32 v4, v4, v17, v24
		ds_read_b128 v[12:15], v4
		ds_read_b128 v[20:23], v4 offset:32
		ds_read_b128 v[40:43], v4 offset:64
		ds_read_b128 v[44:47], v4 offset:96
		ds_read_b128 a[64:67], v4 offset:128
		ds_read_b128 a[68:71], v4 offset:160
		ds_read_b128 a[72:75], v4 offset:192
		ds_read_b128 a[76:79], v4 offset:224
		ds_read_b128 v[176:179], v4 offset:512
		ds_read_b128 v[180:183], v4 offset:544
		ds_read_b128 v[184:187], v4 offset:576
		ds_read_b128 v[188:191], v4 offset:608
		ds_read_b128 a[80:83], v4 offset:640
		ds_read_b128 a[84:87], v4 offset:672
		ds_read_b128 a[88:91], v4 offset:704
		ds_read_b128 a[92:95], v4 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_add3_u32 v4, s1, v16, v27
		v_lshl_add_u32 v4, v7, 5, v4
		v_add3_u32 v4, v4, v26, v31
		ds_read_b64_tr_b16 a[96:97], v4 offset:33264
		ds_read_b64_tr_b16 a[98:99], v4 offset:37616
		ds_read_b64_tr_b16 a[100:101], v4 offset:33520
		ds_read_b64_tr_b16 a[102:103], v4 offset:37872
		ds_read_b64_tr_b16 a[104:105], v4 offset:33776
		ds_read_b64_tr_b16 a[106:107], v4 offset:38128
		ds_read_b64_tr_b16 a[108:109], v4 offset:34032
		ds_read_b64_tr_b16 a[110:111], v4 offset:38384
		ds_read_b64_tr_b16 a[112:113], v4 offset:33328
		ds_read_b64_tr_b16 a[114:115], v4 offset:37680
		ds_read_b64_tr_b16 a[116:117], v4 offset:33584
		ds_read_b64_tr_b16 a[118:119], v4 offset:37936
		ds_read_b64_tr_b16 a[120:121], v4 offset:33840
		ds_read_b64_tr_b16 a[122:123], v4 offset:38192
		ds_read_b64_tr_b16 a[124:125], v4 offset:34096
		ds_read_b64_tr_b16 a[126:127], v4 offset:38448
		ds_read_b64_tr_b16 a[128:129], v4 offset:33392
		ds_read_b64_tr_b16 a[130:131], v4 offset:37744
		ds_read_b64_tr_b16 a[132:133], v4 offset:33648
		ds_read_b64_tr_b16 a[134:135], v4 offset:38000
		ds_read_b64_tr_b16 a[136:137], v4 offset:33904
		ds_read_b64_tr_b16 a[138:139], v4 offset:38256
		ds_read_b64_tr_b16 a[140:141], v4 offset:34160
		ds_read_b64_tr_b16 a[142:143], v4 offset:38512
		ds_read_b64_tr_b16 a[144:145], v4 offset:33456
		ds_read_b64_tr_b16 a[146:147], v4 offset:37808
		ds_read_b64_tr_b16 a[148:149], v4 offset:33712
		ds_read_b64_tr_b16 a[150:151], v4 offset:38064
		ds_read_b64_tr_b16 a[152:153], v4 offset:33968
		ds_read_b64_tr_b16 a[154:155], v4 offset:38320
		ds_read_b64_tr_b16 a[156:157], v4 offset:34224
		ds_read_b64_tr_b16 a[158:159], v4 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[12:15], a[0:3], 0
		s_mul_i32 s1, s16, s23
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[32:35], 0
		v_and_b32_e32 v0, 31, v0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[12:15], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[20:23], a[4:7], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[36:39], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[20:23], a[36:39], v[240:255]
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
		v_mov_b32_e32 v4, 4
		v_mul_lo_u32 v4, v4, v5
		v_add_u32_e32 v5, s14, v4
		v_xad_u32 v6, 16, v4, s14
		v_xad_u32 v7, 32, v4, s14
		v_xad_u32 v4, 48, v4, s14
		v_cmp_lt_i32_e64 s[2:3], v5, s25
		v_cmp_lt_i32_e64 s[4:5], v6, s25
		v_cmp_lt_i32_e64 s[6:7], v7, s25
		v_cmp_lt_i32_e64 vcc, v4, s25
		v_cndmask_b32_e64 v4, v1, v192, s[2:3]
		v_cndmask_b32_e64 v5, v1, v193, s[2:3]
		v_cndmask_b32_e64 v6, v1, v194, s[2:3]
		v_cndmask_b32_e64 v7, v1, v195, s[2:3]
		v_cndmask_b32_e64 v12, v1, v196, s[2:3]
		v_cndmask_b32_e64 v13, v1, v197, s[2:3]
		v_cndmask_b32_e64 v14, v1, v198, s[2:3]
		v_cndmask_b32_e64 v15, v1, v199, s[2:3]
		v_cndmask_b32_e64 v16, v1, v200, s[4:5]
		v_cndmask_b32_e64 v17, v1, v201, s[4:5]
		v_cndmask_b32_e64 v18, v1, v202, s[4:5]
		v_cndmask_b32_e64 v19, v1, v203, s[4:5]
		v_cndmask_b32_e64 v20, v1, v204, s[4:5]
		v_cndmask_b32_e64 v21, v1, v205, s[4:5]
		v_cndmask_b32_e64 v22, v1, v206, s[4:5]
		v_cndmask_b32_e64 v23, v1, v207, s[4:5]
		v_cndmask_b32_e64 v24, v1, v208, s[6:7]
		v_cndmask_b32_e64 v25, v1, v209, s[6:7]
		v_cndmask_b32_e64 v26, v1, v210, s[6:7]
		v_cndmask_b32_e64 v27, v1, v211, s[6:7]
		v_cndmask_b32_e64 v30, v1, v212, s[6:7]
		v_cndmask_b32_e64 v31, v1, v213, s[6:7]
		v_cndmask_b32_e64 v32, v1, v214, s[6:7]
		v_cndmask_b32_e64 v33, v1, v215, s[6:7]
		v_cndmask_b32_e32 v38, v1, v216, vcc
		v_cndmask_b32_e32 v39, v1, v217, vcc
		v_cndmask_b32_e32 v40, v1, v218, vcc
		v_cndmask_b32_e32 v41, v1, v219, vcc
		v_cndmask_b32_e32 v42, v1, v220, vcc
		v_cndmask_b32_e32 v43, v1, v221, vcc
		v_cndmask_b32_e32 v44, v1, v222, vcc
		v_cndmask_b32_e32 v45, v1, v223, vcc
		v_cndmask_b32_e64 v46, v1, v242, s[2:3]
		v_cndmask_b32_e64 v47, v1, v243, s[2:3]
		v_cndmask_b32_e64 v176, v1, v244, s[2:3]
		v_cndmask_b32_e64 v177, v1, v245, s[2:3]
		v_cndmask_b32_e64 v178, v1, v246, s[2:3]
		v_cndmask_b32_e64 v179, v1, v247, s[2:3]
		v_cndmask_b32_e64 v180, v1, v248, s[4:5]
		v_cndmask_b32_e64 v181, v1, v249, s[4:5]
		v_cndmask_b32_e64 v182, v1, v250, s[4:5]
		v_cndmask_b32_e64 v183, v1, v251, s[4:5]
		v_cndmask_b32_e64 v184, v1, v252, s[4:5]
		v_cndmask_b32_e64 v185, v1, v253, s[4:5]
		v_cndmask_b32_e64 v186, v1, v254, s[4:5]
		v_cndmask_b32_e64 v187, v1, v255, s[4:5]
		v_cndmask_b32_e64 v188, v1, v224, s[6:7]
		v_cndmask_b32_e64 v189, v1, v225, s[6:7]
		v_cndmask_b32_e64 v190, v1, v226, s[6:7]
		v_cndmask_b32_e64 v191, v1, v227, s[6:7]
		v_cndmask_b32_e64 v192, v1, v228, s[6:7]
		v_cndmask_b32_e64 v193, v1, v229, s[6:7]
		v_cndmask_b32_e64 v194, v1, v230, s[6:7]
		v_cndmask_b32_e64 v195, v1, v231, s[6:7]
		v_cndmask_b32_e32 v196, v1, v232, vcc
		v_cndmask_b32_e32 v197, v1, v233, vcc
		v_cndmask_b32_e32 v198, v1, v234, vcc
		v_cndmask_b32_e32 v199, v1, v235, vcc
		v_cndmask_b32_e32 v200, v1, v236, vcc
		v_cndmask_b32_e32 v201, v1, v237, vcc
		v_cndmask_b32_e32 v202, v1, v238, vcc
		v_cndmask_b32_e32 v203, v1, v239, vcc
		v_max3_f32 v9, v4, v5, v6
		v_max3_f32 v10, v12, v13, v14
		v_max3_f32 v204, v16, v17, v18
		v_max3_f32 v205, v20, v21, v22
		v_max3_f32 v206, v24, v25, v26
		v_max3_f32 v207, v30, v31, v32
		v_max3_f32 v208, v38, v39, v40
		v_max3_f32 v209, v42, v43, v44
		v_max3_f32 v9, v9, v7, v10
		v_max3_f32 v10, v204, v19, v205
		v_max3_f32 v204, v206, v27, v207
		v_max3_f32 v205, v208, v41, v209
		v_max3_f32 v9, v9, v15, v10
		v_max3_f32 v10, v204, v33, v205
		v_max3_f32 v9, v9, v23, v10
		v_max_f32_e32 v204, v9, v45
		v_mov_b32_e32 v205, v204
		v_cndmask_b32_e64 v206, v1, v240, s[2:3]
		v_cndmask_b32_e64 v207, v1, v241, s[2:3]
		v_permlane32_swap_b32_e32 v204, v205
		v_max3_f32 v1, v206, v207, v46
		v_max3_f32 v9, v176, v177, v178
		v_max3_f32 v10, v180, v181, v182
		v_max3_f32 v208, v184, v185, v186
		v_max3_f32 v209, v188, v189, v190
		v_max3_f32 v210, v192, v193, v194
		v_max3_f32 v211, v196, v197, v198
		v_max3_f32 v212, v200, v201, v202
		v_max3_f32 v1, v1, v47, v9
		v_max3_f32 v9, v10, v183, v208
		v_max3_f32 v10, v209, v191, v210
		v_max3_f32 v208, v211, v199, v212
		v_max3_f32 v1, v1, v179, v9
		v_max3_f32 v9, v10, v195, v208
		v_max3_f32 v1, v1, v187, v9
		v_max_f32_e32 v208, v1, v203
		v_mov_b32_e32 v209, v208
		v_max_f32_e32 v210, v204, v205
		s_lshl_b32 s1, s1, 9
		v_permlane32_swap_b32_e32 v208, v209
		v_max_f32_e32 v211, v208, v209
		v_pk_mul_f32 v[204:205], v[210:211], v[28:29]
		v_max_f32_e32 v208, v36, v204
		v_max_f32_e32 v209, v37, v205
		v_pk_fma_f32 v[204:205], v[4:5], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[4:5], v[6:7], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[6:7], v[12:13], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[14:15], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[14:15], v[16:17], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[18:19], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[20:21], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[22:23], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[24:25], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[26:27], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[30:31], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[32:33], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[32:33], v[38:39], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[38:39], v[40:41], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[40:41], v[42:43], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[44:45], v[28:29], v[208:209] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[206:207], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[46:47], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[176:177], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[28:29], v[208:209] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v28, v204
		v_exp_f32_e32 v202, v205
		v_exp_f32_e32 v204, v4
		v_exp_f32_e32 v210, v5
		v_exp_f32_e32 v4, v6
		v_exp_f32_e32 v212, v7
		v_exp_f32_e32 v6, v12
		v_exp_f32_e32 v214, v13
		v_exp_f32_e32 v12, v14
		v_exp_f32_e32 v216, v15
		v_exp_f32_e32 v14, v16
		v_exp_f32_e32 v218, v17
		v_exp_f32_e32 v16, v18
		v_exp_f32_e32 v220, v19
		v_exp_f32_e32 v18, v20
		v_exp_f32_e32 v222, v21
		v_exp_f32_e32 v29, v22
		v_exp_f32_e32 v203, v23
		v_exp_f32_e32 v205, v24
		v_exp_f32_e32 v211, v25
		v_exp_f32_e32 v5, v26
		v_exp_f32_e32 v213, v27
		v_exp_f32_e32 v7, v30
		v_exp_f32_e32 v215, v31
		v_exp_f32_e32 v13, v32
		v_exp_f32_e32 v217, v33
		v_exp_f32_e32 v15, v38
		v_exp_f32_e32 v219, v39
		v_exp_f32_e32 v17, v40
		v_exp_f32_e32 v221, v41
		v_exp_f32_e32 v19, v42
		v_exp_f32_e32 v223, v43
		v_exp_f32_e32 v20, v44
		v_exp_f32_e32 v22, v45
		v_exp_f32_e32 v24, v206
		v_exp_f32_e32 v26, v207
		v_exp_f32_e32 v30, v46
		v_exp_f32_e32 v32, v47
		v_exp_f32_e32 v38, v176
		v_exp_f32_e32 v40, v177
		v_exp_f32_e32 v42, v178
		v_exp_f32_e32 v44, v179
		v_exp_f32_e32 v46, v180
		v_exp_f32_e32 v176, v181
		v_exp_f32_e32 v178, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v182, v184
		v_exp_f32_e32 v206, v185
		v_exp_f32_e32 v21, v186
		v_exp_f32_e32 v23, v187
		v_exp_f32_e32 v25, v188
		v_exp_f32_e32 v27, v189
		v_exp_f32_e32 v31, v190
		v_exp_f32_e32 v33, v191
		v_exp_f32_e32 v39, v192
		v_exp_f32_e32 v41, v193
		v_exp_f32_e32 v43, v194
		v_exp_f32_e32 v45, v195
		v_exp_f32_e32 v47, v196
		v_exp_f32_e32 v177, v197
		v_exp_f32_e32 v179, v198
		v_exp_f32_e32 v181, v199
		v_exp_f32_e32 v183, v200
		v_exp_f32_e32 v207, v201
		v_pk_add_f32 v[184:185], v[28:29], v[202:203]
		v_pk_add_f32 v[186:187], v[204:205], v[210:211]
		v_pk_add_f32 v[188:189], v[4:5], v[212:213]
		v_pk_add_f32 v[190:191], v[6:7], v[214:215]
		v_pk_add_f32 v[192:193], v[12:13], v[216:217]
		v_pk_add_f32 v[194:195], v[14:15], v[218:219]
		v_pk_add_f32 v[196:197], v[16:17], v[220:221]
		v_pk_add_f32 v[198:199], v[18:19], v[222:223]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_add_f32_e32 v1, v188, v189
		ds_bpermute_b32 v184, v2, v1
		ds_bpermute_b32 v186, v8, v1
		v_pk_add_f32 v[8:9], v[20:21], v[22:23]
		v_pk_add_f32 v[188:189], v[24:25], v[26:27]
		v_pk_add_f32 v[190:191], v[30:31], v[32:33]
		v_pk_add_f32 v[192:193], v[38:39], v[40:41]
		v_pk_add_f32 v[194:195], v[42:43], v[44:45]
		v_pk_add_f32 v[196:197], v[46:47], v[176:177]
		v_pk_add_f32 v[198:199], v[178:179], v[180:181]
		v_pk_add_f32 v[200:201], v[182:183], v[206:207]
		v_pk_add_f32 v[8:9], v[8:9], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[8:9], v[8:9], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[8:9], v[188:189]
		v_mov_b32_e32 v187, v191
		v_mov_b32_e32 v185, v190
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[8:9], v[184:185], v[186:187]
		v_mov_b32_e32 v184, v9
		v_mov_b32_e32 v185, v9
		v_pk_add_f32 v[186:187], v[36:37], v[208:209] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v188, v28, v202
		v_permlane32_swap_b32_e32 v184, v185
		v_add_f32_e32 v37, v184, v185
		v_exp_f32_e32 v184, v186
		v_exp_f32_e32 v185, v187
		v_cvt_pk_bf16_f32 v189, v204, v210
		v_pk_mul_f32 v[224:225], v[48:49], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[226:227], v[50:51], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[228:229], v[52:53], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[230:231], v[54:55], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[232:233], v[56:57], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[234:235], v[58:59], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[236:237], v[60:61], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[238:239], v[62:63], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[64:65], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[66:67], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[68:69], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[70:71], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[72:73], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[74:75], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[76:77], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[78:79], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[80:81], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[82:83], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[84:85], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[86:87], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[88:89], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[90:91], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[92:93], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[94:95], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[96:97], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[82:83], v[98:99], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[84:85], v[100:101], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[86:87], v[102:103], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[88:89], v[104:105], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[90:91], v[106:107], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[92:93], v[108:109], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[94:95], v[110:111], v[184:185] op_sel_hi:[1,0]
		v_pk_mul_f32 v[96:97], v[112:113], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[98:99], v[114:115], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[100:101], v[116:117], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[102:103], v[118:119], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[104:105], v[120:121], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[106:107], v[122:123], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[108:109], v[124:125], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[110:111], v[126:127], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[112:113], v[128:129], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[130:131], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[132:133], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[134:135], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[136:137], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[138:139], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[140:141], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[142:143], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[144:145], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[146:147], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[148:149], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[150:151], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[152:153], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[154:155], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[156:157], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[158:159], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[144:145], v[160:161], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[146:147], v[162:163], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[148:149], v[164:165], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[150:151], v[166:167], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[152:153], v[168:169], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[154:155], v[170:171], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[156:157], v[172:173], v[184:185] op_sel:[0,1]
		v_pk_mul_f32 v[158:159], v[174:175], v[184:185] op_sel:[0,1]
		v_mov_b32_e32 v36, v8
		v_pk_fma_f32 v[8:9], v[34:35], v[184:185], v[36:37]
		v_cvt_pk_bf16_f32 v190, v4, v212
		v_cvt_pk_bf16_f32 v191, v6, v214
		v_cvt_pk_bf16_f32 v160, v12, v216
		v_cvt_pk_bf16_f32 v161, v14, v218
		v_cvt_pk_bf16_f32 v162, v16, v220
		v_cvt_pk_bf16_f32 v163, v18, v222
		v_cvt_pk_bf16_f32 v164, v29, v203
		v_cvt_pk_bf16_f32 v165, v205, v211
		v_cvt_pk_bf16_f32 v166, v5, v213
		v_cvt_pk_bf16_f32 v167, v7, v215
		v_cvt_pk_bf16_f32 v4, v13, v217
		v_cvt_pk_bf16_f32 v5, v15, v219
		v_cvt_pk_bf16_f32 v6, v17, v221
		v_cvt_pk_bf16_f32 v7, v19, v223
		v_cvt_pk_bf16_f32 v12, v20, v22
		v_cvt_pk_bf16_f32 v13, v24, v26
		v_cvt_pk_bf16_f32 v14, v30, v32
		v_cvt_pk_bf16_f32 v15, v38, v40
		v_cvt_pk_bf16_f32 v16, v42, v44
		v_cvt_pk_bf16_f32 v17, v46, v176
		v_cvt_pk_bf16_f32 v18, v178, v180
		v_cvt_pk_bf16_f32 v19, v182, v206
		v_cvt_pk_bf16_f32 v168, v21, v23
		v_cvt_pk_bf16_f32 v169, v25, v27
		v_cvt_pk_bf16_f32 v170, v31, v33
		v_cvt_pk_bf16_f32 v171, v39, v41
		v_cvt_pk_bf16_f32 v20, v43, v45
		v_cvt_pk_bf16_f32 v21, v47, v177
		v_cvt_pk_bf16_f32 v22, v179, v181
		v_cvt_pk_bf16_f32 v23, v183, v207
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], v[188:191], v[224:239]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		s_mul_i32 s2, s17, s21
		s_lshl_b32 s2, s2, 1
		s_add_i32 s3, s1, s2
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[188:191], v[64:79]
		s_mul_i32 s0, s0, s22
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[188:191], v[80:95]
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[12:15], v[144:159]
		s_add_i32 s3, s3, s0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], v[12:15], v[96:111]
		v_mul_lo_u32 v1, s23, v11
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[12:15], v[112:127]
		v_mul_lo_u32 v0, s23, v0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[12:15], v[128:143]
		v_lshl_add_u32 v2, v1, 6, s3
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], v[160:163], v[224:239]
		v_lshl_add_u32 v2, v0, 1, v2
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[160:163], v[48:63]
		v_lshl_add_u32 v2, v3, 4, v2
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[160:163], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[160:163], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[16:19], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], v[16:19], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[16:19], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[16:19], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], v[164:167], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[168:171], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], v[168:171], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[168:171], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[168:171], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], v[4:7], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[4:7], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[4:7], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[4:7], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[20:23], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[20:23], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[20:23], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[20:23], v[128:143]
		v_rcp_f32_e32 v4, v8
		v_rcp_f32_e32 v6, v9
		v_mov_b32_e32 v5, v4
		s_nop 1
		v_pk_mul_f32 v[8:9], v[224:225], v[4:5]
		v_pk_mul_f32 v[10:11], v[226:227], v[4:5]
		v_pk_mul_f32 v[12:13], v[228:229], v[4:5]
		v_pk_mul_f32 v[14:15], v[230:231], v[4:5]
		v_pk_mul_f32 v[16:17], v[232:233], v[4:5]
		v_pk_mul_f32 v[18:19], v[234:235], v[4:5]
		v_pk_mul_f32 v[20:21], v[236:237], v[4:5]
		v_pk_mul_f32 v[22:23], v[238:239], v[4:5]
		v_pk_mul_f32 v[24:25], v[48:49], v[4:5]
		v_pk_mul_f32 v[26:27], v[50:51], v[4:5]
		v_pk_mul_f32 v[28:29], v[52:53], v[4:5]
		v_pk_mul_f32 v[30:31], v[54:55], v[4:5]
		v_pk_mul_f32 v[32:33], v[56:57], v[4:5]
		v_pk_mul_f32 v[34:35], v[58:59], v[4:5]
		v_pk_mul_f32 v[36:37], v[60:61], v[4:5]
		v_pk_mul_f32 v[38:39], v[62:63], v[4:5]
		v_pk_mul_f32 v[40:41], v[64:65], v[4:5]
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
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[4:5], v[96:97], v[6:7]
		v_pk_mul_f32 v[72:73], v[98:99], v[6:7]
		v_pk_mul_f32 v[74:75], v[100:101], v[6:7]
		v_pk_mul_f32 v[76:77], v[102:103], v[6:7]
		v_pk_mul_f32 v[78:79], v[104:105], v[6:7]
		v_pk_mul_f32 v[80:81], v[106:107], v[6:7]
		v_pk_mul_f32 v[82:83], v[108:109], v[6:7]
		v_pk_mul_f32 v[84:85], v[110:111], v[6:7]
		v_pk_mul_f32 v[86:87], v[112:113], v[6:7]
		v_pk_mul_f32 v[88:89], v[114:115], v[6:7]
		v_pk_mul_f32 v[90:91], v[116:117], v[6:7]
		v_pk_mul_f32 v[92:93], v[118:119], v[6:7]
		v_pk_mul_f32 v[94:95], v[120:121], v[6:7]
		v_pk_mul_f32 v[96:97], v[122:123], v[6:7]
		v_pk_mul_f32 v[98:99], v[124:125], v[6:7]
		v_pk_mul_f32 v[100:101], v[126:127], v[6:7]
		v_pk_mul_f32 v[102:103], v[128:129], v[6:7]
		v_pk_mul_f32 v[104:105], v[130:131], v[6:7]
		v_pk_mul_f32 v[106:107], v[132:133], v[6:7]
		v_pk_mul_f32 v[108:109], v[134:135], v[6:7]
		v_pk_mul_f32 v[110:111], v[136:137], v[6:7]
		v_pk_mul_f32 v[112:113], v[138:139], v[6:7]
		v_pk_mul_f32 v[114:115], v[140:141], v[6:7]
		v_pk_mul_f32 v[116:117], v[142:143], v[6:7]
		v_pk_mul_f32 v[118:119], v[144:145], v[6:7]
		v_pk_mul_f32 v[120:121], v[146:147], v[6:7]
		v_pk_mul_f32 v[122:123], v[148:149], v[6:7]
		v_pk_mul_f32 v[124:125], v[150:151], v[6:7]
		v_pk_mul_f32 v[126:127], v[152:153], v[6:7]
		v_pk_mul_f32 v[128:129], v[154:155], v[6:7]
		v_pk_mul_f32 v[130:131], v[156:157], v[6:7]
		v_pk_mul_f32 v[132:133], v[158:159], v[6:7]
		v_cvt_pk_bf16_f32 v136, v8, v9
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
		v_cvt_pk_bf16_f32 v36, v4, v5
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
		v_and_b32_e32 v64, 0xffff, v136
		v_lshrrev_b32_e32 v65, 16, v136
		v_and_b32_e32 v65, 0xffff, v65
		v_and_b32_e32 v66, 0xffff, v137
		v_lshrrev_b32_e32 v67, 16, v137
		v_and_b32_e32 v67, 0xffff, v67
		v_and_b32_e32 v68, 0xffff, v138
		v_lshrrev_b32_e32 v69, 16, v138
		v_and_b32_e32 v69, 0xffff, v69
		v_and_b32_e32 v70, 0xffff, v139
		v_lshrrev_b32_e32 v71, 16, v139
		v_and_b32_e32 v71, 0xffff, v71
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_and_b32_e32 v72, 0xffff, v8
		v_lshrrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v8, 0xffff, v8
		v_and_b32_e32 v73, 0xffff, v9
		v_lshrrev_b32_e32 v9, 16, v9
		v_and_b32_e32 v9, 0xffff, v9
		v_and_b32_e32 v74, 0xffff, v10
		v_lshrrev_b32_e32 v10, 16, v10
		v_and_b32_e32 v10, 0xffff, v10
		v_and_b32_e32 v75, 0xffff, v11
		v_lshrrev_b32_e32 v11, 16, v11
		v_and_b32_e32 v11, 0xffff, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_and_b32_e32 v76, 0xffff, v12
		v_lshrrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v12, 0xffff, v12
		v_and_b32_e32 v77, 0xffff, v13
		v_lshrrev_b32_e32 v13, 16, v13
		v_and_b32_e32 v13, 0xffff, v13
		v_and_b32_e32 v78, 0xffff, v14
		v_lshrrev_b32_e32 v14, 16, v14
		v_and_b32_e32 v14, 0xffff, v14
		v_and_b32_e32 v79, 0xffff, v15
		v_lshrrev_b32_e32 v15, 16, v15
		v_and_b32_e32 v15, 0xffff, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_and_b32_e32 v80, 0xffff, v16
		v_lshrrev_b32_e32 v16, 16, v16
		v_and_b32_e32 v16, 0xffff, v16
		v_and_b32_e32 v81, 0xffff, v17
		v_lshrrev_b32_e32 v17, 16, v17
		v_and_b32_e32 v17, 0xffff, v17
		v_and_b32_e32 v82, 0xffff, v18
		v_lshrrev_b32_e32 v18, 16, v18
		v_and_b32_e32 v18, 0xffff, v18
		v_and_b32_e32 v83, 0xffff, v19
		v_lshrrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v19, 0xffff, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_and_b32_e32 v84, 0xffff, v20
		v_lshrrev_b32_e32 v20, 16, v20
		v_and_b32_e32 v20, 0xffff, v20
		v_and_b32_e32 v85, 0xffff, v21
		v_lshrrev_b32_e32 v21, 16, v21
		v_and_b32_e32 v21, 0xffff, v21
		v_and_b32_e32 v86, 0xffff, v22
		v_lshrrev_b32_e32 v22, 16, v22
		v_and_b32_e32 v22, 0xffff, v22
		v_and_b32_e32 v87, 0xffff, v23
		v_lshrrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v23, 0xffff, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_and_b32_e32 v88, 0xffff, v24
		v_lshrrev_b32_e32 v24, 16, v24
		v_and_b32_e32 v24, 0xffff, v24
		v_and_b32_e32 v89, 0xffff, v25
		v_lshrrev_b32_e32 v25, 16, v25
		v_and_b32_e32 v25, 0xffff, v25
		v_and_b32_e32 v90, 0xffff, v26
		v_lshrrev_b32_e32 v26, 16, v26
		v_and_b32_e32 v26, 0xffff, v26
		v_and_b32_e32 v91, 0xffff, v27
		v_lshrrev_b32_e32 v27, 16, v27
		v_and_b32_e32 v27, 0xffff, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_and_b32_e32 v92, 0xffff, v28
		v_lshrrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v28, 0xffff, v28
		v_and_b32_e32 v93, 0xffff, v29
		v_lshrrev_b32_e32 v29, 16, v29
		v_and_b32_e32 v29, 0xffff, v29
		v_and_b32_e32 v94, 0xffff, v30
		v_lshrrev_b32_e32 v30, 16, v30
		v_and_b32_e32 v30, 0xffff, v30
		v_and_b32_e32 v95, 0xffff, v31
		v_lshrrev_b32_e32 v31, 16, v31
		v_and_b32_e32 v31, 0xffff, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_and_b32_e32 v96, 0xffff, v32
		v_lshrrev_b32_e32 v32, 16, v32
		v_and_b32_e32 v32, 0xffff, v32
		v_and_b32_e32 v97, 0xffff, v33
		v_lshrrev_b32_e32 v33, 16, v33
		v_and_b32_e32 v33, 0xffff, v33
		v_and_b32_e32 v98, 0xffff, v34
		v_lshrrev_b32_e32 v34, 16, v34
		v_and_b32_e32 v34, 0xffff, v34
		v_and_b32_e32 v99, 0xffff, v35
		v_lshrrev_b32_e32 v35, 16, v35
		v_and_b32_e32 v35, 0xffff, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_and_b32_e32 v100, 0xffff, v36
		v_lshrrev_b32_e32 v36, 16, v36
		v_and_b32_e32 v36, 0xffff, v36
		v_and_b32_e32 v101, 0xffff, v37
		v_lshrrev_b32_e32 v37, 16, v37
		v_and_b32_e32 v37, 0xffff, v37
		v_and_b32_e32 v102, 0xffff, v38
		v_lshrrev_b32_e32 v38, 16, v38
		v_and_b32_e32 v38, 0xffff, v38
		v_and_b32_e32 v103, 0xffff, v39
		v_lshrrev_b32_e32 v39, 16, v39
		v_and_b32_e32 v39, 0xffff, v39
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_and_b32_e32 v104, 0xffff, v4
		v_lshrrev_b32_e32 v4, 16, v4
		v_and_b32_e32 v4, 0xffff, v4
		v_and_b32_e32 v105, 0xffff, v5
		v_lshrrev_b32_e32 v5, 16, v5
		v_and_b32_e32 v5, 0xffff, v5
		v_and_b32_e32 v106, 0xffff, v6
		v_lshrrev_b32_e32 v6, 16, v6
		v_and_b32_e32 v6, 0xffff, v6
		v_and_b32_e32 v107, 0xffff, v7
		v_lshrrev_b32_e32 v7, 16, v7
		v_and_b32_e32 v7, 0xffff, v7
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_and_b32_e32 v108, 0xffff, v40
		v_lshrrev_b32_e32 v40, 16, v40
		v_and_b32_e32 v40, 0xffff, v40
		v_and_b32_e32 v109, 0xffff, v41
		v_lshrrev_b32_e32 v41, 16, v41
		v_and_b32_e32 v41, 0xffff, v41
		v_and_b32_e32 v110, 0xffff, v42
		v_lshrrev_b32_e32 v42, 16, v42
		v_and_b32_e32 v42, 0xffff, v42
		v_and_b32_e32 v111, 0xffff, v43
		v_lshrrev_b32_e32 v43, 16, v43
		v_and_b32_e32 v43, 0xffff, v43
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_and_b32_e32 v112, 0xffff, v44
		v_lshrrev_b32_e32 v44, 16, v44
		v_and_b32_e32 v44, 0xffff, v44
		v_and_b32_e32 v113, 0xffff, v45
		v_lshrrev_b32_e32 v45, 16, v45
		v_and_b32_e32 v45, 0xffff, v45
		v_and_b32_e32 v114, 0xffff, v46
		v_lshrrev_b32_e32 v46, 16, v46
		v_and_b32_e32 v46, 0xffff, v46
		v_and_b32_e32 v115, 0xffff, v47
		v_lshrrev_b32_e32 v47, 16, v47
		v_and_b32_e32 v47, 0xffff, v47
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_and_b32_e32 v116, 0xffff, v48
		v_lshrrev_b32_e32 v48, 16, v48
		v_and_b32_e32 v48, 0xffff, v48
		v_and_b32_e32 v117, 0xffff, v49
		v_lshrrev_b32_e32 v49, 16, v49
		v_and_b32_e32 v49, 0xffff, v49
		v_and_b32_e32 v118, 0xffff, v50
		v_lshrrev_b32_e32 v50, 16, v50
		v_and_b32_e32 v50, 0xffff, v50
		v_and_b32_e32 v119, 0xffff, v51
		v_lshrrev_b32_e32 v51, 16, v51
		v_and_b32_e32 v51, 0xffff, v51
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_and_b32_e32 v120, 0xffff, v52
		v_lshrrev_b32_e32 v52, 16, v52
		v_and_b32_e32 v52, 0xffff, v52
		v_and_b32_e32 v121, 0xffff, v53
		v_lshrrev_b32_e32 v53, 16, v53
		v_and_b32_e32 v53, 0xffff, v53
		v_and_b32_e32 v122, 0xffff, v54
		v_lshrrev_b32_e32 v54, 16, v54
		v_and_b32_e32 v54, 0xffff, v54
		v_and_b32_e32 v123, 0xffff, v55
		v_lshrrev_b32_e32 v55, 16, v55
		v_and_b32_e32 v55, 0xffff, v55
		v_permlane32_swap_b32_e32 v56, v58
		v_permlane32_swap_b32_e32 v57, v59
		v_and_b32_e32 v124, 0xffff, v56
		v_lshrrev_b32_e32 v56, 16, v56
		v_and_b32_e32 v56, 0xffff, v56
		v_and_b32_e32 v125, 0xffff, v57
		v_lshrrev_b32_e32 v57, 16, v57
		v_and_b32_e32 v57, 0xffff, v57
		v_and_b32_e32 v126, 0xffff, v58
		v_lshrrev_b32_e32 v58, 16, v58
		v_and_b32_e32 v58, 0xffff, v58
		v_and_b32_e32 v127, 0xffff, v59
		v_lshrrev_b32_e32 v59, 16, v59
		v_and_b32_e32 v59, 0xffff, v59
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		v_and_b32_e32 v128, 0xffff, v60
		v_lshrrev_b32_e32 v60, 16, v60
		v_and_b32_e32 v60, 0xffff, v60
		v_and_b32_e32 v129, 0xffff, v61
		v_lshrrev_b32_e32 v61, 16, v61
		v_and_b32_e32 v61, 0xffff, v61
		v_and_b32_e32 v130, 0xffff, v62
		v_lshrrev_b32_e32 v62, 16, v62
		v_and_b32_e32 v62, 0xffff, v62
		v_and_b32_e32 v131, 0xffff, v63
		v_lshrrev_b32_e32 v63, 16, v63
		v_and_b32_e32 v63, 0xffff, v63
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_128
		buffer_store_short v64, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_128:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_128
.L_attn_fwd_async_prefetch.exec_endif_128:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 2
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_129
		buffer_store_short v65, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_129:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_129
.L_attn_fwd_async_prefetch.exec_endif_129:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 4
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_130
		buffer_store_short v66, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_130:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_130
.L_attn_fwd_async_prefetch.exec_endif_130:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 6
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_131
		buffer_store_short v67, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_131:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_131
.L_attn_fwd_async_prefetch.exec_endif_131:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 8
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_132
		buffer_store_short v68, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_132:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_132
.L_attn_fwd_async_prefetch.exec_endif_132:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 10
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_133
		buffer_store_short v69, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_133:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_133
.L_attn_fwd_async_prefetch.exec_endif_133:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 12
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_134
		buffer_store_short v70, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_134:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_134
.L_attn_fwd_async_prefetch.exec_endif_134:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 14
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_135
		buffer_store_short v71, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_135:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_135
.L_attn_fwd_async_prefetch.exec_endif_135:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 32
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_136
		buffer_store_short v72, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_136:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_136
.L_attn_fwd_async_prefetch.exec_endif_136:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 34
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_137
		buffer_store_short v8, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_137:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_137
.L_attn_fwd_async_prefetch.exec_endif_137:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 36
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_138
		buffer_store_short v73, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_138:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_138
.L_attn_fwd_async_prefetch.exec_endif_138:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 38
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_139
		buffer_store_short v9, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_139:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_139
.L_attn_fwd_async_prefetch.exec_endif_139:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 40
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_140
		buffer_store_short v74, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_140:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_140
.L_attn_fwd_async_prefetch.exec_endif_140:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 42
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_141
		buffer_store_short v10, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_141:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_141
.L_attn_fwd_async_prefetch.exec_endif_141:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 44
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_142
		buffer_store_short v75, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_142:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_142
.L_attn_fwd_async_prefetch.exec_endif_142:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 46
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_143
		buffer_store_short v11, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_143:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_143
.L_attn_fwd_async_prefetch.exec_endif_143:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 64
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_144
		buffer_store_short v76, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_144:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_144
.L_attn_fwd_async_prefetch.exec_endif_144:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x42
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_145
		buffer_store_short v12, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_145:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_145
.L_attn_fwd_async_prefetch.exec_endif_145:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x44
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_146
		buffer_store_short v77, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_146:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_146
.L_attn_fwd_async_prefetch.exec_endif_146:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x46
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_147
		buffer_store_short v13, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_147:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_147
.L_attn_fwd_async_prefetch.exec_endif_147:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x48
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_148
		buffer_store_short v78, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_148:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_148
.L_attn_fwd_async_prefetch.exec_endif_148:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x4a
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_149
		buffer_store_short v14, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_149:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_149
.L_attn_fwd_async_prefetch.exec_endif_149:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x4c
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_150
		buffer_store_short v79, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_150:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_150
.L_attn_fwd_async_prefetch.exec_endif_150:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x4e
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_151
		buffer_store_short v15, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_151:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_151
.L_attn_fwd_async_prefetch.exec_endif_151:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x60
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_152
		buffer_store_short v80, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_152:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_152
.L_attn_fwd_async_prefetch.exec_endif_152:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x62
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_153
		buffer_store_short v16, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_153:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_153
.L_attn_fwd_async_prefetch.exec_endif_153:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x64
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_154
		buffer_store_short v81, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_154:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_154
.L_attn_fwd_async_prefetch.exec_endif_154:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x66
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_155
		buffer_store_short v17, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_155:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_155
.L_attn_fwd_async_prefetch.exec_endif_155:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x68
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_156
		buffer_store_short v82, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_156:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_156
.L_attn_fwd_async_prefetch.exec_endif_156:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x6a
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_157
		buffer_store_short v18, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_157:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_157
.L_attn_fwd_async_prefetch.exec_endif_157:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x6c
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_158
		buffer_store_short v83, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_158:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_158
.L_attn_fwd_async_prefetch.exec_endif_158:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x6e
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_159
		buffer_store_short v19, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_159:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_159
.L_attn_fwd_async_prefetch.exec_endif_159:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x80
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_160
		buffer_store_short v84, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_160:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_160
.L_attn_fwd_async_prefetch.exec_endif_160:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x82
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_161
		buffer_store_short v20, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_161:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_161
.L_attn_fwd_async_prefetch.exec_endif_161:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x84
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_162
		buffer_store_short v85, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_162:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_162
.L_attn_fwd_async_prefetch.exec_endif_162:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x86
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_163
		buffer_store_short v21, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_163:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_163
.L_attn_fwd_async_prefetch.exec_endif_163:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x88
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_164
		buffer_store_short v86, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_164:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_164
.L_attn_fwd_async_prefetch.exec_endif_164:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x8a
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_165
		buffer_store_short v22, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_165:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_165
.L_attn_fwd_async_prefetch.exec_endif_165:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x8c
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_166
		buffer_store_short v87, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_166:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_166
.L_attn_fwd_async_prefetch.exec_endif_166:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0x8e
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_167
		buffer_store_short v23, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_167:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_167
.L_attn_fwd_async_prefetch.exec_endif_167:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xa0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_168
		buffer_store_short v88, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_168:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_168
.L_attn_fwd_async_prefetch.exec_endif_168:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xa2
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_169
		buffer_store_short v24, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_169:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_169
.L_attn_fwd_async_prefetch.exec_endif_169:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xa4
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_170
		buffer_store_short v89, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_170:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_170
.L_attn_fwd_async_prefetch.exec_endif_170:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xa6
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_171
		buffer_store_short v25, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_171:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_171
.L_attn_fwd_async_prefetch.exec_endif_171:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xa8
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_172
		buffer_store_short v90, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_172:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_172
.L_attn_fwd_async_prefetch.exec_endif_172:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xaa
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_173
		buffer_store_short v26, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_173:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_173
.L_attn_fwd_async_prefetch.exec_endif_173:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xac
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_174
		buffer_store_short v91, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_174:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_174
.L_attn_fwd_async_prefetch.exec_endif_174:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xae
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_175
		buffer_store_short v27, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_175:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_175
.L_attn_fwd_async_prefetch.exec_endif_175:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xc0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_176
		buffer_store_short v92, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_176:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_176
.L_attn_fwd_async_prefetch.exec_endif_176:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xc2
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_177
		buffer_store_short v28, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_177:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_177
.L_attn_fwd_async_prefetch.exec_endif_177:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xc4
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_178
		buffer_store_short v93, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_178:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_178
.L_attn_fwd_async_prefetch.exec_endif_178:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xc6
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_179
		buffer_store_short v29, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_179:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_179
.L_attn_fwd_async_prefetch.exec_endif_179:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xc8
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_180
		buffer_store_short v94, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_180:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_180
.L_attn_fwd_async_prefetch.exec_endif_180:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xca
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_181
		buffer_store_short v30, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_181:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_181
.L_attn_fwd_async_prefetch.exec_endif_181:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xcc
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_182
		buffer_store_short v95, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_182:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_182
.L_attn_fwd_async_prefetch.exec_endif_182:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xce
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_183
		buffer_store_short v31, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_183:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_183
.L_attn_fwd_async_prefetch.exec_endif_183:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xe0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_184
		buffer_store_short v96, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_184:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_184
.L_attn_fwd_async_prefetch.exec_endif_184:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xe2
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_185
		buffer_store_short v32, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_185:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_185
.L_attn_fwd_async_prefetch.exec_endif_185:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xe4
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_186
		buffer_store_short v97, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_186:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_186
.L_attn_fwd_async_prefetch.exec_endif_186:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xe6
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_187
		buffer_store_short v33, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_187:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_187
.L_attn_fwd_async_prefetch.exec_endif_187:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xe8
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_188
		buffer_store_short v98, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_188:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_188
.L_attn_fwd_async_prefetch.exec_endif_188:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xea
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_189
		buffer_store_short v34, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_189:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_189
.L_attn_fwd_async_prefetch.exec_endif_189:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xec
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_190
		buffer_store_short v99, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_190:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_190
.L_attn_fwd_async_prefetch.exec_endif_190:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s1, 0xee
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v2, v1, 6, s3
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_191
		buffer_store_short v35, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_191:
		s_andn2_b64 exec, s[64:65], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_191
.L_attn_fwd_async_prefetch.exec_endif_191:
		s_mov_b64 exec, s[64:65]
		s_lshl_b32 s3, s23, 8
		s_add_i32 s4, s3, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_192
		buffer_store_short v100, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_192:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_192
.L_attn_fwd_async_prefetch.exec_endif_192:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 2
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_193
		buffer_store_short v36, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_193:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_193
.L_attn_fwd_async_prefetch.exec_endif_193:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 4
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_194
		buffer_store_short v101, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_194:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_194
.L_attn_fwd_async_prefetch.exec_endif_194:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 6
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_195
		buffer_store_short v37, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_195:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_195
.L_attn_fwd_async_prefetch.exec_endif_195:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 8
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_196
		buffer_store_short v102, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_196:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_196
.L_attn_fwd_async_prefetch.exec_endif_196:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 10
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_197
		buffer_store_short v38, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_197:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_197
.L_attn_fwd_async_prefetch.exec_endif_197:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 12
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_198
		buffer_store_short v103, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_198:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_198
.L_attn_fwd_async_prefetch.exec_endif_198:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 14
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_199
		buffer_store_short v39, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_199:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_199
.L_attn_fwd_async_prefetch.exec_endif_199:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 32
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_200
		buffer_store_short v104, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_200:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_200
.L_attn_fwd_async_prefetch.exec_endif_200:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 34
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_201
		buffer_store_short v4, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_201:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_201
.L_attn_fwd_async_prefetch.exec_endif_201:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 36
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_202
		buffer_store_short v105, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_202:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_202
.L_attn_fwd_async_prefetch.exec_endif_202:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 38
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_203
		buffer_store_short v5, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_203:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_203
.L_attn_fwd_async_prefetch.exec_endif_203:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 40
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_204
		buffer_store_short v106, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_204:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_204
.L_attn_fwd_async_prefetch.exec_endif_204:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 42
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_205
		buffer_store_short v6, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_205:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_205
.L_attn_fwd_async_prefetch.exec_endif_205:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 44
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_206
		buffer_store_short v107, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_206:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_206
.L_attn_fwd_async_prefetch.exec_endif_206:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 46
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_207
		buffer_store_short v7, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_207:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_207
.L_attn_fwd_async_prefetch.exec_endif_207:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 64
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_208
		buffer_store_short v108, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_208:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_208
.L_attn_fwd_async_prefetch.exec_endif_208:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x42
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_209
		buffer_store_short v40, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_209:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_209
.L_attn_fwd_async_prefetch.exec_endif_209:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x44
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_210
		buffer_store_short v109, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_210:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_210
.L_attn_fwd_async_prefetch.exec_endif_210:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x46
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_211
		buffer_store_short v41, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_211:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_211
.L_attn_fwd_async_prefetch.exec_endif_211:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x48
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_212
		buffer_store_short v110, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_212:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_212
.L_attn_fwd_async_prefetch.exec_endif_212:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x4a
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_213
		buffer_store_short v42, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_213:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_213
.L_attn_fwd_async_prefetch.exec_endif_213:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x4c
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_214
		buffer_store_short v111, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_214:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_214
.L_attn_fwd_async_prefetch.exec_endif_214:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x4e
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_215
		buffer_store_short v43, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_215:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_215
.L_attn_fwd_async_prefetch.exec_endif_215:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x60
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_216
		buffer_store_short v112, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_216:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_216
.L_attn_fwd_async_prefetch.exec_endif_216:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x62
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_217
		buffer_store_short v44, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_217:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_217
.L_attn_fwd_async_prefetch.exec_endif_217:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x64
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_218
		buffer_store_short v113, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_218:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_218
.L_attn_fwd_async_prefetch.exec_endif_218:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x66
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_219
		buffer_store_short v45, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_219:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_219
.L_attn_fwd_async_prefetch.exec_endif_219:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x68
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_220
		buffer_store_short v114, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_220:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_220
.L_attn_fwd_async_prefetch.exec_endif_220:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x6a
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_221
		buffer_store_short v46, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_221:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_221
.L_attn_fwd_async_prefetch.exec_endif_221:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x6c
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_222
		buffer_store_short v115, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_222:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_222
.L_attn_fwd_async_prefetch.exec_endif_222:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x6e
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_223
		buffer_store_short v47, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_223:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_223
.L_attn_fwd_async_prefetch.exec_endif_223:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x80
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_224
		buffer_store_short v116, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_224:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_224
.L_attn_fwd_async_prefetch.exec_endif_224:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x82
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_225
		buffer_store_short v48, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_225:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_225
.L_attn_fwd_async_prefetch.exec_endif_225:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x84
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_226
		buffer_store_short v117, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_226:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_226
.L_attn_fwd_async_prefetch.exec_endif_226:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x86
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_227
		buffer_store_short v49, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_227:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_227
.L_attn_fwd_async_prefetch.exec_endif_227:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x88
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_228
		buffer_store_short v118, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_228:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_228
.L_attn_fwd_async_prefetch.exec_endif_228:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x8a
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_229
		buffer_store_short v50, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_229:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_229
.L_attn_fwd_async_prefetch.exec_endif_229:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x8c
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_230
		buffer_store_short v119, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_230:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_230
.L_attn_fwd_async_prefetch.exec_endif_230:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0x8e
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_231
		buffer_store_short v51, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_231:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_231
.L_attn_fwd_async_prefetch.exec_endif_231:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xa0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_232
		buffer_store_short v120, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_232:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_232
.L_attn_fwd_async_prefetch.exec_endif_232:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xa2
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_233
		buffer_store_short v52, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_233:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_233
.L_attn_fwd_async_prefetch.exec_endif_233:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xa4
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_234
		buffer_store_short v121, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_234:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_234
.L_attn_fwd_async_prefetch.exec_endif_234:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xa6
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_235
		buffer_store_short v53, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_235:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_235
.L_attn_fwd_async_prefetch.exec_endif_235:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xa8
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_236
		buffer_store_short v122, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_236:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_236
.L_attn_fwd_async_prefetch.exec_endif_236:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xaa
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_237
		buffer_store_short v54, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_237:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_237
.L_attn_fwd_async_prefetch.exec_endif_237:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xac
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_238
		buffer_store_short v123, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_238:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_238
.L_attn_fwd_async_prefetch.exec_endif_238:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xae
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_239
		buffer_store_short v55, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_239:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_239
.L_attn_fwd_async_prefetch.exec_endif_239:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xc0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_240
		buffer_store_short v124, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_240:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_240
.L_attn_fwd_async_prefetch.exec_endif_240:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xc2
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_241
		buffer_store_short v56, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_241:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_241
.L_attn_fwd_async_prefetch.exec_endif_241:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xc4
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_242
		buffer_store_short v125, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_242:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_242
.L_attn_fwd_async_prefetch.exec_endif_242:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xc6
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_243
		buffer_store_short v57, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_243:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_243
.L_attn_fwd_async_prefetch.exec_endif_243:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xc8
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_244
		buffer_store_short v126, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_244:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_244
.L_attn_fwd_async_prefetch.exec_endif_244:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xca
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_245
		buffer_store_short v58, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_245:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_245
.L_attn_fwd_async_prefetch.exec_endif_245:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xcc
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_246
		buffer_store_short v127, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_246:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_246
.L_attn_fwd_async_prefetch.exec_endif_246:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xce
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_247
		buffer_store_short v59, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_247:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_247
.L_attn_fwd_async_prefetch.exec_endif_247:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xe0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_248
		buffer_store_short v128, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_248:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_248
.L_attn_fwd_async_prefetch.exec_endif_248:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xe2
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_249
		buffer_store_short v60, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_249:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_249
.L_attn_fwd_async_prefetch.exec_endif_249:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xe4
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_250
		buffer_store_short v129, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_250:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_250
.L_attn_fwd_async_prefetch.exec_endif_250:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xe6
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_251
		buffer_store_short v61, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_251:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_251
.L_attn_fwd_async_prefetch.exec_endif_251:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xe8
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_252
		buffer_store_short v130, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_252:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_252
.L_attn_fwd_async_prefetch.exec_endif_252:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xea
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_253
		buffer_store_short v62, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_253:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_253
.L_attn_fwd_async_prefetch.exec_endif_253:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s4, s3, 0xec
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s2
		s_add_i32 s4, s4, s0
		v_lshl_add_u32 v2, v1, 6, s4
		v_lshl_add_u32 v2, v0, 1, v2
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_254
		buffer_store_short v131, v2, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_254:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_254
.L_attn_fwd_async_prefetch.exec_endif_254:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s3, s3, 0xee
		s_add_i32 s1, s3, s1
		s_add_i32 s1, s1, s2
		s_add_i32 s0, s1, s0
		v_lshl_add_u32 v1, v1, 6, s0
		v_lshl_add_u32 v0, v0, 1, v1
		v_lshl_add_u32 v0, v3, 4, v0
		s_and_saveexec_b64 s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_255
		buffer_store_short v63, v0, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_255:
		s_andn2_b64 exec, s[64:65], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_255
.L_attn_fwd_async_prefetch.exec_endif_255:
		s_mov_b64 exec, s[64:65]
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
		.amdhsa_next_free_sgpr 66
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
	.set .L_attn_fwd_async_prefetch.numbered_sgpr, 66
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
    .sgpr_count:     66
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
