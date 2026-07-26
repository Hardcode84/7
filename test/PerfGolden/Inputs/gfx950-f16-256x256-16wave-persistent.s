	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	gfx950_persistent_f16_gemm
	.p2align	8
	.type	gfx950_persistent_f16_gemm,@function
gfx950_persistent_f16_gemm:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dword s8, s[0:1], 0x18
		s_waitcnt lgkmcnt(0)
		s_branch .Lgfx950_persistent_f16_gemm.kernarg_preload_entry
	.p2align	8
.Lgfx950_persistent_f16_gemm.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		v_and_b32_e32 v1, 63, v0
		s_mov_b32 s1, 0
		v_cmp_eq_u32_e64 s[12:13], v1, s1
		v_mov_b32_e32 v4, 0
		v_mov_b32_e32 v1, 0x10000
		v_cmp_eq_u32_e64 vcc, v0, s1
		s_and_saveexec_b64 s[24:25], vcc
		s_cbranch_execz .Lgfx950_persistent_f16_gemm.exec_else_0
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		ds_write_b128 v1, v[4:7] offset:32768
		v_mov_b64_e32 v[2:3], 0
		ds_write_b64 v1, v[2:3] offset:32784
.Lgfx950_persistent_f16_gemm.exec_else_0:
		s_andn2_b64 exec, s[24:25], vcc
		s_cbranch_execz .Lgfx950_persistent_f16_gemm.exec_endif_0
.Lgfx950_persistent_f16_gemm.exec_endif_0:
		s_mov_b64 exec, s[24:25]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_ge_u32 s0, 12
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_0
		s_mov_b32 s6, 0x8000000
		s_mov_b32 s7, 0x31016000
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s18, s6
		s_mov_b32 s19, s7
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, s6
		s_mov_b32 s23, s7
		s_add_i32 s6, s0, -12
		s_add_i32 s7, s8, 1
		s_lshl_b32 s8, 1, s6
		s_cmp_eq_u32 s6, 0
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v0, 2, v1
		v_lshrrev_b32_e32 v2, 3, v1
		v_bitop3_b32 v1, v2, 3, v1 bitop3:0x48
		v_lshlrev_b32_e32 v1, 4, v1
		v_lshl_add_u32 v0, v0, 14, v1
		s_cselect_b32 s6, 1, 0
		s_lshl_b32 s11, s0, 18
		s_lshr_b32 s14, s9, 3
		s_lshl_b32 s14, s14, 22
		s_add_i32 s14, s11, s14
		s_and_b32 s15, s9, 7
		s_lshl_b32 s9, s15, 24
		s_add_i32 s9, s14, s9
		v_add_u32_e32 v1, s9, v0
		v_add_u32_e32 v2, 0xffd00000, v1
		s_lshl_b32 s9, s10, 22
		s_add_i32 s9, s9, s11
		v_add_u32_e32 v3, s9, v0
		v_add_u32_e32 v0, 0xffd00000, v3
		v_add_u32_e32 v4, 0xffe00000, v1
		v_add_u32_e32 v5, 0xffe00000, v3
		v_add_u32_e32 v6, 0xfff00000, v1
		v_add_u32_e32 v7, 0xfff00000, v3
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_lshl_b32 s0, s0, 10
		s_mov_b32 s2, s1
