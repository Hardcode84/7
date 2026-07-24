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
		v_and_b32_e32 v17, 1, v16
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v17
		v_xad_u32 v6, v6, v18, s1
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v2, v7
		v_bitop3_b32 v2, v2, v10, v12 bitop3:0x96
		v_xor_b32_e32 v2, v2, v15
		v_xad_u32 v2, v2, v18, s1
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v2, s25
		s_mov_b64 s[28:29], vcc
		v_lshrrev_b32_e32 v2, 5, v0
		v_and_b32_e32 v5, 1, v2
		v_mov_b32_e32 v6, 2
		v_mul_lo_u32 v6, v6, v5
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v14
		v_bitop3_b32 v10, v11, v6, v7 bitop3:0x96
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v17
		v_xad_u32 v10, v10, v15, s1
		v_bitop3_b32 v18, 16, v11, v6 bitop3:0x96
		v_xor_b32_e32 v18, v18, v7
		v_xad_u32 v18, v18, v15, s1
		v_bitop3_b32 v19, 32, v11, v6 bitop3:0x96
		v_xor_b32_e32 v19, v19, v7
		v_xad_u32 v19, v19, v15, s1
		v_bitop3_b32 v20, 48, v11, v6 bitop3:0x96
		v_xor_b32_e32 v20, v20, v7
		v_xad_u32 v20, v20, v15, s1
		v_bitop3_b32 v21, 64, v11, v6 bitop3:0x96
		v_xor_b32_e32 v21, v21, v7
		v_xad_u32 v21, v21, v15, s1
		v_xor_b32_e32 v22, 0x50, v11
		v_xor_b32_e32 v22, v22, v6
		v_xor_b32_e32 v22, v22, v7
		v_xad_u32 v22, v22, v15, s1
		v_xor_b32_e32 v23, 0x60, v11
		v_xor_b32_e32 v23, v23, v6
		v_xor_b32_e32 v23, v23, v7
		v_xad_u32 v23, v23, v15, s1
		v_xor_b32_e32 v24, 0x70, v11
		v_xor_b32_e32 v24, v24, v6
		v_xor_b32_e32 v24, v24, v7
		v_xad_u32 v24, v24, v15, s1
		v_xor_b32_e32 v25, 0x80, v11
		v_xor_b32_e32 v25, v25, v6
		v_xor_b32_e32 v25, v25, v7
		v_xad_u32 v25, v25, v15, s1
		v_xor_b32_e32 v26, 0x90, v11
		v_xor_b32_e32 v26, v26, v6
		v_xor_b32_e32 v26, v26, v7
		v_xad_u32 v26, v26, v15, s1
		v_xor_b32_e32 v27, 0xa0, v11
		v_xor_b32_e32 v27, v27, v6
		v_xor_b32_e32 v27, v27, v7
		v_xad_u32 v27, v27, v15, s1
		v_xor_b32_e32 v28, 0xb0, v11
		v_xor_b32_e32 v28, v28, v6
		v_xor_b32_e32 v28, v28, v7
		v_xad_u32 v28, v28, v15, s1
		v_xor_b32_e32 v29, 0xc0, v11
		v_xor_b32_e32 v29, v29, v6
		v_xor_b32_e32 v29, v29, v7
		v_xad_u32 v29, v29, v15, s1
		v_xor_b32_e32 v30, 0xd0, v11
		v_xor_b32_e32 v30, v30, v6
		v_xor_b32_e32 v30, v30, v7
		v_xad_u32 v30, v30, v15, s1
		v_xor_b32_e32 v31, 0xe0, v11
		v_xor_b32_e32 v31, v31, v6
		v_xor_b32_e32 v31, v31, v7
		v_xad_u32 v31, v31, v15, s1
		v_xor_b32_e32 v11, 0xf0, v11
		v_xor_b32_e32 v6, v11, v6
		v_xor_b32_e32 v6, v6, v7
		v_xad_u32 v6, v6, v15, s1
		s_mov_b32 s34, 0x7fffffff
		s_mov_b32 s35, 0x31016000
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		v_and_b32_e32 v1, 0xffff, v1
		v_lshlrev_b32_e32 v7, 16, v1
		v_or_b32_e32 v32, v1, v7
		v_mov_b32_e32 v33, v32
		v_mov_b32_e32 v34, v32
		v_mov_b32_e32 v35, v32
		s_mul_i32 s1, s16, s12
		s_lshl_b32 s1, s1, 9
		s_mul_i32 s2, s17, s10
		s_lshl_b32 s2, s2, 1
		s_add_i32 s3, s1, s2
		s_mul_i32 s10, s0, s11
		s_lshl_b32 s10, s10, 1
		s_add_i32 s3, s3, s10
		v_mul_lo_u32 v1, s12, v9
		v_lshl_add_u32 v7, v1, 1, s3
		v_and_b32_e32 v11, 1, v0
		v_lshl_add_u32 v7, v11, 4, v7
		v_and_b32_e32 v8, 1, v8
		v_lshl_add_u32 v7, v8, 7, v7
		v_and_b32_e32 v15, 1, v4
		v_lshl_add_u32 v7, v15, 6, v7
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v10, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_0
		buffer_load_dwordx4 v[36:39], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_0:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_0
		v_mov_b32_e32 v36, v32
		v_mov_b32_e32 v37, v33
		v_mov_b32_e32 v38, v34
		v_mov_b32_e32 v39, v35
.L_attn_fwd_async_prefetch.exec_endif_0:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s3, s12, 5
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v18, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_1
		buffer_load_dwordx4 v[40:43], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_1:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_1
		v_mov_b32_e32 v40, v32
		v_mov_b32_e32 v41, v33
		v_mov_b32_e32 v42, v34
		v_mov_b32_e32 v43, v35
.L_attn_fwd_async_prefetch.exec_endif_1:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s3, s12, 6
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v19, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_2
		buffer_load_dwordx4 v[44:47], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_2:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_2
		v_mov_b32_e32 v44, v32
		v_mov_b32_e32 v45, v33
		v_mov_b32_e32 v46, v34
		v_mov_b32_e32 v47, v35
.L_attn_fwd_async_prefetch.exec_endif_2:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0x60, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v20, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_3
		buffer_load_dwordx4 v[48:51], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_3:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_3
		v_mov_b32_e32 v48, v32
		v_mov_b32_e32 v49, v33
		v_mov_b32_e32 v50, v34
		v_mov_b32_e32 v51, v35
.L_attn_fwd_async_prefetch.exec_endif_3:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s3, s12, 7
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v21, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_4
		buffer_load_dwordx4 v[52:55], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_4:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_4
		v_mov_b32_e32 v52, v32
		v_mov_b32_e32 v53, v33
		v_mov_b32_e32 v54, v34
		v_mov_b32_e32 v55, v35
.L_attn_fwd_async_prefetch.exec_endif_4:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0xa0, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_5
		buffer_load_dwordx4 v[56:59], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_5:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_5
		v_mov_b32_e32 v56, v32
		v_mov_b32_e32 v57, v33
		v_mov_b32_e32 v58, v34
		v_mov_b32_e32 v59, v35
.L_attn_fwd_async_prefetch.exec_endif_5:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0xc0, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v23, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_6
		buffer_load_dwordx4 v[20:23], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_6:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_6
		v_mov_b32_e32 v20, v32
		v_mov_b32_e32 v21, v33
		v_mov_b32_e32 v22, v34
		v_mov_b32_e32 v23, v35
.L_attn_fwd_async_prefetch.exec_endif_6:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0xe0, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v24, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_7
		buffer_load_dwordx4 v[60:63], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_7:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_7
		v_mov_b32_e32 v60, v32
		v_mov_b32_e32 v61, v33
		v_mov_b32_e32 v62, v34
		v_mov_b32_e32 v63, v35
.L_attn_fwd_async_prefetch.exec_endif_7:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s3, s12, 8
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v25, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_8
		buffer_load_dwordx4 v[64:67], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_8:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_8
		v_mov_b32_e32 v64, v32
		v_mov_b32_e32 v65, v33
		v_mov_b32_e32 v66, v34
		v_mov_b32_e32 v67, v35
.L_attn_fwd_async_prefetch.exec_endif_8:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0x120, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v26, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_9
		buffer_load_dwordx4 v[68:71], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_9:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_9
		v_mov_b32_e32 v68, v32
		v_mov_b32_e32 v69, v33
		v_mov_b32_e32 v70, v34
		v_mov_b32_e32 v71, v35
.L_attn_fwd_async_prefetch.exec_endif_9:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0x140, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v27, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_10
		buffer_load_dwordx4 v[24:27], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_10:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_10
		v_mov_b32_e32 v24, v32
		v_mov_b32_e32 v25, v33
		v_mov_b32_e32 v26, v34
		v_mov_b32_e32 v27, v35
.L_attn_fwd_async_prefetch.exec_endif_10:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0x160, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v28, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_11
		buffer_load_dwordx4 v[72:75], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_11:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_11
		v_mov_b32_e32 v72, v32
		v_mov_b32_e32 v73, v33
		v_mov_b32_e32 v74, v34
		v_mov_b32_e32 v75, v35
.L_attn_fwd_async_prefetch.exec_endif_11:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0x180, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v29, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_12
		buffer_load_dwordx4 v[76:79], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_12:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_12
		v_mov_b32_e32 v76, v32
		v_mov_b32_e32 v77, v33
		v_mov_b32_e32 v78, v34
		v_mov_b32_e32 v79, v35
.L_attn_fwd_async_prefetch.exec_endif_12:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0x1a0, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v30, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_13
		buffer_load_dwordx4 v[80:83], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_13:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_13
		v_mov_b32_e32 v80, v32
		v_mov_b32_e32 v81, v33
		v_mov_b32_e32 v82, v34
		v_mov_b32_e32 v83, v35
.L_attn_fwd_async_prefetch.exec_endif_13:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0x1c0, s12
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s10
		v_lshl_add_u32 v7, v1, 1, s3
		v_lshl_add_u32 v7, v11, 4, v7
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshl_add_u32 v7, v15, 6, v7
		v_lshl_add_u32 v7, v3, 5, v7
		v_cmp_lt_i32_e64 vcc, v31, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_14
		buffer_load_dwordx4 v[28:31], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_14:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_14
		v_mov_b32_e32 v28, v32
		v_mov_b32_e32 v29, v33
		v_mov_b32_e32 v30, v34
		v_mov_b32_e32 v31, v35
