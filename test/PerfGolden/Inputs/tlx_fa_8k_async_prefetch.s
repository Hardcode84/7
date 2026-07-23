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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_0
		buffer_load_dwordx4 v[36:39], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_0:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_0
		v_mov_b32_e32 v36, v32
		v_mov_b32_e32 v37, v33
		v_mov_b32_e32 v38, v34
		v_mov_b32_e32 v39, v35
.L_attn_fwd_async_prefetch.exec_endif_0:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_1
		buffer_load_dwordx4 v[40:43], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_1:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_1
		v_mov_b32_e32 v40, v32
		v_mov_b32_e32 v41, v33
		v_mov_b32_e32 v42, v34
		v_mov_b32_e32 v43, v35
.L_attn_fwd_async_prefetch.exec_endif_1:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_2
		buffer_load_dwordx4 v[44:47], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_2:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_2
		v_mov_b32_e32 v44, v32
		v_mov_b32_e32 v45, v33
		v_mov_b32_e32 v46, v34
		v_mov_b32_e32 v47, v35
.L_attn_fwd_async_prefetch.exec_endif_2:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_3
		buffer_load_dwordx4 v[48:51], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_3:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_3
		v_mov_b32_e32 v48, v32
		v_mov_b32_e32 v49, v33
		v_mov_b32_e32 v50, v34
		v_mov_b32_e32 v51, v35
.L_attn_fwd_async_prefetch.exec_endif_3:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_4
		buffer_load_dwordx4 v[52:55], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_4:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_4
		v_mov_b32_e32 v52, v32
		v_mov_b32_e32 v53, v33
		v_mov_b32_e32 v54, v34
		v_mov_b32_e32 v55, v35
.L_attn_fwd_async_prefetch.exec_endif_4:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_5
		buffer_load_dwordx4 v[56:59], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_5:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_5
		v_mov_b32_e32 v56, v32
		v_mov_b32_e32 v57, v33
		v_mov_b32_e32 v58, v34
		v_mov_b32_e32 v59, v35
.L_attn_fwd_async_prefetch.exec_endif_5:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_6
		buffer_load_dwordx4 v[20:23], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_6:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_6
		v_mov_b32_e32 v20, v32
		v_mov_b32_e32 v21, v33
		v_mov_b32_e32 v22, v34
		v_mov_b32_e32 v23, v35
.L_attn_fwd_async_prefetch.exec_endif_6:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_7
		buffer_load_dwordx4 v[60:63], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_7:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_7
		v_mov_b32_e32 v60, v32
		v_mov_b32_e32 v61, v33
		v_mov_b32_e32 v62, v34
		v_mov_b32_e32 v63, v35
.L_attn_fwd_async_prefetch.exec_endif_7:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_8
		buffer_load_dwordx4 v[64:67], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_8:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_8
		v_mov_b32_e32 v64, v32
		v_mov_b32_e32 v65, v33
		v_mov_b32_e32 v66, v34
		v_mov_b32_e32 v67, v35
.L_attn_fwd_async_prefetch.exec_endif_8:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_9
		buffer_load_dwordx4 v[68:71], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_9:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_9
		v_mov_b32_e32 v68, v32
		v_mov_b32_e32 v69, v33
		v_mov_b32_e32 v70, v34
		v_mov_b32_e32 v71, v35
.L_attn_fwd_async_prefetch.exec_endif_9:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_10
		buffer_load_dwordx4 v[24:27], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_10:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_10
		v_mov_b32_e32 v24, v32
		v_mov_b32_e32 v25, v33
		v_mov_b32_e32 v26, v34
		v_mov_b32_e32 v27, v35
.L_attn_fwd_async_prefetch.exec_endif_10:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_11
		buffer_load_dwordx4 v[72:75], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_11:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_11
		v_mov_b32_e32 v72, v32
		v_mov_b32_e32 v73, v33
		v_mov_b32_e32 v74, v34
		v_mov_b32_e32 v75, v35
.L_attn_fwd_async_prefetch.exec_endif_11:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_12
		buffer_load_dwordx4 v[76:79], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_12:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_12
		v_mov_b32_e32 v76, v32
		v_mov_b32_e32 v77, v33
		v_mov_b32_e32 v78, v34
		v_mov_b32_e32 v79, v35
.L_attn_fwd_async_prefetch.exec_endif_12:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_13
		buffer_load_dwordx4 v[80:83], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_13:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_13
		v_mov_b32_e32 v80, v32
		v_mov_b32_e32 v81, v33
		v_mov_b32_e32 v82, v34
		v_mov_b32_e32 v83, v35
.L_attn_fwd_async_prefetch.exec_endif_13:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_14
		buffer_load_dwordx4 v[28:31], v7, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_14:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_14
		v_mov_b32_e32 v28, v32
		v_mov_b32_e32 v29, v33
		v_mov_b32_e32 v30, v34
		v_mov_b32_e32 v31, v35
.L_attn_fwd_async_prefetch.exec_endif_14:
		s_mov_b64 exec, s[82:83]
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
		s_and_saveexec_b64 s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_15
		buffer_load_dwordx4 v[84:87], v1, s[32:35], 0 offen
