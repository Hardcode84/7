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
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		v_and_b32_e32 v1, 0xffff, v1
		v_lshlrev_b32_e32 v11, 16, v1
		v_or_b32_e32 v36, v1, v11
		v_mov_b32_e32 v37, v36
		v_mov_b32_e32 v38, v36
		v_mov_b32_e32 v39, v36
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
		v_and_b32_e32 v20, 1, v4
		v_lshl_add_u32 v11, v20, 6, v11
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v19, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_0
		buffer_load_dwordx4 v[40:43], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_0:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_0
		v_mov_b32_e32 v40, v36
		v_mov_b32_e32 v41, v37
		v_mov_b32_e32 v42, v38
		v_mov_b32_e32 v43, v39
.L_attn_fwd_async_prefetch.exec_endif_0:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s10, s12, 5
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v21, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_1
		buffer_load_dwordx4 v[44:47], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_1:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_1
		v_mov_b32_e32 v44, v36
		v_mov_b32_e32 v45, v37
		v_mov_b32_e32 v46, v38
		v_mov_b32_e32 v47, v39
.L_attn_fwd_async_prefetch.exec_endif_1:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s10, s12, 6
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_2
		buffer_load_dwordx4 v[48:51], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_2:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_2
		v_mov_b32_e32 v48, v36
		v_mov_b32_e32 v49, v37
		v_mov_b32_e32 v50, v38
		v_mov_b32_e32 v51, v39
.L_attn_fwd_async_prefetch.exec_endif_2:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0x60, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v23, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_3
		buffer_load_dwordx4 v[52:55], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_3:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_3
		v_mov_b32_e32 v52, v36
		v_mov_b32_e32 v53, v37
		v_mov_b32_e32 v54, v38
		v_mov_b32_e32 v55, v39
.L_attn_fwd_async_prefetch.exec_endif_3:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s10, s12, 7
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v24, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_4
		buffer_load_dwordx4 v[56:59], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_4:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_4
		v_mov_b32_e32 v56, v36
		v_mov_b32_e32 v57, v37
		v_mov_b32_e32 v58, v38
		v_mov_b32_e32 v59, v39
.L_attn_fwd_async_prefetch.exec_endif_4:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0xa0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v25, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_5
		buffer_load_dwordx4 v[60:63], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_5:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_5
		v_mov_b32_e32 v60, v36
		v_mov_b32_e32 v61, v37
		v_mov_b32_e32 v62, v38
		v_mov_b32_e32 v63, v39
.L_attn_fwd_async_prefetch.exec_endif_5:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0xc0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v26, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_6
		buffer_load_dwordx4 v[64:67], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_6:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_6
		v_mov_b32_e32 v64, v36
		v_mov_b32_e32 v65, v37
		v_mov_b32_e32 v66, v38
		v_mov_b32_e32 v67, v39
.L_attn_fwd_async_prefetch.exec_endif_6:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0xe0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v27, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_7
		buffer_load_dwordx4 v[24:27], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_7:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_7
		v_mov_b32_e32 v24, v36
		v_mov_b32_e32 v25, v37
		v_mov_b32_e32 v26, v38
		v_mov_b32_e32 v27, v39
.L_attn_fwd_async_prefetch.exec_endif_7:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s10, s12, 8
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v28, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_8
		buffer_load_dwordx4 v[68:71], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_8:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_8
		v_mov_b32_e32 v68, v36
		v_mov_b32_e32 v69, v37
		v_mov_b32_e32 v70, v38
		v_mov_b32_e32 v71, v39
.L_attn_fwd_async_prefetch.exec_endif_8:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0x120, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v29, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_9
		buffer_load_dwordx4 v[72:75], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_9:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_9
		v_mov_b32_e32 v72, v36
		v_mov_b32_e32 v73, v37
		v_mov_b32_e32 v74, v38
		v_mov_b32_e32 v75, v39
.L_attn_fwd_async_prefetch.exec_endif_9:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0x140, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v30, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_10
		buffer_load_dwordx4 v[76:79], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_10:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_10
		v_mov_b32_e32 v76, v36
		v_mov_b32_e32 v77, v37
		v_mov_b32_e32 v78, v38
		v_mov_b32_e32 v79, v39
.L_attn_fwd_async_prefetch.exec_endif_10:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0x160, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v31, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_11
		buffer_load_dwordx4 v[28:31], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_11:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_11
		v_mov_b32_e32 v28, v36
		v_mov_b32_e32 v29, v37
		v_mov_b32_e32 v30, v38
		v_mov_b32_e32 v31, v39
.L_attn_fwd_async_prefetch.exec_endif_11:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0x180, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v32, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_12
		buffer_load_dwordx4 v[80:83], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_12:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_12
		v_mov_b32_e32 v80, v36
		v_mov_b32_e32 v81, v37
		v_mov_b32_e32 v82, v38
		v_mov_b32_e32 v83, v39
.L_attn_fwd_async_prefetch.exec_endif_12:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0x1a0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v33, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_13
		buffer_load_dwordx4 v[84:87], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_13:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_13
		v_mov_b32_e32 v84, v36
		v_mov_b32_e32 v85, v37
		v_mov_b32_e32 v86, v38
		v_mov_b32_e32 v87, v39
.L_attn_fwd_async_prefetch.exec_endif_13:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0x1c0, s12
		s_add_i32 s10, s10, s2
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s11
		v_lshl_add_u32 v11, v1, 1, s10
		v_lshl_add_u32 v11, v15, 4, v11
		v_lshl_add_u32 v11, v8, 7, v11
		v_lshl_add_u32 v11, v20, 6, v11
		v_lshl_add_u32 v11, v3, 5, v11
		v_cmp_lt_i32_e64 vcc, v34, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_14
		buffer_load_dwordx4 v[32:35], v11, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_14:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_14
		v_mov_b32_e32 v32, v36
		v_mov_b32_e32 v33, v37
		v_mov_b32_e32 v34, v38
		v_mov_b32_e32 v35, v39
.L_attn_fwd_async_prefetch.exec_endif_14:
		s_mov_b64 exec, s[48:49]
		s_mul_i32 s10, 0x1e0, s12
		s_add_i32 s2, s10, s2
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s11
		v_lshl_add_u32 v1, v1, 1, s2
		v_lshl_add_u32 v1, v15, 4, v1
		v_lshl_add_u32 v1, v8, 7, v1
		v_lshl_add_u32 v1, v20, 6, v1
		v_lshl_add_u32 v1, v3, 5, v1
		v_cmp_lt_i32_e64 vcc, v10, s25
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_15
		buffer_load_dwordx4 v[88:91], v1, s[28:31], 0 offen
.L_attn_fwd_async_prefetch.exec_else_15:
		s_andn2_b64 exec, s[48:49], vcc
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_15
		v_mov_b32_e32 v88, v36
		v_mov_b32_e32 v89, v37
		v_mov_b32_e32 v90, v38
		v_mov_b32_e32 v91, v39