.L_attn_fwd_async_prefetch.exec_endif_14:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s3, 0x1e0, s12
		s_add_i32 s1, s3, s1
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s10
		v_lshl_add_u32 v1, v1, 1, s1
		v_lshl_add_u32 v1, v11, 4, v1
		v_lshl_add_u32 v1, v8, 7, v1
		v_lshl_add_u32 v1, v15, 6, v1
		v_lshl_add_u32 v1, v3, 5, v1
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_15
		buffer_load_dwordx4 v[84:87], v1, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_15:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_15
		v_mov_b32_e32 v84, v32
		v_mov_b32_e32 v85, v33
		v_mov_b32_e32 v86, v34
		v_mov_b32_e32 v87, v35
.L_attn_fwd_async_prefetch.exec_endif_15:
		s_mov_b64 exec, s[48:49]
		s_mov_b32 s36, s4
		s_mov_b32 s37, s5
		s_mov_b32 s38, s34
		s_mov_b32 s39, s35
		s_mov_b32 s40, s6
		s_mov_b32 s41, s7
		s_mov_b32 s42, s34
		s_mov_b32 s43, s35
		v_lshlrev_b32_e32 v1, 3, v16
		v_and_b32_e32 v6, 1, v13
		v_lshlrev_b32_e32 v6, 2, v6
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v7, 1, v2
		v_and_b32_e32 v9, 1, v9
		v_bitop3_b32 v7, v7, v0, v9 bitop3:0x96
		v_bitop3_b32 v1, v1, v6, v7 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		s_waitcnt vmcnt(0)
		ds_write_b128 v1, v[36:39] offset:2480
		ds_write_b128 v1, v[40:43] offset:6576
		ds_write_b128 v1, v[44:47] offset:10672
		ds_write_b128 v1, v[48:51] offset:14768
		ds_write_b128 v1, v[52:55] offset:18864
		ds_write_b128 v1, v[56:59] offset:22960
		ds_write_b128 v1, v[20:23] offset:27056
		ds_write_b128 v1, v[60:63] offset:31152
		v_lshlrev_b32_e32 v6, 13, v13
		v_add_u32_e32 v6, 0x10000, v6
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v10, 4, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v10, 1, v10
		v_lshl_add_u32 v6, v10, 12, v6
		v_lshrrev_b32_e32 v10, 3, v7
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v16, 7, v10
		v_add_u32_e32 v18, v6, v16
		v_lshrrev_b32_e32 v19, 2, v7
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v20, 6, v19
		v_add_u32_e32 v21, v18, v20
		v_lshrrev_b32_e32 v22, 1, v7
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v23, 5, v22
		v_add_u32_e32 v32, v21, v23
		v_lshrrev_b32_e32 v33, 5, v7
		v_and_b32_e32 v34, 1, v7
		v_lshlrev_b32_e32 v35, 4, v34
		v_add3_u32 v36, v33, v16, v20
		v_add3_u32 v36, v36, v23, v35
		v_xor_b32_e32 v37, v36, v34
		v_lshl_add_u32 v32, v37, 4, v32
		ds_read_b128 a[0:3], v32 offset:2480
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v37, 2, v36
		v_bitop3_b32 v37, v22, v37, v34 bitop3:0x96
		v_lshl_add_u32 v21, v37, 4, v21
		ds_read_b128 a[4:7], v21 offset:2480
		v_add_u32_e32 v36, 4, v36
		v_xad_u32 v36, v36, v34, v22
		v_lshlrev_b32_e32 v19, 2, v19
		v_xor_b32_e32 v36, v36, v19
		v_lshl_add_u32 v36, v36, 4, v18
		ds_read_b128 a[8:11], v36 offset:2480
		v_add_u32_e32 v37, 6, v33
		v_add3_u32 v37, v37, v16, v20
		v_add3_u32 v37, v37, v23, v35
		v_xor_b32_e32 v37, v37, v34
		v_bitop3_b32 v37, v19, v22, v37 bitop3:0x96
		v_lshl_add_u32 v18, v37, 4, v18
		ds_read_b128 a[12:15], v18 offset:2480
		v_add_u32_e32 v37, 8, v33
		v_add3_u32 v37, v37, v16, v20
		v_add3_u32 v37, v37, v23, v35
		v_xor_b32_e32 v37, v37, v34
		v_add3_u32 v37, v19, v22, v37
		v_lshlrev_b32_e32 v10, 3, v10
		v_xor_b32_e32 v37, v37, v10
		v_lshl_add_u32 v37, v37, 4, v6
		ds_read_b128 a[16:19], v37 offset:2480
		v_add_u32_e32 v38, 10, v33
		v_add3_u32 v38, v38, v16, v20
		v_add3_u32 v38, v38, v23, v35
		v_xor_b32_e32 v38, v38, v34
		v_xad_u32 v38, v22, v38, v19
		v_xor_b32_e32 v38, v38, v10
		v_lshl_add_u32 v38, v38, 4, v6
		ds_read_b128 a[20:23], v38 offset:2480
		v_add_u32_e32 v39, 12, v33
		v_add3_u32 v39, v39, v16, v20
		v_add3_u32 v39, v39, v23, v35
		v_xad_u32 v39, v39, v34, v22
		v_bitop3_b32 v39, v10, v39, v19 bitop3:0x96
		v_lshl_add_u32 v39, v39, 4, v6
		ds_read_b128 a[24:27], v39 offset:2480
		v_add_u32_e32 v40, 14, v33
		v_add3_u32 v16, v40, v16, v20
		v_add3_u32 v16, v16, v23, v35
		v_bitop3_b32 v16, v22, v16, v34 bitop3:0x96
		v_bitop3_b32 v10, v10, v19, v16 bitop3:0x96
		v_lshl_add_u32 v6, v10, 4, v6
		ds_read_b128 a[28:31], v6 offset:2480
		s_mov_b32 s1, 63
		v_mov_b32_e32 v10, 32
		v_mul_lo_u32 v10, v10, v5
		v_bitop3_b32 v16, v12, v10, v14 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[64:67] offset:2480
		ds_write_b128 v1, v[68:71] offset:6576
		ds_write_b128 v1, v[24:27] offset:10672
		ds_write_b128 v1, v[72:75] offset:14768
		ds_write_b128 v1, v[76:79] offset:18864
		ds_write_b128 v1, v[80:83] offset:22960
		ds_write_b128 v1, v[28:31] offset:27056
		ds_write_b128 v1, v[84:87] offset:31152
		v_mov_b32_e32 v1, 2
		v_mul_lo_u32 v1, v1, v17
		v_xor_b32_e32 v16, v16, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[32:35], v32 offset:2480
		ds_read_b128 a[36:39], v21 offset:2480
		ds_read_b128 a[40:43], v36 offset:2480
		ds_read_b128 a[44:47], v18 offset:2480
		ds_read_b128 a[48:51], v37 offset:2480
		ds_read_b128 a[52:55], v38 offset:2480
		ds_read_b128 a[56:59], v39 offset:2480
		ds_read_b128 a[60:63], v6 offset:2480
		s_add_i32 s2, s25, 63
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s2, s1
		s_ashr_i32 s1, s1, 6
		s_add_i32 s1, s1, -1
		s_cmp_gt_i32 s1, 0
		s_cselect_b32 s1, s1, 0
		v_cmp_lt_i32_e64 vcc, v16, s25
		v_readfirstlane_b32 s2, v0
		v_mul_lo_u32 v6, s15, v13
		v_mul_lo_u32 v17, s15, v2
		v_lshlrev_b32_e32 v17, 6, v17
		v_lshl_add_u32 v6, v6, 1, v17
		v_mul_lo_u32 v17, s15, v9
		v_lshl_add_u32 v6, v17, 5, v6
		v_lshlrev_b32_e32 v17, 4, v11
		v_lshlrev_b32_e32 v18, 7, v8
		v_add3_u32 v6, v6, v17, v18
		v_lshlrev_b32_e32 v19, 6, v15
		v_lshlrev_b32_e32 v20, 5, v3
		v_add3_u32 v6, v6, v19, v20
		s_mul_i32 s3, s17, s13
		s_lshl_b32 s3, s3, 1
		s_mul_i32 s4, s0, s14
		s_lshl_b32 s4, s4, 1
		s_add_i32 s5, s3, s4
		v_add_u32_e32 v21, s5, v6
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e32 v21, v22, v21, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s5, 0x410, s2
		s_mov_b32 m0, s5
		v_bitop3_b32 v23, 4, v12, v10 bitop3:0x96
		buffer_load_dwordx4 v21, s[36:39], 0 offen lds
		s_lshl_b32 s6, s15, 3
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		v_add_u32_e32 v21, s6, v6
		v_cndmask_b32_e32 v21, v22, v21, vcc
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v24, 8, v12, v10 bitop3:0x96
		buffer_load_dwordx4 v21, s[36:39], 0 offen lds
		s_lshl_b32 s6, s15, 4
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		v_add_u32_e32 v21, s6, v6
		v_cndmask_b32_e32 v21, v22, v21, vcc
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v10, 12, v12, v10 bitop3:0x96
		buffer_load_dwordx4 v21, s[36:39], 0 offen lds
		s_mul_i32 s6, 24, s15
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		v_add_u32_e32 v12, s6, v6
		v_cndmask_b32_e32 v12, v22, v12, vcc
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v21, v23, v14, v1 bitop3:0x96
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		v_mul_lo_u32 v12, s20, v13
		v_mul_lo_u32 v23, s20, v2
		v_lshlrev_b32_e32 v23, 6, v23
		v_lshl_add_u32 v12, v12, 1, v23
		v_mul_lo_u32 v23, s20, v9
		v_lshl_add_u32 v12, v23, 5, v12
		v_add3_u32 v12, v12, v17, v18
		v_add3_u32 v12, v12, v19, v20
		s_mul_i32 s6, s17, s18
		s_lshl_b32 s6, s6, 1
		s_mul_i32 s7, s0, s19
		s_lshl_b32 s7, s7, 1
		s_add_i32 s10, s6, s7
		v_add_u32_e32 v17, s10, v12
		v_cndmask_b32_e32 v17, v22, v17, vcc
		s_mul_i32 s2, 0x440, s2
		s_add_i32 m0, s2, 0x81f0
		v_bitop3_b32 v18, v24, v14, v1 bitop3:0x96
		buffer_load_dwordx4 v17, s[40:43], 0 offen lds
		s_lshl_b32 s10, s20, 3
		s_add_i32 s10, s10, s6
		s_add_i32 s10, s10, s7
		v_add_u32_e32 v17, s10, v12
		v_cndmask_b32_e32 v17, v22, v17, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v1, v10, v14, v1 bitop3:0x96
		buffer_load_dwordx4 v17, s[40:43], 0 offen lds
		s_lshl_b32 s10, s20, 4
		s_add_i32 s10, s10, s6
		s_add_i32 s10, s10, s7
		v_add_u32_e32 v10, s10, v12
		v_cndmask_b32_e32 v10, v22, v10, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s10, 24, s20
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 s10, s10, s6
		s_add_i32 s10, s10, s7
		v_add_u32_e32 v10, s10, v12
		v_cndmask_b32_e32 v10, v22, v10, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s10, s1, 64
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		v_mbcnt_lo_u32_b32 v10, -1, 0
		v_mbcnt_hi_u32_b32 v10, -1, v10
		v_and_b32_e32 v14, 1, v10
		v_lshrrev_b32_e32 v17, 4, v10
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 4, v17
		v_lshrrev_b32_e32 v19, 3, v10
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 3, v19
		v_add3_u32 v20, v14, v17, v19
		v_lshrrev_b32_e32 v23, 2, v10
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 2, v23
		v_lshrrev_b32_e32 v10, 1, v10
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add3_u32 v20, v20, v23, v10
		v_add_u32_e32 v14, 32, v14
		v_bitop3_b32 v10, v23, v14, v10 bitop3:0x96
		v_bitop3_b32 v10, v17, v19, v10 bitop3:0x96
		v_mov_b32_e32 v24, 0x3e0293ee
		v_mov_b32_e32 v25, 0x3e0293ee
		s_mov_b32 s11, 0xff800000
		v_mov_b32_e32 v14, s11
		s_mov_b32 s12, 0
		v_lshlrev_b32_e32 v17, 4, v33
		v_and_b32_e32 v7, 31, v7
		v_lshrrev_b32_e32 v19, 4, v7
		v_lshlrev_b32_e32 v23, 8, v19
		v_lshrrev_b32_e32 v26, 3, v7
		v_and_b32_e32 v26, 1, v26
		v_mov_b32_e32 v27, 0x2080
		v_mul_lo_u32 v27, v27, v26
		v_lshrrev_b32_e32 v26, 2, v7
		v_and_b32_e32 v26, 1, v26
		v_mov_b32_e32 v28, 0x1040
		v_mul_lo_u32 v28, v28, v26
		v_lshrrev_b32_e32 v26, 1, v7
		v_and_b32_e32 v26, 1, v26
		v_mov_b32_e32 v29, 0x820
		v_mul_lo_u32 v29, v29, v26
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v26, 0x410
		v_mul_lo_u32 v26, v26, v7
		v_and_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 3, v0
		v_mov_b32_e32 v7, 0x2200
		v_mul_lo_u32 v7, v7, v2
		v_lshlrev_b32_e32 v30, 5, v9
		v_and_b32_e32 v4, 3, v4
		v_mov_b32_e32 v31, 0x440
		v_mul_lo_u32 v31, v31, v4
		s_lshl_b32 s13, s15, 7
		s_add_i32 s13, s13, s3
		s_add_i32 s13, s13, s4
		s_mul_i32 s14, 0x88, s15
		s_add_i32 s14, s14, s3
		s_add_i32 s14, s14, s4
		s_mul_i32 s18, 0x90, s15
		s_add_i32 s18, s18, s3
		s_add_i32 s18, s18, s4
		s_mul_i32 s19, 0x98, s15
		s_add_i32 s3, s19, s3
		s_add_i32 s3, s3, s4
		s_lshl_b32 s4, s20, 7
		s_add_i32 s4, s4, s6
		s_add_i32 s4, s4, s7
		s_mul_i32 s19, 0x88, s20
		s_add_i32 s19, s19, s6
		s_add_i32 s19, s19, s7
		s_mul_i32 s24, 0x90, s20
		s_add_i32 s24, s24, s6
		s_add_i32 s24, s24, s7
		s_mul_i32 s30, 0x98, s20
		s_add_i32 s6, s30, s6
		s_add_i32 s6, s6, s7
		v_lshlrev_b32_e32 v4, 2, v20
		v_lshlrev_b32_e32 v10, 2, v10
		s_cmp_lt_i32 0, s10
		v_mov_b32_e32 v34, 1.0
		v_mov_b32_e32 v35, 1.0
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		v_mov_b32_e32 v20, s11
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
		s_lshr_b32 s7, s12, 6
		s_and_b32 s11, s7, 1
		s_mul_i32 s30, 0x4100, s11
		v_add3_u32 v32, s30, v17, v23
		v_add3_u32 v32, v32, v27, v28
		v_add3_u32 v32, v32, v29, v26
		ds_read_b128 v[36:39], v32
		ds_read_b128 v[40:43], v32 offset:32
		ds_read_b128 v[44:47], v32 offset:64
		ds_read_b128 a[64:67], v32 offset:96
		ds_read_b128 a[68:71], v32 offset:128
		ds_read_b128 a[72:75], v32 offset:160
		ds_read_b128 a[76:79], v32 offset:192
		ds_read_b128 a[80:83], v32 offset:224
		ds_read_b128 v[176:179], v32 offset:512
		ds_read_b128 v[180:183], v32 offset:544
		ds_read_b128 v[184:187], v32 offset:576
		ds_read_b128 a[84:87], v32 offset:608
		ds_read_b128 a[88:91], v32 offset:640
		ds_read_b128 a[92:95], v32 offset:672
		ds_read_b128 a[96:99], v32 offset:704
		ds_read_b128 a[100:103], v32 offset:736
		s_mul_i32 s11, 0x4400, s11
		v_add3_u32 v32, s11, v0, v7
		v_add3_u32 v32, v32, v30, v31
		ds_read_b64_tr_b16 a[104:105], v32 offset:33264
		ds_read_b64_tr_b16 a[106:107], v32 offset:37616
		ds_read_b64_tr_b16 a[108:109], v32 offset:33520
		ds_read_b64_tr_b16 a[110:111], v32 offset:37872
		ds_read_b64_tr_b16 a[112:113], v32 offset:33776
		ds_read_b64_tr_b16 a[114:115], v32 offset:38128
		ds_read_b64_tr_b16 a[116:117], v32 offset:34032
		ds_read_b64_tr_b16 a[118:119], v32 offset:38384
		ds_read_b64_tr_b16 a[120:121], v32 offset:33328
		ds_read_b64_tr_b16 a[122:123], v32 offset:37680
		ds_read_b64_tr_b16 a[124:125], v32 offset:33584
		ds_read_b64_tr_b16 a[126:127], v32 offset:37936
		ds_read_b64_tr_b16 a[128:129], v32 offset:33840
		ds_read_b64_tr_b16 a[130:131], v32 offset:38192
		ds_read_b64_tr_b16 a[132:133], v32 offset:34096
		ds_read_b64_tr_b16 a[134:135], v32 offset:38448
		ds_read_b64_tr_b16 a[136:137], v32 offset:33392
		ds_read_b64_tr_b16 a[138:139], v32 offset:37744
		ds_read_b64_tr_b16 a[140:141], v32 offset:33648
		ds_read_b64_tr_b16 a[142:143], v32 offset:38000
		ds_read_b64_tr_b16 a[144:145], v32 offset:33904
		ds_read_b64_tr_b16 a[146:147], v32 offset:38256
		ds_read_b64_tr_b16 a[148:149], v32 offset:34160
		ds_read_b64_tr_b16 a[150:151], v32 offset:38512
		ds_read_b64_tr_b16 a[152:153], v32 offset:33456
		ds_read_b64_tr_b16 a[154:155], v32 offset:37808
		ds_read_b64_tr_b16 a[156:157], v32 offset:33712
		ds_read_b64_tr_b16 a[158:159], v32 offset:38064
		ds_read_b64_tr_b16 a[160:161], v32 offset:33968
		ds_read_b64_tr_b16 a[162:163], v32 offset:38320
		ds_read_b64_tr_b16 a[164:165], v32 offset:34224
		ds_read_b64_tr_b16 a[166:167], v32 offset:38576
		s_mul_i32 s11, s15, s12
		s_lshl_b32 s11, s11, 1
		s_add_i32 s30, s13, s11
		v_add_u32_e32 v32, s30, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v188, s11, v6
		s_add_i32 s7, s7, 1
		v_add_u32_e32 v189, s14, v188
		s_and_b32 s7, s7, 1
		v_add_u32_e32 v190, s18, v188
		s_mul_i32 s11, 0x4100, s7
		v_add_u32_e32 v188, s3, v188
		s_add_i32 s11, s5, s11
		v_mfma_f32_32x32x16_bf16 v[192:207], v[36:39], a[0:3], 0
		s_mov_b32 m0, s11
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
		s_mul_i32 s11, s20, s12
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[32:35], 0
		s_add_i32 s12, s12, 64
		v_mfma_f32_32x32x16_bf16 v[240:255], v[36:39], a[32:35], 0
		v_add_u32_e32 v36, s12, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[4:7], v[192:207]
		v_add_u32_e32 v37, s12, v21
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], v[208:223]
		v_add_u32_e32 v38, s12, v18
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[36:39], v[224:239]
		v_add_u32_e32 v39, s12, v1
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[36:39], v[240:255]
		v_cmp_lt_i32_e64 vcc, v36, s25
		s_mov_b64 s[30:31], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], a[8:11], v[192:207]
		v_cmp_lt_i32_e64 vcc, v37, s25
		s_mov_b64 s[32:33], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[8:11], v[208:223]
		v_cmp_lt_i32_e64 vcc, v38, s25
		s_mov_b64 s[44:45], vcc
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[40:43], v[224:239]
		v_cmp_lt_i32_e64 vcc, v39, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[40:43], v[240:255]
		v_cndmask_b32_e64 v32, v22, v32, s[30:31]
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v32, v22, v189, s[32:33]
		v_cndmask_b32_e64 v36, v22, v190, s[44:45]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v37, v22, v188, vcc
		s_lshl_b32 s11, s11, 1
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		s_add_i32 s46, s4, s11
		v_add_u32_e32 v32, s46, v12
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s7, 0x4400, s7
		s_add_i32 s7, s2, s7
		buffer_load_dwordx4 v36, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v32, v22, v32, s[30:31]
		v_add_u32_e32 v36, s11, v12
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v38, s19, v36
		v_cndmask_b32_e64 v38, v22, v38, s[32:33]
		buffer_load_dwordx4 v37, s[36:39], 0 offen lds
		v_add_u32_e32 v37, s24, v36
		v_cndmask_b32_e64 v37, v22, v37, s[44:45]
		s_add_i32 m0, s7, 0x81f0
		v_add_u32_e32 v36, s6, v36
		v_cndmask_b32_e32 v36, v22, v36, vcc
		buffer_load_dwordx4 v32, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[12:15], v[192:207]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[44:47], v[240:255]
		buffer_load_dwordx4 v38, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[16:19], v[192:207]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[48:51], v[240:255]
		buffer_load_dwordx4 v37, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[20:23], v[192:207]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s12, s10
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[24:27], v[208:223]
		buffer_load_dwordx4 v36, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[60:63], v[240:255]
		s_nop 8
		v_max3_f32 v32, v192, v193, v194
		v_max3_f32 v36, v196, v197, v198
		v_max3_f32 v37, v200, v201, v202
		v_max3_f32 v38, v204, v205, v206
		v_max3_f32 v39, v208, v209, v210
		v_max3_f32 v40, v212, v213, v214
		v_max3_f32 v41, v216, v217, v218
		v_max3_f32 v42, v220, v221, v222
		v_max3_f32 v32, v32, v195, v36
		v_max3_f32 v36, v37, v203, v38
		v_max3_f32 v37, v39, v211, v40
		v_max3_f32 v38, v41, v219, v42
		v_max3_f32 v32, v32, v199, v36
		v_max3_f32 v36, v37, v215, v38
		v_max3_f32 v32, v32, v207, v36
		v_max_f32_e32 v32, v32, v223
		v_mov_b32_e32 v36, v32
		v_mov_b32_e32 v37, v32
		s_nop 1
		v_permlane32_swap_b32_e32 v36, v37
		v_max_f32_e32 v38, v36, v37
		v_max3_f32 v32, v240, v241, v242
		v_max3_f32 v36, v244, v245, v246
		v_max3_f32 v37, v248, v249, v250
		v_max3_f32 v39, v252, v253, v254
		v_max3_f32 v40, v224, v225, v226
		v_max3_f32 v41, v228, v229, v230
		v_max3_f32 v42, v232, v233, v234
		v_max3_f32 v43, v236, v237, v238
		v_max3_f32 v32, v32, v243, v36
		v_max3_f32 v36, v37, v251, v39
		v_max3_f32 v37, v40, v227, v41
		v_max3_f32 v39, v42, v235, v43
		v_max3_f32 v32, v32, v247, v36
		v_max3_f32 v36, v37, v231, v39
		v_max3_f32 v32, v32, v255, v36
		v_max_f32_e32 v32, v32, v239
		v_mov_b32_e32 v36, v32
		v_mov_b32_e32 v37, v32
		s_nop 1
		v_permlane32_swap_b32_e32 v36, v37
		v_max_f32_e32 v39, v36, v37
		v_pk_mul_f32 v[36:37], v[38:39], v[24:25]
		v_max_f32_e32 v38, v14, v36
		v_max_f32_e32 v39, v20, v37
		v_pk_fma_f32 v[36:37], v[192:193], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[40:41], v[194:195], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[196:197], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[198:199], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[200:201], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[202:203], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[204:205], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[206:207], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[208:209], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[210:211], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[212:213], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[214:215], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[216:217], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[24:25], v[38:39] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[240:241], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[242:243], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[244:245], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[246:247], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[248:249], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[254:255], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[224:225], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[226:227], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[228:229], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[230:231], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[232:233], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[224:225], v[234:235], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[226:227], v[236:237], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[228:229], v[238:239], v[24:25], v[38:39] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v230, v36
		v_exp_f32_e32 v232, v37
		v_exp_f32_e32 v231, v40
		v_exp_f32_e32 v233, v41
		v_exp_f32_e32 v36, v42
		v_exp_f32_e32 v40, v43
		v_exp_f32_e32 v37, v44
		v_exp_f32_e32 v41, v45
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
		v_exp_f32_e32 v179, v184
		v_exp_f32_e32 v181, v185
		v_exp_f32_e32 v182, v186
		v_exp_f32_e32 v184, v187
		v_exp_f32_e32 v183, v188
		v_exp_f32_e32 v185, v189
		v_exp_f32_e32 v186, v190
		v_exp_f32_e32 v188, v191
		v_exp_f32_e32 v187, v192
		v_exp_f32_e32 v189, v193
		v_exp_f32_e32 v190, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v191, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v195, v198
		v_exp_f32_e32 v197, v199
		v_exp_f32_e32 v198, v200
		v_exp_f32_e32 v234, v201
		v_exp_f32_e32 v199, v202
		v_exp_f32_e32 v235, v203
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
		v_exp_f32_e32 v212, v216
		v_exp_f32_e32 v214, v217
		v_exp_f32_e32 v213, v218
		v_exp_f32_e32 v215, v219
		v_exp_f32_e32 v216, v220
		v_exp_f32_e32 v218, v221
		v_exp_f32_e32 v217, v222
		v_exp_f32_e32 v219, v223
		v_exp_f32_e32 v220, v224
		v_exp_f32_e32 v222, v225
		v_exp_f32_e32 v221, v226
		v_exp_f32_e32 v223, v227
		v_exp_f32_e32 v224, v228
		v_exp_f32_e32 v226, v229
		v_pk_add_f32 v[228:229], v[230:231], v[232:233]
		v_pk_add_f32 v[236:237], v[36:37], v[40:41]
		v_pk_add_f32 v[238:239], v[42:43], v[44:45]
		v_pk_add_f32 v[240:241], v[46:47], v[176:177]
		v_pk_add_f32 v[242:243], v[178:179], v[180:181]
		v_pk_add_f32 v[244:245], v[182:183], v[184:185]
		v_pk_add_f32 v[246:247], v[186:187], v[188:189]
		v_pk_add_f32 v[248:249], v[190:191], v[192:193]
		v_mov_b32_e32 v250, v229
		v_mov_b32_e32 v251, v237
		v_mov_b32_e32 v252, v228
		v_mov_b32_e32 v253, v236
		v_pk_add_f32 v[228:229], v[252:253], v[250:251]
		v_mov_b32_e32 v236, v239
		v_mov_b32_e32 v237, v241
		v_mov_b32_e32 v250, v238
		v_mov_b32_e32 v251, v240
		v_pk_add_f32 v[238:239], v[250:251], v[236:237]
		v_mov_b32_e32 v236, v243
		v_mov_b32_e32 v237, v245
		v_mov_b32_e32 v240, v242
		v_mov_b32_e32 v241, v244
		v_pk_add_f32 v[242:243], v[240:241], v[236:237]
		v_mov_b32_e32 v236, v247
		v_mov_b32_e32 v237, v249
		v_mov_b32_e32 v240, v246
		v_mov_b32_e32 v241, v248
		v_pk_add_f32 v[244:245], v[240:241], v[236:237]
		v_mov_b32_e32 v236, v229
		v_mov_b32_e32 v237, v239
		v_mov_b32_e32 v240, v228
		v_mov_b32_e32 v241, v238
		v_pk_add_f32 v[228:229], v[240:241], v[236:237]
		v_mov_b32_e32 v236, v243
		v_mov_b32_e32 v237, v245
		v_mov_b32_e32 v238, v242
		v_mov_b32_e32 v239, v244
		v_pk_add_f32 v[240:241], v[238:239], v[236:237]
		v_mov_b32_e32 v236, v229
		v_mov_b32_e32 v237, v241
		v_mov_b32_e32 v238, v228
		v_mov_b32_e32 v239, v240
		v_pk_add_f32 v[228:229], v[238:239], v[236:237]
		v_add_f32_e32 v32, v228, v229
		ds_bpermute_b32 v194, v4, v32
		ds_bpermute_b32 v196, v10, v32
		v_pk_add_f32 v[228:229], v[198:199], v[234:235]
		v_pk_add_f32 v[236:237], v[200:201], v[202:203]
		v_pk_add_f32 v[238:239], v[204:205], v[206:207]
		v_pk_add_f32 v[240:241], v[208:209], v[210:211]
		v_pk_add_f32 v[242:243], v[212:213], v[214:215]
		v_pk_add_f32 v[244:245], v[216:217], v[218:219]
		v_pk_add_f32 v[246:247], v[220:221], v[222:223]
		v_mov_b32_e32 v248, v229
		v_mov_b32_e32 v249, v238
		v_pk_add_f32 v[250:251], v[248:249], v[236:237]
		v_mov_b32_e32 v236, v239
		v_mov_b32_e32 v237, v242
		v_pk_add_f32 v[236:237], v[236:237], v[240:241]
		v_mov_b32_e32 v238, v243
		v_mov_b32_e32 v239, v246
		v_pk_add_f32 v[240:241], v[238:239], v[244:245]
		v_mov_b32_e32 v238, v251
		v_mov_b32_e32 v239, v240
		v_pk_add_f32 v[242:243], v[238:239], v[236:237]
		v_sub_f32_e32 v14, v14, v38
		v_sub_f32_e32 v20, v20, v39
		v_exp_f32_e32 v236, v14
		v_exp_f32_e32 v238, v20
		v_mov_b32_e32 v237, v236
		v_pk_mul_f32 v[48:49], v[48:49], v[236:237]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[244:245], v[194:195], v[196:197]
		v_mov_b32_e32 v225, v245
		v_mov_b32_e32 v227, v228
		v_pk_add_f32 v[228:229], v[224:225], v[226:227]
		v_mov_b32_e32 v248, v247
		v_mov_b32_e32 v249, v250
		v_pk_add_f32 v[228:229], v[248:249], v[228:229]
		v_mov_b32_e32 v246, v241
		v_mov_b32_e32 v247, v242
		v_pk_add_f32 v[240:241], v[246:247], v[228:229]
		v_add_f32_e32 v14, v243, v240
		v_add_f32_e32 v14, v241, v14
		v_mov_b32_e32 v228, v14
		v_mov_b32_e32 v229, v14
		s_nop 1
		v_permlane32_swap_b32_e32 v228, v229
		v_add_f32_e32 v241, v228, v229
		v_pk_mul_f32 v[50:51], v[50:51], v[236:237]
		v_pk_mul_f32 v[52:53], v[52:53], v[236:237]
		v_pk_mul_f32 v[54:55], v[54:55], v[236:237]
		v_pk_mul_f32 v[56:57], v[56:57], v[236:237]
		v_pk_mul_f32 v[58:59], v[58:59], v[236:237]
		v_pk_mul_f32 v[60:61], v[60:61], v[236:237]
		v_pk_mul_f32 v[62:63], v[62:63], v[236:237]
		v_pk_mul_f32 v[64:65], v[64:65], v[236:237]
		v_pk_mul_f32 v[66:67], v[66:67], v[236:237]
		v_pk_mul_f32 v[68:69], v[68:69], v[236:237]
		v_pk_mul_f32 v[70:71], v[70:71], v[236:237]
		v_pk_mul_f32 v[72:73], v[72:73], v[236:237]
		v_pk_mul_f32 v[74:75], v[74:75], v[236:237]
		v_pk_mul_f32 v[76:77], v[76:77], v[236:237]
		v_pk_mul_f32 v[78:79], v[78:79], v[236:237]
		v_pk_mul_f32 v[80:81], v[80:81], v[236:237]
		v_pk_mul_f32 v[82:83], v[82:83], v[236:237]
		v_pk_mul_f32 v[84:85], v[84:85], v[236:237]
		v_pk_mul_f32 v[86:87], v[86:87], v[236:237]
		v_pk_mul_f32 v[88:89], v[88:89], v[236:237]
		v_pk_mul_f32 v[90:91], v[90:91], v[236:237]
		v_pk_mul_f32 v[92:93], v[92:93], v[236:237]
		v_pk_mul_f32 v[94:95], v[94:95], v[236:237]
		v_pk_mul_f32 v[96:97], v[96:97], v[236:237]
		v_pk_mul_f32 v[98:99], v[98:99], v[236:237]
		v_pk_mul_f32 v[100:101], v[100:101], v[236:237]
		v_pk_mul_f32 v[102:103], v[102:103], v[236:237]
		v_pk_mul_f32 v[104:105], v[104:105], v[236:237]
		v_pk_mul_f32 v[106:107], v[106:107], v[236:237]
		v_pk_mul_f32 v[108:109], v[108:109], v[236:237]
		v_pk_mul_f32 v[110:111], v[110:111], v[236:237]
		v_mov_b32_e32 v239, v238
		v_pk_mul_f32 v[112:113], v[112:113], v[238:239]
		v_pk_mul_f32 v[114:115], v[114:115], v[238:239]
		v_pk_mul_f32 v[116:117], v[116:117], v[238:239]
		v_pk_mul_f32 v[118:119], v[118:119], v[238:239]
		v_pk_mul_f32 v[120:121], v[120:121], v[238:239]
		v_pk_mul_f32 v[122:123], v[122:123], v[238:239]
		v_pk_mul_f32 v[124:125], v[124:125], v[238:239]
		v_pk_mul_f32 v[126:127], v[126:127], v[238:239]
		v_pk_mul_f32 v[128:129], v[128:129], v[238:239]
		v_pk_mul_f32 v[130:131], v[130:131], v[238:239]
		v_pk_mul_f32 v[132:133], v[132:133], v[238:239]
		v_pk_mul_f32 v[134:135], v[134:135], v[238:239]
		v_pk_mul_f32 v[136:137], v[136:137], v[238:239]
		v_pk_mul_f32 v[138:139], v[138:139], v[238:239]
		v_pk_mul_f32 v[140:141], v[140:141], v[238:239]
		v_pk_mul_f32 v[142:143], v[142:143], v[238:239]
		v_pk_mul_f32 v[144:145], v[144:145], v[238:239]
		v_pk_mul_f32 v[146:147], v[146:147], v[238:239]
		v_pk_mul_f32 v[148:149], v[148:149], v[238:239]
		v_pk_mul_f32 v[150:151], v[150:151], v[238:239]
		v_pk_mul_f32 v[152:153], v[152:153], v[238:239]
		v_pk_mul_f32 v[154:155], v[154:155], v[238:239]
		v_pk_mul_f32 v[156:157], v[156:157], v[238:239]
		v_pk_mul_f32 v[158:159], v[158:159], v[238:239]
		v_pk_mul_f32 v[160:161], v[160:161], v[238:239]
		v_pk_mul_f32 v[162:163], v[162:163], v[238:239]
		v_pk_mul_f32 v[164:165], v[164:165], v[238:239]
		v_pk_mul_f32 v[166:167], v[166:167], v[238:239]
		v_pk_mul_f32 v[168:169], v[168:169], v[238:239]
		v_pk_mul_f32 v[170:171], v[170:171], v[238:239]
		v_pk_mul_f32 v[172:173], v[172:173], v[238:239]
		v_pk_mul_f32 v[174:175], v[174:175], v[238:239]
		v_mov_b32_e32 v240, v244
		v_mov_b32_e32 v228, v236
		v_mov_b32_e32 v229, v238
		v_pk_fma_f32 v[34:35], v[34:35], v[228:229], v[240:241]
		v_cvt_pk_bf16_f32 v236, v230, v232
		v_cvt_pk_bf16_f32 v237, v231, v233
		v_cvt_pk_bf16_f32 v238, v36, v40
		v_cvt_pk_bf16_f32 v239, v37, v41
		v_cvt_pk_bf16_f32 v228, v42, v44
		v_cvt_pk_bf16_f32 v229, v43, v45
		v_cvt_pk_bf16_f32 v230, v46, v176
		v_cvt_pk_bf16_f32 v231, v47, v177
		v_cvt_pk_bf16_f32 v40, v178, v180
		v_cvt_pk_bf16_f32 v41, v179, v181
		v_cvt_pk_bf16_f32 v42, v182, v184
		v_cvt_pk_bf16_f32 v43, v183, v185
		v_cvt_pk_bf16_f32 v44, v186, v188
		v_cvt_pk_bf16_f32 v45, v187, v189
		v_cvt_pk_bf16_f32 v46, v190, v192
		v_cvt_pk_bf16_f32 v47, v191, v193
		v_cvt_pk_bf16_f32 v176, v195, v197
		v_cvt_pk_bf16_f32 v177, v198, v234
		v_cvt_pk_bf16_f32 v178, v199, v235
		v_cvt_pk_bf16_f32 v179, v200, v202
		v_cvt_pk_bf16_f32 v180, v201, v203
		v_cvt_pk_bf16_f32 v181, v204, v206
		v_cvt_pk_bf16_f32 v182, v205, v207
		v_cvt_pk_bf16_f32 v183, v208, v210
		v_cvt_pk_bf16_f32 v184, v209, v211
		v_cvt_pk_bf16_f32 v185, v212, v214
		v_cvt_pk_bf16_f32 v186, v213, v215
		v_cvt_pk_bf16_f32 v187, v216, v218
		v_cvt_pk_bf16_f32 v188, v217, v219
		v_cvt_pk_bf16_f32 v189, v220, v222
		v_cvt_pk_bf16_f32 v190, v221, v223
		v_cvt_pk_bf16_f32 v191, v224, v226
		v_permlane32_swap_b32_e32 v236, v238
		v_permlane32_swap_b32_e32 v237, v239
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[48:63], a[104:107], v[236:239], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[236:239], v[64:79]
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[236:239], v[80:95]
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[96:111], a[152:155], v[236:239], v[96:111]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[48:63], a[108:111], v[228:231], v[48:63]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[160:175], a[152:155], v[176:179], v[160:175]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[112:127], a[104:107], v[176:179], v[112:127]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[128:143], a[120:123], v[176:179], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[136:139], v[176:179], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[228:231], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[228:231], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[156:159], v[228:231], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[156:159], v[180:183], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[108:111], v[180:183], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[124:127], v[180:183], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[140:143], v[180:183], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[40:43], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[40:43], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[40:43], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[160:163], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[160:163], v[184:187], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[184:187], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[184:187], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[184:187], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[44:47], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[44:47], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[44:47], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[164:167], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[164:167], v[188:191], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[188:191], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[188:191], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[188:191], v[144:159]
		v_mov_b32_e32 v14, v38
		v_mov_b32_e32 v20, v39
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s34
		s_mov_b32 s7, s35
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s1, 1
		s_mul_i32 s2, 0x4100, s1
		v_lshl_add_u32 v1, v33, 4, s2
		v_lshl_add_u32 v1, v19, 8, v1
		v_add3_u32 v1, v1, v27, v28
		v_add3_u32 v1, v1, v29, v26
		ds_read_b128 v[16:19], v1
		ds_read_b128 v[36:39], v1 offset:32
		ds_read_b128 v[40:43], v1 offset:64
		ds_read_b128 v[44:47], v1 offset:96
		ds_read_b128 a[64:67], v1 offset:128
		ds_read_b128 a[68:71], v1 offset:160
		ds_read_b128 a[72:75], v1 offset:192
		ds_read_b128 a[76:79], v1 offset:224
		ds_read_b128 v[176:179], v1 offset:512
		ds_read_b128 v[180:183], v1 offset:544
		ds_read_b128 v[184:187], v1 offset:576
		ds_read_b128 v[188:191], v1 offset:608
		ds_read_b128 a[80:83], v1 offset:640
		ds_read_b128 a[84:87], v1 offset:672
		ds_read_b128 a[88:91], v1 offset:704
		ds_read_b128 a[92:95], v1 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_add3_u32 v0, s1, v0, v7
		v_add3_u32 v0, v0, v30, v31
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
		v_mfma_f32_32x32x16_bf16 v[192:207], v[16:19], a[0:3], 0
		v_mov_b32_e32 v0, 4
		v_mul_lo_u32 v0, v0, v5
		v_add_u32_e32 v1, s10, v0
		v_xad_u32 v5, 16, v0, s10
		v_xad_u32 v6, 32, v0, s10
		v_xad_u32 v0, 48, v0, s10
		v_cmp_lt_i32_e64 vcc, v1, s25
		s_mov_b64 s[2:3], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
		v_cmp_lt_i32_e64 vcc, v5, s25
		s_mov_b64 s[8:9], vcc
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v0, s25
		v_mov_b32_e32 v0, 0xff800000
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[16:19], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[36:39], a[4:7], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[36:39], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[36:39], a[36:39], v[240:255]
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
		s_nop 8
		v_cndmask_b32_e64 v6, v0, v192, s[2:3]
		v_cndmask_b32_e64 v7, v0, v193, s[2:3]
		v_cndmask_b32_e64 v16, v0, v194, s[2:3]
		v_cndmask_b32_e64 v17, v0, v195, s[2:3]
		v_cndmask_b32_e64 v18, v0, v196, s[2:3]
		v_cndmask_b32_e64 v19, v0, v197, s[2:3]
		v_cndmask_b32_e64 v22, v0, v198, s[2:3]
		v_cndmask_b32_e64 v23, v0, v199, s[2:3]
		v_cndmask_b32_e64 v26, v0, v200, s[8:9]
		v_cndmask_b32_e64 v27, v0, v201, s[8:9]
		v_cndmask_b32_e64 v28, v0, v202, s[8:9]
		v_cndmask_b32_e64 v29, v0, v203, s[8:9]
		v_cndmask_b32_e64 v30, v0, v204, s[8:9]
		v_cndmask_b32_e64 v31, v0, v205, s[8:9]
		v_cndmask_b32_e64 v32, v0, v206, s[8:9]
		v_cndmask_b32_e64 v33, v0, v207, s[8:9]
		v_cndmask_b32_e64 v36, v0, v208, s[10:11]
		v_cndmask_b32_e64 v37, v0, v209, s[10:11]
		v_cndmask_b32_e64 v38, v0, v210, s[10:11]
		v_cndmask_b32_e64 v39, v0, v211, s[10:11]
		v_cndmask_b32_e64 v40, v0, v212, s[10:11]
		v_cndmask_b32_e64 v41, v0, v213, s[10:11]
		v_cndmask_b32_e64 v42, v0, v214, s[10:11]
		v_cndmask_b32_e64 v43, v0, v215, s[10:11]
		v_cndmask_b32_e32 v44, v0, v216, vcc
		v_cndmask_b32_e32 v45, v0, v217, vcc
		v_cndmask_b32_e32 v46, v0, v218, vcc
		v_cndmask_b32_e32 v47, v0, v219, vcc
		v_cndmask_b32_e32 v176, v0, v220, vcc
		v_cndmask_b32_e32 v177, v0, v221, vcc
		v_cndmask_b32_e32 v178, v0, v222, vcc
		v_cndmask_b32_e32 v179, v0, v223, vcc
		v_cndmask_b32_e64 v180, v0, v240, s[2:3]
		v_cndmask_b32_e64 v181, v0, v241, s[2:3]
		v_cndmask_b32_e64 v182, v0, v242, s[2:3]
		v_cndmask_b32_e64 v183, v0, v243, s[2:3]
		v_cndmask_b32_e64 v184, v0, v244, s[2:3]
		v_cndmask_b32_e64 v185, v0, v245, s[2:3]
		v_cndmask_b32_e64 v186, v0, v246, s[2:3]
		v_cndmask_b32_e64 v187, v0, v247, s[2:3]
		v_cndmask_b32_e64 v188, v0, v248, s[8:9]
		v_cndmask_b32_e64 v189, v0, v249, s[8:9]
		v_cndmask_b32_e64 v190, v0, v250, s[8:9]
		v_cndmask_b32_e64 v191, v0, v251, s[8:9]
		v_cndmask_b32_e64 v192, v0, v252, s[8:9]
		v_cndmask_b32_e64 v193, v0, v253, s[8:9]
		v_cndmask_b32_e64 v194, v0, v254, s[8:9]
		v_cndmask_b32_e64 v195, v0, v255, s[8:9]
		v_cndmask_b32_e64 v196, v0, v224, s[10:11]
		v_cndmask_b32_e64 v197, v0, v225, s[10:11]
		v_cndmask_b32_e64 v198, v0, v226, s[10:11]
		v_cndmask_b32_e64 v199, v0, v227, s[10:11]
		v_cndmask_b32_e64 v200, v0, v228, s[10:11]
		v_cndmask_b32_e64 v201, v0, v229, s[10:11]
		v_cndmask_b32_e64 v202, v0, v230, s[10:11]
		v_cndmask_b32_e64 v203, v0, v231, s[10:11]
		v_cndmask_b32_e32 v204, v0, v232, vcc
		v_cndmask_b32_e32 v205, v0, v233, vcc
		v_cndmask_b32_e32 v206, v0, v234, vcc
		v_cndmask_b32_e32 v207, v0, v235, vcc
		v_cndmask_b32_e32 v208, v0, v236, vcc
		v_cndmask_b32_e32 v209, v0, v237, vcc
		v_cndmask_b32_e32 v210, v0, v238, vcc
		v_cndmask_b32_e32 v211, v0, v239, vcc
		v_max3_f32 v0, v6, v7, v16
		v_max3_f32 v1, v18, v19, v22
		v_max3_f32 v5, v26, v27, v28
		v_max3_f32 v12, v30, v31, v32
		v_max3_f32 v21, v36, v37, v38
		v_max3_f32 v212, v40, v41, v42
		v_max3_f32 v213, v44, v45, v46
		v_max3_f32 v214, v176, v177, v178
		v_max3_f32 v0, v0, v17, v1
		v_max3_f32 v1, v5, v29, v12
		v_max3_f32 v5, v21, v39, v212
		v_max3_f32 v12, v213, v47, v214
		v_max3_f32 v0, v0, v23, v1
		v_max3_f32 v1, v5, v43, v12
		v_max3_f32 v0, v0, v33, v1
		v_max_f32_e32 v0, v0, v179
		v_mov_b32_e32 v212, v0
		v_mov_b32_e32 v213, v0
		s_nop 1
		v_permlane32_swap_b32_e32 v212, v213
		v_max_f32_e32 v0, v212, v213
		v_max3_f32 v1, v180, v181, v182
		v_max3_f32 v5, v184, v185, v186
		v_max3_f32 v12, v188, v189, v190
		v_max3_f32 v21, v192, v193, v194
		v_max3_f32 v212, v196, v197, v198
		v_max3_f32 v213, v200, v201, v202
		v_max3_f32 v214, v204, v205, v206
		v_max3_f32 v215, v208, v209, v210
		v_max3_f32 v1, v1, v183, v5
		v_max3_f32 v5, v12, v191, v21
		v_max3_f32 v12, v212, v199, v213
		v_max3_f32 v21, v214, v207, v215
		v_max3_f32 v1, v1, v187, v5
		v_max3_f32 v5, v12, v203, v21
		v_max3_f32 v1, v1, v195, v5
		v_max_f32_e32 v1, v1, v211
		v_mov_b32_e32 v212, v1
		v_mov_b32_e32 v213, v1
		s_nop 1
		v_permlane32_swap_b32_e32 v212, v213
		v_max_f32_e32 v1, v212, v213
		v_pk_mul_f32 v[212:213], v[0:1], v[24:25]
		v_max_f32_e32 v0, v14, v212
		v_max_f32_e32 v1, v20, v213
		v_pk_fma_f32 v[212:213], v[6:7], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[6:7], v[16:17], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[18:19], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[22:23], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[26:27], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[28:29], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[30:31], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[32:33], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[32:33], v[36:37], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[36:37], v[38:39], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[38:39], v[40:41], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[40:41], v[42:43], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[44:45], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[46:47], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[176:177], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[24:25], v[0:1] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[206:207], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[208:209], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[210:211], v[24:25], v[0:1] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v24, v212
		v_exp_f32_e32 v210, v213
		v_exp_f32_e32 v25, v6
		v_exp_f32_e32 v211, v7
		v_exp_f32_e32 v6, v16
		v_exp_f32_e32 v212, v17
		v_exp_f32_e32 v7, v18
		v_exp_f32_e32 v213, v19
		v_exp_f32_e32 v16, v22
		v_exp_f32_e32 v18, v23
		v_exp_f32_e32 v17, v26
		v_exp_f32_e32 v19, v27
		v_exp_f32_e32 v22, v28
		v_exp_f32_e32 v26, v29
		v_exp_f32_e32 v23, v30
		v_exp_f32_e32 v27, v31
		v_exp_f32_e32 v28, v32
		v_exp_f32_e32 v30, v33
		v_exp_f32_e32 v29, v36
		v_exp_f32_e32 v31, v37
		v_exp_f32_e32 v32, v38
		v_exp_f32_e32 v36, v39
		v_exp_f32_e32 v33, v40
		v_exp_f32_e32 v37, v41
		v_exp_f32_e32 v38, v42
		v_exp_f32_e32 v40, v43
		v_exp_f32_e32 v39, v44
		v_exp_f32_e32 v41, v45
		v_exp_f32_e32 v42, v46
		v_exp_f32_e32 v44, v47
		v_exp_f32_e32 v43, v176
		v_exp_f32_e32 v45, v177
		v_exp_f32_e32 v47, v178
		v_exp_f32_e32 v177, v179
		v_exp_f32_e32 v178, v180
		v_exp_f32_e32 v214, v181
		v_exp_f32_e32 v179, v182
		v_exp_f32_e32 v215, v183
		v_exp_f32_e32 v180, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v181, v186
		v_exp_f32_e32 v183, v187
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
		v_pk_add_f32 v[208:209], v[24:25], v[210:211]
		v_pk_add_f32 v[216:217], v[6:7], v[212:213]
		v_pk_add_f32 v[218:219], v[16:17], v[18:19]
		v_pk_add_f32 v[220:221], v[22:23], v[26:27]
		v_pk_add_f32 v[222:223], v[28:29], v[30:31]
		v_pk_add_f32 v[224:225], v[32:33], v[36:37]
		v_pk_add_f32 v[226:227], v[38:39], v[40:41]
		v_pk_add_f32 v[228:229], v[42:43], v[44:45]
		v_mov_b32_e32 v230, v209
		v_mov_b32_e32 v231, v217
		v_mov_b32_e32 v232, v208
		v_mov_b32_e32 v233, v216
		v_pk_add_f32 v[208:209], v[232:233], v[230:231]
		v_mov_b32_e32 v216, v219
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v230, v218
		v_mov_b32_e32 v231, v220
		v_pk_add_f32 v[218:219], v[230:231], v[216:217]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v225
		v_mov_b32_e32 v220, v222
		v_mov_b32_e32 v221, v224
		v_pk_add_f32 v[222:223], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v227
		v_mov_b32_e32 v217, v229
		v_mov_b32_e32 v220, v226
		v_mov_b32_e32 v221, v228
		v_pk_add_f32 v[224:225], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v209
		v_mov_b32_e32 v217, v219
		v_mov_b32_e32 v220, v208
		v_mov_b32_e32 v221, v218
		v_pk_add_f32 v[208:209], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v225
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v209
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v218, v208
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[208:209], v[218:219], v[216:217]
		v_add_f32_e32 v5, v208, v209
		ds_bpermute_b32 v46, v4, v5
		ds_bpermute_b32 v176, v10, v5
		v_pk_add_f32 v[4:5], v[178:179], v[214:215]
		v_pk_add_f32 v[208:209], v[180:181], v[182:183]
		v_pk_add_f32 v[216:217], v[184:185], v[186:187]
		v_pk_add_f32 v[218:219], v[188:189], v[190:191]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[220:221], v[46:47], v[176:177]
		v_pk_add_f32 v[222:223], v[192:193], v[194:195]
		v_pk_add_f32 v[224:225], v[196:197], v[198:199]
		v_pk_add_f32 v[226:227], v[200:201], v[202:203]
		v_mov_b32_e32 v205, v221
		v_mov_b32_e32 v207, v4
		v_pk_add_f32 v[228:229], v[204:205], v[206:207]
		v_mov_b32_e32 v230, v5
		v_mov_b32_e32 v231, v216
		v_pk_add_f32 v[4:5], v[230:231], v[208:209]
		v_mov_b32_e32 v208, v217
		v_mov_b32_e32 v209, v222
		v_pk_add_f32 v[208:209], v[208:209], v[218:219]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v226
		v_pk_add_f32 v[218:219], v[216:217], v[224:225]
		v_mov_b32_e32 v216, v227
		v_mov_b32_e32 v217, v4
		v_pk_add_f32 v[216:217], v[216:217], v[228:229]
		v_mov_b32_e32 v222, v5
		v_mov_b32_e32 v223, v218
		v_pk_add_f32 v[4:5], v[222:223], v[208:209]
		v_mov_b32_e32 v208, v219
		v_mov_b32_e32 v209, v4
		v_pk_add_f32 v[218:219], v[208:209], v[216:217]
		v_add_f32_e32 v4, v5, v218
		v_add_f32_e32 v4, v219, v4
		v_mov_b32_e32 v208, v4
		v_mov_b32_e32 v209, v4
		s_nop 1
		v_permlane32_swap_b32_e32 v208, v209
		v_add_f32_e32 v5, v208, v209
		v_sub_f32_e32 v0, v14, v0
		v_sub_f32_e32 v1, v20, v1
		v_exp_f32_e32 v20, v0
		v_exp_f32_e32 v208, v1
		v_mov_b32_e32 v21, v20
		v_pk_mul_f32 v[224:225], v[48:49], v[20:21]
		v_pk_mul_f32 v[226:227], v[50:51], v[20:21]
		v_pk_mul_f32 v[228:229], v[52:53], v[20:21]
		v_pk_mul_f32 v[230:231], v[54:55], v[20:21]
		v_pk_mul_f32 v[232:233], v[56:57], v[20:21]
		v_pk_mul_f32 v[234:235], v[58:59], v[20:21]
		v_pk_mul_f32 v[236:237], v[60:61], v[20:21]
		v_pk_mul_f32 v[238:239], v[62:63], v[20:21]
		v_pk_mul_f32 v[48:49], v[64:65], v[20:21]
		v_pk_mul_f32 v[50:51], v[66:67], v[20:21]
		v_pk_mul_f32 v[52:53], v[68:69], v[20:21]
		v_pk_mul_f32 v[54:55], v[70:71], v[20:21]
		v_pk_mul_f32 v[56:57], v[72:73], v[20:21]
		v_pk_mul_f32 v[58:59], v[74:75], v[20:21]
		v_pk_mul_f32 v[60:61], v[76:77], v[20:21]
		v_pk_mul_f32 v[62:63], v[78:79], v[20:21]
		v_pk_mul_f32 v[64:65], v[80:81], v[20:21]
		v_pk_mul_f32 v[66:67], v[82:83], v[20:21]
		v_pk_mul_f32 v[68:69], v[84:85], v[20:21]
		v_pk_mul_f32 v[70:71], v[86:87], v[20:21]
		v_pk_mul_f32 v[72:73], v[88:89], v[20:21]
		v_pk_mul_f32 v[74:75], v[90:91], v[20:21]
		v_pk_mul_f32 v[76:77], v[92:93], v[20:21]
		v_pk_mul_f32 v[78:79], v[94:95], v[20:21]
		v_pk_mul_f32 v[80:81], v[96:97], v[20:21]
		v_pk_mul_f32 v[82:83], v[98:99], v[20:21]
		v_pk_mul_f32 v[84:85], v[100:101], v[20:21]
		v_pk_mul_f32 v[86:87], v[102:103], v[20:21]
		v_pk_mul_f32 v[88:89], v[104:105], v[20:21]
		v_pk_mul_f32 v[90:91], v[106:107], v[20:21]
		v_pk_mul_f32 v[92:93], v[108:109], v[20:21]
		v_pk_mul_f32 v[94:95], v[110:111], v[20:21]
		v_mov_b32_e32 v209, v208
		v_pk_mul_f32 v[96:97], v[112:113], v[208:209]
		v_pk_mul_f32 v[98:99], v[114:115], v[208:209]
		v_pk_mul_f32 v[100:101], v[116:117], v[208:209]
		v_pk_mul_f32 v[102:103], v[118:119], v[208:209]
		v_pk_mul_f32 v[104:105], v[120:121], v[208:209]
		v_pk_mul_f32 v[106:107], v[122:123], v[208:209]
		v_pk_mul_f32 v[108:109], v[124:125], v[208:209]
		v_pk_mul_f32 v[110:111], v[126:127], v[208:209]
		v_pk_mul_f32 v[112:113], v[128:129], v[208:209]
		v_pk_mul_f32 v[114:115], v[130:131], v[208:209]
		v_pk_mul_f32 v[116:117], v[132:133], v[208:209]
		v_pk_mul_f32 v[118:119], v[134:135], v[208:209]
		v_pk_mul_f32 v[120:121], v[136:137], v[208:209]
		v_pk_mul_f32 v[122:123], v[138:139], v[208:209]
		v_pk_mul_f32 v[124:125], v[140:141], v[208:209]
		v_pk_mul_f32 v[126:127], v[142:143], v[208:209]
		v_pk_mul_f32 v[128:129], v[144:145], v[208:209]
		v_pk_mul_f32 v[130:131], v[146:147], v[208:209]
		v_pk_mul_f32 v[132:133], v[148:149], v[208:209]
		v_pk_mul_f32 v[134:135], v[150:151], v[208:209]
		v_pk_mul_f32 v[136:137], v[152:153], v[208:209]
		v_pk_mul_f32 v[138:139], v[154:155], v[208:209]
		v_pk_mul_f32 v[140:141], v[156:157], v[208:209]
		v_pk_mul_f32 v[142:143], v[158:159], v[208:209]
		v_pk_mul_f32 v[144:145], v[160:161], v[208:209]
		v_pk_mul_f32 v[146:147], v[162:163], v[208:209]
		v_pk_mul_f32 v[148:149], v[164:165], v[208:209]
		v_pk_mul_f32 v[150:151], v[166:167], v[208:209]
		v_pk_mul_f32 v[152:153], v[168:169], v[208:209]
		v_pk_mul_f32 v[154:155], v[170:171], v[208:209]
		v_pk_mul_f32 v[156:157], v[172:173], v[208:209]
		v_pk_mul_f32 v[158:159], v[174:175], v[208:209]
		v_mov_b32_e32 v0, v20
		v_mov_b32_e32 v1, v208
		v_mov_b32_e32 v4, v220
		v_pk_fma_f32 v[20:21], v[34:35], v[0:1], v[4:5]
		v_cvt_pk_bf16_f32 v160, v24, v210
		v_cvt_pk_bf16_f32 v161, v25, v211
		v_cvt_pk_bf16_f32 v162, v6, v212
		v_cvt_pk_bf16_f32 v163, v7, v213
		v_cvt_pk_bf16_f32 v4, v16, v18
		v_cvt_pk_bf16_f32 v5, v17, v19
		v_cvt_pk_bf16_f32 v6, v22, v26
		v_cvt_pk_bf16_f32 v7, v23, v27
		v_cvt_pk_bf16_f32 v16, v28, v30
		v_cvt_pk_bf16_f32 v17, v29, v31
		v_cvt_pk_bf16_f32 v18, v32, v36
		v_cvt_pk_bf16_f32 v19, v33, v37
		v_cvt_pk_bf16_f32 v24, v38, v40
		v_cvt_pk_bf16_f32 v25, v39, v41
		v_cvt_pk_bf16_f32 v26, v42, v44
		v_cvt_pk_bf16_f32 v27, v43, v45
		v_cvt_pk_bf16_f32 v28, v47, v177
		v_cvt_pk_bf16_f32 v29, v178, v214
		v_cvt_pk_bf16_f32 v30, v179, v215
		v_cvt_pk_bf16_f32 v31, v180, v182
		v_cvt_pk_bf16_f32 v32, v181, v183
		v_cvt_pk_bf16_f32 v33, v184, v186
		v_cvt_pk_bf16_f32 v34, v185, v187
		v_cvt_pk_bf16_f32 v35, v188, v190
		v_cvt_pk_bf16_f32 v36, v189, v191
		v_cvt_pk_bf16_f32 v37, v192, v194
		v_cvt_pk_bf16_f32 v38, v193, v195
		v_cvt_pk_bf16_f32 v39, v196, v198
		v_cvt_pk_bf16_f32 v40, v197, v199
		v_cvt_pk_bf16_f32 v41, v200, v202
		v_cvt_pk_bf16_f32 v42, v201, v203
		v_cvt_pk_bf16_f32 v43, v204, v206
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], v[160:163], v[224:239]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[160:163], v[48:63]
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_rcp_f32_e32 v0, v20
		v_rcp_f32_e32 v22, v21
		s_mul_i32 s1, s16, s23
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[160:163], v[64:79]
		s_lshl_b32 s1, s1, 9
		s_mul_i32 s2, s17, s21
		s_lshl_b32 s2, s2, 1
		s_add_i32 s3, s1, s2
		s_mul_i32 s0, s0, s22
		s_lshl_b32 s0, s0, 1
		s_add_i32 s3, s3, s0
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[160:163], v[80:95]
		v_mul_lo_u32 v10, s23, v13
		v_lshl_add_u32 v1, v10, 6, s3
		v_mul_lo_u32 v11, s23, v11
		v_lshl_add_u32 v1, v11, 1, v1
		v_mul_lo_u32 v9, s23, v9
		v_lshl_add_u32 v1, v9, 5, v1
		v_mul_lo_u32 v8, s23, v8
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[28:31], v[144:159]
		v_lshl_add_u32 v1, v8, 4, v1
		v_mul_lo_u32 v12, s23, v15
		v_lshl_add_u32 v1, v12, 3, v1
		v_mul_lo_u32 v3, s23, v3
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v13, v2, 4, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], v[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], v[4:7], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[4:7], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[4:7], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[4:7], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], v[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], v[16:19], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[16:19], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], v[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], v[24:27], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[40:43], v[128:143]
		v_mov_b32_e32 v1, v0
		s_nop 3
		v_pk_mul_f32 v[4:5], v[224:225], v[0:1]
		v_pk_mul_f32 v[6:7], v[226:227], v[0:1]
		v_pk_mul_f32 v[14:15], v[228:229], v[0:1]
		v_pk_mul_f32 v[16:17], v[230:231], v[0:1]
		v_pk_mul_f32 v[18:19], v[232:233], v[0:1]
		v_pk_mul_f32 v[20:21], v[234:235], v[0:1]
		v_pk_mul_f32 v[24:25], v[236:237], v[0:1]
		v_pk_mul_f32 v[26:27], v[238:239], v[0:1]
		v_pk_mul_f32 v[28:29], v[48:49], v[0:1]
		v_pk_mul_f32 v[30:31], v[50:51], v[0:1]
		v_pk_mul_f32 v[32:33], v[52:53], v[0:1]
		v_pk_mul_f32 v[34:35], v[54:55], v[0:1]
		v_pk_mul_f32 v[36:37], v[56:57], v[0:1]
		v_pk_mul_f32 v[38:39], v[58:59], v[0:1]
		v_pk_mul_f32 v[40:41], v[60:61], v[0:1]
		v_pk_mul_f32 v[42:43], v[62:63], v[0:1]
		v_pk_mul_f32 v[44:45], v[64:65], v[0:1]
		v_pk_mul_f32 v[46:47], v[66:67], v[0:1]
		v_pk_mul_f32 v[48:49], v[68:69], v[0:1]
		v_pk_mul_f32 v[50:51], v[70:71], v[0:1]
		v_pk_mul_f32 v[52:53], v[72:73], v[0:1]
		v_pk_mul_f32 v[54:55], v[74:75], v[0:1]
		v_pk_mul_f32 v[56:57], v[76:77], v[0:1]
		v_pk_mul_f32 v[58:59], v[78:79], v[0:1]
		v_pk_mul_f32 v[60:61], v[80:81], v[0:1]
		v_pk_mul_f32 v[62:63], v[82:83], v[0:1]
		v_pk_mul_f32 v[64:65], v[84:85], v[0:1]
		v_pk_mul_f32 v[66:67], v[86:87], v[0:1]
		v_pk_mul_f32 v[68:69], v[88:89], v[0:1]
		v_pk_mul_f32 v[70:71], v[90:91], v[0:1]
		v_pk_mul_f32 v[72:73], v[92:93], v[0:1]
		v_pk_mul_f32 v[74:75], v[94:95], v[0:1]
		v_mov_b32_e32 v23, v22
		v_pk_mul_f32 v[0:1], v[96:97], v[22:23]
		v_pk_mul_f32 v[76:77], v[98:99], v[22:23]
		v_pk_mul_f32 v[78:79], v[100:101], v[22:23]
		v_pk_mul_f32 v[80:81], v[102:103], v[22:23]
		v_pk_mul_f32 v[82:83], v[104:105], v[22:23]
		v_pk_mul_f32 v[84:85], v[106:107], v[22:23]
		v_pk_mul_f32 v[86:87], v[108:109], v[22:23]
		v_pk_mul_f32 v[88:89], v[110:111], v[22:23]
		v_pk_mul_f32 v[90:91], v[112:113], v[22:23]
		v_pk_mul_f32 v[92:93], v[114:115], v[22:23]
		v_pk_mul_f32 v[94:95], v[116:117], v[22:23]
		v_pk_mul_f32 v[96:97], v[118:119], v[22:23]
		v_pk_mul_f32 v[98:99], v[120:121], v[22:23]
		v_pk_mul_f32 v[100:101], v[122:123], v[22:23]
		v_pk_mul_f32 v[102:103], v[124:125], v[22:23]
		v_pk_mul_f32 v[104:105], v[126:127], v[22:23]
		v_pk_mul_f32 v[106:107], v[128:129], v[22:23]
		v_pk_mul_f32 v[108:109], v[130:131], v[22:23]
		v_pk_mul_f32 v[110:111], v[132:133], v[22:23]
		v_pk_mul_f32 v[112:113], v[134:135], v[22:23]
		v_pk_mul_f32 v[114:115], v[136:137], v[22:23]
		v_pk_mul_f32 v[116:117], v[138:139], v[22:23]
		v_pk_mul_f32 v[118:119], v[140:141], v[22:23]
		v_pk_mul_f32 v[120:121], v[142:143], v[22:23]
		v_pk_mul_f32 v[122:123], v[144:145], v[22:23]
		v_pk_mul_f32 v[124:125], v[146:147], v[22:23]
		v_pk_mul_f32 v[126:127], v[148:149], v[22:23]
		v_pk_mul_f32 v[128:129], v[150:151], v[22:23]
		v_pk_mul_f32 v[130:131], v[152:153], v[22:23]
		v_pk_mul_f32 v[132:133], v[154:155], v[22:23]
		v_pk_mul_f32 v[134:135], v[156:157], v[22:23]
		v_pk_mul_f32 v[136:137], v[158:159], v[22:23]
		v_cvt_pk_bf16_f32 v140, v4, v5
		v_cvt_pk_bf16_f32 v141, v6, v7
		v_cvt_pk_bf16_f32 v142, v14, v15
		v_cvt_pk_bf16_f32 v143, v16, v17
		v_cvt_pk_bf16_f32 v4, v18, v19
		v_cvt_pk_bf16_f32 v5, v20, v21
		v_cvt_pk_bf16_f32 v6, v24, v25
		v_cvt_pk_bf16_f32 v7, v26, v27
		v_cvt_pk_bf16_f32 v16, v28, v29
		v_cvt_pk_bf16_f32 v17, v30, v31
		v_cvt_pk_bf16_f32 v18, v32, v33
		v_cvt_pk_bf16_f32 v19, v34, v35
		v_cvt_pk_bf16_f32 v20, v36, v37
		v_cvt_pk_bf16_f32 v21, v38, v39
		v_cvt_pk_bf16_f32 v22, v40, v41
		v_cvt_pk_bf16_f32 v23, v42, v43
		v_cvt_pk_bf16_f32 v24, v44, v45
		v_cvt_pk_bf16_f32 v25, v46, v47
		v_cvt_pk_bf16_f32 v26, v48, v49
		v_cvt_pk_bf16_f32 v27, v50, v51
		v_cvt_pk_bf16_f32 v28, v52, v53
		v_cvt_pk_bf16_f32 v29, v54, v55
		v_cvt_pk_bf16_f32 v30, v56, v57
		v_cvt_pk_bf16_f32 v31, v58, v59
		v_cvt_pk_bf16_f32 v32, v60, v61
		v_cvt_pk_bf16_f32 v33, v62, v63
		v_cvt_pk_bf16_f32 v34, v64, v65
		v_cvt_pk_bf16_f32 v35, v66, v67
		v_cvt_pk_bf16_f32 v36, v68, v69
		v_cvt_pk_bf16_f32 v37, v70, v71
		v_cvt_pk_bf16_f32 v38, v72, v73
		v_cvt_pk_bf16_f32 v39, v74, v75
		v_cvt_pk_bf16_f32 v40, v0, v1
		v_cvt_pk_bf16_f32 v41, v76, v77
		v_cvt_pk_bf16_f32 v42, v78, v79
		v_cvt_pk_bf16_f32 v43, v80, v81
		v_cvt_pk_bf16_f32 v44, v82, v83
		v_cvt_pk_bf16_f32 v45, v84, v85
		v_cvt_pk_bf16_f32 v46, v86, v87
		v_cvt_pk_bf16_f32 v47, v88, v89
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
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
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
		s_and_saveexec_b64 s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_16
		buffer_store_dwordx4 v[140:143], v13, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_16:
		s_andn2_b64 exec, s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_16