.L_attn_fwd_async_prefetch.exec_else_15:
		s_andn2_b64 exec, s[82:83], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_15
		v_mov_b32_e32 v84, v32
		v_mov_b32_e32 v85, v33
		v_mov_b32_e32 v86, v34
		v_mov_b32_e32 v87, v35
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
		v_add3_u32 v36, v16, v20, v23
		v_add3_u32 v37, v33, v35, v36
		v_xor_b32_e32 v37, v37, v34
		v_lshl_add_u32 v32, v37, 4, v32
		ds_read_b128 a[0:3], v32 offset:2480
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v37, 2, v33
		v_add3_u32 v37, v37, v35, v36
		v_bitop3_b32 v37, v22, v37, v34 bitop3:0x96
		v_lshl_add_u32 v21, v37, 4, v21
		ds_read_b128 a[4:7], v21 offset:2480
		v_add_u32_e32 v37, 4, v33
		v_add3_u32 v36, v37, v35, v36
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
		v_bitop3_b32 v17, 4, v12, v10 bitop3:0x96
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
		v_bitop3_b32 v6, v17, v14, v1 bitop3:0x96
		v_bitop3_b32 v17, 8, v12, v10 bitop3:0x96
		v_bitop3_b32 v17, v17, v14, v1 bitop3:0x96
		v_bitop3_b32 v10, 12, v12, v10 bitop3:0x96
		v_bitop3_b32 v1, v10, v14, v1 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v16, s25
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v17, s25
		s_mov_b64 s[6:7], vcc
		v_cmp_lt_i32_e64 vcc, v1, s25
		v_readfirstlane_b32 s10, v0
		v_mul_lo_u32 v10, s15, v13
		v_mul_lo_u32 v12, s15, v2
		v_lshlrev_b32_e32 v12, 6, v12
		v_lshl_add_u32 v10, v10, 1, v12
		v_mul_lo_u32 v12, s15, v9
		v_lshl_add_u32 v10, v12, 5, v10
		v_lshlrev_b32_e32 v12, 4, v11
		v_lshlrev_b32_e32 v14, 7, v8
		v_add3_u32 v10, v10, v12, v14
		v_lshlrev_b32_e32 v18, 6, v15
		v_lshlrev_b32_e32 v19, 5, v3
		v_add3_u32 v10, v10, v18, v19
		s_mul_i32 s11, s17, s13
		s_lshl_b32 s11, s11, 1
		s_mul_i32 s12, s0, s14
		s_lshl_b32 s12, s12, 1
		s_add_i32 s13, s11, s12
		v_add_u32_e32 v20, s13, v10
		v_mov_b32_e32 v21, 0x80000000
		s_lshr_b32 s10, s10, 6
		s_mul_i32 s13, 0x410, s10
		s_mov_b32 m0, s13
		v_cndmask_b32_e64 v20, v21, v20, s[2:3]
		buffer_load_dwordx4 v20, s[36:39], 0 offen lds
		s_lshl_b32 s14, s15, 3
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s12
		v_add_u32_e32 v20, s14, v10
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v20, v21, v20, s[4:5]
		buffer_load_dwordx4 v20, s[36:39], 0 offen lds
		s_lshl_b32 s14, s15, 4
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s12
		v_add_u32_e32 v20, s14, v10
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v20, v21, v20, s[6:7]
		buffer_load_dwordx4 v20, s[36:39], 0 offen lds
		s_mul_i32 s14, 24, s15
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s12
		v_add_u32_e32 v20, s14, v10
		v_cndmask_b32_e32 v20, v21, v20, vcc
		s_add_i32 m0, m0, 0x1040
		v_mul_lo_u32 v22, s20, v13
		buffer_load_dwordx4 v20, s[36:39], 0 offen lds
		v_mul_lo_u32 v20, s20, v2
		v_lshlrev_b32_e32 v20, 6, v20
		v_lshl_add_u32 v20, v22, 1, v20
		v_mul_lo_u32 v22, s20, v9
		v_lshl_add_u32 v20, v22, 5, v20
		v_add3_u32 v12, v20, v12, v14
		v_add3_u32 v12, v12, v18, v19
		s_mul_i32 s14, s17, s18
		s_lshl_b32 s14, s14, 1
		s_mul_i32 s18, s0, s19
		s_lshl_b32 s18, s18, 1
		s_add_i32 s19, s14, s18
		v_add_u32_e32 v14, s19, v12
		s_mul_i32 s10, 0x440, s10
		s_add_i32 m0, s10, 0x81f0
		v_cndmask_b32_e64 v14, v21, v14, s[2:3]
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
		s_lshl_b32 s2, s20, 3
		s_add_i32 s2, s2, s14
		s_add_i32 s2, s2, s18
		v_add_u32_e32 v14, s2, v12
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v14, v21, v14, s[4:5]
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
		s_lshl_b32 s2, s20, 4
		s_add_i32 s2, s2, s14
		s_add_i32 s2, s2, s18
		v_add_u32_e32 v14, s2, v12
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v14, v21, v14, s[6:7]
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
		s_mul_i32 s2, 24, s20
		s_add_i32 s2, s2, s14
		s_add_i32 s2, s2, s18
		v_add_u32_e32 v14, s2, v12
		v_cndmask_b32_e32 v14, v21, v14, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s2, s1, 64
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
		v_mbcnt_lo_u32_b32 v14, -1, 0
		v_mbcnt_hi_u32_b32 v14, -1, v14
		v_and_b32_e32 v18, 1, v14
		v_lshrrev_b32_e32 v19, 4, v14
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 4, v19
		v_lshrrev_b32_e32 v20, 3, v14
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 3, v20
		v_add3_u32 v22, v18, v19, v20
		v_lshrrev_b32_e32 v23, 2, v14
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 2, v23
		v_lshrrev_b32_e32 v14, 1, v14
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add3_u32 v22, v22, v23, v14
		v_add_u32_e32 v18, 32, v18
		v_bitop3_b32 v14, v23, v18, v14 bitop3:0x96
		v_bitop3_b32 v14, v19, v20, v14 bitop3:0x96
		v_mov_b32_e32 v18, 0x3e0293ee
		v_mov_b32_e32 v19, 0x3e0293ee
		s_mov_b32 s3, 0xff800000
		v_mov_b32_e32 v20, s3
		s_mov_b32 s4, 0
		v_lshlrev_b32_e32 v23, 4, v33
		v_and_b32_e32 v7, 31, v7
		v_lshrrev_b32_e32 v24, 4, v7
		v_lshlrev_b32_e32 v25, 8, v24
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
		s_lshl_b32 s5, s15, 7
		s_add_i32 s5, s5, s11
		s_add_i32 s5, s5, s12
		s_mul_i32 s6, 0x88, s15
		s_add_i32 s6, s6, s11
		s_add_i32 s6, s6, s12
		s_mul_i32 s7, 0x90, s15
		s_add_i32 s7, s7, s11
		s_add_i32 s7, s7, s12
		s_mul_i32 s19, 0x98, s15
		s_add_i32 s11, s19, s11
		s_add_i32 s11, s11, s12
		s_lshl_b32 s12, s20, 7
		s_add_i32 s12, s12, s14
		s_add_i32 s12, s12, s18
		s_mul_i32 s19, 0x88, s20
		s_add_i32 s19, s19, s14
		s_add_i32 s19, s19, s18
		s_mul_i32 s24, 0x90, s20
		s_add_i32 s24, s24, s14
		s_add_i32 s24, s24, s18
		s_mul_i32 s30, 0x98, s20
		s_add_i32 s14, s30, s14
		s_add_i32 s14, s14, s18
		v_lshlrev_b32_e32 v4, 2, v22
		v_lshlrev_b32_e32 v14, 2, v14
		s_cmp_lt_i32 0, s2
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
		v_mov_b32_e32 v22, s3
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
		s_and_b32 s18, s3, 1
		s_mul_i32 s30, 0x4100, s18
		v_add3_u32 v32, s30, v23, v25
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
		s_mul_i32 s18, 0x4400, s18
		v_add3_u32 v32, s18, v0, v7
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
		s_mul_i32 s18, s15, s4
		s_lshl_b32 s18, s18, 1
		s_add_i32 s30, s5, s18
		v_add_u32_e32 v32, s30, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v188, s18, v10
		s_add_i32 s3, s3, 1
		v_add_u32_e32 v189, s6, v188
		s_and_b32 s3, s3, 1
		v_add_u32_e32 v190, s7, v188
		s_mul_i32 s18, 0x4100, s3
		v_add_u32_e32 v188, s11, v188
		s_add_i32 s18, s13, s18
		v_mfma_f32_32x32x16_bf16 v[192:207], v[36:39], a[0:3], 0
		s_mov_b32 m0, s18
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
		s_mul_i32 s18, s20, s4
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[32:35], 0
		s_add_i32 s4, s4, 64
		v_mfma_f32_32x32x16_bf16 v[240:255], v[36:39], a[32:35], 0
		v_add_u32_e32 v36, s4, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[4:7], v[192:207]
		v_add_u32_e32 v37, s4, v6
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], v[208:223]
		v_add_u32_e32 v38, s4, v17
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[36:39], v[224:239]
		v_add_u32_e32 v39, s4, v1
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
		v_cndmask_b32_e64 v32, v21, v32, s[30:31]
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v32, v21, v189, s[32:33]
		v_cndmask_b32_e64 v36, v21, v190, s[44:45]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v37, v21, v188, vcc
		s_lshl_b32 s18, s18, 1
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		s_add_i32 s46, s12, s18
		v_add_u32_e32 v32, s46, v12
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s3, 0x4400, s3
		s_add_i32 s3, s10, s3
		buffer_load_dwordx4 v36, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v32, v21, v32, s[30:31]
		v_add_u32_e32 v36, s18, v12
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v38, s19, v36
		v_cndmask_b32_e64 v38, v21, v38, s[32:33]
		buffer_load_dwordx4 v37, s[36:39], 0 offen lds
		v_add_u32_e32 v37, s24, v36
		v_cndmask_b32_e64 v37, v21, v37, s[44:45]
		s_add_i32 m0, s3, 0x81f0
		v_add_u32_e32 v36, s14, v36
		v_cndmask_b32_e32 v36, v21, v36, vcc
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
		s_cmp_lt_i32 s4, s2
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
		ds_bpermute_b32 v36, v4, v32
		ds_bpermute_b32 v37, v14, v32
		v_max3_f32 v32, v240, v241, v242
		v_max3_f32 v38, v244, v245, v246
		v_max3_f32 v39, v248, v249, v250
		v_max3_f32 v40, v252, v253, v254
		v_max3_f32 v41, v224, v225, v226
		v_max3_f32 v42, v228, v229, v230
		v_max3_f32 v43, v232, v233, v234
		v_max3_f32 v44, v236, v237, v238
		v_max3_f32 v32, v32, v243, v38
		v_max3_f32 v38, v39, v251, v40
		v_max3_f32 v39, v41, v227, v42
		v_max3_f32 v40, v43, v235, v44
		v_max3_f32 v32, v32, v247, v38
		v_max3_f32 v38, v39, v231, v40
		v_max3_f32 v32, v32, v255, v38
		v_max_f32_e32 v32, v32, v239
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v38, v36, v37
		ds_bpermute_b32 v36, v4, v32
		ds_bpermute_b32 v37, v14, v32
		v_pk_mul_f32 v[40:41], v[192:193], v[18:19]
		v_pk_mul_f32 v[42:43], v[194:195], v[18:19]
		v_pk_mul_f32 v[44:45], v[196:197], v[18:19]
		v_pk_mul_f32 v[46:47], v[198:199], v[18:19]
		v_pk_mul_f32 v[176:177], v[200:201], v[18:19]
		v_pk_mul_f32 v[178:179], v[202:203], v[18:19]
		v_pk_mul_f32 v[180:181], v[204:205], v[18:19]
		v_pk_mul_f32 v[182:183], v[206:207], v[18:19]
		v_pk_mul_f32 v[184:185], v[208:209], v[18:19]
		v_pk_mul_f32 v[186:187], v[210:211], v[18:19]
		v_pk_mul_f32 v[188:189], v[212:213], v[18:19]
		v_pk_mul_f32 v[190:191], v[214:215], v[18:19]
		v_pk_mul_f32 v[192:193], v[216:217], v[18:19]
		v_pk_mul_f32 v[194:195], v[218:219], v[18:19]
		v_pk_mul_f32 v[196:197], v[220:221], v[18:19]
		v_pk_mul_f32 v[198:199], v[222:223], v[18:19]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v39, v36, v37
		v_pk_mul_f32 v[36:37], v[38:39], v[18:19]
		v_max_f32_e32 v32, v20, v36
		v_max_f32_e32 v36, v22, v37
		v_pk_mul_f32 v[38:39], v[240:241], v[18:19]
		v_pk_mul_f32 v[200:201], v[242:243], v[18:19]
		v_pk_mul_f32 v[202:203], v[244:245], v[18:19]
		v_pk_mul_f32 v[204:205], v[246:247], v[18:19]
		v_pk_mul_f32 v[206:207], v[248:249], v[18:19]
		v_pk_mul_f32 v[208:209], v[250:251], v[18:19]
		v_pk_mul_f32 v[210:211], v[252:253], v[18:19]
		v_pk_mul_f32 v[212:213], v[254:255], v[18:19]
		v_pk_mul_f32 v[214:215], v[224:225], v[18:19]
		v_pk_mul_f32 v[216:217], v[226:227], v[18:19]
		v_pk_mul_f32 v[218:219], v[228:229], v[18:19]
		v_pk_mul_f32 v[220:221], v[230:231], v[18:19]
		v_pk_mul_f32 v[222:223], v[232:233], v[18:19]
		v_pk_mul_f32 v[224:225], v[234:235], v[18:19]
		v_pk_mul_f32 v[226:227], v[236:237], v[18:19]
		v_pk_mul_f32 v[228:229], v[238:239], v[18:19]
		v_sub_f32_e32 v37, v40, v32
		v_sub_f32_e32 v40, v41, v32
		v_sub_f32_e32 v41, v42, v32
		v_sub_f32_e32 v42, v43, v32
		v_sub_f32_e32 v43, v44, v32
		v_sub_f32_e32 v44, v45, v32
		v_sub_f32_e32 v45, v46, v32
		v_sub_f32_e32 v46, v47, v32
		v_sub_f32_e32 v47, v176, v32
		v_sub_f32_e32 v176, v177, v32
		v_sub_f32_e32 v177, v178, v32
		v_sub_f32_e32 v178, v179, v32
		v_sub_f32_e32 v179, v180, v32
		v_sub_f32_e32 v180, v181, v32
		v_sub_f32_e32 v181, v182, v32
		v_sub_f32_e32 v182, v183, v32
		v_sub_f32_e32 v183, v184, v32
		v_sub_f32_e32 v184, v185, v32
		v_sub_f32_e32 v185, v186, v32
		v_sub_f32_e32 v186, v187, v32
		v_sub_f32_e32 v187, v188, v32
		v_sub_f32_e32 v188, v189, v32
		v_sub_f32_e32 v189, v190, v32
		v_sub_f32_e32 v190, v191, v32
		v_sub_f32_e32 v191, v192, v32
		v_sub_f32_e32 v192, v193, v32
		v_sub_f32_e32 v193, v194, v32
		v_sub_f32_e32 v194, v195, v32
		v_sub_f32_e32 v195, v196, v32
		v_sub_f32_e32 v196, v197, v32
		v_sub_f32_e32 v197, v198, v32
		v_sub_f32_e32 v198, v199, v32
		v_sub_f32_e32 v38, v38, v36
		v_sub_f32_e32 v39, v39, v36
		v_sub_f32_e32 v199, v200, v36
		v_sub_f32_e32 v200, v201, v36
		v_sub_f32_e32 v201, v202, v36
		v_sub_f32_e32 v202, v203, v36
		v_sub_f32_e32 v203, v204, v36
		v_sub_f32_e32 v204, v205, v36
		v_sub_f32_e32 v205, v206, v36
		v_sub_f32_e32 v206, v207, v36
		v_sub_f32_e32 v207, v208, v36
		v_sub_f32_e32 v208, v209, v36
		v_sub_f32_e32 v209, v210, v36
		v_sub_f32_e32 v210, v211, v36
		v_sub_f32_e32 v211, v212, v36
		v_sub_f32_e32 v212, v213, v36
		v_sub_f32_e32 v213, v214, v36
		v_sub_f32_e32 v214, v215, v36
		v_sub_f32_e32 v215, v216, v36
		v_sub_f32_e32 v216, v217, v36
		v_sub_f32_e32 v217, v218, v36
		v_sub_f32_e32 v218, v219, v36
		v_sub_f32_e32 v219, v220, v36
		v_sub_f32_e32 v220, v221, v36
		v_sub_f32_e32 v221, v222, v36
		v_sub_f32_e32 v222, v223, v36
		v_sub_f32_e32 v223, v224, v36
		v_sub_f32_e32 v224, v225, v36
		v_sub_f32_e32 v225, v226, v36
		v_sub_f32_e32 v226, v227, v36
		v_sub_f32_e32 v227, v228, v36
		v_sub_f32_e32 v228, v229, v36
		v_exp_f32_e32 v230, v37
		v_exp_f32_e32 v232, v40
		v_exp_f32_e32 v231, v41
		v_exp_f32_e32 v233, v42
		v_exp_f32_e32 v40, v43
		v_exp_f32_e32 v42, v44
		v_exp_f32_e32 v41, v45
		v_exp_f32_e32 v43, v46
		v_exp_f32_e32 v44, v47
		v_exp_f32_e32 v46, v176
		v_exp_f32_e32 v45, v177
		v_exp_f32_e32 v47, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v178, v180
		v_exp_f32_e32 v177, v181
		v_exp_f32_e32 v179, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v182, v184
		v_exp_f32_e32 v181, v185
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v184, v187
		v_exp_f32_e32 v186, v188
		v_exp_f32_e32 v185, v189
		v_exp_f32_e32 v187, v190
		v_exp_f32_e32 v188, v191
		v_exp_f32_e32 v190, v192
		v_exp_f32_e32 v189, v193
		v_exp_f32_e32 v191, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v194, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v195, v198
		v_exp_f32_e32 v197, v38
		v_exp_f32_e32 v235, v39
		v_exp_f32_e32 v38, v199
		v_exp_f32_e32 v198, v200
		v_exp_f32_e32 v39, v201
		v_exp_f32_e32 v199, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v202, v204
		v_exp_f32_e32 v201, v205
		v_exp_f32_e32 v203, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v206, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v207, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v210, v212
		v_exp_f32_e32 v209, v213
		v_exp_f32_e32 v211, v214
		v_exp_f32_e32 v212, v215
		v_exp_f32_e32 v214, v216
		v_exp_f32_e32 v213, v217
		v_exp_f32_e32 v215, v218
		v_exp_f32_e32 v216, v219
		v_exp_f32_e32 v218, v220
		v_exp_f32_e32 v217, v221
		v_exp_f32_e32 v219, v222
		v_exp_f32_e32 v220, v223
		v_exp_f32_e32 v222, v224
		v_exp_f32_e32 v221, v225
		v_exp_f32_e32 v223, v226
		v_exp_f32_e32 v224, v227
		v_exp_f32_e32 v226, v228
		v_pk_add_f32 v[228:229], v[230:231], v[232:233]
		v_pk_add_f32 v[236:237], v[40:41], v[42:43]
		v_pk_add_f32 v[238:239], v[44:45], v[46:47]
		v_pk_add_f32 v[240:241], v[176:177], v[178:179]
		v_pk_add_f32 v[242:243], v[180:181], v[182:183]
		v_pk_add_f32 v[244:245], v[184:185], v[186:187]
		v_pk_add_f32 v[246:247], v[188:189], v[190:191]
		v_pk_add_f32 v[248:249], v[192:193], v[194:195]
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
		v_add_f32_e32 v37, v228, v229
		ds_bpermute_b32 v196, v4, v37
		ds_bpermute_b32 v234, v14, v37
		v_pk_add_f32 v[228:229], v[38:39], v[198:199]
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
		v_sub_f32_e32 v20, v20, v32
		v_sub_f32_e32 v22, v22, v36
		v_exp_f32_e32 v236, v20
		v_exp_f32_e32 v238, v22
		v_mov_b32_e32 v237, v236
		v_pk_mul_f32 v[48:49], v[48:49], v[236:237]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[244:245], v[196:197], v[234:235]
		v_mov_b32_e32 v225, v245
		v_mov_b32_e32 v227, v228
		v_pk_add_f32 v[228:229], v[224:225], v[226:227]
		v_mov_b32_e32 v248, v247
		v_mov_b32_e32 v249, v250
		v_pk_add_f32 v[228:229], v[248:249], v[228:229]
		v_mov_b32_e32 v246, v241
		v_mov_b32_e32 v247, v242
		v_pk_add_f32 v[240:241], v[246:247], v[228:229]
		v_add_f32_e32 v20, v243, v240
		v_add_f32_e32 v20, v241, v20
		ds_bpermute_b32 v22, v4, v20
		ds_bpermute_b32 v37, v14, v20
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
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v229, v22, v37
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
		v_mov_b32_e32 v228, v244
		v_mov_b32_e32 v240, v236
		v_mov_b32_e32 v241, v238
		v_pk_fma_f32 v[34:35], v[34:35], v[240:241], v[228:229]
		v_cvt_pk_bf16_f32 v236, v230, v232
		v_cvt_pk_bf16_f32 v237, v231, v233
		v_cvt_pk_bf16_f32 v238, v40, v42
		v_cvt_pk_bf16_f32 v239, v41, v43
		v_cvt_pk_bf16_f32 v40, v44, v46
		v_cvt_pk_bf16_f32 v41, v45, v47
		v_cvt_pk_bf16_f32 v42, v176, v178
		v_cvt_pk_bf16_f32 v43, v177, v179
		v_cvt_pk_bf16_f32 v44, v180, v182
		v_cvt_pk_bf16_f32 v45, v181, v183
		v_cvt_pk_bf16_f32 v46, v184, v186
		v_cvt_pk_bf16_f32 v47, v185, v187
		v_cvt_pk_bf16_f32 v176, v188, v190
		v_cvt_pk_bf16_f32 v177, v189, v191
		v_cvt_pk_bf16_f32 v178, v192, v194
		v_cvt_pk_bf16_f32 v179, v193, v195
		v_cvt_pk_bf16_f32 v180, v197, v235
		v_cvt_pk_bf16_f32 v181, v38, v198
		v_cvt_pk_bf16_f32 v182, v39, v199
		v_cvt_pk_bf16_f32 v183, v200, v202
		v_cvt_pk_bf16_f32 v184, v201, v203
		v_cvt_pk_bf16_f32 v185, v204, v206
		v_cvt_pk_bf16_f32 v186, v205, v207
		v_cvt_pk_bf16_f32 v187, v208, v210
		v_cvt_pk_bf16_f32 v188, v209, v211
		v_cvt_pk_bf16_f32 v189, v212, v214
		v_cvt_pk_bf16_f32 v190, v213, v215
		v_cvt_pk_bf16_f32 v191, v216, v218
		v_cvt_pk_bf16_f32 v192, v217, v219
		v_cvt_pk_bf16_f32 v193, v220, v222
		v_cvt_pk_bf16_f32 v194, v221, v223
		v_cvt_pk_bf16_f32 v195, v224, v226
		v_permlane32_swap_b32_e32 v236, v238
		v_permlane32_swap_b32_e32 v237, v239
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[48:63], a[104:107], v[236:239], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[236:239], v[64:79]
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[236:239], v[80:95]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[96:111], a[152:155], v[236:239], v[96:111]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[108:111], v[40:43], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[160:175], a[152:155], v[180:183], v[160:175]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[112:127], a[104:107], v[180:183], v[112:127]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[128:143], a[120:123], v[180:183], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[136:139], v[180:183], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[40:43], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[40:43], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[156:159], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[156:159], v[184:187], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[108:111], v[184:187], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[124:127], v[184:187], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[140:143], v[184:187], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[44:47], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[44:47], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[44:47], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[160:163], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[160:163], v[188:191], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[188:191], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[188:191], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[188:191], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[176:179], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[176:179], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[176:179], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[164:167], v[176:179], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[164:167], v[192:195], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[192:195], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[192:195], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[192:195], v[144:159]
		v_mov_b32_e32 v20, v32
		v_mov_b32_e32 v22, v36
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
		v_lshl_add_u32 v1, v33, 4, s3
		v_lshl_add_u32 v1, v24, 8, v1
		v_add3_u32 v1, v1, v27, v28
		v_add3_u32 v1, v1, v29, v26
		ds_read_b128 v[24:27], v1
		ds_read_b128 v[36:39], v1 offset:32
		ds_read_b128 v[40:43], v1 offset:64
		ds_read_b128 a[64:67], v1 offset:96
		ds_read_b128 a[68:71], v1 offset:128
		ds_read_b128 a[72:75], v1 offset:160
		ds_read_b128 a[76:79], v1 offset:192
		ds_read_b128 a[80:83], v1 offset:224
		ds_read_b128 v[44:47], v1 offset:512
		ds_read_b128 v[176:179], v1 offset:544
		ds_read_b128 v[180:183], v1 offset:576
		ds_read_b128 a[84:87], v1 offset:608
		ds_read_b128 a[88:91], v1 offset:640
		ds_read_b128 a[92:95], v1 offset:672
		ds_read_b128 a[96:99], v1 offset:704
		ds_read_b128 a[100:103], v1 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_add3_u32 v0, s1, v0, v7
		v_add3_u32 v0, v0, v30, v31
		ds_read_b64_tr_b16 a[104:105], v0 offset:33264
		ds_read_b64_tr_b16 a[106:107], v0 offset:37616
		ds_read_b64_tr_b16 a[108:109], v0 offset:33520
		ds_read_b64_tr_b16 a[110:111], v0 offset:37872
		ds_read_b64_tr_b16 a[112:113], v0 offset:33776
		ds_read_b64_tr_b16 a[114:115], v0 offset:38128
		ds_read_b64_tr_b16 a[116:117], v0 offset:34032
		ds_read_b64_tr_b16 a[118:119], v0 offset:38384
		ds_read_b64_tr_b16 a[120:121], v0 offset:33328
		ds_read_b64_tr_b16 a[122:123], v0 offset:37680
		ds_read_b64_tr_b16 a[124:125], v0 offset:33584
		ds_read_b64_tr_b16 a[126:127], v0 offset:37936
		ds_read_b64_tr_b16 a[128:129], v0 offset:33840
		ds_read_b64_tr_b16 a[130:131], v0 offset:38192
		ds_read_b64_tr_b16 a[132:133], v0 offset:34096
		ds_read_b64_tr_b16 a[134:135], v0 offset:38448
		ds_read_b64_tr_b16 a[136:137], v0 offset:33392
		ds_read_b64_tr_b16 a[138:139], v0 offset:37744
		ds_read_b64_tr_b16 a[140:141], v0 offset:33648
		ds_read_b64_tr_b16 a[142:143], v0 offset:38000
		ds_read_b64_tr_b16 a[144:145], v0 offset:33904
		ds_read_b64_tr_b16 a[146:147], v0 offset:38256
		ds_read_b64_tr_b16 a[148:149], v0 offset:34160
		ds_read_b64_tr_b16 a[150:151], v0 offset:38512
		ds_read_b64_tr_b16 a[152:153], v0 offset:33456
		ds_read_b64_tr_b16 a[154:155], v0 offset:37808
		ds_read_b64_tr_b16 a[156:157], v0 offset:33712
		ds_read_b64_tr_b16 a[158:159], v0 offset:38064
		ds_read_b64_tr_b16 a[160:161], v0 offset:33968
		ds_read_b64_tr_b16 a[162:163], v0 offset:38320
		ds_read_b64_tr_b16 a[164:165], v0 offset:34224
		ds_read_b64_tr_b16 a[166:167], v0 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[0:3], 0
		v_mov_b32_e32 v0, 4
		v_mul_lo_u32 v0, v0, v5
		v_add_u32_e32 v1, s2, v0
		v_xad_u32 v6, 1, v0, s2
		v_xad_u32 v7, 2, v0, s2
		v_xad_u32 v10, 3, v0, s2
		v_xad_u32 v12, 8, v0, s2
		v_mfma_f32_32x32x16_bf16 v[208:223], v[44:47], a[0:3], 0
		v_xad_u32 v16, 9, v0, s2
		v_xad_u32 v17, 10, v0, s2
		v_xad_u32 v21, 11, v0, s2
		v_xad_u32 v23, 16, v0, s2
		v_xad_u32 v28, 17, v0, s2
		v_xad_u32 v29, 18, v0, s2
		v_xad_u32 v30, 19, v0, s2
		v_mfma_f32_32x32x16_bf16 v[224:239], v[44:47], a[32:35], 0
		v_xad_u32 v31, 24, v0, s2
		v_xad_u32 v32, 25, v0, s2
		v_xad_u32 v33, 26, v0, s2
		v_xad_u32 v44, 27, v0, s2
		v_xad_u32 v45, 32, v0, s2
		v_xad_u32 v46, 33, v0, s2
		v_xad_u32 v47, 34, v0, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], v[24:27], a[32:35], 0
		v_xad_u32 v24, 35, v0, s2
		v_xad_u32 v25, 40, v0, s2
		v_xad_u32 v26, 41, v0, s2
		v_xad_u32 v27, 42, v0, s2
		v_xad_u32 v184, 43, v0, s2
		v_xad_u32 v185, 48, v0, s2
		v_xad_u32 v186, 49, v0, s2
		v_mfma_f32_32x32x16_bf16 v[192:207], v[36:39], a[4:7], v[192:207]
		v_xad_u32 v187, 50, v0, s2
		v_xad_u32 v188, 51, v0, s2
		v_xad_u32 v189, 56, v0, s2
		v_xad_u32 v190, 57, v0, s2
		v_xad_u32 v191, 58, v0, s2
		v_xad_u32 v0, 59, v0, s2
		v_cmp_lt_i32_e64 vcc, v1, s25
		s_mov_b64 s[2:3], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[4:7], v[208:223]
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_mov_b64 s[8:9], vcc
		v_cmp_lt_i32_e64 vcc, v7, s25
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v10, s25
		s_mov_b64 s[12:13], vcc
		v_cmp_lt_i32_e64 vcc, v12, s25
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v16, s25
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v17, s25
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v21, s25
		s_mov_b64 s[32:33], vcc
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[36:39], v[224:239]
		v_cmp_lt_i32_e64 vcc, v23, s25
		s_mov_b64 s[34:35], vcc
		v_cmp_lt_i32_e64 vcc, v28, s25
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v29, s25
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v30, s25
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v31, s25
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v32, s25
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v33, s25
		s_mov_b64 s[46:47], vcc
		v_mfma_f32_32x32x16_bf16 v[240:255], v[36:39], a[36:39], v[240:255]
		v_cmp_lt_i32_e64 vcc, v44, s25
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v45, s25
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v46, s25
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v47, s25
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v24, s25
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v25, s25
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v26, s25
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[8:11], v[192:207]
		v_cmp_lt_i32_e64 vcc, v27, s25
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v184, s25
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v185, s25
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v186, s25
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v187, s25
		s_mov_b64 s[70:71], vcc
		v_cmp_lt_i32_e64 vcc, v188, s25
		s_mov_b64 s[72:73], vcc
		v_cmp_lt_i32_e64 vcc, v189, s25
		s_mov_b64 s[74:75], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[8:11], v[208:223]
		v_cmp_lt_i32_e64 vcc, v190, s25
		s_mov_b64 s[76:77], vcc
		v_cmp_lt_i32_e64 vcc, v191, s25
		s_mov_b64 s[78:79], vcc
		v_cmp_lt_i32_e64 vcc, v0, s25
		v_mov_b32_e32 v0, 0xff800000
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[12:15], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[44:47], v[240:255]
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
		v_mov_b32_e32 v1, 8
		v_mul_lo_u32 v1, v1, v5
		v_xor_b32_e32 v5, 16, v1
		v_xor_b32_e32 v6, 32, v1
		v_xor_b32_e32 v7, 48, v1
		v_xor_b32_e32 v10, 64, v1
		v_xor_b32_e32 v12, 0x50, v1
		v_xor_b32_e32 v16, 0x60, v1
		v_xor_b32_e32 v17, 0x70, v1
		s_nop 0
		v_cndmask_b32_e64 v24, v0, v192, s[2:3]
		v_cndmask_b32_e64 v25, v0, v193, s[8:9]
		v_cndmask_b32_e64 v26, v0, v194, s[10:11]
		v_cndmask_b32_e64 v27, v0, v195, s[12:13]
		v_cndmask_b32_e64 v28, v0, v196, s[14:15]
		v_cndmask_b32_e64 v29, v0, v197, s[18:19]
		v_cndmask_b32_e64 v30, v0, v198, s[30:31]
		v_cndmask_b32_e64 v31, v0, v199, s[32:33]
		v_cndmask_b32_e64 v32, v0, v200, s[34:35]
		v_cndmask_b32_e64 v33, v0, v201, s[36:37]
		v_cndmask_b32_e64 v36, v0, v202, s[38:39]
		v_cndmask_b32_e64 v37, v0, v203, s[40:41]
		v_cndmask_b32_e64 v38, v0, v204, s[42:43]
		v_cndmask_b32_e64 v39, v0, v205, s[44:45]
		v_cndmask_b32_e64 v40, v0, v206, s[46:47]
		v_cndmask_b32_e64 v41, v0, v207, s[48:49]
		v_cndmask_b32_e64 v42, v0, v208, s[50:51]
		v_cndmask_b32_e64 v43, v0, v209, s[52:53]
		v_cndmask_b32_e64 v44, v0, v210, s[54:55]
		v_cndmask_b32_e64 v45, v0, v211, s[56:57]
		v_cndmask_b32_e64 v46, v0, v212, s[58:59]
		v_cndmask_b32_e64 v47, v0, v213, s[60:61]
		v_cndmask_b32_e64 v176, v0, v214, s[62:63]
		v_cndmask_b32_e64 v177, v0, v215, s[64:65]
		v_cndmask_b32_e64 v178, v0, v216, s[66:67]
		v_cndmask_b32_e64 v179, v0, v217, s[68:69]
		v_cndmask_b32_e64 v180, v0, v218, s[70:71]
		v_cndmask_b32_e64 v181, v0, v219, s[72:73]
		v_cndmask_b32_e64 v182, v0, v220, s[74:75]
		v_cndmask_b32_e64 v183, v0, v221, s[76:77]
		v_cndmask_b32_e64 v184, v0, v222, s[78:79]
		v_cndmask_b32_e32 v185, v0, v223, vcc
		v_cndmask_b32_e64 v186, v0, v240, s[2:3]
		v_cndmask_b32_e64 v187, v0, v241, s[8:9]
		v_cndmask_b32_e64 v188, v0, v242, s[10:11]
		v_cndmask_b32_e64 v189, v0, v243, s[12:13]
		v_cndmask_b32_e64 v190, v0, v244, s[14:15]
		v_cndmask_b32_e64 v191, v0, v245, s[18:19]
		v_cndmask_b32_e64 v192, v0, v246, s[30:31]
		v_cndmask_b32_e64 v193, v0, v247, s[32:33]
		v_cndmask_b32_e64 v194, v0, v248, s[34:35]
		v_cndmask_b32_e64 v195, v0, v249, s[36:37]
		v_cndmask_b32_e64 v196, v0, v250, s[38:39]
		v_cndmask_b32_e64 v197, v0, v251, s[40:41]
		v_cndmask_b32_e64 v198, v0, v252, s[42:43]
		v_cndmask_b32_e64 v199, v0, v253, s[44:45]
		v_cndmask_b32_e64 v200, v0, v254, s[46:47]
		v_cndmask_b32_e64 v201, v0, v255, s[48:49]
		v_cndmask_b32_e64 v202, v0, v224, s[50:51]
		v_cndmask_b32_e64 v203, v0, v225, s[52:53]
		v_cndmask_b32_e64 v204, v0, v226, s[54:55]
		v_cndmask_b32_e64 v205, v0, v227, s[56:57]
		v_cndmask_b32_e64 v206, v0, v228, s[58:59]
		v_cndmask_b32_e64 v207, v0, v229, s[60:61]
		v_cndmask_b32_e64 v208, v0, v230, s[62:63]
		v_cndmask_b32_e64 v209, v0, v231, s[64:65]
		v_cndmask_b32_e64 v210, v0, v232, s[66:67]
		v_cndmask_b32_e64 v211, v0, v233, s[68:69]
		v_cndmask_b32_e64 v212, v0, v234, s[70:71]
		v_cndmask_b32_e64 v213, v0, v235, s[72:73]
		v_cndmask_b32_e64 v214, v0, v236, s[74:75]
		v_cndmask_b32_e64 v215, v0, v237, s[76:77]
		v_cndmask_b32_e64 v216, v0, v238, s[78:79]
		v_cndmask_b32_e32 v217, v0, v239, vcc
		v_max3_f32 v0, v24, v25, v26
		v_max3_f32 v21, v28, v29, v30
		v_max3_f32 v23, v32, v33, v36
		v_max3_f32 v218, v38, v39, v40
		v_max3_f32 v219, v42, v43, v44
		v_max3_f32 v220, v46, v47, v176
		v_max3_f32 v221, v178, v179, v180
		v_max3_f32 v222, v182, v183, v184
		v_max3_f32 v0, v0, v27, v21
		v_max3_f32 v21, v23, v37, v218
		v_max3_f32 v23, v219, v45, v220
		v_max3_f32 v218, v221, v181, v222
		v_max3_f32 v0, v0, v31, v21
		v_max3_f32 v21, v23, v177, v218
		v_max3_f32 v0, v0, v41, v21
		v_max_f32_e32 v0, v0, v185
		ds_bpermute_b32 v21, v4, v0
		ds_bpermute_b32 v23, v14, v0
		v_max3_f32 v0, v186, v187, v188
		v_max3_f32 v218, v190, v191, v192
		v_max3_f32 v219, v194, v195, v196
		v_max3_f32 v220, v198, v199, v200
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v222, v21, v23
		v_max3_f32 v21, v202, v203, v204
		v_max3_f32 v23, v206, v207, v208
		v_max3_f32 v221, v210, v211, v212
		v_max3_f32 v223, v214, v215, v216
		v_max3_f32 v0, v0, v189, v218
		v_max3_f32 v218, v219, v197, v220
		v_max3_f32 v21, v21, v205, v23
		v_max3_f32 v23, v221, v213, v223
		v_max3_f32 v0, v0, v193, v218
		v_max3_f32 v21, v21, v209, v23
		v_max3_f32 v0, v0, v201, v21
		v_max_f32_e32 v0, v0, v217
		ds_bpermute_b32 v21, v4, v0
		ds_bpermute_b32 v23, v14, v0
		v_pk_mul_f32 v[218:219], v[24:25], v[18:19]
		v_pk_mul_f32 v[24:25], v[26:27], v[18:19]
		v_pk_mul_f32 v[26:27], v[28:29], v[18:19]
		v_pk_mul_f32 v[28:29], v[30:31], v[18:19]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v223, v21, v23
		v_pk_mul_f32 v[30:31], v[222:223], v[18:19]
		v_max_f32_e32 v0, v20, v30
		v_max_f32_e32 v21, v22, v31
		v_pk_mul_f32 v[30:31], v[32:33], v[18:19]
		v_pk_mul_f32 v[32:33], v[36:37], v[18:19]
		v_pk_mul_f32 v[36:37], v[38:39], v[18:19]
		v_pk_mul_f32 v[38:39], v[40:41], v[18:19]
		v_pk_mul_f32 v[40:41], v[42:43], v[18:19]
		v_pk_mul_f32 v[42:43], v[44:45], v[18:19]
		v_pk_mul_f32 v[44:45], v[46:47], v[18:19]
		v_pk_mul_f32 v[46:47], v[176:177], v[18:19]
		v_pk_mul_f32 v[176:177], v[178:179], v[18:19]
		v_pk_mul_f32 v[178:179], v[180:181], v[18:19]
		v_pk_mul_f32 v[180:181], v[182:183], v[18:19]
		v_pk_mul_f32 v[182:183], v[184:185], v[18:19]
		v_pk_mul_f32 v[184:185], v[186:187], v[18:19]
		v_pk_mul_f32 v[186:187], v[188:189], v[18:19]
		v_pk_mul_f32 v[188:189], v[190:191], v[18:19]
		v_pk_mul_f32 v[190:191], v[192:193], v[18:19]
		v_pk_mul_f32 v[192:193], v[194:195], v[18:19]
		v_pk_mul_f32 v[194:195], v[196:197], v[18:19]
		v_pk_mul_f32 v[196:197], v[198:199], v[18:19]
		v_pk_mul_f32 v[198:199], v[200:201], v[18:19]
		v_pk_mul_f32 v[200:201], v[202:203], v[18:19]
		v_pk_mul_f32 v[202:203], v[204:205], v[18:19]
		v_pk_mul_f32 v[204:205], v[206:207], v[18:19]
		v_pk_mul_f32 v[206:207], v[208:209], v[18:19]
		v_pk_mul_f32 v[208:209], v[210:211], v[18:19]
		v_pk_mul_f32 v[210:211], v[212:213], v[18:19]
		v_pk_mul_f32 v[212:213], v[214:215], v[18:19]
		v_pk_mul_f32 v[214:215], v[216:217], v[18:19]
		v_sub_f32_e32 v18, v218, v0
		v_sub_f32_e32 v19, v219, v0
		v_sub_f32_e32 v23, v24, v0
		v_sub_f32_e32 v24, v25, v0
		v_sub_f32_e32 v25, v26, v0
		v_sub_f32_e32 v26, v27, v0
		v_sub_f32_e32 v27, v28, v0
		v_sub_f32_e32 v28, v29, v0
		v_sub_f32_e32 v29, v30, v0
		v_sub_f32_e32 v30, v31, v0
		v_sub_f32_e32 v31, v32, v0
		v_sub_f32_e32 v32, v33, v0
		v_sub_f32_e32 v33, v36, v0
		v_sub_f32_e32 v36, v37, v0
		v_sub_f32_e32 v37, v38, v0
		v_sub_f32_e32 v38, v39, v0
		v_sub_f32_e32 v39, v40, v0
		v_sub_f32_e32 v40, v41, v0
		v_sub_f32_e32 v41, v42, v0
		v_sub_f32_e32 v42, v43, v0
		v_sub_f32_e32 v43, v44, v0
		v_sub_f32_e32 v44, v45, v0
		v_sub_f32_e32 v45, v46, v0
		v_sub_f32_e32 v46, v47, v0
		v_sub_f32_e32 v47, v176, v0
		v_sub_f32_e32 v176, v177, v0
		v_sub_f32_e32 v177, v178, v0
		v_sub_f32_e32 v178, v179, v0
		v_sub_f32_e32 v179, v180, v0
		v_sub_f32_e32 v180, v181, v0
		v_sub_f32_e32 v181, v182, v0
		v_sub_f32_e32 v182, v183, v0
		v_sub_f32_e32 v183, v184, v21
		v_sub_f32_e32 v184, v185, v21
		v_sub_f32_e32 v185, v186, v21
		v_sub_f32_e32 v186, v187, v21
		v_sub_f32_e32 v187, v188, v21
		v_sub_f32_e32 v188, v189, v21
		v_sub_f32_e32 v189, v190, v21
		v_sub_f32_e32 v190, v191, v21
		v_sub_f32_e32 v191, v192, v21
		v_sub_f32_e32 v192, v193, v21
		v_sub_f32_e32 v193, v194, v21
		v_sub_f32_e32 v194, v195, v21
		v_sub_f32_e32 v195, v196, v21
		v_sub_f32_e32 v196, v197, v21
		v_sub_f32_e32 v197, v198, v21
		v_sub_f32_e32 v198, v199, v21
		v_sub_f32_e32 v199, v200, v21
		v_sub_f32_e32 v200, v201, v21
		v_sub_f32_e32 v201, v202, v21
		v_sub_f32_e32 v202, v203, v21
		v_sub_f32_e32 v203, v204, v21
		v_sub_f32_e32 v204, v205, v21
		v_sub_f32_e32 v205, v206, v21
		v_sub_f32_e32 v206, v207, v21
		v_sub_f32_e32 v207, v208, v21
		v_sub_f32_e32 v208, v209, v21
		v_sub_f32_e32 v209, v210, v21
		v_sub_f32_e32 v210, v211, v21
		v_sub_f32_e32 v211, v212, v21
		v_sub_f32_e32 v212, v213, v21
		v_sub_f32_e32 v213, v214, v21
		v_sub_f32_e32 v214, v215, v21
		v_exp_f32_e32 v216, v18
		v_exp_f32_e32 v218, v19
		v_exp_f32_e32 v217, v23
		v_exp_f32_e32 v219, v24
		v_exp_f32_e32 v18, v25
		v_exp_f32_e32 v24, v26
		v_exp_f32_e32 v19, v27
		v_exp_f32_e32 v25, v28
		v_exp_f32_e32 v26, v29
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v27, v31
		v_exp_f32_e32 v29, v32
		v_exp_f32_e32 v30, v33
		v_exp_f32_e32 v32, v36
		v_exp_f32_e32 v31, v37
		v_exp_f32_e32 v33, v38
		v_exp_f32_e32 v36, v39
		v_exp_f32_e32 v38, v40
		v_exp_f32_e32 v37, v41
		v_exp_f32_e32 v39, v42
		v_exp_f32_e32 v40, v43
		v_exp_f32_e32 v42, v44
		v_exp_f32_e32 v41, v45
		v_exp_f32_e32 v43, v46
		v_exp_f32_e32 v44, v47
		v_exp_f32_e32 v46, v176
		v_exp_f32_e32 v45, v177
		v_exp_f32_e32 v47, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v178, v180
		v_exp_f32_e32 v177, v181
		v_exp_f32_e32 v179, v182
		v_exp_f32_e32 v181, v183
		v_exp_f32_e32 v183, v184
		v_exp_f32_e32 v220, v185
		v_exp_f32_e32 v184, v186
		v_exp_f32_e32 v221, v187
		v_exp_f32_e32 v185, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v188, v190
		v_exp_f32_e32 v187, v191
		v_exp_f32_e32 v189, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v192, v194
		v_exp_f32_e32 v191, v195
		v_exp_f32_e32 v193, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v196, v198
		v_exp_f32_e32 v195, v199
		v_exp_f32_e32 v197, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v200, v202
		v_exp_f32_e32 v199, v203
		v_exp_f32_e32 v201, v204
		v_exp_f32_e32 v202, v205
		v_exp_f32_e32 v204, v206
		v_exp_f32_e32 v203, v207
		v_exp_f32_e32 v205, v208
		v_exp_f32_e32 v206, v209
		v_exp_f32_e32 v208, v210
		v_exp_f32_e32 v207, v211
		v_exp_f32_e32 v209, v212
		v_exp_f32_e32 v210, v213
		v_exp_f32_e32 v212, v214
		v_pk_add_f32 v[214:215], v[216:217], v[218:219]
		v_pk_add_f32 v[222:223], v[18:19], v[24:25]
		v_pk_add_f32 v[224:225], v[26:27], v[28:29]
		v_pk_add_f32 v[226:227], v[30:31], v[32:33]
		v_pk_add_f32 v[228:229], v[36:37], v[38:39]
		v_pk_add_f32 v[230:231], v[40:41], v[42:43]
		v_pk_add_f32 v[232:233], v[44:45], v[46:47]
		v_pk_add_f32 v[234:235], v[176:177], v[178:179]
		v_mov_b32_e32 v236, v215
		v_mov_b32_e32 v237, v223
		v_mov_b32_e32 v238, v214
		v_mov_b32_e32 v239, v222
		v_pk_add_f32 v[214:215], v[238:239], v[236:237]
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
		v_mov_b32_e32 v222, v215
		v_mov_b32_e32 v223, v225
		v_mov_b32_e32 v226, v214
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[214:215], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v215
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v214
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[214:215], v[224:225], v[222:223]
		v_add_f32_e32 v23, v214, v215
		ds_bpermute_b32 v180, v4, v23
		ds_bpermute_b32 v182, v14, v23
		v_pk_add_f32 v[214:215], v[220:221], v[184:185]
		v_pk_add_f32 v[222:223], v[186:187], v[188:189]
		v_pk_add_f32 v[224:225], v[190:191], v[192:193]
		v_pk_add_f32 v[226:227], v[194:195], v[196:197]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[228:229], v[180:181], v[182:183]
		v_pk_add_f32 v[230:231], v[198:199], v[200:201]
		v_pk_add_f32 v[232:233], v[202:203], v[204:205]
		v_pk_add_f32 v[234:235], v[206:207], v[208:209]
		v_mov_b32_e32 v211, v229
		v_mov_b32_e32 v213, v214
		v_pk_add_f32 v[236:237], v[210:211], v[212:213]
		v_mov_b32_e32 v238, v215
		v_mov_b32_e32 v239, v224
		v_pk_add_f32 v[214:215], v[238:239], v[222:223]
		v_mov_b32_e32 v222, v225
		v_mov_b32_e32 v223, v230
		v_pk_add_f32 v[222:223], v[222:223], v[226:227]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[226:227], v[224:225], v[232:233]
		v_mov_b32_e32 v224, v235
		v_mov_b32_e32 v225, v214
		v_pk_add_f32 v[224:225], v[224:225], v[236:237]
		v_mov_b32_e32 v230, v215
		v_mov_b32_e32 v231, v226
		v_pk_add_f32 v[214:215], v[230:231], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v214
		v_pk_add_f32 v[226:227], v[222:223], v[224:225]
		v_add_f32_e32 v23, v215, v226
		v_add_f32_e32 v23, v227, v23
		ds_bpermute_b32 v180, v4, v23
		ds_bpermute_b32 v4, v14, v23
		v_sub_f32_e32 v0, v20, v0
		v_sub_f32_e32 v14, v22, v21
		v_exp_f32_e32 v20, v0
		v_exp_f32_e32 v22, v14
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v215, v180, v4
		v_mov_b32_e32 v21, v20
		v_pk_mul_f32 v[240:241], v[48:49], v[20:21]
		v_pk_mul_f32 v[242:243], v[50:51], v[20:21]
		v_pk_mul_f32 v[244:245], v[52:53], v[20:21]
		v_pk_mul_f32 v[246:247], v[54:55], v[20:21]
		v_pk_mul_f32 v[248:249], v[56:57], v[20:21]
		v_pk_mul_f32 v[250:251], v[58:59], v[20:21]
		v_pk_mul_f32 v[252:253], v[60:61], v[20:21]
		v_pk_mul_f32 v[254:255], v[62:63], v[20:21]
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
		v_mov_b32_e32 v23, v22
		v_pk_mul_f32 v[96:97], v[112:113], v[22:23]
		v_pk_mul_f32 v[98:99], v[114:115], v[22:23]
		v_pk_mul_f32 v[100:101], v[116:117], v[22:23]
		v_pk_mul_f32 v[102:103], v[118:119], v[22:23]
		v_pk_mul_f32 v[104:105], v[120:121], v[22:23]
		v_pk_mul_f32 v[106:107], v[122:123], v[22:23]
		v_pk_mul_f32 v[108:109], v[124:125], v[22:23]
		v_pk_mul_f32 v[110:111], v[126:127], v[22:23]
		v_pk_mul_f32 v[112:113], v[128:129], v[22:23]
		v_pk_mul_f32 v[114:115], v[130:131], v[22:23]
		v_pk_mul_f32 v[116:117], v[132:133], v[22:23]
		v_pk_mul_f32 v[118:119], v[134:135], v[22:23]
		v_pk_mul_f32 v[120:121], v[136:137], v[22:23]
		v_pk_mul_f32 v[122:123], v[138:139], v[22:23]
		v_pk_mul_f32 v[124:125], v[140:141], v[22:23]
		v_pk_mul_f32 v[126:127], v[142:143], v[22:23]
		v_pk_mul_f32 v[128:129], v[144:145], v[22:23]
		v_pk_mul_f32 v[130:131], v[146:147], v[22:23]
		v_pk_mul_f32 v[132:133], v[148:149], v[22:23]
		v_pk_mul_f32 v[134:135], v[150:151], v[22:23]
		v_pk_mul_f32 v[136:137], v[152:153], v[22:23]
		v_pk_mul_f32 v[138:139], v[154:155], v[22:23]
		v_pk_mul_f32 v[140:141], v[156:157], v[22:23]
		v_pk_mul_f32 v[142:143], v[158:159], v[22:23]
		v_pk_mul_f32 v[144:145], v[160:161], v[22:23]
		v_pk_mul_f32 v[146:147], v[162:163], v[22:23]
		v_pk_mul_f32 v[148:149], v[164:165], v[22:23]
		v_pk_mul_f32 v[150:151], v[166:167], v[22:23]
		v_pk_mul_f32 v[152:153], v[168:169], v[22:23]
		v_pk_mul_f32 v[154:155], v[170:171], v[22:23]
		v_pk_mul_f32 v[156:157], v[172:173], v[22:23]
		v_pk_mul_f32 v[158:159], v[174:175], v[22:23]
		v_mov_b32_e32 v214, v228
		v_mov_b32_e32 v160, v20
		v_mov_b32_e32 v161, v22
		v_pk_fma_f32 v[20:21], v[34:35], v[160:161], v[214:215]
		v_cvt_pk_bf16_f32 v160, v216, v218
		v_cvt_pk_bf16_f32 v161, v217, v219
		v_cvt_pk_bf16_f32 v162, v18, v24
		v_cvt_pk_bf16_f32 v163, v19, v25
		v_cvt_pk_bf16_f32 v164, v26, v28
		v_cvt_pk_bf16_f32 v165, v27, v29
		v_cvt_pk_bf16_f32 v166, v30, v32
		v_cvt_pk_bf16_f32 v167, v31, v33
		v_cvt_pk_bf16_f32 v24, v36, v38
		v_cvt_pk_bf16_f32 v25, v37, v39
		v_cvt_pk_bf16_f32 v26, v40, v42
		v_cvt_pk_bf16_f32 v27, v41, v43
		v_cvt_pk_bf16_f32 v28, v44, v46
		v_cvt_pk_bf16_f32 v29, v45, v47
		v_cvt_pk_bf16_f32 v30, v176, v178
		v_cvt_pk_bf16_f32 v31, v177, v179
		v_cvt_pk_bf16_f32 v32, v181, v183
		v_cvt_pk_bf16_f32 v33, v220, v184
		v_cvt_pk_bf16_f32 v34, v221, v185
		v_cvt_pk_bf16_f32 v35, v186, v188
		v_cvt_pk_bf16_f32 v36, v187, v189
		v_cvt_pk_bf16_f32 v37, v190, v192
		v_cvt_pk_bf16_f32 v38, v191, v193
		v_cvt_pk_bf16_f32 v39, v194, v196
		v_cvt_pk_bf16_f32 v40, v195, v197
		v_cvt_pk_bf16_f32 v41, v198, v200
		v_cvt_pk_bf16_f32 v42, v199, v201
		v_cvt_pk_bf16_f32 v43, v202, v204
		v_cvt_pk_bf16_f32 v44, v203, v205
		v_cvt_pk_bf16_f32 v45, v206, v208
		v_cvt_pk_bf16_f32 v46, v207, v209
		v_cvt_pk_bf16_f32 v47, v210, v212
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[240:255], a[104:107], v[160:163], v[240:255]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[160:163], v[48:63]
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_rcp_f32_e32 v18, v20
		v_rcp_f32_e32 v22, v21
		s_mov_b32 s1, 0x80
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[160:163], v[64:79]
		v_cmp_lt_i32_e64 vcc, v1, s1
		s_mov_b64 s[2:3], vcc
		s_and_b32 s8, s26, s2
		s_and_b32 s9, s27, s3
		v_cmp_lt_i32_e64 vcc, v5, s1
		s_mov_b64 s[10:11], vcc
		s_and_b32 s12, s26, s10
		s_and_b32 s13, s27, s11
		v_cmp_lt_i32_e64 vcc, v6, s1
		s_mov_b64 s[14:15], vcc
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[160:163], v[80:95]
		s_and_b32 s18, s26, s14
		s_and_b32 s19, s27, s15
		v_cmp_lt_i32_e64 vcc, v7, s1
		s_mov_b64 s[24:25], vcc
		s_and_b32 s30, s26, s24
		s_and_b32 s31, s27, s25
		v_cmp_lt_i32_e64 vcc, v10, s1
		s_mov_b64 s[32:33], vcc
		s_and_b32 s34, s26, s32
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[32:35], v[144:159]
		s_and_b32 s35, s27, s33
		v_cmp_lt_i32_e64 vcc, v12, s1
		s_mov_b64 s[36:37], vcc
		s_and_b32 s38, s26, s36
		s_and_b32 s39, s27, s37
		v_cmp_lt_i32_e64 vcc, v16, s1
		s_mov_b64 s[40:41], vcc
		s_and_b32 s42, s26, s40
		s_and_b32 s43, s27, s41
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], v[32:35], v[96:111]
		v_cmp_lt_i32_e64 vcc, v17, s1
		s_mov_b64 s[44:45], vcc
		s_and_b32 s46, s26, s44
		s_and_b32 s47, s27, s45
		s_and_b32 s26, s28, s2
		s_and_b32 s27, s29, s3
		s_and_b32 s2, s28, s10
		s_and_b32 s3, s29, s11
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[32:35], v[112:127]
		s_and_b32 s10, s28, s14
		s_and_b32 s11, s29, s15
		s_and_b32 s14, s28, s24
		s_and_b32 s15, s29, s25
		s_and_b32 s24, s28, s32
		s_and_b32 s25, s29, s33
		s_and_b32 s32, s28, s36
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[32:35], v[128:143]
		s_and_b32 s33, s29, s37
		s_and_b32 s36, s28, s40
		s_and_b32 s37, s29, s41
		s_and_b32 s40, s28, s44
		s_and_b32 s41, s29, s45
		s_mul_i32 s1, s16, s23
		s_lshl_b32 s1, s1, 9
		v_mfma_f32_32x32x16_bf16 v[240:255], a[108:111], v[164:167], v[240:255]
		s_mul_i32 s16, s17, s21
		s_lshl_b32 s16, s16, 1
		s_add_i32 s17, s1, s16
		s_mul_i32 s0, s0, s22
		s_lshl_b32 s0, s0, 1
		s_add_i32 s17, s17, s0
		v_mul_lo_u32 v0, s23, v13
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[164:167], v[48:63]
		v_lshl_add_u32 v1, v0, 6, s17
		v_mul_lo_u32 v4, s23, v11
		v_lshl_add_u32 v1, v4, 1, v1
		v_mul_lo_u32 v5, s23, v9
		v_lshl_add_u32 v1, v5, 5, v1
		v_mul_lo_u32 v6, s23, v8
		v_lshl_add_u32 v1, v6, 4, v1
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[164:167], v[64:79]
		v_mul_lo_u32 v7, s23, v15
		v_lshl_add_u32 v1, v7, 3, v1
		v_mul_lo_u32 v3, s23, v3
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[112:115], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], v[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[112:115], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], v[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], v[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[116:119], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], v[44:47], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[116:119], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], v[44:47], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], v[44:47], v[128:143]
		v_mov_b32_e32 v19, v18
		s_nop 3
		v_pk_mul_f32 v[8:9], v[240:241], v[18:19]
		v_pk_mul_f32 v[10:11], v[242:243], v[18:19]
		v_pk_mul_f32 v[12:13], v[244:245], v[18:19]
		v_pk_mul_f32 v[14:15], v[246:247], v[18:19]
		v_pk_mul_f32 v[16:17], v[248:249], v[18:19]
		v_pk_mul_f32 v[20:21], v[250:251], v[18:19]
		v_pk_mul_f32 v[24:25], v[252:253], v[18:19]
		v_pk_mul_f32 v[26:27], v[254:255], v[18:19]
		v_pk_mul_f32 v[28:29], v[48:49], v[18:19]
		v_pk_mul_f32 v[30:31], v[50:51], v[18:19]
		v_pk_mul_f32 v[32:33], v[52:53], v[18:19]
		v_pk_mul_f32 v[34:35], v[54:55], v[18:19]
		v_pk_mul_f32 v[36:37], v[56:57], v[18:19]
		v_pk_mul_f32 v[38:39], v[58:59], v[18:19]
		v_pk_mul_f32 v[40:41], v[60:61], v[18:19]
		v_pk_mul_f32 v[42:43], v[62:63], v[18:19]
		v_pk_mul_f32 v[44:45], v[64:65], v[18:19]
		v_pk_mul_f32 v[46:47], v[66:67], v[18:19]
		v_pk_mul_f32 v[48:49], v[68:69], v[18:19]
		v_pk_mul_f32 v[50:51], v[70:71], v[18:19]
		v_pk_mul_f32 v[52:53], v[72:73], v[18:19]
		v_pk_mul_f32 v[54:55], v[74:75], v[18:19]
		v_pk_mul_f32 v[56:57], v[76:77], v[18:19]
		v_pk_mul_f32 v[58:59], v[78:79], v[18:19]
		v_pk_mul_f32 v[60:61], v[80:81], v[18:19]
		v_pk_mul_f32 v[62:63], v[82:83], v[18:19]
		v_pk_mul_f32 v[64:65], v[84:85], v[18:19]
		v_pk_mul_f32 v[66:67], v[86:87], v[18:19]
		v_pk_mul_f32 v[68:69], v[88:89], v[18:19]
		v_pk_mul_f32 v[70:71], v[90:91], v[18:19]
		v_pk_mul_f32 v[72:73], v[92:93], v[18:19]
		v_pk_mul_f32 v[74:75], v[94:95], v[18:19]
		v_mov_b32_e32 v23, v22
		v_pk_mul_f32 v[18:19], v[96:97], v[22:23]
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
		v_cvt_pk_bf16_f32 v140, v8, v9
		v_cvt_pk_bf16_f32 v141, v10, v11
		v_cvt_pk_bf16_f32 v142, v12, v13
		v_cvt_pk_bf16_f32 v143, v14, v15
		v_cvt_pk_bf16_f32 v8, v16, v17
		v_cvt_pk_bf16_f32 v9, v20, v21
		v_cvt_pk_bf16_f32 v10, v24, v25
		v_cvt_pk_bf16_f32 v11, v26, v27
		v_cvt_pk_bf16_f32 v12, v28, v29
		v_cvt_pk_bf16_f32 v13, v30, v31
		v_cvt_pk_bf16_f32 v14, v32, v33
		v_cvt_pk_bf16_f32 v15, v34, v35
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
		v_cvt_pk_bf16_f32 v40, v18, v19
		v_cvt_pk_bf16_f32 v41, v76, v77
		v_cvt_pk_bf16_f32 v42, v78, v79
		v_cvt_pk_bf16_f32 v43, v80, v81
		v_cvt_pk_bf16_f32 v16, v82, v83
		v_cvt_pk_bf16_f32 v17, v84, v85
		v_cvt_pk_bf16_f32 v18, v86, v87
		v_cvt_pk_bf16_f32 v19, v88, v89
		v_cvt_pk_bf16_f32 v44, v90, v91
		v_cvt_pk_bf16_f32 v45, v92, v93
		v_cvt_pk_bf16_f32 v46, v94, v95
		v_cvt_pk_bf16_f32 v47, v96, v97
		v_cvt_pk_bf16_f32 v48, v98, v99
		v_cvt_pk_bf16_f32 v49, v100, v101
		v_cvt_pk_bf16_f32 v50, v102, v103
		v_cvt_pk_bf16_f32 v51, v104, v105
		v_cvt_pk_bf16_f32 v52, v106, v107
		v_cvt_pk_bf16_f32 v53, v108, v109
		v_cvt_pk_bf16_f32 v54, v110, v111
		v_cvt_pk_bf16_f32 v55, v112, v113
		v_cvt_pk_bf16_f32 v56, v114, v115
		v_cvt_pk_bf16_f32 v57, v116, v117
		v_cvt_pk_bf16_f32 v58, v118, v119
		v_cvt_pk_bf16_f32 v59, v120, v121
		v_cvt_pk_bf16_f32 v60, v122, v123
		v_cvt_pk_bf16_f32 v61, v124, v125
		v_cvt_pk_bf16_f32 v62, v126, v127
		v_cvt_pk_bf16_f32 v63, v128, v129
		v_cvt_pk_bf16_f32 v64, v130, v131
		v_cvt_pk_bf16_f32 v65, v132, v133
		v_cvt_pk_bf16_f32 v66, v134, v135
		v_cvt_pk_bf16_f32 v67, v136, v137
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
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
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
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
		s_and_saveexec_b64 s[82:83], s[8:9]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_16
		buffer_store_dwordx4 v[140:143], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_16:
		s_andn2_b64 exec, s[82:83], s[8:9]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_16