.Lgfx950_persistent_f16_gemm.loop_head_0:
		s_cmp_ge_u32 s2, 3
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_1
		s_add_i32 s3, s2, -3
		s_lshl_b32 s3, s3, 12
		s_add_i32 s3, s3, 0xfff
		s_mul_hi_u32 s4, s2, 0xaaaaaaab
		s_lshr_b32 s4, s4, 1
		s_mul_i32 s4, s4, 3
		s_xor_b32 s4, s4, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s4, s2, s4
		s_lshl_b32 s4, s4, 2
		s_add_i32 s4, s4, 0x10000
		v_mov_b32_e32 v8, s4
		s_mov_b32 s4, 1
		s_mov_b32 s5, 0
		s_and_saveexec_b64 s[10:11], s[4:5]
		ds_read_b32 v9, v8 offset:32780
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v9
		s_cmp_lg_u32 s4, s3
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_2
.Lgfx950_persistent_f16_gemm.loop_head_1:
		ds_read_b32 v9, v8 offset:32780
		s_sleep 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v9
		s_cmp_lg_u32 s4, s3
		s_cbranch_scc1 .Lgfx950_persistent_f16_gemm.loop_head_1
.Lgfx950_persistent_f16_gemm.loop_exit_1:
		s_branch .Lgfx950_persistent_f16_gemm.if_end_2
.Lgfx950_persistent_f16_gemm.if_else_2:
.Lgfx950_persistent_f16_gemm.if_end_2:
		s_mov_b64 exec, s[10:11]
		s_branch .Lgfx950_persistent_f16_gemm.if_end_1
.Lgfx950_persistent_f16_gemm.if_else_1:
.Lgfx950_persistent_f16_gemm.if_end_1:
		s_mul_hi_u32 s3, s2, 0xaaaaaaab
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s3, s2, s3
		s_lshl_b32 s4, s3, 15
		s_add_i32 s4, s0, s4
		s_add_i32 m0, s4, 0xffffd000
		s_lshl_b32 s3, s3, 2
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_lshl_b32 s5, s2, 4
		s_add_i32 m0, m0, 0x4000
		s_nop 0
		buffer_load_dwordx4 v0, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xffffd000
		s_nop 0
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xffffd000
		s_nop 0
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_nop 0
		s_mov_b32 m0, s4
		s_nop 0
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		s_add_i32 s3, s3, 0x10000
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s4, s5, 15
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_getreg_b32 s9, hwreg(HW_REG_IB_STS)
		s_and_b32 s10, s9, 15
		s_lshr_b32 s9, s9, 18
		s_and_b32 s9, s9, 48
		s_or_b32 s9, s10, s9
		s_cmp_lg_u32 s9, 0
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_3
.Lgfx950_persistent_f16_gemm.loop_head_2:
		s_sleep 1
		s_getreg_b32 s9, hwreg(HW_REG_IB_STS)
		s_and_b32 s10, s9, 15
		s_lshr_b32 s9, s9, 18
		s_and_b32 s9, s9, 48
		s_or_b32 s9, s10, s9
		s_cmp_lg_u32 s9, 0
		s_cbranch_scc1 .Lgfx950_persistent_f16_gemm.loop_head_2
.Lgfx950_persistent_f16_gemm.loop_exit_2:
		s_branch .Lgfx950_persistent_f16_gemm.if_end_3
.Lgfx950_persistent_f16_gemm.if_else_3:
.Lgfx950_persistent_f16_gemm.if_end_3:
		s_cmp_lg_u32 s6, 0
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_4
		s_cmp_lt_u32 s2, 3
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_5
		s_mov_b32 s9, s5
		s_branch .Lgfx950_persistent_f16_gemm.if_end_5
.Lgfx950_persistent_f16_gemm.if_else_5:
		s_mov_b32 s9, 33
.Lgfx950_persistent_f16_gemm.if_end_5:
		s_branch .Lgfx950_persistent_f16_gemm.if_end_4
.Lgfx950_persistent_f16_gemm.if_else_4:
		s_mov_b32 s9, s1
.Lgfx950_persistent_f16_gemm.if_end_4:
		s_add_i32 s5, s8, s9
		v_mov_b32_e32 v8, s5
		v_mov_b32_e32 v9, s3
		s_and_saveexec_b64 s[24:25], s[12:13]
		s_cbranch_execz .Lgfx950_persistent_f16_gemm.exec_else_1
		ds_add_rtn_u32 v10, v9, v8 offset:32768