.L_attn_fwd_async_prefetch.exec_endif_15:
		s_mov_b64 exec, s[48:49]
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		s_mov_b32 s36, s6
		s_mov_b32 s37, s7
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		v_lshlrev_b32_e32 v1, 3, v16
		v_and_b32_e32 v10, 1, v13
		v_lshlrev_b32_e32 v10, 2, v10
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v11, 1, v5
		v_and_b32_e32 v9, 1, v9
		v_bitop3_b32 v11, v11, v0, v9 bitop3:0x96
		v_bitop3_b32 v1, v1, v10, v11 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		s_waitcnt vmcnt(0)
		ds_write_b128 v1, v[40:43] offset:2480
		ds_write_b128 v1, v[44:47] offset:6576
		ds_write_b128 v1, v[48:51] offset:10672
		ds_write_b128 v1, v[52:55] offset:14768
		ds_write_b128 v1, v[56:59] offset:18864
		ds_write_b128 v1, v[60:63] offset:22960
		ds_write_b128 v1, v[64:67] offset:27056
		ds_write_b128 v1, v[24:27] offset:31152
		v_lshlrev_b32_e32 v10, 13, v13
		v_add_u32_e32 v10, 0x10000, v10
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v16, 4, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v16, 1, v16
		v_lshl_add_u32 v10, v16, 12, v10
		v_lshrrev_b32_e32 v16, 3, v11
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v19, 7, v16
		v_add_u32_e32 v21, v10, v19
		v_lshrrev_b32_e32 v22, 2, v11
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v23, 6, v22
		v_add_u32_e32 v24, v21, v23
		v_lshrrev_b32_e32 v25, 1, v11
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v26, 5, v25
		v_add_u32_e32 v27, v24, v26
		v_lshrrev_b32_e32 v36, 5, v11
		v_and_b32_e32 v37, 1, v11
		v_lshlrev_b32_e32 v38, 4, v37
		v_add3_u32 v39, v36, v19, v23
		v_add3_u32 v39, v39, v26, v38
		v_xor_b32_e32 v40, v39, v37
		v_lshl_add_u32 v27, v40, 4, v27
		ds_read_b128 a[0:3], v27 offset:2480
		v_lshlrev_b32_e32 v25, 1, v25
		v_add_u32_e32 v40, 2, v39
		v_bitop3_b32 v40, v25, v40, v37 bitop3:0x96
		v_lshl_add_u32 v24, v40, 4, v24
		ds_read_b128 a[4:7], v24 offset:2480
		v_add_u32_e32 v39, 4, v39
		v_xad_u32 v39, v39, v37, v25
		v_lshlrev_b32_e32 v22, 2, v22
		v_xor_b32_e32 v39, v39, v22
		v_lshl_add_u32 v39, v39, 4, v21
		ds_read_b128 a[8:11], v39 offset:2480
		v_add_u32_e32 v40, 6, v36
		v_add3_u32 v40, v40, v19, v23
		v_add3_u32 v40, v40, v26, v38
		v_xor_b32_e32 v40, v40, v37
		v_bitop3_b32 v40, v22, v25, v40 bitop3:0x96
		v_lshl_add_u32 v21, v40, 4, v21
		ds_read_b128 a[12:15], v21 offset:2480
		v_add_u32_e32 v40, 8, v36
		v_add3_u32 v40, v40, v19, v23
		v_add3_u32 v40, v40, v26, v38
		v_xor_b32_e32 v40, v40, v37
		v_add3_u32 v40, v22, v25, v40
		v_lshlrev_b32_e32 v16, 3, v16
		v_xor_b32_e32 v40, v40, v16
		v_lshl_add_u32 v40, v40, 4, v10
		ds_read_b128 a[16:19], v40 offset:2480
		v_add_u32_e32 v41, 10, v36
		v_add3_u32 v41, v41, v19, v23
		v_add3_u32 v41, v41, v26, v38
		v_xor_b32_e32 v41, v41, v37
		v_xad_u32 v41, v25, v41, v22
		v_xor_b32_e32 v41, v41, v16
		v_lshl_add_u32 v41, v41, 4, v10
		ds_read_b128 a[20:23], v41 offset:2480
		v_add_u32_e32 v42, 12, v36
		v_add3_u32 v42, v42, v19, v23
		v_add3_u32 v42, v42, v26, v38
		v_xad_u32 v42, v42, v37, v25
		v_bitop3_b32 v42, v16, v42, v22 bitop3:0x96
		v_lshl_add_u32 v42, v42, 4, v10
		ds_read_b128 a[24:27], v42 offset:2480
		v_add_u32_e32 v43, 14, v36
		v_add3_u32 v19, v43, v19, v23
		v_add3_u32 v19, v19, v26, v38
		v_bitop3_b32 v19, v25, v19, v37 bitop3:0x96
		v_bitop3_b32 v16, v16, v22, v19 bitop3:0x96
		v_lshl_add_u32 v10, v16, 4, v10
		ds_read_b128 a[28:31], v10 offset:2480
		s_mov_b32 s2, 63
		v_mov_b32_e32 v16, 32
		v_mul_lo_u32 v16, v16, v7
		v_bitop3_b32 v19, v12, v16, v14 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[68:71] offset:2480
		ds_write_b128 v1, v[72:75] offset:6576
		ds_write_b128 v1, v[76:79] offset:10672
		ds_write_b128 v1, v[28:31] offset:14768
		ds_write_b128 v1, v[80:83] offset:18864
		ds_write_b128 v1, v[84:87] offset:22960
		ds_write_b128 v1, v[32:35] offset:27056
		ds_write_b128 v1, v[88:91] offset:31152
		v_mov_b32_e32 v1, 2
		v_mul_lo_u32 v1, v1, v17
		v_xor_b32_e32 v17, v19, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[32:35], v27 offset:2480
		ds_read_b128 a[36:39], v24 offset:2480
		ds_read_b128 a[40:43], v39 offset:2480
		ds_read_b128 a[44:47], v21 offset:2480
		ds_read_b128 a[48:51], v40 offset:2480
		ds_read_b128 a[52:55], v41 offset:2480
		ds_read_b128 a[56:59], v42 offset:2480
		ds_read_b128 a[60:63], v10 offset:2480
		s_add_i32 s3, s25, 63
		s_cmp_lt_i32 s3, 0
		s_cselect_b32 s2, s2, 0
		s_add_i32 s2, s3, s2
		s_ashr_i32 s2, s2, 6
		s_add_i32 s2, s2, -1
		s_cmp_gt_i32 s2, 0
		s_cselect_b32 s2, s2, 0
		v_cmp_lt_i32_e64 vcc, v17, s25
		v_readfirstlane_b32 s3, v0
		v_mul_lo_u32 v10, s15, v13
		v_mul_lo_u32 v19, s15, v5
		v_lshlrev_b32_e32 v19, 6, v19
		v_lshl_add_u32 v10, v10, 1, v19
		v_mul_lo_u32 v19, s15, v9
		v_lshl_add_u32 v10, v19, 5, v10
		v_lshlrev_b32_e32 v19, 4, v15
		v_lshlrev_b32_e32 v21, 7, v8
		v_add3_u32 v10, v10, v19, v21
		v_lshlrev_b32_e32 v22, 6, v20
		v_lshlrev_b32_e32 v23, 5, v3
		v_add3_u32 v10, v10, v22, v23
		s_mul_i32 s4, s17, s13
		s_lshl_b32 s4, s4, 1
		s_mul_i32 s5, s0, s14
		s_lshl_b32 s5, s5, 1
		s_add_i32 s6, s4, s5
		v_add_u32_e32 v24, s6, v10
		v_mov_b32_e32 v25, 0x80000000
		v_cndmask_b32_e32 v24, v25, v24, vcc
		s_lshr_b32 s3, s3, 6
		s_mul_i32 s6, 0x410, s3
		s_mov_b32 m0, s6
		v_xad_u32 v6, v6, v18, s1
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		s_lshl_b32 s7, s15, 3
		s_add_i32 s7, s7, s4
		s_add_i32 s7, s7, s5
		v_add_u32_e32 v24, s7, v10
		v_cndmask_b32_e32 v24, v25, v24, vcc
		s_add_i32 m0, m0, 0x1040
		v_xad_u32 v2, v2, v18, s1
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		s_lshl_b32 s1, s15, 4
		s_add_i32 s1, s1, s4
		s_add_i32 s1, s1, s5
		v_add_u32_e32 v18, s1, v10
		v_cndmask_b32_e32 v18, v25, v18, vcc
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v24, 4, v12, v16 bitop3:0x96
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_mul_i32 s1, 24, s15
		s_add_i32 s1, s1, s4
		s_add_i32 s1, s1, s5
		v_add_u32_e32 v18, s1, v10
		v_cndmask_b32_e32 v18, v25, v18, vcc
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v26, 8, v12, v16 bitop3:0x96
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		v_bitop3_b32 v18, v26, v14, v1 bitop3:0x96
		v_mul_lo_u32 v26, s20, v13
		v_mul_lo_u32 v27, s20, v5
		v_lshlrev_b32_e32 v27, 6, v27
		v_lshl_add_u32 v26, v26, 1, v27
		v_mul_lo_u32 v27, s20, v9
		v_lshl_add_u32 v26, v27, 5, v26
		v_add3_u32 v19, v26, v19, v21
		v_add3_u32 v19, v19, v22, v23
		s_mul_i32 s1, s17, s18
		s_lshl_b32 s1, s1, 1
		s_mul_i32 s7, s0, s19
		s_lshl_b32 s7, s7, 1
		s_add_i32 s10, s1, s7
		v_add_u32_e32 v21, s10, v19
		v_cndmask_b32_e32 v21, v25, v21, vcc
		s_mul_i32 s3, 0x440, s3
		s_add_i32 m0, s3, 0x81f0
		v_bitop3_b32 v12, 12, v12, v16 bitop3:0x96
		buffer_load_dwordx4 v21, s[36:39], 0 offen lds
		v_bitop3_b32 v12, v12, v14, v1 bitop3:0x96
		s_lshl_b32 s10, s20, 3
		s_add_i32 s10, s10, s1
		s_add_i32 s10, s10, s7
		v_add_u32_e32 v16, s10, v19
		v_cndmask_b32_e32 v16, v25, v16, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[10:11], v6, s25
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_lshl_b32 s12, s20, 4
		s_add_i32 s12, s12, s1
		s_add_i32 s12, s12, s7
		v_add_u32_e32 v6, s12, v19
		v_cndmask_b32_e32 v6, v25, v6, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[12:13], v2, s25
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_mul_i32 s14, 24, s20
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s7
		v_add_u32_e32 v2, s14, v19
		v_cndmask_b32_e32 v2, v25, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v1, v24, v14, v1 bitop3:0x96
		buffer_load_dwordx4 v2, s[36:39], 0 offen lds
		s_mul_i32 s14, s2, 64
		v_mov_b32_e32 v2, 0xff800000
		v_mbcnt_lo_u32_b32 v6, -1, 0
		v_mbcnt_hi_u32_b32 v6, -1, v6
		v_and_b32_e32 v14, 1, v6
		v_lshrrev_b32_e32 v16, 4, v6
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 4, v16
		v_lshrrev_b32_e32 v21, 3, v6
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 3, v21
		v_add3_u32 v22, v14, v16, v21
		v_lshrrev_b32_e32 v23, 2, v6
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 2, v23
		v_lshrrev_b32_e32 v6, 1, v6
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add3_u32 v22, v22, v23, v6
		v_add_u32_e32 v14, 32, v14
		v_bitop3_b32 v6, v23, v14, v6 bitop3:0x96
		v_bitop3_b32 v6, v16, v21, v6 bitop3:0x96
		v_mov_b32_e32 v26, 0x3e0293ee
		v_mov_b32_e32 v27, 0x3e0293ee
		s_mov_b32 s18, 0
		v_lshlrev_b32_e32 v14, 4, v36
		v_and_b32_e32 v11, 31, v11
		v_lshrrev_b32_e32 v16, 4, v11
		v_lshlrev_b32_e32 v21, 8, v16
		v_lshrrev_b32_e32 v23, 3, v11
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v24, 0x2080
		v_mul_lo_u32 v24, v24, v23
		v_lshrrev_b32_e32 v23, 2, v11
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v28, 0x1040
		v_mul_lo_u32 v28, v28, v23
		v_lshrrev_b32_e32 v23, 1, v11
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v29, 0x820
		v_mul_lo_u32 v29, v29, v23
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v23, 0x410
		v_mul_lo_u32 v23, v23, v11
		v_and_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 3, v0
		v_mov_b32_e32 v11, 0x2200
		v_mul_lo_u32 v11, v11, v5
		v_lshlrev_b32_e32 v30, 5, v9
		v_and_b32_e32 v4, 3, v4
		v_mov_b32_e32 v31, 0x440
		v_mul_lo_u32 v31, v31, v4
		s_lshl_b32 s19, s15, 7
		s_add_i32 s19, s19, s4
		s_add_i32 s19, s19, s5
		s_mul_i32 s24, 0x88, s15
		s_add_i32 s24, s24, s4
		s_add_i32 s24, s24, s5
		s_mul_i32 s26, 0x90, s15
		s_add_i32 s26, s26, s4
		s_add_i32 s26, s26, s5
		s_mul_i32 s27, 0x98, s15
		s_add_i32 s4, s27, s4
		s_add_i32 s4, s4, s5
		s_lshl_b32 s5, s20, 7
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s7
		s_mul_i32 s27, 0x88, s20
		s_add_i32 s27, s27, s1
		s_add_i32 s27, s27, s7
		s_mul_i32 s28, 0x90, s20
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s7
		s_mul_i32 s29, 0x98, s20
		s_add_i32 s1, s29, s1
		s_add_i32 s1, s1, s7
		v_lshlrev_b32_e32 v4, 2, v22
		v_lshlrev_b32_e32 v6, 2, v6
		s_cmp_lt_i32 0, s14
		v_mov_b32_e32 v32, 1.0
		v_mov_b32_e32 v33, 1.0
		v_mov_b32_e32 v34, 0xff800000
		v_mov_b32_e32 v35, 0xff800000
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
		s_and_b32 s29, s7, 1
		s_mul_i32 s40, 0x4100, s29
		v_add3_u32 v22, s40, v14, v21
		v_add3_u32 v22, v22, v24, v28
		v_add3_u32 v22, v22, v29, v23
		ds_read_b128 v[40:43], v22
		ds_read_b128 v[44:47], v22 offset:32
		ds_read_b128 v[176:179], v22 offset:64
		ds_read_b128 a[64:67], v22 offset:96
		ds_read_b128 a[68:71], v22 offset:128
		ds_read_b128 a[72:75], v22 offset:160
		ds_read_b128 a[76:79], v22 offset:192
		ds_read_b128 a[80:83], v22 offset:224
		ds_read_b128 v[180:183], v22 offset:512
		ds_read_b128 v[184:187], v22 offset:544
		ds_read_b128 v[188:191], v22 offset:576
		ds_read_b128 a[84:87], v22 offset:608
		ds_read_b128 a[88:91], v22 offset:640
		ds_read_b128 a[92:95], v22 offset:672
		ds_read_b128 a[96:99], v22 offset:704
		ds_read_b128 a[100:103], v22 offset:736
		s_mul_i32 s29, 0x4400, s29
		v_add3_u32 v22, s29, v0, v11
		v_add3_u32 v22, v22, v30, v31
		ds_read_b64_tr_b16 a[104:105], v22 offset:33264
		ds_read_b64_tr_b16 a[106:107], v22 offset:37616
		ds_read_b64_tr_b16 a[108:109], v22 offset:33520
		ds_read_b64_tr_b16 a[110:111], v22 offset:37872
		ds_read_b64_tr_b16 a[112:113], v22 offset:33776
		ds_read_b64_tr_b16 a[114:115], v22 offset:38128
		ds_read_b64_tr_b16 a[116:117], v22 offset:34032
		ds_read_b64_tr_b16 a[118:119], v22 offset:38384
		ds_read_b64_tr_b16 a[120:121], v22 offset:33328
		ds_read_b64_tr_b16 a[122:123], v22 offset:37680
		ds_read_b64_tr_b16 a[124:125], v22 offset:33584
		ds_read_b64_tr_b16 a[126:127], v22 offset:37936
		ds_read_b64_tr_b16 a[128:129], v22 offset:33840
		ds_read_b64_tr_b16 a[130:131], v22 offset:38192
		ds_read_b64_tr_b16 a[132:133], v22 offset:34096
		ds_read_b64_tr_b16 a[134:135], v22 offset:38448
		ds_read_b64_tr_b16 a[136:137], v22 offset:33392
		ds_read_b64_tr_b16 a[138:139], v22 offset:37744
		ds_read_b64_tr_b16 a[140:141], v22 offset:33648
		ds_read_b64_tr_b16 a[142:143], v22 offset:38000
		ds_read_b64_tr_b16 a[144:145], v22 offset:33904
		ds_read_b64_tr_b16 a[146:147], v22 offset:38256
		ds_read_b64_tr_b16 a[148:149], v22 offset:34160
		ds_read_b64_tr_b16 a[150:151], v22 offset:38512
		ds_read_b64_tr_b16 a[152:153], v22 offset:33456
		ds_read_b64_tr_b16 a[154:155], v22 offset:37808
		ds_read_b64_tr_b16 a[156:157], v22 offset:33712
		ds_read_b64_tr_b16 a[158:159], v22 offset:38064
		ds_read_b64_tr_b16 a[160:161], v22 offset:33968
		ds_read_b64_tr_b16 a[162:163], v22 offset:38320
		ds_read_b64_tr_b16 a[164:165], v22 offset:34224
		ds_read_b64_tr_b16 a[166:167], v22 offset:38576
		s_mul_i32 s29, s15, s18
		s_lshl_b32 s29, s29, 1
		s_add_i32 s40, s19, s29
		v_add_u32_e32 v22, s40, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v37, s29, v10
		s_add_i32 s7, s7, 1
		v_add_u32_e32 v38, s24, v37
		s_and_b32 s7, s7, 1
		v_add_u32_e32 v39, s26, v37
		s_mul_i32 s29, 0x4100, s7
		v_add_u32_e32 v37, s4, v37
		s_add_i32 s29, s6, s29
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[0:3], 0
		s_mov_b32 m0, s29
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[0:3], 0
		s_mul_i32 s29, s20, s18
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[32:35], 0
		s_add_i32 s18, s18, 64
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[32:35], 0
		v_add_u32_e32 v40, s18, v17
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], a[4:7], v[192:207]
		v_add_u32_e32 v41, s18, v1
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[4:7], v[208:223]
		v_add_u32_e32 v42, s18, v18
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[36:39], v[224:239]
		v_add_u32_e32 v43, s18, v12
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[36:39], v[240:255]
		v_cmp_lt_i32_e64 s[40:41], v40, s25
		v_mfma_f32_32x32x16_bf16 v[192:207], v[176:179], a[8:11], v[192:207]
		v_cmp_lt_i32_e64 vcc, v43, s25
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[8:11], v[208:223]
		v_cndmask_b32_e64 v22, v25, v22, s[40:41]
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[40:43], v[224:239]
		v_cmp_lt_i32_e64 s[42:43], v41, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], v[176:179], a[40:43], v[240:255]
		s_nop 0
		v_cndmask_b32_e64 v22, v25, v38, s[42:43]
		v_cmp_lt_i32_e64 s[44:45], v42, s25
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		v_cndmask_b32_e64 v38, v25, v39, s[44:45]
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		v_cndmask_b32_e32 v22, v25, v37, vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[12:15], v[192:207]
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s29, s29, 1
		s_add_i32 s46, s5, s29
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		v_add_u32_e32 v37, s46, v19
		v_cndmask_b32_e64 v37, v25, v37, s[40:41]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s7, 0x4400, s7
		s_add_i32 s7, s3, s7
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		v_add_u32_e32 v22, s29, v19
		v_add_u32_e32 v38, s27, v22
		s_add_i32 m0, s7, 0x81f0
		v_cndmask_b32_e64 v38, v25, v38, s[42:43]
		v_add_u32_e32 v39, s28, v22
		buffer_load_dwordx4 v37, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v37, v25, v39, s[44:45]
		v_add_u32_e32 v22, s1, v22
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v22, v25, v22, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[12:15], v[208:223]
		buffer_load_dwordx4 v38, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[44:47], v[224:239]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[44:47], v[240:255]
		buffer_load_dwordx4 v37, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[16:19], v[192:207]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s18, s14
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[16:19], v[208:223]
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
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
		s_nop 8
		v_max3_f32 v22, v192, v193, v194
		v_max3_f32 v37, v196, v197, v198
		v_max3_f32 v38, v200, v201, v202
		v_max3_f32 v39, v204, v205, v206
		v_max3_f32 v40, v208, v209, v210
		v_max3_f32 v41, v212, v213, v214
		v_max3_f32 v42, v216, v217, v218
		v_max3_f32 v43, v220, v221, v222
		v_max3_f32 v22, v22, v195, v37
		v_max3_f32 v37, v38, v203, v39
		v_max3_f32 v38, v40, v211, v41
		v_max3_f32 v39, v42, v219, v43
		v_max3_f32 v22, v22, v199, v37
		v_max3_f32 v37, v38, v215, v39
		v_max3_f32 v22, v22, v207, v37
		v_max_f32_e32 v38, v22, v223
		v_mov_b32_e32 v39, v38
		v_max3_f32 v22, v240, v241, v242
		v_max3_f32 v37, v244, v245, v246
		v_max3_f32 v40, v248, v249, v250
		v_max3_f32 v41, v252, v253, v254
		v_max3_f32 v42, v224, v225, v226
		v_max3_f32 v43, v228, v229, v230
		v_max3_f32 v44, v232, v233, v234
		v_max3_f32 v45, v236, v237, v238
		v_max3_f32 v22, v22, v243, v37
		v_max3_f32 v37, v40, v251, v41
		v_max3_f32 v40, v42, v227, v43
		v_max3_f32 v41, v44, v235, v45
		v_max3_f32 v22, v22, v247, v37
		v_max3_f32 v37, v40, v231, v41
		v_max3_f32 v22, v22, v255, v37
		v_max_f32_e32 v40, v22, v239
		v_permlane32_swap_b32_e32 v38, v39
		v_mov_b32_e32 v41, v40
		v_max_f32_e32 v42, v38, v39
		s_nop 0
		v_permlane32_swap_b32_e32 v40, v41
		v_max_f32_e32 v43, v40, v41
		v_pk_mul_f32 v[38:39], v[42:43], v[26:27]
		v_max_f32_e32 v40, v34, v38
		v_max_f32_e32 v42, v35, v39
		v_mov_b32_e32 v41, v40
		v_pk_fma_f32 v[38:39], v[192:193], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[194:195], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[196:197], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[198:199], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[200:201], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[202:203], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[204:205], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[206:207], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[208:209], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[210:211], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[212:213], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[214:215], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[216:217], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[218:219], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[220:221], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[222:223], v[26:27], v[40:41] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_mov_b32_e32 v43, v42
		v_pk_fma_f32 v[202:203], v[240:241], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[242:243], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[244:245], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[246:247], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[248:249], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[250:251], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[252:253], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[254:255], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[224:225], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[226:227], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[228:229], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[224:225], v[230:231], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[226:227], v[232:233], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[228:229], v[234:235], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[230:231], v[236:237], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[232:233], v[238:239], v[26:27], v[42:43] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v234, v38
		v_exp_f32_e32 v236, v39
		v_exp_f32_e32 v38, v44
		v_exp_f32_e32 v238, v45
		v_exp_f32_e32 v44, v46
		v_exp_f32_e32 v240, v47
		v_exp_f32_e32 v46, v176
		v_exp_f32_e32 v242, v177
		v_exp_f32_e32 v176, v178
		v_exp_f32_e32 v244, v179
		v_exp_f32_e32 v178, v180
		v_exp_f32_e32 v246, v181
		v_exp_f32_e32 v180, v182
		v_exp_f32_e32 v248, v183
		v_exp_f32_e32 v182, v184
		v_exp_f32_e32 v250, v185
		v_exp_f32_e32 v235, v186
		v_exp_f32_e32 v237, v187
		v_exp_f32_e32 v39, v188
		v_exp_f32_e32 v239, v189
		v_exp_f32_e32 v45, v190
		v_exp_f32_e32 v241, v191
		v_exp_f32_e32 v47, v192
		v_exp_f32_e32 v243, v193
		v_exp_f32_e32 v177, v194
		v_exp_f32_e32 v245, v195
		v_exp_f32_e32 v179, v196
		v_exp_f32_e32 v247, v197
		v_exp_f32_e32 v181, v198
		v_exp_f32_e32 v249, v199
		v_exp_f32_e32 v183, v200
		v_exp_f32_e32 v251, v201
		v_exp_f32_e32 v184, v202
		v_exp_f32_e32 v186, v203
		v_exp_f32_e32 v188, v204
		v_exp_f32_e32 v190, v205
		v_exp_f32_e32 v192, v206
		v_exp_f32_e32 v194, v207
		v_exp_f32_e32 v196, v208
		v_exp_f32_e32 v198, v209
		v_exp_f32_e32 v200, v210
		v_exp_f32_e32 v202, v211
		v_exp_f32_e32 v204, v212
		v_exp_f32_e32 v206, v213
		v_exp_f32_e32 v208, v214
		v_exp_f32_e32 v210, v215
		v_exp_f32_e32 v212, v216
		v_exp_f32_e32 v214, v217
		v_exp_f32_e32 v185, v218
		v_exp_f32_e32 v187, v219
		v_exp_f32_e32 v189, v220
		v_exp_f32_e32 v191, v221
		v_exp_f32_e32 v193, v222
		v_exp_f32_e32 v195, v223
		v_exp_f32_e32 v197, v224
		v_exp_f32_e32 v199, v225
		v_exp_f32_e32 v201, v226
		v_exp_f32_e32 v203, v227
		v_exp_f32_e32 v205, v228
		v_exp_f32_e32 v207, v229
		v_exp_f32_e32 v209, v230
		v_exp_f32_e32 v211, v231
		v_exp_f32_e32 v213, v232
		v_exp_f32_e32 v215, v233
		v_pk_add_f32 v[216:217], v[234:235], v[236:237]
		v_pk_add_f32 v[218:219], v[38:39], v[238:239]
		v_pk_add_f32 v[220:221], v[44:45], v[240:241]
		v_pk_add_f32 v[222:223], v[46:47], v[242:243]
		v_pk_add_f32 v[224:225], v[176:177], v[244:245]
		v_pk_add_f32 v[226:227], v[178:179], v[246:247]
		v_pk_add_f32 v[228:229], v[180:181], v[248:249]
		v_pk_add_f32 v[230:231], v[182:183], v[250:251]
		v_pk_add_f32 v[216:217], v[216:217], v[218:219]
		v_pk_add_f32 v[218:219], v[220:221], v[222:223]
		v_pk_add_f32 v[220:221], v[224:225], v[226:227]
		v_pk_add_f32 v[222:223], v[228:229], v[230:231]
		v_pk_add_f32 v[216:217], v[216:217], v[218:219]
		v_pk_add_f32 v[218:219], v[220:221], v[222:223]
		v_pk_add_f32 v[220:221], v[216:217], v[218:219]
		v_add_f32_e32 v22, v220, v221
		ds_bpermute_b32 v216, v4, v22
		ds_bpermute_b32 v218, v6, v22
		v_pk_add_f32 v[220:221], v[184:185], v[186:187]
		v_pk_add_f32 v[222:223], v[188:189], v[190:191]
		v_pk_add_f32 v[224:225], v[192:193], v[194:195]
		v_pk_add_f32 v[226:227], v[196:197], v[198:199]
		v_pk_add_f32 v[228:229], v[200:201], v[202:203]
		v_pk_add_f32 v[230:231], v[204:205], v[206:207]
		v_pk_add_f32 v[232:233], v[208:209], v[210:211]
		v_pk_add_f32 v[252:253], v[212:213], v[214:215]
		v_pk_add_f32 v[220:221], v[220:221], v[222:223]
		v_pk_add_f32 v[222:223], v[224:225], v[226:227]
		v_pk_add_f32 v[224:225], v[228:229], v[230:231]
		v_pk_add_f32 v[226:227], v[232:233], v[252:253]
		v_pk_add_f32 v[220:221], v[220:221], v[222:223]
		v_pk_add_f32 v[222:223], v[224:225], v[226:227]
		v_pk_add_f32 v[224:225], v[220:221], v[222:223]
		v_mov_b32_e32 v219, v225
		v_mov_b32_e32 v217, v224
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[220:221], v[216:217], v[218:219]
		v_mov_b32_e32 v216, v221
		v_mov_b32_e32 v217, v221
		v_cvt_pk_bf16_f32 v224, v234, v236
		v_cvt_pk_bf16_f32 v225, v38, v238
		v_permlane32_swap_b32_e32 v216, v217
		v_add_f32_e32 v219, v216, v217
		v_mov_b32_e32 v216, v40
		v_mov_b32_e32 v217, v42
		v_pk_add_f32 v[40:41], v[34:35], v[216:217] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v34, v40
		v_exp_f32_e32 v42, v41
		v_mov_b32_e32 v35, v34
		v_pk_mul_f32 v[48:49], v[48:49], v[34:35]
		v_pk_mul_f32 v[50:51], v[50:51], v[34:35]
		v_pk_mul_f32 v[52:53], v[52:53], v[34:35]
		v_pk_mul_f32 v[54:55], v[54:55], v[34:35]
		v_pk_mul_f32 v[56:57], v[56:57], v[34:35]
		v_pk_mul_f32 v[58:59], v[58:59], v[34:35]
		v_pk_mul_f32 v[60:61], v[60:61], v[34:35]
		v_pk_mul_f32 v[62:63], v[62:63], v[34:35]
		v_pk_mul_f32 v[64:65], v[64:65], v[34:35]
		v_pk_mul_f32 v[66:67], v[66:67], v[34:35]
		v_pk_mul_f32 v[68:69], v[68:69], v[34:35]
		v_pk_mul_f32 v[70:71], v[70:71], v[34:35]
		v_pk_mul_f32 v[72:73], v[72:73], v[34:35]
		v_pk_mul_f32 v[74:75], v[74:75], v[34:35]
		v_pk_mul_f32 v[76:77], v[76:77], v[34:35]
		v_pk_mul_f32 v[78:79], v[78:79], v[34:35]
		v_pk_mul_f32 v[80:81], v[80:81], v[34:35]
		v_pk_mul_f32 v[82:83], v[82:83], v[34:35]
		v_pk_mul_f32 v[84:85], v[84:85], v[34:35]
		v_pk_mul_f32 v[86:87], v[86:87], v[34:35]
		v_pk_mul_f32 v[88:89], v[88:89], v[34:35]
		v_pk_mul_f32 v[90:91], v[90:91], v[34:35]
		v_pk_mul_f32 v[92:93], v[92:93], v[34:35]
		v_pk_mul_f32 v[94:95], v[94:95], v[34:35]
		v_pk_mul_f32 v[96:97], v[96:97], v[34:35]
		v_pk_mul_f32 v[98:99], v[98:99], v[34:35]
		v_pk_mul_f32 v[100:101], v[100:101], v[34:35]
		v_pk_mul_f32 v[102:103], v[102:103], v[34:35]
		v_pk_mul_f32 v[104:105], v[104:105], v[34:35]
		v_pk_mul_f32 v[106:107], v[106:107], v[34:35]
		v_pk_mul_f32 v[108:109], v[108:109], v[34:35]
		v_pk_mul_f32 v[110:111], v[110:111], v[34:35]
		v_mov_b32_e32 v43, v42
		v_pk_mul_f32 v[112:113], v[112:113], v[42:43]
		v_pk_mul_f32 v[114:115], v[114:115], v[42:43]
		v_pk_mul_f32 v[116:117], v[116:117], v[42:43]
		v_pk_mul_f32 v[118:119], v[118:119], v[42:43]
		v_pk_mul_f32 v[120:121], v[120:121], v[42:43]
		v_pk_mul_f32 v[122:123], v[122:123], v[42:43]
		v_pk_mul_f32 v[124:125], v[124:125], v[42:43]
		v_pk_mul_f32 v[126:127], v[126:127], v[42:43]
		v_pk_mul_f32 v[128:129], v[128:129], v[42:43]
		v_pk_mul_f32 v[130:131], v[130:131], v[42:43]
		v_pk_mul_f32 v[132:133], v[132:133], v[42:43]
		v_pk_mul_f32 v[134:135], v[134:135], v[42:43]
		v_pk_mul_f32 v[136:137], v[136:137], v[42:43]
		v_pk_mul_f32 v[138:139], v[138:139], v[42:43]
		v_pk_mul_f32 v[140:141], v[140:141], v[42:43]
		v_pk_mul_f32 v[142:143], v[142:143], v[42:43]
		v_pk_mul_f32 v[144:145], v[144:145], v[42:43]
		v_pk_mul_f32 v[146:147], v[146:147], v[42:43]
		v_pk_mul_f32 v[148:149], v[148:149], v[42:43]
		v_pk_mul_f32 v[150:151], v[150:151], v[42:43]
		v_pk_mul_f32 v[152:153], v[152:153], v[42:43]
		v_pk_mul_f32 v[154:155], v[154:155], v[42:43]
		v_pk_mul_f32 v[156:157], v[156:157], v[42:43]
		v_pk_mul_f32 v[158:159], v[158:159], v[42:43]
		v_pk_mul_f32 v[160:161], v[160:161], v[42:43]
		v_pk_mul_f32 v[162:163], v[162:163], v[42:43]
		v_pk_mul_f32 v[164:165], v[164:165], v[42:43]
		v_pk_mul_f32 v[166:167], v[166:167], v[42:43]
		v_pk_mul_f32 v[168:169], v[168:169], v[42:43]
		v_pk_mul_f32 v[170:171], v[170:171], v[42:43]
		v_pk_mul_f32 v[172:173], v[172:173], v[42:43]
		v_pk_mul_f32 v[174:175], v[174:175], v[42:43]
		v_mov_b32_e32 v40, v34
		v_mov_b32_e32 v41, v42
		v_mov_b32_e32 v218, v220
		v_pk_fma_f32 v[32:33], v[32:33], v[40:41], v[218:219]
		v_cvt_pk_bf16_f32 v226, v44, v240
		v_cvt_pk_bf16_f32 v227, v46, v242
		v_cvt_pk_bf16_f32 v40, v176, v244
		v_cvt_pk_bf16_f32 v41, v178, v246
		v_cvt_pk_bf16_f32 v42, v180, v248
		v_cvt_pk_bf16_f32 v43, v182, v250
		v_cvt_pk_bf16_f32 v220, v235, v237
		v_cvt_pk_bf16_f32 v221, v39, v239
		v_cvt_pk_bf16_f32 v222, v45, v241
		v_cvt_pk_bf16_f32 v223, v47, v243
		v_cvt_pk_bf16_f32 v44, v177, v245
		v_cvt_pk_bf16_f32 v45, v179, v247
		v_cvt_pk_bf16_f32 v46, v181, v249
		v_cvt_pk_bf16_f32 v47, v183, v251
		v_cvt_pk_bf16_f32 v176, v184, v186
		v_cvt_pk_bf16_f32 v177, v188, v190
		v_cvt_pk_bf16_f32 v178, v192, v194
		v_cvt_pk_bf16_f32 v179, v196, v198
		v_cvt_pk_bf16_f32 v180, v200, v202
		v_cvt_pk_bf16_f32 v181, v204, v206
		v_cvt_pk_bf16_f32 v182, v208, v210
		v_cvt_pk_bf16_f32 v183, v212, v214
		v_cvt_pk_bf16_f32 v228, v185, v187
		v_cvt_pk_bf16_f32 v229, v189, v191
		v_cvt_pk_bf16_f32 v230, v193, v195
		v_cvt_pk_bf16_f32 v231, v197, v199
		v_cvt_pk_bf16_f32 v184, v201, v203
		v_cvt_pk_bf16_f32 v185, v205, v207
		v_cvt_pk_bf16_f32 v186, v209, v211
		v_cvt_pk_bf16_f32 v187, v213, v215
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[48:63], a[104:107], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[224:227], v[64:79]
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[224:227], v[80:95]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[96:111], a[152:155], v[224:227], v[96:111]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[160:175], a[152:155], v[176:179], v[160:175]
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		v_mfma_f32_32x32x16_bf16 v[112:127], a[104:107], v[176:179], v[112:127]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[128:143], a[120:123], v[176:179], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[136:139], v[176:179], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[108:111], v[40:43], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[40:43], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[40:43], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[156:159], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[156:159], v[180:183], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[108:111], v[180:183], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[124:127], v[180:183], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[140:143], v[180:183], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[220:223], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[160:163], v[220:223], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[160:163], v[228:231], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[228:231], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[228:231], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[228:231], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[44:47], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[44:47], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[44:47], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[164:167], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[164:167], v[184:187], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[184:187], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[184:187], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[184:187], v[144:159]
		v_mov_b32_e32 v34, v216
		v_mov_b32_e32 v35, v217
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s30
		s_mov_b32 s7, s31
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s2, 1
		s_mul_i32 s2, 0x4100, s1
		v_lshl_add_u32 v1, v36, 4, s2
		v_lshl_add_u32 v1, v16, 8, v1
		v_add3_u32 v1, v1, v24, v28
		v_add3_u32 v1, v1, v29, v23
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
		v_add3_u32 v0, s1, v0, v11
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
		s_mul_i32 s1, s16, s23
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
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
		v_mov_b32_e32 v0, 4
		v_mul_lo_u32 v0, v0, v7
		v_add_u32_e32 v1, s14, v0
		v_xad_u32 v7, 16, v0, s14
		v_xad_u32 v10, 32, v0, s14
		v_xad_u32 v0, 48, v0, s14
		v_cmp_lt_i32_e64 s[2:3], v1, s25
		v_cmp_lt_i32_e64 s[8:9], v7, s25
		v_cmp_lt_i32_e64 s[14:15], v10, s25
		v_cmp_lt_i32_e64 vcc, v0, s25
		v_cndmask_b32_e64 v0, v2, v192, s[2:3]
		v_cndmask_b32_e64 v1, v2, v193, s[2:3]
		v_cndmask_b32_e64 v10, v2, v194, s[2:3]
		v_cndmask_b32_e64 v11, v2, v195, s[2:3]
		v_cndmask_b32_e64 v16, v2, v196, s[2:3]
		v_cndmask_b32_e64 v17, v2, v197, s[2:3]
		v_cndmask_b32_e64 v18, v2, v198, s[2:3]
		v_cndmask_b32_e64 v19, v2, v199, s[2:3]
		v_cndmask_b32_e64 v22, v2, v200, s[8:9]
		v_cndmask_b32_e64 v23, v2, v201, s[8:9]
		v_cndmask_b32_e64 v24, v2, v202, s[8:9]
		v_cndmask_b32_e64 v25, v2, v203, s[8:9]
		v_cndmask_b32_e64 v28, v2, v204, s[8:9]
		v_cndmask_b32_e64 v29, v2, v205, s[8:9]
		v_cndmask_b32_e64 v30, v2, v206, s[8:9]
		v_cndmask_b32_e64 v31, v2, v207, s[8:9]
		v_cndmask_b32_e64 v36, v2, v208, s[14:15]
		v_cndmask_b32_e64 v37, v2, v209, s[14:15]
		v_cndmask_b32_e64 v38, v2, v210, s[14:15]
		v_cndmask_b32_e64 v39, v2, v211, s[14:15]
		v_cndmask_b32_e64 v40, v2, v212, s[14:15]
		v_cndmask_b32_e64 v41, v2, v213, s[14:15]
		v_cndmask_b32_e64 v42, v2, v214, s[14:15]
		v_cndmask_b32_e64 v43, v2, v215, s[14:15]
		v_cndmask_b32_e32 v44, v2, v216, vcc
		v_cndmask_b32_e32 v45, v2, v217, vcc
		v_cndmask_b32_e32 v46, v2, v218, vcc
		v_cndmask_b32_e32 v47, v2, v219, vcc
		v_cndmask_b32_e32 v176, v2, v220, vcc
		v_cndmask_b32_e32 v177, v2, v221, vcc
		v_cndmask_b32_e32 v178, v2, v222, vcc
		v_cndmask_b32_e32 v179, v2, v223, vcc
		v_cndmask_b32_e64 v180, v2, v242, s[2:3]
		v_cndmask_b32_e64 v181, v2, v243, s[2:3]
		v_cndmask_b32_e64 v182, v2, v244, s[2:3]
		v_cndmask_b32_e64 v183, v2, v245, s[2:3]
		v_cndmask_b32_e64 v184, v2, v246, s[2:3]
		v_cndmask_b32_e64 v185, v2, v247, s[2:3]
		v_cndmask_b32_e64 v186, v2, v248, s[8:9]
		v_cndmask_b32_e64 v187, v2, v249, s[8:9]
		v_cndmask_b32_e64 v188, v2, v250, s[8:9]
		v_cndmask_b32_e64 v189, v2, v251, s[8:9]
		v_cndmask_b32_e64 v190, v2, v252, s[8:9]
		v_cndmask_b32_e64 v191, v2, v253, s[8:9]
		v_cndmask_b32_e64 v192, v2, v254, s[8:9]
		v_cndmask_b32_e64 v193, v2, v255, s[8:9]
		v_cndmask_b32_e64 v194, v2, v224, s[14:15]
		v_cndmask_b32_e64 v195, v2, v225, s[14:15]
		v_cndmask_b32_e64 v196, v2, v226, s[14:15]
		v_cndmask_b32_e64 v197, v2, v227, s[14:15]
		v_cndmask_b32_e64 v198, v2, v228, s[14:15]
		v_cndmask_b32_e64 v199, v2, v229, s[14:15]
		v_cndmask_b32_e64 v200, v2, v230, s[14:15]
		v_cndmask_b32_e64 v201, v2, v231, s[14:15]
		v_cndmask_b32_e32 v202, v2, v232, vcc
		v_cndmask_b32_e32 v203, v2, v233, vcc
		v_cndmask_b32_e32 v204, v2, v234, vcc
		v_cndmask_b32_e32 v205, v2, v235, vcc
		v_cndmask_b32_e32 v206, v2, v236, vcc
		v_cndmask_b32_e32 v207, v2, v237, vcc
		v_cndmask_b32_e32 v208, v2, v238, vcc
		v_cndmask_b32_e32 v209, v2, v239, vcc
		v_max3_f32 v7, v0, v1, v10
		v_max3_f32 v12, v16, v17, v18
		v_max3_f32 v14, v22, v23, v24
		v_max3_f32 v21, v28, v29, v30
		v_max3_f32 v210, v36, v37, v38
		v_max3_f32 v211, v40, v41, v42
		v_max3_f32 v212, v44, v45, v46
		v_max3_f32 v213, v176, v177, v178
		v_max3_f32 v7, v7, v11, v12
		v_max3_f32 v12, v14, v25, v21
		v_max3_f32 v14, v210, v39, v211
		v_max3_f32 v21, v212, v47, v213
		v_max3_f32 v7, v7, v19, v12
		v_max3_f32 v12, v14, v43, v21
		v_max3_f32 v7, v7, v31, v12
		v_max_f32_e32 v210, v7, v179
		v_mov_b32_e32 v211, v210
		v_cndmask_b32_e64 v212, v2, v240, s[2:3]
		v_cndmask_b32_e64 v213, v2, v241, s[2:3]
		v_permlane32_swap_b32_e32 v210, v211
		v_max3_f32 v2, v212, v213, v180
		v_max3_f32 v7, v182, v183, v184
		v_max3_f32 v12, v186, v187, v188
		v_max3_f32 v14, v190, v191, v192
		v_max3_f32 v21, v194, v195, v196
		v_max3_f32 v214, v198, v199, v200
		v_max3_f32 v215, v202, v203, v204
		v_max3_f32 v216, v206, v207, v208
		v_max3_f32 v2, v2, v181, v7
		v_max3_f32 v7, v12, v189, v14
		v_max3_f32 v12, v21, v197, v214
		v_max3_f32 v14, v215, v205, v216
		v_max3_f32 v2, v2, v185, v7
		v_max3_f32 v7, v12, v201, v14
		v_max3_f32 v2, v2, v193, v7
		v_max_f32_e32 v214, v2, v209
		v_mov_b32_e32 v215, v214
		v_max_f32_e32 v216, v210, v211
		s_lshl_b32 s1, s1, 9
		v_permlane32_swap_b32_e32 v214, v215
		v_max_f32_e32 v217, v214, v215
		v_pk_mul_f32 v[210:211], v[216:217], v[26:27]
		v_max_f32_e32 v214, v34, v210
		v_max_f32_e32 v216, v35, v211
		v_mov_b32_e32 v215, v214
		v_pk_fma_f32 v[210:211], v[0:1], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[0:1], v[10:11], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[10:11], v[16:17], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[18:19], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[22:23], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[24:25], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[28:29], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[30:31], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[36:37], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[36:37], v[38:39], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[38:39], v[40:41], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[40:41], v[42:43], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[44:45], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[46:47], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[176:177], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[26:27], v[214:215] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_mov_b32_e32 v217, v216
		v_pk_fma_f32 v[178:179], v[212:213], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[180:181], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[206:207], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[208:209], v[26:27], v[216:217] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v26, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v210, v0
		v_exp_f32_e32 v218, v1
		v_exp_f32_e32 v0, v10
		v_exp_f32_e32 v220, v11
		v_exp_f32_e32 v10, v16
		v_exp_f32_e32 v222, v17
		v_exp_f32_e32 v16, v18
		v_exp_f32_e32 v224, v19
		v_exp_f32_e32 v18, v22
		v_exp_f32_e32 v226, v23
		v_exp_f32_e32 v22, v24
		v_exp_f32_e32 v228, v25
		v_exp_f32_e32 v24, v28
		v_exp_f32_e32 v230, v29
		v_exp_f32_e32 v27, v30
		v_exp_f32_e32 v209, v31
		v_exp_f32_e32 v211, v36
		v_exp_f32_e32 v219, v37
		v_exp_f32_e32 v1, v38
		v_exp_f32_e32 v221, v39
		v_exp_f32_e32 v11, v40
		v_exp_f32_e32 v223, v41
		v_exp_f32_e32 v17, v42
		v_exp_f32_e32 v225, v43
		v_exp_f32_e32 v19, v44
		v_exp_f32_e32 v227, v45
		v_exp_f32_e32 v23, v46
		v_exp_f32_e32 v229, v47
		v_exp_f32_e32 v25, v176
		v_exp_f32_e32 v231, v177
		v_exp_f32_e32 v28, v178
		v_exp_f32_e32 v30, v179
		v_exp_f32_e32 v36, v212
		v_exp_f32_e32 v38, v213
		v_exp_f32_e32 v40, v180
		v_exp_f32_e32 v42, v181
		v_exp_f32_e32 v44, v182
		v_exp_f32_e32 v46, v183
		v_exp_f32_e32 v176, v184
		v_exp_f32_e32 v178, v185
		v_exp_f32_e32 v180, v186
		v_exp_f32_e32 v182, v187
		v_exp_f32_e32 v184, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v188, v190
		v_exp_f32_e32 v212, v191
		v_exp_f32_e32 v29, v192
		v_exp_f32_e32 v31, v193
		v_exp_f32_e32 v37, v194
		v_exp_f32_e32 v39, v195
		v_exp_f32_e32 v41, v196
		v_exp_f32_e32 v43, v197
		v_exp_f32_e32 v45, v198
		v_exp_f32_e32 v47, v199
		v_exp_f32_e32 v177, v200
		v_exp_f32_e32 v179, v201
		v_exp_f32_e32 v181, v202
		v_exp_f32_e32 v183, v203
		v_exp_f32_e32 v185, v204
		v_exp_f32_e32 v187, v205
		v_exp_f32_e32 v189, v206
		v_exp_f32_e32 v213, v207
		v_pk_add_f32 v[190:191], v[26:27], v[208:209]
		v_pk_add_f32 v[192:193], v[210:211], v[218:219]
		v_pk_add_f32 v[194:195], v[0:1], v[220:221]
		v_pk_add_f32 v[196:197], v[10:11], v[222:223]
		v_pk_add_f32 v[198:199], v[16:17], v[224:225]
		v_pk_add_f32 v[200:201], v[18:19], v[226:227]
		v_pk_add_f32 v[202:203], v[22:23], v[228:229]
		v_pk_add_f32 v[204:205], v[24:25], v[230:231]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[198:199], v[200:201]
		v_pk_add_f32 v[196:197], v[202:203], v[204:205]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[190:191], v[192:193]
		v_add_f32_e32 v2, v194, v195
		ds_bpermute_b32 v190, v4, v2
		ds_bpermute_b32 v192, v6, v2
		v_pk_add_f32 v[6:7], v[28:29], v[30:31]
		v_pk_add_f32 v[194:195], v[36:37], v[38:39]
		v_pk_add_f32 v[196:197], v[40:41], v[42:43]
		v_pk_add_f32 v[198:199], v[44:45], v[46:47]
		v_pk_add_f32 v[200:201], v[176:177], v[178:179]
		v_pk_add_f32 v[202:203], v[180:181], v[182:183]
		v_pk_add_f32 v[204:205], v[184:185], v[186:187]
		v_pk_add_f32 v[206:207], v[188:189], v[212:213]
		v_pk_add_f32 v[6:7], v[6:7], v[194:195]
		v_pk_add_f32 v[194:195], v[196:197], v[198:199]
		v_pk_add_f32 v[196:197], v[200:201], v[202:203]
		v_pk_add_f32 v[198:199], v[204:205], v[206:207]
		v_pk_add_f32 v[6:7], v[6:7], v[194:195]
		v_pk_add_f32 v[194:195], v[196:197], v[198:199]
		v_pk_add_f32 v[196:197], v[6:7], v[194:195]
		v_mov_b32_e32 v193, v197
		v_mov_b32_e32 v191, v196
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[6:7], v[190:191], v[192:193]
		v_mov_b32_e32 v190, v7
		v_mov_b32_e32 v191, v7
		v_cvt_pk_bf16_f32 v192, v26, v208
		v_cvt_pk_bf16_f32 v193, v210, v218
		v_permlane32_swap_b32_e32 v190, v191
		v_add_f32_e32 v195, v190, v191
		v_mov_b32_e32 v190, v214
		v_mov_b32_e32 v191, v216
		v_pk_add_f32 v[196:197], v[34:35], v[190:191] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v34, v196
		v_exp_f32_e32 v190, v197
		v_mov_b32_e32 v35, v34
		v_pk_mul_f32 v[240:241], v[48:49], v[34:35]
		v_pk_mul_f32 v[242:243], v[50:51], v[34:35]
		v_pk_mul_f32 v[244:245], v[52:53], v[34:35]
		v_pk_mul_f32 v[246:247], v[54:55], v[34:35]
		v_pk_mul_f32 v[248:249], v[56:57], v[34:35]
		v_pk_mul_f32 v[250:251], v[58:59], v[34:35]
		v_pk_mul_f32 v[252:253], v[60:61], v[34:35]
		v_pk_mul_f32 v[254:255], v[62:63], v[34:35]
		v_pk_mul_f32 v[48:49], v[64:65], v[34:35]
		v_pk_mul_f32 v[50:51], v[66:67], v[34:35]
		v_pk_mul_f32 v[52:53], v[68:69], v[34:35]
		v_pk_mul_f32 v[54:55], v[70:71], v[34:35]
		v_pk_mul_f32 v[56:57], v[72:73], v[34:35]
		v_pk_mul_f32 v[58:59], v[74:75], v[34:35]
		v_pk_mul_f32 v[60:61], v[76:77], v[34:35]
		v_pk_mul_f32 v[62:63], v[78:79], v[34:35]
		v_pk_mul_f32 v[64:65], v[80:81], v[34:35]
		v_pk_mul_f32 v[66:67], v[82:83], v[34:35]
		v_pk_mul_f32 v[68:69], v[84:85], v[34:35]
		v_pk_mul_f32 v[70:71], v[86:87], v[34:35]
		v_pk_mul_f32 v[72:73], v[88:89], v[34:35]
		v_pk_mul_f32 v[74:75], v[90:91], v[34:35]
		v_pk_mul_f32 v[76:77], v[92:93], v[34:35]
		v_pk_mul_f32 v[78:79], v[94:95], v[34:35]
		v_pk_mul_f32 v[80:81], v[96:97], v[34:35]
		v_pk_mul_f32 v[82:83], v[98:99], v[34:35]
		v_pk_mul_f32 v[84:85], v[100:101], v[34:35]
		v_pk_mul_f32 v[86:87], v[102:103], v[34:35]
		v_pk_mul_f32 v[88:89], v[104:105], v[34:35]
		v_pk_mul_f32 v[90:91], v[106:107], v[34:35]
		v_pk_mul_f32 v[92:93], v[108:109], v[34:35]
		v_pk_mul_f32 v[94:95], v[110:111], v[34:35]
		v_mov_b32_e32 v191, v190
		v_pk_mul_f32 v[96:97], v[112:113], v[190:191]
		v_pk_mul_f32 v[98:99], v[114:115], v[190:191]
		v_pk_mul_f32 v[100:101], v[116:117], v[190:191]
		v_pk_mul_f32 v[102:103], v[118:119], v[190:191]
		v_pk_mul_f32 v[104:105], v[120:121], v[190:191]
		v_pk_mul_f32 v[106:107], v[122:123], v[190:191]
		v_pk_mul_f32 v[108:109], v[124:125], v[190:191]
		v_pk_mul_f32 v[110:111], v[126:127], v[190:191]
		v_pk_mul_f32 v[112:113], v[128:129], v[190:191]
		v_pk_mul_f32 v[114:115], v[130:131], v[190:191]
		v_pk_mul_f32 v[116:117], v[132:133], v[190:191]
		v_pk_mul_f32 v[118:119], v[134:135], v[190:191]
		v_pk_mul_f32 v[120:121], v[136:137], v[190:191]
		v_pk_mul_f32 v[122:123], v[138:139], v[190:191]
		v_pk_mul_f32 v[124:125], v[140:141], v[190:191]
		v_pk_mul_f32 v[126:127], v[142:143], v[190:191]
		v_pk_mul_f32 v[128:129], v[144:145], v[190:191]
		v_pk_mul_f32 v[130:131], v[146:147], v[190:191]
		v_pk_mul_f32 v[132:133], v[148:149], v[190:191]
		v_pk_mul_f32 v[134:135], v[150:151], v[190:191]
		v_pk_mul_f32 v[136:137], v[152:153], v[190:191]
		v_pk_mul_f32 v[138:139], v[154:155], v[190:191]
		v_pk_mul_f32 v[140:141], v[156:157], v[190:191]
		v_pk_mul_f32 v[142:143], v[158:159], v[190:191]
		v_pk_mul_f32 v[144:145], v[160:161], v[190:191]
		v_pk_mul_f32 v[146:147], v[162:163], v[190:191]
		v_pk_mul_f32 v[148:149], v[164:165], v[190:191]
		v_pk_mul_f32 v[150:151], v[166:167], v[190:191]
		v_pk_mul_f32 v[152:153], v[168:169], v[190:191]
		v_pk_mul_f32 v[154:155], v[170:171], v[190:191]
		v_pk_mul_f32 v[156:157], v[172:173], v[190:191]
		v_pk_mul_f32 v[158:159], v[174:175], v[190:191]
		v_mov_b32_e32 v160, v34
		v_mov_b32_e32 v161, v190
		v_mov_b32_e32 v194, v6
		v_pk_fma_f32 v[6:7], v[32:33], v[160:161], v[194:195]
		v_cvt_pk_bf16_f32 v194, v0, v220
		v_cvt_pk_bf16_f32 v195, v10, v222
		v_cvt_pk_bf16_f32 v32, v16, v224
		v_cvt_pk_bf16_f32 v33, v18, v226
		v_cvt_pk_bf16_f32 v34, v22, v228
		v_cvt_pk_bf16_f32 v35, v24, v230
		v_cvt_pk_bf16_f32 v160, v27, v209
		v_cvt_pk_bf16_f32 v161, v211, v219
		v_cvt_pk_bf16_f32 v162, v1, v221
		v_cvt_pk_bf16_f32 v163, v11, v223
		v_cvt_pk_bf16_f32 v164, v17, v225
		v_cvt_pk_bf16_f32 v165, v19, v227
		v_cvt_pk_bf16_f32 v166, v23, v229
		v_cvt_pk_bf16_f32 v167, v25, v231
		v_cvt_pk_bf16_f32 v16, v28, v30
		v_cvt_pk_bf16_f32 v17, v36, v38
		v_cvt_pk_bf16_f32 v18, v40, v42
		v_cvt_pk_bf16_f32 v19, v44, v46
		v_cvt_pk_bf16_f32 v24, v176, v178
		v_cvt_pk_bf16_f32 v25, v180, v182
		v_cvt_pk_bf16_f32 v26, v184, v186
		v_cvt_pk_bf16_f32 v27, v188, v212
		v_cvt_pk_bf16_f32 v168, v29, v31
		v_cvt_pk_bf16_f32 v169, v37, v39
		v_cvt_pk_bf16_f32 v170, v41, v43
		v_cvt_pk_bf16_f32 v171, v45, v47
		v_cvt_pk_bf16_f32 v28, v177, v179
		v_cvt_pk_bf16_f32 v29, v181, v183
		v_cvt_pk_bf16_f32 v30, v185, v187
		v_cvt_pk_bf16_f32 v31, v189, v213
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[240:255], a[96:99], v[192:195], v[240:255]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		s_mul_i32 s2, s17, s21
		s_lshl_b32 s2, s2, 1
		s_add_i32 s3, s1, s2
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[192:195], v[64:79]
		s_mul_i32 s0, s0, s22
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[192:195], v[80:95]
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[16:19], v[144:159]
		s_add_i32 s3, s3, s0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], v[16:19], v[96:111]
		v_mul_lo_u32 v0, s23, v13
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[16:19], v[112:127]
		v_lshl_add_u32 v1, v0, 6, s3
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[16:19], v[128:143]
		v_mul_lo_u32 v2, s23, v15
		v_mfma_f32_32x32x16_bf16 v[240:255], a[100:103], v[32:35], v[240:255]
		v_lshl_add_u32 v1, v2, 1, v1
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[32:35], v[48:63]
		v_mul_lo_u32 v4, s23, v9
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[32:35], v[64:79]
		v_lshl_add_u32 v1, v4, 5, v1
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[32:35], v[80:95]
		v_mul_lo_u32 v8, s23, v8
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[24:27], v[144:159]
		v_lshl_add_u32 v1, v8, 4, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], v[24:27], v[96:111]
		v_mul_lo_u32 v9, s23, v20
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[24:27], v[112:127]
		v_lshl_add_u32 v1, v9, 3, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[24:27], v[128:143]
		v_mul_lo_u32 v3, s23, v3
		v_mfma_f32_32x32x16_bf16 v[240:255], a[104:107], v[160:163], v[240:255]
		v_lshl_add_u32 v1, v3, 2, v1
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[160:163], v[48:63]
		v_lshl_add_u32 v1, v5, 4, v1
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[160:163], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[160:163], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[168:171], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], v[168:171], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[168:171], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[168:171], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[108:111], v[164:167], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[28:31], v[128:143]
		v_rcp_f32_e32 v10, v6
		v_rcp_f32_e32 v12, v7
		v_mov_b32_e32 v11, v10
		s_nop 1
		v_pk_mul_f32 v[6:7], v[240:241], v[10:11]
		v_pk_mul_f32 v[14:15], v[242:243], v[10:11]
		v_pk_mul_f32 v[16:17], v[244:245], v[10:11]
		v_pk_mul_f32 v[18:19], v[246:247], v[10:11]
		v_pk_mul_f32 v[20:21], v[248:249], v[10:11]
		v_pk_mul_f32 v[22:23], v[250:251], v[10:11]
		v_pk_mul_f32 v[24:25], v[252:253], v[10:11]
		v_pk_mul_f32 v[26:27], v[254:255], v[10:11]
		v_pk_mul_f32 v[28:29], v[48:49], v[10:11]
		v_pk_mul_f32 v[30:31], v[50:51], v[10:11]
		v_pk_mul_f32 v[32:33], v[52:53], v[10:11]
		v_pk_mul_f32 v[34:35], v[54:55], v[10:11]
		v_pk_mul_f32 v[36:37], v[56:57], v[10:11]
		v_pk_mul_f32 v[38:39], v[58:59], v[10:11]
		v_pk_mul_f32 v[40:41], v[60:61], v[10:11]
		v_pk_mul_f32 v[42:43], v[62:63], v[10:11]
		v_pk_mul_f32 v[44:45], v[64:65], v[10:11]
		v_pk_mul_f32 v[46:47], v[66:67], v[10:11]
		v_pk_mul_f32 v[48:49], v[68:69], v[10:11]
		v_pk_mul_f32 v[50:51], v[70:71], v[10:11]
		v_pk_mul_f32 v[52:53], v[72:73], v[10:11]
		v_pk_mul_f32 v[54:55], v[74:75], v[10:11]
		v_pk_mul_f32 v[56:57], v[76:77], v[10:11]
		v_pk_mul_f32 v[58:59], v[78:79], v[10:11]
		v_pk_mul_f32 v[60:61], v[80:81], v[10:11]
		v_pk_mul_f32 v[62:63], v[82:83], v[10:11]
		v_pk_mul_f32 v[64:65], v[84:85], v[10:11]
		v_pk_mul_f32 v[66:67], v[86:87], v[10:11]
		v_pk_mul_f32 v[68:69], v[88:89], v[10:11]
		v_pk_mul_f32 v[70:71], v[90:91], v[10:11]
		v_pk_mul_f32 v[72:73], v[92:93], v[10:11]
		v_pk_mul_f32 v[74:75], v[94:95], v[10:11]
		v_mov_b32_e32 v13, v12
		v_pk_mul_f32 v[10:11], v[96:97], v[12:13]
		v_pk_mul_f32 v[76:77], v[98:99], v[12:13]
		v_pk_mul_f32 v[78:79], v[100:101], v[12:13]
		v_pk_mul_f32 v[80:81], v[102:103], v[12:13]
		v_pk_mul_f32 v[82:83], v[104:105], v[12:13]
		v_pk_mul_f32 v[84:85], v[106:107], v[12:13]
		v_pk_mul_f32 v[86:87], v[108:109], v[12:13]
		v_pk_mul_f32 v[88:89], v[110:111], v[12:13]
		v_pk_mul_f32 v[90:91], v[112:113], v[12:13]
		v_pk_mul_f32 v[92:93], v[114:115], v[12:13]
		v_pk_mul_f32 v[94:95], v[116:117], v[12:13]
		v_pk_mul_f32 v[96:97], v[118:119], v[12:13]
		v_pk_mul_f32 v[98:99], v[120:121], v[12:13]
		v_pk_mul_f32 v[100:101], v[122:123], v[12:13]
		v_pk_mul_f32 v[102:103], v[124:125], v[12:13]
		v_pk_mul_f32 v[104:105], v[126:127], v[12:13]
		v_pk_mul_f32 v[106:107], v[128:129], v[12:13]
		v_pk_mul_f32 v[108:109], v[130:131], v[12:13]
		v_pk_mul_f32 v[110:111], v[132:133], v[12:13]
		v_pk_mul_f32 v[112:113], v[134:135], v[12:13]
		v_pk_mul_f32 v[114:115], v[136:137], v[12:13]
		v_pk_mul_f32 v[116:117], v[138:139], v[12:13]
		v_pk_mul_f32 v[118:119], v[140:141], v[12:13]
		v_pk_mul_f32 v[120:121], v[142:143], v[12:13]
		v_pk_mul_f32 v[122:123], v[144:145], v[12:13]
		v_pk_mul_f32 v[124:125], v[146:147], v[12:13]
		v_pk_mul_f32 v[126:127], v[148:149], v[12:13]
		v_pk_mul_f32 v[128:129], v[150:151], v[12:13]
		v_pk_mul_f32 v[130:131], v[152:153], v[12:13]
		v_pk_mul_f32 v[132:133], v[154:155], v[12:13]
		v_pk_mul_f32 v[134:135], v[156:157], v[12:13]
		v_pk_mul_f32 v[136:137], v[158:159], v[12:13]
		v_cvt_pk_bf16_f32 v140, v6, v7
		v_cvt_pk_bf16_f32 v141, v14, v15
		v_cvt_pk_bf16_f32 v142, v16, v17
		v_cvt_pk_bf16_f32 v143, v18, v19
		v_cvt_pk_bf16_f32 v12, v20, v21
		v_cvt_pk_bf16_f32 v13, v22, v23
		v_cvt_pk_bf16_f32 v14, v24, v25
		v_cvt_pk_bf16_f32 v15, v26, v27
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
		v_cvt_pk_bf16_f32 v40, v10, v11
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
		s_and_saveexec_b64 s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_16
		buffer_store_dwordx4 v[140:143], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_16:
		s_andn2_b64 exec, s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_16