.L_attn_fwd_async_prefetch.exec_endif_16:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s8, s1, 32
		s_add_i32 s8, s8, s16
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_17
		buffer_store_dwordx4 v[8:11], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_17:
		s_andn2_b64 exec, s[82:83], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_17
.L_attn_fwd_async_prefetch.exec_endif_17:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s8, s1, 64
		s_add_i32 s8, s8, s16
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[18:19]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_18
		buffer_store_dwordx4 v[12:15], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_18:
		s_andn2_b64 exec, s[82:83], s[18:19]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_18
.L_attn_fwd_async_prefetch.exec_endif_18:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s8, s1, 0x60
		s_add_i32 s8, s8, s16
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_19
		buffer_store_dwordx4 v[20:23], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_19:
		s_andn2_b64 exec, s[82:83], s[30:31]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_19
.L_attn_fwd_async_prefetch.exec_endif_19:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s8, s1, 0x80
		s_add_i32 s8, s8, s16
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_20
		buffer_store_dwordx4 v[24:27], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_20:
		s_andn2_b64 exec, s[82:83], s[34:35]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_20
.L_attn_fwd_async_prefetch.exec_endif_20:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s8, s1, 0xa0
		s_add_i32 s8, s8, s16
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_21
		buffer_store_dwordx4 v[28:31], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_21:
		s_andn2_b64 exec, s[82:83], s[38:39]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_21