.Lgfx950_persistent_f16_gemm.exec_else_1:
		s_andn2_b64 exec, s[24:25], s[12:13]
		s_cbranch_execz .Lgfx950_persistent_f16_gemm.exec_endif_1
		v_mov_b32_e32 v10, 0
.Lgfx950_persistent_f16_gemm.exec_endif_1:
		s_mov_b64 exec, s[24:25]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s3, v10
		s_add_i32 s3, s3, s5
		s_cmp_eq_u32 s3, s4
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_6
		s_wakeup
		s_branch .Lgfx950_persistent_f16_gemm.if_end_6
.Lgfx950_persistent_f16_gemm.if_else_6:
.Lgfx950_persistent_f16_gemm.if_end_6:
		s_add_u32 s16, s16, 64
		s_addc_u32 s17, s17, 0
		s_add_u32 s20, s20, 64
		s_addc_u32 s21, s21, 0
		s_add_i32 s2, s2, 1
		s_cmp_lt_i32 s2, s7
		s_cbranch_scc1 .Lgfx950_persistent_f16_gemm.loop_head_0
.Lgfx950_persistent_f16_gemm.loop_exit_0:
		s_branch .Lgfx950_persistent_f16_gemm.if_end_0
.Lgfx950_persistent_f16_gemm.if_else_0:
		s_mul_hi_u32 s2, s0, 0xaaaaaaab
		s_lshr_b32 s2, s2, 1
		s_mul_i32 s3, s2, 3
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s3, s0, s3
		s_cmp_eq_u32 s3, 2
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_7
		s_add_i32 s3, s8, 1
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_lshl_b32 s4, 1, s0
		s_cmp_eq_u32 s0, 0
		s_mov_b32 s14, 1
		s_mov_b32 s15, 0
		s_cselect_b32 s0, 1, 0
		s_lshl_b32 s5, s2, 12
		v_and_b32_e32 v1, 63, v0
		v_and_b32_e32 v0, 15, v1
		v_lshlrev_b32_e32 v2, 6, v0
		v_lshrrev_b32_e32 v1, 4, v1
		v_lshrrev_b32_e32 v3, 1, v0
		v_bitop3_b32 v3, v1, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v3, 4, v3
		s_mov_b32 s8, s1
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
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
.Lgfx950_persistent_f16_gemm.loop_head_3:
		s_lshl_b32 s11, s8, 4
		s_add_i32 s11, s11, 15
		s_mul_hi_u32 s16, s8, 0xaaaaaaab
		s_lshr_b32 s16, s16, 1
		s_mul_i32 s16, s16, 3
		s_xor_b32 s16, s16, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s16, s8, s16
		s_lshl_b32 s17, s16, 2
		s_add_i32 s17, s17, 0x10000
		v_mov_b32_e32 v100, s17
		ds_read_b32 v101, v100 offset:32768
		s_and_saveexec_b64 s[18:19], s[14:15]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s17, v101
		s_cmp_lg_u32 s17, s11
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_8
.Lgfx950_persistent_f16_gemm.loop_head_4:
		ds_read_b32 v101, v100 offset:32768
		s_sleep 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s17, v101
		s_cmp_lg_u32 s17, s11
		s_cbranch_scc1 .Lgfx950_persistent_f16_gemm.loop_head_4
.Lgfx950_persistent_f16_gemm.loop_exit_4:
		s_branch .Lgfx950_persistent_f16_gemm.if_end_8
