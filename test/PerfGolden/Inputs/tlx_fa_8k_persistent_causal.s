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
		v_accvgpr_write_b32 a10, v1
		s_add_i32 s1, s22, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s1, s1, s22
		s_xor_b32 s22, s1, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s1, s22, s1
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a11, v1
		s_mul_i32 s1, s19, 2
		s_cmp_lt_i32 s1, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s19, s1, 1
		s_and_b32 s1, s1, 1
		s_xor_b32 s22, s19, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s22, s22, 31
		s_cmp_eq_u32 s1, 0
		s_cselect_b32 s1, s19, s22
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a12, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, 0x100
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
		v_accvgpr_write_b32 a13, v13
		v_accvgpr_read_b32 v13, a13
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v13
		v_bitop3_b32 v5, v5, v12, v14 bitop3:0x96
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 64
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v5, v5, v16
		v_accvgpr_write_b32 a14, v5
		v_accvgpr_read_b32 v5, a14
		v_add_u32_e32 v5, s1, v5
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v4
		v_xor_b32_e32 v1, v1, v6
		v_bitop3_b32 v1, v1, v9, v12 bitop3:0x96
		v_bitop3_b32 v1, v1, v14, v16 bitop3:0x96
		v_accvgpr_write_b32 a15, v1
		v_accvgpr_read_b32 v1, a15
		v_add_u32_e32 v1, s1, v1
		v_cmp_lt_i32_e64 vcc, v5, s20
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_i32_e64 vcc, v1, s20
		s_mov_b64 s[24:25], vcc
		v_mov_b32_e32 v4, s24
		v_mov_b32_e32 v5, s25
		v_accvgpr_write_b32 a16, v4
		v_accvgpr_write_b32 a17, v5
		v_mov_b32_e32 v1, 2
		v_mul_lo_u32 v1, v1, v11
		v_lshrrev_b32_e32 v4, 5, v0
		v_and_b32_e32 v5, 1, v4
		v_accvgpr_write_b32 a18, v5
		v_accvgpr_read_b32 v5, a18
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v5, v8, v1, v6 bitop3:0x96
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v13
		v_xor_b32_e32 v5, v5, v9
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v15
		v_xad_u32 v5, v5, v12, s1
		v_bitop3_b32 v14, 32, v8, v1 bitop3:0x96
		v_bitop3_b32 v14, v14, v6, v9 bitop3:0x96
		v_xad_u32 v14, v14, v12, s1
		v_bitop3_b32 v16, 64, v8, v1 bitop3:0x96
		v_bitop3_b32 v16, v16, v6, v9 bitop3:0x96
		v_xad_u32 v16, v16, v12, s1
		v_xor_b32_e32 v17, 0x60, v8
		v_xor_b32_e32 v17, v17, v1
		v_xor_b32_e32 v17, v17, v6
		v_xor_b32_e32 v17, v17, v9
		v_xad_u32 v17, v17, v12, s1
		v_xor_b32_e32 v18, 0x80, v8
		v_xor_b32_e32 v18, v18, v1
		v_xor_b32_e32 v18, v18, v6
		v_xor_b32_e32 v18, v18, v9
		v_xad_u32 v18, v18, v12, s1
		v_xor_b32_e32 v19, 0xa0, v8
		v_xor_b32_e32 v19, v19, v1
		v_xor_b32_e32 v19, v19, v6
		v_xor_b32_e32 v19, v19, v9
		v_xad_u32 v19, v19, v12, s1
		v_xor_b32_e32 v20, 0xc0, v8
		v_xor_b32_e32 v20, v20, v1
		v_xor_b32_e32 v20, v20, v6
		v_xor_b32_e32 v20, v20, v9
		v_xad_u32 v20, v20, v12, s1
		v_xor_b32_e32 v21, 0xe0, v8
		v_xor_b32_e32 v1, v21, v1
		v_xor_b32_e32 v1, v1, v6
		v_xor_b32_e32 v1, v1, v9
		v_xad_u32 v1, v1, v12, s1
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v9, a6
		v_and_b32_e32 v9, 0xffff, v9
		v_lshlrev_b32_e32 v12, 16, v9
		v_or_b32_e32 v24, v9, v12
		v_mov_b32_e32 v25, v24
		v_mov_b32_e32 v26, v24
		v_mov_b32_e32 v27, v24
		v_accvgpr_read_b32 v9, a12
		s_nop 0
		v_readfirstlane_b32 s19, v9
		s_mul_i32 s19, s19, s12
		s_lshl_b32 s19, s19, 9
		v_accvgpr_read_b32 v9, a10
		s_nop 0
		v_readfirstlane_b32 s28, v9
		s_mul_i32 s28, s28, s10
		s_lshl_b32 s28, s28, 1
		s_add_i32 s29, s19, s28
		v_accvgpr_read_b32 v9, a11
		s_nop 0
		v_readfirstlane_b32 s30, v9
		s_mul_i32 s30, s30, s11
		s_lshl_b32 s30, s30, 1
		s_add_i32 s29, s29, s30
		v_mul_lo_u32 v9, s12, v7
		v_lshl_add_u32 v12, v9, 1, s29
		v_and_b32_e32 v21, 1, v0
		v_accvgpr_write_b32 a19, v21
		v_accvgpr_read_b32 v21, a19
		v_lshl_add_u32 v12, v21, 4, v12
		v_and_b32_e32 v21, 1, v3
		v_accvgpr_write_b32 a20, v21
		v_accvgpr_read_b32 v21, a20
		v_lshl_add_u32 v12, v21, 6, v12
		v_and_b32_e32 v2, 1, v2
		v_accvgpr_write_b32 a21, v2
		v_accvgpr_read_b32 v2, a21
		v_lshl_add_u32 v2, v2, 5, v12
		v_cmp_lt_i32_e64 vcc, v5, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[28:31], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v28, v24
		v_mov_b32_e32 v29, v25
		v_mov_b32_e32 v30, v26
		v_mov_b32_e32 v31, v27
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s29, s12, 6
		s_add_i32 s29, s29, s19
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v2, v9, 1, s29
		v_accvgpr_read_b32 v5, a19
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a20
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a21
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v14, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[32:35], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v32, v24
		v_mov_b32_e32 v33, v25
		v_mov_b32_e32 v34, v26
		v_mov_b32_e32 v35, v27
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s29, s12, 7
		s_add_i32 s29, s29, s19
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v2, v9, 1, s29
		v_accvgpr_read_b32 v5, a19
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a20
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a21
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v16, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[36:39], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v36, v24
		v_mov_b32_e32 v37, v25
		v_mov_b32_e32 v38, v26
		v_mov_b32_e32 v39, v27
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s29, 0xc0, s12
		s_add_i32 s29, s29, s19
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v2, v9, 1, s29
		v_accvgpr_read_b32 v5, a19
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a20
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a21
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v17, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[40:43], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v40, v24
		v_mov_b32_e32 v41, v25
		v_mov_b32_e32 v42, v26
		v_mov_b32_e32 v43, v27
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s29, s12, 8
		s_add_i32 s29, s29, s19
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v2, v9, 1, s29
		v_accvgpr_read_b32 v5, a19
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a20
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a21
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v18, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[44:47], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v44, v24
		v_mov_b32_e32 v45, v25
		v_mov_b32_e32 v46, v26
		v_mov_b32_e32 v47, v27
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s29, 0x140, s12
		s_add_i32 s29, s29, s19
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v2, v9, 1, s29
		v_accvgpr_read_b32 v5, a19
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a20
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a21
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v19, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[16:19], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v16, v24
		v_mov_b32_e32 v17, v25
		v_mov_b32_e32 v18, v26
		v_mov_b32_e32 v19, v27
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s29, 0x180, s12
		s_add_i32 s29, s29, s19
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v2, v9, 1, s29
		v_accvgpr_read_b32 v5, a19
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a20
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a21
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v20, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[20:23], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v20, v24
		v_mov_b32_e32 v21, v25
		v_mov_b32_e32 v22, v26
		v_mov_b32_e32 v23, v27
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s29, 0x1c0, s12
		s_add_i32 s19, s29, s19
		s_add_i32 s19, s19, s28
		s_add_i32 s19, s19, s30
		v_lshl_add_u32 v2, v9, 1, s19
		v_accvgpr_read_b32 v5, a19
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a20
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a21
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v1, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[48:51], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v48, v24
		v_mov_b32_e32 v49, v25
		v_mov_b32_e32 v50, v26
		v_mov_b32_e32 v51, v27
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
		v_accvgpr_read_b32 v1, a13
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 2, v1
		v_and_b32_e32 v2, 1, v4
		v_accvgpr_write_b32 a22, v2
		v_accvgpr_read_b32 v2, a22
		v_lshlrev_b32_e32 v2, 1, v2
		v_and_b32_e32 v4, 1, v10
		v_accvgpr_write_b32 a23, v4
		v_accvgpr_read_b32 v4, a23
		v_xor_b32_e32 v4, v0, v4
		v_bitop3_b32 v1, v1, v2, v4 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[28:31] offset:2480
		ds_write_b128 v1, v[32:35] offset:6576
		ds_write_b128 v1, v[36:39] offset:10672
		ds_write_b128 v1, v[40:43] offset:14768
		v_accvgpr_read_b32 v2, a13
		v_lshlrev_b32_e32 v2, 12, v2
		v_add_u32_e32 v2, 0x10000, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 3, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v9, 6, v5
		v_add_u32_e32 v10, v2, v9
		v_lshrrev_b32_e32 v12, 2, v4
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v14, 5, v12
		v_add_u32_e32 v24, v10, v14
		v_lshrrev_b32_e32 v25, 5, v4
		v_accvgpr_write_b32 a24, v25
		v_lshrrev_b32_e32 v25, 4, v4
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 7, v25
		v_lshrrev_b32_e32 v26, 1, v4
		v_and_b32_e32 v26, 1, v26
		v_lshlrev_b32_e32 v27, 4, v26
		v_and_b32_e32 v28, 1, v4
		v_lshlrev_b32_e32 v28, 3, v28
		v_add3_u32 v29, v25, v9, v14
		v_add_u32_e32 v29, v29, v27
		v_accvgpr_read_b32 v30, a24
		v_add3_u32 v30, v30, v28, v29
		v_xor_b32_e32 v30, v30, v26
		v_lshl_add_u32 v24, v30, 4, v24
		ds_read_b128 a[28:31], v24 offset:2480
		v_lshlrev_b32_e32 v12, 1, v12
		v_accvgpr_read_b32 v30, a24
		v_add_u32_e32 v30, 2, v30
		v_add3_u32 v30, v30, v28, v29
		v_bitop3_b32 v30, v12, v30, v26 bitop3:0x96
		v_lshl_add_u32 v10, v30, 4, v10
		ds_read_b128 a[32:35], v10 offset:2480
		v_accvgpr_read_b32 v30, a24
		v_add_u32_e32 v30, 4, v30
		v_add3_u32 v29, v30, v28, v29
		v_xad_u32 v29, v29, v26, v12
		v_lshlrev_b32_e32 v5, 2, v5
		v_xor_b32_e32 v29, v29, v5
		v_lshl_add_u32 v29, v29, 4, v2
		ds_read_b128 a[36:39], v29 offset:2480
		v_accvgpr_read_b32 v30, a24
		v_add_u32_e32 v30, 6, v30
		v_add_u32_e32 v25, v30, v25
		v_add3_u32 v9, v25, v9, v14
		v_add3_u32 v9, v9, v27, v28
		v_xor_b32_e32 v9, v9, v26
		v_bitop3_b32 v5, v5, v12, v9 bitop3:0x96
		v_lshl_add_u32 v2, v5, 4, v2
		ds_read_b128 a[40:43], v2 offset:2480
		v_accvgpr_read_b32 v5, a12
		s_nop 0
		v_readfirstlane_b32 s19, v5
		s_add_i32 s19, s19, 1
		s_mul_i32 s19, s19, 0x100
		s_mov_b32 s24, 0x7f
		v_mov_b32_e32 v5, 64
		v_mul_lo_u32 v5, v5, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[44:47] offset:2480
		ds_write_b128 v1, v[16:19] offset:6576
		ds_write_b128 v1, v[20:23] offset:10672
		ds_write_b128 v1, v[48:51] offset:14768
		v_mov_b32_e32 v1, 32
		v_mul_lo_u32 v1, v1, v11
		v_accvgpr_read_b32 v9, a18
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[44:47], v24 offset:2480
		ds_read_b128 a[48:51], v10 offset:2480
		ds_read_b128 a[52:55], v29 offset:2480
		ds_read_b128 a[56:59], v2 offset:2480
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_add_i32 s19, s19, s25
		s_cmp_lt_i32 s21, s19
		s_cselect_b32 s19, s21, s19
		s_add_i32 s25, s19, 0x7f
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s36, s24, 0
		s_add_i32 s25, s25, s36
		s_ashr_i32 s25, s25, 7
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s36, v2
		s_add_i32 s36, s1, s36
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s37, s24, 0
		s_add_i32 s36, s36, s37
		s_ashr_i32 s36, s36, 7
		s_cmp_lt_i32 s36, s25
		s_cselect_b32 s36, s36, s25
		s_cmp_gt_i32 s36, 0
		s_cselect_b32 s36, s36, 0
		v_bitop3_b32 v2, v5, v1, v11 bitop3:0x96
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v15
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a25, v2
		v_bitop3_b32 v2, 4, v5, v1 bitop3:0x96
		v_xor_b32_e32 v2, v2, v11
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a26, v2
		v_bitop3_b32 v2, 8, v5, v1 bitop3:0x96
		v_xor_b32_e32 v2, v2, v11
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a27, v2
		v_bitop3_b32 v2, 12, v5, v1 bitop3:0x96
		v_xor_b32_e32 v2, v2, v11
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a60, v2
		v_accvgpr_read_b32 v2, a25
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v2, a26
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v2, a27
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v2, a60
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[44:45], vcc
		v_mov_b32_e32 v2, 16
		v_mul_lo_u32 v2, v2, v8
		v_accvgpr_read_b32 v5, a18
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v5
		v_bitop3_b32 v5, v2, v1, v8 bitop3:0x96
		v_bitop3_b32 v5, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a61, v5
		v_bitop3_b32 v5, 4, v2, v1 bitop3:0x96
		v_xor_b32_e32 v5, v5, v8
		v_bitop3_b32 v5, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a62, v5
		v_bitop3_b32 v5, 8, v2, v1 bitop3:0x96
		v_xor_b32_e32 v5, v5, v8
		v_bitop3_b32 v5, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a63, v5
		v_bitop3_b32 v1, 12, v2, v1 bitop3:0x96
		v_accvgpr_read_b32 v2, a61
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v2, a62
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v2, a63
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[50:51], vcc
		v_readfirstlane_b32 s52, v0
		v_accvgpr_read_b32 v2, a13
		v_mul_lo_u32 v2, s15, v2
		v_accvgpr_read_b32 v5, a22
		v_mul_lo_u32 v5, s15, v5
		v_lshlrev_b32_e32 v5, 5, v5
		v_lshl_add_u32 v2, v2, 1, v5
		v_accvgpr_read_b32 v5, a23
		v_mul_lo_u32 v5, s15, v5
		v_lshl_add_u32 v2, v5, 6, v2
		v_and_b32_e32 v5, 1, v7
		v_accvgpr_write_b32 a64, v5
		v_accvgpr_read_b32 v5, a64
		v_mul_lo_u32 v5, s15, v5
		v_lshlrev_b32_e32 v5, 7, v5
		v_accvgpr_read_b32 v7, a19
		v_lshlrev_b32_e32 v7, 4, v7
		v_add3_u32 v2, v2, v5, v7
		v_accvgpr_read_b32 v5, a20
		v_lshlrev_b32_e32 v5, 6, v5
		v_accvgpr_read_b32 v10, a21
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v2, v2, v5, v10
		v_accvgpr_read_b32 v11, a10
		s_nop 0
		v_readfirstlane_b32 s37, v11
		s_mul_i32 s37, s37, s13
		s_lshl_b32 s37, s37, 1
		v_accvgpr_read_b32 v11, a11
		s_nop 0
		v_readfirstlane_b32 s53, v11
		s_mul_i32 s53, s53, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s54, s37, s53
		v_add_u32_e32 v11, s54, v2
		v_mov_b32_e32 v12, 0x80000000
		v_cndmask_b32_e64 v11, v12, v11, s[38:39]
		s_lshr_b32 s38, s52, 6
		s_mul_i32 s39, 0x410, s38
		s_mov_b32 m0, s39
		v_xor_b32_e32 v1, v1, v8
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v1, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a65, v1
		s_lshl_b32 s54, s15, 3
		s_add_i32 s54, s54, s37
		s_add_i32 s54, s54, s53
		v_add_u32_e32 v1, s54, v2
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v1, v12, v1, s[40:41]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_lshl_b32 s40, s15, 4
		s_add_i32 s40, s40, s37
		s_add_i32 s40, s40, s53
		v_add_u32_e32 v1, s40, v2
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v1, v12, v1, s[42:43]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_mul_i32 s40, 24, s15
		s_add_i32 s40, s40, s37
		s_add_i32 s40, s40, s53
		v_add_u32_e32 v1, s40, v2
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v1, v12, v1, s[44:45]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v1, a13
		v_mul_lo_u32 v1, s17, v1
		v_accvgpr_read_b32 v8, a22
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 7, v8
		v_lshl_add_u32 v1, v1, 1, v8
		v_accvgpr_read_b32 v8, a23
		v_mul_lo_u32 v8, s17, v8
		v_lshl_add_u32 v1, v8, 6, v1
		v_accvgpr_read_b32 v8, a64
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 5, v8
		v_add3_u32 v1, v1, v8, v7
		v_add3_u32 v1, v1, v5, v10
		v_accvgpr_read_b32 v5, a0
		s_nop 0
		v_readfirstlane_b32 s40, v5
		v_accvgpr_read_b32 v5, a10
		s_nop 0
		v_readfirstlane_b32 s41, v5
		s_mul_i32 s40, s41, s40
		s_lshl_b32 s40, s40, 1
		v_accvgpr_read_b32 v5, a1
		s_nop 0
		v_readfirstlane_b32 s41, v5
		v_accvgpr_read_b32 v5, a11
		s_nop 0
		v_readfirstlane_b32 s42, v5
		s_mul_i32 s41, s42, s41
		s_lshl_b32 s41, s41, 1
		s_add_i32 s42, s40, s41
		v_add_u32_e32 v5, s42, v1
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_cndmask_b32_e64 v5, v12, v5, s[46:47]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_lshl_b32 s42, s17, 3
		s_add_i32 s42, s42, s40
		s_add_i32 s42, s42, s41
		v_add_u32_e32 v5, s42, v1
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v5, v12, v5, s[48:49]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_lshl_b32 s42, s17, 4
		s_add_i32 s42, s42, s40
		s_add_i32 s42, s42, s41
		v_add_u32_e32 v5, s42, v1
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v5, v12, v5, s[50:51]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_mul_i32 s42, 24, s17
		s_add_i32 s42, s42, s40
		s_add_i32 s42, s42, s41
		v_accvgpr_read_b32 v5, a65
		v_cmp_lt_i32_e64 vcc, v5, s21
		v_add_u32_e32 v5, s42, v1
		v_mbcnt_lo_u32_b32 v7, -1, 0
		v_cndmask_b32_e32 v5, v12, v5, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s42, s36, 0x80
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_mbcnt_hi_u32_b32 v5, -1, v7
		v_and_b32_e32 v7, 1, v5
		v_lshrrev_b32_e32 v8, 4, v5
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 4, v8
		v_lshrrev_b32_e32 v9, 3, v5
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_add3_u32 v10, v7, v8, v9
		v_lshrrev_b32_e32 v11, 2, v5
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 2, v11
		v_lshrrev_b32_e32 v5, 1, v5
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 1, v5
		v_add3_u32 v10, v10, v11, v5
		v_add_u32_e32 v7, 32, v7
		v_bitop3_b32 v5, v11, v7, v5 bitop3:0x96
		v_bitop3_b32 v5, v8, v9, v5 bitop3:0x96
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s36, 0xff800000
		v_mov_b32_e32 v7, s36
		v_mov_b32_e32 v11, s36
		s_mov_b32 s36, 1.0
		v_mov_b32_e32 v14, s36
		v_mov_b32_e32 v15, s36
		s_mov_b32 s36, 0
		v_accvgpr_read_b32 v13, a24
		v_lshlrev_b32_e32 v13, 4, v13
		v_accvgpr_write_b32 a66, v13
		v_and_b32_e32 v4, 31, v4
		v_lshrrev_b32_e32 v13, 4, v4
		v_lshlrev_b32_e32 v13, 9, v13
		v_accvgpr_write_b32 a67, v13
		v_lshrrev_b32_e32 v13, 3, v4
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v16, 0x2080
		v_mul_lo_u32 v16, v16, v13
		v_accvgpr_write_b32 a68, v16
		v_lshrrev_b32_e32 v13, 2, v4
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v16, 0x1040
		v_mul_lo_u32 v16, v16, v13
		v_accvgpr_write_b32 a69, v16
		v_lshrrev_b32_e32 v13, 1, v4
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v16, 0x820
		v_mul_lo_u32 v16, v16, v13
		v_accvgpr_write_b32 a70, v16
		v_and_b32_e32 v4, 1, v4
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v4
		v_accvgpr_write_b32 a71, v13
		v_and_b32_e32 v4, 3, v0
		v_accvgpr_write_b32 a72, v4
		v_accvgpr_read_b32 v4, a72
		v_lshlrev_b32_e32 v4, 3, v4
		v_accvgpr_write_b32 a73, v4
		v_accvgpr_read_b32 v4, a22
		v_mov_b32_e32 v13, 0x2200
		v_mul_lo_u32 v13, v13, v4
		v_accvgpr_write_b32 a74, v13
		v_accvgpr_read_b32 v4, a23
		v_lshlrev_b32_e32 v4, 5, v4
		v_accvgpr_write_b32 a75, v4
		v_and_b32_e32 v3, 3, v3
		v_mov_b32_e32 v4, 0x440
		v_mul_lo_u32 v4, v4, v3
		v_accvgpr_write_b32 a76, v4
		s_lshl_b32 s43, s15, 8
		s_add_i32 s43, s43, s37
		s_add_i32 s43, s43, s53
		s_mul_i32 s44, 0x108, s15
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s53
		s_mul_i32 s45, 0x110, s15
		s_add_i32 s45, s45, s37
		s_add_i32 s45, s45, s53
		s_mul_i32 s46, 0x118, s15
		s_add_i32 s37, s46, s37
		s_add_i32 s37, s37, s53
		s_lshl_b32 s46, s17, 8
		s_add_i32 s46, s46, s40
		s_add_i32 s46, s46, s41
		s_mul_i32 s47, 0x108, s17
		s_add_i32 s47, s47, s40
		s_add_i32 s47, s47, s41
		s_mul_i32 s48, 0x110, s17
		s_add_i32 s48, s48, s40
		s_add_i32 s48, s48, s41
		s_mul_i32 s49, 0x118, s17
		s_add_i32 s40, s49, s40
		s_add_i32 s40, s40, s41
		v_lshlrev_b32_e32 v3, 2, v10
		v_accvgpr_write_b32 a77, v3
		v_lshlrev_b32_e32 v3, 2, v5
		v_accvgpr_write_b32 a78, v3
		s_cmp_lt_i32 0, s42
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_mov_b64_e32 v[20:21], 0
		v_mov_b64_e32 v[22:23], 0
		v_mov_b64_e32 v[24:25], 0
		v_mov_b64_e32 v[26:27], 0
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_1
.L_attn_fwd_persistent.loop_head_1:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s41, s36, 7
		s_and_b32 s49, s41, 1
		s_mul_i32 s50, 0x4100, s49
		v_accvgpr_read_b32 v3, a66
		v_accvgpr_read_b32 v4, a67
		v_add3_u32 v3, s50, v3, v4
		v_accvgpr_read_b32 v4, a68
		v_accvgpr_read_b32 v5, a69
		v_add3_u32 v3, v3, v4, v5
		v_accvgpr_read_b32 v4, a70
		v_accvgpr_read_b32 v5, a71
		v_add3_u32 v3, v3, v4, v5
		ds_read_b128 v[80:83], v3
		ds_read_b128 a[80:83], v3 offset:32
		ds_read_b128 a[84:87], v3 offset:64
		ds_read_b128 a[88:91], v3 offset:96
		ds_read_b128 v[84:87], v3 offset:256
		ds_read_b128 a[92:95], v3 offset:288
		ds_read_b128 a[96:99], v3 offset:320
		ds_read_b128 a[100:103], v3 offset:352
		ds_read_b128 a[104:107], v3 offset:128
		ds_read_b128 a[108:111], v3 offset:160
		ds_read_b128 a[112:115], v3 offset:192
		ds_read_b128 a[116:119], v3 offset:224
		ds_read_b128 v[88:91], v3 offset:384
		ds_read_b128 a[120:123], v3 offset:416
		ds_read_b128 a[124:127], v3 offset:448
		ds_read_b128 a[128:131], v3 offset:480
		s_mul_i32 s49, 0x4400, s49
		v_accvgpr_read_b32 v3, a73
		v_accvgpr_read_b32 v4, a74
		v_add3_u32 v3, s49, v3, v4
		v_accvgpr_read_b32 v4, a75
		v_accvgpr_read_b32 v5, a76
		v_add3_u32 v3, v3, v4, v5
		ds_read_b64_tr_b16 a[132:133], v3 offset:33264
		ds_read_b64_tr_b16 a[134:135], v3 offset:37616
		ds_read_b64_tr_b16 a[136:137], v3 offset:33392
		ds_read_b64_tr_b16 a[138:139], v3 offset:37744
		ds_read_b64_tr_b16 a[140:141], v3 offset:33520
		ds_read_b64_tr_b16 a[142:143], v3 offset:37872
		ds_read_b64_tr_b16 a[144:145], v3 offset:33648
		ds_read_b64_tr_b16 a[146:147], v3 offset:38000
		ds_read_b64_tr_b16 a[148:149], v3 offset:33776
		ds_read_b64_tr_b16 a[150:151], v3 offset:38128
		ds_read_b64_tr_b16 a[152:153], v3 offset:33904
		ds_read_b64_tr_b16 a[154:155], v3 offset:38256
		ds_read_b64_tr_b16 a[156:157], v3 offset:34032
		ds_read_b64_tr_b16 a[158:159], v3 offset:38384
		ds_read_b64_tr_b16 a[160:161], v3 offset:34160
		ds_read_b64_tr_b16 a[162:163], v3 offset:38512
		ds_read_b64_tr_b16 a[164:165], v3 offset:33328
		ds_read_b64_tr_b16 a[166:167], v3 offset:37680
		ds_read_b64_tr_b16 a[168:169], v3 offset:33456
		ds_read_b64_tr_b16 a[170:171], v3 offset:37808
		ds_read_b64_tr_b16 a[172:173], v3 offset:33584
		ds_read_b64_tr_b16 a[174:175], v3 offset:37936
		ds_read_b64_tr_b16 a[176:177], v3 offset:33712
		ds_read_b64_tr_b16 a[178:179], v3 offset:38064
		ds_read_b64_tr_b16 a[180:181], v3 offset:33840
		ds_read_b64_tr_b16 a[182:183], v3 offset:38192
		ds_read_b64_tr_b16 a[184:185], v3 offset:33968
		ds_read_b64_tr_b16 a[186:187], v3 offset:38320
		ds_read_b64_tr_b16 a[188:189], v3 offset:34096
		ds_read_b64_tr_b16 a[190:191], v3 offset:38448
		ds_read_b64_tr_b16 a[192:193], v3 offset:34224
		ds_read_b64_tr_b16 a[194:195], v3 offset:38576
		s_mul_i32 s49, s15, s36
		s_lshl_b32 s49, s49, 1
		s_add_i32 s50, s43, s49
		v_add_u32_e32 v3, s50, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v4, s49, v2
		s_add_i32 s41, s41, 1
		v_add_u32_e32 v5, s44, v4
		s_and_b32 s41, s41, 1
		v_add_u32_e32 v10, s45, v4
		s_mul_i32 s49, 0x4100, s41
		v_add_u32_e32 v4, s37, v4
		s_add_i32 s49, s39, s49
		v_mfma_f32_32x32x16_bf16 v[96:111], v[80:83], a[28:31], 0
		s_mov_b32 m0, s49
		v_mfma_f32_32x32x16_bf16 v[112:127], v[84:87], a[28:31], 0
		s_mul_i32 s49, s17, s36
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], a[28:31], 0
		s_add_i32 s36, s36, 0x80
		v_mfma_f32_32x32x16_bf16 v[144:159], v[88:91], a[28:31], 0
		v_accvgpr_read_b32 v13, a25
		v_add_u32_e32 v13, s36, v13
		v_mfma_f32_32x32x16_bf16 v[160:175], v[88:91], a[44:47], 0
		v_accvgpr_read_b32 v88, a26
		v_add_u32_e32 v88, s36, v88
		v_mfma_f32_32x32x16_bf16 v[176:191], v[80:83], a[44:47], 0
		v_accvgpr_read_b32 v80, a27
		v_add_u32_e32 v80, s36, v80
		v_mfma_f32_32x32x16_bf16 v[192:207], v[84:87], a[44:47], 0
		v_accvgpr_read_b32 v81, a60
		v_add_u32_e32 v81, s36, v81
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[44:47], 0
		v_cmp_lt_i32_e64 vcc, v13, s21
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], a[32:35], v[96:111]
		v_cmp_lt_i32_e64 vcc, v88, s21
		s_mov_b64 s[54:55], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[32:35], v[112:127]
		v_cmp_lt_i32_e64 vcc, v80, s21
		s_mov_b64 s[56:57], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[108:111], a[32:35], v[128:143]
		v_cmp_lt_i32_e64 vcc, v81, s21
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[120:123], a[32:35], v[144:159]
		v_accvgpr_read_b32 v13, a61
		v_add_u32_e32 v13, s36, v13
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[48:51], v[160:175]
		v_accvgpr_read_b32 v80, a62
		v_add_u32_e32 v80, s36, v80
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[48:51], v[176:191]
		v_accvgpr_read_b32 v81, a63
		v_add_u32_e32 v81, s36, v81
		v_mfma_f32_32x32x16_bf16 v[192:207], a[92:95], a[48:51], v[192:207]
		v_cmp_lt_i32_e64 vcc, v13, s21
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[108:111], a[48:51], v[208:223]
		v_cmp_lt_i32_e64 vcc, v80, s21
		s_mov_b64 s[62:63], vcc
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[36:39], v[96:111]
		v_cmp_lt_i32_e64 vcc, v81, s21
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], a[36:39], v[112:127]
		v_cndmask_b32_e64 v3, v12, v3, s[50:51]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], a[36:39], v[128:143]
		v_accvgpr_read_b32 v3, a65
		v_add_u32_e32 v3, s36, v3
		v_cndmask_b32_e64 v5, v12, v5, s[54:55]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v10, v12, v10, s[56:57]
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v4, v12, v4, s[58:59]
		v_cmp_lt_i32_e64 vcc, v3, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s49, s49, 1
		s_add_i32 s50, s46, s49
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_add_u32_e32 v3, s50, v1
		v_cndmask_b32_e64 v3, v12, v3, s[60:61]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s41, 0x4400, s41
		s_add_i32 s41, s38, s41
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_add_u32_e32 v4, s49, v1
		v_add_u32_e32 v5, s47, v4
		s_add_i32 m0, s41, 0x81f0
		v_cndmask_b32_e64 v5, v12, v5, s[62:63]
		v_add_u32_e32 v10, s48, v4
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v3, v12, v10, s[64:65]
		v_add_u32_e32 v4, s40, v4
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v4, v12, v4, vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[124:127], a[36:39], v[144:159]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[52:55], v[160:175]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[96:99], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[52:55], v[208:223]
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[96:111], a[88:91], a[40:43], v[96:111]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s36, s42
		v_mfma_f32_32x32x16_bf16 v[112:127], a[100:103], a[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[116:119], a[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], a[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[128:131], a[56:59], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[88:91], a[56:59], v[176:191]
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[100:103], a[56:59], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[116:119], a[56:59], v[208:223]
		s_nop 1
		v_max3_f32 v3, v96, v97, v98
		v_max3_f32 v4, v100, v101, v102
		v_max3_f32 v5, v104, v105, v106
		v_max3_f32 v10, v108, v109, v110
		v_max3_f32 v13, v112, v113, v114
		v_max3_f32 v80, v116, v117, v118
		v_max3_f32 v81, v120, v121, v122
		v_max3_f32 v82, v124, v125, v126
		v_max3_f32 v83, v128, v129, v130
		v_max3_f32 v84, v132, v133, v134
		v_max3_f32 v85, v136, v137, v138
		v_max3_f32 v86, v140, v141, v142
		v_max3_f32 v87, v144, v145, v146
		v_max3_f32 v88, v148, v149, v150
		v_max3_f32 v89, v152, v153, v154
		v_max3_f32 v90, v156, v157, v158
		v_max3_f32 v3, v3, v99, v4
		v_max3_f32 v4, v5, v107, v10
		v_max3_f32 v5, v13, v115, v80
		v_max3_f32 v10, v81, v123, v82
		v_max3_f32 v13, v83, v131, v84
		v_max3_f32 v80, v85, v139, v86
		v_max3_f32 v81, v87, v147, v88
		v_max3_f32 v82, v89, v155, v90
		v_max3_f32 v3, v3, v103, v4
		v_max3_f32 v4, v5, v119, v10
		v_max3_f32 v5, v13, v135, v80
		v_max3_f32 v10, v81, v151, v82
		v_max3_f32 v3, v3, v111, v4
		v_max3_f32 v4, v5, v143, v10
		v_max3_f32 v3, v3, v127, v4
		v_max_f32_e32 v3, v3, v159
		v_mov_b32_e32 v4, v3
		v_mov_b32_e32 v5, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v4, v5
		v_max_f32_e32 v80, v4, v5
		v_max3_f32 v3, v176, v177, v178
		v_max3_f32 v4, v180, v181, v182
		v_max3_f32 v5, v184, v185, v186
		v_max3_f32 v10, v188, v189, v190
		v_max3_f32 v13, v192, v193, v194
		v_max3_f32 v81, v196, v197, v198
		v_max3_f32 v82, v200, v201, v202
		v_max3_f32 v83, v204, v205, v206
		v_max3_f32 v84, v208, v209, v210
		v_max3_f32 v85, v212, v213, v214
		v_max3_f32 v86, v216, v217, v218
		v_max3_f32 v87, v220, v221, v222
		v_max3_f32 v88, v160, v161, v162
		v_max3_f32 v89, v164, v165, v166
		v_max3_f32 v90, v168, v169, v170
		v_max3_f32 v91, v172, v173, v174
		v_max3_f32 v3, v3, v179, v4
		v_max3_f32 v4, v5, v187, v10
		v_max3_f32 v5, v13, v195, v81
		v_max3_f32 v10, v82, v203, v83
		v_max3_f32 v13, v84, v211, v85
		v_max3_f32 v81, v86, v219, v87
		v_max3_f32 v82, v88, v163, v89
		v_max3_f32 v83, v90, v171, v91
		v_max3_f32 v3, v3, v183, v4
		v_max3_f32 v4, v5, v199, v10
		v_max3_f32 v5, v13, v215, v81
		v_max3_f32 v10, v82, v167, v83
		v_max3_f32 v3, v3, v191, v4
		v_max3_f32 v4, v5, v223, v10
		v_max3_f32 v3, v3, v207, v4
		v_max_f32_e32 v3, v3, v175
		v_mov_b32_e32 v4, v3
		v_mov_b32_e32 v5, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v4, v5
		v_max_f32_e32 v81, v4, v5
		v_pk_mul_f32 v[4:5], v[80:81], v[8:9]
		v_max_f32_e32 v80, v7, v4
		v_max_f32_e32 v81, v11, v5
		v_pk_fma_f32 v[4:5], v[96:97], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[82:83], v[98:99], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[84:85], v[100:101], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[86:87], v[102:103], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[88:89], v[104:105], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[90:91], v[106:107], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[92:93], v[108:109], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[94:95], v[110:111], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[112:113], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[114:115], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[116:117], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[118:119], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[120:121], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[122:123], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[124:125], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[126:127], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[128:129], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[130:131], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[132:133], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[134:135], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[136:137], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[138:139], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[140:141], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[142:143], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[144:145], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[146:147], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[148:149], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[150:151], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[152:153], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[154:155], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[156:157], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[158:159], v[8:9], v[80:81] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[176:177], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[178:179], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[180:181], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[182:183], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[184:185], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[186:187], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[188:189], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[190:191], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[192:193], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[194:195], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[196:197], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[198:199], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[200:201], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[202:203], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[204:205], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[206:207], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[208:209], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[210:211], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[212:213], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[214:215], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[216:217], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[218:219], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[220:221], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[222:223], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[160:161], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[8:9], v[80:81] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v174, v4
		v_exp_f32_e32 v210, v5
		v_exp_f32_e32 v175, v82
		v_exp_f32_e32 v211, v83
		v_exp_f32_e32 v4, v84
		v_exp_f32_e32 v82, v85
		v_exp_f32_e32 v5, v86
		v_exp_f32_e32 v83, v87
		v_exp_f32_e32 v84, v88
		v_exp_f32_e32 v86, v89
		v_exp_f32_e32 v85, v90
		v_exp_f32_e32 v87, v91
		v_exp_f32_e32 v88, v92
		v_exp_f32_e32 v90, v93
		v_exp_f32_e32 v89, v94
		v_exp_f32_e32 v91, v95
		v_exp_f32_e32 v92, v96
		v_exp_f32_e32 v94, v97
		v_exp_f32_e32 v93, v98
		v_exp_f32_e32 v95, v99
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
		v_exp_f32_e32 v108, v112
		v_exp_f32_e32 v110, v113
		v_exp_f32_e32 v109, v114
		v_exp_f32_e32 v111, v115
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
		v_exp_f32_e32 v141, v144
		v_exp_f32_e32 v143, v145
		v_exp_f32_e32 v144, v146
		v_exp_f32_e32 v212, v147
		v_exp_f32_e32 v145, v148
		v_exp_f32_e32 v213, v149
		v_exp_f32_e32 v146, v150
		v_exp_f32_e32 v148, v151
		v_exp_f32_e32 v147, v152
		v_exp_f32_e32 v149, v153
		v_exp_f32_e32 v150, v154
		v_exp_f32_e32 v152, v155
		v_exp_f32_e32 v151, v156
		v_exp_f32_e32 v153, v157
		v_exp_f32_e32 v154, v158
		v_exp_f32_e32 v156, v159
		v_exp_f32_e32 v155, v176
		v_exp_f32_e32 v157, v177
		v_exp_f32_e32 v158, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v159, v180
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
		v_exp_f32_e32 v206, v160
		v_exp_f32_e32 v208, v161
		v_exp_f32_e32 v207, v162
		v_exp_f32_e32 v209, v163
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
		v_pk_add_f32 v[172:173], v[174:175], v[210:211]
		v_pk_add_f32 v[214:215], v[4:5], v[82:83]
		v_pk_add_f32 v[216:217], v[84:85], v[86:87]
		v_pk_add_f32 v[218:219], v[88:89], v[90:91]
		v_pk_add_f32 v[220:221], v[92:93], v[94:95]
		v_pk_add_f32 v[222:223], v[96:97], v[98:99]
		v_pk_add_f32 v[224:225], v[100:101], v[102:103]
		v_pk_add_f32 v[226:227], v[104:105], v[106:107]
		v_pk_add_f32 v[228:229], v[108:109], v[110:111]
		v_pk_add_f32 v[230:231], v[112:113], v[114:115]
		v_pk_add_f32 v[232:233], v[116:117], v[118:119]
		v_pk_add_f32 v[234:235], v[120:121], v[122:123]
		v_pk_add_f32 v[236:237], v[124:125], v[126:127]
		v_pk_add_f32 v[238:239], v[128:129], v[130:131]
		v_pk_add_f32 v[240:241], v[132:133], v[134:135]
		v_pk_add_f32 v[242:243], v[136:137], v[138:139]
		v_mov_b32_e32 v244, v173
		v_mov_b32_e32 v245, v215
		v_mov_b32_e32 v246, v172
		v_mov_b32_e32 v247, v214
		v_pk_add_f32 v[172:173], v[246:247], v[244:245]
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
		v_mov_b32_e32 v214, v173
		v_mov_b32_e32 v215, v217
		v_mov_b32_e32 v218, v172
		v_mov_b32_e32 v219, v216
		v_pk_add_f32 v[172:173], v[218:219], v[214:215]
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
		v_mov_b32_e32 v214, v173
		v_mov_b32_e32 v215, v219
		v_mov_b32_e32 v216, v172
		v_mov_b32_e32 v217, v218
		v_pk_add_f32 v[172:173], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v221
		v_mov_b32_e32 v215, v223
		v_mov_b32_e32 v216, v220
		v_mov_b32_e32 v217, v222
		v_pk_add_f32 v[218:219], v[216:217], v[214:215]
		v_mov_b32_e32 v214, v173
		v_mov_b32_e32 v215, v219
		v_mov_b32_e32 v216, v172
		v_mov_b32_e32 v217, v218
		v_pk_add_f32 v[172:173], v[216:217], v[214:215]
		v_add_f32_e32 v3, v172, v173
		v_accvgpr_read_b32 v10, a77
		ds_bpermute_b32 v140, v10, v3
		v_accvgpr_read_b32 v10, a78
		ds_bpermute_b32 v142, v10, v3
		v_pk_add_f32 v[172:173], v[144:145], v[212:213]
		v_pk_add_f32 v[214:215], v[146:147], v[148:149]
		v_pk_add_f32 v[216:217], v[150:151], v[152:153]
		v_pk_add_f32 v[218:219], v[154:155], v[156:157]
		v_pk_add_f32 v[220:221], v[158:159], v[176:177]
		v_pk_add_f32 v[222:223], v[178:179], v[180:181]
		v_pk_add_f32 v[224:225], v[182:183], v[184:185]
		v_pk_add_f32 v[226:227], v[186:187], v[188:189]
		v_pk_add_f32 v[228:229], v[190:191], v[192:193]
		v_pk_add_f32 v[230:231], v[194:195], v[196:197]
		v_pk_add_f32 v[232:233], v[198:199], v[200:201]
		v_pk_add_f32 v[234:235], v[202:203], v[204:205]
		v_pk_add_f32 v[236:237], v[206:207], v[208:209]
		v_pk_add_f32 v[238:239], v[160:161], v[162:163]
		v_pk_add_f32 v[240:241], v[164:165], v[166:167]
		v_mov_b32_e32 v242, v173
		v_mov_b32_e32 v243, v216
		v_pk_add_f32 v[244:245], v[242:243], v[214:215]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[214:215], v[140:141], v[142:143]
		v_mov_b32_e32 v169, v215
		v_mov_b32_e32 v171, v172
		v_pk_add_f32 v[172:173], v[168:169], v[170:171]
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
		v_pk_add_f32 v[172:173], v[226:227], v[172:173]
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
		v_pk_add_f32 v[172:173], v[218:219], v[172:173]
		v_mov_b32_e32 v218, v231
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[222:223], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v221
		v_mov_b32_e32 v217, v222
		v_pk_add_f32 v[218:219], v[216:217], v[172:173]
		v_add_f32_e32 v3, v223, v218
		v_add_f32_e32 v3, v219, v3
		v_mov_b32_e32 v172, v3
		v_mov_b32_e32 v173, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v172, v173
		v_add_f32_e32 v217, v172, v173
		v_sub_f32_e32 v3, v7, v80
		v_sub_f32_e32 v7, v11, v81
		v_exp_f32_e32 v10, v3
		v_exp_f32_e32 v172, v7
		v_mov_b32_e32 v11, v10
		v_pk_mul_f32 v[16:17], v[16:17], v[10:11]
		v_pk_mul_f32 v[18:19], v[18:19], v[10:11]
		v_pk_mul_f32 v[20:21], v[20:21], v[10:11]
		v_pk_mul_f32 v[22:23], v[22:23], v[10:11]
		v_pk_mul_f32 v[24:25], v[24:25], v[10:11]
		v_pk_mul_f32 v[26:27], v[26:27], v[10:11]
		v_pk_mul_f32 v[28:29], v[28:29], v[10:11]
		v_pk_mul_f32 v[30:31], v[30:31], v[10:11]
		v_pk_mul_f32 v[32:33], v[32:33], v[10:11]
		v_pk_mul_f32 v[34:35], v[34:35], v[10:11]
		v_pk_mul_f32 v[36:37], v[36:37], v[10:11]
		v_pk_mul_f32 v[38:39], v[38:39], v[10:11]
		v_pk_mul_f32 v[40:41], v[40:41], v[10:11]
		v_pk_mul_f32 v[42:43], v[42:43], v[10:11]
		v_pk_mul_f32 v[44:45], v[44:45], v[10:11]
		v_pk_mul_f32 v[46:47], v[46:47], v[10:11]
		v_mov_b32_e32 v173, v172
		v_pk_mul_f32 v[48:49], v[48:49], v[172:173]
		v_pk_mul_f32 v[50:51], v[50:51], v[172:173]
		v_pk_mul_f32 v[52:53], v[52:53], v[172:173]
		v_pk_mul_f32 v[54:55], v[54:55], v[172:173]
		v_pk_mul_f32 v[56:57], v[56:57], v[172:173]
		v_pk_mul_f32 v[58:59], v[58:59], v[172:173]
		v_pk_mul_f32 v[60:61], v[60:61], v[172:173]
		v_pk_mul_f32 v[62:63], v[62:63], v[172:173]
		v_pk_mul_f32 v[64:65], v[64:65], v[172:173]
		v_pk_mul_f32 v[66:67], v[66:67], v[172:173]
		v_pk_mul_f32 v[68:69], v[68:69], v[172:173]
		v_pk_mul_f32 v[70:71], v[70:71], v[172:173]
		v_pk_mul_f32 v[72:73], v[72:73], v[172:173]
		v_pk_mul_f32 v[74:75], v[74:75], v[172:173]
		v_pk_mul_f32 v[76:77], v[76:77], v[172:173]
		v_pk_mul_f32 v[78:79], v[78:79], v[172:173]
		v_mov_b32_e32 v218, v10
		v_mov_b32_e32 v219, v172
		v_mov_b32_e32 v216, v214
		v_mov_b64_e32 v[10:11], v[14:15]
		v_pk_fma_f32 v[14:15], v[10:11], v[218:219], v[216:217]
		v_cvt_pk_bf16_f32 v216, v174, v210
		v_cvt_pk_bf16_f32 v217, v175, v211
		v_cvt_pk_bf16_f32 v218, v4, v82
		v_cvt_pk_bf16_f32 v219, v5, v83
		v_cvt_pk_bf16_f32 v172, v84, v86
		v_cvt_pk_bf16_f32 v173, v85, v87
		v_cvt_pk_bf16_f32 v174, v88, v90
		v_cvt_pk_bf16_f32 v175, v89, v91
		v_cvt_pk_bf16_f32 v84, v92, v94
		v_cvt_pk_bf16_f32 v85, v93, v95
		v_cvt_pk_bf16_f32 v86, v96, v98
		v_cvt_pk_bf16_f32 v87, v97, v99
		v_cvt_pk_bf16_f32 v88, v100, v102
		v_cvt_pk_bf16_f32 v89, v101, v103
		v_cvt_pk_bf16_f32 v90, v104, v106
		v_cvt_pk_bf16_f32 v91, v105, v107
		v_cvt_pk_bf16_f32 v92, v108, v110
		v_cvt_pk_bf16_f32 v93, v109, v111
		v_cvt_pk_bf16_f32 v94, v112, v114
		v_cvt_pk_bf16_f32 v95, v113, v115
		v_cvt_pk_bf16_f32 v96, v116, v118
		v_cvt_pk_bf16_f32 v97, v117, v119
		v_cvt_pk_bf16_f32 v98, v120, v122
		v_cvt_pk_bf16_f32 v99, v121, v123
		v_cvt_pk_bf16_f32 v100, v124, v126
		v_cvt_pk_bf16_f32 v101, v125, v127
		v_cvt_pk_bf16_f32 v102, v128, v130
		v_cvt_pk_bf16_f32 v103, v129, v131
		v_cvt_pk_bf16_f32 v104, v132, v134
		v_cvt_pk_bf16_f32 v105, v133, v135
		v_cvt_pk_bf16_f32 v106, v136, v138
		v_cvt_pk_bf16_f32 v107, v137, v139
		v_cvt_pk_bf16_f32 v108, v141, v143
		v_cvt_pk_bf16_f32 v109, v144, v212
		v_cvt_pk_bf16_f32 v110, v145, v213
		v_cvt_pk_bf16_f32 v111, v146, v148
		v_cvt_pk_bf16_f32 v112, v147, v149
		v_cvt_pk_bf16_f32 v113, v150, v152
		v_cvt_pk_bf16_f32 v114, v151, v153
		v_cvt_pk_bf16_f32 v115, v154, v156
		v_cvt_pk_bf16_f32 v116, v155, v157
		v_cvt_pk_bf16_f32 v117, v158, v176
		v_cvt_pk_bf16_f32 v118, v159, v177
		v_cvt_pk_bf16_f32 v119, v178, v180
		v_cvt_pk_bf16_f32 v120, v179, v181
		v_cvt_pk_bf16_f32 v121, v182, v184
		v_cvt_pk_bf16_f32 v122, v183, v185
		v_cvt_pk_bf16_f32 v123, v186, v188
		v_cvt_pk_bf16_f32 v124, v187, v189
		v_cvt_pk_bf16_f32 v125, v190, v192
		v_cvt_pk_bf16_f32 v126, v191, v193
		v_cvt_pk_bf16_f32 v127, v194, v196
		v_cvt_pk_bf16_f32 v128, v195, v197
		v_cvt_pk_bf16_f32 v129, v198, v200
		v_cvt_pk_bf16_f32 v130, v199, v201
		v_cvt_pk_bf16_f32 v131, v202, v204
		v_cvt_pk_bf16_f32 v132, v203, v205
		v_cvt_pk_bf16_f32 v133, v206, v208
		v_cvt_pk_bf16_f32 v134, v207, v209
		v_cvt_pk_bf16_f32 v135, v160, v162
		v_cvt_pk_bf16_f32 v136, v161, v163
		v_cvt_pk_bf16_f32 v137, v164, v166
		v_cvt_pk_bf16_f32 v138, v165, v167
		v_cvt_pk_bf16_f32 v139, v168, v170
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[16:31], a[132:135], v[216:219], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[164:167], v[216:219], v[32:47]
		v_permlane32_swap_b32_e32 v84, v86
		v_permlane32_swap_b32_e32 v85, v87
		v_mfma_f32_32x32x16_bf16 v[16:31], a[136:139], v[172:175], v[16:31]
		v_permlane32_swap_b32_e32 v88, v90
		v_permlane32_swap_b32_e32 v89, v91
		v_mfma_f32_32x32x16_bf16 v[32:47], a[168:171], v[172:175], v[32:47]
		v_permlane32_swap_b32_e32 v92, v94
		v_permlane32_swap_b32_e32 v93, v95
		v_mfma_f32_32x32x16_bf16 v[16:31], a[140:143], v[84:87], v[16:31]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[172:175], v[84:87], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[16:31], a[144:147], v[88:91], v[16:31]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[32:47], a[176:179], v[88:91], v[32:47]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[16:31], a[148:151], v[92:95], v[16:31]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[64:79], a[164:167], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[108:111], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[64:79], a[168:171], v[112:115], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[112:115], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[64:79], a[172:175], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[64:79], a[176:179], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[180:183], v[92:95], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[180:183], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[152:155], v[96:99], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[156:159], v[100:103], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[160:163], v[104:107], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[136:139], v[48:63]
		v_mov_b32_e32 v7, v80
		v_mov_b32_e32 v11, v81
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s25, s25, 0x80
		v_accvgpr_read_b32 v3, a14
		v_accvgpr_read_b32 v4, a5
		s_nop 0
		v_readfirstlane_b32 s36, v4
		s_nop 1
		v_add_u32_e32 v3, s36, v3
		v_add_u32_e32 v3, s1, v3
		v_accvgpr_read_b32 v4, a15
		v_accvgpr_read_b32 v5, a5
		s_nop 0
		v_readfirstlane_b32 s36, v5
		s_nop 1
		v_add_u32_e32 v4, s36, v4
		v_add_u32_e32 v4, s1, v4
		v_xor_b32_e32 v5, 1, v6
		v_accvgpr_write_b32 a14, v5
		v_xor_b32_e32 v5, 2, v6
		v_accvgpr_write_b32 a15, v5
		v_xor_b32_e32 v5, 3, v6
		v_accvgpr_write_b32 a66, v5
		v_xor_b32_e32 v5, 8, v6
		v_accvgpr_write_b32 a73, v5
		v_xor_b32_e32 v5, 9, v6
		v_accvgpr_write_b32 a79, v5
		v_xor_b32_e32 v5, 10, v6
		v_accvgpr_write_b32 a80, v5
		v_xor_b32_e32 v5, 11, v6
		v_accvgpr_write_b32 a81, v5
		v_xor_b32_e32 v5, 16, v6
		v_accvgpr_write_b32 a82, v5
		v_xor_b32_e32 v5, 17, v6
		v_accvgpr_write_b32 a83, v5
		v_xor_b32_e32 v5, 18, v6
		v_accvgpr_write_b32 a84, v5
		v_xor_b32_e32 v5, 19, v6
		v_accvgpr_write_b32 a85, v5
		v_xor_b32_e32 v5, 24, v6
		v_accvgpr_write_b32 a86, v5
		v_xor_b32_e32 v5, 25, v6
		v_accvgpr_write_b32 a87, v5
		v_xor_b32_e32 v5, 26, v6
		v_accvgpr_write_b32 a88, v5
		v_xor_b32_e32 v5, 27, v6
		v_accvgpr_write_b32 a89, v5
		v_xor_b32_e32 v5, 32, v6
		v_accvgpr_write_b32 a90, v5
		v_xor_b32_e32 v5, 33, v6
		v_accvgpr_write_b32 a91, v5
		v_xor_b32_e32 v5, 34, v6
		v_accvgpr_write_b32 a92, v5
		v_xor_b32_e32 v5, 35, v6
		v_accvgpr_write_b32 a93, v5
		v_xor_b32_e32 v5, 40, v6
		v_accvgpr_write_b32 a94, v5
		v_xor_b32_e32 v5, 41, v6
		v_accvgpr_write_b32 a95, v5
		v_xor_b32_e32 v5, 42, v6
		v_accvgpr_write_b32 a96, v5
		v_xor_b32_e32 v5, 43, v6
		v_accvgpr_write_b32 a97, v5
		v_xor_b32_e32 v5, 48, v6
		v_accvgpr_write_b32 a98, v5
		v_xor_b32_e32 v5, 49, v6
		v_accvgpr_write_b32 a99, v5
		v_xor_b32_e32 v5, 50, v6
		v_accvgpr_write_b32 a100, v5
		v_xor_b32_e32 v5, 51, v6
		v_accvgpr_write_b32 a101, v5
		v_xor_b32_e32 v5, 56, v6
		v_accvgpr_write_b32 a102, v5
		v_xor_b32_e32 v5, 57, v6
		v_accvgpr_write_b32 a103, v5
		v_xor_b32_e32 v5, 58, v6
		v_accvgpr_write_b32 a104, v5
		v_xor_b32_e32 v5, 59, v6
		v_accvgpr_write_b32 a105, v5
		v_xor_b32_e32 v5, 64, v6
		v_accvgpr_write_b32 a106, v5
		v_xor_b32_e32 v5, 0x41, v6
		v_accvgpr_write_b32 a107, v5
		v_xor_b32_e32 v5, 0x42, v6
		v_accvgpr_write_b32 a108, v5
		v_xor_b32_e32 v5, 0x43, v6
		v_accvgpr_write_b32 a109, v5
		v_xor_b32_e32 v5, 0x48, v6
		v_accvgpr_write_b32 a110, v5
		v_xor_b32_e32 v5, 0x49, v6
		v_accvgpr_write_b32 a111, v5
		v_xor_b32_e32 v5, 0x4a, v6
		v_accvgpr_write_b32 a112, v5
		v_xor_b32_e32 v5, 0x4b, v6
		v_accvgpr_write_b32 a113, v5
		v_xor_b32_e32 v5, 0x50, v6
		v_accvgpr_write_b32 a114, v5
		v_xor_b32_e32 v5, 0x51, v6
		v_accvgpr_write_b32 a115, v5
		v_xor_b32_e32 v5, 0x52, v6
		v_accvgpr_write_b32 a116, v5
		v_xor_b32_e32 v5, 0x53, v6
		v_accvgpr_write_b32 a117, v5
		v_xor_b32_e32 v5, 0x58, v6
		v_accvgpr_write_b32 a118, v5
		v_xor_b32_e32 v5, 0x59, v6
		v_accvgpr_write_b32 a119, v5
		v_xor_b32_e32 v5, 0x5a, v6
		v_accvgpr_write_b32 a120, v5
		v_xor_b32_e32 v5, 0x5b, v6
		v_accvgpr_write_b32 a121, v5
		v_xor_b32_e32 v5, 0x60, v6
		v_accvgpr_write_b32 a122, v5
		v_xor_b32_e32 v5, 0x61, v6
		v_accvgpr_write_b32 a123, v5
		v_xor_b32_e32 v5, 0x62, v6
		v_accvgpr_write_b32 a124, v5
		v_xor_b32_e32 v5, 0x63, v6
		v_accvgpr_write_b32 a125, v5
		v_xor_b32_e32 v5, 0x68, v6
		v_accvgpr_write_b32 a126, v5
		v_xor_b32_e32 v5, 0x69, v6
		v_accvgpr_write_b32 a127, v5
		v_xor_b32_e32 v5, 0x6a, v6
		v_accvgpr_write_b32 a128, v5
		v_xor_b32_e32 v5, 0x6b, v6
		v_accvgpr_write_b32 a129, v5
		v_xor_b32_e32 v5, 0x70, v6
		v_accvgpr_write_b32 a130, v5
		v_xor_b32_e32 v5, 0x71, v6
		v_accvgpr_write_b32 a131, v5
		v_xor_b32_e32 v5, 0x72, v6
		v_accvgpr_write_b32 a132, v5
		v_xor_b32_e32 v5, 0x73, v6
		v_accvgpr_write_b32 a133, v5
		v_xor_b32_e32 v5, 0x78, v6
		v_accvgpr_write_b32 a134, v5
		v_xor_b32_e32 v5, 0x79, v6
		v_accvgpr_write_b32 a135, v5
		v_xor_b32_e32 v5, 0x7a, v6
		v_accvgpr_write_b32 a136, v5
		v_xor_b32_e32 v5, 0x7b, v6
		v_accvgpr_write_b32 a137, v5
		v_accvgpr_read_b32 v5, a24
		v_accvgpr_read_b32 v10, a67
		v_lshl_add_u32 v5, v5, 4, v10
		v_accvgpr_read_b32 v10, a68
		v_accvgpr_read_b32 v13, a69
		v_add3_u32 v5, v5, v10, v13
		v_accvgpr_read_b32 v10, a70
		v_accvgpr_read_b32 v13, a71
		v_add3_u32 v5, v5, v10, v13
		v_accvgpr_write_b32 a24, v5
		v_accvgpr_read_b32 v5, a72
		v_accvgpr_read_b32 v10, a74
		v_lshl_add_u32 v5, v5, 3, v10
		v_accvgpr_read_b32 v10, a75
		v_accvgpr_read_b32 v13, a76
		v_add3_u32 v5, v5, v10, v13
		v_accvgpr_write_b32 a67, v5
		v_mov_b32_e32 v5, 0xff800000
		s_cmp_lt_i32 s42, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s36, s24, 0
		s_add_i32 s36, s42, s36
		s_ashr_i32 s36, s36, 7
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s38, s16, 0
		s_add_i32 s38, s36, s38
		s_ashr_i32 s38, s38, 1
		s_lshl_b32 s38, s38, 1
		s_xor_b32 s38, s38, -1
		s_add_i32 s38, s38, 1
		s_add_i32 s38, s36, s38
		s_add_i32 s36, s36, 1
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s39, s16, 0
		s_add_i32 s39, s36, s39
		s_ashr_i32 s39, s39, 1
		s_lshl_b32 s39, s39, 1
		s_xor_b32 s39, s39, -1
		s_add_i32 s39, s39, 1
		s_add_i32 s50, s36, s39
		s_mul_i32 s36, 0x4100, s38
		v_accvgpr_read_b32 v10, a24
		v_add_u32_e32 v10, s36, v10
		ds_read_b128 v[80:83], v10
		ds_read_b128 a[68:71], v10 offset:32
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
		ds_read_b128 v[84:87], v10 offset:384
		ds_read_b128 a[180:183], v10 offset:416
		ds_read_b128 a[184:187], v10 offset:448
		ds_read_b128 a[188:191], v10 offset:480
		s_mul_i32 s36, 0x4400, s38
		v_accvgpr_read_b32 v10, a67
		v_add_u32_e32 v10, s36, v10
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
		s_cmp_lt_i32 s1, s19
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v10, a25
		v_add_u32_e32 v10, s1, v10
		v_accvgpr_read_b32 v13, a26
		v_add_u32_e32 v13, s1, v13
		v_accvgpr_read_b32 v88, a27
		v_add_u32_e32 v88, s1, v88
		v_accvgpr_read_b32 v89, a60
		v_add_u32_e32 v89, s1, v89
		v_cmp_lt_i32_e64 vcc, v10, s21
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v13, s21
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v88, s21
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v89, s21
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v10, a61
		v_add_u32_e32 v10, s1, v10
		v_accvgpr_read_b32 v13, a62
		v_add_u32_e32 v13, s1, v13
		v_accvgpr_read_b32 v88, a63
		v_add_u32_e32 v88, s1, v88
		v_cmp_lt_i32_e64 vcc, v10, s21
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v13, s21
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v88, s21
		s_mov_b64 s[64:65], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s36, s15, s42
		s_lshl_b32 s36, s36, 1
		s_add_i32 s41, s43, s36
		v_add_u32_e32 v10, s41, v2
		s_mov_b32 s66, 1
		s_mov_b32 s67, 0
		s_mov_b32 s53, 0
		s_mul_i32 s68, s66, s52
		s_mul_hi_u32 s69, s66, s52
		s_mul_i32 s41, s66, s53
		s_add_i32 s69, s69, s41
		s_mul_i32 s41, s67, s52
		s_add_i32 s69, s69, s41
		s_lshr_b64 s[66:67], s[68:69], 6
		s_mov_b32 s68, 0x410
		s_mov_b32 s69, 0
		s_mul_i32 s70, s68, s66
		s_mul_hi_u32 s71, s68, s66
		s_mul_i32 s41, s68, s67
		s_add_i32 s71, s71, s41
		s_mul_i32 s41, s69, s66
		s_add_i32 s71, s71, s41
		s_cmp_lt_i32 s50, 0
		s_cselect_b32 s51, -1, 0
		s_mov_b32 s68, 0x4100
		s_mov_b32 s69, 0
		s_mul_i32 s72, s68, s50
		s_mul_hi_u32 s73, s68, s50
		s_mul_i32 s41, s68, s51
		s_add_i32 s73, s73, s41
		s_mul_i32 s41, s69, s50
		s_add_i32 s73, s73, s41
		s_add_u32 s68, s70, s72
		s_addc_u32 s69, s71, s73
		s_add_u32 s74, s68, 0
		s_addc_u32 s75, s69, 0
		s_mov_b32 m0, s74
		v_cndmask_b32_e64 v10, v12, v10, s[38:39]
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v10, a65
		v_add_u32_e32 v10, s1, v10
		s_add_i32 s1, s44, s36
		v_add_u32_e32 v13, s1, v2
		s_add_u32 s38, s70, 0x1040
		s_addc_u32 s39, s71, 0
		s_add_u32 s38, s38, s72
		s_addc_u32 s39, s39, s73
		s_add_u32 s68, s38, 0
		s_addc_u32 s69, s39, 0
		s_mov_b32 m0, s68
		v_cndmask_b32_e64 v13, v12, v13, s[54:55]
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s1, s45, s36
		v_add_u32_e32 v13, s1, v2
		s_add_u32 s38, s70, 0x2080
		s_addc_u32 s39, s71, 0
		s_add_u32 s38, s38, s72
		s_addc_u32 s39, s39, s73
		s_add_u32 s54, s38, 0
		s_addc_u32 s55, s39, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v13, v12, v13, s[56:57]
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s1, s37, s36
		v_add_u32_e32 v13, s1, v2
		s_add_u32 s38, s70, 0x30c0
		s_addc_u32 s39, s71, 0
		s_add_u32 s38, s38, s72
		s_addc_u32 s39, s39, s73
		s_add_u32 s54, s38, 0
		s_addc_u32 s55, s39, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v13, v12, v13, s[58:59]
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_mul_i32 s1, s17, s42
		s_lshl_b32 s1, s1, 1
		s_add_i32 s36, s46, s1
		v_add_u32_e32 v13, s36, v1
		s_mov_b32 s38, 0x440
		s_mov_b32 s39, 0
		s_mul_i32 s54, s38, s66
		s_mul_hi_u32 s55, s38, s66
		s_mul_i32 s36, s38, s67
		s_add_i32 s55, s55, s36
		s_mul_i32 s36, s39, s66
		s_add_i32 s55, s55, s36
		s_add_u32 s38, s54, 0x81f0
		s_addc_u32 s39, s55, 0
		s_mov_b32 s56, 0x4400
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s50
		s_mul_hi_u32 s59, s56, s50
		s_mul_i32 s36, s56, s51
		s_add_i32 s59, s59, s36
		s_mul_i32 s36, s57, s50
		s_add_i32 s59, s59, s36
		s_add_u32 s38, s38, s58
		s_addc_u32 s39, s39, s59
		s_add_u32 s50, s38, 0
		s_addc_u32 s51, s39, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v13, v12, v13, s[60:61]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_add_i32 s36, s47, s1
		v_add_u32_e32 v13, s36, v1
		s_add_u32 s38, s54, 0x92f0
		s_addc_u32 s39, s55, 0
		s_add_u32 s38, s38, s58
		s_addc_u32 s39, s39, s59
		s_add_u32 s50, s38, 0
		s_addc_u32 s51, s39, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v13, v12, v13, s[62:63]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_add_i32 s36, s48, s1
		v_add_u32_e32 v13, s36, v1
		s_add_u32 s38, s54, 0xa3f0
		s_addc_u32 s39, s55, 0
		s_add_u32 s38, s38, s58
		s_addc_u32 s39, s39, s59
		s_add_u32 s50, s38, 0
		s_addc_u32 s51, s39, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v13, v12, v13, s[64:65]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_add_i32 s1, s40, s1
		v_cmp_lt_i32_e64 vcc, v10, s21
		v_add_u32_e32 v10, s1, v1
		s_add_u32 s38, s54, 0xb4f0
		s_addc_u32 s39, s55, 0
		v_cndmask_b32_e32 v10, v12, v10, vcc
		s_add_u32 s38, s38, s58
		s_addc_u32 s39, s39, s59
		s_add_u32 s50, s38, 0
		s_addc_u32 s51, s39, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[80:83], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[84:87], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[84:87], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[80:83], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[164:167], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[68:71], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], a[48:51], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[168:171], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[52:55], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], a[52:55], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[172:175], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[56:59], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[56:59], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], a[56:59], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[176:179], a[56:59], v[192:207]
		v_add_u32_e32 v10, s42, v6
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, s42, v13
		v_accvgpr_read_b32 v208, a15
		v_add_u32_e32 v208, s42, v208
		v_accvgpr_read_b32 v209, a66
		v_add_u32_e32 v209, s42, v209
		v_accvgpr_read_b32 v210, a80
		v_add_u32_e32 v210, s42, v210
		v_accvgpr_read_b32 v211, a81
		v_add_u32_e32 v211, s42, v211
		v_accvgpr_read_b32 v212, a84
		v_add_u32_e32 v212, s42, v212
		v_accvgpr_read_b32 v213, a85
		v_add_u32_e32 v213, s42, v213
		v_accvgpr_read_b32 v214, a88
		v_add_u32_e32 v214, s42, v214
		v_accvgpr_read_b32 v215, a89
		v_add_u32_e32 v215, s42, v215
		v_accvgpr_read_b32 v216, a92
		v_add_u32_e32 v216, s42, v216
		v_accvgpr_read_b32 v217, a93
		v_add_u32_e32 v217, s42, v217
		v_accvgpr_read_b32 v218, a96
		v_add_u32_e32 v218, s42, v218
		v_accvgpr_read_b32 v219, a97
		v_add_u32_e32 v219, s42, v219
		v_accvgpr_read_b32 v220, a100
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_read_b32 v221, a101
		v_add_u32_e32 v221, s42, v221
		v_accvgpr_read_b32 v222, a104
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a68, v222
		v_accvgpr_read_b32 v222, a105
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a69, v222
		v_accvgpr_read_b32 v222, a108
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a70, v222
		v_accvgpr_read_b32 v222, a109
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a71, v222
		v_accvgpr_read_b32 v222, a112
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a72, v222
		v_accvgpr_read_b32 v222, a113
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a74, v222
		v_accvgpr_read_b32 v222, a116
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a75, v222
		v_accvgpr_read_b32 v222, a117
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a76, v222
		v_accvgpr_read_b32 v222, a120
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a138, v222
		v_accvgpr_read_b32 v222, a121
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a139, v222
		v_accvgpr_read_b32 v222, a124
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a140, v222
		v_accvgpr_read_b32 v222, a125
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a141, v222
		v_accvgpr_read_b32 v222, a128
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a142, v222
		v_accvgpr_read_b32 v222, a129
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a143, v222
		v_accvgpr_read_b32 v222, a132
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a144, v222
		v_accvgpr_read_b32 v222, a133
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a145, v222
		v_accvgpr_read_b32 v222, a136
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a146, v222
		v_accvgpr_read_b32 v222, a137
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_write_b32 a147, v222
		v_cmp_ge_i32_e64 vcc, v3, v10
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v3, v13
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v3, v208
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v3, v209
		v_accvgpr_read_b32 v222, a73
		v_add_u32_e32 v222, s42, v222
		v_accvgpr_read_b32 v223, a79
		v_add_u32_e32 v223, s42, v223
		v_cndmask_b32_e32 v225, v5, v99, vcc
		v_cmp_ge_i32_e64 vcc, v3, v222
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v3, v223
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v3, v210
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v3, v211
		v_accvgpr_read_b32 v99, a82
		v_add_u32_e32 v99, s42, v99
		v_accvgpr_read_b32 v224, a83
		v_add_u32_e32 v226, s42, v224
		v_cndmask_b32_e32 v229, v5, v103, vcc
		v_cmp_ge_i32_e64 vcc, v3, v99
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v3, v226
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v3, v212
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v3, v213
		v_accvgpr_read_b32 v103, a86
		v_add_u32_e32 v103, s42, v103
		v_accvgpr_read_b32 v224, a87
		v_add_u32_e32 v227, s42, v224
		v_cndmask_b32_e32 v231, v5, v107, vcc
		v_cmp_ge_i32_e64 vcc, v3, v103
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v3, v227
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v3, v214
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v3, v215
		v_accvgpr_read_b32 v107, a90
		v_add_u32_e32 v107, s42, v107
		v_accvgpr_read_b32 v224, a91
		v_add_u32_e32 v232, s42, v224
		v_cndmask_b32_e32 v235, v5, v111, vcc
		v_cmp_ge_i32_e64 vcc, v3, v107
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v3, v232
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v3, v216
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v3, v217
		v_accvgpr_read_b32 v111, a94
		v_add_u32_e32 v111, s42, v111
		v_accvgpr_read_b32 v224, a95
		v_add_u32_e32 v233, s42, v224
		v_cndmask_b32_e32 v237, v5, v115, vcc
		v_cmp_ge_i32_e64 vcc, v3, v111
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v3, v233
		s_mov_b64 s[82:83], vcc
		v_cmp_ge_i32_e64 vcc, v3, v218
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_write_b32 a148, v238
		v_accvgpr_write_b32 a149, v239
		v_cmp_ge_i32_e64 vcc, v3, v219
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_read_b32 v115, a98
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_read_b32 v224, a99
		v_add_u32_e32 v236, s42, v224
		v_cndmask_b32_e32 v239, v5, v119, vcc
		v_cmp_ge_i32_e64 vcc, v3, v115
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_cmp_ge_i32_e64 vcc, v3, v236
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a152, v240
		v_accvgpr_write_b32 a153, v241
		v_cmp_ge_i32_e64 vcc, v3, v220
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a154, v240
		v_accvgpr_write_b32 a155, v241
		v_cmp_ge_i32_e64 vcc, v3, v221
		v_accvgpr_read_b32 v119, a102
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_read_b32 v224, a103
		v_add_u32_e32 v238, s42, v224
		v_cndmask_b32_e32 v241, v5, v123, vcc
		v_cmp_ge_i32_e64 vcc, v3, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a156, v242
		v_accvgpr_write_b32 a157, v243
		v_cmp_ge_i32_e64 vcc, v3, v238
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a158, v242
		v_accvgpr_write_b32 a159, v243
		v_accvgpr_read_b32 v123, a68
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v123, a69
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_read_b32 v123, a106
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_write_b32 a162, v123
		v_accvgpr_read_b32 v123, a107
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_write_b32 a163, v123
		v_cndmask_b32_e32 v243, v5, v127, vcc
		v_accvgpr_read_b32 v123, a162
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_accvgpr_read_b32 v123, a163
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v123, a70
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v123, a71
		v_cmp_ge_i32_e64 vcc, v3, v123
		v_accvgpr_read_b32 v123, a110
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_write_b32 a170, v123
		v_accvgpr_read_b32 v123, a111
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_write_b32 a171, v123
		v_cndmask_b32_e32 v245, v5, v131, vcc
		v_accvgpr_read_b32 v123, a170
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a172, v246
		v_accvgpr_write_b32 a173, v247
		v_accvgpr_read_b32 v123, a171
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v123, a72
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v123, a74
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_read_b32 v123, a114
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_write_b32 a178, v123
		v_accvgpr_read_b32 v123, a115
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_write_b32 a179, v123
		v_cndmask_b32_e32 v247, v5, v135, vcc
		v_accvgpr_read_b32 v123, a178
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a180, v248
		v_accvgpr_write_b32 a181, v249
		v_accvgpr_read_b32 v123, a179
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v123, a75
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a184, v248
		v_accvgpr_write_b32 a185, v249
		v_accvgpr_read_b32 v123, a76
		v_cmp_ge_i32_e64 vcc, v3, v123
		v_accvgpr_read_b32 v123, a118
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_write_b32 a186, v123
		v_accvgpr_read_b32 v123, a119
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_write_b32 a187, v123
		v_cndmask_b32_e32 v249, v5, v139, vcc
		v_accvgpr_read_b32 v123, a186
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v250, s84
		v_mov_b32_e32 v251, s85
		v_accvgpr_write_b32 a188, v250
		v_accvgpr_write_b32 a189, v251
		v_accvgpr_read_b32 v123, a187
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v123, a138
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[86:87], vcc
		v_cndmask_b32_e64 v251, v5, v141, s[84:85]
		v_cndmask_b32_e64 v252, v5, v142, s[86:87]
		v_accvgpr_read_b32 v123, a139
		v_cmp_ge_i32_e64 vcc, v3, v123
		v_accvgpr_read_b32 v123, a122
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_read_b32 v127, a123
		v_add_u32_e32 v127, s42, v127
		v_cndmask_b32_e32 v253, v5, v143, vcc
		v_cmp_ge_i32_e64 vcc, v3, v123
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v3, v127
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v131, a140
		v_cmp_ge_i32_e64 vcc, v3, v131
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v142, v5, v144, s[84:85]
		v_cndmask_b32_e64 v143, v5, v145, s[86:87]
		v_cndmask_b32_e64 v144, v5, v146, s[88:89]
		v_accvgpr_read_b32 v131, a141
		v_cmp_ge_i32_e64 vcc, v3, v131
		v_accvgpr_read_b32 v131, a126
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_read_b32 v135, a127
		v_add_u32_e32 v135, s42, v135
		v_cndmask_b32_e32 v145, v5, v147, vcc
		v_cmp_ge_i32_e64 vcc, v3, v131
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v3, v135
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v139, a142
		v_cmp_ge_i32_e64 vcc, v3, v139
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v146, v5, v148, s[84:85]
		v_cndmask_b32_e64 v147, v5, v149, s[86:87]
		v_cndmask_b32_e64 v148, v5, v150, s[88:89]
		v_accvgpr_read_b32 v139, a143
		v_cmp_ge_i32_e64 vcc, v3, v139
		v_accvgpr_read_b32 v139, a130
		v_add_u32_e32 v139, s42, v139
		v_accvgpr_read_b32 v141, a131
		v_add_u32_e32 v141, s42, v141
		v_cndmask_b32_e32 v149, v5, v151, vcc
		v_cmp_ge_i32_e64 vcc, v3, v139
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v3, v141
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v150, a144
		v_cmp_ge_i32_e64 vcc, v3, v150
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v150, v5, v152, s[84:85]
		v_cndmask_b32_e64 v151, v5, v153, s[86:87]
		v_cndmask_b32_e64 v152, v5, v154, s[88:89]
		v_accvgpr_read_b32 v153, a145
		v_cmp_ge_i32_e64 vcc, v3, v153
		v_accvgpr_read_b32 v153, a134
		v_add_u32_e32 v153, s42, v153
		v_accvgpr_write_b32 a190, v153
		v_accvgpr_read_b32 v153, a135
		v_add_u32_e32 v153, s42, v153
		v_accvgpr_write_b32 a191, v153
		v_cndmask_b32_e32 v153, v5, v155, vcc
		v_accvgpr_read_b32 v154, a190
		v_cmp_ge_i32_e64 vcc, v3, v154
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v154, a191
		v_cmp_ge_i32_e64 vcc, v3, v154
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v154, a146
		v_cmp_ge_i32_e64 vcc, v3, v154
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v154, v5, v156, s[84:85]
		v_cndmask_b32_e64 v155, v5, v157, s[86:87]
		v_cndmask_b32_e64 v156, v5, v158, s[88:89]
		v_accvgpr_read_b32 v157, a147
		v_cmp_ge_i32_e64 vcc, v3, v157
		v_cndmask_b32_e64 v254, v5, v96, s[38:39]
		v_cndmask_b32_e64 v255, v5, v97, s[50:51]
		v_cndmask_b32_e32 v157, v5, v159, vcc
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v13
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v4, v208
		s_mov_b64 s[84:85], vcc
		v_cndmask_b32_e64 v96, v5, v176, s[38:39]
		v_cndmask_b32_e64 v97, v5, v177, s[50:51]
		v_cndmask_b32_e64 v158, v5, v178, s[84:85]
		v_cmp_ge_i32_e64 vcc, v4, v209
		v_cndmask_b32_e64 v224, v5, v98, s[54:55]
		v_cndmask_b32_e64 v176, v5, v100, s[56:57]
		v_cndmask_b32_e32 v159, v5, v179, vcc
		v_cmp_ge_i32_e64 vcc, v4, v222
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v223
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v4, v210
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v178, v5, v180, s[38:39]
		v_cndmask_b32_e64 v179, v5, v181, s[50:51]
		v_cndmask_b32_e64 v180, v5, v182, s[54:55]
		v_cmp_ge_i32_e64 vcc, v4, v211
		v_cndmask_b32_e64 v177, v5, v101, s[58:59]
		v_cndmask_b32_e64 v228, v5, v102, s[60:61]
		v_cndmask_b32_e32 v181, v5, v183, vcc
		v_cmp_ge_i32_e64 vcc, v4, v99
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v226
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v4, v212
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v98, v5, v184, s[38:39]
		v_cndmask_b32_e64 v99, v5, v185, s[50:51]
		v_cndmask_b32_e64 v100, v5, v186, s[54:55]
		v_cmp_ge_i32_e64 vcc, v4, v213
		v_cndmask_b32_e64 v182, v5, v104, s[62:63]
		v_cndmask_b32_e64 v183, v5, v105, s[64:65]
		v_cndmask_b32_e32 v101, v5, v187, vcc
		v_cmp_ge_i32_e64 vcc, v4, v103
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v227
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v4, v214
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v102, v5, v188, s[38:39]
		v_cndmask_b32_e64 v103, v5, v189, s[50:51]
		v_cndmask_b32_e64 v104, v5, v190, s[54:55]
		v_cmp_ge_i32_e64 vcc, v4, v215
		v_cndmask_b32_e64 v230, v5, v106, s[66:67]
		v_cndmask_b32_e64 v184, v5, v108, s[68:69]
		v_cndmask_b32_e32 v105, v5, v191, vcc
		v_cmp_ge_i32_e64 vcc, v4, v107
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v232
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v4, v216
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v106, v5, v80, s[38:39]
		v_cndmask_b32_e64 v107, v5, v81, s[50:51]
		v_cndmask_b32_e64 v80, v5, v82, s[54:55]
		v_cmp_ge_i32_e64 vcc, v4, v217
		v_cndmask_b32_e64 v185, v5, v109, s[70:71]
		v_cndmask_b32_e64 v234, v5, v110, s[72:73]
		v_cndmask_b32_e32 v81, v5, v83, vcc
		v_cmp_ge_i32_e64 vcc, v4, v111
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v233
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v4, v218
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v82, v5, v84, s[38:39]
		v_cndmask_b32_e64 v83, v5, v85, s[50:51]
		v_cndmask_b32_e64 v84, v5, v86, s[54:55]
		v_cmp_ge_i32_e64 vcc, v4, v219
		v_cndmask_b32_e64 v108, v5, v112, s[74:75]
		v_cndmask_b32_e64 v109, v5, v113, s[76:77]
		v_cndmask_b32_e32 v85, v5, v87, vcc
		v_cmp_ge_i32_e64 vcc, v4, v115
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v236
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v4, v220
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v86, v5, v88, s[38:39]
		v_cndmask_b32_e64 v87, v5, v89, s[50:51]
		v_cndmask_b32_e64 v88, v5, v90, s[54:55]
		v_cmp_ge_i32_e64 vcc, v4, v221
		v_cndmask_b32_e64 v236, v5, v114, s[78:79]
		v_cndmask_b32_e64 v110, v5, v116, s[80:81]
		v_cndmask_b32_e32 v89, v5, v91, vcc
		v_cmp_ge_i32_e64 vcc, v4, v119
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v238
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a68
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v90, v5, v92, s[38:39]
		v_cndmask_b32_e64 v91, v5, v93, s[50:51]
		v_cndmask_b32_e64 v92, v5, v94, s[54:55]
		v_accvgpr_read_b32 v10, a69
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_cndmask_b32_e64 v111, v5, v117, s[82:83]
		v_accvgpr_read_b32 v10, a148
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a149
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v238, v5, v118, s[38:39]
		v_cndmask_b32_e32 v93, v5, v95, vcc
		v_accvgpr_read_b32 v10, a162
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a163
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a70
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v94, v5, v192, s[38:39]
		v_cndmask_b32_e64 v95, v5, v193, s[50:51]
		v_cndmask_b32_e64 v112, v5, v194, s[54:55]
		v_accvgpr_read_b32 v10, a71
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_accvgpr_read_b32 v10, a150
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a151
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v114, v5, v120, s[38:39]
		v_accvgpr_read_b32 v10, a152
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a153
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v115, v5, v121, s[38:39]
		v_cndmask_b32_e32 v113, v5, v195, vcc
		v_accvgpr_read_b32 v10, a170
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a171
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a72
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v116, v5, v196, s[38:39]
		v_cndmask_b32_e64 v117, v5, v197, s[50:51]
		v_cndmask_b32_e64 v118, v5, v198, s[54:55]
		v_accvgpr_read_b32 v10, a74
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_accvgpr_read_b32 v10, a154
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a155
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v240, v5, v122, s[38:39]
		v_accvgpr_read_b32 v10, a156
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a157
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v120, v5, v124, s[38:39]
		v_cndmask_b32_e32 v119, v5, v199, vcc
		v_accvgpr_read_b32 v10, a178
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a179
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a75
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v186, v5, v200, s[38:39]
		v_cndmask_b32_e64 v187, v5, v201, s[50:51]
		v_cndmask_b32_e64 v188, v5, v202, s[54:55]
		v_accvgpr_read_b32 v10, a76
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_accvgpr_read_b32 v10, a158
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a159
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v121, v5, v125, s[38:39]
		v_accvgpr_read_b32 v10, a160
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a161
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v242, v5, v126, s[38:39]
		v_cndmask_b32_e32 v189, v5, v203, vcc
		v_accvgpr_read_b32 v10, a186
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a187
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a138
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v124, v5, v204, s[38:39]
		v_cndmask_b32_e64 v125, v5, v205, s[50:51]
		v_cndmask_b32_e64 v190, v5, v206, s[54:55]
		v_accvgpr_read_b32 v10, a139
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_accvgpr_read_b32 v10, a164
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a165
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v192, v5, v128, s[38:39]
		v_accvgpr_read_b32 v10, a166
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a167
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v193, v5, v129, s[38:39]
		v_cndmask_b32_e32 v191, v5, v207, vcc
		v_cmp_ge_i32_e64 vcc, v4, v123
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v127
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a140
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v122, v5, v160, s[38:39]
		v_cndmask_b32_e64 v123, v5, v161, s[50:51]
		v_cndmask_b32_e64 v126, v5, v162, s[54:55]
		v_accvgpr_read_b32 v10, a141
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_accvgpr_read_b32 v10, a168
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a169
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v244, v5, v130, s[38:39]
		v_accvgpr_read_b32 v10, a172
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a173
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v128, v5, v132, s[38:39]
		v_cndmask_b32_e32 v127, v5, v163, vcc
		v_cmp_ge_i32_e64 vcc, v4, v131
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v135
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a142
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v130, v5, v164, s[38:39]
		v_cndmask_b32_e64 v131, v5, v165, s[50:51]
		v_cndmask_b32_e64 v160, v5, v166, s[54:55]
		v_accvgpr_read_b32 v10, a143
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_accvgpr_read_b32 v10, a174
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a175
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v129, v5, v133, s[38:39]
		v_accvgpr_read_b32 v10, a176
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a177
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v246, v5, v134, s[38:39]
		v_cndmask_b32_e32 v161, v5, v167, vcc
		v_cmp_ge_i32_e64 vcc, v4, v139
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v4, v141
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a144
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v132, v5, v168, s[38:39]
		v_cndmask_b32_e64 v133, v5, v169, s[50:51]
		v_cndmask_b32_e64 v134, v5, v170, s[54:55]
		v_accvgpr_read_b32 v10, a145
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_accvgpr_read_b32 v10, a180
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a181
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v162, v5, v136, s[38:39]
		v_accvgpr_read_b32 v10, a182
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a183
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v163, v5, v137, s[38:39]
		v_cndmask_b32_e32 v135, v5, v171, vcc
		v_accvgpr_read_b32 v10, a190
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a191
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a146
		v_cmp_ge_i32_e64 vcc, v4, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v136, v5, v172, s[38:39]
		v_cndmask_b32_e64 v137, v5, v173, s[50:51]
		v_cndmask_b32_e64 v164, v5, v174, s[54:55]
		v_accvgpr_read_b32 v10, a147
		v_cmp_ge_i32_e64 vcc, v4, v10
		v_accvgpr_read_b32 v10, a184
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a185
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v248, v5, v138, s[38:39]
		v_accvgpr_read_b32 v10, a188
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a189
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v250, v5, v140, s[38:39]
		v_cndmask_b32_e32 v165, v5, v175, vcc
		v_max3_f32 v10, v254, v255, v224
		v_max3_f32 v13, v176, v177, v228
		v_max3_f32 v138, v182, v183, v230
		v_max3_f32 v139, v184, v185, v234
		v_max3_f32 v140, v108, v109, v236
		v_max3_f32 v141, v110, v111, v238
		v_max3_f32 v166, v114, v115, v240
		v_max3_f32 v167, v120, v121, v242
		v_max3_f32 v168, v192, v193, v244
		v_max3_f32 v169, v128, v129, v246
		v_max3_f32 v170, v162, v163, v248
		v_max3_f32 v171, v250, v251, v252
		v_max3_f32 v172, v142, v143, v144
		v_max3_f32 v173, v146, v147, v148
		v_max3_f32 v174, v150, v151, v152
		v_max3_f32 v175, v154, v155, v156
		v_max3_f32 v10, v10, v225, v13
		v_max3_f32 v13, v138, v231, v139
		v_max3_f32 v138, v140, v237, v141
		v_max3_f32 v139, v166, v241, v167
		v_max3_f32 v140, v168, v245, v169
		v_max3_f32 v141, v170, v249, v171
		v_max3_f32 v166, v172, v145, v173
		v_max3_f32 v167, v174, v153, v175
		v_max3_f32 v10, v10, v229, v13
		v_max3_f32 v13, v138, v239, v139
		v_max3_f32 v138, v140, v247, v141
		v_max3_f32 v139, v166, v149, v167
		v_max3_f32 v10, v10, v235, v13
		v_max3_f32 v13, v138, v253, v139
		v_max3_f32 v10, v10, v243, v13
		v_max_f32_e32 v10, v10, v157
		v_mov_b32_e32 v138, v10
		v_mov_b32_e32 v139, v10
		s_nop 1
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v140, v138, v139
		v_max3_f32 v10, v96, v97, v158
		v_max3_f32 v13, v178, v179, v180
		v_max3_f32 v138, v98, v99, v100
		v_max3_f32 v139, v102, v103, v104
		v_max3_f32 v141, v106, v107, v80
		v_max3_f32 v166, v82, v83, v84
		v_max3_f32 v167, v86, v87, v88
		v_max3_f32 v168, v90, v91, v92
		v_max3_f32 v169, v94, v95, v112
		v_max3_f32 v170, v116, v117, v118
		v_max3_f32 v171, v186, v187, v188
		v_max3_f32 v172, v124, v125, v190
		v_max3_f32 v173, v122, v123, v126
		v_max3_f32 v174, v130, v131, v160
		v_max3_f32 v175, v132, v133, v134
		v_max3_f32 v194, v136, v137, v164
		v_max3_f32 v10, v10, v159, v13
		v_max3_f32 v13, v138, v101, v139
		v_max3_f32 v138, v141, v81, v166
		v_max3_f32 v139, v167, v89, v168
		v_max3_f32 v141, v169, v113, v170
		v_max3_f32 v166, v171, v189, v172
		v_max3_f32 v167, v173, v127, v174
		v_max3_f32 v168, v175, v135, v194
		v_max3_f32 v10, v10, v181, v13
		v_max3_f32 v13, v138, v85, v139
		v_max3_f32 v138, v141, v119, v166
		v_max3_f32 v139, v167, v161, v168
		v_max3_f32 v10, v10, v105, v13
		v_max3_f32 v13, v138, v191, v139
		v_max3_f32 v10, v10, v93, v13
		v_max_f32_e32 v10, v10, v165
		v_mov_b32_e32 v138, v10
		v_mov_b32_e32 v139, v10
		s_nop 1
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v141, v138, v139
		v_pk_mul_f32 v[138:139], v[140:141], v[8:9]
		v_max_f32_e32 v140, v7, v138
		v_max_f32_e32 v141, v11, v139
		v_pk_fma_f32 v[138:139], v[254:255], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[224:225], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[176:177], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[228:229], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[182:183], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[230:231], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[184:185], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[234:235], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[108:109], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[236:237], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[110:111], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[238:239], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[114:115], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[240:241], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[120:121], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[242:243], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[192:193], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[244:245], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[128:129], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[246:247], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[162:163], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[248:249], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[250:251], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[252:253], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[142:143], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[8:9], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[96:97], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[158:159], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[178:179], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[98:99], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[80:81], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[80:81], v[82:83], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[82:83], v[84:85], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[84:85], v[86:87], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[86:87], v[88:89], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[88:89], v[90:91], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[90:91], v[92:93], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[92:93], v[94:95], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[94:95], v[112:113], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[116:117], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[186:187], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[124:125], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[190:191], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[122:123], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[160:161], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[132:133], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[134:135], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[164:165], v[8:9], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v164, v138
		v_exp_f32_e32 v212, v139
		v_exp_f32_e32 v165, v166
		v_exp_f32_e32 v213, v167
		v_exp_f32_e32 v138, v168
		v_exp_f32_e32 v166, v169
		v_exp_f32_e32 v139, v170
		v_exp_f32_e32 v167, v171
		v_exp_f32_e32 v168, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v169, v174
		v_exp_f32_e32 v171, v175
		v_exp_f32_e32 v172, v176
		v_exp_f32_e32 v174, v177
		v_exp_f32_e32 v173, v182
		v_exp_f32_e32 v175, v183
		v_exp_f32_e32 v176, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v177, v108
		v_exp_f32_e32 v183, v109
		v_exp_f32_e32 v108, v194
		v_exp_f32_e32 v184, v195
		v_exp_f32_e32 v109, v110
		v_exp_f32_e32 v185, v111
		v_exp_f32_e32 v110, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v111, v114
		v_exp_f32_e32 v195, v115
		v_exp_f32_e32 v114, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v115, v120
		v_exp_f32_e32 v197, v121
		v_exp_f32_e32 v120, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v121, v192
		v_exp_f32_e32 v199, v193
		v_exp_f32_e32 v192, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v193, v128
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
		v_exp_f32_e32 v156, v96
		v_exp_f32_e32 v214, v97
		v_exp_f32_e32 v157, v158
		v_exp_f32_e32 v215, v159
		v_exp_f32_e32 v96, v178
		v_exp_f32_e32 v158, v179
		v_exp_f32_e32 v97, v180
		v_exp_f32_e32 v159, v181
		v_exp_f32_e32 v178, v98
		v_exp_f32_e32 v180, v99
		v_exp_f32_e32 v179, v100
		v_exp_f32_e32 v181, v101
		v_exp_f32_e32 v98, v102
		v_exp_f32_e32 v100, v103
		v_exp_f32_e32 v99, v104
		v_exp_f32_e32 v101, v105
		v_exp_f32_e32 v102, v106
		v_exp_f32_e32 v104, v107
		v_exp_f32_e32 v103, v80
		v_exp_f32_e32 v105, v81
		v_exp_f32_e32 v80, v82
		v_exp_f32_e32 v106, v83
		v_exp_f32_e32 v81, v84
		v_exp_f32_e32 v107, v85
		v_exp_f32_e32 v82, v86
		v_exp_f32_e32 v84, v87
		v_exp_f32_e32 v83, v88
		v_exp_f32_e32 v85, v89
		v_exp_f32_e32 v86, v90
		v_exp_f32_e32 v88, v91
		v_exp_f32_e32 v87, v92
		v_exp_f32_e32 v89, v93
		v_exp_f32_e32 v90, v94
		v_exp_f32_e32 v92, v95
		v_exp_f32_e32 v91, v112
		v_exp_f32_e32 v93, v113
		v_exp_f32_e32 v94, v116
		v_exp_f32_e32 v112, v117
		v_exp_f32_e32 v95, v118
		v_exp_f32_e32 v113, v119
		v_exp_f32_e32 v116, v186
		v_exp_f32_e32 v118, v187
		v_exp_f32_e32 v117, v188
		v_exp_f32_e32 v119, v189
		v_exp_f32_e32 v186, v124
		v_exp_f32_e32 v188, v125
		v_exp_f32_e32 v187, v190
		v_exp_f32_e32 v189, v191
		v_exp_f32_e32 v124, v122
		v_exp_f32_e32 v190, v123
		v_exp_f32_e32 v125, v126
		v_exp_f32_e32 v191, v127
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
		v_pk_add_f32 v[136:137], v[164:165], v[212:213]
		v_pk_add_f32 v[216:217], v[138:139], v[166:167]
		v_pk_add_f32 v[218:219], v[168:169], v[170:171]
		v_pk_add_f32 v[220:221], v[172:173], v[174:175]
		v_pk_add_f32 v[222:223], v[176:177], v[182:183]
		v_pk_add_f32 v[224:225], v[108:109], v[184:185]
		v_pk_add_f32 v[226:227], v[110:111], v[194:195]
		v_pk_add_f32 v[228:229], v[114:115], v[196:197]
		v_pk_add_f32 v[230:231], v[120:121], v[198:199]
		v_pk_add_f32 v[232:233], v[192:193], v[200:201]
		v_pk_add_f32 v[234:235], v[128:129], v[202:203]
		v_pk_add_f32 v[236:237], v[162:163], v[204:205]
		v_pk_add_f32 v[238:239], v[206:207], v[208:209]
		v_pk_add_f32 v[240:241], v[142:143], v[210:211]
		v_pk_add_f32 v[242:243], v[144:145], v[146:147]
		v_pk_add_f32 v[244:245], v[148:149], v[150:151]
		v_mov_b32_e32 v246, v137
		v_mov_b32_e32 v247, v217
		v_mov_b32_e32 v248, v136
		v_mov_b32_e32 v249, v216
		v_pk_add_f32 v[136:137], v[248:249], v[246:247]
		v_mov_b32_e32 v216, v219
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v246, v218
		v_mov_b32_e32 v247, v220
		v_pk_add_f32 v[218:219], v[246:247], v[216:217]
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
		v_mov_b32_e32 v216, v231
		v_mov_b32_e32 v217, v233
		v_mov_b32_e32 v220, v230
		v_mov_b32_e32 v221, v232
		v_pk_add_f32 v[226:227], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v235
		v_mov_b32_e32 v217, v237
		v_mov_b32_e32 v220, v234
		v_mov_b32_e32 v221, v236
		v_pk_add_f32 v[228:229], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v239
		v_mov_b32_e32 v217, v241
		v_mov_b32_e32 v220, v238
		v_mov_b32_e32 v221, v240
		v_pk_add_f32 v[230:231], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v243
		v_mov_b32_e32 v217, v245
		v_mov_b32_e32 v220, v242
		v_mov_b32_e32 v221, v244
		v_pk_add_f32 v[232:233], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v137
		v_mov_b32_e32 v217, v219
		v_mov_b32_e32 v220, v136
		v_mov_b32_e32 v221, v218
		v_pk_add_f32 v[136:137], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v225
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v227
		v_mov_b32_e32 v217, v229
		v_mov_b32_e32 v218, v226
		v_mov_b32_e32 v219, v228
		v_pk_add_f32 v[222:223], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v231
		v_mov_b32_e32 v217, v233
		v_mov_b32_e32 v218, v230
		v_mov_b32_e32 v219, v232
		v_pk_add_f32 v[224:225], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v137
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v218, v136
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[136:137], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v225
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v137
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v218, v136
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[136:137], v[218:219], v[216:217]
		v_add_f32_e32 v10, v136, v137
		v_accvgpr_read_b32 v13, a77
		ds_bpermute_b32 v152, v13, v10
		v_accvgpr_read_b32 v13, a78
		ds_bpermute_b32 v154, v13, v10
		v_pk_add_f32 v[136:137], v[156:157], v[214:215]
		v_pk_add_f32 v[216:217], v[96:97], v[158:159]
		v_pk_add_f32 v[218:219], v[178:179], v[180:181]
		v_pk_add_f32 v[220:221], v[98:99], v[100:101]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[222:223], v[152:153], v[154:155]
		v_pk_add_f32 v[224:225], v[102:103], v[104:105]
		v_pk_add_f32 v[226:227], v[80:81], v[106:107]
		v_pk_add_f32 v[228:229], v[82:83], v[84:85]
		v_pk_add_f32 v[230:231], v[86:87], v[88:89]
		v_pk_add_f32 v[232:233], v[90:91], v[92:93]
		v_pk_add_f32 v[234:235], v[94:95], v[112:113]
		v_pk_add_f32 v[236:237], v[116:117], v[118:119]
		v_pk_add_f32 v[238:239], v[186:187], v[188:189]
		v_pk_add_f32 v[240:241], v[124:125], v[190:191]
		v_pk_add_f32 v[242:243], v[122:123], v[126:127]
		v_pk_add_f32 v[244:245], v[130:131], v[160:161]
		v_mov_b32_e32 v133, v223
		v_mov_b32_e32 v135, v136
		v_pk_add_f32 v[246:247], v[132:133], v[134:135]
		v_mov_b32_e32 v248, v137
		v_mov_b32_e32 v249, v218
		v_pk_add_f32 v[136:137], v[248:249], v[216:217]
		v_mov_b32_e32 v216, v219
		v_mov_b32_e32 v217, v224
		v_pk_add_f32 v[216:217], v[216:217], v[220:221]
		v_mov_b32_e32 v218, v225
		v_mov_b32_e32 v219, v228
		v_pk_add_f32 v[220:221], v[218:219], v[226:227]
		v_mov_b32_e32 v218, v229
		v_mov_b32_e32 v219, v232
		v_pk_add_f32 v[218:219], v[218:219], v[230:231]
		v_mov_b32_e32 v224, v233
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[226:227], v[224:225], v[234:235]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v240
		v_pk_add_f32 v[224:225], v[224:225], v[238:239]
		v_mov_b32_e32 v228, v241
		v_mov_b32_e32 v229, v244
		v_pk_add_f32 v[230:231], v[228:229], v[242:243]
		v_mov_b32_e32 v228, v245
		v_mov_b32_e32 v229, v136
		v_pk_add_f32 v[228:229], v[228:229], v[246:247]
		v_mov_b32_e32 v232, v137
		v_mov_b32_e32 v233, v220
		v_pk_add_f32 v[136:137], v[232:233], v[216:217]
		v_mov_b32_e32 v216, v221
		v_mov_b32_e32 v217, v226
		v_pk_add_f32 v[216:217], v[216:217], v[218:219]
		v_mov_b32_e32 v218, v227
		v_mov_b32_e32 v219, v230
		v_pk_add_f32 v[220:221], v[218:219], v[224:225]
		v_mov_b32_e32 v218, v231
		v_mov_b32_e32 v219, v136
		v_pk_add_f32 v[218:219], v[218:219], v[228:229]
		v_mov_b32_e32 v224, v137
		v_mov_b32_e32 v225, v220
		v_pk_add_f32 v[136:137], v[224:225], v[216:217]
		v_mov_b32_e32 v216, v221
		v_mov_b32_e32 v217, v136
		v_pk_add_f32 v[220:221], v[216:217], v[218:219]
		v_add_f32_e32 v10, v137, v220
		v_add_f32_e32 v10, v221, v10
		v_mov_b32_e32 v136, v10
		v_mov_b32_e32 v137, v10
		s_nop 1
		v_permlane32_swap_b32_e32 v136, v137
		v_add_f32_e32 v217, v136, v137
		v_sub_f32_e32 v7, v7, v140
		v_sub_f32_e32 v10, v11, v141
		v_exp_f32_e32 v136, v7
		v_exp_f32_e32 v218, v10
		v_mov_b32_e32 v137, v136
		v_pk_mul_f32 v[16:17], v[16:17], v[136:137]
		v_pk_mul_f32 v[18:19], v[18:19], v[136:137]
		v_pk_mul_f32 v[20:21], v[20:21], v[136:137]
		v_pk_mul_f32 v[22:23], v[22:23], v[136:137]
		v_pk_mul_f32 v[24:25], v[24:25], v[136:137]
		v_pk_mul_f32 v[26:27], v[26:27], v[136:137]
		v_pk_mul_f32 v[28:29], v[28:29], v[136:137]
		v_pk_mul_f32 v[30:31], v[30:31], v[136:137]
		v_pk_mul_f32 v[32:33], v[32:33], v[136:137]
		v_pk_mul_f32 v[34:35], v[34:35], v[136:137]
		v_pk_mul_f32 v[36:37], v[36:37], v[136:137]
		v_pk_mul_f32 v[38:39], v[38:39], v[136:137]
		v_pk_mul_f32 v[40:41], v[40:41], v[136:137]
		v_pk_mul_f32 v[42:43], v[42:43], v[136:137]
		v_pk_mul_f32 v[44:45], v[44:45], v[136:137]
		v_pk_mul_f32 v[46:47], v[46:47], v[136:137]
		v_mov_b32_e32 v219, v218
		v_pk_mul_f32 v[48:49], v[48:49], v[218:219]
		v_pk_mul_f32 v[50:51], v[50:51], v[218:219]
		v_pk_mul_f32 v[52:53], v[52:53], v[218:219]
		v_pk_mul_f32 v[54:55], v[54:55], v[218:219]
		v_pk_mul_f32 v[56:57], v[56:57], v[218:219]
		v_pk_mul_f32 v[58:59], v[58:59], v[218:219]
		v_pk_mul_f32 v[60:61], v[60:61], v[218:219]
		v_pk_mul_f32 v[62:63], v[62:63], v[218:219]
		v_pk_mul_f32 v[64:65], v[64:65], v[218:219]
		v_pk_mul_f32 v[66:67], v[66:67], v[218:219]
		v_pk_mul_f32 v[68:69], v[68:69], v[218:219]
		v_pk_mul_f32 v[70:71], v[70:71], v[218:219]
		v_pk_mul_f32 v[72:73], v[72:73], v[218:219]
		v_pk_mul_f32 v[74:75], v[74:75], v[218:219]
		v_pk_mul_f32 v[76:77], v[76:77], v[218:219]
		v_pk_mul_f32 v[78:79], v[78:79], v[218:219]
		v_mov_b32_e32 v10, v136
		v_mov_b32_e32 v11, v218
		v_mov_b32_e32 v216, v222
		v_mov_b64_e32 v[136:137], v[14:15]
		v_pk_fma_f32 v[14:15], v[136:137], v[10:11], v[216:217]
		v_cvt_pk_bf16_f32 v216, v164, v212
		v_cvt_pk_bf16_f32 v217, v165, v213
		v_cvt_pk_bf16_f32 v218, v138, v166
		v_cvt_pk_bf16_f32 v219, v139, v167
		v_cvt_pk_bf16_f32 v136, v168, v170
		v_cvt_pk_bf16_f32 v137, v169, v171
		v_cvt_pk_bf16_f32 v138, v172, v174
		v_cvt_pk_bf16_f32 v139, v173, v175
		v_cvt_pk_bf16_f32 v164, v176, v182
		v_cvt_pk_bf16_f32 v165, v177, v183
		v_cvt_pk_bf16_f32 v166, v108, v184
		v_cvt_pk_bf16_f32 v167, v109, v185
		v_cvt_pk_bf16_f32 v168, v110, v194
		v_cvt_pk_bf16_f32 v169, v111, v195
		v_cvt_pk_bf16_f32 v170, v114, v196
		v_cvt_pk_bf16_f32 v171, v115, v197
		v_cvt_pk_bf16_f32 v108, v120, v198
		v_cvt_pk_bf16_f32 v109, v121, v199
		v_cvt_pk_bf16_f32 v110, v192, v200
		v_cvt_pk_bf16_f32 v111, v193, v201
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
		v_cvt_pk_bf16_f32 v145, v156, v214
		v_cvt_pk_bf16_f32 v146, v157, v215
		v_cvt_pk_bf16_f32 v147, v96, v158
		v_cvt_pk_bf16_f32 v148, v97, v159
		v_cvt_pk_bf16_f32 v149, v178, v180
		v_cvt_pk_bf16_f32 v150, v179, v181
		v_cvt_pk_bf16_f32 v151, v98, v100
		v_cvt_pk_bf16_f32 v152, v99, v101
		v_cvt_pk_bf16_f32 v153, v102, v104
		v_cvt_pk_bf16_f32 v154, v103, v105
		v_cvt_pk_bf16_f32 v155, v80, v106
		v_cvt_pk_bf16_f32 v96, v81, v107
		v_cvt_pk_bf16_f32 v97, v82, v84
		v_cvt_pk_bf16_f32 v98, v83, v85
		v_cvt_pk_bf16_f32 v99, v86, v88
		v_cvt_pk_bf16_f32 v80, v87, v89
		v_cvt_pk_bf16_f32 v81, v90, v92
		v_cvt_pk_bf16_f32 v82, v91, v93
		v_cvt_pk_bf16_f32 v83, v94, v112
		v_cvt_pk_bf16_f32 v84, v95, v113
		v_cvt_pk_bf16_f32 v85, v116, v118
		v_cvt_pk_bf16_f32 v86, v117, v119
		v_cvt_pk_bf16_f32 v87, v186, v188
		v_cvt_pk_bf16_f32 v88, v187, v189
		v_cvt_pk_bf16_f32 v89, v124, v190
		v_cvt_pk_bf16_f32 v90, v125, v191
		v_cvt_pk_bf16_f32 v91, v122, v126
		v_cvt_pk_bf16_f32 v92, v123, v127
		v_cvt_pk_bf16_f32 v93, v130, v160
		v_cvt_pk_bf16_f32 v94, v131, v161
		v_cvt_pk_bf16_f32 v95, v132, v134
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
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
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v80, v82
		v_permlane32_swap_b32_e32 v81, v83
		v_permlane32_swap_b32_e32 v84, v86
		v_permlane32_swap_b32_e32 v85, v87
		v_permlane32_swap_b32_e32 v88, v90
		v_permlane32_swap_b32_e32 v89, v91
		v_permlane32_swap_b32_e32 v92, v94
		v_permlane32_swap_b32_e32 v93, v95
		v_mfma_f32_32x32x16_bf16 v[16:31], a[192:195], v[216:219], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[224:227], v[216:219], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[224:227], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[192:195], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[196:199], v[136:139], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[228:231], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[228:231], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[196:199], v[148:151], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[200:203], v[164:167], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[232:235], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[232:235], v[152:155], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[200:203], v[152:155], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[204:207], v[168:171], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[236:239], v[168:171], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[236:239], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[204:207], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[208:211], v[108:111], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[240:243], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[240:243], v[80:83], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[208:211], v[80:83], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[212:215], v[172:175], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[244:247], v[172:175], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[244:247], v[84:87], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[212:215], v[84:87], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[216:219], v[192:195], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[248:251], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[248:251], v[88:91], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[88:91], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[220:223], v[196:199], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[252:255], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[252:255], v[92:95], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[92:95], v[48:63]
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s1, s25
		s_mov_b32 s42, s1
		v_mov_b32_e32 v7, v140
		v_mov_b32_e32 v11, v141
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v2, v14
		v_rcp_f32_e32 v4, v15
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[6:7], v[16:17], v[2:3]
		v_pk_mul_f32 v[8:9], v[18:19], v[2:3]
		v_pk_mul_f32 v[10:11], v[20:21], v[2:3]
		v_pk_mul_f32 v[12:13], v[22:23], v[2:3]
		v_pk_mul_f32 v[14:15], v[24:25], v[2:3]
		v_pk_mul_f32 v[16:17], v[26:27], v[2:3]
		v_pk_mul_f32 v[18:19], v[28:29], v[2:3]
		v_pk_mul_f32 v[20:21], v[30:31], v[2:3]
		v_pk_mul_f32 v[22:23], v[32:33], v[2:3]
		v_pk_mul_f32 v[24:25], v[34:35], v[2:3]
		v_pk_mul_f32 v[26:27], v[36:37], v[2:3]
		v_pk_mul_f32 v[28:29], v[38:39], v[2:3]
		v_pk_mul_f32 v[30:31], v[40:41], v[2:3]
		v_pk_mul_f32 v[32:33], v[42:43], v[2:3]
		v_pk_mul_f32 v[34:35], v[44:45], v[2:3]
		v_pk_mul_f32 v[36:37], v[46:47], v[2:3]
		v_mov_b32_e32 v5, v4
		v_pk_mul_f32 v[2:3], v[48:49], v[4:5]
		v_pk_mul_f32 v[38:39], v[50:51], v[4:5]
		v_pk_mul_f32 v[40:41], v[52:53], v[4:5]
		v_pk_mul_f32 v[42:43], v[54:55], v[4:5]
		v_pk_mul_f32 v[44:45], v[56:57], v[4:5]
		v_pk_mul_f32 v[46:47], v[58:59], v[4:5]
		v_pk_mul_f32 v[48:49], v[60:61], v[4:5]
		v_pk_mul_f32 v[50:51], v[62:63], v[4:5]
		v_pk_mul_f32 v[52:53], v[64:65], v[4:5]
		v_pk_mul_f32 v[54:55], v[66:67], v[4:5]
		v_pk_mul_f32 v[56:57], v[68:69], v[4:5]
		v_pk_mul_f32 v[58:59], v[70:71], v[4:5]
		v_pk_mul_f32 v[60:61], v[72:73], v[4:5]
		v_pk_mul_f32 v[62:63], v[74:75], v[4:5]
		v_pk_mul_f32 v[64:65], v[76:77], v[4:5]
		v_pk_mul_f32 v[66:67], v[78:79], v[4:5]
		v_accvgpr_read_b32 v1, a18
		v_mov_b32_e32 v4, 8
		v_mul_lo_u32 v4, v4, v1
		v_xor_b32_e32 v1, 16, v4
		v_xor_b32_e32 v5, 32, v4
		v_xor_b32_e32 v68, 48, v4
		s_mov_b32 s1, 64
		v_cmp_lt_i32_e64 vcc, v4, s1
		s_mov_b64 s[24:25], vcc
		v_mov_b32_e32 v70, s22
		v_mov_b32_e32 v71, s23
		s_nop 0
		v_readfirstlane_b32 s22, v70
		v_readfirstlane_b32 s23, v71
		s_nop 1
		v_mov_b32_e32 v4, s23
		v_mov_b32_e32 v69, s22
		s_nop 0
		v_readfirstlane_b32 s19, v69
		s_and_b32 s22, s19, s24
		v_readfirstlane_b32 s19, v4
		s_and_b32 s23, s19, s25
		v_cmp_lt_i32_e64 vcc, v1, s1
		s_mov_b64 s[26:27], vcc
		v_readfirstlane_b32 s19, v69
		s_and_b32 s32, s19, s26
		v_readfirstlane_b32 s19, v4
		s_and_b32 s33, s19, s27
		v_cmp_lt_i32_e64 vcc, v5, s1
		s_mov_b64 s[34:35], vcc
		v_readfirstlane_b32 s19, v69
		s_and_b32 s36, s19, s34
		v_readfirstlane_b32 s19, v4
		s_and_b32 s37, s19, s35
		v_cmp_lt_i32_e64 vcc, v68, s1
		s_mov_b64 s[38:39], vcc
		v_readfirstlane_b32 s1, v69
		s_and_b32 s40, s1, s38
		v_readfirstlane_b32 s1, v4
		s_and_b32 s41, s1, s39
		v_accvgpr_read_b32 v1, a16
		s_nop 0
		v_readfirstlane_b32 s42, v1
		v_accvgpr_read_b32 v1, a17
		s_nop 0
		v_readfirstlane_b32 s43, v1
		s_nop 1
		v_mov_b32_e32 v1, s43
		v_mov_b32_e32 v4, s42
		s_nop 0
		v_readfirstlane_b32 s1, v4
		s_and_b32 s42, s1, s24
		v_readfirstlane_b32 s1, v1
		s_and_b32 s43, s1, s25
		v_readfirstlane_b32 s1, v4
		s_and_b32 s24, s1, s26
		v_readfirstlane_b32 s1, v1
		s_and_b32 s25, s1, s27
		v_readfirstlane_b32 s1, v4
		s_and_b32 s26, s1, s34
		v_readfirstlane_b32 s1, v1
		s_and_b32 s27, s1, s35
		v_readfirstlane_b32 s1, v4
		s_and_b32 s34, s1, s38
		v_readfirstlane_b32 s1, v1
		s_and_b32 s35, s1, s39
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
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s19, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s38, v1
		s_mul_i32 s19, s38, s19
		s_lshl_b32 s19, s19, 1
		s_add_i32 s38, s1, s19
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s39, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s44, v1
		s_mul_i32 s39, s44, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_accvgpr_read_b32 v1, a13
		v_mul_lo_u32 v1, s18, v1
		v_lshl_add_u32 v2, v1, 6, s38
		v_accvgpr_read_b32 v3, a19
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v32, a23
		v_mul_lo_u32 v32, s18, v32
		v_lshl_add_u32 v2, v32, 5, v2
		v_accvgpr_read_b32 v33, a64
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
		s_and_saveexec_b64 s[90:91], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[68:71], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[90:91], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s1, 32
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v36, a22
		v_lshl_add_u32 v2, v36, 4, v2
		s_and_saveexec_b64 s[90:91], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[4:7], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[90:91], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s1, 64
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[8:11], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[90:91], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s1, 0x60
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[12:15], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[90:91], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s22, s18, 8
		s_add_i32 s23, s22, s1
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[16:19], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[90:91], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s23, s22, 32
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[20:23], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[90:91], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s23, s22, 64
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a22
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[24:27], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s22, 0x60
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s39
		v_lshl_add_u32 v1, v1, 6, s1
		v_lshl_add_u32 v1, v3, 1, v1
		v_lshl_add_u32 v1, v32, 5, v1
		v_lshl_add_u32 v1, v33, 4, v1
		v_lshl_add_u32 v1, v34, 3, v1
		v_lshl_add_u32 v1, v35, 2, v1
		v_accvgpr_read_b32 v2, a22
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[90:91], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v1, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[90:91], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[90:91]
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_and_b32 s1, s0, 15
		s_mul_i32 s1, s1, 2
		s_add_i32 s1, s1, 1
		s_cmp_lt_i32 s1, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_3
		s_lshr_b32 s19, s1, 1
		s_and_b32 s1, s1, 1
		s_xor_b32 s22, s19, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s22, s22, 31
		s_cmp_eq_u32 s1, 0
		s_cselect_b32 s1, s19, s22
		s_mul_i32 s19, s1, 0x100
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
		v_accvgpr_write_b32 a12, v13
		v_accvgpr_read_b32 v13, a12
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v13
		v_bitop3_b32 v5, v5, v12, v14 bitop3:0x96
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 64
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v5, v5, v16
		v_accvgpr_write_b32 a13, v5
		v_accvgpr_read_b32 v5, a13
		v_add_u32_e32 v5, s19, v5
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v4
		v_xor_b32_e32 v1, v1, v6
		v_bitop3_b32 v1, v1, v9, v12 bitop3:0x96
		v_bitop3_b32 v1, v1, v14, v16 bitop3:0x96
		v_accvgpr_write_b32 a14, v1
		v_accvgpr_read_b32 v1, a14
		v_add_u32_e32 v1, s19, v1
		v_cmp_lt_i32_e64 vcc, v5, s20
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_i32_e64 vcc, v1, s20
		s_mov_b64 s[24:25], vcc
		v_mov_b32_e32 v1, 2
		v_mul_lo_u32 v1, v1, v11
		v_lshrrev_b32_e32 v4, 5, v0
		v_and_b32_e32 v5, 1, v4
		v_accvgpr_write_b32 a15, v5
		v_accvgpr_read_b32 v5, a15
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v5, v8, v1, v6 bitop3:0x96
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v13
		v_xor_b32_e32 v5, v5, v9
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v15
		v_xad_u32 v5, v5, v12, s19
		v_bitop3_b32 v14, 32, v8, v1 bitop3:0x96
		v_bitop3_b32 v14, v14, v6, v9 bitop3:0x96
		v_xad_u32 v14, v14, v12, s19
		v_bitop3_b32 v16, 64, v8, v1 bitop3:0x96
		v_bitop3_b32 v16, v16, v6, v9 bitop3:0x96
		v_xad_u32 v16, v16, v12, s19
		v_xor_b32_e32 v17, 0x60, v8
		v_xor_b32_e32 v17, v17, v1
		v_xor_b32_e32 v17, v17, v6
		v_xor_b32_e32 v17, v17, v9
		v_xad_u32 v17, v17, v12, s19
		v_xor_b32_e32 v18, 0x80, v8
		v_xor_b32_e32 v18, v18, v1
		v_xor_b32_e32 v18, v18, v6
		v_xor_b32_e32 v18, v18, v9
		v_xad_u32 v18, v18, v12, s19
		v_xor_b32_e32 v19, 0xa0, v8
		v_xor_b32_e32 v19, v19, v1
		v_xor_b32_e32 v19, v19, v6
		v_xor_b32_e32 v19, v19, v9
		v_xad_u32 v19, v19, v12, s19
		v_xor_b32_e32 v20, 0xc0, v8
		v_xor_b32_e32 v20, v20, v1
		v_xor_b32_e32 v20, v20, v6
		v_xor_b32_e32 v20, v20, v9
		v_xad_u32 v20, v20, v12, s19
		v_xor_b32_e32 v21, 0xe0, v8
		v_xor_b32_e32 v1, v21, v1
		v_xor_b32_e32 v1, v1, v6
		v_xor_b32_e32 v1, v1, v9
		v_xad_u32 v1, v1, v12, s19
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		v_accvgpr_read_b32 v9, a6
		v_and_b32_e32 v9, 0xffff, v9
		v_lshlrev_b32_e32 v12, 16, v9
		v_or_b32_e32 v24, v9, v12
		v_mov_b32_e32 v25, v24
		v_mov_b32_e32 v26, v24
		v_mov_b32_e32 v27, v24
		s_mul_i32 s26, s1, s12
		s_lshl_b32 s26, s26, 9
		v_accvgpr_read_b32 v9, a10
		s_nop 0
		v_readfirstlane_b32 s27, v9
		s_mul_i32 s27, s27, s10
		s_lshl_b32 s27, s27, 1
		s_add_i32 s32, s26, s27
		v_accvgpr_read_b32 v9, a11
		s_nop 0
		v_readfirstlane_b32 s33, v9
		s_mul_i32 s33, s33, s11
		s_lshl_b32 s33, s33, 1
		s_add_i32 s32, s32, s33
		v_mul_lo_u32 v9, s12, v7
		v_lshl_add_u32 v12, v9, 1, s32
		v_and_b32_e32 v21, 1, v0
		v_accvgpr_write_b32 a16, v21
		v_accvgpr_read_b32 v21, a16
		v_lshl_add_u32 v12, v21, 4, v12
		v_and_b32_e32 v21, 1, v3
		v_accvgpr_write_b32 a17, v21
		v_accvgpr_read_b32 v21, a17
		v_lshl_add_u32 v12, v21, 6, v12
		v_and_b32_e32 v2, 1, v2
		v_accvgpr_write_b32 a18, v2
		v_accvgpr_read_b32 v2, a18
		v_lshl_add_u32 v2, v2, 5, v12
		v_cmp_lt_i32_e64 vcc, v5, s20
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
		s_add_i32 s32, s32, s26
		s_add_i32 s32, s32, s27
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v9, 1, s32
		v_accvgpr_read_b32 v5, a16
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a17
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a18
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v14, s20
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
		s_add_i32 s32, s32, s26
		s_add_i32 s32, s32, s27
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v9, 1, s32
		v_accvgpr_read_b32 v5, a16
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a17
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a18
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v16, s20
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
		s_add_i32 s32, s32, s26
		s_add_i32 s32, s32, s27
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v9, 1, s32
		v_accvgpr_read_b32 v5, a16
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a17
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a18
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v17, s20
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
		s_add_i32 s32, s32, s26
		s_add_i32 s32, s32, s27
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v9, 1, s32
		v_accvgpr_read_b32 v5, a16
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a17
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a18
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v18, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[44:47], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v44, v24
		v_mov_b32_e32 v45, v25
		v_mov_b32_e32 v46, v26
		v_mov_b32_e32 v47, v27
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s32, 0x140, s12
		s_add_i32 s32, s32, s26
		s_add_i32 s32, s32, s27
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v9, 1, s32
		v_accvgpr_read_b32 v5, a16
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a17
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a18
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v19, s20
		s_and_saveexec_b64 s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[16:19], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[90:91], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v16, v24
		v_mov_b32_e32 v17, v25
		v_mov_b32_e32 v18, v26
		v_mov_b32_e32 v19, v27
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[90:91]
		s_mul_i32 s32, 0x180, s12
		s_add_i32 s32, s32, s26
		s_add_i32 s32, s32, s27
		s_add_i32 s32, s32, s33
		v_lshl_add_u32 v2, v9, 1, s32
		v_accvgpr_read_b32 v5, a16
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a17
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a18
		v_lshl_add_u32 v2, v5, 5, v2
		v_cmp_lt_i32_e64 vcc, v20, s20
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
		s_add_i32 s26, s32, s26
		s_add_i32 s26, s26, s27
		s_add_i32 s26, s26, s33
		v_lshl_add_u32 v2, v9, 1, s26
		v_accvgpr_read_b32 v5, a16
		v_lshl_add_u32 v2, v5, 4, v2
		v_accvgpr_read_b32 v5, a17
		v_lshl_add_u32 v2, v5, 6, v2
		v_accvgpr_read_b32 v5, a18
		v_lshl_add_u32 v2, v5, 5, v2
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
		v_accvgpr_read_b32 v1, a12
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 2, v1
		v_and_b32_e32 v2, 1, v4
		v_accvgpr_write_b32 a19, v2
		v_accvgpr_read_b32 v2, a19
		v_lshlrev_b32_e32 v2, 1, v2
		v_and_b32_e32 v4, 1, v10
		v_accvgpr_write_b32 a20, v4
		v_accvgpr_read_b32 v4, a20
		v_xor_b32_e32 v4, v0, v4
		v_bitop3_b32 v1, v1, v2, v4 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[28:31] offset:18864
		ds_write_b128 v1, v[32:35] offset:22960
		ds_write_b128 v1, v[36:39] offset:27056
		ds_write_b128 v1, v[40:43] offset:31152
		v_accvgpr_read_b32 v2, a12
		v_lshlrev_b32_e32 v2, 12, v2
		v_add_u32_e32 v2, 0x10000, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 3, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v9, 6, v5
		v_add_u32_e32 v10, v2, v9
		v_lshrrev_b32_e32 v12, 2, v4
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v14, 5, v12
		v_add_u32_e32 v24, v10, v14
		v_lshrrev_b32_e32 v25, 5, v4
		v_accvgpr_write_b32 a21, v25
		v_lshrrev_b32_e32 v25, 4, v4
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 7, v25
		v_lshrrev_b32_e32 v26, 1, v4
		v_and_b32_e32 v26, 1, v26
		v_lshlrev_b32_e32 v27, 4, v26
		v_and_b32_e32 v28, 1, v4
		v_lshlrev_b32_e32 v28, 3, v28
		v_add3_u32 v29, v25, v9, v14
		v_add_u32_e32 v29, v29, v27
		v_accvgpr_read_b32 v30, a21
		v_add3_u32 v30, v30, v28, v29
		v_xor_b32_e32 v30, v30, v26
		v_lshl_add_u32 v24, v30, 4, v24
		ds_read_b128 a[24:27], v24 offset:18864
		v_lshlrev_b32_e32 v12, 1, v12
		v_accvgpr_read_b32 v30, a21
		v_add_u32_e32 v30, 2, v30
		v_add3_u32 v30, v30, v28, v29
		v_bitop3_b32 v30, v12, v30, v26 bitop3:0x96
		v_lshl_add_u32 v10, v30, 4, v10
		ds_read_b128 a[28:31], v10 offset:18864
		v_accvgpr_read_b32 v30, a21
		v_add_u32_e32 v30, 4, v30
		v_add3_u32 v29, v30, v28, v29
		v_xad_u32 v29, v29, v26, v12
		v_lshlrev_b32_e32 v5, 2, v5
		v_xor_b32_e32 v29, v29, v5
		v_lshl_add_u32 v29, v29, 4, v2
		ds_read_b128 a[32:35], v29 offset:18864
		v_accvgpr_read_b32 v30, a21
		v_add_u32_e32 v30, 6, v30
		v_add_u32_e32 v25, v30, v25
		v_add3_u32 v9, v25, v9, v14
		v_add3_u32 v9, v9, v27, v28
		v_xor_b32_e32 v9, v9, v26
		v_bitop3_b32 v5, v5, v12, v9 bitop3:0x96
		v_lshl_add_u32 v2, v5, 4, v2
		ds_read_b128 a[36:39], v2 offset:18864
		s_add_i32 s26, s1, 1
		s_mul_i32 s26, s26, 0x100
		s_mov_b32 s27, 0x7f
		v_mov_b32_e32 v5, 64
		v_mul_lo_u32 v5, v5, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[44:47] offset:18864
		ds_write_b128 v1, v[16:19] offset:22960
		ds_write_b128 v1, v[20:23] offset:27056
		ds_write_b128 v1, v[48:51] offset:31152
		v_mov_b32_e32 v1, 32
		v_mul_lo_u32 v1, v1, v11
		v_accvgpr_read_b32 v9, a15
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[40:43], v24 offset:18864
		ds_read_b128 a[44:47], v10 offset:18864
		ds_read_b128 a[48:51], v29 offset:18864
		ds_read_b128 a[52:55], v2 offset:18864
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s28, v2
		s_add_i32 s26, s26, s28
		s_cmp_lt_i32 s21, s26
		s_cselect_b32 s26, s21, s26
		s_add_i32 s28, s26, 0x7f
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s28, 0
		s_cselect_b32 s29, s27, 0
		s_add_i32 s28, s28, s29
		s_ashr_i32 s28, s28, 7
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s29, v2
		s_add_i32 s29, s19, s29
		s_cmp_lt_i32 s29, 0
		s_cselect_b32 s40, s27, 0
		s_add_i32 s29, s29, s40
		s_ashr_i32 s29, s29, 7
		s_cmp_lt_i32 s29, s28
		s_cselect_b32 s29, s29, s28
		s_cmp_gt_i32 s29, 0
		s_cselect_b32 s29, s29, 0
		v_bitop3_b32 v2, v5, v1, v11 bitop3:0x96
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v15
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a22, v2
		v_bitop3_b32 v2, 4, v5, v1 bitop3:0x96
		v_xor_b32_e32 v2, v2, v11
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a23, v2
		v_bitop3_b32 v2, 8, v5, v1 bitop3:0x96
		v_xor_b32_e32 v2, v2, v11
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a56, v2
		v_bitop3_b32 v2, 12, v5, v1 bitop3:0x96
		v_xor_b32_e32 v2, v2, v11
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_read_b32 v5, a22
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v5, a23
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v5, a56
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v2, s21
		s_mov_b64 s[46:47], vcc
		v_mov_b32_e32 v5, 16
		v_mul_lo_u32 v5, v5, v8
		v_accvgpr_read_b32 v8, a15
		v_mov_b32_e32 v10, 64
		v_mul_lo_u32 v10, v10, v8
		v_bitop3_b32 v8, v5, v1, v10 bitop3:0x96
		v_bitop3_b32 v8, v8, v13, v9 bitop3:0x96
		v_bitop3_b32 v11, 4, v5, v1 bitop3:0x96
		v_xor_b32_e32 v11, v11, v10
		v_bitop3_b32 v11, v11, v13, v9 bitop3:0x96
		v_bitop3_b32 v12, 8, v5, v1 bitop3:0x96
		v_xor_b32_e32 v12, v12, v10
		v_bitop3_b32 v12, v12, v13, v9 bitop3:0x96
		v_bitop3_b32 v1, 12, v5, v1 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v8, s21
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v11, s21
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v12, s21
		s_mov_b64 s[52:53], vcc
		v_readfirstlane_b32 s54, v0
		v_accvgpr_read_b32 v5, a12
		v_mul_lo_u32 v5, s15, v5
		v_accvgpr_read_b32 v14, a19
		v_mul_lo_u32 v14, s15, v14
		v_lshlrev_b32_e32 v14, 5, v14
		v_lshl_add_u32 v5, v5, 1, v14
		v_accvgpr_read_b32 v14, a20
		v_mul_lo_u32 v14, s15, v14
		v_lshl_add_u32 v5, v14, 6, v5
		v_and_b32_e32 v7, 1, v7
		v_accvgpr_write_b32 a57, v7
		v_accvgpr_read_b32 v7, a57
		v_mul_lo_u32 v7, s15, v7
		v_lshlrev_b32_e32 v7, 7, v7
		v_accvgpr_read_b32 v14, a16
		v_lshlrev_b32_e32 v14, 4, v14
		v_add3_u32 v5, v5, v7, v14
		v_accvgpr_read_b32 v7, a17
		v_lshlrev_b32_e32 v7, 6, v7
		v_accvgpr_read_b32 v15, a18
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v5, v5, v7, v15
		v_accvgpr_read_b32 v16, a10
		s_nop 0
		v_readfirstlane_b32 s55, v16
		s_mul_i32 s55, s55, s13
		s_lshl_b32 s55, s55, 1
		v_accvgpr_read_b32 v16, a11
		s_nop 0
		v_readfirstlane_b32 s56, v16
		s_mul_i32 s56, s56, s14
		s_lshl_b32 s56, s56, 1
		s_add_i32 s57, s55, s56
		v_add_u32_e32 v16, s57, v5
		v_mov_b32_e32 v17, 0x80000000
		v_cndmask_b32_e64 v16, v17, v16, s[40:41]
		s_lshr_b32 s40, s54, 6
		s_mul_i32 s41, 0x410, s40
		s_mov_b32 m0, s41
		v_xor_b32_e32 v1, v1, v10
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v1, v13, v9 bitop3:0x96
		s_lshl_b32 s57, s15, 3
		s_add_i32 s57, s57, s55
		s_add_i32 s57, s57, s56
		v_add_u32_e32 v9, s57, v5
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v9, v17, v9, s[42:43]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_lshl_b32 s42, s15, 4
		s_add_i32 s42, s42, s55
		s_add_i32 s42, s42, s56
		v_add_u32_e32 v9, s42, v5
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v9, v17, v9, s[44:45]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_mul_i32 s42, 24, s15
		s_add_i32 s42, s42, s55
		s_add_i32 s42, s42, s56
		v_add_u32_e32 v9, s42, v5
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v9, v17, v9, s[46:47]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v9, a12
		v_mul_lo_u32 v9, s17, v9
		v_accvgpr_read_b32 v10, a19
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 7, v10
		v_lshl_add_u32 v9, v9, 1, v10
		v_accvgpr_read_b32 v10, a20
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v9, v10, 6, v9
		v_accvgpr_read_b32 v10, a57
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v9, v9, v10, v14
		v_add3_u32 v7, v9, v7, v15
		v_accvgpr_read_b32 v9, a0
		s_nop 0
		v_readfirstlane_b32 s42, v9
		v_accvgpr_read_b32 v9, a10
		s_nop 0
		v_readfirstlane_b32 s43, v9
		s_mul_i32 s42, s43, s42
		s_lshl_b32 s42, s42, 1
		v_accvgpr_read_b32 v9, a1
		s_nop 0
		v_readfirstlane_b32 s43, v9
		v_accvgpr_read_b32 v9, a11
		s_nop 0
		v_readfirstlane_b32 s44, v9
		s_mul_i32 s43, s44, s43
		s_lshl_b32 s43, s43, 1
		s_add_i32 s44, s42, s43
		v_add_u32_e32 v9, s44, v7
		s_mul_i32 s40, 0x440, s40
		s_add_i32 m0, s40, 0x81f0
		v_cndmask_b32_e64 v9, v17, v9, s[48:49]
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_lshl_b32 s44, s17, 3
		s_add_i32 s44, s44, s42
		s_add_i32 s44, s44, s43
		v_add_u32_e32 v9, s44, v7
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v9, v17, v9, s[50:51]
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_lshl_b32 s44, s17, 4
		s_add_i32 s44, s44, s42
		s_add_i32 s44, s44, s43
		v_add_u32_e32 v9, s44, v7
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v9, v17, v9, s[52:53]
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_mul_i32 s44, 24, s17
		s_add_i32 s44, s44, s42
		s_add_i32 s44, s44, s43
		v_cmp_lt_i32_e64 vcc, v1, s21
		v_add_u32_e32 v9, s44, v7
		v_mbcnt_lo_u32_b32 v10, -1, 0
		v_cndmask_b32_e32 v9, v17, v9, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s44, s29, 0x80
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		v_mbcnt_hi_u32_b32 v9, -1, v10
		v_and_b32_e32 v10, 1, v9
		v_lshrrev_b32_e32 v13, 4, v9
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 4, v13
		v_lshrrev_b32_e32 v14, 3, v9
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 3, v14
		v_add3_u32 v15, v10, v13, v14
		v_lshrrev_b32_e32 v16, 2, v9
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 2, v16
		v_lshrrev_b32_e32 v9, 1, v9
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add3_u32 v15, v15, v16, v9
		v_add_u32_e32 v10, 32, v10
		v_bitop3_b32 v9, v16, v10, v9 bitop3:0x96
		v_bitop3_b32 v9, v13, v14, v9 bitop3:0x96
		v_mov_b32_e32 v18, 0x3e38aa3b
		v_mov_b32_e32 v19, 0x3e38aa3b
		s_mov_b32 s29, 0xff800000
		v_mov_b32_e32 v10, s29
		v_mov_b32_e32 v13, s29
		s_mov_b32 s29, 1.0
		v_mov_b32_e32 v20, s29
		v_mov_b32_e32 v21, s29
		s_mov_b32 s29, 0
		v_accvgpr_read_b32 v14, a21
		v_lshlrev_b32_e32 v14, 4, v14
		v_accvgpr_write_b32 a58, v14
		v_and_b32_e32 v4, 31, v4
		v_lshrrev_b32_e32 v14, 4, v4
		v_lshlrev_b32_e32 v14, 9, v14
		v_accvgpr_write_b32 a59, v14
		v_lshrrev_b32_e32 v14, 3, v4
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v16, 0x2080
		v_mul_lo_u32 v16, v16, v14
		v_accvgpr_write_b32 a60, v16
		v_lshrrev_b32_e32 v14, 2, v4
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v16, 0x1040
		v_mul_lo_u32 v16, v16, v14
		v_accvgpr_write_b32 a61, v16
		v_lshrrev_b32_e32 v14, 1, v4
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v16, 0x820
		v_mul_lo_u32 v16, v16, v14
		v_accvgpr_write_b32 a62, v16
		v_and_b32_e32 v4, 1, v4
		v_mov_b32_e32 v14, 0x410
		v_mul_lo_u32 v14, v14, v4
		v_accvgpr_write_b32 a63, v14
		v_and_b32_e32 v4, 3, v0
		v_accvgpr_write_b32 a64, v4
		v_accvgpr_read_b32 v4, a64
		v_lshlrev_b32_e32 v4, 3, v4
		v_accvgpr_write_b32 a65, v4
		v_accvgpr_read_b32 v4, a19
		v_mov_b32_e32 v14, 0x2200
		v_mul_lo_u32 v14, v14, v4
		v_accvgpr_write_b32 a66, v14
		v_accvgpr_read_b32 v4, a20
		v_lshlrev_b32_e32 v4, 5, v4
		v_accvgpr_write_b32 a67, v4
		v_and_b32_e32 v3, 3, v3
		v_mov_b32_e32 v4, 0x440
		v_mul_lo_u32 v4, v4, v3
		v_accvgpr_write_b32 a68, v4
		s_lshl_b32 s45, s15, 8
		s_add_i32 s45, s45, s55
		s_add_i32 s45, s45, s56
		s_mul_i32 s46, 0x108, s15
		s_add_i32 s46, s46, s55
		s_add_i32 s46, s46, s56
		s_mul_i32 s47, 0x110, s15
		s_add_i32 s47, s47, s55
		s_add_i32 s47, s47, s56
		s_mul_i32 s48, 0x118, s15
		s_add_i32 s48, s48, s55
		s_add_i32 s48, s48, s56
		s_lshl_b32 s49, s17, 8
		s_add_i32 s49, s49, s42
		s_add_i32 s49, s49, s43
		s_mul_i32 s50, 0x108, s17
		s_add_i32 s50, s50, s42
		s_add_i32 s50, s50, s43
		s_mul_i32 s51, 0x110, s17
		s_add_i32 s51, s51, s42
		s_add_i32 s51, s51, s43
		s_mul_i32 s52, 0x118, s17
		s_add_i32 s42, s52, s42
		s_add_i32 s42, s42, s43
		v_lshlrev_b32_e32 v3, 2, v15
		v_accvgpr_write_b32 a69, v3
		v_lshlrev_b32_e32 v3, 2, v9
		v_accvgpr_write_b32 a70, v3
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_3
.L_attn_fwd_persistent.loop_head_3:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s43, s29, 7
		s_and_b32 s52, s43, 1
		s_mul_i32 s53, 0x4100, s52
		v_accvgpr_read_b32 v3, a58
		v_accvgpr_read_b32 v4, a59
		v_add3_u32 v3, s53, v3, v4
		v_accvgpr_read_b32 v4, a60
		v_accvgpr_read_b32 v9, a61
		v_add3_u32 v3, v3, v4, v9
		v_accvgpr_read_b32 v4, a62
		v_accvgpr_read_b32 v9, a63
		v_add3_u32 v3, v3, v4, v9
		ds_read_b128 v[24:27], v3
		ds_read_b128 a[72:75], v3 offset:32
		ds_read_b128 a[76:79], v3 offset:64
		ds_read_b128 a[80:83], v3 offset:96
		ds_read_b128 v[28:31], v3 offset:256
		ds_read_b128 a[84:87], v3 offset:288
		ds_read_b128 a[88:91], v3 offset:320
		ds_read_b128 a[92:95], v3 offset:352
		ds_read_b128 v[96:99], v3 offset:128
		ds_read_b128 a[96:99], v3 offset:160
		ds_read_b128 a[100:103], v3 offset:192
		ds_read_b128 a[104:107], v3 offset:224
		ds_read_b128 v[100:103], v3 offset:384
		ds_read_b128 a[108:111], v3 offset:416
		ds_read_b128 a[112:115], v3 offset:448
		ds_read_b128 a[116:119], v3 offset:480
		s_mul_i32 s52, 0x4400, s52
		v_accvgpr_read_b32 v3, a65
		v_accvgpr_read_b32 v4, a66
		v_add3_u32 v3, s52, v3, v4
		v_accvgpr_read_b32 v4, a67
		v_accvgpr_read_b32 v9, a68
		v_add3_u32 v3, v3, v4, v9
		ds_read_b64_tr_b16 a[120:121], v3 offset:33264
		ds_read_b64_tr_b16 a[122:123], v3 offset:37616
		ds_read_b64_tr_b16 a[124:125], v3 offset:33392
		ds_read_b64_tr_b16 a[126:127], v3 offset:37744
		ds_read_b64_tr_b16 a[128:129], v3 offset:33520
		ds_read_b64_tr_b16 a[130:131], v3 offset:37872
		ds_read_b64_tr_b16 a[132:133], v3 offset:33648
		ds_read_b64_tr_b16 a[134:135], v3 offset:38000
		ds_read_b64_tr_b16 a[136:137], v3 offset:33776
		ds_read_b64_tr_b16 a[138:139], v3 offset:38128
		ds_read_b64_tr_b16 a[140:141], v3 offset:33904
		ds_read_b64_tr_b16 a[142:143], v3 offset:38256
		ds_read_b64_tr_b16 a[144:145], v3 offset:34032
		ds_read_b64_tr_b16 a[146:147], v3 offset:38384
		ds_read_b64_tr_b16 a[148:149], v3 offset:34160
		ds_read_b64_tr_b16 a[150:151], v3 offset:38512
		ds_read_b64_tr_b16 a[152:153], v3 offset:33328
		ds_read_b64_tr_b16 a[154:155], v3 offset:37680
		ds_read_b64_tr_b16 a[156:157], v3 offset:33456
		ds_read_b64_tr_b16 a[158:159], v3 offset:37808
		ds_read_b64_tr_b16 a[160:161], v3 offset:33584
		ds_read_b64_tr_b16 a[162:163], v3 offset:37936
		ds_read_b64_tr_b16 a[164:165], v3 offset:33712
		ds_read_b64_tr_b16 a[166:167], v3 offset:38064
		ds_read_b64_tr_b16 a[168:169], v3 offset:33840
		ds_read_b64_tr_b16 a[170:171], v3 offset:38192
		ds_read_b64_tr_b16 a[172:173], v3 offset:33968
		ds_read_b64_tr_b16 a[174:175], v3 offset:38320
		ds_read_b64_tr_b16 a[176:177], v3 offset:34096
		ds_read_b64_tr_b16 a[178:179], v3 offset:38448
		ds_read_b64_tr_b16 a[180:181], v3 offset:34224
		ds_read_b64_tr_b16 a[182:183], v3 offset:38576
		s_mul_i32 s52, s15, s29
		s_lshl_b32 s52, s52, 1
		s_add_i32 s53, s45, s52
		v_add_u32_e32 v3, s53, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v4, s52, v5
		s_add_i32 s43, s43, 1
		v_add_u32_e32 v9, s46, v4
		s_and_b32 s43, s43, 1
		v_add_u32_e32 v14, s47, v4
		s_mul_i32 s52, 0x4100, s43
		v_add_u32_e32 v4, s48, v4
		s_add_i32 s52, s41, s52
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[24:27], 0
		s_mov_b32 m0, s52
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[24:27], 0
		s_mul_i32 s52, s17, s29
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], 0
		s_add_i32 s29, s29, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[24:27], 0
		v_accvgpr_read_b32 v15, a22
		v_add_u32_e32 v15, s29, v15
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[40:43], 0
		v_accvgpr_read_b32 v16, a23
		v_add_u32_e32 v16, s29, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[40:43], 0
		v_accvgpr_read_b32 v22, a56
		v_add_u32_e32 v22, s29, v22
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[40:43], 0
		v_add_u32_e32 v23, s29, v2
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], a[40:43], 0
		v_cmp_lt_i32_e64 vcc, v15, s21
		s_mov_b64 s[56:57], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[72:75], a[28:31], v[112:127]
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[84:87], a[28:31], v[128:143]
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[96:99], a[28:31], v[144:159]
		v_cmp_lt_i32_e64 vcc, v23, s21
		s_mov_b64 s[62:63], vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[108:111], a[28:31], v[160:175]
		v_add_u32_e32 v15, s29, v8
		v_mfma_f32_32x32x16_bf16 v[176:191], a[108:111], a[44:47], v[176:191]
		v_add_u32_e32 v16, s29, v11
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[44:47], v[192:207]
		v_add_u32_e32 v22, s29, v12
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[44:47], v[208:223]
		v_cmp_lt_i32_e64 vcc, v15, s21
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[44:47], v[224:239]
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_mov_b64 s[66:67], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[32:35], v[112:127]
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_mov_b64 s[68:69], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[32:35], v[128:143]
		v_cndmask_b32_e64 v3, v17, v3, s[56:57]
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[32:35], v[144:159]
		v_add_u32_e32 v3, s29, v1
		v_cndmask_b32_e64 v9, v17, v9, s[58:59]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v14, v17, v14, s[60:61]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v4, v17, v4, s[62:63]
		v_cmp_lt_i32_e64 vcc, v3, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s52, s52, 1
		s_add_i32 s53, s49, s52
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_add_u32_e32 v3, s53, v7
		v_cndmask_b32_e64 v3, v17, v3, s[64:65]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s43, 0x4400, s43
		s_add_i32 s43, s40, s43
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_add_u32_e32 v4, s52, v7
		v_add_u32_e32 v9, s50, v4
		s_add_i32 m0, s43, 0x81f0
		v_cndmask_b32_e64 v9, v17, v9, s[66:67]
		v_add_u32_e32 v14, s51, v4
		buffer_load_dwordx4 v3, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v3, v17, v14, s[68:69]
		v_add_u32_e32 v4, s42, v4
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v4, v17, v4, vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[112:115], a[32:35], v[160:175]
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[112:115], a[48:51], v[176:191]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[48:51], v[224:239]
		buffer_load_dwordx4 v3, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[36:39], v[112:127]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s29, s44
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[52:55], v[192:207]
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[52:55], v[224:239]
		s_nop 1
		v_max3_f32 v3, v112, v113, v114
		v_max3_f32 v4, v116, v117, v118
		v_max3_f32 v9, v120, v121, v122
		v_max3_f32 v14, v124, v125, v126
		v_max3_f32 v15, v128, v129, v130
		v_max3_f32 v16, v132, v133, v134
		v_max3_f32 v22, v136, v137, v138
		v_max3_f32 v23, v140, v141, v142
		v_max3_f32 v24, v144, v145, v146
		v_max3_f32 v25, v148, v149, v150
		v_max3_f32 v26, v152, v153, v154
		v_max3_f32 v27, v156, v157, v158
		v_max3_f32 v28, v160, v161, v162
		v_max3_f32 v29, v164, v165, v166
		v_max3_f32 v30, v168, v169, v170
		v_max3_f32 v31, v172, v173, v174
		v_max3_f32 v3, v3, v115, v4
		v_max3_f32 v4, v9, v123, v14
		v_max3_f32 v9, v15, v131, v16
		v_max3_f32 v14, v22, v139, v23
		v_max3_f32 v15, v24, v147, v25
		v_max3_f32 v16, v26, v155, v27
		v_max3_f32 v22, v28, v163, v29
		v_max3_f32 v23, v30, v171, v31
		v_max3_f32 v3, v3, v119, v4
		v_max3_f32 v4, v9, v135, v14
		v_max3_f32 v9, v15, v151, v16
		v_max3_f32 v14, v22, v167, v23
		v_max3_f32 v3, v3, v127, v4
		v_max3_f32 v4, v9, v159, v14
		v_max3_f32 v3, v3, v143, v4
		v_max_f32_e32 v3, v3, v175
		v_mov_b32_e32 v14, v3
		v_mov_b32_e32 v15, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v14, v15
		v_max_f32_e32 v22, v14, v15
		v_max3_f32 v3, v192, v193, v194
		v_max3_f32 v4, v196, v197, v198
		v_max3_f32 v9, v200, v201, v202
		v_max3_f32 v14, v204, v205, v206
		v_max3_f32 v15, v208, v209, v210
		v_max3_f32 v16, v212, v213, v214
		v_max3_f32 v23, v216, v217, v218
		v_max3_f32 v24, v220, v221, v222
		v_max3_f32 v25, v224, v225, v226
		v_max3_f32 v26, v228, v229, v230
		v_max3_f32 v27, v232, v233, v234
		v_max3_f32 v28, v236, v237, v238
		v_max3_f32 v29, v176, v177, v178
		v_max3_f32 v30, v180, v181, v182
		v_max3_f32 v31, v184, v185, v186
		v_max3_f32 v96, v188, v189, v190
		v_max3_f32 v3, v3, v195, v4
		v_max3_f32 v4, v9, v203, v14
		v_max3_f32 v9, v15, v211, v16
		v_max3_f32 v14, v23, v219, v24
		v_max3_f32 v15, v25, v227, v26
		v_max3_f32 v16, v27, v235, v28
		v_max3_f32 v23, v29, v179, v30
		v_max3_f32 v24, v31, v187, v96
		v_max3_f32 v3, v3, v199, v4
		v_max3_f32 v4, v9, v215, v14
		v_max3_f32 v9, v15, v231, v16
		v_max3_f32 v14, v23, v183, v24
		v_max3_f32 v3, v3, v207, v4
		v_max3_f32 v4, v9, v239, v14
		v_max3_f32 v3, v3, v223, v4
		v_max_f32_e32 v3, v3, v191
		v_mov_b32_e32 v14, v3
		v_mov_b32_e32 v15, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v14, v15
		v_max_f32_e32 v23, v14, v15
		v_pk_mul_f32 v[14:15], v[22:23], v[18:19]
		v_max_f32_e32 v22, v10, v14
		v_max_f32_e32 v23, v13, v15
		v_pk_fma_f32 v[14:15], v[112:113], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[114:115], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[116:117], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[118:119], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[120:121], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[122:123], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[124:125], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[126:127], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[128:129], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[130:131], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[132:133], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[134:135], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[136:137], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[138:139], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[140:141], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[142:143], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[144:145], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[146:147], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[148:149], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[150:151], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[152:153], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[154:155], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[156:157], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[158:159], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[160:161], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[164:165], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[166:167], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[168:169], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[170:171], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[172:173], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[174:175], v[18:19], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[192:193], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[194:195], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[196:197], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[198:199], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[200:201], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[202:203], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[204:205], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[206:207], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[208:209], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[210:211], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[212:213], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[214:215], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[216:217], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[224:225], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[226:227], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[228:229], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[230:231], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[232:233], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[234:235], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[236:237], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[238:239], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[176:177], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[18:19], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v14
		v_exp_f32_e32 v216, v15
		v_exp_f32_e32 v191, v24
		v_exp_f32_e32 v217, v25
		v_exp_f32_e32 v14, v26
		v_exp_f32_e32 v24, v27
		v_exp_f32_e32 v15, v28
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
		v_pk_add_f32 v[220:221], v[14:15], v[24:25]
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
		v_add_f32_e32 v3, v188, v189
		v_accvgpr_read_b32 v4, a69
		ds_bpermute_b32 v146, v4, v3
		v_accvgpr_read_b32 v4, a70
		ds_bpermute_b32 v148, v4, v3
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
		v_add_f32_e32 v3, v229, v224
		v_add_f32_e32 v3, v225, v3
		v_mov_b32_e32 v188, v3
		v_mov_b32_e32 v189, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v188, v189
		v_add_f32_e32 v223, v188, v189
		v_sub_f32_e32 v3, v10, v22
		v_sub_f32_e32 v4, v13, v23
		v_exp_f32_e32 v188, v3
		v_exp_f32_e32 v224, v4
		v_mov_b32_e32 v189, v188
		v_pk_mul_f32 v[32:33], v[32:33], v[188:189]
		v_pk_mul_f32 v[34:35], v[34:35], v[188:189]
		v_pk_mul_f32 v[36:37], v[36:37], v[188:189]
		v_pk_mul_f32 v[38:39], v[38:39], v[188:189]
		v_pk_mul_f32 v[40:41], v[40:41], v[188:189]
		v_pk_mul_f32 v[42:43], v[42:43], v[188:189]
		v_pk_mul_f32 v[44:45], v[44:45], v[188:189]
		v_pk_mul_f32 v[46:47], v[46:47], v[188:189]
		v_pk_mul_f32 v[48:49], v[48:49], v[188:189]
		v_pk_mul_f32 v[50:51], v[50:51], v[188:189]
		v_pk_mul_f32 v[52:53], v[52:53], v[188:189]
		v_pk_mul_f32 v[54:55], v[54:55], v[188:189]
		v_pk_mul_f32 v[56:57], v[56:57], v[188:189]
		v_pk_mul_f32 v[58:59], v[58:59], v[188:189]
		v_pk_mul_f32 v[60:61], v[60:61], v[188:189]
		v_pk_mul_f32 v[62:63], v[62:63], v[188:189]
		v_mov_b32_e32 v225, v224
		v_pk_mul_f32 v[64:65], v[64:65], v[224:225]
		v_pk_mul_f32 v[66:67], v[66:67], v[224:225]
		v_pk_mul_f32 v[68:69], v[68:69], v[224:225]
		v_pk_mul_f32 v[70:71], v[70:71], v[224:225]
		v_pk_mul_f32 v[72:73], v[72:73], v[224:225]
		v_pk_mul_f32 v[74:75], v[74:75], v[224:225]
		v_pk_mul_f32 v[76:77], v[76:77], v[224:225]
		v_pk_mul_f32 v[78:79], v[78:79], v[224:225]
		v_pk_mul_f32 v[80:81], v[80:81], v[224:225]
		v_pk_mul_f32 v[82:83], v[82:83], v[224:225]
		v_pk_mul_f32 v[84:85], v[84:85], v[224:225]
		v_pk_mul_f32 v[86:87], v[86:87], v[224:225]
		v_pk_mul_f32 v[88:89], v[88:89], v[224:225]
		v_pk_mul_f32 v[90:91], v[90:91], v[224:225]
		v_pk_mul_f32 v[92:93], v[92:93], v[224:225]
		v_pk_mul_f32 v[94:95], v[94:95], v[224:225]
		v_mov_b32_e32 v226, v188
		v_mov_b32_e32 v227, v224
		v_mov_b32_e32 v222, v220
		v_mov_b64_e32 v[188:189], v[20:21]
		v_pk_fma_f32 v[20:21], v[188:189], v[226:227], v[222:223]
		v_cvt_pk_bf16_f32 v220, v190, v216
		v_cvt_pk_bf16_f32 v221, v191, v217
		v_cvt_pk_bf16_f32 v222, v14, v24
		v_cvt_pk_bf16_f32 v223, v15, v25
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
		v_mov_b32_e32 v10, v22
		v_mov_b32_e32 v13, v23
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s28, s28, 0x80
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s29, v3
		v_accvgpr_read_b32 v3, a13
		s_nop 0
		v_add_u32_e32 v3, s29, v3
		v_add_u32_e32 v3, s19, v3
		v_accvgpr_read_b32 v4, a5
		s_nop 0
		v_readfirstlane_b32 s29, v4
		v_accvgpr_read_b32 v4, a14
		s_nop 0
		v_add_u32_e32 v4, s29, v4
		v_add_u32_e32 v4, s19, v4
		v_xor_b32_e32 v9, 1, v6
		v_accvgpr_write_b32 a13, v9
		v_xor_b32_e32 v9, 2, v6
		v_accvgpr_write_b32 a14, v9
		v_xor_b32_e32 v9, 3, v6
		v_accvgpr_write_b32 a58, v9
		v_xor_b32_e32 v9, 8, v6
		v_accvgpr_write_b32 a65, v9
		v_xor_b32_e32 v9, 9, v6
		v_accvgpr_write_b32 a71, v9
		v_xor_b32_e32 v9, 10, v6
		v_accvgpr_write_b32 a72, v9
		v_xor_b32_e32 v9, 11, v6
		v_accvgpr_write_b32 a73, v9
		v_xor_b32_e32 v9, 16, v6
		v_accvgpr_write_b32 a74, v9
		v_xor_b32_e32 v9, 17, v6
		v_accvgpr_write_b32 a75, v9
		v_xor_b32_e32 v9, 18, v6
		v_accvgpr_write_b32 a76, v9
		v_xor_b32_e32 v9, 19, v6
		v_accvgpr_write_b32 a77, v9
		v_xor_b32_e32 v9, 24, v6
		v_accvgpr_write_b32 a78, v9
		v_xor_b32_e32 v9, 25, v6
		v_accvgpr_write_b32 a79, v9
		v_xor_b32_e32 v9, 26, v6
		v_accvgpr_write_b32 a80, v9
		v_xor_b32_e32 v9, 27, v6
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 32, v6
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 33, v6
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 34, v6
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 35, v6
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 40, v6
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 41, v6
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 42, v6
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 43, v6
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 48, v6
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 49, v6
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 50, v6
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 51, v6
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 56, v6
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 57, v6
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 58, v6
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 59, v6
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 64, v6
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 0x41, v6
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 0x42, v6
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 0x43, v6
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 0x48, v6
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 0x49, v6
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 0x4a, v6
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 0x4b, v6
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 0x50, v6
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 0x51, v6
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 0x52, v6
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x53, v6
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x58, v6
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x59, v6
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x5a, v6
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x5b, v6
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x60, v6
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x61, v6
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x62, v6
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x63, v6
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x68, v6
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x69, v6
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x6a, v6
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x6b, v6
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x70, v6
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x71, v6
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x72, v6
		v_accvgpr_write_b32 a124, v9
		v_xor_b32_e32 v9, 0x73, v6
		v_accvgpr_write_b32 a125, v9
		v_xor_b32_e32 v9, 0x78, v6
		v_accvgpr_write_b32 a126, v9
		v_xor_b32_e32 v9, 0x79, v6
		v_accvgpr_write_b32 a127, v9
		v_xor_b32_e32 v9, 0x7a, v6
		v_accvgpr_write_b32 a128, v9
		v_xor_b32_e32 v9, 0x7b, v6
		v_accvgpr_write_b32 a129, v9
		v_accvgpr_read_b32 v9, a21
		v_accvgpr_read_b32 v14, a59
		v_lshl_add_u32 v9, v9, 4, v14
		v_accvgpr_read_b32 v14, a60
		v_accvgpr_read_b32 v15, a61
		v_add3_u32 v9, v9, v14, v15
		v_accvgpr_read_b32 v14, a62
		v_accvgpr_read_b32 v15, a63
		v_add3_u32 v9, v9, v14, v15
		v_accvgpr_write_b32 a21, v9
		v_accvgpr_read_b32 v9, a64
		v_accvgpr_read_b32 v14, a66
		v_lshl_add_u32 v9, v9, 3, v14
		v_accvgpr_read_b32 v14, a67
		v_accvgpr_read_b32 v15, a68
		v_add3_u32 v9, v9, v14, v15
		v_accvgpr_write_b32 a59, v9
		v_mov_b32_e32 v9, 0xff800000
		s_cmp_lt_i32 s44, s28
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s19, s44, 0x80
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s29, s27, 0
		s_add_i32 s29, s44, s29
		s_ashr_i32 s29, s29, 7
		s_cmp_lt_i32 s29, 0
		s_cselect_b32 s40, s16, 0
		s_add_i32 s40, s29, s40
		s_ashr_i32 s40, s40, 1
		s_lshl_b32 s40, s40, 1
		s_xor_b32 s40, s40, -1
		s_add_i32 s40, s40, 1
		s_add_i32 s40, s29, s40
		s_add_i32 s29, s29, 1
		s_cmp_lt_i32 s29, 0
		s_cselect_b32 s41, s16, 0
		s_add_i32 s41, s29, s41
		s_ashr_i32 s41, s41, 1
		s_lshl_b32 s41, s41, 1
		s_xor_b32 s41, s41, -1
		s_add_i32 s41, s41, 1
		s_add_i32 s52, s29, s41
		s_mul_i32 s29, 0x4100, s40
		v_accvgpr_read_b32 v14, a21
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
		s_mul_i32 s29, 0x4400, s40
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
		s_cmp_lt_i32 s19, s26
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v14, a22
		v_add_u32_e32 v14, s19, v14
		v_accvgpr_read_b32 v15, a23
		v_add_u32_e32 v15, s19, v15
		v_accvgpr_read_b32 v16, a56
		v_add_u32_e32 v16, s19, v16
		v_add_u32_e32 v22, s19, v2
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v15, s21
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_mov_b64 s[60:61], vcc
		v_add_u32_e32 v14, s19, v8
		v_add_u32_e32 v15, s19, v11
		v_add_u32_e32 v16, s19, v12
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v15, s21
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_mov_b64 s[66:67], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s29, s15, s44
		s_lshl_b32 s29, s29, 1
		s_add_i32 s43, s45, s29
		v_add_u32_e32 v14, s43, v5
		s_mov_b32 s68, 1
		s_mov_b32 s69, 0
		s_mov_b32 s55, 0
		s_mul_i32 s70, s68, s54
		s_mul_hi_u32 s71, s68, s54
		s_mul_i32 s43, s68, s55
		s_add_i32 s71, s71, s43
		s_mul_i32 s43, s69, s54
		s_add_i32 s71, s71, s43
		s_lshr_b64 s[68:69], s[70:71], 6
		s_mov_b32 s70, 0x410
		s_mov_b32 s71, 0
		s_mul_i32 s72, s70, s68
		s_mul_hi_u32 s73, s70, s68
		s_mul_i32 s43, s70, s69
		s_add_i32 s73, s73, s43
		s_mul_i32 s43, s71, s68
		s_add_i32 s73, s73, s43
		s_cmp_lt_i32 s52, 0
		s_cselect_b32 s53, -1, 0
		s_mov_b32 s70, 0x4100
		s_mov_b32 s71, 0
		s_mul_i32 s74, s70, s52
		s_mul_hi_u32 s75, s70, s52
		s_mul_i32 s43, s70, s53
		s_add_i32 s75, s75, s43
		s_mul_i32 s43, s71, s52
		s_add_i32 s75, s75, s43
		s_add_u32 s70, s72, s74
		s_addc_u32 s71, s73, s75
		s_add_u32 s76, s70, 0
		s_addc_u32 s77, s71, 0
		s_mov_b32 m0, s76
		v_cndmask_b32_e64 v14, v17, v14, s[40:41]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_add_u32_e32 v14, s19, v1
		s_add_i32 s40, s46, s29
		v_add_u32_e32 v15, s40, v5
		s_add_u32 s40, s72, 0x1040
		s_addc_u32 s41, s73, 0
		s_add_u32 s40, s40, s74
		s_addc_u32 s41, s41, s75
		s_add_u32 s70, s40, 0
		s_addc_u32 s71, s41, 0
		s_mov_b32 m0, s70
		v_cndmask_b32_e64 v15, v17, v15, s[56:57]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_add_i32 s40, s47, s29
		v_add_u32_e32 v15, s40, v5
		s_add_u32 s40, s72, 0x2080
		s_addc_u32 s41, s73, 0
		s_add_u32 s40, s40, s74
		s_addc_u32 s41, s41, s75
		s_add_u32 s56, s40, 0
		s_addc_u32 s57, s41, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v15, v17, v15, s[58:59]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_add_i32 s29, s48, s29
		v_add_u32_e32 v15, s29, v5
		s_add_u32 s40, s72, 0x30c0
		s_addc_u32 s41, s73, 0
		s_add_u32 s40, s40, s74
		s_addc_u32 s41, s41, s75
		s_add_u32 s56, s40, 0
		s_addc_u32 s57, s41, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v15, v17, v15, s[60:61]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_mul_i32 s29, s17, s44
		s_lshl_b32 s29, s29, 1
		s_add_i32 s40, s49, s29
		v_add_u32_e32 v15, s40, v7
		s_mov_b32 s40, 0x440
		s_mov_b32 s41, 0
		s_mul_i32 s56, s40, s68
		s_mul_hi_u32 s57, s40, s68
		s_mul_i32 s43, s40, s69
		s_add_i32 s57, s57, s43
		s_mul_i32 s43, s41, s68
		s_add_i32 s57, s57, s43
		s_add_u32 s40, s56, 0x81f0
		s_addc_u32 s41, s57, 0
		s_mov_b32 s58, 0x4400
		s_mov_b32 s59, 0
		s_mul_i32 s60, s58, s52
		s_mul_hi_u32 s61, s58, s52
		s_mul_i32 s43, s58, s53
		s_add_i32 s61, s61, s43
		s_mul_i32 s43, s59, s52
		s_add_i32 s61, s61, s43
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v15, v17, v15, s[62:63]
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		s_add_i32 s40, s50, s29
		v_add_u32_e32 v15, s40, v7
		s_add_u32 s40, s56, 0x92f0
		s_addc_u32 s41, s57, 0
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v15, v17, v15, s[64:65]
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		s_add_i32 s40, s51, s29
		v_add_u32_e32 v15, s40, v7
		s_add_u32 s40, s56, 0xa3f0
		s_addc_u32 s41, s57, 0
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v15, v17, v15, s[66:67]
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		s_add_i32 s29, s42, s29
		v_cmp_lt_i32_e64 vcc, v14, s21
		v_add_u32_e32 v14, s29, v7
		s_add_u32 s40, s56, 0xb4f0
		s_addc_u32 s41, s57, 0
		v_cndmask_b32_e32 v14, v17, v14, vcc
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[60:63], a[24:27], 0
		v_add_u32_e32 v14, s44, v6
		v_accvgpr_read_b32 v15, a13
		v_add_u32_e32 v15, s44, v15
		v_accvgpr_read_b32 v16, a14
		v_add_u32_e32 v16, s44, v16
		v_accvgpr_read_b32 v22, a58
		v_add_u32_e32 v22, s44, v22
		v_accvgpr_read_b32 v23, a72
		v_add_u32_e32 v23, s44, v23
		v_accvgpr_read_b32 v24, a73
		v_add_u32_e32 v24, s44, v24
		v_accvgpr_read_b32 v25, a76
		v_add_u32_e32 v25, s44, v25
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[24:27], 0
		v_accvgpr_read_b32 v26, a77
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_read_b32 v27, a80
		v_add_u32_e32 v27, s44, v27
		v_accvgpr_read_b32 v28, a81
		v_add_u32_e32 v28, s44, v28
		v_accvgpr_read_b32 v29, a84
		v_add_u32_e32 v29, s44, v29
		v_accvgpr_read_b32 v30, a85
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_read_b32 v31, a88
		v_add_u32_e32 v31, s44, v31
		v_accvgpr_read_b32 v128, a89
		v_add_u32_e32 v128, s44, v128
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], a[24:27], 0
		v_accvgpr_read_b32 v129, a92
		v_add_u32_e32 v129, s44, v129
		v_accvgpr_read_b32 v130, a93
		v_add_u32_e32 v130, s44, v130
		v_accvgpr_read_b32 v131, a96
		v_add_u32_e32 v131, s44, v131
		v_accvgpr_read_b32 v132, a97
		v_add_u32_e32 v132, s44, v132
		v_accvgpr_read_b32 v133, a100
		v_add_u32_e32 v133, s44, v133
		v_accvgpr_read_b32 v134, a101
		v_add_u32_e32 v134, s44, v134
		v_accvgpr_read_b32 v135, a104
		v_add_u32_e32 v135, s44, v135
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[24:27], 0
		v_accvgpr_read_b32 v136, a105
		v_add_u32_e32 v136, s44, v136
		v_accvgpr_read_b32 v137, a108
		v_add_u32_e32 v137, s44, v137
		v_accvgpr_read_b32 v138, a109
		v_add_u32_e32 v138, s44, v138
		v_accvgpr_read_b32 v139, a112
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a64, v139
		v_accvgpr_read_b32 v139, a113
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a66, v139
		v_accvgpr_read_b32 v139, a116
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a67, v139
		v_accvgpr_read_b32 v139, a117
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a68, v139
		v_mfma_f32_32x32x16_bf16 v[176:191], a[176:179], a[40:43], 0
		v_accvgpr_read_b32 v139, a120
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a130, v139
		v_accvgpr_read_b32 v139, a121
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a131, v139
		v_accvgpr_read_b32 v139, a124
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a176, v139
		v_accvgpr_read_b32 v139, a125
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a177, v139
		v_accvgpr_read_b32 v139, a128
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a178, v139
		v_accvgpr_read_b32 v139, a129
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a179, v139
		v_cmp_ge_i32_e64 vcc, v3, v14
		s_mov_b64 s[40:41], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], a[60:63], a[40:43], 0
		v_cmp_ge_i32_e64 vcc, v3, v15
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v3, v16
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v3, v22
		v_accvgpr_read_b32 v139, a65
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_read_b32 v140, a71
		v_add_u32_e32 v140, s44, v140
		v_accvgpr_read_b32 v141, a74
		v_add_u32_e32 v141, s44, v141
		v_accvgpr_read_b32 v142, a75
		v_add_u32_e32 v142, s44, v142
		v_mfma_f32_32x32x16_bf16 v[208:223], a[144:147], a[40:43], 0
		v_accvgpr_read_b32 v143, a78
		v_add_u32_e32 v143, s44, v143
		v_accvgpr_read_b32 v224, a79
		v_add_u32_e32 v224, s44, v224
		v_accvgpr_read_b32 v225, a82
		v_add_u32_e32 v225, s44, v225
		v_accvgpr_read_b32 v226, a83
		v_add_u32_e32 v226, s44, v226
		v_accvgpr_read_b32 v227, a86
		v_add_u32_e32 v227, s44, v227
		v_accvgpr_read_b32 v228, a87
		v_add_u32_e32 v228, s44, v228
		v_accvgpr_read_b32 v229, a90
		v_add_u32_e32 v229, s44, v229
		v_mfma_f32_32x32x16_bf16 v[240:255], a[160:163], a[40:43], 0
		v_accvgpr_read_b32 v230, a91
		v_add_u32_e32 v230, s44, v230
		v_accvgpr_read_b32 v231, a94
		v_add_u32_e32 v231, s44, v231
		v_accvgpr_read_b32 v232, a95
		v_add_u32_e32 v232, s44, v232
		v_accvgpr_read_b32 v233, a98
		v_add_u32_e32 v233, s44, v233
		v_accvgpr_read_b32 v234, a99
		v_add_u32_e32 v234, s44, v234
		v_accvgpr_read_b32 v235, a102
		v_add_u32_e32 v235, s44, v235
		v_accvgpr_read_b32 v236, a103
		v_add_u32_e32 v236, s44, v236
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[28:31], v[96:111]
		v_accvgpr_read_b32 v237, a106
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a60, v237
		v_accvgpr_read_b32 v237, a107
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a61, v237
		v_accvgpr_read_b32 v237, a110
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a62, v237
		v_accvgpr_read_b32 v237, a111
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a63, v237
		v_accvgpr_read_b32 v237, a114
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a144, v237
		v_accvgpr_read_b32 v237, a115
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a145, v237
		v_accvgpr_read_b32 v237, a118
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a146, v237
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[28:31], v[112:127]
		v_accvgpr_read_b32 v237, a119
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a147, v237
		v_accvgpr_read_b32 v237, a122
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a160, v237
		v_accvgpr_read_b32 v237, a123
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a161, v237
		v_accvgpr_read_b32 v237, a126
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a162, v237
		v_accvgpr_read_b32 v237, a127
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a163, v237
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[132:135], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[148:151], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[164:167], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[184:187], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[136:139], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[152:155], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[168:171], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[172:175], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[188:191], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[140:143], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[156:159], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[172:175], a[52:55], v[240:255]
		s_cmp_lt_i32 s19, s28
		s_nop 3
		v_cndmask_b32_e32 v99, v9, v99, vcc
		v_accvgpr_write_b32 a133, v99
		v_cmp_ge_i32_e64 vcc, v3, v139
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v3, v140
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v3, v23
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v3, v24
		v_cndmask_b32_e64 v96, v9, v96, s[40:41]
		v_accvgpr_write_b32 a134, v96
		v_cndmask_b32_e64 v96, v9, v97, s[52:53]
		v_accvgpr_write_b32 a135, v96
		v_cndmask_b32_e32 v97, v9, v103, vcc
		v_cmp_ge_i32_e64 vcc, v3, v141
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v3, v142
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v3, v25
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v3, v26
		v_cndmask_b32_e64 v96, v9, v98, s[56:57]
		v_accvgpr_write_b32 a132, v96
		v_cndmask_b32_e64 v98, v9, v100, s[58:59]
		v_cndmask_b32_e32 v96, v9, v107, vcc
		v_accvgpr_write_b32 a137, v96
		v_cmp_ge_i32_e64 vcc, v3, v143
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v3, v224
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v3, v27
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v3, v28
		v_cndmask_b32_e64 v99, v9, v101, s[60:61]
		v_cndmask_b32_e64 v96, v9, v102, s[62:63]
		v_cndmask_b32_e32 v101, v9, v111, vcc
		v_cmp_ge_i32_e64 vcc, v3, v225
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v3, v226
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v3, v29
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_cndmask_b32_e64 v102, v9, v104, s[40:41]
		v_cndmask_b32_e64 v103, v9, v105, s[52:53]
		v_cndmask_b32_e32 v100, v9, v115, vcc
		v_accvgpr_write_b32 a139, v100
		v_cmp_ge_i32_e64 vcc, v3, v227
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v3, v228
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v3, v31
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v3, v128
		v_cndmask_b32_e64 v100, v9, v106, s[64:65]
		v_accvgpr_write_b32 a136, v100
		v_cndmask_b32_e64 v104, v9, v108, s[56:57]
		v_cndmask_b32_e32 v100, v9, v119, vcc
		v_accvgpr_write_b32 a141, v100
		v_cmp_ge_i32_e64 vcc, v3, v229
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v3, v230
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v3, v129
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v3, v130
		v_cndmask_b32_e64 v105, v9, v109, s[58:59]
		v_cndmask_b32_e64 v100, v9, v110, s[66:67]
		v_cndmask_b32_e32 v107, v9, v123, vcc
		v_cmp_ge_i32_e64 vcc, v3, v231
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v3, v232
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v3, v131
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v3, v132
		v_cndmask_b32_e64 v108, v9, v112, s[60:61]
		v_cndmask_b32_e64 v109, v9, v113, s[62:63]
		v_cndmask_b32_e32 v111, v9, v127, vcc
		v_cmp_ge_i32_e64 vcc, v3, v233
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v3, v234
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v3, v133
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v3, v134
		v_cndmask_b32_e64 v106, v9, v114, s[68:69]
		v_accvgpr_write_b32 a138, v106
		v_cndmask_b32_e64 v112, v9, v116, s[40:41]
		v_cndmask_b32_e32 v115, v9, v147, vcc
		v_cmp_ge_i32_e64 vcc, v3, v235
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v3, v236
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v3, v135
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v3, v136
		v_cndmask_b32_e64 v113, v9, v117, s[52:53]
		v_cndmask_b32_e64 v106, v9, v118, s[70:71]
		v_accvgpr_write_b32 a140, v106
		v_cndmask_b32_e32 v117, v9, v151, vcc
		v_accvgpr_read_b32 v106, a60
		v_cmp_ge_i32_e64 vcc, v3, v106
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v106, a61
		v_cmp_ge_i32_e64 vcc, v3, v106
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v3, v137
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v3, v138
		v_cndmask_b32_e64 v106, v9, v120, s[56:57]
		v_accvgpr_write_b32 a142, v106
		v_cndmask_b32_e64 v106, v9, v121, s[64:65]
		v_accvgpr_write_b32 a143, v106
		v_cndmask_b32_e32 v119, v9, v155, vcc
		v_accvgpr_read_b32 v106, a62
		v_cmp_ge_i32_e64 vcc, v3, v106
		s_mov_b64 s[56:57], vcc
		v_accvgpr_read_b32 v106, a63
		v_cmp_ge_i32_e64 vcc, v3, v106
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v106, a64
		v_cmp_ge_i32_e64 vcc, v3, v106
		s_mov_b64 s[82:83], vcc
		v_cndmask_b32_e64 v121, v9, v157, s[64:65]
		v_cndmask_b32_e64 v238, v9, v158, s[82:83]
		v_accvgpr_read_b32 v106, a66
		v_cmp_ge_i32_e64 vcc, v3, v106
		v_cndmask_b32_e64 v106, v9, v122, s[72:73]
		v_cndmask_b32_e64 v122, v9, v124, s[58:59]
		v_cndmask_b32_e32 v239, v9, v159, vcc
		v_accvgpr_read_b32 v110, a144
		v_cmp_ge_i32_e64 vcc, v3, v110
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v110, a145
		v_cmp_ge_i32_e64 vcc, v3, v110
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v110, a67
		v_cmp_ge_i32_e64 vcc, v3, v110
		s_mov_b64 s[72:73], vcc
		v_cndmask_b32_e64 v158, v9, v160, s[58:59]
		v_cndmask_b32_e64 v159, v9, v161, s[64:65]
		v_cndmask_b32_e64 v160, v9, v162, s[72:73]
		v_accvgpr_read_b32 v110, a68
		v_cmp_ge_i32_e64 vcc, v3, v110
		v_cndmask_b32_e64 v123, v9, v125, s[66:67]
		v_cndmask_b32_e64 v110, v9, v126, s[74:75]
		v_cndmask_b32_e32 v161, v9, v163, vcc
		v_accvgpr_read_b32 v114, a146
		v_cmp_ge_i32_e64 vcc, v3, v114
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v114, a147
		v_cmp_ge_i32_e64 vcc, v3, v114
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v114, a130
		v_cmp_ge_i32_e64 vcc, v3, v114
		s_mov_b64 s[66:67], vcc
		v_cndmask_b32_e64 v124, v9, v164, s[58:59]
		v_cndmask_b32_e64 v125, v9, v165, s[64:65]
		v_cndmask_b32_e64 v126, v9, v166, s[66:67]
		v_accvgpr_read_b32 v114, a131
		v_cmp_ge_i32_e64 vcc, v3, v114
		v_cndmask_b32_e64 v162, v9, v144, s[60:61]
		v_cndmask_b32_e64 v163, v9, v145, s[62:63]
		v_cndmask_b32_e32 v127, v9, v167, vcc
		v_accvgpr_read_b32 v114, a160
		v_cmp_ge_i32_e64 vcc, v3, v114
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v114, a161
		v_cmp_ge_i32_e64 vcc, v3, v114
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v114, a176
		v_cmp_ge_i32_e64 vcc, v3, v114
		s_mov_b64 s[62:63], vcc
		v_cndmask_b32_e64 v144, v9, v168, s[58:59]
		v_cndmask_b32_e64 v145, v9, v169, s[60:61]
		v_cndmask_b32_e64 v164, v9, v170, s[62:63]
		v_accvgpr_read_b32 v114, a177
		v_cmp_ge_i32_e64 vcc, v3, v114
		v_cndmask_b32_e64 v114, v9, v146, s[76:77]
		v_cndmask_b32_e64 v146, v9, v148, s[40:41]
		v_cndmask_b32_e32 v165, v9, v171, vcc
		v_accvgpr_read_b32 v116, a162
		v_cmp_ge_i32_e64 vcc, v3, v116
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v116, a163
		v_cmp_ge_i32_e64 vcc, v3, v116
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v116, a178
		v_cmp_ge_i32_e64 vcc, v3, v116
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v166, v9, v172, s[40:41]
		v_cndmask_b32_e64 v167, v9, v173, s[58:59]
		v_cndmask_b32_e64 v168, v9, v174, s[60:61]
		v_accvgpr_read_b32 v116, a179
		v_cmp_ge_i32_e64 vcc, v3, v116
		v_cndmask_b32_e64 v147, v9, v149, s[68:69]
		v_cndmask_b32_e64 v116, v9, v150, s[78:79]
		v_cndmask_b32_e32 v169, v9, v175, vcc
		v_cmp_ge_i32_e64 vcc, v4, v14
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v15
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v4, v16
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v14, v9, v192, s[40:41]
		v_cndmask_b32_e64 v15, v9, v193, s[58:59]
		v_cndmask_b32_e64 v148, v9, v194, s[60:61]
		v_cmp_ge_i32_e64 vcc, v4, v22
		v_cndmask_b32_e64 v150, v9, v152, s[52:53]
		v_cndmask_b32_e64 v151, v9, v153, s[70:71]
		v_cndmask_b32_e32 v149, v9, v195, vcc
		v_cmp_ge_i32_e64 vcc, v4, v139
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v140
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v23
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v22, v9, v196, s[40:41]
		v_cndmask_b32_e64 v23, v9, v197, s[52:53]
		v_cndmask_b32_e64 v152, v9, v198, s[58:59]
		v_cmp_ge_i32_e64 vcc, v4, v24
		v_cndmask_b32_e64 v118, v9, v154, s[80:81]
		v_cndmask_b32_e64 v120, v9, v156, s[56:57]
		v_cndmask_b32_e32 v153, v9, v199, vcc
		v_cmp_ge_i32_e64 vcc, v4, v141
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v142
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v25
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v24, v9, v200, s[40:41]
		v_cndmask_b32_e64 v25, v9, v201, s[52:53]
		v_cndmask_b32_e64 v140, v9, v202, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v26
		v_accvgpr_read_b32 v16, a132
		v_accvgpr_read_b32 v26, a134
		v_accvgpr_read_b32 v139, a135
		v_max3_f32 v16, v26, v139, v16
		v_max3_f32 v26, v98, v99, v96
		v_cndmask_b32_e32 v141, v9, v203, vcc
		v_cmp_ge_i32_e64 vcc, v4, v143
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v224
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v27
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v142, v9, v204, s[40:41]
		v_cndmask_b32_e64 v143, v9, v205, s[52:53]
		v_cndmask_b32_e64 v154, v9, v206, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v28
		v_accvgpr_read_b32 v27, a136
		v_max3_f32 v27, v102, v103, v27
		v_max3_f32 v28, v104, v105, v100
		v_cndmask_b32_e32 v155, v9, v207, vcc
		v_cmp_ge_i32_e64 vcc, v4, v225
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v226
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v29
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v156, v9, v208, s[40:41]
		v_cndmask_b32_e64 v157, v9, v209, s[52:53]
		v_cndmask_b32_e64 v170, v9, v210, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v30
		v_accvgpr_read_b32 v29, a138
		v_max3_f32 v29, v108, v109, v29
		v_accvgpr_read_b32 v30, a140
		v_max3_f32 v30, v112, v113, v30
		v_cndmask_b32_e32 v171, v9, v211, vcc
		v_cmp_ge_i32_e64 vcc, v4, v227
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v228
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v31
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v172, v9, v212, s[40:41]
		v_cndmask_b32_e64 v173, v9, v213, s[52:53]
		v_cndmask_b32_e64 v174, v9, v214, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v128
		v_accvgpr_read_b32 v31, a142
		v_accvgpr_read_b32 v128, a143
		v_max3_f32 v31, v31, v128, v106
		v_max3_f32 v128, v122, v123, v110
		v_cndmask_b32_e32 v175, v9, v215, vcc
		v_cmp_ge_i32_e64 vcc, v4, v229
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v230
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v129
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v192, v9, v216, s[40:41]
		v_cndmask_b32_e64 v193, v9, v217, s[52:53]
		v_cndmask_b32_e64 v194, v9, v218, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v130
		v_max3_f32 v129, v162, v163, v114
		v_max3_f32 v130, v146, v147, v116
		v_cndmask_b32_e32 v195, v9, v219, vcc
		v_cmp_ge_i32_e64 vcc, v4, v231
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v232
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v131
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v196, v9, v220, s[40:41]
		v_cndmask_b32_e64 v197, v9, v221, s[52:53]
		v_cndmask_b32_e64 v198, v9, v222, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v132
		v_max3_f32 v131, v150, v151, v118
		v_max3_f32 v132, v120, v121, v238
		v_cndmask_b32_e32 v199, v9, v223, vcc
		v_cmp_ge_i32_e64 vcc, v4, v233
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v234
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v133
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v200, v9, v240, s[40:41]
		v_cndmask_b32_e64 v201, v9, v241, s[52:53]
		v_cndmask_b32_e64 v202, v9, v242, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v134
		v_max3_f32 v133, v158, v159, v160
		v_max3_f32 v134, v124, v125, v126
		v_cndmask_b32_e32 v203, v9, v243, vcc
		v_cmp_ge_i32_e64 vcc, v4, v235
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v4, v236
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v135
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v204, v9, v244, s[40:41]
		v_cndmask_b32_e64 v205, v9, v245, s[52:53]
		v_cndmask_b32_e64 v206, v9, v246, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v136
		v_max3_f32 v135, v144, v145, v164
		v_max3_f32 v136, v166, v167, v168
		v_cndmask_b32_e32 v207, v9, v247, vcc
		v_accvgpr_read_b32 v139, a60
		v_cmp_ge_i32_e64 vcc, v4, v139
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v139, a61
		v_cmp_ge_i32_e64 vcc, v4, v139
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v4, v137
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v208, v9, v248, s[40:41]
		v_cndmask_b32_e64 v209, v9, v249, s[52:53]
		v_cndmask_b32_e64 v210, v9, v250, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v138
		v_accvgpr_read_b32 v137, a133
		v_max3_f32 v16, v16, v137, v26
		v_accvgpr_read_b32 v26, a137
		v_max3_f32 v26, v27, v26, v28
		v_cndmask_b32_e32 v211, v9, v251, vcc
		v_accvgpr_read_b32 v27, a62
		v_cmp_ge_i32_e64 vcc, v4, v27
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v27, a63
		v_cmp_ge_i32_e64 vcc, v4, v27
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v27, a64
		v_cmp_ge_i32_e64 vcc, v4, v27
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v138, v9, v252, s[40:41]
		v_cndmask_b32_e64 v139, v9, v253, s[52:53]
		v_cndmask_b32_e64 v212, v9, v254, s[56:57]
		v_accvgpr_read_b32 v27, a66
		v_cmp_ge_i32_e64 vcc, v4, v27
		v_accvgpr_read_b32 v27, a139
		v_max3_f32 v27, v29, v27, v30
		v_max3_f32 v28, v31, v107, v128
		v_cndmask_b32_e32 v213, v9, v255, vcc
		v_accvgpr_read_b32 v29, a144
		v_cmp_ge_i32_e64 vcc, v4, v29
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v29, a145
		v_cmp_ge_i32_e64 vcc, v4, v29
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v29, a67
		v_cmp_ge_i32_e64 vcc, v4, v29
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v30, v9, v176, s[40:41]
		v_cndmask_b32_e64 v31, v9, v177, s[52:53]
		v_cndmask_b32_e64 v176, v9, v178, s[56:57]
		v_accvgpr_read_b32 v29, a68
		v_cmp_ge_i32_e64 vcc, v4, v29
		v_max3_f32 v29, v129, v115, v130
		v_max3_f32 v128, v131, v119, v132
		v_cndmask_b32_e32 v177, v9, v179, vcc
		v_accvgpr_read_b32 v129, a146
		v_cmp_ge_i32_e64 vcc, v4, v129
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v129, a147
		v_cmp_ge_i32_e64 vcc, v4, v129
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v129, a130
		v_cmp_ge_i32_e64 vcc, v4, v129
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v130, v9, v180, s[40:41]
		v_cndmask_b32_e64 v131, v9, v181, s[52:53]
		v_cndmask_b32_e64 v178, v9, v182, s[56:57]
		v_accvgpr_read_b32 v129, a131
		v_cmp_ge_i32_e64 vcc, v4, v129
		v_max3_f32 v129, v133, v161, v134
		v_max3_f32 v132, v135, v165, v136
		v_cndmask_b32_e32 v179, v9, v183, vcc
		v_accvgpr_read_b32 v133, a160
		v_cmp_ge_i32_e64 vcc, v4, v133
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v133, a161
		v_cmp_ge_i32_e64 vcc, v4, v133
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v133, a176
		v_cmp_ge_i32_e64 vcc, v4, v133
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v134, v9, v184, s[40:41]
		v_cndmask_b32_e64 v135, v9, v185, s[52:53]
		v_cndmask_b32_e64 v136, v9, v186, s[56:57]
		v_accvgpr_read_b32 v133, a177
		v_cmp_ge_i32_e64 vcc, v4, v133
		v_max3_f32 v16, v16, v97, v26
		v_accvgpr_read_b32 v26, a141
		v_max3_f32 v26, v27, v26, v28
		v_cndmask_b32_e32 v137, v9, v187, vcc
		v_accvgpr_read_b32 v27, a162
		v_cmp_ge_i32_e64 vcc, v4, v27
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v27, a163
		v_cmp_ge_i32_e64 vcc, v4, v27
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v27, a178
		v_cmp_ge_i32_e64 vcc, v4, v27
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v180, v9, v188, s[40:41]
		v_cndmask_b32_e64 v181, v9, v189, s[52:53]
		v_cndmask_b32_e64 v182, v9, v190, s[56:57]
		v_accvgpr_read_b32 v27, a179
		v_cmp_ge_i32_e64 vcc, v4, v27
		v_max3_f32 v27, v29, v117, v128
		v_max3_f32 v28, v129, v127, v132
		v_cndmask_b32_e32 v183, v9, v191, vcc
		v_max3_f32 v16, v16, v101, v26
		v_max3_f32 v26, v27, v239, v28
		v_max3_f32 v16, v16, v111, v26
		v_max_f32_e32 v16, v16, v169
		v_mov_b32_e32 v26, v16
		v_mov_b32_e32 v27, v16
		s_nop 1
		v_permlane32_swap_b32_e32 v26, v27
		v_max_f32_e32 v28, v26, v27
		v_max3_f32 v16, v14, v15, v148
		v_max3_f32 v26, v22, v23, v152
		v_max3_f32 v27, v24, v25, v140
		v_max3_f32 v29, v142, v143, v154
		v_max3_f32 v128, v156, v157, v170
		v_max3_f32 v129, v172, v173, v174
		v_max3_f32 v132, v192, v193, v194
		v_max3_f32 v133, v196, v197, v198
		v_max3_f32 v184, v200, v201, v202
		v_max3_f32 v185, v204, v205, v206
		v_max3_f32 v186, v208, v209, v210
		v_max3_f32 v187, v138, v139, v212
		v_max3_f32 v188, v30, v31, v176
		v_max3_f32 v189, v130, v131, v178
		v_max3_f32 v190, v134, v135, v136
		v_max3_f32 v191, v180, v181, v182
		v_max3_f32 v16, v16, v149, v26
		v_max3_f32 v26, v27, v141, v29
		v_max3_f32 v27, v128, v171, v129
		v_max3_f32 v29, v132, v195, v133
		v_max3_f32 v128, v184, v203, v185
		v_max3_f32 v129, v186, v211, v187
		v_max3_f32 v132, v188, v177, v189
		v_max3_f32 v133, v190, v137, v191
		v_max3_f32 v16, v16, v153, v26
		v_max3_f32 v26, v27, v175, v29
		v_max3_f32 v27, v128, v207, v129
		v_max3_f32 v29, v132, v179, v133
		v_max3_f32 v16, v16, v155, v26
		v_max3_f32 v26, v27, v213, v29
		v_max3_f32 v16, v16, v199, v26
		v_max_f32_e32 v16, v16, v183
		v_mov_b32_e32 v26, v16
		v_mov_b32_e32 v27, v16
		s_nop 1
		v_permlane32_swap_b32_e32 v26, v27
		v_max_f32_e32 v29, v26, v27
		v_pk_mul_f32 v[26:27], v[28:29], v[18:19]
		v_max_f32_e32 v28, v10, v26
		v_max_f32_e32 v29, v13, v27
		v_accvgpr_read_b32 v26, a134
		v_accvgpr_read_b32 v27, a135
		v_pk_fma_f32 v[128:129], v[26:27], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v26, a132
		v_accvgpr_read_b32 v27, a133
		v_pk_fma_f32 v[132:133], v[26:27], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[98:99], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[96:97], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[102:103], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v102, a136
		v_accvgpr_read_b32 v103, a137
		v_pk_fma_f32 v[184:185], v[102:103], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[100:101], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[108:109], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v108, a138
		v_accvgpr_read_b32 v109, a139
		v_pk_fma_f32 v[186:187], v[108:109], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[112:113], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v112, a140
		v_accvgpr_read_b32 v113, a141
		v_pk_fma_f32 v[188:189], v[112:113], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v112, a142
		v_accvgpr_read_b32 v113, a143
		v_pk_fma_f32 v[190:191], v[112:113], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[106:107], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[122:123], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[110:111], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[162:163], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[114:115], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[146:147], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[116:117], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[150:151], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[118:119], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[238:239], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[158:159], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[124:125], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[144:145], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[164:165], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[18:19], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[14:15], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[14:15], v[148:149], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[22:23], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[152:153], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[24:25], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[140:141], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[142:143], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[154:155], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[170:171], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[192:193], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[206:207], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[208:209], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[210:211], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[138:139], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[212:213], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[30:31], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[176:177], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[130:131], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[178:179], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[134:135], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[180:181], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[18:19], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v182, v128
		v_exp_f32_e32 v216, v129
		v_exp_f32_e32 v183, v132
		v_exp_f32_e32 v217, v133
		v_exp_f32_e32 v128, v26
		v_exp_f32_e32 v132, v27
		v_exp_f32_e32 v129, v98
		v_exp_f32_e32 v133, v99
		v_exp_f32_e32 v26, v96
		v_exp_f32_e32 v98, v97
		v_exp_f32_e32 v27, v184
		v_exp_f32_e32 v99, v185
		v_exp_f32_e32 v96, v102
		v_exp_f32_e32 v184, v103
		v_exp_f32_e32 v97, v104
		v_exp_f32_e32 v185, v105
		v_exp_f32_e32 v102, v100
		v_exp_f32_e32 v104, v101
		v_exp_f32_e32 v103, v186
		v_exp_f32_e32 v105, v187
		v_exp_f32_e32 v100, v108
		v_exp_f32_e32 v186, v109
		v_exp_f32_e32 v101, v188
		v_exp_f32_e32 v187, v189
		v_exp_f32_e32 v108, v190
		v_exp_f32_e32 v188, v191
		v_exp_f32_e32 v109, v112
		v_exp_f32_e32 v189, v113
		v_exp_f32_e32 v112, v106
		v_exp_f32_e32 v190, v107
		v_exp_f32_e32 v113, v122
		v_exp_f32_e32 v191, v123
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v122, v111
		v_exp_f32_e32 v107, v162
		v_exp_f32_e32 v123, v163
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v162, v115
		v_exp_f32_e32 v111, v146
		v_exp_f32_e32 v163, v147
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v146, v117
		v_exp_f32_e32 v115, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v150, v119
		v_exp_f32_e32 v117, v120
		v_exp_f32_e32 v151, v121
		v_exp_f32_e32 v118, v214
		v_exp_f32_e32 v120, v215
		v_exp_f32_e32 v119, v158
		v_exp_f32_e32 v121, v159
		v_exp_f32_e32 v158, v160
		v_exp_f32_e32 v214, v161
		v_exp_f32_e32 v159, v124
		v_exp_f32_e32 v215, v125
		v_exp_f32_e32 v124, v126
		v_exp_f32_e32 v160, v127
		v_exp_f32_e32 v125, v144
		v_exp_f32_e32 v161, v145
		v_exp_f32_e32 v126, v164
		v_exp_f32_e32 v144, v165
		v_exp_f32_e32 v127, v166
		v_exp_f32_e32 v145, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v167, v169
		v_exp_f32_e32 v168, v14
		v_exp_f32_e32 v218, v15
		v_exp_f32_e32 v169, v148
		v_exp_f32_e32 v219, v149
		v_exp_f32_e32 v14, v22
		v_exp_f32_e32 v148, v23
		v_exp_f32_e32 v15, v152
		v_exp_f32_e32 v149, v153
		v_exp_f32_e32 v22, v24
		v_exp_f32_e32 v152, v25
		v_exp_f32_e32 v23, v140
		v_exp_f32_e32 v153, v141
		v_exp_f32_e32 v24, v142
		v_exp_f32_e32 v140, v143
		v_exp_f32_e32 v25, v154
		v_exp_f32_e32 v141, v155
		v_exp_f32_e32 v142, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v143, v170
		v_exp_f32_e32 v155, v171
		v_exp_f32_e32 v156, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v157, v174
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
		v_exp_f32_e32 v208, v138
		v_exp_f32_e32 v210, v139
		v_exp_f32_e32 v209, v212
		v_exp_f32_e32 v211, v213
		v_exp_f32_e32 v138, v30
		v_exp_f32_e32 v212, v31
		v_exp_f32_e32 v139, v176
		v_exp_f32_e32 v213, v177
		v_exp_f32_e32 v30, v130
		v_exp_f32_e32 v176, v131
		v_exp_f32_e32 v31, v178
		v_exp_f32_e32 v177, v179
		v_exp_f32_e32 v130, v134
		v_exp_f32_e32 v178, v135
		v_exp_f32_e32 v131, v136
		v_exp_f32_e32 v179, v137
		v_exp_f32_e32 v134, v180
		v_exp_f32_e32 v136, v181
		v_pk_add_f32 v[180:181], v[182:183], v[216:217]
		v_pk_add_f32 v[220:221], v[128:129], v[132:133]
		v_pk_add_f32 v[222:223], v[26:27], v[98:99]
		v_pk_add_f32 v[224:225], v[96:97], v[184:185]
		v_pk_add_f32 v[226:227], v[102:103], v[104:105]
		v_pk_add_f32 v[228:229], v[100:101], v[186:187]
		v_pk_add_f32 v[230:231], v[108:109], v[188:189]
		v_pk_add_f32 v[232:233], v[112:113], v[190:191]
		v_pk_add_f32 v[234:235], v[106:107], v[122:123]
		v_pk_add_f32 v[236:237], v[110:111], v[162:163]
		v_pk_add_f32 v[238:239], v[114:115], v[146:147]
		v_pk_add_f32 v[240:241], v[116:117], v[150:151]
		v_pk_add_f32 v[242:243], v[118:119], v[120:121]
		v_pk_add_f32 v[244:245], v[158:159], v[214:215]
		v_pk_add_f32 v[246:247], v[124:125], v[160:161]
		v_pk_add_f32 v[248:249], v[126:127], v[144:145]
		v_mov_b32_e32 v250, v181
		v_mov_b32_e32 v251, v221
		v_mov_b32_e32 v252, v180
		v_mov_b32_e32 v253, v220
		v_pk_add_f32 v[180:181], v[252:253], v[250:251]
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
		v_mov_b32_e32 v220, v181
		v_mov_b32_e32 v221, v223
		v_mov_b32_e32 v224, v180
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[180:181], v[224:225], v[220:221]
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
		v_mov_b32_e32 v220, v181
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v180
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[180:181], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v181
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v180
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[180:181], v[222:223], v[220:221]
		v_add_f32_e32 v16, v180, v181
		v_accvgpr_read_b32 v135, a69
		ds_bpermute_b32 v164, v135, v16
		v_accvgpr_read_b32 v135, a70
		ds_bpermute_b32 v166, v135, v16
		v_pk_add_f32 v[180:181], v[168:169], v[218:219]
		v_pk_add_f32 v[220:221], v[14:15], v[148:149]
		v_pk_add_f32 v[222:223], v[22:23], v[152:153]
		v_pk_add_f32 v[224:225], v[24:25], v[140:141]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[226:227], v[164:165], v[166:167]
		v_pk_add_f32 v[228:229], v[142:143], v[154:155]
		v_pk_add_f32 v[230:231], v[156:157], v[170:171]
		v_pk_add_f32 v[232:233], v[172:173], v[174:175]
		v_pk_add_f32 v[234:235], v[192:193], v[194:195]
		v_pk_add_f32 v[236:237], v[196:197], v[198:199]
		v_pk_add_f32 v[238:239], v[200:201], v[202:203]
		v_pk_add_f32 v[240:241], v[204:205], v[206:207]
		v_pk_add_f32 v[242:243], v[208:209], v[210:211]
		v_pk_add_f32 v[244:245], v[138:139], v[212:213]
		v_pk_add_f32 v[246:247], v[30:31], v[176:177]
		v_pk_add_f32 v[248:249], v[130:131], v[178:179]
		v_mov_b32_e32 v135, v227
		v_mov_b32_e32 v137, v180
		v_pk_add_f32 v[250:251], v[134:135], v[136:137]
		v_mov_b32_e32 v252, v181
		v_mov_b32_e32 v253, v222
		v_pk_add_f32 v[180:181], v[252:253], v[220:221]
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
		v_mov_b32_e32 v233, v180
		v_pk_add_f32 v[232:233], v[232:233], v[250:251]
		v_mov_b32_e32 v236, v181
		v_mov_b32_e32 v237, v224
		v_pk_add_f32 v[180:181], v[236:237], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[220:221], v[220:221], v[222:223]
		v_mov_b32_e32 v222, v231
		v_mov_b32_e32 v223, v234
		v_pk_add_f32 v[224:225], v[222:223], v[228:229]
		v_mov_b32_e32 v222, v235
		v_mov_b32_e32 v223, v180
		v_pk_add_f32 v[222:223], v[222:223], v[232:233]
		v_mov_b32_e32 v228, v181
		v_mov_b32_e32 v229, v224
		v_pk_add_f32 v[180:181], v[228:229], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v180
		v_pk_add_f32 v[224:225], v[220:221], v[222:223]
		v_add_f32_e32 v16, v181, v224
		v_add_f32_e32 v16, v225, v16
		v_mov_b32_e32 v180, v16
		v_mov_b32_e32 v181, v16
		s_nop 1
		v_permlane32_swap_b32_e32 v180, v181
		v_add_f32_e32 v221, v180, v181
		v_sub_f32_e32 v10, v10, v28
		v_sub_f32_e32 v13, v13, v29
		v_exp_f32_e32 v180, v10
		v_exp_f32_e32 v222, v13
		v_mov_b32_e32 v181, v180
		v_pk_mul_f32 v[32:33], v[32:33], v[180:181]
		v_pk_mul_f32 v[34:35], v[34:35], v[180:181]
		v_pk_mul_f32 v[36:37], v[36:37], v[180:181]
		v_pk_mul_f32 v[38:39], v[38:39], v[180:181]
		v_pk_mul_f32 v[40:41], v[40:41], v[180:181]
		v_pk_mul_f32 v[42:43], v[42:43], v[180:181]
		v_pk_mul_f32 v[44:45], v[44:45], v[180:181]
		v_pk_mul_f32 v[46:47], v[46:47], v[180:181]
		v_pk_mul_f32 v[48:49], v[48:49], v[180:181]
		v_pk_mul_f32 v[50:51], v[50:51], v[180:181]
		v_pk_mul_f32 v[52:53], v[52:53], v[180:181]
		v_pk_mul_f32 v[54:55], v[54:55], v[180:181]
		v_pk_mul_f32 v[56:57], v[56:57], v[180:181]
		v_pk_mul_f32 v[58:59], v[58:59], v[180:181]
		v_pk_mul_f32 v[60:61], v[60:61], v[180:181]
		v_pk_mul_f32 v[62:63], v[62:63], v[180:181]
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
		v_mov_b32_e32 v224, v180
		v_mov_b32_e32 v225, v222
		v_mov_b32_e32 v220, v226
		v_mov_b64_e32 v[180:181], v[20:21]
		v_pk_fma_f32 v[20:21], v[180:181], v[224:225], v[220:221]
		v_cvt_pk_bf16_f32 v220, v182, v216
		v_cvt_pk_bf16_f32 v221, v183, v217
		v_cvt_pk_bf16_f32 v222, v128, v132
		v_cvt_pk_bf16_f32 v223, v129, v133
		v_cvt_pk_bf16_f32 v180, v26, v98
		v_cvt_pk_bf16_f32 v181, v27, v99
		v_cvt_pk_bf16_f32 v182, v96, v184
		v_cvt_pk_bf16_f32 v183, v97, v185
		v_cvt_pk_bf16_f32 v96, v102, v104
		v_cvt_pk_bf16_f32 v97, v103, v105
		v_cvt_pk_bf16_f32 v98, v100, v186
		v_cvt_pk_bf16_f32 v99, v101, v187
		v_cvt_pk_bf16_f32 v100, v108, v188
		v_cvt_pk_bf16_f32 v101, v109, v189
		v_cvt_pk_bf16_f32 v102, v112, v190
		v_cvt_pk_bf16_f32 v103, v113, v191
		v_cvt_pk_bf16_f32 v184, v106, v122
		v_cvt_pk_bf16_f32 v185, v107, v123
		v_cvt_pk_bf16_f32 v186, v110, v162
		v_cvt_pk_bf16_f32 v187, v111, v163
		v_cvt_pk_bf16_f32 v104, v114, v146
		v_cvt_pk_bf16_f32 v105, v115, v147
		v_cvt_pk_bf16_f32 v106, v116, v150
		v_cvt_pk_bf16_f32 v107, v117, v151
		v_cvt_pk_bf16_f32 v108, v118, v120
		v_cvt_pk_bf16_f32 v109, v119, v121
		v_cvt_pk_bf16_f32 v110, v158, v214
		v_cvt_pk_bf16_f32 v111, v159, v215
		v_cvt_pk_bf16_f32 v112, v124, v160
		v_cvt_pk_bf16_f32 v113, v125, v161
		v_cvt_pk_bf16_f32 v114, v126, v144
		v_cvt_pk_bf16_f32 v115, v127, v145
		v_cvt_pk_bf16_f32 v116, v165, v167
		v_cvt_pk_bf16_f32 v117, v168, v218
		v_cvt_pk_bf16_f32 v118, v169, v219
		v_cvt_pk_bf16_f32 v119, v14, v148
		v_cvt_pk_bf16_f32 v120, v15, v149
		v_cvt_pk_bf16_f32 v121, v22, v152
		v_cvt_pk_bf16_f32 v122, v23, v153
		v_cvt_pk_bf16_f32 v123, v24, v140
		v_cvt_pk_bf16_f32 v124, v25, v141
		v_cvt_pk_bf16_f32 v125, v142, v154
		v_cvt_pk_bf16_f32 v126, v143, v155
		v_cvt_pk_bf16_f32 v127, v156, v170
		v_cvt_pk_bf16_f32 v24, v157, v171
		v_cvt_pk_bf16_f32 v25, v172, v174
		v_cvt_pk_bf16_f32 v26, v173, v175
		v_cvt_pk_bf16_f32 v27, v192, v194
		v_cvt_pk_bf16_f32 v140, v193, v195
		v_cvt_pk_bf16_f32 v141, v196, v198
		v_cvt_pk_bf16_f32 v142, v197, v199
		v_cvt_pk_bf16_f32 v143, v200, v202
		v_cvt_pk_bf16_f32 v144, v201, v203
		v_cvt_pk_bf16_f32 v145, v204, v206
		v_cvt_pk_bf16_f32 v146, v205, v207
		v_cvt_pk_bf16_f32 v147, v208, v210
		v_cvt_pk_bf16_f32 v148, v209, v211
		v_cvt_pk_bf16_f32 v149, v138, v212
		v_cvt_pk_bf16_f32 v150, v139, v213
		v_cvt_pk_bf16_f32 v151, v30, v176
		v_cvt_pk_bf16_f32 v152, v31, v177
		v_cvt_pk_bf16_f32 v153, v130, v178
		v_cvt_pk_bf16_f32 v154, v131, v179
		v_cvt_pk_bf16_f32 v155, v134, v136
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[180:183], v[48:63]
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
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[152:155], v[64:79]
		s_mov_b32 s44, s19
		v_mov_b32_e32 v10, v28
		v_mov_b32_e32 v13, v29
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s32, s8
		s_mov_b32 s33, s9
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_rcp_f32_e32 v2, v20
		v_rcp_f32_e32 v4, v21
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
		v_accvgpr_read_b32 v1, a15
		v_mov_b32_e32 v4, 8
		v_mul_lo_u32 v4, v4, v1
		v_xor_b32_e32 v1, 16, v4
		v_xor_b32_e32 v5, 32, v4
		v_xor_b32_e32 v68, 48, v4
		s_mov_b32 s19, 64
		v_cmp_lt_i32_e64 vcc, v4, s19
		s_mov_b64 s[26:27], vcc
		s_and_b32 s28, s22, s26
		s_and_b32 s29, s23, s27
		v_cmp_lt_i32_e64 vcc, v1, s19
		s_mov_b64 s[30:31], vcc
		s_and_b32 s36, s22, s30
		s_and_b32 s37, s23, s31
		v_cmp_lt_i32_e64 vcc, v5, s19
		s_mov_b64 s[38:39], vcc
		s_and_b32 s40, s22, s38
		s_and_b32 s41, s23, s39
		v_cmp_lt_i32_e64 vcc, v68, s19
		s_mov_b64 s[42:43], vcc
		s_and_b32 s44, s22, s42
		s_and_b32 s45, s23, s43
		s_and_b32 s22, s24, s26
		s_and_b32 s23, s25, s27
		s_and_b32 s26, s24, s30
		s_and_b32 s27, s25, s31
		s_and_b32 s30, s24, s38
		s_and_b32 s31, s25, s39
		s_and_b32 s38, s24, s42
		s_and_b32 s39, s25, s43
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
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s19, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_mul_i32 s19, s24, s19
		s_lshl_b32 s19, s19, 1
		s_add_i32 s24, s1, s19
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s25, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s42, v1
		s_mul_i32 s25, s42, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s24, s24, s25
		v_accvgpr_read_b32 v1, a12
		v_mul_lo_u32 v1, s18, v1
		v_lshl_add_u32 v2, v1, 6, s24
		v_accvgpr_read_b32 v3, a16
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v32, a20
		v_mul_lo_u32 v32, s18, v32
		v_lshl_add_u32 v2, v32, 5, v2
		v_accvgpr_read_b32 v33, a57
		v_mul_lo_u32 v33, s18, v33
		v_lshl_add_u32 v2, v33, 4, v2
		v_accvgpr_read_b32 v34, a17
		v_mul_lo_u32 v34, s18, v34
		v_lshl_add_u32 v2, v34, 3, v2
		v_accvgpr_read_b32 v35, a18
		v_mul_lo_u32 v35, s18, v35
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v36, a19
		v_lshl_add_u32 v2, v36, 4, v2
		s_and_saveexec_b64 s[90:91], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[68:71], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[90:91], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s24, s1, 32
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s25
		v_lshl_add_u32 v2, v1, 6, s24
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v36, a19
		v_lshl_add_u32 v2, v36, 4, v2
		s_and_saveexec_b64 s[90:91], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[4:7], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[90:91], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s24, s1, 64
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s25
		v_lshl_add_u32 v2, v1, 6, s24
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a19
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[8:11], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[90:91], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s24, s1, 0x60
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s25
		v_lshl_add_u32 v2, v1, 6, s24
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a19
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[12:15], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[90:91], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[90:91]
		s_lshl_b32 s24, s18, 8
		s_add_i32 s28, s24, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s25
		v_lshl_add_u32 v2, v1, 6, s28
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a19
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[16:19], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[90:91], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s24, 32
		s_add_i32 s22, s22, s1
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s25
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a19
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[20:23], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[90:91], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s24, 64
		s_add_i32 s22, s22, s1
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s25
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a19
		v_lshl_add_u32 v2, v4, 4, v2
		s_and_saveexec_b64 s[90:91], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[24:27], v2, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[90:91], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[90:91]
		s_add_i32 s22, s24, 0x60
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s25
		v_lshl_add_u32 v1, v1, 6, s1
		v_lshl_add_u32 v1, v3, 1, v1
		v_lshl_add_u32 v1, v32, 5, v1
		v_lshl_add_u32 v1, v33, 4, v1
		v_lshl_add_u32 v1, v34, 3, v1
		v_lshl_add_u32 v1, v35, 2, v1
		v_accvgpr_read_b32 v2, a19
		v_lshl_add_u32 v1, v2, 4, v1
		s_and_saveexec_b64 s[90:91], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[28:31], v1, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_31:
		s_andn2_b64 exec, s[90:91], s[38:39]
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
    wave.regalloc.agpr.dwords: 840
    wave.regalloc.remat.dwords: 4
    wave.regalloc.sgpr_to_vgpr.dwords: 56
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