.L_attn_fwd_async_prefetch.exec_endif_21:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s8, s1, 0xc0
		s_add_i32 s8, s8, s16
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_22
		buffer_store_dwordx4 v[32:35], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_22:
		s_andn2_b64 exec, s[82:83], s[42:43]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_22
.L_attn_fwd_async_prefetch.exec_endif_22:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s8, s1, 0xe0
		s_add_i32 s8, s8, s16
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_23
		buffer_store_dwordx4 v[36:39], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_23:
		s_andn2_b64 exec, s[82:83], s[46:47]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_23
.L_attn_fwd_async_prefetch.exec_endif_23:
		s_mov_b64 exec, s[82:83]
		s_lshl_b32 s8, s23, 8
		s_add_i32 s9, s8, s1
		s_add_i32 s9, s9, s16
		s_add_i32 s9, s9, s0
		v_lshl_add_u32 v1, v0, 6, s9
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_24
		buffer_store_dwordx4 v[40:43], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_24:
		s_andn2_b64 exec, s[82:83], s[26:27]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_24
.L_attn_fwd_async_prefetch.exec_endif_24:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s9, s8, 32
		s_add_i32 s9, s9, s1
		s_add_i32 s9, s9, s16
		s_add_i32 s9, s9, s0
		v_lshl_add_u32 v1, v0, 6, s9
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_25
		buffer_store_dwordx4 v[16:19], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_25:
		s_andn2_b64 exec, s[82:83], s[2:3]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_25