.Lgfx950_persistent_f16_gemm.if_else_8:
.Lgfx950_persistent_f16_gemm.if_end_8:
		s_mov_b64 exec, s[18:19]
		s_lshl_b32 s11, s16, 15
		s_add_i32 s16, s5, s11
		v_add3_u32 v101, s16, v2, v3
		ds_read_b128 v[104:107], v101
		ds_read_b128 v[108:111], v101 offset:1024
		ds_read_b128 v[112:115], v101 offset:2048
		ds_read_b128 v[116:119], v101 offset:3072
		v_add3_u32 v101, s11, v2, v3
		ds_read_b128 v[120:123], v101 offset:26624
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[4:7], v[104:107], v[120:123], v[4:7]
		v_mfma_f32_16x16x32_f16 v[28:31], v[108:111], v[120:123], v[28:31]
		v_mfma_f32_16x16x32_f16 v[52:55], v[112:115], v[120:123], v[52:55]
		v_mfma_f32_16x16x32_f16 v[76:79], v[116:119], v[120:123], v[76:79]
		ds_read_b128 v[120:123], v101 offset:27648
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[8:11], v[104:107], v[120:123], v[8:11]
		v_mfma_f32_16x16x32_f16 v[32:35], v[108:111], v[120:123], v[32:35]
		v_mfma_f32_16x16x32_f16 v[56:59], v[112:115], v[120:123], v[56:59]
		v_mfma_f32_16x16x32_f16 v[80:83], v[116:119], v[120:123], v[80:83]
		ds_read_b128 v[120:123], v101 offset:28672
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[12:15], v[104:107], v[120:123], v[12:15]
		v_mfma_f32_16x16x32_f16 v[36:39], v[108:111], v[120:123], v[36:39]
		v_mfma_f32_16x16x32_f16 v[60:63], v[112:115], v[120:123], v[60:63]
		v_mfma_f32_16x16x32_f16 v[84:87], v[116:119], v[120:123], v[84:87]
		ds_read_b128 v[120:123], v101 offset:29696
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[16:19], v[104:107], v[120:123], v[16:19]
		v_mfma_f32_16x16x32_f16 v[40:43], v[108:111], v[120:123], v[40:43]
		v_mfma_f32_16x16x32_f16 v[64:67], v[112:115], v[120:123], v[64:67]
		v_mfma_f32_16x16x32_f16 v[88:91], v[116:119], v[120:123], v[88:91]
		ds_read_b128 v[120:123], v101 offset:30720
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[20:23], v[104:107], v[120:123], v[20:23]
		v_mfma_f32_16x16x32_f16 v[44:47], v[108:111], v[120:123], v[44:47]
		v_mfma_f32_16x16x32_f16 v[68:71], v[112:115], v[120:123], v[68:71]
		v_mfma_f32_16x16x32_f16 v[92:95], v[116:119], v[120:123], v[92:95]
		ds_read_b128 v[120:123], v101 offset:31744
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[24:27], v[104:107], v[120:123], v[24:27]
		v_mfma_f32_16x16x32_f16 v[48:51], v[108:111], v[120:123], v[48:51]
		v_mfma_f32_16x16x32_f16 v[72:75], v[112:115], v[120:123], v[72:75]
		v_mfma_f32_16x16x32_f16 v[96:99], v[116:119], v[120:123], v[96:99]
		s_cmp_lg_u32 s0, 0
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_9
		s_cmp_lt_u32 s8, 3
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_10
		s_lshl_b32 s11, s8, 12
		s_branch .Lgfx950_persistent_f16_gemm.if_end_10
.Lgfx950_persistent_f16_gemm.if_else_10:
		s_mov_b32 s11, 0x2001
.Lgfx950_persistent_f16_gemm.if_end_10:
		s_branch .Lgfx950_persistent_f16_gemm.if_end_9
.Lgfx950_persistent_f16_gemm.if_else_9:
		s_mov_b32 s11, s1
.Lgfx950_persistent_f16_gemm.if_end_9:
		s_add_i32 s11, s4, s11
		v_mov_b32_e32 v101, s11
		s_lshl_b32 s16, s8, 12
		s_add_i32 s16, s16, 0xfff
		s_and_saveexec_b64 s[24:25], s[12:13]
		s_cbranch_execz .Lgfx950_persistent_f16_gemm.exec_else_2
		ds_add_rtn_u32 v102, v100, v101 offset:32780