.L_attn_fwd_async_prefetch.exec_endif_16:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 32
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v1, v0, 6, s3
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_17
		buffer_store_dwordx4 v[12:15], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_17:
		s_andn2_b64 exec, s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_17
.L_attn_fwd_async_prefetch.exec_endif_17:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 64
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v1, v0, 6, s3
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_18
		buffer_store_dwordx4 v[16:19], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_18:
		s_andn2_b64 exec, s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_18
.L_attn_fwd_async_prefetch.exec_endif_18:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0x60
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v1, v0, 6, s3
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_19
		buffer_store_dwordx4 v[20:23], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_19:
		s_andn2_b64 exec, s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_19
.L_attn_fwd_async_prefetch.exec_endif_19:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0x80
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v1, v0, 6, s3
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_20
		buffer_store_dwordx4 v[24:27], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_20:
		s_andn2_b64 exec, s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_20
.L_attn_fwd_async_prefetch.exec_endif_20:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0xa0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v1, v0, 6, s3
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_21
		buffer_store_dwordx4 v[28:31], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_21:
		s_andn2_b64 exec, s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_21
.L_attn_fwd_async_prefetch.exec_endif_21:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0xc0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v1, v0, 6, s3
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_22
		buffer_store_dwordx4 v[32:35], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_22:
		s_andn2_b64 exec, s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_22