.L_attn_fwd_async_prefetch.exec_endif_16:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 32
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v0, v10, 6, s3
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_17
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_17:
		s_andn2_b64 exec, s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_17
.L_attn_fwd_async_prefetch.exec_endif_17:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 64
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v0, v10, 6, s3
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_18
		buffer_store_dwordx4 v[16:19], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_18:
		s_andn2_b64 exec, s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_18
.L_attn_fwd_async_prefetch.exec_endif_18:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0x60
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v0, v10, 6, s3
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_19
		buffer_store_dwordx4 v[20:23], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_19:
		s_andn2_b64 exec, s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_19
.L_attn_fwd_async_prefetch.exec_endif_19:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0x80
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v0, v10, 6, s3
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_20
		buffer_store_dwordx4 v[24:27], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_20:
		s_andn2_b64 exec, s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_20
.L_attn_fwd_async_prefetch.exec_endif_20:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0xa0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v0, v10, 6, s3
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_21
		buffer_store_dwordx4 v[28:31], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_21:
		s_andn2_b64 exec, s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_21
.L_attn_fwd_async_prefetch.exec_endif_21:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0xc0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v0, v10, 6, s3
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_22
		buffer_store_dwordx4 v[32:35], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_22:
		s_andn2_b64 exec, s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_22
