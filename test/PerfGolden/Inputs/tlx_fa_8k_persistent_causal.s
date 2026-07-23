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
		v_lshlrev_b32_e32 v4, 2, v5
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
		v_accvgpr_read_b32 v5, a66
		v_accvgpr_read_b32 v10, a67
		v_add3_u32 v5, s50, v5, v10
		v_accvgpr_read_b32 v10, a68
		v_accvgpr_read_b32 v13, a69
		v_add3_u32 v5, v5, v10, v13
		v_accvgpr_read_b32 v10, a70
		v_accvgpr_read_b32 v13, a71
		v_add3_u32 v5, v5, v10, v13
		ds_read_b128 v[80:83], v5
		ds_read_b128 a[80:83], v5 offset:32
		ds_read_b128 a[84:87], v5 offset:64
		ds_read_b128 a[88:91], v5 offset:96
		ds_read_b128 v[84:87], v5 offset:256
		ds_read_b128 a[92:95], v5 offset:288
		ds_read_b128 a[96:99], v5 offset:320
		ds_read_b128 a[100:103], v5 offset:352
		ds_read_b128 a[104:107], v5 offset:128
		ds_read_b128 a[108:111], v5 offset:160
		ds_read_b128 a[112:115], v5 offset:192
		ds_read_b128 a[116:119], v5 offset:224
		ds_read_b128 v[88:91], v5 offset:384
		ds_read_b128 a[120:123], v5 offset:416
		ds_read_b128 a[124:127], v5 offset:448
		ds_read_b128 a[128:131], v5 offset:480
		s_mul_i32 s49, 0x4400, s49
		v_accvgpr_read_b32 v5, a73
		v_accvgpr_read_b32 v10, a74
		v_add3_u32 v5, s49, v5, v10
		v_accvgpr_read_b32 v10, a75
		v_accvgpr_read_b32 v13, a76
		v_add3_u32 v5, v5, v10, v13
		ds_read_b64_tr_b16 a[132:133], v5 offset:33264
		ds_read_b64_tr_b16 a[134:135], v5 offset:37616
		ds_read_b64_tr_b16 a[136:137], v5 offset:33392
		ds_read_b64_tr_b16 a[138:139], v5 offset:37744
		ds_read_b64_tr_b16 a[140:141], v5 offset:33520
		ds_read_b64_tr_b16 a[142:143], v5 offset:37872
		ds_read_b64_tr_b16 a[144:145], v5 offset:33648
		ds_read_b64_tr_b16 a[146:147], v5 offset:38000
		ds_read_b64_tr_b16 a[148:149], v5 offset:33776
		ds_read_b64_tr_b16 a[150:151], v5 offset:38128
		ds_read_b64_tr_b16 a[152:153], v5 offset:33904
		ds_read_b64_tr_b16 a[154:155], v5 offset:38256
		ds_read_b64_tr_b16 a[156:157], v5 offset:34032
		ds_read_b64_tr_b16 a[158:159], v5 offset:38384
		ds_read_b64_tr_b16 a[160:161], v5 offset:34160
		ds_read_b64_tr_b16 a[162:163], v5 offset:38512
		ds_read_b64_tr_b16 a[164:165], v5 offset:33328
		ds_read_b64_tr_b16 a[166:167], v5 offset:37680
		ds_read_b64_tr_b16 a[168:169], v5 offset:33456
		ds_read_b64_tr_b16 a[170:171], v5 offset:37808
		ds_read_b64_tr_b16 a[172:173], v5 offset:33584
		ds_read_b64_tr_b16 a[174:175], v5 offset:37936
		ds_read_b64_tr_b16 a[176:177], v5 offset:33712
		ds_read_b64_tr_b16 a[178:179], v5 offset:38064
		ds_read_b64_tr_b16 a[180:181], v5 offset:33840
		ds_read_b64_tr_b16 a[182:183], v5 offset:38192
		ds_read_b64_tr_b16 a[184:185], v5 offset:33968
		ds_read_b64_tr_b16 a[186:187], v5 offset:38320
		ds_read_b64_tr_b16 a[188:189], v5 offset:34096
		ds_read_b64_tr_b16 a[190:191], v5 offset:38448
		ds_read_b64_tr_b16 a[192:193], v5 offset:34224
		ds_read_b64_tr_b16 a[194:195], v5 offset:38576
		s_mul_i32 s49, s15, s36
		s_lshl_b32 s49, s49, 1
		s_add_i32 s50, s43, s49
		v_add_u32_e32 v5, s50, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v10, s49, v2
		s_add_i32 s41, s41, 1
		v_add_u32_e32 v13, s44, v10
		s_and_b32 s41, s41, 1
		v_add_u32_e32 v92, s45, v10
		s_mul_i32 s49, 0x4100, s41
		v_add_u32_e32 v10, s37, v10
		s_add_i32 s49, s39, s49
		v_mfma_f32_32x32x16_bf16 v[96:111], v[80:83], a[28:31], 0
		s_mov_b32 m0, s49
		v_mfma_f32_32x32x16_bf16 v[112:127], v[84:87], a[28:31], 0
		s_mul_i32 s49, s17, s36
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], a[28:31], 0
		s_add_i32 s36, s36, 0x80
		v_mfma_f32_32x32x16_bf16 v[144:159], v[88:91], a[28:31], 0
		v_accvgpr_read_b32 v93, a25
		v_add_u32_e32 v93, s36, v93
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
		v_cmp_lt_i32_e64 vcc, v93, s21
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
		v_accvgpr_read_b32 v80, a61
		v_add_u32_e32 v80, s36, v80
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[48:51], v[160:175]
		v_accvgpr_read_b32 v81, a62
		v_add_u32_e32 v81, s36, v81
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[48:51], v[176:191]
		v_accvgpr_read_b32 v82, a63
		v_add_u32_e32 v82, s36, v82
		v_mfma_f32_32x32x16_bf16 v[192:207], a[92:95], a[48:51], v[192:207]
		v_cmp_lt_i32_e64 vcc, v80, s21
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[108:111], a[48:51], v[208:223]
		v_cmp_lt_i32_e64 vcc, v81, s21
		s_mov_b64 s[62:63], vcc
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[36:39], v[96:111]
		v_cmp_lt_i32_e64 vcc, v82, s21
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], a[36:39], v[112:127]
		v_cndmask_b32_e64 v5, v12, v5, s[50:51]
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], a[36:39], v[128:143]
		v_accvgpr_read_b32 v5, a65
		v_add_u32_e32 v5, s36, v5
		v_cndmask_b32_e64 v13, v12, v13, s[54:55]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v80, v12, v92, s[56:57]
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v10, v12, v10, s[58:59]
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s49, s49, 1
		s_add_i32 s50, s46, s49
		buffer_load_dwordx4 v80, s[28:31], 0 offen lds
		v_add_u32_e32 v5, s50, v1
		v_cndmask_b32_e64 v5, v12, v5, s[60:61]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s41, 0x4400, s41
		s_add_i32 s41, s38, s41
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_add_u32_e32 v10, s49, v1
		v_add_u32_e32 v13, s47, v10
		s_add_i32 m0, s41, 0x81f0
		v_cndmask_b32_e64 v13, v12, v13, s[62:63]
		v_add_u32_e32 v80, s48, v10
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v5, v12, v80, s[64:65]
		v_add_u32_e32 v10, s40, v10
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v10, v12, v10, vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[124:127], a[36:39], v[144:159]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[52:55], v[160:175]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[96:99], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[52:55], v[208:223]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[96:111], a[88:91], a[40:43], v[96:111]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s36, s42
		v_mfma_f32_32x32x16_bf16 v[112:127], a[100:103], a[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[116:119], a[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], a[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[128:131], a[56:59], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[88:91], a[56:59], v[176:191]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[100:103], a[56:59], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[116:119], a[56:59], v[208:223]
		s_nop 1
		v_max3_f32 v5, v96, v97, v98
		v_max3_f32 v10, v100, v101, v102
		v_max3_f32 v13, v104, v105, v106
		v_max3_f32 v80, v108, v109, v110
		v_max3_f32 v81, v112, v113, v114
		v_max3_f32 v82, v116, v117, v118
		v_max3_f32 v83, v120, v121, v122
		v_max3_f32 v84, v124, v125, v126
		v_max3_f32 v85, v128, v129, v130
		v_max3_f32 v86, v132, v133, v134
		v_max3_f32 v87, v136, v137, v138
		v_max3_f32 v88, v140, v141, v142
		v_max3_f32 v89, v144, v145, v146
		v_max3_f32 v90, v148, v149, v150
		v_max3_f32 v91, v152, v153, v154
		v_max3_f32 v92, v156, v157, v158
		v_max3_f32 v5, v5, v99, v10
		v_max3_f32 v10, v13, v107, v80
		v_max3_f32 v13, v81, v115, v82
		v_max3_f32 v80, v83, v123, v84
		v_max3_f32 v81, v85, v131, v86
		v_max3_f32 v82, v87, v139, v88
		v_max3_f32 v83, v89, v147, v90
		v_max3_f32 v84, v91, v155, v92
		v_max3_f32 v5, v5, v103, v10
		v_max3_f32 v10, v13, v119, v80
		v_max3_f32 v13, v81, v135, v82
		v_max3_f32 v80, v83, v151, v84
		v_max3_f32 v5, v5, v111, v10
		v_max3_f32 v10, v13, v143, v80
		v_max3_f32 v5, v5, v127, v10
		v_max_f32_e32 v5, v5, v159
		ds_bpermute_b32 v10, v3, v5
		ds_bpermute_b32 v13, v4, v5
		v_max3_f32 v5, v176, v177, v178
		v_max3_f32 v80, v180, v181, v182
		v_max3_f32 v81, v184, v185, v186
		v_max3_f32 v82, v188, v189, v190
		v_max3_f32 v83, v192, v193, v194
		v_max3_f32 v84, v196, v197, v198
		v_max3_f32 v85, v200, v201, v202
		v_max3_f32 v86, v204, v205, v206
		v_max3_f32 v87, v208, v209, v210
		v_max3_f32 v88, v212, v213, v214
		v_max3_f32 v89, v216, v217, v218
		v_max3_f32 v90, v220, v221, v222
		v_max3_f32 v91, v160, v161, v162
		v_max3_f32 v92, v164, v165, v166
		v_max3_f32 v93, v168, v169, v170
		v_max3_f32 v94, v172, v173, v174
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v224, v10, v13
		v_max3_f32 v5, v5, v179, v80
		v_max3_f32 v10, v81, v187, v82
		v_max3_f32 v13, v83, v195, v84
		v_max3_f32 v80, v85, v203, v86
		v_max3_f32 v81, v87, v211, v88
		v_max3_f32 v82, v89, v219, v90
		v_max3_f32 v83, v91, v163, v92
		v_max3_f32 v84, v93, v171, v94
		v_max3_f32 v5, v5, v183, v10
		v_max3_f32 v10, v13, v199, v80
		v_max3_f32 v13, v81, v215, v82
		v_max3_f32 v80, v83, v167, v84
		v_max3_f32 v5, v5, v191, v10
		v_max3_f32 v10, v13, v223, v80
		v_max3_f32 v5, v5, v207, v10
		v_max_f32_e32 v5, v5, v175
		ds_bpermute_b32 v10, v3, v5
		ds_bpermute_b32 v13, v4, v5
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v225, v10, v13
		v_pk_mul_f32 v[80:81], v[224:225], v[8:9]
		v_max_f32_e32 v82, v7, v80
		v_max_f32_e32 v83, v11, v81
		v_pk_fma_f32 v[80:81], v[96:97], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[84:85], v[98:99], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[86:87], v[100:101], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[88:89], v[102:103], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[90:91], v[104:105], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[92:93], v[106:107], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[94:95], v[108:109], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[110:111], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[112:113], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[114:115], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[116:117], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[118:119], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[120:121], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[122:123], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[124:125], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[126:127], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[128:129], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[130:131], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[132:133], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[134:135], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[136:137], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[138:139], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[140:141], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[142:143], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[144:145], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[146:147], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[148:149], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[150:151], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[152:153], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[154:155], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[156:157], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[158:159], v[8:9], v[82:83] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[176:177], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[178:179], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[180:181], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[182:183], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[184:185], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[186:187], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[188:189], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[190:191], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[192:193], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[194:195], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[196:197], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[198:199], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[200:201], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[202:203], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[204:205], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[206:207], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[208:209], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[210:211], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[212:213], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[214:215], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[216:217], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[218:219], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[220:221], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[222:223], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[160:161], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[8:9], v[82:83] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v174, v80
		v_exp_f32_e32 v212, v81
		v_exp_f32_e32 v175, v84
		v_exp_f32_e32 v213, v85
		v_exp_f32_e32 v80, v86
		v_exp_f32_e32 v84, v87
		v_exp_f32_e32 v81, v88
		v_exp_f32_e32 v85, v89
		v_exp_f32_e32 v86, v90
		v_exp_f32_e32 v88, v91
		v_exp_f32_e32 v87, v92
		v_exp_f32_e32 v89, v93
		v_exp_f32_e32 v90, v94
		v_exp_f32_e32 v92, v95
		v_exp_f32_e32 v91, v96
		v_exp_f32_e32 v93, v97
		v_exp_f32_e32 v94, v98
		v_exp_f32_e32 v96, v99
		v_exp_f32_e32 v95, v100
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
		v_exp_f32_e32 v143, v146
		v_exp_f32_e32 v145, v147
		v_exp_f32_e32 v146, v148
		v_exp_f32_e32 v214, v149
		v_exp_f32_e32 v147, v150
		v_exp_f32_e32 v215, v151
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v149, v154
		v_exp_f32_e32 v151, v155
		v_exp_f32_e32 v152, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v153, v158
		v_exp_f32_e32 v155, v159
		v_exp_f32_e32 v156, v176
		v_exp_f32_e32 v158, v177
		v_exp_f32_e32 v157, v178
		v_exp_f32_e32 v159, v179
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
		v_exp_f32_e32 v208, v160
		v_exp_f32_e32 v210, v161
		v_exp_f32_e32 v209, v162
		v_exp_f32_e32 v211, v163
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
		v_pk_add_f32 v[172:173], v[174:175], v[212:213]
		v_pk_add_f32 v[216:217], v[80:81], v[84:85]
		v_pk_add_f32 v[218:219], v[86:87], v[88:89]
		v_pk_add_f32 v[220:221], v[90:91], v[92:93]
		v_pk_add_f32 v[222:223], v[94:95], v[96:97]
		v_pk_add_f32 v[224:225], v[98:99], v[100:101]
		v_pk_add_f32 v[226:227], v[102:103], v[104:105]
		v_pk_add_f32 v[228:229], v[106:107], v[108:109]
		v_pk_add_f32 v[230:231], v[110:111], v[112:113]
		v_pk_add_f32 v[232:233], v[114:115], v[116:117]
		v_pk_add_f32 v[234:235], v[118:119], v[120:121]
		v_pk_add_f32 v[236:237], v[122:123], v[124:125]
		v_pk_add_f32 v[238:239], v[126:127], v[128:129]
		v_pk_add_f32 v[240:241], v[130:131], v[132:133]
		v_pk_add_f32 v[242:243], v[134:135], v[136:137]
		v_pk_add_f32 v[244:245], v[138:139], v[140:141]
		v_mov_b32_e32 v246, v173
		v_mov_b32_e32 v247, v217
		v_mov_b32_e32 v248, v172
		v_mov_b32_e32 v249, v216
		v_pk_add_f32 v[172:173], v[248:249], v[246:247]
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
		v_mov_b32_e32 v216, v173
		v_mov_b32_e32 v217, v219
		v_mov_b32_e32 v220, v172
		v_mov_b32_e32 v221, v218
		v_pk_add_f32 v[172:173], v[220:221], v[216:217]
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
		v_mov_b32_e32 v216, v173
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v218, v172
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[172:173], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v225
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v173
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v218, v172
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[172:173], v[218:219], v[216:217]
		v_add_f32_e32 v5, v172, v173
		ds_bpermute_b32 v142, v3, v5
		ds_bpermute_b32 v144, v4, v5
		v_pk_add_f32 v[172:173], v[146:147], v[214:215]
		v_pk_add_f32 v[216:217], v[148:149], v[150:151]
		v_pk_add_f32 v[218:219], v[152:153], v[154:155]
		v_pk_add_f32 v[220:221], v[156:157], v[158:159]
		v_pk_add_f32 v[222:223], v[176:177], v[178:179]
		v_pk_add_f32 v[224:225], v[180:181], v[182:183]
		v_pk_add_f32 v[226:227], v[184:185], v[186:187]
		v_pk_add_f32 v[228:229], v[188:189], v[190:191]
		v_pk_add_f32 v[230:231], v[192:193], v[194:195]
		v_pk_add_f32 v[232:233], v[196:197], v[198:199]
		v_pk_add_f32 v[234:235], v[200:201], v[202:203]
		v_pk_add_f32 v[236:237], v[204:205], v[206:207]
		v_pk_add_f32 v[238:239], v[208:209], v[210:211]
		v_pk_add_f32 v[240:241], v[160:161], v[162:163]
		v_pk_add_f32 v[242:243], v[164:165], v[166:167]
		v_mov_b32_e32 v244, v173
		v_mov_b32_e32 v245, v218
		v_pk_add_f32 v[246:247], v[244:245], v[216:217]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[216:217], v[142:143], v[144:145]
		v_mov_b32_e32 v169, v217
		v_mov_b32_e32 v171, v172
		v_pk_add_f32 v[172:173], v[168:169], v[170:171]
		v_mov_b32_e32 v244, v219
		v_mov_b32_e32 v245, v222
		v_pk_add_f32 v[218:219], v[244:245], v[220:221]
		v_mov_b32_e32 v220, v223
		v_mov_b32_e32 v221, v226
		v_pk_add_f32 v[222:223], v[220:221], v[224:225]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[220:221], v[220:221], v[228:229]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[226:227], v[224:225], v[232:233]
		v_mov_b32_e32 v224, v235
		v_mov_b32_e32 v225, v238
		v_pk_add_f32 v[224:225], v[224:225], v[236:237]
		v_mov_b32_e32 v228, v239
		v_mov_b32_e32 v229, v242
		v_pk_add_f32 v[230:231], v[228:229], v[240:241]
		v_mov_b32_e32 v228, v243
		v_mov_b32_e32 v229, v246
		v_pk_add_f32 v[172:173], v[228:229], v[172:173]
		v_mov_b32_e32 v228, v247
		v_mov_b32_e32 v229, v222
		v_pk_add_f32 v[232:233], v[228:229], v[218:219]
		v_mov_b32_e32 v218, v223
		v_mov_b32_e32 v219, v226
		v_pk_add_f32 v[218:219], v[218:219], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[222:223], v[220:221], v[224:225]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v232
		v_pk_add_f32 v[172:173], v[220:221], v[172:173]
		v_mov_b32_e32 v220, v233
		v_mov_b32_e32 v221, v222
		v_pk_add_f32 v[224:225], v[220:221], v[218:219]
		v_mov_b32_e32 v218, v223
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[172:173]
		v_add_f32_e32 v5, v225, v220
		v_add_f32_e32 v5, v221, v5
		ds_bpermute_b32 v10, v3, v5
		ds_bpermute_b32 v13, v4, v5
		v_sub_f32_e32 v5, v7, v82
		v_sub_f32_e32 v7, v11, v83
		v_exp_f32_e32 v172, v5
		v_exp_f32_e32 v218, v7
		v_mov_b32_e32 v173, v172
		v_pk_mul_f32 v[16:17], v[16:17], v[172:173]
		v_pk_mul_f32 v[18:19], v[18:19], v[172:173]
		v_pk_mul_f32 v[20:21], v[20:21], v[172:173]
		v_pk_mul_f32 v[22:23], v[22:23], v[172:173]
		v_pk_mul_f32 v[24:25], v[24:25], v[172:173]
		v_pk_mul_f32 v[26:27], v[26:27], v[172:173]
		v_pk_mul_f32 v[28:29], v[28:29], v[172:173]
		v_pk_mul_f32 v[30:31], v[30:31], v[172:173]
		v_pk_mul_f32 v[32:33], v[32:33], v[172:173]
		v_pk_mul_f32 v[34:35], v[34:35], v[172:173]
		v_pk_mul_f32 v[36:37], v[36:37], v[172:173]
		v_pk_mul_f32 v[38:39], v[38:39], v[172:173]
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v221, v10, v13
		v_pk_mul_f32 v[40:41], v[40:41], v[172:173]
		v_pk_mul_f32 v[42:43], v[42:43], v[172:173]
		v_pk_mul_f32 v[44:45], v[44:45], v[172:173]
		v_pk_mul_f32 v[46:47], v[46:47], v[172:173]
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
		v_mov_b32_e32 v220, v216
		v_mov_b32_e32 v10, v172
		v_mov_b32_e32 v11, v218
		v_mov_b64_e32 v[172:173], v[14:15]
		v_pk_fma_f32 v[14:15], v[172:173], v[10:11], v[220:221]
		v_cvt_pk_bf16_f32 v216, v174, v212
		v_cvt_pk_bf16_f32 v217, v175, v213
		v_cvt_pk_bf16_f32 v218, v80, v84
		v_cvt_pk_bf16_f32 v219, v81, v85
		v_cvt_pk_bf16_f32 v172, v86, v88
		v_cvt_pk_bf16_f32 v173, v87, v89
		v_cvt_pk_bf16_f32 v174, v90, v92
		v_cvt_pk_bf16_f32 v175, v91, v93
		v_cvt_pk_bf16_f32 v84, v94, v96
		v_cvt_pk_bf16_f32 v85, v95, v97
		v_cvt_pk_bf16_f32 v86, v98, v100
		v_cvt_pk_bf16_f32 v87, v99, v101
		v_cvt_pk_bf16_f32 v88, v102, v104
		v_cvt_pk_bf16_f32 v89, v103, v105
		v_cvt_pk_bf16_f32 v90, v106, v108
		v_cvt_pk_bf16_f32 v91, v107, v109
		v_cvt_pk_bf16_f32 v92, v110, v112
		v_cvt_pk_bf16_f32 v93, v111, v113
		v_cvt_pk_bf16_f32 v94, v114, v116
		v_cvt_pk_bf16_f32 v95, v115, v117
		v_cvt_pk_bf16_f32 v96, v118, v120
		v_cvt_pk_bf16_f32 v97, v119, v121
		v_cvt_pk_bf16_f32 v98, v122, v124
		v_cvt_pk_bf16_f32 v99, v123, v125
		v_cvt_pk_bf16_f32 v100, v126, v128
		v_cvt_pk_bf16_f32 v101, v127, v129
		v_cvt_pk_bf16_f32 v102, v130, v132
		v_cvt_pk_bf16_f32 v103, v131, v133
		v_cvt_pk_bf16_f32 v104, v134, v136
		v_cvt_pk_bf16_f32 v105, v135, v137
		v_cvt_pk_bf16_f32 v106, v138, v140
		v_cvt_pk_bf16_f32 v107, v139, v141
		v_cvt_pk_bf16_f32 v108, v143, v145
		v_cvt_pk_bf16_f32 v109, v146, v214
		v_cvt_pk_bf16_f32 v110, v147, v215
		v_cvt_pk_bf16_f32 v111, v148, v150
		v_cvt_pk_bf16_f32 v112, v149, v151
		v_cvt_pk_bf16_f32 v113, v152, v154
		v_cvt_pk_bf16_f32 v114, v153, v155
		v_cvt_pk_bf16_f32 v115, v156, v158
		v_cvt_pk_bf16_f32 v116, v157, v159
		v_cvt_pk_bf16_f32 v117, v176, v178
		v_cvt_pk_bf16_f32 v118, v177, v179
		v_cvt_pk_bf16_f32 v119, v180, v182
		v_cvt_pk_bf16_f32 v120, v181, v183
		v_cvt_pk_bf16_f32 v121, v184, v186
		v_cvt_pk_bf16_f32 v122, v185, v187
		v_cvt_pk_bf16_f32 v123, v188, v190
		v_cvt_pk_bf16_f32 v124, v189, v191
		v_cvt_pk_bf16_f32 v125, v192, v194
		v_cvt_pk_bf16_f32 v126, v193, v195
		v_cvt_pk_bf16_f32 v127, v196, v198
		v_cvt_pk_bf16_f32 v128, v197, v199
		v_cvt_pk_bf16_f32 v129, v200, v202
		v_cvt_pk_bf16_f32 v130, v201, v203
		v_cvt_pk_bf16_f32 v131, v204, v206
		v_cvt_pk_bf16_f32 v132, v205, v207
		v_cvt_pk_bf16_f32 v133, v208, v210
		v_cvt_pk_bf16_f32 v134, v209, v211
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
		v_mov_b32_e32 v7, v82
		v_mov_b32_e32 v11, v83
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s25, s25, 0x80
		v_accvgpr_read_b32 v5, a14
		v_accvgpr_read_b32 v8, a5
		s_nop 0
		v_readfirstlane_b32 s36, v8
		s_nop 1
		v_add_u32_e32 v5, s36, v5
		v_add_u32_e32 v5, s1, v5
		v_accvgpr_read_b32 v8, a15
		v_accvgpr_read_b32 v9, a5
		s_nop 0
		v_readfirstlane_b32 s36, v9
		s_nop 1
		v_add_u32_e32 v8, s36, v8
		v_add_u32_e32 v8, s1, v8
		v_xor_b32_e32 v9, 1, v6
		v_accvgpr_write_b32 a14, v9
		v_xor_b32_e32 v9, 2, v6
		v_accvgpr_write_b32 a15, v9
		v_xor_b32_e32 v9, 3, v6
		v_accvgpr_write_b32 a66, v9
		v_xor_b32_e32 v9, 8, v6
		v_accvgpr_write_b32 a73, v9
		v_xor_b32_e32 v9, 9, v6
		v_accvgpr_write_b32 a77, v9
		v_xor_b32_e32 v9, 10, v6
		v_accvgpr_write_b32 a78, v9
		v_xor_b32_e32 v9, 11, v6
		v_accvgpr_write_b32 a79, v9
		v_xor_b32_e32 v9, 16, v6
		v_accvgpr_write_b32 a80, v9
		v_xor_b32_e32 v9, 17, v6
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 18, v6
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 19, v6
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 24, v6
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 25, v6
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 26, v6
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 27, v6
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 32, v6
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 33, v6
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 34, v6
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 35, v6
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 40, v6
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 41, v6
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 42, v6
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 43, v6
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 48, v6
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 49, v6
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 50, v6
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 51, v6
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 56, v6
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 57, v6
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 58, v6
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 59, v6
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 64, v6
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 0x41, v6
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 0x42, v6
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 0x43, v6
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 0x48, v6
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x49, v6
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x4a, v6
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x4b, v6
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x50, v6
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x51, v6
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x52, v6
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x53, v6
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x58, v6
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x59, v6
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x5a, v6
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x5b, v6
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x60, v6
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x61, v6
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x62, v6
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x63, v6
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x68, v6
		v_accvgpr_write_b32 a124, v9
		v_xor_b32_e32 v9, 0x69, v6
		v_accvgpr_write_b32 a125, v9
		v_xor_b32_e32 v9, 0x6a, v6
		v_accvgpr_write_b32 a126, v9
		v_xor_b32_e32 v9, 0x6b, v6
		v_accvgpr_write_b32 a127, v9
		v_xor_b32_e32 v9, 0x70, v6
		v_accvgpr_write_b32 a128, v9
		v_xor_b32_e32 v9, 0x71, v6
		v_accvgpr_write_b32 a129, v9
		v_xor_b32_e32 v9, 0x72, v6
		v_accvgpr_write_b32 a130, v9
		v_xor_b32_e32 v9, 0x73, v6
		v_accvgpr_write_b32 a131, v9
		v_xor_b32_e32 v9, 0x78, v6
		v_accvgpr_write_b32 a132, v9
		v_xor_b32_e32 v9, 0x79, v6
		v_accvgpr_write_b32 a133, v9
		v_xor_b32_e32 v9, 0x7a, v6
		v_accvgpr_write_b32 a134, v9
		v_xor_b32_e32 v9, 0x7b, v6
		v_accvgpr_write_b32 a135, v9
		v_accvgpr_read_b32 v9, a24
		v_accvgpr_read_b32 v10, a67
		v_lshl_add_u32 v9, v9, 4, v10
		v_accvgpr_read_b32 v10, a68
		v_accvgpr_read_b32 v13, a69
		v_add3_u32 v9, v9, v10, v13
		v_accvgpr_read_b32 v10, a70
		v_accvgpr_read_b32 v13, a71
		v_add3_u32 v9, v9, v10, v13
		v_accvgpr_write_b32 a24, v9
		v_accvgpr_read_b32 v9, a72
		v_accvgpr_read_b32 v10, a74
		v_lshl_add_u32 v9, v9, 3, v10
		v_accvgpr_read_b32 v10, a75
		v_accvgpr_read_b32 v13, a76
		v_add3_u32 v9, v9, v10, v13
		v_accvgpr_write_b32 a67, v9
		v_mov_b32_e32 v9, 0xff800000
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
		ds_read_b128 a[136:139], v10 offset:64
		ds_read_b128 a[140:143], v10 offset:96
		ds_read_b128 a[144:147], v10 offset:256
		ds_read_b128 a[148:151], v10 offset:288
		ds_read_b128 a[152:155], v10 offset:320
		ds_read_b128 a[156:159], v10 offset:352
		ds_read_b128 a[160:163], v10 offset:128
		ds_read_b128 a[164:167], v10 offset:160
		ds_read_b128 a[168:171], v10 offset:192
		ds_read_b128 a[172:175], v10 offset:224
		ds_read_b128 v[84:87], v10 offset:384
		ds_read_b128 a[176:179], v10 offset:416
		ds_read_b128 a[180:183], v10 offset:448
		ds_read_b128 a[184:187], v10 offset:480
		s_mul_i32 s36, 0x4400, s38
		v_accvgpr_read_b32 v10, a67
		v_add_u32_e32 v10, s36, v10
		ds_read_b64_tr_b16 a[188:189], v10 offset:33264
		ds_read_b64_tr_b16 a[190:191], v10 offset:37616
		ds_read_b64_tr_b16 a[192:193], v10 offset:33392
		ds_read_b64_tr_b16 a[194:195], v10 offset:37744
		ds_read_b64_tr_b16 a[196:197], v10 offset:33520
		ds_read_b64_tr_b16 a[198:199], v10 offset:37872
		ds_read_b64_tr_b16 a[200:201], v10 offset:33648
		ds_read_b64_tr_b16 a[202:203], v10 offset:38000
		ds_read_b64_tr_b16 a[204:205], v10 offset:33776
		ds_read_b64_tr_b16 a[206:207], v10 offset:38128
		ds_read_b64_tr_b16 a[208:209], v10 offset:33904
		ds_read_b64_tr_b16 a[210:211], v10 offset:38256
		ds_read_b64_tr_b16 a[212:213], v10 offset:34032
		ds_read_b64_tr_b16 a[214:215], v10 offset:38384
		ds_read_b64_tr_b16 a[216:217], v10 offset:34160
		ds_read_b64_tr_b16 a[218:219], v10 offset:38512
		ds_read_b64_tr_b16 a[220:221], v10 offset:33328
		ds_read_b64_tr_b16 a[222:223], v10 offset:37680
		ds_read_b64_tr_b16 a[224:225], v10 offset:33456
		ds_read_b64_tr_b16 a[226:227], v10 offset:37808
		ds_read_b64_tr_b16 a[228:229], v10 offset:33584
		ds_read_b64_tr_b16 a[230:231], v10 offset:37936
		ds_read_b64_tr_b16 a[232:233], v10 offset:33712
		ds_read_b64_tr_b16 a[234:235], v10 offset:38064
		ds_read_b64_tr_b16 a[236:237], v10 offset:33840
		ds_read_b64_tr_b16 a[238:239], v10 offset:38192
		ds_read_b64_tr_b16 a[240:241], v10 offset:33968
		ds_read_b64_tr_b16 a[242:243], v10 offset:38320
		ds_read_b64_tr_b16 a[244:245], v10 offset:34096
		ds_read_b64_tr_b16 a[246:247], v10 offset:38448
		ds_read_b64_tr_b16 a[248:249], v10 offset:34224
		ds_read_b64_tr_b16 a[250:251], v10 offset:38576
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
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[84:87], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[84:87], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[80:83], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[44:47], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[68:71], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[176:179], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], a[48:51], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[164:167], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[52:55], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], a[52:55], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[168:171], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[56:59], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[56:59], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], a[56:59], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[172:175], a[56:59], v[192:207]
		v_add_u32_e32 v10, s42, v6
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, s42, v13
		v_accvgpr_read_b32 v208, a15
		v_add_u32_e32 v208, s42, v208
		v_accvgpr_read_b32 v209, a66
		v_add_u32_e32 v209, s42, v209
		v_accvgpr_read_b32 v210, a78
		v_add_u32_e32 v210, s42, v210
		v_accvgpr_read_b32 v211, a79
		v_add_u32_e32 v211, s42, v211
		v_accvgpr_read_b32 v212, a82
		v_add_u32_e32 v212, s42, v212
		v_accvgpr_read_b32 v213, a83
		v_add_u32_e32 v213, s42, v213
		v_accvgpr_read_b32 v214, a86
		v_add_u32_e32 v214, s42, v214
		v_accvgpr_read_b32 v215, a87
		v_add_u32_e32 v215, s42, v215
		v_accvgpr_read_b32 v216, a90
		v_add_u32_e32 v216, s42, v216
		v_accvgpr_read_b32 v217, a91
		v_add_u32_e32 v217, s42, v217
		v_accvgpr_read_b32 v218, a94
		v_add_u32_e32 v218, s42, v218
		v_accvgpr_read_b32 v219, a95
		v_add_u32_e32 v219, s42, v219
		v_accvgpr_read_b32 v220, a98
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a68, v220
		v_accvgpr_read_b32 v220, a99
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a69, v220
		v_accvgpr_read_b32 v220, a102
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a70, v220
		v_accvgpr_read_b32 v220, a103
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a71, v220
		v_accvgpr_read_b32 v220, a106
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a72, v220
		v_accvgpr_read_b32 v220, a107
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a74, v220
		v_accvgpr_read_b32 v220, a110
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a75, v220
		v_accvgpr_read_b32 v220, a111
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a76, v220
		v_accvgpr_read_b32 v220, a114
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a136, v220
		v_accvgpr_read_b32 v220, a115
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a137, v220
		v_accvgpr_read_b32 v220, a118
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a138, v220
		v_accvgpr_read_b32 v220, a119
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a139, v220
		v_accvgpr_read_b32 v220, a122
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a140, v220
		v_accvgpr_read_b32 v220, a123
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a141, v220
		v_accvgpr_read_b32 v220, a126
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a142, v220
		v_accvgpr_read_b32 v220, a127
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a143, v220
		v_accvgpr_read_b32 v220, a130
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a144, v220
		v_accvgpr_read_b32 v220, a131
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a145, v220
		v_accvgpr_read_b32 v220, a134
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a146, v220
		v_accvgpr_read_b32 v220, a135
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_write_b32 a147, v220
		v_cmp_ge_i32_e64 vcc, v5, v10
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v5, v13
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v208
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v5, v209
		v_accvgpr_read_b32 v220, a73
		v_add_u32_e32 v220, s42, v220
		v_accvgpr_read_b32 v221, a77
		v_add_u32_e32 v221, s42, v221
		v_cndmask_b32_e32 v223, v9, v99, vcc
		v_cmp_ge_i32_e64 vcc, v5, v220
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v5, v221
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v5, v210
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v5, v211
		v_accvgpr_read_b32 v99, a80
		v_add_u32_e32 v99, s42, v99
		v_accvgpr_read_b32 v222, a81
		v_add_u32_e32 v224, s42, v222
		v_cndmask_b32_e32 v227, v9, v103, vcc
		v_cmp_ge_i32_e64 vcc, v5, v99
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v5, v224
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v5, v212
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v5, v213
		v_accvgpr_read_b32 v103, a84
		v_add_u32_e32 v103, s42, v103
		v_accvgpr_read_b32 v222, a85
		v_add_u32_e32 v225, s42, v222
		v_cndmask_b32_e32 v229, v9, v107, vcc
		v_cmp_ge_i32_e64 vcc, v5, v103
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v5, v225
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v5, v214
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v5, v215
		v_accvgpr_read_b32 v107, a88
		v_add_u32_e32 v107, s42, v107
		v_accvgpr_read_b32 v222, a89
		v_add_u32_e32 v230, s42, v222
		v_cndmask_b32_e32 v233, v9, v111, vcc
		v_cmp_ge_i32_e64 vcc, v5, v107
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v5, v230
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v5, v216
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v5, v217
		v_accvgpr_read_b32 v111, a92
		v_add_u32_e32 v111, s42, v111
		v_accvgpr_read_b32 v222, a93
		v_add_u32_e32 v231, s42, v222
		v_cndmask_b32_e32 v235, v9, v115, vcc
		v_cmp_ge_i32_e64 vcc, v5, v111
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v5, v231
		s_mov_b64 s[82:83], vcc
		v_cmp_ge_i32_e64 vcc, v5, v218
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v236, s84
		v_mov_b32_e32 v237, s85
		v_accvgpr_write_b32 a148, v236
		v_accvgpr_write_b32 a149, v237
		v_cmp_ge_i32_e64 vcc, v5, v219
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v236, s84
		v_mov_b32_e32 v237, s85
		v_accvgpr_read_b32 v115, a96
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_read_b32 v222, a97
		v_add_u32_e32 v234, s42, v222
		v_cndmask_b32_e32 v237, v9, v119, vcc
		v_cmp_ge_i32_e64 vcc, v5, v115
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_write_b32 a150, v238
		v_accvgpr_write_b32 a151, v239
		v_cmp_ge_i32_e64 vcc, v5, v234
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_write_b32 a152, v238
		v_accvgpr_write_b32 a153, v239
		v_accvgpr_read_b32 v119, a68
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v238, s84
		v_mov_b32_e32 v239, s85
		v_accvgpr_write_b32 a154, v238
		v_accvgpr_write_b32 a155, v239
		v_accvgpr_read_b32 v119, a69
		v_cmp_ge_i32_e64 vcc, v5, v119
		v_accvgpr_read_b32 v119, a100
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a156, v119
		v_accvgpr_read_b32 v119, a101
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a157, v119
		v_cndmask_b32_e32 v239, v9, v123, vcc
		v_accvgpr_read_b32 v119, a156
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a158, v240
		v_accvgpr_write_b32 a159, v241
		v_accvgpr_read_b32 v119, a157
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a160, v240
		v_accvgpr_write_b32 a161, v241
		v_accvgpr_read_b32 v119, a70
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_write_b32 a162, v240
		v_accvgpr_write_b32 a163, v241
		v_accvgpr_read_b32 v119, a71
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v240, s84
		v_mov_b32_e32 v241, s85
		v_accvgpr_read_b32 v119, a104
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a164, v119
		v_accvgpr_read_b32 v119, a105
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a165, v119
		v_cndmask_b32_e32 v241, v9, v127, vcc
		v_accvgpr_read_b32 v119, a164
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a166, v242
		v_accvgpr_write_b32 a167, v243
		v_accvgpr_read_b32 v119, a165
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a168, v242
		v_accvgpr_write_b32 a169, v243
		v_accvgpr_read_b32 v119, a72
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v242, s84
		v_mov_b32_e32 v243, s85
		v_accvgpr_write_b32 a170, v242
		v_accvgpr_write_b32 a171, v243
		v_accvgpr_read_b32 v119, a74
		v_cmp_ge_i32_e64 vcc, v5, v119
		v_accvgpr_read_b32 v119, a108
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a172, v119
		v_accvgpr_read_b32 v119, a109
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a173, v119
		v_cndmask_b32_e32 v243, v9, v131, vcc
		v_accvgpr_read_b32 v119, a172
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a174, v244
		v_accvgpr_write_b32 a175, v245
		v_accvgpr_read_b32 v119, a173
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a176, v244
		v_accvgpr_write_b32 a177, v245
		v_accvgpr_read_b32 v119, a75
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_write_b32 a178, v244
		v_accvgpr_write_b32 a179, v245
		v_accvgpr_read_b32 v119, a76
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v244, s84
		v_mov_b32_e32 v245, s85
		v_accvgpr_read_b32 v119, a112
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a180, v119
		v_accvgpr_read_b32 v119, a113
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a181, v119
		v_cndmask_b32_e32 v245, v9, v135, vcc
		v_accvgpr_read_b32 v119, a180
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a182, v246
		v_accvgpr_write_b32 a183, v247
		v_accvgpr_read_b32 v119, a181
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a184, v246
		v_accvgpr_write_b32 a185, v247
		v_accvgpr_read_b32 v119, a136
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v246, s84
		v_mov_b32_e32 v247, s85
		v_accvgpr_write_b32 a186, v246
		v_accvgpr_write_b32 a187, v247
		v_accvgpr_read_b32 v119, a137
		v_cmp_ge_i32_e64 vcc, v5, v119
		v_accvgpr_read_b32 v119, a116
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a252, v119
		v_accvgpr_read_b32 v119, a117
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_write_b32 a253, v119
		v_cndmask_b32_e32 v247, v9, v139, vcc
		v_accvgpr_read_b32 v119, a252
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_mov_b32_e32 v248, s84
		v_mov_b32_e32 v249, s85
		v_accvgpr_write_b32 a254, v248
		v_accvgpr_write_b32 a255, v249
		v_accvgpr_read_b32 v119, a253
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v119, a138
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[86:87], vcc
		v_cndmask_b32_e64 v249, v9, v141, s[84:85]
		v_cndmask_b32_e64 v250, v9, v142, s[86:87]
		v_accvgpr_read_b32 v119, a139
		v_cmp_ge_i32_e64 vcc, v5, v119
		v_accvgpr_read_b32 v119, a120
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_read_b32 v123, a121
		v_add_u32_e32 v123, s42, v123
		v_cndmask_b32_e32 v251, v9, v143, vcc
		v_cmp_ge_i32_e64 vcc, v5, v119
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v5, v123
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v127, a140
		v_cmp_ge_i32_e64 vcc, v5, v127
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v142, v9, v144, s[84:85]
		v_cndmask_b32_e64 v143, v9, v145, s[86:87]
		v_cndmask_b32_e64 v144, v9, v146, s[88:89]
		v_accvgpr_read_b32 v127, a141
		v_cmp_ge_i32_e64 vcc, v5, v127
		v_accvgpr_read_b32 v127, a124
		v_add_u32_e32 v127, s42, v127
		v_accvgpr_read_b32 v131, a125
		v_add_u32_e32 v131, s42, v131
		v_cndmask_b32_e32 v145, v9, v147, vcc
		v_cmp_ge_i32_e64 vcc, v5, v127
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v5, v131
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v135, a142
		v_cmp_ge_i32_e64 vcc, v5, v135
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v146, v9, v148, s[84:85]
		v_cndmask_b32_e64 v147, v9, v149, s[86:87]
		v_cndmask_b32_e64 v148, v9, v150, s[88:89]
		v_accvgpr_read_b32 v135, a143
		v_cmp_ge_i32_e64 vcc, v5, v135
		v_accvgpr_read_b32 v135, a128
		v_add_u32_e32 v135, s42, v135
		v_accvgpr_read_b32 v139, a129
		v_add_u32_e32 v139, s42, v139
		v_cndmask_b32_e32 v149, v9, v151, vcc
		v_cmp_ge_i32_e64 vcc, v5, v135
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v5, v139
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v141, a144
		v_cmp_ge_i32_e64 vcc, v5, v141
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v150, v9, v152, s[84:85]
		v_cndmask_b32_e64 v151, v9, v153, s[86:87]
		v_cndmask_b32_e64 v152, v9, v154, s[88:89]
		v_accvgpr_read_b32 v141, a145
		v_cmp_ge_i32_e64 vcc, v5, v141
		v_accvgpr_read_b32 v141, a132
		v_add_u32_e32 v141, s42, v141
		v_accvgpr_read_b32 v153, a133
		v_add_u32_e32 v154, s42, v153
		v_cndmask_b32_e32 v153, v9, v155, vcc
		v_cmp_ge_i32_e64 vcc, v5, v141
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v5, v154
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v155, a146
		v_cmp_ge_i32_e64 vcc, v5, v155
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v252, v9, v156, s[84:85]
		v_cndmask_b32_e64 v253, v9, v157, s[86:87]
		v_cndmask_b32_e64 v156, v9, v158, s[88:89]
		v_accvgpr_read_b32 v155, a147
		v_cmp_ge_i32_e64 vcc, v5, v155
		v_mov_b32_e32 v155, 0xff800000
		v_cndmask_b32_e64 v254, v155, v96, s[38:39]
		v_cndmask_b32_e64 v255, v155, v97, s[50:51]
		v_cndmask_b32_e32 v157, v155, v159, vcc
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v13
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v208
		s_mov_b64 s[84:85], vcc
		v_cndmask_b32_e64 v96, v155, v176, s[38:39]
		v_cndmask_b32_e64 v97, v155, v177, s[50:51]
		v_cndmask_b32_e64 v158, v155, v178, s[84:85]
		v_cmp_ge_i32_e64 vcc, v8, v209
		v_cndmask_b32_e64 v222, v155, v98, s[54:55]
		v_cndmask_b32_e64 v176, v155, v100, s[56:57]
		v_cndmask_b32_e32 v159, v155, v179, vcc
		v_cmp_ge_i32_e64 vcc, v8, v220
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v221
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v210
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v178, v155, v180, s[38:39]
		v_cndmask_b32_e64 v179, v155, v181, s[50:51]
		v_cndmask_b32_e64 v180, v155, v182, s[54:55]
		v_cmp_ge_i32_e64 vcc, v8, v211
		v_cndmask_b32_e64 v177, v155, v101, s[58:59]
		v_cndmask_b32_e64 v226, v155, v102, s[60:61]
		v_cndmask_b32_e32 v181, v155, v183, vcc
		v_cmp_ge_i32_e64 vcc, v8, v99
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v224
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v212
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v98, v155, v184, s[38:39]
		v_cndmask_b32_e64 v99, v155, v185, s[50:51]
		v_cndmask_b32_e64 v100, v155, v186, s[54:55]
		v_cmp_ge_i32_e64 vcc, v8, v213
		v_cndmask_b32_e64 v182, v155, v104, s[62:63]
		v_cndmask_b32_e64 v183, v155, v105, s[64:65]
		v_cndmask_b32_e32 v101, v155, v187, vcc
		v_cmp_ge_i32_e64 vcc, v8, v103
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v225
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v214
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v102, v155, v188, s[38:39]
		v_cndmask_b32_e64 v103, v155, v189, s[50:51]
		v_cndmask_b32_e64 v104, v155, v190, s[54:55]
		v_cmp_ge_i32_e64 vcc, v8, v215
		v_cndmask_b32_e64 v228, v155, v106, s[66:67]
		v_cndmask_b32_e64 v184, v155, v108, s[68:69]
		v_cndmask_b32_e32 v105, v155, v191, vcc
		v_cmp_ge_i32_e64 vcc, v8, v107
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v230
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v216
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v106, v155, v80, s[38:39]
		v_cndmask_b32_e64 v107, v155, v81, s[50:51]
		v_cndmask_b32_e64 v80, v155, v82, s[54:55]
		v_cmp_ge_i32_e64 vcc, v8, v217
		v_cndmask_b32_e64 v185, v155, v109, s[70:71]
		v_cndmask_b32_e64 v232, v155, v110, s[72:73]
		v_cndmask_b32_e32 v81, v155, v83, vcc
		v_cmp_ge_i32_e64 vcc, v8, v111
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v231
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v218
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v82, v155, v84, s[38:39]
		v_cndmask_b32_e64 v83, v155, v85, s[50:51]
		v_cndmask_b32_e64 v84, v155, v86, s[54:55]
		v_cmp_ge_i32_e64 vcc, v8, v219
		v_cndmask_b32_e64 v108, v155, v112, s[74:75]
		v_cndmask_b32_e64 v109, v155, v113, s[76:77]
		v_cndmask_b32_e32 v85, v155, v87, vcc
		v_cmp_ge_i32_e64 vcc, v8, v115
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v234
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a68
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v86, v155, v88, s[38:39]
		v_cndmask_b32_e64 v87, v155, v89, s[50:51]
		v_cndmask_b32_e64 v88, v155, v90, s[54:55]
		v_accvgpr_read_b32 v10, a69
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_cndmask_b32_e64 v234, v155, v114, s[78:79]
		v_cndmask_b32_e64 v110, v155, v116, s[80:81]
		v_cndmask_b32_e32 v89, v155, v91, vcc
		v_accvgpr_read_b32 v10, a156
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a157
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a70
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v90, v155, v92, s[38:39]
		v_cndmask_b32_e64 v91, v155, v93, s[50:51]
		v_cndmask_b32_e64 v92, v155, v94, s[54:55]
		v_accvgpr_read_b32 v10, a71
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_cndmask_b32_e64 v111, v155, v117, s[82:83]
		v_accvgpr_read_b32 v10, a148
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a149
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v236, v155, v118, s[38:39]
		v_cndmask_b32_e32 v93, v155, v95, vcc
		v_accvgpr_read_b32 v10, a164
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a165
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a72
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v94, v155, v192, s[38:39]
		v_cndmask_b32_e64 v95, v155, v193, s[50:51]
		v_cndmask_b32_e64 v112, v155, v194, s[54:55]
		v_accvgpr_read_b32 v10, a74
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_accvgpr_read_b32 v10, a150
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a151
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v114, v155, v120, s[38:39]
		v_accvgpr_read_b32 v10, a152
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a153
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v115, v155, v121, s[38:39]
		v_cndmask_b32_e32 v113, v155, v195, vcc
		v_accvgpr_read_b32 v10, a172
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a173
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a75
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v116, v155, v196, s[38:39]
		v_cndmask_b32_e64 v117, v155, v197, s[50:51]
		v_cndmask_b32_e64 v120, v155, v198, s[54:55]
		v_accvgpr_read_b32 v10, a76
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_accvgpr_read_b32 v10, a154
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a155
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v238, v155, v122, s[38:39]
		v_accvgpr_read_b32 v10, a158
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a159
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v186, v155, v124, s[38:39]
		v_cndmask_b32_e32 v121, v155, v199, vcc
		v_accvgpr_read_b32 v10, a180
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a181
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a136
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v188, v155, v200, s[38:39]
		v_cndmask_b32_e64 v189, v155, v201, s[50:51]
		v_cndmask_b32_e64 v190, v155, v202, s[54:55]
		v_accvgpr_read_b32 v10, a137
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_accvgpr_read_b32 v10, a160
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a161
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v187, v155, v125, s[38:39]
		v_accvgpr_read_b32 v10, a162
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a163
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v240, v155, v126, s[38:39]
		v_cndmask_b32_e32 v191, v155, v203, vcc
		v_accvgpr_read_b32 v10, a252
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v10, a253
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a138
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v124, v155, v204, s[38:39]
		v_cndmask_b32_e64 v125, v155, v205, s[50:51]
		v_cndmask_b32_e64 v192, v155, v206, s[54:55]
		v_accvgpr_read_b32 v10, a139
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_accvgpr_read_b32 v10, a166
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a167
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v194, v155, v128, s[38:39]
		v_accvgpr_read_b32 v10, a168
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a169
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v195, v155, v129, s[38:39]
		v_cndmask_b32_e32 v193, v155, v207, vcc
		v_cmp_ge_i32_e64 vcc, v8, v119
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v123
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a140
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v118, v155, v160, s[38:39]
		v_cndmask_b32_e64 v119, v155, v161, s[50:51]
		v_cndmask_b32_e64 v122, v155, v162, s[54:55]
		v_accvgpr_read_b32 v10, a141
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_accvgpr_read_b32 v10, a170
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a171
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v242, v155, v130, s[38:39]
		v_accvgpr_read_b32 v10, a174
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a175
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v128, v155, v132, s[38:39]
		v_cndmask_b32_e32 v123, v155, v163, vcc
		v_cmp_ge_i32_e64 vcc, v8, v127
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v131
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a142
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v126, v155, v164, s[38:39]
		v_cndmask_b32_e64 v127, v155, v165, s[50:51]
		v_cndmask_b32_e64 v130, v155, v166, s[54:55]
		v_accvgpr_read_b32 v10, a143
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_accvgpr_read_b32 v10, a176
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a177
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v129, v155, v133, s[38:39]
		v_accvgpr_read_b32 v10, a178
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a179
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v244, v155, v134, s[38:39]
		v_cndmask_b32_e32 v131, v155, v167, vcc
		v_cmp_ge_i32_e64 vcc, v8, v135
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v139
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a144
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v132, v155, v168, s[38:39]
		v_cndmask_b32_e64 v133, v155, v169, s[50:51]
		v_cndmask_b32_e64 v134, v155, v170, s[54:55]
		v_accvgpr_read_b32 v10, a145
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_accvgpr_read_b32 v10, a182
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a183
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v160, v155, v136, s[38:39]
		v_accvgpr_read_b32 v10, a184
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a185
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v161, v155, v137, s[38:39]
		v_cndmask_b32_e32 v135, v155, v171, vcc
		v_cmp_ge_i32_e64 vcc, v8, v141
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v154
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a146
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v136, v155, v172, s[38:39]
		v_cndmask_b32_e64 v137, v155, v173, s[50:51]
		v_cndmask_b32_e64 v162, v155, v174, s[54:55]
		v_accvgpr_read_b32 v10, a147
		v_cmp_ge_i32_e64 vcc, v8, v10
		v_accvgpr_read_b32 v10, a186
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a187
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v246, v155, v138, s[38:39]
		v_accvgpr_read_b32 v10, a254
		s_nop 0
		v_readfirstlane_b32 s38, v10
		v_accvgpr_read_b32 v10, a255
		s_nop 0
		v_readfirstlane_b32 s39, v10
		s_nop 1
		v_cndmask_b32_e64 v248, v155, v140, s[38:39]
		v_cndmask_b32_e32 v163, v155, v175, vcc
		v_max3_f32 v10, v254, v255, v222
		v_max3_f32 v13, v176, v177, v226
		v_max3_f32 v138, v182, v183, v228
		v_max3_f32 v139, v184, v185, v232
		v_max3_f32 v140, v108, v109, v234
		v_max3_f32 v141, v110, v111, v236
		v_max3_f32 v154, v114, v115, v238
		v_max3_f32 v155, v186, v187, v240
		v_max3_f32 v164, v194, v195, v242
		v_max3_f32 v165, v128, v129, v244
		v_max3_f32 v166, v160, v161, v246
		v_max3_f32 v167, v248, v249, v250
		v_max3_f32 v168, v142, v143, v144
		v_max3_f32 v169, v146, v147, v148
		v_max3_f32 v170, v150, v151, v152
		v_max3_f32 v171, v252, v253, v156
		v_max3_f32 v10, v10, v223, v13
		v_max3_f32 v13, v138, v229, v139
		v_max3_f32 v138, v140, v235, v141
		v_max3_f32 v139, v154, v239, v155
		v_max3_f32 v140, v164, v243, v165
		v_max3_f32 v141, v166, v247, v167
		v_max3_f32 v154, v168, v145, v169
		v_max3_f32 v155, v170, v153, v171
		v_max3_f32 v10, v10, v227, v13
		v_max3_f32 v13, v138, v237, v139
		v_max3_f32 v138, v140, v245, v141
		v_max3_f32 v139, v154, v149, v155
		v_max3_f32 v10, v10, v233, v13
		v_max3_f32 v13, v138, v251, v139
		v_max3_f32 v10, v10, v241, v13
		v_max_f32_e32 v10, v10, v157
		ds_bpermute_b32 v13, v3, v10
		ds_bpermute_b32 v138, v4, v10
		v_max3_f32 v10, v96, v97, v158
		v_max3_f32 v139, v178, v179, v180
		v_max3_f32 v140, v98, v99, v100
		v_max3_f32 v141, v102, v103, v104
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v154, v13, v138
		v_max3_f32 v13, v106, v107, v80
		v_max3_f32 v138, v82, v83, v84
		v_max3_f32 v155, v86, v87, v88
		v_max3_f32 v164, v90, v91, v92
		v_max3_f32 v165, v94, v95, v112
		v_max3_f32 v166, v116, v117, v120
		v_max3_f32 v167, v188, v189, v190
		v_max3_f32 v168, v124, v125, v192
		v_max3_f32 v169, v118, v119, v122
		v_max3_f32 v170, v126, v127, v130
		v_max3_f32 v171, v132, v133, v134
		v_max3_f32 v172, v136, v137, v162
		v_max3_f32 v10, v10, v159, v139
		v_max3_f32 v139, v140, v101, v141
		v_max3_f32 v13, v13, v81, v138
		v_max3_f32 v138, v155, v89, v164
		v_max3_f32 v140, v165, v113, v166
		v_max3_f32 v141, v167, v191, v168
		v_max3_f32 v155, v169, v123, v170
		v_max3_f32 v164, v171, v135, v172
		v_max3_f32 v10, v10, v181, v139
		v_max3_f32 v13, v13, v85, v138
		v_max3_f32 v138, v140, v121, v141
		v_max3_f32 v139, v155, v131, v164
		v_max3_f32 v10, v10, v105, v13
		v_max3_f32 v13, v138, v193, v139
		v_max3_f32 v10, v10, v93, v13
		v_max_f32_e32 v10, v10, v163
		ds_bpermute_b32 v13, v3, v10
		ds_bpermute_b32 v138, v4, v10
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s1, s25
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v155, v13, v138
		v_mov_b32_e32 v138, 0x3e38aa3b
		v_mov_b32_e32 v139, 0x3e38aa3b
		v_pk_mul_f32 v[140:141], v[154:155], v[138:139]
		v_max_f32_e32 v154, v7, v140
		v_max_f32_e32 v155, v11, v141
		v_pk_fma_f32 v[140:141], v[254:255], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[222:223], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[176:177], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[226:227], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[182:183], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[228:229], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[184:185], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[232:233], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[108:109], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[234:235], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[110:111], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[236:237], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[114:115], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[238:239], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[186:187], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[240:241], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[194:195], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[242:243], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[128:129], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[244:245], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[160:161], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[246:247], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[248:249], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[142:143], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[252:253], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[156:157], v[138:139], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[96:97], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[158:159], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[178:179], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[98:99], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[80:81], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[80:81], v[82:83], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[82:83], v[84:85], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[84:85], v[86:87], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[86:87], v[88:89], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[88:89], v[90:91], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[90:91], v[92:93], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[92:93], v[94:95], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[94:95], v[112:113], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[116:117], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[120:121], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[188:189], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[124:125], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[192:193], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[118:119], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[134:135], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[138:139], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v138, v140
		v_exp_f32_e32 v162, v141
		v_exp_f32_e32 v139, v164
		v_exp_f32_e32 v163, v165
		v_exp_f32_e32 v140, v166
		v_exp_f32_e32 v164, v167
		v_exp_f32_e32 v141, v168
		v_exp_f32_e32 v165, v169
		v_exp_f32_e32 v166, v170
		v_exp_f32_e32 v168, v171
		v_exp_f32_e32 v167, v172
		v_exp_f32_e32 v169, v173
		v_exp_f32_e32 v170, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v171, v176
		v_exp_f32_e32 v173, v177
		v_exp_f32_e32 v174, v182
		v_exp_f32_e32 v176, v183
		v_exp_f32_e32 v175, v108
		v_exp_f32_e32 v177, v109
		v_exp_f32_e32 v108, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v109, v110
		v_exp_f32_e32 v183, v111
		v_exp_f32_e32 v110, v196
		v_exp_f32_e32 v184, v197
		v_exp_f32_e32 v111, v114
		v_exp_f32_e32 v185, v115
		v_exp_f32_e32 v114, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v115, v186
		v_exp_f32_e32 v197, v187
		v_exp_f32_e32 v186, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v187, v194
		v_exp_f32_e32 v199, v195
		v_exp_f32_e32 v194, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v195, v128
		v_exp_f32_e32 v201, v129
		v_exp_f32_e32 v128, v204
		v_exp_f32_e32 v202, v205
		v_exp_f32_e32 v129, v160
		v_exp_f32_e32 v203, v161
		v_exp_f32_e32 v160, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v161, v208
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
		v_exp_f32_e32 v149, v212
		v_exp_f32_e32 v151, v213
		v_exp_f32_e32 v153, v156
		v_exp_f32_e32 v213, v157
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
		v_exp_f32_e32 v95, v120
		v_exp_f32_e32 v113, v121
		v_exp_f32_e32 v116, v188
		v_exp_f32_e32 v120, v189
		v_exp_f32_e32 v117, v190
		v_exp_f32_e32 v121, v191
		v_exp_f32_e32 v188, v124
		v_exp_f32_e32 v190, v125
		v_exp_f32_e32 v189, v192
		v_exp_f32_e32 v191, v193
		v_exp_f32_e32 v124, v118
		v_exp_f32_e32 v192, v119
		v_exp_f32_e32 v125, v122
		v_exp_f32_e32 v193, v123
		v_exp_f32_e32 v118, v126
		v_exp_f32_e32 v122, v127
		v_exp_f32_e32 v119, v130
		v_exp_f32_e32 v123, v131
		v_exp_f32_e32 v126, v132
		v_exp_f32_e32 v130, v133
		v_exp_f32_e32 v127, v134
		v_exp_f32_e32 v131, v135
		v_exp_f32_e32 v132, v136
		v_exp_f32_e32 v134, v137
		v_pk_add_f32 v[136:137], v[138:139], v[162:163]
		v_pk_add_f32 v[216:217], v[140:141], v[164:165]
		v_pk_add_f32 v[218:219], v[166:167], v[168:169]
		v_pk_add_f32 v[220:221], v[170:171], v[172:173]
		v_pk_add_f32 v[222:223], v[174:175], v[176:177]
		v_pk_add_f32 v[224:225], v[108:109], v[182:183]
		v_pk_add_f32 v[226:227], v[110:111], v[184:185]
		v_pk_add_f32 v[228:229], v[114:115], v[196:197]
		v_pk_add_f32 v[230:231], v[186:187], v[198:199]
		v_pk_add_f32 v[232:233], v[194:195], v[200:201]
		v_pk_add_f32 v[234:235], v[128:129], v[202:203]
		v_pk_add_f32 v[236:237], v[160:161], v[204:205]
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
		ds_bpermute_b32 v152, v3, v10
		ds_bpermute_b32 v212, v4, v10
		v_pk_add_f32 v[136:137], v[156:157], v[214:215]
		v_pk_add_f32 v[216:217], v[96:97], v[158:159]
		v_pk_add_f32 v[218:219], v[178:179], v[180:181]
		v_pk_add_f32 v[220:221], v[98:99], v[100:101]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[222:223], v[152:153], v[212:213]
		v_pk_add_f32 v[224:225], v[102:103], v[104:105]
		v_pk_add_f32 v[226:227], v[80:81], v[106:107]
		v_pk_add_f32 v[228:229], v[82:83], v[84:85]
		v_pk_add_f32 v[230:231], v[86:87], v[88:89]
		v_pk_add_f32 v[232:233], v[90:91], v[92:93]
		v_pk_add_f32 v[234:235], v[94:95], v[112:113]
		v_pk_add_f32 v[236:237], v[116:117], v[120:121]
		v_pk_add_f32 v[238:239], v[188:189], v[190:191]
		v_pk_add_f32 v[240:241], v[124:125], v[192:193]
		v_pk_add_f32 v[242:243], v[118:119], v[122:123]
		v_pk_add_f32 v[244:245], v[126:127], v[130:131]
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
		ds_bpermute_b32 v13, v3, v10
		ds_bpermute_b32 v133, v4, v10
		v_sub_f32_e32 v7, v7, v154
		v_sub_f32_e32 v10, v11, v155
		v_exp_f32_e32 v136, v7
		v_exp_f32_e32 v216, v10
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v11, v13, v133
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
		v_mov_b32_e32 v217, v216
		v_pk_mul_f32 v[48:49], v[48:49], v[216:217]
		v_pk_mul_f32 v[50:51], v[50:51], v[216:217]
		v_pk_mul_f32 v[52:53], v[52:53], v[216:217]
		v_pk_mul_f32 v[54:55], v[54:55], v[216:217]
		v_pk_mul_f32 v[56:57], v[56:57], v[216:217]
		v_pk_mul_f32 v[58:59], v[58:59], v[216:217]
		v_pk_mul_f32 v[60:61], v[60:61], v[216:217]
		v_pk_mul_f32 v[62:63], v[62:63], v[216:217]
		v_pk_mul_f32 v[64:65], v[64:65], v[216:217]
		v_pk_mul_f32 v[66:67], v[66:67], v[216:217]
		v_pk_mul_f32 v[68:69], v[68:69], v[216:217]
		v_pk_mul_f32 v[70:71], v[70:71], v[216:217]
		v_pk_mul_f32 v[72:73], v[72:73], v[216:217]
		v_pk_mul_f32 v[74:75], v[74:75], v[216:217]
		v_pk_mul_f32 v[76:77], v[76:77], v[216:217]
		v_pk_mul_f32 v[78:79], v[78:79], v[216:217]
		v_mov_b32_e32 v10, v222
		v_mov_b32_e32 v218, v136
		v_mov_b32_e32 v219, v216
		v_mov_b64_e32 v[136:137], v[14:15]
		v_pk_fma_f32 v[14:15], v[136:137], v[218:219], v[10:11]
		v_cvt_pk_bf16_f32 v216, v138, v162
		v_cvt_pk_bf16_f32 v217, v139, v163
		v_cvt_pk_bf16_f32 v218, v140, v164
		v_cvt_pk_bf16_f32 v219, v141, v165
		v_cvt_pk_bf16_f32 v136, v166, v168
		v_cvt_pk_bf16_f32 v137, v167, v169
		v_cvt_pk_bf16_f32 v138, v170, v172
		v_cvt_pk_bf16_f32 v139, v171, v173
		v_cvt_pk_bf16_f32 v164, v174, v176
		v_cvt_pk_bf16_f32 v165, v175, v177
		v_cvt_pk_bf16_f32 v166, v108, v182
		v_cvt_pk_bf16_f32 v167, v109, v183
		v_cvt_pk_bf16_f32 v168, v110, v184
		v_cvt_pk_bf16_f32 v169, v111, v185
		v_cvt_pk_bf16_f32 v170, v114, v196
		v_cvt_pk_bf16_f32 v171, v115, v197
		v_cvt_pk_bf16_f32 v108, v186, v198
		v_cvt_pk_bf16_f32 v109, v187, v199
		v_cvt_pk_bf16_f32 v110, v194, v200
		v_cvt_pk_bf16_f32 v111, v195, v201
		v_cvt_pk_bf16_f32 v172, v128, v202
		v_cvt_pk_bf16_f32 v173, v129, v203
		v_cvt_pk_bf16_f32 v174, v160, v204
		v_cvt_pk_bf16_f32 v175, v161, v205
		v_cvt_pk_bf16_f32 v160, v206, v208
		v_cvt_pk_bf16_f32 v161, v207, v209
		v_cvt_pk_bf16_f32 v162, v142, v210
		v_cvt_pk_bf16_f32 v163, v143, v211
		v_cvt_pk_bf16_f32 v140, v144, v146
		v_cvt_pk_bf16_f32 v141, v145, v147
		v_cvt_pk_bf16_f32 v142, v148, v150
		v_cvt_pk_bf16_f32 v143, v149, v151
		v_cvt_pk_bf16_f32 v144, v153, v213
		v_cvt_pk_bf16_f32 v145, v156, v214
		v_cvt_pk_bf16_f32 v146, v157, v215
		v_cvt_pk_bf16_f32 v147, v96, v158
		v_cvt_pk_bf16_f32 v148, v97, v159
		v_cvt_pk_bf16_f32 v149, v178, v180
		v_cvt_pk_bf16_f32 v150, v179, v181
		v_cvt_pk_bf16_f32 v151, v98, v100
		v_cvt_pk_bf16_f32 v156, v99, v101
		v_cvt_pk_bf16_f32 v157, v102, v104
		v_cvt_pk_bf16_f32 v158, v103, v105
		v_cvt_pk_bf16_f32 v159, v80, v106
		v_cvt_pk_bf16_f32 v96, v81, v107
		v_cvt_pk_bf16_f32 v97, v82, v84
		v_cvt_pk_bf16_f32 v98, v83, v85
		v_cvt_pk_bf16_f32 v99, v86, v88
		v_cvt_pk_bf16_f32 v80, v87, v89
		v_cvt_pk_bf16_f32 v81, v90, v92
		v_cvt_pk_bf16_f32 v82, v91, v93
		v_cvt_pk_bf16_f32 v83, v94, v112
		v_cvt_pk_bf16_f32 v84, v95, v113
		v_cvt_pk_bf16_f32 v85, v116, v120
		v_cvt_pk_bf16_f32 v86, v117, v121
		v_cvt_pk_bf16_f32 v87, v188, v190
		v_cvt_pk_bf16_f32 v88, v189, v191
		v_cvt_pk_bf16_f32 v89, v124, v192
		v_cvt_pk_bf16_f32 v90, v125, v193
		v_cvt_pk_bf16_f32 v91, v118, v122
		v_cvt_pk_bf16_f32 v92, v119, v123
		v_cvt_pk_bf16_f32 v93, v126, v130
		v_cvt_pk_bf16_f32 v94, v127, v131
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
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_permlane32_swap_b32_e32 v156, v158
		v_permlane32_swap_b32_e32 v157, v159
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
		v_mfma_f32_32x32x16_bf16 v[16:31], a[188:191], v[216:219], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[216:219], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[192:195], v[136:139], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[224:227], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[224:227], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[192:195], v[148:151], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[196:199], v[164:167], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[228:231], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[228:231], v[156:159], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[196:199], v[156:159], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[200:203], v[168:171], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[232:235], v[168:171], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[232:235], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[200:203], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[204:207], v[108:111], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[236:239], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[236:239], v[80:83], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[204:207], v[80:83], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[208:211], v[172:175], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[240:243], v[172:175], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[240:243], v[84:87], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[208:211], v[84:87], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[212:215], v[160:163], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[244:247], v[160:163], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[244:247], v[88:91], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[212:215], v[88:91], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[216:219], v[140:143], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[248:251], v[140:143], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[248:251], v[92:95], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[92:95], v[48:63]
		s_mov_b32 s42, s1
		v_mov_b32_e32 v7, v154
		v_mov_b32_e32 v11, v155
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
		v_lshlrev_b32_e32 v4, 2, v9
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
		v_accvgpr_read_b32 v9, a58
		v_accvgpr_read_b32 v14, a59
		v_add3_u32 v9, s53, v9, v14
		v_accvgpr_read_b32 v14, a60
		v_accvgpr_read_b32 v15, a61
		v_add3_u32 v9, v9, v14, v15
		v_accvgpr_read_b32 v14, a62
		v_accvgpr_read_b32 v15, a63
		v_add3_u32 v9, v9, v14, v15
		ds_read_b128 v[24:27], v9
		ds_read_b128 a[72:75], v9 offset:32
		ds_read_b128 a[76:79], v9 offset:64
		ds_read_b128 a[80:83], v9 offset:96
		ds_read_b128 v[28:31], v9 offset:256
		ds_read_b128 a[84:87], v9 offset:288
		ds_read_b128 a[88:91], v9 offset:320
		ds_read_b128 a[92:95], v9 offset:352
		ds_read_b128 v[96:99], v9 offset:128
		ds_read_b128 a[96:99], v9 offset:160
		ds_read_b128 a[100:103], v9 offset:192
		ds_read_b128 a[104:107], v9 offset:224
		ds_read_b128 v[100:103], v9 offset:384
		ds_read_b128 a[108:111], v9 offset:416
		ds_read_b128 a[112:115], v9 offset:448
		ds_read_b128 a[116:119], v9 offset:480
		s_mul_i32 s52, 0x4400, s52
		v_accvgpr_read_b32 v9, a65
		v_accvgpr_read_b32 v14, a66
		v_add3_u32 v9, s52, v9, v14
		v_accvgpr_read_b32 v14, a67
		v_accvgpr_read_b32 v15, a68
		v_add3_u32 v9, v9, v14, v15
		ds_read_b64_tr_b16 a[120:121], v9 offset:33264
		ds_read_b64_tr_b16 a[122:123], v9 offset:37616
		ds_read_b64_tr_b16 a[124:125], v9 offset:33392
		ds_read_b64_tr_b16 a[126:127], v9 offset:37744
		ds_read_b64_tr_b16 a[128:129], v9 offset:33520
		ds_read_b64_tr_b16 a[130:131], v9 offset:37872
		ds_read_b64_tr_b16 a[132:133], v9 offset:33648
		ds_read_b64_tr_b16 a[134:135], v9 offset:38000
		ds_read_b64_tr_b16 a[136:137], v9 offset:33776
		ds_read_b64_tr_b16 a[138:139], v9 offset:38128
		ds_read_b64_tr_b16 a[140:141], v9 offset:33904
		ds_read_b64_tr_b16 a[142:143], v9 offset:38256
		ds_read_b64_tr_b16 a[144:145], v9 offset:34032
		ds_read_b64_tr_b16 a[146:147], v9 offset:38384
		ds_read_b64_tr_b16 a[148:149], v9 offset:34160
		ds_read_b64_tr_b16 a[150:151], v9 offset:38512
		ds_read_b64_tr_b16 a[152:153], v9 offset:33328
		ds_read_b64_tr_b16 a[154:155], v9 offset:37680
		ds_read_b64_tr_b16 a[156:157], v9 offset:33456
		ds_read_b64_tr_b16 a[158:159], v9 offset:37808
		ds_read_b64_tr_b16 a[160:161], v9 offset:33584
		ds_read_b64_tr_b16 a[162:163], v9 offset:37936
		ds_read_b64_tr_b16 a[164:165], v9 offset:33712
		ds_read_b64_tr_b16 a[166:167], v9 offset:38064
		ds_read_b64_tr_b16 a[168:169], v9 offset:33840
		ds_read_b64_tr_b16 a[170:171], v9 offset:38192
		ds_read_b64_tr_b16 a[172:173], v9 offset:33968
		ds_read_b64_tr_b16 a[174:175], v9 offset:38320
		ds_read_b64_tr_b16 a[176:177], v9 offset:34096
		ds_read_b64_tr_b16 a[178:179], v9 offset:38448
		ds_read_b64_tr_b16 a[180:181], v9 offset:34224
		ds_read_b64_tr_b16 a[182:183], v9 offset:38576
		s_mul_i32 s52, s15, s29
		s_lshl_b32 s52, s52, 1
		s_add_i32 s53, s45, s52
		v_add_u32_e32 v9, s53, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v14, s52, v5
		s_add_i32 s43, s43, 1
		v_add_u32_e32 v15, s46, v14
		s_and_b32 s43, s43, 1
		v_add_u32_e32 v16, s47, v14
		s_mul_i32 s52, 0x4100, s43
		v_add_u32_e32 v14, s48, v14
		s_add_i32 s52, s41, s52
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[24:27], 0
		s_mov_b32 m0, s52
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[24:27], 0
		s_mul_i32 s52, s17, s29
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], 0
		s_add_i32 s29, s29, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[24:27], 0
		v_accvgpr_read_b32 v22, a22
		v_add_u32_e32 v22, s29, v22
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[40:43], 0
		v_accvgpr_read_b32 v23, a23
		v_add_u32_e32 v23, s29, v23
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[40:43], 0
		v_accvgpr_read_b32 v24, a56
		v_add_u32_e32 v24, s29, v24
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[40:43], 0
		v_add_u32_e32 v25, s29, v2
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], a[40:43], 0
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_mov_b64 s[56:57], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[72:75], a[28:31], v[112:127]
		v_cmp_lt_i32_e64 vcc, v23, s21
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[84:87], a[28:31], v[128:143]
		v_cmp_lt_i32_e64 vcc, v24, s21
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[96:99], a[28:31], v[144:159]
		v_cmp_lt_i32_e64 vcc, v25, s21
		s_mov_b64 s[62:63], vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[108:111], a[28:31], v[160:175]
		v_add_u32_e32 v22, s29, v8
		v_mfma_f32_32x32x16_bf16 v[176:191], a[108:111], a[44:47], v[176:191]
		v_add_u32_e32 v23, s29, v11
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[44:47], v[192:207]
		v_add_u32_e32 v24, s29, v12
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[44:47], v[208:223]
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[44:47], v[224:239]
		v_cmp_lt_i32_e64 vcc, v23, s21
		s_mov_b64 s[66:67], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[32:35], v[112:127]
		v_cmp_lt_i32_e64 vcc, v24, s21
		s_mov_b64 s[68:69], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[32:35], v[128:143]
		v_cndmask_b32_e64 v9, v17, v9, s[56:57]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[32:35], v[144:159]
		v_add_u32_e32 v9, s29, v1
		v_cndmask_b32_e64 v15, v17, v15, s[58:59]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v16, v17, v16, s[60:61]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v14, v17, v14, s[62:63]
		v_cmp_lt_i32_e64 vcc, v9, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s52, s52, 1
		s_add_i32 s53, s49, s52
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		v_add_u32_e32 v9, s53, v7
		v_cndmask_b32_e64 v9, v17, v9, s[64:65]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s43, 0x4400, s43
		s_add_i32 s43, s40, s43
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_add_u32_e32 v14, s52, v7
		v_add_u32_e32 v15, s50, v14
		s_add_i32 m0, s43, 0x81f0
		v_cndmask_b32_e64 v15, v17, v15, s[66:67]
		v_add_u32_e32 v16, s51, v14
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v9, v17, v16, s[68:69]
		v_add_u32_e32 v14, s42, v14
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v14, v17, v14, vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[112:115], a[32:35], v[160:175]
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[112:115], a[48:51], v[176:191]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[48:51], v[224:239]
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[36:39], v[112:127]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s29, s44
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[52:55], v[192:207]
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[52:55], v[224:239]
		s_nop 1
		v_max3_f32 v9, v112, v113, v114
		v_max3_f32 v14, v116, v117, v118
		v_max3_f32 v15, v120, v121, v122
		v_max3_f32 v16, v124, v125, v126
		v_max3_f32 v22, v128, v129, v130
		v_max3_f32 v23, v132, v133, v134
		v_max3_f32 v24, v136, v137, v138
		v_max3_f32 v25, v140, v141, v142
		v_max3_f32 v26, v144, v145, v146
		v_max3_f32 v27, v148, v149, v150
		v_max3_f32 v28, v152, v153, v154
		v_max3_f32 v29, v156, v157, v158
		v_max3_f32 v30, v160, v161, v162
		v_max3_f32 v31, v164, v165, v166
		v_max3_f32 v96, v168, v169, v170
		v_max3_f32 v97, v172, v173, v174
		v_max3_f32 v9, v9, v115, v14
		v_max3_f32 v14, v15, v123, v16
		v_max3_f32 v15, v22, v131, v23
		v_max3_f32 v16, v24, v139, v25
		v_max3_f32 v22, v26, v147, v27
		v_max3_f32 v23, v28, v155, v29
		v_max3_f32 v24, v30, v163, v31
		v_max3_f32 v25, v96, v171, v97
		v_max3_f32 v9, v9, v119, v14
		v_max3_f32 v14, v15, v135, v16
		v_max3_f32 v15, v22, v151, v23
		v_max3_f32 v16, v24, v167, v25
		v_max3_f32 v9, v9, v127, v14
		v_max3_f32 v14, v15, v159, v16
		v_max3_f32 v9, v9, v143, v14
		v_max_f32_e32 v9, v9, v175
		ds_bpermute_b32 v14, v3, v9
		ds_bpermute_b32 v15, v4, v9
		v_max3_f32 v9, v192, v193, v194
		v_max3_f32 v16, v196, v197, v198
		v_max3_f32 v22, v200, v201, v202
		v_max3_f32 v23, v204, v205, v206
		v_max3_f32 v24, v208, v209, v210
		v_max3_f32 v25, v212, v213, v214
		v_max3_f32 v26, v216, v217, v218
		v_max3_f32 v27, v220, v221, v222
		v_max3_f32 v28, v224, v225, v226
		v_max3_f32 v29, v228, v229, v230
		v_max3_f32 v30, v232, v233, v234
		v_max3_f32 v31, v236, v237, v238
		v_max3_f32 v96, v176, v177, v178
		v_max3_f32 v97, v180, v181, v182
		v_max3_f32 v98, v184, v185, v186
		v_max3_f32 v99, v188, v189, v190
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v100, v14, v15
		v_max3_f32 v9, v9, v195, v16
		v_max3_f32 v14, v22, v203, v23
		v_max3_f32 v15, v24, v211, v25
		v_max3_f32 v16, v26, v219, v27
		v_max3_f32 v22, v28, v227, v29
		v_max3_f32 v23, v30, v235, v31
		v_max3_f32 v24, v96, v179, v97
		v_max3_f32 v25, v98, v187, v99
		v_max3_f32 v9, v9, v199, v14
		v_max3_f32 v14, v15, v215, v16
		v_max3_f32 v15, v22, v231, v23
		v_max3_f32 v16, v24, v183, v25
		v_max3_f32 v9, v9, v207, v14
		v_max3_f32 v14, v15, v239, v16
		v_max3_f32 v9, v9, v223, v14
		v_max_f32_e32 v9, v9, v191
		ds_bpermute_b32 v14, v3, v9
		ds_bpermute_b32 v15, v4, v9
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v101, v14, v15
		v_pk_mul_f32 v[14:15], v[100:101], v[18:19]
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
		v_add_f32_e32 v9, v188, v189
		ds_bpermute_b32 v146, v3, v9
		ds_bpermute_b32 v148, v4, v9
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
		v_add_f32_e32 v9, v229, v224
		v_add_f32_e32 v9, v225, v9
		ds_bpermute_b32 v16, v3, v9
		ds_bpermute_b32 v146, v4, v9
		v_sub_f32_e32 v9, v10, v22
		v_sub_f32_e32 v10, v13, v23
		v_exp_f32_e32 v188, v9
		v_exp_f32_e32 v222, v10
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
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v225, v16, v146
		v_pk_mul_f32 v[56:57], v[56:57], v[188:189]
		v_pk_mul_f32 v[58:59], v[58:59], v[188:189]
		v_pk_mul_f32 v[60:61], v[60:61], v[188:189]
		v_pk_mul_f32 v[62:63], v[62:63], v[188:189]
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
		v_mov_b32_e32 v224, v220
		v_mov_b32_e32 v220, v188
		v_mov_b32_e32 v221, v222
		v_mov_b64_e32 v[188:189], v[20:21]
		v_pk_fma_f32 v[20:21], v[188:189], v[220:221], v[224:225]
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
		v_accvgpr_read_b32 v9, a5
		s_nop 0
		v_readfirstlane_b32 s29, v9
		v_accvgpr_read_b32 v9, a13
		s_nop 0
		v_add_u32_e32 v9, s29, v9
		v_add_u32_e32 v9, s19, v9
		v_accvgpr_read_b32 v14, a5
		s_nop 0
		v_readfirstlane_b32 s29, v14
		v_accvgpr_read_b32 v14, a14
		s_nop 0
		v_add_u32_e32 v14, s29, v14
		v_add_u32_e32 v14, s19, v14
		v_xor_b32_e32 v15, 1, v6
		v_accvgpr_write_b32 a13, v15
		v_xor_b32_e32 v15, 2, v6
		v_accvgpr_write_b32 a14, v15
		v_xor_b32_e32 v15, 3, v6
		v_accvgpr_write_b32 a58, v15
		v_xor_b32_e32 v15, 8, v6
		v_accvgpr_write_b32 a65, v15
		v_xor_b32_e32 v15, 9, v6
		v_accvgpr_write_b32 a69, v15
		v_xor_b32_e32 v15, 10, v6
		v_accvgpr_write_b32 a70, v15
		v_xor_b32_e32 v15, 11, v6
		v_accvgpr_write_b32 a71, v15
		v_xor_b32_e32 v15, 16, v6
		v_accvgpr_write_b32 a72, v15
		v_xor_b32_e32 v15, 17, v6
		v_accvgpr_write_b32 a73, v15
		v_xor_b32_e32 v15, 18, v6
		v_accvgpr_write_b32 a74, v15
		v_xor_b32_e32 v15, 19, v6
		v_accvgpr_write_b32 a75, v15
		v_xor_b32_e32 v15, 24, v6
		v_accvgpr_write_b32 a76, v15
		v_xor_b32_e32 v15, 25, v6
		v_accvgpr_write_b32 a77, v15
		v_xor_b32_e32 v15, 26, v6
		v_accvgpr_write_b32 a78, v15
		v_xor_b32_e32 v15, 27, v6
		v_accvgpr_write_b32 a79, v15
		v_xor_b32_e32 v15, 32, v6
		v_accvgpr_write_b32 a80, v15
		v_xor_b32_e32 v15, 33, v6
		v_accvgpr_write_b32 a81, v15
		v_xor_b32_e32 v15, 34, v6
		v_accvgpr_write_b32 a82, v15
		v_xor_b32_e32 v15, 35, v6
		v_accvgpr_write_b32 a83, v15
		v_xor_b32_e32 v15, 40, v6
		v_accvgpr_write_b32 a84, v15
		v_xor_b32_e32 v15, 41, v6
		v_accvgpr_write_b32 a85, v15
		v_xor_b32_e32 v15, 42, v6
		v_accvgpr_write_b32 a86, v15
		v_xor_b32_e32 v15, 43, v6
		v_accvgpr_write_b32 a87, v15
		v_xor_b32_e32 v15, 48, v6
		v_accvgpr_write_b32 a88, v15
		v_xor_b32_e32 v15, 49, v6
		v_accvgpr_write_b32 a89, v15
		v_xor_b32_e32 v15, 50, v6
		v_accvgpr_write_b32 a90, v15
		v_xor_b32_e32 v15, 51, v6
		v_accvgpr_write_b32 a91, v15
		v_xor_b32_e32 v15, 56, v6
		v_accvgpr_write_b32 a92, v15
		v_xor_b32_e32 v15, 57, v6
		v_accvgpr_write_b32 a93, v15
		v_xor_b32_e32 v15, 58, v6
		v_accvgpr_write_b32 a94, v15
		v_xor_b32_e32 v15, 59, v6
		v_accvgpr_write_b32 a95, v15
		v_xor_b32_e32 v15, 64, v6
		v_accvgpr_write_b32 a96, v15
		v_xor_b32_e32 v15, 0x41, v6
		v_accvgpr_write_b32 a97, v15
		v_xor_b32_e32 v15, 0x42, v6
		v_accvgpr_write_b32 a98, v15
		v_xor_b32_e32 v15, 0x43, v6
		v_accvgpr_write_b32 a99, v15
		v_xor_b32_e32 v15, 0x48, v6
		v_accvgpr_write_b32 a100, v15
		v_xor_b32_e32 v15, 0x49, v6
		v_accvgpr_write_b32 a101, v15
		v_xor_b32_e32 v15, 0x4a, v6
		v_accvgpr_write_b32 a102, v15
		v_xor_b32_e32 v15, 0x4b, v6
		v_accvgpr_write_b32 a103, v15
		v_xor_b32_e32 v15, 0x50, v6
		v_accvgpr_write_b32 a104, v15
		v_xor_b32_e32 v15, 0x51, v6
		v_accvgpr_write_b32 a105, v15
		v_xor_b32_e32 v15, 0x52, v6
		v_accvgpr_write_b32 a106, v15
		v_xor_b32_e32 v15, 0x53, v6
		v_accvgpr_write_b32 a107, v15
		v_xor_b32_e32 v15, 0x58, v6
		v_accvgpr_write_b32 a108, v15
		v_xor_b32_e32 v15, 0x59, v6
		v_accvgpr_write_b32 a109, v15
		v_xor_b32_e32 v15, 0x5a, v6
		v_accvgpr_write_b32 a110, v15
		v_xor_b32_e32 v15, 0x5b, v6
		v_accvgpr_write_b32 a111, v15
		v_xor_b32_e32 v15, 0x60, v6
		v_accvgpr_write_b32 a112, v15
		v_xor_b32_e32 v15, 0x61, v6
		v_accvgpr_write_b32 a113, v15
		v_xor_b32_e32 v15, 0x62, v6
		v_accvgpr_write_b32 a114, v15
		v_xor_b32_e32 v15, 0x63, v6
		v_accvgpr_write_b32 a115, v15
		v_xor_b32_e32 v15, 0x68, v6
		v_accvgpr_write_b32 a116, v15
		v_xor_b32_e32 v15, 0x69, v6
		v_accvgpr_write_b32 a117, v15
		v_xor_b32_e32 v15, 0x6a, v6
		v_accvgpr_write_b32 a118, v15
		v_xor_b32_e32 v15, 0x6b, v6
		v_accvgpr_write_b32 a119, v15
		v_xor_b32_e32 v15, 0x70, v6
		v_accvgpr_write_b32 a120, v15
		v_xor_b32_e32 v15, 0x71, v6
		v_accvgpr_write_b32 a121, v15
		v_xor_b32_e32 v15, 0x72, v6
		v_accvgpr_write_b32 a122, v15
		v_xor_b32_e32 v15, 0x73, v6
		v_accvgpr_write_b32 a123, v15
		v_xor_b32_e32 v15, 0x78, v6
		v_accvgpr_write_b32 a124, v15
		v_xor_b32_e32 v15, 0x79, v6
		v_accvgpr_write_b32 a125, v15
		v_xor_b32_e32 v15, 0x7a, v6
		v_accvgpr_write_b32 a126, v15
		v_xor_b32_e32 v15, 0x7b, v6
		v_accvgpr_write_b32 a127, v15
		v_accvgpr_read_b32 v15, a21
		v_accvgpr_read_b32 v16, a59
		v_lshl_add_u32 v15, v15, 4, v16
		v_accvgpr_read_b32 v16, a60
		v_accvgpr_read_b32 v22, a61
		v_add3_u32 v15, v15, v16, v22
		v_accvgpr_read_b32 v16, a62
		v_accvgpr_read_b32 v22, a63
		v_add3_u32 v15, v15, v16, v22
		v_accvgpr_write_b32 a21, v15
		v_accvgpr_read_b32 v15, a64
		v_accvgpr_read_b32 v16, a66
		v_lshl_add_u32 v15, v15, 3, v16
		v_accvgpr_read_b32 v16, a67
		v_accvgpr_read_b32 v22, a68
		v_add3_u32 v15, v15, v16, v22
		v_accvgpr_write_b32 a59, v15
		v_mov_b32_e32 v15, 0xff800000
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
		v_accvgpr_read_b32 v16, a21
		v_add_u32_e32 v16, s29, v16
		ds_read_b128 a[60:63], v16
		ds_read_b128 a[128:131], v16 offset:32
		ds_read_b128 a[132:135], v16 offset:64
		ds_read_b128 a[136:139], v16 offset:96
		ds_read_b128 a[140:143], v16 offset:256
		ds_read_b128 a[144:147], v16 offset:288
		ds_read_b128 a[148:151], v16 offset:320
		ds_read_b128 a[152:155], v16 offset:352
		ds_read_b128 a[156:159], v16 offset:128
		ds_read_b128 a[160:163], v16 offset:160
		ds_read_b128 a[164:167], v16 offset:192
		ds_read_b128 a[168:171], v16 offset:224
		ds_read_b128 a[172:175], v16 offset:384
		ds_read_b128 a[176:179], v16 offset:416
		ds_read_b128 a[180:183], v16 offset:448
		ds_read_b128 a[184:187], v16 offset:480
		s_mul_i32 s29, 0x4400, s40
		v_accvgpr_read_b32 v16, a59
		v_add_u32_e32 v16, s29, v16
		ds_read_b64_tr_b16 a[188:189], v16 offset:33264
		ds_read_b64_tr_b16 a[190:191], v16 offset:37616
		ds_read_b64_tr_b16 a[192:193], v16 offset:33392
		ds_read_b64_tr_b16 a[194:195], v16 offset:37744
		ds_read_b64_tr_b16 a[196:197], v16 offset:33520
		ds_read_b64_tr_b16 a[198:199], v16 offset:37872
		ds_read_b64_tr_b16 a[200:201], v16 offset:33648
		ds_read_b64_tr_b16 a[202:203], v16 offset:38000
		ds_read_b64_tr_b16 a[204:205], v16 offset:33776
		ds_read_b64_tr_b16 a[206:207], v16 offset:38128
		ds_read_b64_tr_b16 a[208:209], v16 offset:33904
		ds_read_b64_tr_b16 a[210:211], v16 offset:38256
		ds_read_b64_tr_b16 a[212:213], v16 offset:34032
		ds_read_b64_tr_b16 a[214:215], v16 offset:38384
		ds_read_b64_tr_b16 a[216:217], v16 offset:34160
		ds_read_b64_tr_b16 a[218:219], v16 offset:38512
		ds_read_b64_tr_b16 a[220:221], v16 offset:33328
		ds_read_b64_tr_b16 a[222:223], v16 offset:37680
		ds_read_b64_tr_b16 a[224:225], v16 offset:33456
		ds_read_b64_tr_b16 a[226:227], v16 offset:37808
		ds_read_b64_tr_b16 a[228:229], v16 offset:33584
		ds_read_b64_tr_b16 a[230:231], v16 offset:37936
		ds_read_b64_tr_b16 a[232:233], v16 offset:33712
		ds_read_b64_tr_b16 a[234:235], v16 offset:38064
		ds_read_b64_tr_b16 a[236:237], v16 offset:33840
		ds_read_b64_tr_b16 a[238:239], v16 offset:38192
		ds_read_b64_tr_b16 a[240:241], v16 offset:33968
		ds_read_b64_tr_b16 a[242:243], v16 offset:38320
		ds_read_b64_tr_b16 a[244:245], v16 offset:34096
		ds_read_b64_tr_b16 a[246:247], v16 offset:38448
		ds_read_b64_tr_b16 a[248:249], v16 offset:34224
		ds_read_b64_tr_b16 a[250:251], v16 offset:38576
		s_cmp_lt_i32 s19, s26
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v16, a22
		v_add_u32_e32 v16, s19, v16
		v_accvgpr_read_b32 v22, a23
		v_add_u32_e32 v22, s19, v22
		v_accvgpr_read_b32 v23, a56
		v_add_u32_e32 v23, s19, v23
		v_add_u32_e32 v24, s19, v2
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v23, s21
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v24, s21
		s_mov_b64 s[60:61], vcc
		v_add_u32_e32 v16, s19, v8
		v_add_u32_e32 v22, s19, v11
		v_add_u32_e32 v23, s19, v12
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v23, s21
		s_mov_b64 s[66:67], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s29, s15, s44
		s_lshl_b32 s29, s29, 1
		s_add_i32 s43, s45, s29
		v_add_u32_e32 v16, s43, v5
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
		v_cndmask_b32_e64 v16, v17, v16, s[40:41]
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		v_add_u32_e32 v16, s19, v1
		s_add_i32 s40, s46, s29
		v_add_u32_e32 v22, s40, v5
		s_add_u32 s40, s72, 0x1040
		s_addc_u32 s41, s73, 0
		s_add_u32 s40, s40, s74
		s_addc_u32 s41, s41, s75
		s_add_u32 s70, s40, 0
		s_addc_u32 s71, s41, 0
		s_mov_b32 m0, s70
		v_cndmask_b32_e64 v22, v17, v22, s[56:57]
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		s_add_i32 s40, s47, s29
		v_add_u32_e32 v22, s40, v5
		s_add_u32 s40, s72, 0x2080
		s_addc_u32 s41, s73, 0
		s_add_u32 s40, s40, s74
		s_addc_u32 s41, s41, s75
		s_add_u32 s56, s40, 0
		s_addc_u32 s57, s41, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v22, v17, v22, s[58:59]
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		s_add_i32 s29, s48, s29
		v_add_u32_e32 v22, s29, v5
		s_add_u32 s40, s72, 0x30c0
		s_addc_u32 s41, s73, 0
		s_add_u32 s40, s40, s74
		s_addc_u32 s41, s41, s75
		s_add_u32 s56, s40, 0
		s_addc_u32 s57, s41, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v22, v17, v22, s[60:61]
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		s_mul_i32 s29, s17, s44
		s_lshl_b32 s29, s29, 1
		s_add_i32 s40, s49, s29
		v_add_u32_e32 v22, s40, v7
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
		v_cndmask_b32_e64 v22, v17, v22, s[62:63]
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		s_add_i32 s40, s50, s29
		v_add_u32_e32 v22, s40, v7
		s_add_u32 s40, s56, 0x92f0
		s_addc_u32 s41, s57, 0
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v22, v17, v22, s[64:65]
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		s_add_i32 s40, s51, s29
		v_add_u32_e32 v22, s40, v7
		s_add_u32 s40, s56, 0xa3f0
		s_addc_u32 s41, s57, 0
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v22, v17, v22, s[66:67]
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		s_add_i32 s29, s42, s29
		v_cmp_lt_i32_e64 vcc, v16, s21
		v_add_u32_e32 v16, s29, v7
		s_add_u32 s40, s56, 0xb4f0
		s_addc_u32 s41, s57, 0
		v_cndmask_b32_e32 v16, v17, v16, vcc
		s_add_u32 s40, s40, s60
		s_addc_u32 s41, s41, s61
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[60:63], a[24:27], 0
		v_add_u32_e32 v16, s44, v6
		v_accvgpr_read_b32 v22, a13
		v_add_u32_e32 v22, s44, v22
		v_accvgpr_read_b32 v23, a14
		v_add_u32_e32 v23, s44, v23
		v_accvgpr_read_b32 v24, a58
		v_add_u32_e32 v24, s44, v24
		v_accvgpr_read_b32 v25, a70
		v_add_u32_e32 v25, s44, v25
		v_accvgpr_read_b32 v26, a71
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_read_b32 v27, a74
		v_add_u32_e32 v27, s44, v27
		v_mfma_f32_32x32x16_bf16 v[112:127], a[140:143], a[24:27], 0
		v_accvgpr_read_b32 v28, a75
		v_add_u32_e32 v28, s44, v28
		v_accvgpr_read_b32 v29, a78
		v_add_u32_e32 v29, s44, v29
		v_accvgpr_read_b32 v30, a79
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_read_b32 v31, a82
		v_add_u32_e32 v31, s44, v31
		v_accvgpr_read_b32 v128, a83
		v_add_u32_e32 v128, s44, v128
		v_accvgpr_read_b32 v129, a86
		v_add_u32_e32 v129, s44, v129
		v_accvgpr_read_b32 v130, a87
		v_add_u32_e32 v130, s44, v130
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], a[24:27], 0
		v_accvgpr_read_b32 v131, a90
		v_add_u32_e32 v131, s44, v131
		v_accvgpr_read_b32 v132, a91
		v_add_u32_e32 v132, s44, v132
		v_accvgpr_read_b32 v133, a94
		v_add_u32_e32 v133, s44, v133
		v_accvgpr_read_b32 v134, a95
		v_add_u32_e32 v134, s44, v134
		v_accvgpr_read_b32 v135, a98
		v_add_u32_e32 v135, s44, v135
		v_accvgpr_read_b32 v136, a99
		v_add_u32_e32 v136, s44, v136
		v_accvgpr_read_b32 v137, a102
		v_add_u32_e32 v137, s44, v137
		v_mfma_f32_32x32x16_bf16 v[160:175], a[172:175], a[24:27], 0
		v_accvgpr_read_b32 v138, a103
		v_add_u32_e32 v138, s44, v138
		v_accvgpr_read_b32 v139, a106
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a64, v139
		v_accvgpr_read_b32 v139, a107
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a66, v139
		v_accvgpr_read_b32 v139, a110
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a67, v139
		v_accvgpr_read_b32 v139, a111
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a68, v139
		v_accvgpr_read_b32 v139, a114
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a252, v139
		v_accvgpr_read_b32 v139, a115
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a253, v139
		v_mfma_f32_32x32x16_bf16 v[176:191], a[172:175], a[40:43], 0
		v_accvgpr_read_b32 v139, a118
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a172, v139
		v_accvgpr_read_b32 v139, a119
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a173, v139
		v_accvgpr_read_b32 v139, a122
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a174, v139
		v_accvgpr_read_b32 v139, a123
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a175, v139
		v_accvgpr_read_b32 v139, a126
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a254, v139
		v_accvgpr_read_b32 v139, a127
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_write_b32 a255, v139
		v_cmp_ge_i32_e64 vcc, v9, v16
		s_mov_b64 s[40:41], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], a[60:63], a[40:43], 0
		v_cmp_ge_i32_e64 vcc, v9, v22
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v9, v23
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v9, v24
		v_accvgpr_read_b32 v139, a65
		v_add_u32_e32 v139, s44, v139
		v_accvgpr_read_b32 v140, a69
		v_add_u32_e32 v140, s44, v140
		v_accvgpr_read_b32 v141, a72
		v_add_u32_e32 v141, s44, v141
		v_accvgpr_read_b32 v142, a73
		v_add_u32_e32 v142, s44, v142
		v_mfma_f32_32x32x16_bf16 v[208:223], a[140:143], a[40:43], 0
		v_accvgpr_read_b32 v143, a76
		v_add_u32_e32 v143, s44, v143
		v_accvgpr_read_b32 v224, a77
		v_add_u32_e32 v224, s44, v224
		v_accvgpr_read_b32 v225, a80
		v_add_u32_e32 v225, s44, v225
		v_accvgpr_read_b32 v226, a81
		v_add_u32_e32 v226, s44, v226
		v_accvgpr_read_b32 v227, a84
		v_add_u32_e32 v227, s44, v227
		v_accvgpr_read_b32 v228, a85
		v_add_u32_e32 v228, s44, v228
		v_accvgpr_read_b32 v229, a88
		v_add_u32_e32 v229, s44, v229
		v_mfma_f32_32x32x16_bf16 v[240:255], a[156:159], a[40:43], 0
		v_accvgpr_read_b32 v230, a89
		v_add_u32_e32 v230, s44, v230
		v_accvgpr_read_b32 v231, a92
		v_add_u32_e32 v231, s44, v231
		v_accvgpr_read_b32 v232, a93
		v_add_u32_e32 v232, s44, v232
		v_accvgpr_read_b32 v233, a96
		v_add_u32_e32 v233, s44, v233
		v_accvgpr_read_b32 v234, a97
		v_add_u32_e32 v234, s44, v234
		v_accvgpr_read_b32 v235, a100
		v_add_u32_e32 v235, s44, v235
		v_accvgpr_read_b32 v236, a101
		v_add_u32_e32 v236, s44, v236
		v_mfma_f32_32x32x16_bf16 v[96:111], a[128:131], a[28:31], v[96:111]
		v_accvgpr_read_b32 v237, a104
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a60, v237
		v_accvgpr_read_b32 v237, a105
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a61, v237
		v_accvgpr_read_b32 v237, a108
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a62, v237
		v_accvgpr_read_b32 v237, a109
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a63, v237
		v_accvgpr_read_b32 v237, a112
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a140, v237
		v_accvgpr_read_b32 v237, a113
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a141, v237
		v_accvgpr_read_b32 v237, a116
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a142, v237
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[28:31], v[112:127]
		v_accvgpr_read_b32 v237, a117
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a143, v237
		v_accvgpr_read_b32 v237, a120
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a156, v237
		v_accvgpr_read_b32 v237, a121
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a157, v237
		v_accvgpr_read_b32 v237, a124
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a158, v237
		v_accvgpr_read_b32 v237, a125
		v_add_u32_e32 v237, s44, v237
		v_accvgpr_write_b32 a159, v237
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[176:179], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[128:131], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[144:147], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[160:163], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[132:135], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[148:151], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[164:167], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[184:187], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[136:139], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[152:155], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[168:171], a[52:55], v[240:255]
		s_cmp_lt_i32 s19, s28
		s_nop 3
		v_cndmask_b32_e32 v99, v15, v99, vcc
		v_accvgpr_write_b32 a129, v99
		v_cmp_ge_i32_e64 vcc, v9, v139
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v9, v140
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v9, v25
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v9, v26
		v_cndmask_b32_e64 v96, v15, v96, s[40:41]
		v_accvgpr_write_b32 a130, v96
		v_cndmask_b32_e64 v96, v15, v97, s[52:53]
		v_accvgpr_write_b32 a131, v96
		v_cndmask_b32_e32 v97, v15, v103, vcc
		v_cmp_ge_i32_e64 vcc, v9, v141
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v9, v142
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v9, v27
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v9, v28
		v_cndmask_b32_e64 v96, v15, v98, s[56:57]
		v_accvgpr_write_b32 a128, v96
		v_cndmask_b32_e64 v98, v15, v100, s[58:59]
		v_cndmask_b32_e32 v96, v15, v107, vcc
		v_accvgpr_write_b32 a133, v96
		v_cmp_ge_i32_e64 vcc, v9, v143
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v9, v224
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v9, v29
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v9, v30
		v_cndmask_b32_e64 v99, v15, v101, s[60:61]
		v_cndmask_b32_e64 v96, v15, v102, s[62:63]
		v_cndmask_b32_e32 v101, v15, v111, vcc
		v_cmp_ge_i32_e64 vcc, v9, v225
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v9, v226
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v9, v31
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v9, v128
		v_cndmask_b32_e64 v102, v15, v104, s[40:41]
		v_cndmask_b32_e64 v103, v15, v105, s[52:53]
		v_cndmask_b32_e32 v100, v15, v115, vcc
		v_accvgpr_write_b32 a135, v100
		v_cmp_ge_i32_e64 vcc, v9, v227
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v9, v228
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v9, v129
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v9, v130
		v_cndmask_b32_e64 v100, v15, v106, s[64:65]
		v_accvgpr_write_b32 a132, v100
		v_cndmask_b32_e64 v104, v15, v108, s[56:57]
		v_cndmask_b32_e32 v100, v15, v119, vcc
		v_accvgpr_write_b32 a137, v100
		v_cmp_ge_i32_e64 vcc, v9, v229
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v9, v230
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v9, v131
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v9, v132
		v_cndmask_b32_e64 v105, v15, v109, s[58:59]
		v_cndmask_b32_e64 v100, v15, v110, s[66:67]
		v_cndmask_b32_e32 v107, v15, v123, vcc
		v_cmp_ge_i32_e64 vcc, v9, v231
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v9, v232
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v9, v133
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v9, v134
		v_cndmask_b32_e64 v108, v15, v112, s[60:61]
		v_cndmask_b32_e64 v109, v15, v113, s[62:63]
		v_cndmask_b32_e32 v111, v15, v127, vcc
		v_cmp_ge_i32_e64 vcc, v9, v233
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v9, v234
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v9, v135
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v9, v136
		v_cndmask_b32_e64 v106, v15, v114, s[68:69]
		v_accvgpr_write_b32 a134, v106
		v_cndmask_b32_e64 v112, v15, v116, s[40:41]
		v_cndmask_b32_e32 v115, v15, v147, vcc
		v_cmp_ge_i32_e64 vcc, v9, v235
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v9, v236
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v9, v137
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v9, v138
		v_cndmask_b32_e64 v113, v15, v117, s[52:53]
		v_cndmask_b32_e64 v106, v15, v118, s[70:71]
		v_accvgpr_write_b32 a136, v106
		v_cndmask_b32_e32 v117, v15, v151, vcc
		v_accvgpr_read_b32 v106, a60
		v_cmp_ge_i32_e64 vcc, v9, v106
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v106, a61
		v_cmp_ge_i32_e64 vcc, v9, v106
		s_mov_b64 s[70:71], vcc
		v_accvgpr_read_b32 v106, a64
		v_cmp_ge_i32_e64 vcc, v9, v106
		s_mov_b64 s[80:81], vcc
		v_accvgpr_read_b32 v106, a66
		v_cmp_ge_i32_e64 vcc, v9, v106
		v_cndmask_b32_e64 v106, v15, v120, s[56:57]
		v_accvgpr_write_b32 a138, v106
		v_cndmask_b32_e64 v106, v15, v121, s[64:65]
		v_accvgpr_write_b32 a139, v106
		v_cndmask_b32_e32 v119, v15, v155, vcc
		v_accvgpr_read_b32 v106, a62
		v_cmp_ge_i32_e64 vcc, v9, v106
		s_mov_b64 s[56:57], vcc
		v_accvgpr_read_b32 v106, a63
		v_cmp_ge_i32_e64 vcc, v9, v106
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v106, a67
		v_cmp_ge_i32_e64 vcc, v9, v106
		s_mov_b64 s[82:83], vcc
		v_cndmask_b32_e64 v121, v15, v157, s[64:65]
		v_cndmask_b32_e64 v238, v15, v158, s[82:83]
		v_accvgpr_read_b32 v106, a68
		v_cmp_ge_i32_e64 vcc, v9, v106
		v_cndmask_b32_e64 v106, v15, v122, s[72:73]
		v_cndmask_b32_e64 v122, v15, v124, s[58:59]
		v_cndmask_b32_e32 v239, v15, v159, vcc
		v_accvgpr_read_b32 v110, a140
		v_cmp_ge_i32_e64 vcc, v9, v110
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v110, a141
		v_cmp_ge_i32_e64 vcc, v9, v110
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v110, a252
		v_cmp_ge_i32_e64 vcc, v9, v110
		s_mov_b64 s[72:73], vcc
		v_cndmask_b32_e64 v158, v15, v160, s[58:59]
		v_cndmask_b32_e64 v159, v15, v161, s[64:65]
		v_cndmask_b32_e64 v160, v15, v162, s[72:73]
		v_accvgpr_read_b32 v110, a253
		v_cmp_ge_i32_e64 vcc, v9, v110
		v_cndmask_b32_e64 v123, v15, v125, s[66:67]
		v_cndmask_b32_e64 v110, v15, v126, s[74:75]
		v_cndmask_b32_e32 v161, v15, v163, vcc
		v_accvgpr_read_b32 v114, a142
		v_cmp_ge_i32_e64 vcc, v9, v114
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v114, a143
		v_cmp_ge_i32_e64 vcc, v9, v114
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v114, a172
		v_cmp_ge_i32_e64 vcc, v9, v114
		s_mov_b64 s[66:67], vcc
		v_cndmask_b32_e64 v124, v15, v164, s[58:59]
		v_cndmask_b32_e64 v125, v15, v165, s[64:65]
		v_cndmask_b32_e64 v126, v15, v166, s[66:67]
		v_accvgpr_read_b32 v114, a173
		v_cmp_ge_i32_e64 vcc, v9, v114
		v_cndmask_b32_e64 v162, v15, v144, s[60:61]
		v_cndmask_b32_e64 v163, v15, v145, s[62:63]
		v_cndmask_b32_e32 v127, v15, v167, vcc
		v_accvgpr_read_b32 v114, a156
		v_cmp_ge_i32_e64 vcc, v9, v114
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v114, a157
		v_cmp_ge_i32_e64 vcc, v9, v114
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v114, a174
		v_cmp_ge_i32_e64 vcc, v9, v114
		s_mov_b64 s[62:63], vcc
		v_cndmask_b32_e64 v144, v15, v168, s[58:59]
		v_cndmask_b32_e64 v145, v15, v169, s[60:61]
		v_cndmask_b32_e64 v164, v15, v170, s[62:63]
		v_accvgpr_read_b32 v114, a175
		v_cmp_ge_i32_e64 vcc, v9, v114
		v_cndmask_b32_e64 v114, v15, v146, s[76:77]
		v_cndmask_b32_e64 v146, v15, v148, s[40:41]
		v_cndmask_b32_e32 v165, v15, v171, vcc
		v_accvgpr_read_b32 v116, a158
		v_cmp_ge_i32_e64 vcc, v9, v116
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v116, a159
		v_cmp_ge_i32_e64 vcc, v9, v116
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v116, a254
		v_cmp_ge_i32_e64 vcc, v9, v116
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v166, v15, v172, s[40:41]
		v_cndmask_b32_e64 v167, v15, v173, s[58:59]
		v_cndmask_b32_e64 v168, v15, v174, s[60:61]
		v_accvgpr_read_b32 v116, a255
		v_cmp_ge_i32_e64 vcc, v9, v116
		v_cndmask_b32_e64 v147, v15, v149, s[68:69]
		v_cndmask_b32_e64 v116, v15, v150, s[78:79]
		v_cndmask_b32_e32 v169, v15, v175, vcc
		v_cmp_ge_i32_e64 vcc, v14, v16
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v22
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v14, v23
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v22, v15, v192, s[40:41]
		v_cndmask_b32_e64 v23, v15, v193, s[58:59]
		v_cndmask_b32_e64 v148, v15, v194, s[60:61]
		v_cmp_ge_i32_e64 vcc, v14, v24
		v_cndmask_b32_e64 v150, v15, v152, s[52:53]
		v_cndmask_b32_e64 v151, v15, v153, s[70:71]
		v_cndmask_b32_e32 v149, v15, v195, vcc
		v_cmp_ge_i32_e64 vcc, v14, v139
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v140
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v25
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v24, v15, v196, s[40:41]
		v_cndmask_b32_e64 v25, v15, v197, s[52:53]
		v_cndmask_b32_e64 v152, v15, v198, s[58:59]
		v_cmp_ge_i32_e64 vcc, v14, v26
		v_cndmask_b32_e64 v118, v15, v154, s[80:81]
		v_cndmask_b32_e64 v120, v15, v156, s[56:57]
		v_cndmask_b32_e32 v153, v15, v199, vcc
		v_cmp_ge_i32_e64 vcc, v14, v141
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v142
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v27
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v26, v15, v200, s[40:41]
		v_cndmask_b32_e64 v27, v15, v201, s[52:53]
		v_cndmask_b32_e64 v140, v15, v202, s[56:57]
		v_cmp_ge_i32_e64 vcc, v14, v28
		v_accvgpr_read_b32 v16, a128
		v_accvgpr_read_b32 v28, a130
		v_accvgpr_read_b32 v139, a131
		v_max3_f32 v16, v28, v139, v16
		v_max3_f32 v28, v98, v99, v96
		v_cndmask_b32_e32 v141, v15, v203, vcc
		v_cmp_ge_i32_e64 vcc, v14, v143
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v224
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v29
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v142, v15, v204, s[40:41]
		v_cndmask_b32_e64 v143, v15, v205, s[52:53]
		v_cndmask_b32_e64 v154, v15, v206, s[56:57]
		v_cmp_ge_i32_e64 vcc, v14, v30
		v_accvgpr_read_b32 v29, a132
		v_max3_f32 v29, v102, v103, v29
		v_max3_f32 v30, v104, v105, v100
		v_cndmask_b32_e32 v155, v15, v207, vcc
		v_cmp_ge_i32_e64 vcc, v14, v225
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v226
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v31
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v156, v15, v208, s[40:41]
		v_cndmask_b32_e64 v157, v15, v209, s[52:53]
		v_cndmask_b32_e64 v170, v15, v210, s[56:57]
		v_cmp_ge_i32_e64 vcc, v14, v128
		v_accvgpr_read_b32 v31, a134
		v_max3_f32 v31, v108, v109, v31
		v_accvgpr_read_b32 v128, a136
		v_max3_f32 v128, v112, v113, v128
		v_cndmask_b32_e32 v171, v15, v211, vcc
		v_cmp_ge_i32_e64 vcc, v14, v227
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v228
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v129
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v172, v15, v212, s[40:41]
		v_cndmask_b32_e64 v173, v15, v213, s[52:53]
		v_cndmask_b32_e64 v174, v15, v214, s[56:57]
		v_cmp_ge_i32_e64 vcc, v14, v130
		v_accvgpr_read_b32 v129, a138
		v_accvgpr_read_b32 v130, a139
		v_max3_f32 v129, v129, v130, v106
		v_max3_f32 v130, v122, v123, v110
		v_cndmask_b32_e32 v175, v15, v215, vcc
		v_cmp_ge_i32_e64 vcc, v14, v229
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v230
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v131
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v192, v15, v216, s[40:41]
		v_cndmask_b32_e64 v193, v15, v217, s[52:53]
		v_cndmask_b32_e64 v194, v15, v218, s[56:57]
		v_cmp_ge_i32_e64 vcc, v14, v132
		v_max3_f32 v131, v162, v163, v114
		v_max3_f32 v132, v146, v147, v116
		v_cndmask_b32_e32 v195, v15, v219, vcc
		v_cmp_ge_i32_e64 vcc, v14, v231
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v232
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v133
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v196, v15, v220, s[40:41]
		v_cndmask_b32_e64 v197, v15, v221, s[52:53]
		v_cndmask_b32_e64 v198, v15, v222, s[56:57]
		v_cmp_ge_i32_e64 vcc, v14, v134
		v_max3_f32 v133, v150, v151, v118
		v_max3_f32 v134, v120, v121, v238
		v_cndmask_b32_e32 v199, v15, v223, vcc
		v_cmp_ge_i32_e64 vcc, v14, v233
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v234
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v135
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v200, v15, v240, s[40:41]
		v_cndmask_b32_e64 v201, v15, v241, s[52:53]
		v_cndmask_b32_e64 v202, v15, v242, s[56:57]
		v_cmp_ge_i32_e64 vcc, v14, v136
		v_max3_f32 v135, v158, v159, v160
		v_max3_f32 v136, v124, v125, v126
		v_cndmask_b32_e32 v203, v15, v243, vcc
		v_cmp_ge_i32_e64 vcc, v14, v235
		s_mov_b64 s[40:41], vcc
		v_cmp_ge_i32_e64 vcc, v14, v236
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v14, v137
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v204, v15, v244, s[40:41]
		v_cndmask_b32_e64 v205, v15, v245, s[52:53]
		v_cndmask_b32_e64 v206, v15, v246, s[56:57]
		v_cmp_ge_i32_e64 vcc, v14, v138
		v_max3_f32 v137, v144, v145, v164
		v_max3_f32 v138, v166, v167, v168
		v_cndmask_b32_e32 v207, v15, v247, vcc
		v_accvgpr_read_b32 v139, a60
		v_cmp_ge_i32_e64 vcc, v14, v139
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v139, a61
		v_cmp_ge_i32_e64 vcc, v14, v139
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v139, a64
		v_cmp_ge_i32_e64 vcc, v14, v139
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v208, v15, v248, s[40:41]
		v_cndmask_b32_e64 v209, v15, v249, s[52:53]
		v_cndmask_b32_e64 v210, v15, v250, s[56:57]
		v_accvgpr_read_b32 v139, a66
		v_cmp_ge_i32_e64 vcc, v14, v139
		v_accvgpr_read_b32 v139, a129
		v_max3_f32 v16, v16, v139, v28
		v_accvgpr_read_b32 v28, a133
		v_max3_f32 v28, v29, v28, v30
		v_cndmask_b32_e32 v211, v15, v251, vcc
		v_accvgpr_read_b32 v29, a62
		v_cmp_ge_i32_e64 vcc, v14, v29
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v29, a63
		v_cmp_ge_i32_e64 vcc, v14, v29
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v29, a67
		v_cmp_ge_i32_e64 vcc, v14, v29
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v212, v15, v252, s[40:41]
		v_cndmask_b32_e64 v213, v15, v253, s[52:53]
		v_cndmask_b32_e64 v214, v15, v254, s[56:57]
		v_accvgpr_read_b32 v29, a68
		v_cmp_ge_i32_e64 vcc, v14, v29
		v_accvgpr_read_b32 v29, a135
		v_max3_f32 v29, v31, v29, v128
		v_max3_f32 v30, v129, v107, v130
		v_cndmask_b32_e32 v215, v15, v255, vcc
		v_accvgpr_read_b32 v31, a140
		v_cmp_ge_i32_e64 vcc, v14, v31
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v31, a141
		v_cmp_ge_i32_e64 vcc, v14, v31
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v31, a252
		v_cmp_ge_i32_e64 vcc, v14, v31
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v128, v15, v176, s[40:41]
		v_cndmask_b32_e64 v129, v15, v177, s[52:53]
		v_cndmask_b32_e64 v176, v15, v178, s[56:57]
		v_accvgpr_read_b32 v31, a253
		v_cmp_ge_i32_e64 vcc, v14, v31
		v_max3_f32 v31, v131, v115, v132
		v_max3_f32 v130, v133, v119, v134
		v_cndmask_b32_e32 v177, v15, v179, vcc
		v_accvgpr_read_b32 v131, a142
		v_cmp_ge_i32_e64 vcc, v14, v131
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v131, a143
		v_cmp_ge_i32_e64 vcc, v14, v131
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v131, a172
		v_cmp_ge_i32_e64 vcc, v14, v131
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v132, v15, v180, s[40:41]
		v_cndmask_b32_e64 v133, v15, v181, s[52:53]
		v_cndmask_b32_e64 v178, v15, v182, s[56:57]
		v_accvgpr_read_b32 v131, a173
		v_cmp_ge_i32_e64 vcc, v14, v131
		v_max3_f32 v131, v135, v161, v136
		v_max3_f32 v134, v137, v165, v138
		v_cndmask_b32_e32 v179, v15, v183, vcc
		v_accvgpr_read_b32 v135, a156
		v_cmp_ge_i32_e64 vcc, v14, v135
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v135, a157
		v_cmp_ge_i32_e64 vcc, v14, v135
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v135, a174
		v_cmp_ge_i32_e64 vcc, v14, v135
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v136, v15, v184, s[40:41]
		v_cndmask_b32_e64 v137, v15, v185, s[52:53]
		v_cndmask_b32_e64 v138, v15, v186, s[56:57]
		v_accvgpr_read_b32 v135, a175
		v_cmp_ge_i32_e64 vcc, v14, v135
		v_max3_f32 v16, v16, v97, v28
		v_accvgpr_read_b32 v28, a137
		v_max3_f32 v28, v29, v28, v30
		v_cndmask_b32_e32 v139, v15, v187, vcc
		v_accvgpr_read_b32 v29, a158
		v_cmp_ge_i32_e64 vcc, v14, v29
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v29, a159
		v_cmp_ge_i32_e64 vcc, v14, v29
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v29, a254
		v_cmp_ge_i32_e64 vcc, v14, v29
		s_mov_b64 s[56:57], vcc
		v_cndmask_b32_e64 v180, v15, v188, s[40:41]
		v_cndmask_b32_e64 v181, v15, v189, s[52:53]
		v_cndmask_b32_e64 v182, v15, v190, s[56:57]
		v_accvgpr_read_b32 v29, a255
		v_cmp_ge_i32_e64 vcc, v14, v29
		v_max3_f32 v29, v31, v117, v130
		v_max3_f32 v30, v131, v127, v134
		v_cndmask_b32_e32 v183, v15, v191, vcc
		v_max3_f32 v16, v16, v101, v28
		v_max3_f32 v28, v29, v239, v30
		v_max3_f32 v16, v16, v111, v28
		v_max_f32_e32 v16, v16, v169
		ds_bpermute_b32 v28, v3, v16
		ds_bpermute_b32 v29, v4, v16
		v_max3_f32 v16, v22, v23, v148
		v_max3_f32 v30, v24, v25, v152
		v_max3_f32 v31, v26, v27, v140
		v_max3_f32 v130, v142, v143, v154
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v134, v28, v29
		v_max3_f32 v28, v156, v157, v170
		v_max3_f32 v29, v172, v173, v174
		v_max3_f32 v131, v192, v193, v194
		v_max3_f32 v135, v196, v197, v198
		v_max3_f32 v184, v200, v201, v202
		v_max3_f32 v185, v204, v205, v206
		v_max3_f32 v186, v208, v209, v210
		v_max3_f32 v187, v212, v213, v214
		v_max3_f32 v188, v128, v129, v176
		v_max3_f32 v189, v132, v133, v178
		v_max3_f32 v190, v136, v137, v138
		v_max3_f32 v191, v180, v181, v182
		v_max3_f32 v16, v16, v149, v30
		v_max3_f32 v30, v31, v141, v130
		v_max3_f32 v28, v28, v171, v29
		v_max3_f32 v29, v131, v195, v135
		v_max3_f32 v31, v184, v203, v185
		v_max3_f32 v130, v186, v211, v187
		v_max3_f32 v131, v188, v177, v189
		v_max3_f32 v135, v190, v139, v191
		v_max3_f32 v16, v16, v153, v30
		v_max3_f32 v28, v28, v175, v29
		v_max3_f32 v29, v31, v207, v130
		v_max3_f32 v30, v131, v179, v135
		v_max3_f32 v16, v16, v155, v28
		v_max3_f32 v28, v29, v215, v30
		v_max3_f32 v16, v16, v199, v28
		v_max_f32_e32 v16, v16, v183
		ds_bpermute_b32 v28, v3, v16
		ds_bpermute_b32 v29, v4, v16
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v135, v28, v29
		v_pk_mul_f32 v[28:29], v[134:135], v[18:19]
		v_max_f32_e32 v30, v10, v28
		v_max_f32_e32 v31, v13, v29
		v_accvgpr_read_b32 v28, a130
		v_accvgpr_read_b32 v29, a131
		v_pk_fma_f32 v[130:131], v[28:29], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v28, a128
		v_accvgpr_read_b32 v29, a129
		v_pk_fma_f32 v[134:135], v[28:29], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[98:99], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[96:97], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[102:103], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v102, a132
		v_accvgpr_read_b32 v103, a133
		v_pk_fma_f32 v[184:185], v[102:103], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[100:101], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[108:109], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v108, a134
		v_accvgpr_read_b32 v109, a135
		v_pk_fma_f32 v[186:187], v[108:109], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[112:113], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v112, a136
		v_accvgpr_read_b32 v113, a137
		v_pk_fma_f32 v[188:189], v[112:113], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v112, a138
		v_accvgpr_read_b32 v113, a139
		v_pk_fma_f32 v[190:191], v[112:113], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[106:107], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[122:123], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[110:111], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[162:163], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[114:115], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[146:147], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[116:117], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[150:151], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[118:119], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[238:239], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[158:159], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[124:125], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[144:145], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[164:165], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[18:19], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[22:23], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[148:149], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[24:25], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[152:153], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[26:27], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[140:141], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[142:143], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[154:155], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[170:171], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[192:193], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[206:207], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[208:209], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[210:211], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[212:213], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[214:215], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[128:129], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[176:177], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[132:133], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[178:179], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[136:137], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[138:139], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[180:181], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[18:19], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v182, v130
		v_exp_f32_e32 v218, v131
		v_exp_f32_e32 v183, v134
		v_exp_f32_e32 v219, v135
		v_exp_f32_e32 v130, v28
		v_exp_f32_e32 v134, v29
		v_exp_f32_e32 v131, v98
		v_exp_f32_e32 v135, v99
		v_exp_f32_e32 v28, v96
		v_exp_f32_e32 v98, v97
		v_exp_f32_e32 v29, v184
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
		v_exp_f32_e32 v118, v216
		v_exp_f32_e32 v120, v217
		v_exp_f32_e32 v119, v158
		v_exp_f32_e32 v121, v159
		v_exp_f32_e32 v158, v160
		v_exp_f32_e32 v216, v161
		v_exp_f32_e32 v159, v124
		v_exp_f32_e32 v217, v125
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
		v_exp_f32_e32 v168, v22
		v_exp_f32_e32 v220, v23
		v_exp_f32_e32 v169, v148
		v_exp_f32_e32 v221, v149
		v_exp_f32_e32 v22, v24
		v_exp_f32_e32 v148, v25
		v_exp_f32_e32 v23, v152
		v_exp_f32_e32 v149, v153
		v_exp_f32_e32 v24, v26
		v_exp_f32_e32 v152, v27
		v_exp_f32_e32 v25, v140
		v_exp_f32_e32 v153, v141
		v_exp_f32_e32 v26, v142
		v_exp_f32_e32 v140, v143
		v_exp_f32_e32 v27, v154
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
		v_exp_f32_e32 v208, v212
		v_exp_f32_e32 v210, v213
		v_exp_f32_e32 v209, v214
		v_exp_f32_e32 v211, v215
		v_exp_f32_e32 v212, v128
		v_exp_f32_e32 v214, v129
		v_exp_f32_e32 v213, v176
		v_exp_f32_e32 v215, v177
		v_exp_f32_e32 v128, v132
		v_exp_f32_e32 v176, v133
		v_exp_f32_e32 v129, v178
		v_exp_f32_e32 v177, v179
		v_exp_f32_e32 v132, v136
		v_exp_f32_e32 v178, v137
		v_exp_f32_e32 v133, v138
		v_exp_f32_e32 v179, v139
		v_exp_f32_e32 v136, v180
		v_exp_f32_e32 v138, v181
		v_pk_add_f32 v[180:181], v[182:183], v[218:219]
		v_pk_add_f32 v[222:223], v[130:131], v[134:135]
		v_pk_add_f32 v[224:225], v[28:29], v[98:99]
		v_pk_add_f32 v[226:227], v[96:97], v[184:185]
		v_pk_add_f32 v[228:229], v[102:103], v[104:105]
		v_pk_add_f32 v[230:231], v[100:101], v[186:187]
		v_pk_add_f32 v[232:233], v[108:109], v[188:189]
		v_pk_add_f32 v[234:235], v[112:113], v[190:191]
		v_pk_add_f32 v[236:237], v[106:107], v[122:123]
		v_pk_add_f32 v[238:239], v[110:111], v[162:163]
		v_pk_add_f32 v[240:241], v[114:115], v[146:147]
		v_pk_add_f32 v[242:243], v[116:117], v[150:151]
		v_pk_add_f32 v[244:245], v[118:119], v[120:121]
		v_pk_add_f32 v[246:247], v[158:159], v[216:217]
		v_pk_add_f32 v[248:249], v[124:125], v[160:161]
		v_pk_add_f32 v[250:251], v[126:127], v[144:145]
		v_mov_b32_e32 v252, v181
		v_mov_b32_e32 v253, v223
		v_mov_b32_e32 v254, v180
		v_mov_b32_e32 v255, v222
		v_pk_add_f32 v[180:181], v[254:255], v[252:253]
		v_mov_b32_e32 v222, v225
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v252, v224
		v_mov_b32_e32 v253, v226
		v_pk_add_f32 v[224:225], v[252:253], v[222:223]
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
		v_mov_b32_e32 v222, v237
		v_mov_b32_e32 v223, v239
		v_mov_b32_e32 v226, v236
		v_mov_b32_e32 v227, v238
		v_pk_add_f32 v[232:233], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v241
		v_mov_b32_e32 v223, v243
		v_mov_b32_e32 v226, v240
		v_mov_b32_e32 v227, v242
		v_pk_add_f32 v[234:235], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v245
		v_mov_b32_e32 v223, v247
		v_mov_b32_e32 v226, v244
		v_mov_b32_e32 v227, v246
		v_pk_add_f32 v[236:237], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v249
		v_mov_b32_e32 v223, v251
		v_mov_b32_e32 v226, v248
		v_mov_b32_e32 v227, v250
		v_pk_add_f32 v[238:239], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v181
		v_mov_b32_e32 v223, v225
		v_mov_b32_e32 v226, v180
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[180:181], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v233
		v_mov_b32_e32 v223, v235
		v_mov_b32_e32 v224, v232
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[228:229], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v237
		v_mov_b32_e32 v223, v239
		v_mov_b32_e32 v224, v236
		v_mov_b32_e32 v225, v238
		v_pk_add_f32 v[230:231], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v181
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v180
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[180:181], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v181
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v180
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[180:181], v[224:225], v[222:223]
		v_add_f32_e32 v16, v180, v181
		ds_bpermute_b32 v164, v3, v16
		ds_bpermute_b32 v166, v4, v16
		v_pk_add_f32 v[180:181], v[168:169], v[220:221]
		v_pk_add_f32 v[222:223], v[22:23], v[148:149]
		v_pk_add_f32 v[224:225], v[24:25], v[152:153]
		v_pk_add_f32 v[226:227], v[26:27], v[140:141]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[228:229], v[164:165], v[166:167]
		v_pk_add_f32 v[230:231], v[142:143], v[154:155]
		v_pk_add_f32 v[232:233], v[156:157], v[170:171]
		v_pk_add_f32 v[234:235], v[172:173], v[174:175]
		v_pk_add_f32 v[236:237], v[192:193], v[194:195]
		v_pk_add_f32 v[238:239], v[196:197], v[198:199]
		v_pk_add_f32 v[240:241], v[200:201], v[202:203]
		v_pk_add_f32 v[242:243], v[204:205], v[206:207]
		v_pk_add_f32 v[244:245], v[208:209], v[210:211]
		v_pk_add_f32 v[246:247], v[212:213], v[214:215]
		v_pk_add_f32 v[248:249], v[128:129], v[176:177]
		v_pk_add_f32 v[250:251], v[132:133], v[178:179]
		v_mov_b32_e32 v137, v229
		v_mov_b32_e32 v139, v180
		v_pk_add_f32 v[252:253], v[136:137], v[138:139]
		v_mov_b32_e32 v254, v181
		v_mov_b32_e32 v255, v224
		v_pk_add_f32 v[180:181], v[254:255], v[222:223]
		v_mov_b32_e32 v222, v225
		v_mov_b32_e32 v223, v230
		v_pk_add_f32 v[222:223], v[222:223], v[226:227]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[226:227], v[224:225], v[232:233]
		v_mov_b32_e32 v224, v235
		v_mov_b32_e32 v225, v238
		v_pk_add_f32 v[224:225], v[224:225], v[236:237]
		v_mov_b32_e32 v230, v239
		v_mov_b32_e32 v231, v242
		v_pk_add_f32 v[232:233], v[230:231], v[240:241]
		v_mov_b32_e32 v230, v243
		v_mov_b32_e32 v231, v246
		v_pk_add_f32 v[230:231], v[230:231], v[244:245]
		v_mov_b32_e32 v234, v247
		v_mov_b32_e32 v235, v250
		v_pk_add_f32 v[236:237], v[234:235], v[248:249]
		v_mov_b32_e32 v234, v251
		v_mov_b32_e32 v235, v180
		v_pk_add_f32 v[234:235], v[234:235], v[252:253]
		v_mov_b32_e32 v238, v181
		v_mov_b32_e32 v239, v226
		v_pk_add_f32 v[180:181], v[238:239], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[222:223], v[222:223], v[224:225]
		v_mov_b32_e32 v224, v233
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[226:227], v[224:225], v[230:231]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v180
		v_pk_add_f32 v[224:225], v[224:225], v[234:235]
		v_mov_b32_e32 v230, v181
		v_mov_b32_e32 v231, v226
		v_pk_add_f32 v[180:181], v[230:231], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v180
		v_pk_add_f32 v[226:227], v[222:223], v[224:225]
		v_add_f32_e32 v16, v181, v226
		v_add_f32_e32 v16, v227, v16
		ds_bpermute_b32 v137, v3, v16
		ds_bpermute_b32 v139, v4, v16
		v_sub_f32_e32 v10, v10, v30
		v_sub_f32_e32 v13, v13, v31
		v_exp_f32_e32 v180, v10
		v_exp_f32_e32 v222, v13
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v225, v137, v139
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
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v226, v180
		v_mov_b32_e32 v227, v222
		v_mov_b64_e32 v[180:181], v[20:21]
		v_pk_fma_f32 v[20:21], v[180:181], v[226:227], v[224:225]
		v_cvt_pk_bf16_f32 v224, v182, v218
		v_cvt_pk_bf16_f32 v225, v183, v219
		v_cvt_pk_bf16_f32 v226, v130, v134
		v_cvt_pk_bf16_f32 v227, v131, v135
		v_cvt_pk_bf16_f32 v180, v28, v98
		v_cvt_pk_bf16_f32 v181, v29, v99
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
		v_cvt_pk_bf16_f32 v110, v158, v216
		v_cvt_pk_bf16_f32 v111, v159, v217
		v_cvt_pk_bf16_f32 v112, v124, v160
		v_cvt_pk_bf16_f32 v113, v125, v161
		v_cvt_pk_bf16_f32 v114, v126, v144
		v_cvt_pk_bf16_f32 v115, v127, v145
		v_cvt_pk_bf16_f32 v116, v165, v167
		v_cvt_pk_bf16_f32 v117, v168, v220
		v_cvt_pk_bf16_f32 v118, v169, v221
		v_cvt_pk_bf16_f32 v119, v22, v148
		v_cvt_pk_bf16_f32 v120, v23, v149
		v_cvt_pk_bf16_f32 v121, v24, v152
		v_cvt_pk_bf16_f32 v122, v25, v153
		v_cvt_pk_bf16_f32 v123, v26, v140
		v_cvt_pk_bf16_f32 v124, v27, v141
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
		v_cvt_pk_bf16_f32 v149, v212, v214
		v_cvt_pk_bf16_f32 v150, v213, v215
		v_cvt_pk_bf16_f32 v151, v128, v176
		v_cvt_pk_bf16_f32 v152, v129, v177
		v_cvt_pk_bf16_f32 v153, v132, v178
		v_cvt_pk_bf16_f32 v154, v133, v179
		v_cvt_pk_bf16_f32 v155, v136, v138
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[224:227], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[96:99], v[32:47]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[96:99], v[48:63]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[100:103], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[100:103], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[152:155], v[64:79]
		s_mov_b32 s44, s19
		v_mov_b32_e32 v10, v30
		v_mov_b32_e32 v13, v31
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
    wave.regalloc.iterations: 421
    wave.regalloc.agpr.dwords: 840
    wave.regalloc.remat.dwords: 7
    wave.regalloc.sgpr_to_vgpr.dwords: 56
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