.L_attn_fwd_async_prefetch.exec_endif_25:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s2, s8, 64
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s16
		s_add_i32 s2, s2, s0
		v_lshl_add_u32 v1, v0, 6, s2
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_26
		buffer_store_dwordx4 v[44:47], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_26:
		s_andn2_b64 exec, s[82:83], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_26
.L_attn_fwd_async_prefetch.exec_endif_26:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s2, s8, 0x60
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s16
		s_add_i32 s2, s2, s0
		v_lshl_add_u32 v1, v0, 6, s2
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[14:15]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_27
		buffer_store_dwordx4 v[48:51], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_27:
		s_andn2_b64 exec, s[82:83], s[14:15]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_27
.L_attn_fwd_async_prefetch.exec_endif_27:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s2, s8, 0x80
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s16
		s_add_i32 s2, s2, s0
		v_lshl_add_u32 v1, v0, 6, s2
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[24:25]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_28
		buffer_store_dwordx4 v[52:55], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_28:
		s_andn2_b64 exec, s[82:83], s[24:25]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_28
.L_attn_fwd_async_prefetch.exec_endif_28:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s2, s8, 0xa0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s16
		s_add_i32 s2, s2, s0
		v_lshl_add_u32 v1, v0, 6, s2
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_29
		buffer_store_dwordx4 v[56:59], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_29:
		s_andn2_b64 exec, s[82:83], s[32:33]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_29