.L_attn_fwd_async_prefetch.exec_endif_22:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s1, 0xe0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_lshl_add_u32 v1, v0, 6, s3
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_23
		buffer_store_dwordx4 v[36:39], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_23:
		s_andn2_b64 exec, s[48:49], s[10:11]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_23
.L_attn_fwd_async_prefetch.exec_endif_23:
		s_mov_b64 exec, s[48:49]
		s_lshl_b32 s3, s23, 8
		s_add_i32 s8, s3, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_24
		buffer_store_dwordx4 v[40:43], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_24:
		s_andn2_b64 exec, s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_24
.L_attn_fwd_async_prefetch.exec_endif_24:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 32
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_25
		buffer_store_dwordx4 v[44:47], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_25:
		s_andn2_b64 exec, s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_25
.L_attn_fwd_async_prefetch.exec_endif_25:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 64
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_26
		buffer_store_dwordx4 v[48:51], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_26:
		s_andn2_b64 exec, s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_26
.L_attn_fwd_async_prefetch.exec_endif_26:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 0x60
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_27
		buffer_store_dwordx4 v[52:55], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_27:
		s_andn2_b64 exec, s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_27
.L_attn_fwd_async_prefetch.exec_endif_27:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 0x80
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_28
		buffer_store_dwordx4 v[56:59], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_28:
		s_andn2_b64 exec, s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_28