.Lgfx950_persistent_f16_gemm.exec_else_2:
		s_andn2_b64 exec, s[24:25], s[12:13]
		s_cbranch_execz .Lgfx950_persistent_f16_gemm.exec_endif_2
		v_mov_b32_e32 v102, 0
.Lgfx950_persistent_f16_gemm.exec_endif_2:
		s_mov_b64 exec, s[24:25]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s17, v102
		s_add_i32 s11, s17, s11
		s_cmp_eq_u32 s11, s16
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_11
		s_wakeup
		s_branch .Lgfx950_persistent_f16_gemm.if_end_11
.Lgfx950_persistent_f16_gemm.if_else_11:
.Lgfx950_persistent_f16_gemm.if_end_11:
		s_add_i32 s8, s8, 1
		s_cmp_lt_i32 s8, s3
		s_cbranch_scc1 .Lgfx950_persistent_f16_gemm.loop_head_3
.Lgfx950_persistent_f16_gemm.loop_exit_3:
		s_mov_b32 s14, 0x8000000
		s_mov_b32 s15, 0x31016000
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_lshlrev_b32_e32 v0, 14, v0
		v_lshl_add_u32 v0, v1, 3, v0
		s_lshl_b32 s0, s10, 22
		s_add_i32 s1, s0, 0x280000
		s_lshl_b32 s2, s2, 7
		s_add_i32 s1, s1, s2
		s_lshr_b32 s3, s9, 3
		s_lshl_b32 s3, s3, 9
		s_add_i32 s1, s1, s3
		s_and_b32 s4, s9, 7
		s_lshl_b32 s4, s4, 11
		s_add_i32 s1, s1, s4
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s1 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v8, v9
		v_cvt_pk_f16_f32 v3, v10, v11
		s_add_i32 s5, s0, 0x2c0000
		s_add_i32 s5, s5, s2
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s5 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v12, v13
		v_cvt_pk_f16_f32 v3, v14, v15
		s_add_i32 s6, s0, 0x300000
		s_add_i32 s6, s6, s2
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s6 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		s_add_i32 s7, s0, 0x340000
		s_add_i32 s7, s7, s2
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s7 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v20, v21
		v_cvt_pk_f16_f32 v3, v22, v23
		s_add_i32 s8, s0, 0x380000
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s3
		s_add_i32 s8, s8, s4
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v24, v25
		v_cvt_pk_f16_f32 v3, v26, v27
		s_add_i32 s0, s0, 0x3c0000
		s_add_i32 s0, s0, s2
		s_add_i32 s0, s0, s3
		s_add_i32 s0, s0, s4
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v28, v29
		v_cvt_pk_f16_f32 v3, v30, v31
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s1 offen offset:32 sc0 nt
		v_cvt_pk_f16_f32 v2, v32, v33
		v_cvt_pk_f16_f32 v3, v34, v35
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s5 offen offset:32 sc0 nt
		v_cvt_pk_f16_f32 v2, v36, v37
		v_cvt_pk_f16_f32 v3, v38, v39
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s6 offen offset:32 sc0 nt
		v_cvt_pk_f16_f32 v2, v40, v41
		v_cvt_pk_f16_f32 v3, v42, v43
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s7 offen offset:32 sc0 nt
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:32 sc0 nt
		v_cvt_pk_f16_f32 v2, v48, v49
		v_cvt_pk_f16_f32 v3, v50, v51
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:32 sc0 nt
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s1 offen offset:64 sc0 nt
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s5 offen offset:64 sc0 nt
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s6 offen offset:64 sc0 nt
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s7 offen offset:64 sc0 nt
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:64 sc0 nt
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:64 sc0 nt
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s1 offen offset:96 sc0 nt
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s5 offen offset:96 sc0 nt
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s6 offen offset:96 sc0 nt
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s7 offen offset:96 sc0 nt
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:96 sc0 nt
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:96 sc0 nt
		s_branch .Lgfx950_persistent_f16_gemm.if_end_7