.L_attn_fwd_async_prefetch.exec_endif_22:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0xe0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v0, v10, 6, s3
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_23
		buffer_store_dwordx4 v[36:39], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_23:
		s_andn2_b64 exec, s[48:49], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_23
.L_attn_fwd_async_prefetch.exec_endif_23:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s3, s23, 8
		s_add_i32 s8, s3, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v0, v10, 6, s8
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_24
		buffer_store_dwordx4 v[40:43], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_24:
		s_andn2_b64 exec, s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_24
.L_attn_fwd_async_prefetch.exec_endif_24:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 32
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v0, v10, 6, s8
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_25
		buffer_store_dwordx4 v[44:47], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_25:
		s_andn2_b64 exec, s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_25
.L_attn_fwd_async_prefetch.exec_endif_25:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 64
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v0, v10, 6, s8
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_26
		buffer_store_dwordx4 v[48:51], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_26:
		s_andn2_b64 exec, s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_26
.L_attn_fwd_async_prefetch.exec_endif_26:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 0x60
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v0, v10, 6, s8
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_27
		buffer_store_dwordx4 v[52:55], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_27:
		s_andn2_b64 exec, s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_27
.L_attn_fwd_async_prefetch.exec_endif_27:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 0x80
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v0, v10, 6, s8
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_28
		buffer_store_dwordx4 v[56:59], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_28:
		s_andn2_b64 exec, s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_28