.L_attn_fwd_async_prefetch.exec_endif_29:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s2, s8, 0xc0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s16
		s_add_i32 s2, s2, s0
		v_lshl_add_u32 v1, v0, 6, s2
		v_lshl_add_u32 v1, v4, 1, v1
		v_lshl_add_u32 v1, v5, 5, v1
		v_lshl_add_u32 v1, v6, 4, v1
		v_lshl_add_u32 v1, v7, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[82:83], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_30
		buffer_store_dwordx4 v[60:63], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_30:
		s_andn2_b64 exec, s[82:83], s[36:37]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_30
.L_attn_fwd_async_prefetch.exec_endif_30:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s2, s8, 0xe0
		s_add_i32 s1, s2, s1
		s_add_i32 s1, s1, s16
		s_add_i32 s0, s1, s0
		v_lshl_add_u32 v0, v0, 6, s0
		v_lshl_add_u32 v0, v4, 1, v0
		v_lshl_add_u32 v0, v5, 5, v0
		v_lshl_add_u32 v0, v6, 4, v0
		v_lshl_add_u32 v0, v7, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v2, 4, v0
		s_and_saveexec_b64 s[82:83], s[40:41]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_31
		buffer_store_dwordx4 v[64:67], v0, s[4:7], 0 offen
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
		.amdhsa_next_free_vgpr 424
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
	.set .L_attn_fwd_async_prefetch.num_agpr, 168
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
    .vgpr_count:     424
    .agpr_count:     168
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 69
    wave.regalloc.agpr.dwords: 272
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