.Lgfx950_persistent_f16_gemm.if_else_7:
		s_add_i32 s3, s8, 1
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_lshl_b32 s4, 1, s0
		s_cmp_eq_u32 s0, 0
		s_mov_b32 s14, 1
		s_mov_b32 s15, 0
		s_cselect_b32 s5, 1, 0
		s_lshl_b32 s8, s2, 12
		v_and_b32_e32 v0, 63, v0
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v2, 6, v1
		v_lshrrev_b32_e32 v0, 4, v0
		v_lshrrev_b32_e32 v3, 1, v1
		v_bitop3_b32 v3, v0, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v3, 4, v3
		v_add_u32_e32 v8, v2, v3
		s_mul_i32 s11, 0xffffc400, s2
		s_mul_i32 s16, 0x1400, s0
		s_add_i32 s11, s11, s16
		s_mov_b32 s16, s1
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
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
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
.Lgfx950_persistent_f16_gemm.loop_head_5:
		s_lshl_b32 s17, s16, 4
		s_add_i32 s17, s17, 15
		s_mul_hi_u32 s18, s16, 0xaaaaaaab
		s_lshr_b32 s18, s18, 1
		s_mul_i32 s18, s18, 3
		s_xor_b32 s18, s18, -1
		s_add_i32 s18, s18, 1
		s_add_i32 s18, s16, s18
		s_lshl_b32 s19, s18, 2
		s_add_i32 s19, s19, 0x10000
		v_mov_b32_e32 v9, s19
		ds_read_b32 v10, v9 offset:32768
		s_and_saveexec_b64 s[20:21], s[14:15]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s19, v10
		s_cmp_lg_u32 s19, s17
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_12
.Lgfx950_persistent_f16_gemm.loop_head_6:
		ds_read_b32 v10, v9 offset:32768
		s_sleep 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s19, v10
		s_cmp_lg_u32 s19, s17
		s_cbranch_scc1 .Lgfx950_persistent_f16_gemm.loop_head_6
.Lgfx950_persistent_f16_gemm.loop_exit_6:
		s_branch .Lgfx950_persistent_f16_gemm.if_end_12