.L_attn_fwd_async_prefetch.exec_endif_28:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 0xa0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v0, v10, 6, s8
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_29
		buffer_store_dwordx4 v[60:63], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_29:
		s_andn2_b64 exec, s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_29
.L_attn_fwd_async_prefetch.exec_endif_29:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 0xc0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v0, v10, 6, s8
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_30
		buffer_store_dwordx4 v[64:67], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_30:
		s_andn2_b64 exec, s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_30
.L_attn_fwd_async_prefetch.exec_endif_30:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s3, 0xe0
		s_add_i32 s1, s3, s1
		s_add_i32 s1, s1, s2
		s_add_i32 s0, s1, s0
		v_lshl_add_u32 v0, v10, 6, s0
		v_lshl_add_u32 v0, v11, 1, v0
		v_lshl_add_u32 v0, v9, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v12, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_31
		buffer_store_dwordx4 v[68:71], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_31:
		s_andn2_b64 exec, s[48:49], s[28:29]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_31
.L_attn_fwd_async_prefetch.exec_endif_31:
		s_mov_b64 exec, s[48:49]
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
		.amdhsa_next_free_vgpr 424
		.amdhsa_next_free_sgpr 50
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
	.set .L_attn_fwd_async_prefetch.num_agpr, 168
	.set .L_attn_fwd_async_prefetch.numbered_sgpr, 50
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
    .sgpr_count:     50
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_async_prefetch.kd
    .uses_dynamic_stack: false
    .vgpr_count:     424
    .agpr_count:     168
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 67
    wave.regalloc.agpr.dwords: 264
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