.L_attn_fwd_async_prefetch.exec_endif_28:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 0xa0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_29
		buffer_store_dwordx4 v[60:63], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_29:
		s_andn2_b64 exec, s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_29
.L_attn_fwd_async_prefetch.exec_endif_29:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s3, 0xc0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_lshl_add_u32 v1, v0, 6, s8
		v_lshl_add_u32 v1, v2, 1, v1
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshl_add_u32 v1, v8, 4, v1
		v_lshl_add_u32 v1, v9, 3, v1
		v_lshl_add_u32 v1, v3, 2, v1
		v_lshl_add_u32 v1, v5, 4, v1
		s_and_saveexec_b64 s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_30
		buffer_store_dwordx4 v[64:67], v1, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_30:
		s_andn2_b64 exec, s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_endif_30
.L_attn_fwd_async_prefetch.exec_endif_30:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s3, s3, 0xe0
		s_add_i32 s1, s3, s1
		s_add_i32 s1, s1, s2
		s_add_i32 s0, s1, s0
		v_lshl_add_u32 v0, v0, 6, s0
		v_lshl_add_u32 v0, v2, 1, v0
		v_lshl_add_u32 v0, v4, 5, v0
		v_lshl_add_u32 v0, v8, 4, v0
		v_lshl_add_u32 v0, v9, 3, v0
		v_lshl_add_u32 v0, v3, 2, v0
		v_lshl_add_u32 v0, v5, 4, v0
		s_and_saveexec_b64 s[48:49], s[12:13]
		s_cbranch_execz .L_attn_fwd_async_prefetch.exec_else_31
		buffer_store_dwordx4 v[68:71], v0, s[4:7], 0 offen
.L_attn_fwd_async_prefetch.exec_else_31:
		s_andn2_b64 exec, s[48:49], s[12:13]
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