.Lgfx950_persistent_f16_gemm.if_else_12:
.Lgfx950_persistent_f16_gemm.if_end_12:
		s_mov_b64 exec, s[20:21]
		s_lshl_b32 s17, s18, 15
		s_add_i32 s18, s8, s17
		v_add3_u32 v10, s18, v2, v3
		ds_read_b128 v[88:91], v10
		ds_read_b128 v[92:95], v10 offset:1024
		ds_read_b128 v[96:99], v10 offset:2048
		ds_read_b128 v[100:103], v10 offset:3072
		s_add_i32 s17, s11, s17
		v_add_u32_e32 v10, s17, v8
		ds_read_b128 v[104:107], v10 offset:16384
		ds_read_b128 v[108:111], v10 offset:17408
		ds_read_b128 v[112:115], v10 offset:18432
		ds_read_b128 v[116:119], v10 offset:19456
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[4:7], v[88:91], v[104:107], v[4:7]
		v_mfma_f32_16x16x32_f16 v[28:31], v[92:95], v[104:107], v[28:31]
		v_mfma_f32_16x16x32_f16 v[48:51], v[96:99], v[104:107], v[48:51]
		v_mfma_f32_16x16x32_f16 v[68:71], v[100:103], v[104:107], v[68:71]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[12:15], v[88:91], v[108:111], v[12:15]
		v_mfma_f32_16x16x32_f16 v[32:35], v[92:95], v[108:111], v[32:35]
		v_mfma_f32_16x16x32_f16 v[52:55], v[96:99], v[108:111], v[52:55]
		v_mfma_f32_16x16x32_f16 v[72:75], v[100:103], v[108:111], v[72:75]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[16:19], v[88:91], v[112:115], v[16:19]
		v_mfma_f32_16x16x32_f16 v[36:39], v[92:95], v[112:115], v[36:39]
		v_mfma_f32_16x16x32_f16 v[56:59], v[96:99], v[112:115], v[56:59]
		v_mfma_f32_16x16x32_f16 v[76:79], v[100:103], v[112:115], v[76:79]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[20:23], v[88:91], v[116:119], v[20:23]
		v_mfma_f32_16x16x32_f16 v[40:43], v[92:95], v[116:119], v[40:43]
		v_mfma_f32_16x16x32_f16 v[60:63], v[96:99], v[116:119], v[60:63]
		v_mfma_f32_16x16x32_f16 v[80:83], v[100:103], v[116:119], v[80:83]
		ds_read_b128 v[104:107], v10 offset:20480
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[24:27], v[88:91], v[104:107], v[24:27]
		v_mfma_f32_16x16x32_f16 v[44:47], v[92:95], v[104:107], v[44:47]
		v_mfma_f32_16x16x32_f16 v[64:67], v[96:99], v[104:107], v[64:67]
		v_mfma_f32_16x16x32_f16 v[84:87], v[100:103], v[104:107], v[84:87]
		s_cmp_lg_u32 s5, 0
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_13
		s_cmp_lt_u32 s16, 3
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_14
		s_lshl_b32 s17, s16, 12
		s_branch .Lgfx950_persistent_f16_gemm.if_end_14
.Lgfx950_persistent_f16_gemm.if_else_14:
		s_mov_b32 s17, 0x2001
.Lgfx950_persistent_f16_gemm.if_end_14:
		s_branch .Lgfx950_persistent_f16_gemm.if_end_13
.Lgfx950_persistent_f16_gemm.if_else_13:
		s_mov_b32 s17, s1
.Lgfx950_persistent_f16_gemm.if_end_13:
		s_add_i32 s17, s4, s17
		v_mov_b32_e32 v10, s17
		s_lshl_b32 s18, s16, 12
		s_add_i32 s18, s18, 0xfff
		s_and_saveexec_b64 s[24:25], s[12:13]
		s_cbranch_execz .Lgfx950_persistent_f16_gemm.exec_else_3
		ds_add_rtn_u32 v11, v9, v10 offset:32780
.Lgfx950_persistent_f16_gemm.exec_else_3:
		s_andn2_b64 exec, s[24:25], s[12:13]
		s_cbranch_execz .Lgfx950_persistent_f16_gemm.exec_endif_3
		v_mov_b32_e32 v11, 0
.Lgfx950_persistent_f16_gemm.exec_endif_3:
		s_mov_b64 exec, s[24:25]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s19, v11
		s_add_i32 s17, s19, s17
		s_cmp_eq_u32 s17, s18
		s_cbranch_scc0 .Lgfx950_persistent_f16_gemm.if_else_15
		s_wakeup
		s_branch .Lgfx950_persistent_f16_gemm.if_end_15
.Lgfx950_persistent_f16_gemm.if_else_15:
.Lgfx950_persistent_f16_gemm.if_end_15:
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s16, s3
		s_cbranch_scc1 .Lgfx950_persistent_f16_gemm.loop_head_5
.Lgfx950_persistent_f16_gemm.loop_exit_5:
		s_mov_b32 s14, 0x8000000
		s_mov_b32 s15, 0x31016000
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		s_lshl_b32 s1, s10, 22
		s_mul_i32 s2, 0xffc40080, s2
		s_add_i32 s3, s1, s2
		s_mul_i32 s0, 0x140000, s0
		s_add_i32 s3, s3, s0
		s_lshr_b32 s4, s9, 3
		s_lshl_b32 s4, s4, 9
		s_add_i32 s3, s3, s4
		s_and_b32 s5, s9, 7
		s_lshl_b32 s5, s5, 11
		s_add_i32 s3, s3, s5
		v_lshlrev_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v1, 14, v1
		v_add3_u32 v4, s3, v0, v1
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v12, v13
		v_cvt_pk_f16_f32 v3, v14, v15
		s_add_i32 s3, s1, 0x40000
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		s_add_i32 s3, s1, 0x80000
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v20, v21
		v_cvt_pk_f16_f32 v3, v22, v23
		s_add_i32 s3, s1, 0xc0000
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v24, v25
		v_cvt_pk_f16_f32 v3, v26, v27
		s_add_i32 s3, s1, 0x100000
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v28, v29
		v_cvt_pk_f16_f32 v3, v30, v31
		s_add_i32 s3, s1, 32
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v32, v33
		v_cvt_pk_f16_f32 v3, v34, v35
		s_add_i32 s3, s1, 0x40020
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v36, v37
		v_cvt_pk_f16_f32 v3, v38, v39
		s_add_i32 s3, s1, 0x80020
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v40, v41
		v_cvt_pk_f16_f32 v3, v42, v43
		s_add_i32 s3, s1, 0xc0020
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		s_add_i32 s3, s1, 0x100020
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v48, v49
		v_cvt_pk_f16_f32 v3, v50, v51
		s_add_i32 s3, s1, 64
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		s_add_i32 s3, s1, 0x40040
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		s_add_i32 s3, s1, 0x80040
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		s_add_i32 s3, s1, 0xc0040
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		s_add_i32 s3, s1, 0x100040
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		s_add_i32 s3, s1, 0x60
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		s_add_i32 s3, s1, 0x40060
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		s_add_i32 s3, s1, 0x80060
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		s_add_i32 s3, s1, 0xc0060
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s5
		v_add3_u32 v4, s3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[12:15], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		s_add_i32 s1, s1, 0x100060
		s_add_i32 s1, s1, s2
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s4
		s_add_i32 s0, s0, s5
		v_add3_u32 v0, s0, v0, v1
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen sc0 nt
.Lgfx950_persistent_f16_gemm.if_end_7:
.Lgfx950_persistent_f16_gemm.if_end_0:
		s_endpgm
	.size	gfx950_persistent_f16_gemm, .-gfx950_persistent_f16_gemm
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel gfx950_persistent_f16_gemm
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 32
		.amdhsa_user_sgpr_count 9
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 7
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 124
		.amdhsa_next_free_sgpr 26
		.amdhsa_accum_offset 124
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
	.set .Lgfx950_persistent_f16_gemm.num_vgpr, 124
	.set .Lgfx950_persistent_f16_gemm.num_agpr, 0
	.set .Lgfx950_persistent_f16_gemm.numbered_sgpr, 26
	.set .Lgfx950_persistent_f16_gemm.num_named_barrier, 0
	.set .Lgfx950_persistent_f16_gemm.private_seg_size, 0
	.set .Lgfx950_persistent_f16_gemm.uses_vcc, 1
	.set .Lgfx950_persistent_f16_gemm.uses_flat_scratch, 0
	.set .Lgfx950_persistent_f16_gemm.has_dyn_sized_stack, 0
	.set .Lgfx950_persistent_f16_gemm.has_recursion, 0
	.set .Lgfx950_persistent_f16_gemm.has_indirect_call, 0
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
      - .name:           arg3
        .offset:         24
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 32
    .max_flat_workgroup_size: 1024
    .name:           gfx950_persistent_f16_gemm
    .private_segment_fixed_size: 0
    .sgpr_count:     26
    .sgpr_spill_count: 0
    .symbol:         gfx950_persistent_f16_gemm.kd
    .uses_dynamic_stack: false
    .vgpr_count:     124
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 1
    wave.regalloc.agpr.dwords: 0
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
