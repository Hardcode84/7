	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	wmma_f16_matmul_tiled
	.p2align	8
	.type	wmma_f16_matmul_tiled,@function
wmma_f16_matmul_tiled:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dword s12, s[0:1], 0x28
		s_waitcnt lgkmcnt(0)
		s_branch .Lwmma_f16_matmul_tiled.kernarg_preload_entry
	.p2align	8
.Lwmma_f16_matmul_tiled.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s22, 0x1000000
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, 0x1000000
		s_mov_b32 s3, 0x31016000
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, 0x1000000
		s_mov_b32 s7, 0x31016000
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, 0x1000000
		s_mov_b32 s27, 0x31016000
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s8, 0
		scratch_store_dword off, v4, s8 offset:664
		scratch_store_dword off, v5, s8 offset:668
		scratch_store_dword off, v6, s8 offset:672
		scratch_store_dword off, v7, s8 offset:676
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_accvgpr_write_b32 a0, v1
		v_accvgpr_read_b32 v1, a0
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v1, s9, v2
		v_and_b32_e32 v3, 63, v0
		v_lshrrev_b32_e32 v4, 2, v3
		v_lshlrev_b32_e32 v3, 12, v4
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 3, v4
		v_and_b32_e32 v4, 3, v5
		v_and_b32_e32 v5, 63, v0
		v_and_b32_e32 v6, 3, v5
		v_xor_b32_e32 v5, v4, v6
		v_lshlrev_b32_e32 v4, 4, v5
		v_add3_u32 v5, v1, v3, v4
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v6, v1, v3, v4
		v_add3_u32 v1, s9, 64, v2
		v_add3_u32 v7, v1, v3, v4
		s_add_i32 s10, s9, 0x80040
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v8, v1, v3, v4
		s_lshl_b32 s10, s14, 20
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v9, v1, v3, v4
		s_add_i32 s11, s10, 0x80000
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v10, v1, v3, v4
		v_add3_u32 v1, s10, 64, v2
		v_add3_u32 v11, v1, v3, v4
		s_add_i32 s11, s10, 0x80040
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v12, v1, v3, v4
		s_lshr_b32 s11, s8, 6
		s_lshl_b32 s15, s11, 10
		s_add_i32 s28, s15, 0x2000
		s_add_i32 s29, s15, 0x4000
		s_add_i32 s30, s15, 0x6000
		s_add_i32 s31, s15, 0x8000
		s_add_i32 s32, s15, 0xa000
		s_add_i32 s33, s15, 0xc000
		s_add_i32 s34, s15, 0xe000
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_lshl_b32 s35, s14, 16
		s_add_i32 s36, s9, s35
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshlrev_b32_e32 v6, 9, v5
		v_lshlrev_b32_e32 v5, 2, v1
		v_add3_u32 v7, s36, v6, v5
		s_lshr_b32 s37, s8, 7
		s_lshl_b32 s8, s37, 9
		s_add_i32 s37, s9, 0x100
		s_add_i32 s38, s37, s35
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshlrev_b32_e32 v6, 9, v5
		v_lshlrev_b32_e32 v5, 2, v1
		v_add3_u32 v8, s38, v6, v5
		s_add_i32 s37, s8, 0x100
		v_and_b32_e32 v5, 63, v0
		v_lshlrev_b32_e32 v6, 4, v5
		v_accvgpr_read_b32 v5, a0
		v_and_b32_e32 v9, 1, v5
		v_lshlrev_b32_e32 v5, 10, v9
		v_add3_u32 v10, s36, v6, v5
		s_and_b32 s36, s11, 1
		s_lshl_b32 s11, s36, 10
		s_add_i32 s36, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v7, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x20100
		s_nop 0
		buffer_load_dword v8, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v5, 15, v0
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v8, 4, v7
		v_lshrrev_b32_e32 v7, 1, v5
		v_and_b32_e32 v5, 3, v7
		v_xor_b32_e32 v7, v8, v5
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshlrev_b32_e32 v8, 12, v5
		v_and_b32_e32 v5, 15, v0
		v_lshlrev_b32_e32 v10, 6, v5
		v_lshlrev_b32_e32 v5, 4, v7
		v_add3_u32 v11, v8, v10, v5
		ds_read_b128 v[12:15], v11
		ds_read_b128 v[16:19], v11 offset:1024
		ds_read_b128 v[20:23], v11 offset:2048
		ds_read_b128 v[24:27], v11 offset:3072
		v_lshlrev_b32_e32 v5, 13, v9
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v10, 6, v8
		v_lshlrev_b32_e32 v8, 4, v7
		v_add3_u32 v11, v10, v5, v8
		ds_read_b128 v[28:31], v11 offset:32768
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s38 offset:1212
		scratch_store_dword off, v29, s38 offset:1216
		scratch_store_dword off, v30, s38 offset:1220
		scratch_store_dword off, v31, s38 offset:1224
		ds_read_b128 v[28:31], v11 offset:33792
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s38 offset:1196
		scratch_store_dword off, v29, s38 offset:1200
		scratch_store_dword off, v30, s38 offset:1204
		scratch_store_dword off, v31, s38 offset:1208
		ds_read_b128 v[28:31], v11 offset:34816
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s38 offset:1180
		scratch_store_dword off, v29, s38 offset:1184
		scratch_store_dword off, v30, s38 offset:1188
		scratch_store_dword off, v31, s38 offset:1192
		ds_read_b128 v[28:31], v11 offset:35840
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s38 offset:1164
		scratch_store_dword off, v29, s38 offset:1168
		scratch_store_dword off, v30, s38 offset:1172
		scratch_store_dword off, v31, s38 offset:1176
		ds_read_b128 v[28:31], v11 offset:36864
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s38 offset:1148
		scratch_store_dword off, v29, s38 offset:1152
		scratch_store_dword off, v30, s38 offset:1156
		scratch_store_dword off, v31, s38 offset:1160
		ds_read_b128 v[28:31], v11 offset:37888
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s38 offset:1132
		scratch_store_dword off, v29, s38 offset:1136
		scratch_store_dword off, v30, s38 offset:1140
		scratch_store_dword off, v31, s38 offset:1144
		ds_read_b128 v[28:31], v11 offset:38912
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s38 offset:1116
		scratch_store_dword off, v29, s38 offset:1120
		scratch_store_dword off, v30, s38 offset:1124
		scratch_store_dword off, v31, s38 offset:1128
		ds_read_b128 v[28:31], v11 offset:39936
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s38 offset:1100
		scratch_store_dword off, v29, s38 offset:1104
		scratch_store_dword off, v30, s38 offset:1108
		scratch_store_dword off, v31, s38 offset:1112
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshlrev_b32_e32 v8, 9, v5
		v_add_u32_e32 v5, 0x20000, v8
		v_lshlrev_b32_e32 v8, 2, v1
		v_add_u32_e32 v10, v5, v8
		ds_read_b32 v5, v10
		ds_read_b32 v8, v10 offset:256
		v_lshlrev_b32_e32 v10, 2, v1
		v_add_u32_e32 v11, 0x20000, v10
		v_lshlrev_b32_e32 v10, 10, v9
		v_add_u32_e32 v28, v11, v10
		ds_read_b32 v10, v28 offset:2048
		ds_read_b32 v11, v28 offset:2304
		ds_read_b32 v29, v28 offset:2560
		ds_read_b32 v30, v28 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s38, s9, 0x80
		v_add_u32_e32 v28, s38, v2
		v_add3_u32 v31, v28, v3, v4
		s_add_i32 s38, s9, 0x80080
		v_add_u32_e32 v28, s38, v2
		v_add3_u32 v32, v28, v3, v4
		s_add_i32 s38, s9, 0xc0
		v_add_u32_e32 v28, s38, v2
		v_add3_u32 v33, v28, v3, v4
		s_add_i32 s38, s9, 0x800c0
		v_add_u32_e32 v28, s38, v2
		v_add3_u32 v34, v28, v3, v4
		s_add_i32 s38, s10, 0x80
		v_add_u32_e32 v28, s38, v2
		v_add3_u32 v35, v28, v3, v4
		s_add_i32 s38, s10, 0x80080
		v_add_u32_e32 v28, s38, v2
		v_add3_u32 v36, v28, v3, v4
		s_add_i32 s38, s10, 0xc0
		v_add_u32_e32 v28, s38, v2
		v_add3_u32 v37, v28, v3, v4
		s_add_i32 s38, s10, 0x800c0
		v_add_u32_e32 v28, s38, v2
		v_add3_u32 v2, v28, v3, v4
		s_add_i32 s10, s15, 0x10000
		s_add_i32 s38, s15, 0x12000
		s_add_i32 s39, s15, 0x14000
		s_add_i32 s40, s15, 0x16000
		s_add_i32 s41, s15, 0x18000
		s_add_i32 s42, s15, 0x1a000
		s_add_i32 s43, s15, 0x1c000
		s_add_i32 s44, s15, 0x1e000
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v31, s[20:23], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v32, s[20:23], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v33, s[20:23], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v34, s[20:23], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v35, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v36, s[0:3], 0 offen lds
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v37, s[0:3], 0 offen lds
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s45, s9, 0x800
		s_add_i32 s46, s45, s35
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v4, s46, v3, v2
		s_add_i32 s45, s8, 0x1000
		s_add_i32 s47, s9, 0x900
		s_add_i32 s9, s47, s35
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v28, s9, v3, v2
		s_add_i32 s9, s8, 0x1100
		v_lshlrev_b32_e32 v2, 10, v9
		v_add3_u32 v3, s46, v6, v2
		s_add_i32 s35, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dword v4, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x21100
		s_nop 0
		buffer_load_dword v28, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s11, s12, 1
		s_mov_b32 s46, 2
		v_mov_b32_e32 v2, s13
		v_mov_b32_e32 v3, 0
		s_mov_b32 s48, 0x100000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v32, s48
		v_mov_b32_e32 v33, s49
		v_mul_lo_u32 v34, v32, v2
		v_mul_hi_u32 v35, v32, v2
		v_mul_lo_u32 v4, v32, v3
		v_add_u32_e32 v35, v35, v4
		v_mul_lo_u32 v4, v33, v2
		v_add_u32_e32 v35, v35, v4
		s_mov_b32 s48, 1
		s_mov_b32 s49, 0
		v_mov_b32_e32 v36, v0
		v_mov_b32_e32 v37, 0
		v_mov_b32_e32 v38, s48
		v_mov_b32_e32 v39, s49
		v_mul_lo_u32 v40, v38, v36
		v_mul_hi_u32 v41, v38, v36
		v_mul_lo_u32 v2, v38, v37
		v_add_u32_e32 v41, v41, v2
		v_mul_lo_u32 v2, v39, v36
		v_add_u32_e32 v41, v41, v2
		v_lshrrev_b64 v[42:43], 6, v[40:41]
		s_mov_b32 s48, 0x10000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v44, s48
		v_mov_b32_e32 v45, s49
		v_mul_lo_u32 v46, v44, v42
		v_mul_hi_u32 v47, v44, v42
		v_mul_lo_u32 v2, v44, v43
		v_add_u32_e32 v47, v47, v2
		v_mul_lo_u32 v2, v45, v42
		v_add_u32_e32 v47, v47, v2
		v_add_co_u32_e64 v48, vcc, v34, v46
		v_addc_co_u32_e64 v49, vcc, v35, v47, vcc
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v50, v36, v2
		v_and_b32_e32 v51, v3, v3
		v_mul_lo_u32 v36, v38, v50
		v_mul_hi_u32 v37, v38, v50
		v_mul_lo_u32 v2, v38, v51
		v_add_u32_e32 v37, v37, v2
		v_mul_lo_u32 v2, v39, v50
		v_add_u32_e32 v37, v37, v2
		v_lshrrev_b64 v[38:39], 2, v[36:37]
		s_mov_b32 s48, 0x1000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v52, s48
		v_mov_b32_e32 v53, s49
		v_mul_lo_u32 v54, v52, v38
		v_mul_hi_u32 v55, v52, v38
		v_mul_lo_u32 v2, v52, v39
		v_add_u32_e32 v55, v55, v2
		v_mul_lo_u32 v2, v53, v38
		v_add_u32_e32 v55, v55, v2
		v_add_co_u32_e64 v38, vcc, v48, v54
		v_addc_co_u32_e64 v39, vcc, v49, v55, vcc
		v_lshrrev_b64 v[48:49], 3, v[36:37]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v36, v48, v2
		v_and_b32_e32 v37, v49, v3
		v_and_b32_e32 v48, v50, v2
		v_and_b32_e32 v49, v51, v3
		v_xor_b32_e32 v52, v36, v48
		v_xor_b32_e32 v53, v37, v49
		s_mov_b32 s48, 16
		s_mov_b32 s49, 0
		v_mov_b32_e32 v36, s48
		v_mov_b32_e32 v37, s49
		v_mul_lo_u32 v48, v36, v52
		v_mul_hi_u32 v49, v36, v52
		v_mul_lo_u32 v2, v36, v53
		v_add_u32_e32 v49, v49, v2
		v_mul_lo_u32 v2, v37, v52
		v_add_u32_e32 v49, v49, v2
		v_add_co_u32_e64 v52, vcc, v38, v48
		v_addc_co_u32_e64 v53, vcc, v39, v49, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x22000, v2
		ds_write_b32 v4, v52
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x22800, v2
		ds_write_b32 v4, v53
		s_mov_b32 s48, 0x80
		s_mov_b32 s49, 0
		v_mov_b32_e32 v38, s48
		v_mov_b32_e32 v39, s49
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x23000, v2
		ds_write_b32 v4, v38
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x23800, v2
		ds_write_b32 v4, v39
		v_mov_b32_e32 v2, 0x80000
		v_add_co_u32_e64 v38, vcc, v34, v2
		v_addc_co_u32_e64 v39, vcc, v35, 0, vcc
		v_add_co_u32_e64 v52, vcc, v38, v46
		v_addc_co_u32_e64 v53, vcc, v39, v47, vcc
		v_add_co_u32_e64 v38, vcc, v52, v54
		v_addc_co_u32_e64 v39, vcc, v53, v55, vcc
		v_add_co_u32_e64 v52, vcc, v38, v48
		v_addc_co_u32_e64 v53, vcc, v39, v49, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x24000, v4
		ds_write_b32 v6, v52
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x24800, v4
		ds_write_b32 v6, v53
		v_mov_b32_e32 v4, 64
		v_add_co_u32_e64 v38, vcc, v34, v4
		v_addc_co_u32_e64 v39, vcc, v35, 0, vcc
		v_add_co_u32_e64 v52, vcc, v38, v46
		v_addc_co_u32_e64 v53, vcc, v39, v47, vcc
		v_add_co_u32_e64 v38, vcc, v52, v54
		v_addc_co_u32_e64 v39, vcc, v53, v55, vcc
		v_add_co_u32_e64 v52, vcc, v38, v48
		v_addc_co_u32_e64 v53, vcc, v39, v49, vcc
		v_lshlrev_b32_e32 v6, 2, v0
		v_add_u32_e32 v28, 0x25000, v6
		ds_write_b32 v28, v52
		v_lshlrev_b32_e32 v6, 2, v0
		v_add_u32_e32 v28, 0x25800, v6
		ds_write_b32 v28, v53
		v_mov_b32_e32 v6, 0x80040
		v_add_co_u32_e64 v38, vcc, v34, v6
		v_addc_co_u32_e64 v39, vcc, v35, 0, vcc
		v_add_co_u32_e64 v52, vcc, v38, v46
		v_addc_co_u32_e64 v53, vcc, v39, v47, vcc
		v_add_co_u32_e64 v38, vcc, v52, v54
		v_addc_co_u32_e64 v39, vcc, v53, v55, vcc
		v_add_co_u32_e64 v52, vcc, v38, v48
		v_addc_co_u32_e64 v53, vcc, v39, v49, vcc
		v_lshlrev_b32_e32 v28, 2, v0
		v_add_u32_e32 v31, 0x26000, v28
		ds_write_b32 v31, v52
		v_lshlrev_b32_e32 v28, 2, v0
		v_add_u32_e32 v31, 0x26800, v28
		ds_write_b32 v31, v53
		v_mov_b32_e32 v38, s14
		v_mov_b32_e32 v39, 0
		v_mul_lo_u32 v52, v32, v38
		v_mul_hi_u32 v53, v32, v38
		v_mul_lo_u32 v28, v32, v39
		v_add_u32_e32 v53, v53, v28
		v_mul_lo_u32 v28, v33, v38
		v_add_u32_e32 v53, v53, v28
		v_add_co_u32_e64 v32, vcc, v52, v46
		v_addc_co_u32_e64 v33, vcc, v53, v47, vcc
		v_add_co_u32_e64 v56, vcc, v32, v54
		v_addc_co_u32_e64 v57, vcc, v33, v55, vcc
		v_add_co_u32_e64 v32, vcc, v56, v48
		v_addc_co_u32_e64 v33, vcc, v57, v49, vcc
		v_lshlrev_b32_e32 v28, 2, v0
		v_add_u32_e32 v31, 0x27000, v28
		ds_write_b32 v31, v32
		v_lshlrev_b32_e32 v28, 2, v0
		v_add_u32_e32 v31, 0x27800, v28
		ds_write_b32 v31, v33
		v_add_co_u32_e64 v32, vcc, v52, v2
		v_addc_co_u32_e64 v33, vcc, v53, 0, vcc
		v_add_co_u32_e64 v56, vcc, v32, v46
		v_addc_co_u32_e64 v57, vcc, v33, v47, vcc
		v_add_co_u32_e64 v32, vcc, v56, v54
		v_addc_co_u32_e64 v33, vcc, v57, v55, vcc
		v_add_co_u32_e64 v56, vcc, v32, v48
		v_addc_co_u32_e64 v57, vcc, v33, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v56, s47
		scratch_store_dword off, v57, s47 offset:4
		v_add_co_u32_e64 v32, vcc, v52, v4
		v_addc_co_u32_e64 v33, vcc, v53, 0, vcc
		v_add_co_u32_e64 v56, vcc, v32, v46
		v_addc_co_u32_e64 v57, vcc, v33, v47, vcc
		v_add_co_u32_e64 v32, vcc, v56, v54
		v_addc_co_u32_e64 v33, vcc, v57, v55, vcc
		v_add_co_u32_e64 v56, vcc, v32, v48
		v_addc_co_u32_e64 v57, vcc, v33, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v56, s47 offset:8
		scratch_store_dword off, v57, s47 offset:12
		v_add_co_u32_e64 v32, vcc, v52, v6
		v_addc_co_u32_e64 v33, vcc, v53, 0, vcc
		v_add_co_u32_e64 v56, vcc, v32, v46
		v_addc_co_u32_e64 v57, vcc, v33, v47, vcc
		v_add_co_u32_e64 v32, vcc, v56, v54
		v_addc_co_u32_e64 v33, vcc, v57, v55, vcc
		v_add_co_u32_e64 v56, vcc, v32, v48
		v_addc_co_u32_e64 v57, vcc, v33, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v56, s47 offset:16
		scratch_store_dword off, v57, s47 offset:20
		v_mul_lo_u32 v32, v44, v38
		v_mul_hi_u32 v33, v44, v38
		v_mul_lo_u32 v2, v44, v39
		v_add_u32_e32 v33, v33, v2
		v_mul_lo_u32 v2, v45, v38
		v_add_u32_e32 v33, v33, v2
		v_add_co_u32_e64 v38, vcc, v34, v32
		v_addc_co_u32_e64 v39, vcc, v35, v33, vcc
		v_lshrrev_b64 v[44:45], 7, v[40:41]
		s_mov_b32 s48, 0x200
		s_mov_b32 s49, 0
		v_mov_b32_e32 v40, s48
		v_mov_b32_e32 v41, s49
		v_mul_lo_u32 v56, v40, v44
		v_mul_hi_u32 v57, v40, v44
		v_mul_lo_u32 v2, v40, v45
		v_add_u32_e32 v57, v57, v2
		v_mul_lo_u32 v2, v41, v44
		v_add_u32_e32 v57, v57, v2
		v_add_co_u32_e64 v40, vcc, v38, v56
		v_addc_co_u32_e64 v41, vcc, v39, v57, vcc
		s_mov_b32 s48, 4
		s_mov_b32 s49, 0
		v_mov_b32_e32 v44, s48
		v_mov_b32_e32 v45, s49
		v_mul_lo_u32 v58, v44, v50
		v_mul_hi_u32 v59, v44, v50
		v_mul_lo_u32 v2, v44, v51
		v_add_u32_e32 v59, v59, v2
		v_mul_lo_u32 v2, v45, v50
		v_add_u32_e32 v59, v59, v2
		v_add_co_u32_e64 v44, vcc, v40, v58
		v_addc_co_u32_e64 v45, vcc, v41, v59, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v44, s47 offset:24
		scratch_store_dword off, v45, s47 offset:28
		s_mov_b32 s48, 0x800
		s_mov_b32 s49, 0
		v_mov_b32_e32 v40, s48
		v_mov_b32_e32 v41, s49
		s_mov_b32 s47, 0
		scratch_store_dword off, v40, s47 offset:32
		scratch_store_dword off, v41, s47 offset:36
		v_mov_b32_e32 v2, 0x100
		v_add_co_u32_e64 v40, vcc, v34, v2
		v_addc_co_u32_e64 v41, vcc, v35, 0, vcc
		v_add_co_u32_e64 v44, vcc, v40, v32
		v_addc_co_u32_e64 v45, vcc, v41, v33, vcc
		v_add_co_u32_e64 v40, vcc, v44, v56
		v_addc_co_u32_e64 v41, vcc, v45, v57, vcc
		v_add_co_u32_e64 v44, vcc, v40, v58
		v_addc_co_u32_e64 v45, vcc, v41, v59, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v44, s47 offset:40
		scratch_store_dword off, v45, s47 offset:44
		v_mul_lo_u32 v40, v36, v50
		v_mul_hi_u32 v41, v36, v50
		v_mul_lo_u32 v2, v36, v51
		v_add_u32_e32 v41, v41, v2
		v_mul_lo_u32 v2, v37, v50
		v_add_u32_e32 v41, v41, v2
		v_add_co_u32_e64 v36, vcc, v38, v40
		v_addc_co_u32_e64 v37, vcc, v39, v41, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v38, v42, v2
		v_and_b32_e32 v39, v43, v3
		s_mov_b32 s48, 0x400
		s_mov_b32 s49, 0
		v_mov_b32_e32 v2, s48
		v_mov_b32_e32 v3, s49
		v_mul_lo_u32 v42, v2, v38
		v_mul_hi_u32 v43, v2, v38
		v_mul_lo_u32 v4, v2, v39
		v_add_u32_e32 v43, v43, v4
		v_mul_lo_u32 v4, v3, v38
		v_add_u32_e32 v43, v43, v4
		v_add_co_u32_e64 v2, vcc, v36, v42
		v_addc_co_u32_e64 v3, vcc, v37, v43, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:48
		scratch_store_dword off, v3, s47 offset:52
		v_mov_b32_e32 v2, 0x80
		v_add_co_u32_e64 v36, vcc, v34, v2
		v_addc_co_u32_e64 v37, vcc, v35, 0, vcc
		v_add_co_u32_e64 v38, vcc, v36, v46
		v_addc_co_u32_e64 v39, vcc, v37, v47, vcc
		v_add_co_u32_e64 v36, vcc, v38, v54
		v_addc_co_u32_e64 v37, vcc, v39, v55, vcc
		v_add_co_u32_e64 v38, vcc, v36, v48
		v_addc_co_u32_e64 v39, vcc, v37, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v38, s47 offset:56
		scratch_store_dword off, v39, s47 offset:60
		v_mov_b32_e32 v3, 0x80080
		v_add_co_u32_e64 v36, vcc, v34, v3
		v_addc_co_u32_e64 v37, vcc, v35, 0, vcc
		v_add_co_u32_e64 v38, vcc, v36, v46
		v_addc_co_u32_e64 v39, vcc, v37, v47, vcc
		v_add_co_u32_e64 v36, vcc, v38, v54
		v_addc_co_u32_e64 v37, vcc, v39, v55, vcc
		v_add_co_u32_e64 v38, vcc, v36, v48
		v_addc_co_u32_e64 v39, vcc, v37, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v38, s47 offset:64
		scratch_store_dword off, v39, s47 offset:68
		v_mov_b32_e32 v4, 0xc0
		v_add_co_u32_e64 v36, vcc, v34, v4
		v_addc_co_u32_e64 v37, vcc, v35, 0, vcc
		v_add_co_u32_e64 v38, vcc, v36, v46
		v_addc_co_u32_e64 v39, vcc, v37, v47, vcc
		v_add_co_u32_e64 v36, vcc, v38, v54
		v_addc_co_u32_e64 v37, vcc, v39, v55, vcc
		v_add_co_u32_e64 v38, vcc, v36, v48
		v_addc_co_u32_e64 v39, vcc, v37, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v38, s47 offset:72
		scratch_store_dword off, v39, s47 offset:76
		v_mov_b32_e32 v6, 0x800c0
		v_add_co_u32_e64 v36, vcc, v34, v6
		v_addc_co_u32_e64 v37, vcc, v35, 0, vcc
		v_add_co_u32_e64 v38, vcc, v36, v46
		v_addc_co_u32_e64 v39, vcc, v37, v47, vcc
		v_add_co_u32_e64 v36, vcc, v38, v54
		v_addc_co_u32_e64 v37, vcc, v39, v55, vcc
		v_add_co_u32_e64 v38, vcc, v36, v48
		v_addc_co_u32_e64 v39, vcc, v37, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v38, s47 offset:80
		scratch_store_dword off, v39, s47 offset:84
		v_add_co_u32_e64 v36, vcc, v52, v2
		v_addc_co_u32_e64 v37, vcc, v53, 0, vcc
		v_add_co_u32_e64 v38, vcc, v36, v46
		v_addc_co_u32_e64 v39, vcc, v37, v47, vcc
		v_add_co_u32_e64 v36, vcc, v38, v54
		v_addc_co_u32_e64 v37, vcc, v39, v55, vcc
		v_add_co_u32_e64 v38, vcc, v36, v48
		v_addc_co_u32_e64 v39, vcc, v37, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v38, s47 offset:88
		scratch_store_dword off, v39, s47 offset:92
		v_add_co_u32_e64 v36, vcc, v52, v3
		v_addc_co_u32_e64 v37, vcc, v53, 0, vcc
		v_add_co_u32_e64 v2, vcc, v36, v46
		v_addc_co_u32_e64 v3, vcc, v37, v47, vcc
		v_add_co_u32_e64 v36, vcc, v2, v54
		v_addc_co_u32_e64 v37, vcc, v3, v55, vcc
		v_add_co_u32_e64 v2, vcc, v36, v48
		v_addc_co_u32_e64 v3, vcc, v37, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:96
		scratch_store_dword off, v3, s47 offset:100
		v_add_co_u32_e64 v2, vcc, v52, v4
		v_addc_co_u32_e64 v3, vcc, v53, 0, vcc
		v_add_co_u32_e64 v36, vcc, v2, v46
		v_addc_co_u32_e64 v37, vcc, v3, v47, vcc
		v_add_co_u32_e64 v2, vcc, v36, v54
		v_addc_co_u32_e64 v3, vcc, v37, v55, vcc
		v_add_co_u32_e64 v36, vcc, v2, v48
		v_addc_co_u32_e64 v37, vcc, v3, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v36, s47 offset:104
		scratch_store_dword off, v37, s47 offset:108
		v_add_co_u32_e64 v2, vcc, v52, v6
		v_addc_co_u32_e64 v3, vcc, v53, 0, vcc
		v_add_co_u32_e64 v36, vcc, v2, v46
		v_addc_co_u32_e64 v37, vcc, v3, v47, vcc
		v_add_co_u32_e64 v2, vcc, v36, v54
		v_addc_co_u32_e64 v3, vcc, v37, v55, vcc
		v_add_co_u32_e64 v36, vcc, v2, v48
		v_addc_co_u32_e64 v37, vcc, v3, v49, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v36, s47 offset:112
		scratch_store_dword off, v37, s47 offset:116
		v_mov_b32_e32 v2, 0x800
		v_add_co_u32_e64 v36, vcc, v34, v2
		v_addc_co_u32_e64 v37, vcc, v35, 0, vcc
		v_add_co_u32_e64 v2, vcc, v36, v32
		v_addc_co_u32_e64 v3, vcc, v37, v33, vcc
		v_add_co_u32_e64 v36, vcc, v2, v56
		v_addc_co_u32_e64 v37, vcc, v3, v57, vcc
		v_add_co_u32_e64 v38, vcc, v36, v58
		v_addc_co_u32_e64 v39, vcc, v37, v59, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v38, s47 offset:120
		scratch_store_dword off, v39, s47 offset:124
		v_mov_b32_e32 v4, 0x900
		v_add_co_u32_e64 v36, vcc, v34, v4
		v_addc_co_u32_e64 v37, vcc, v35, 0, vcc
		v_add_co_u32_e64 v34, vcc, v36, v32
		v_addc_co_u32_e64 v35, vcc, v37, v33, vcc
		v_add_co_u32_e64 v32, vcc, v34, v56
		v_addc_co_u32_e64 v33, vcc, v35, v57, vcc
		v_add_co_u32_e64 v34, vcc, v32, v58
		v_addc_co_u32_e64 v35, vcc, v33, v59, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v34, s47 offset:128
		scratch_store_dword off, v35, s47 offset:132
		v_add_co_u32_e64 v32, vcc, v2, v40
		v_addc_co_u32_e64 v33, vcc, v3, v41, vcc
		v_add_co_u32_e64 v2, vcc, v32, v42
		v_addc_co_u32_e64 v3, vcc, v33, v43, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:136
		scratch_store_dword off, v3, s47 offset:140
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:648
		scratch_store_dword off, v33, s47 offset:652
		scratch_store_dword off, v34, s47 offset:656
		scratch_store_dword off, v35, s47 offset:660
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:632
		scratch_store_dword off, v33, s47 offset:636
		scratch_store_dword off, v34, s47 offset:640
		scratch_store_dword off, v35, s47 offset:644
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:616
		scratch_store_dword off, v33, s47 offset:620
		scratch_store_dword off, v34, s47 offset:624
		scratch_store_dword off, v35, s47 offset:628
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:600
		scratch_store_dword off, v33, s47 offset:604
		scratch_store_dword off, v34, s47 offset:608
		scratch_store_dword off, v35, s47 offset:612
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:584
		scratch_store_dword off, v33, s47 offset:588
		scratch_store_dword off, v34, s47 offset:592
		scratch_store_dword off, v35, s47 offset:596
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:568
		scratch_store_dword off, v33, s47 offset:572
		scratch_store_dword off, v34, s47 offset:576
		scratch_store_dword off, v35, s47 offset:580
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:552
		scratch_store_dword off, v33, s47 offset:556
		scratch_store_dword off, v34, s47 offset:560
		scratch_store_dword off, v35, s47 offset:564
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:536
		scratch_store_dword off, v33, s47 offset:540
		scratch_store_dword off, v34, s47 offset:544
		scratch_store_dword off, v35, s47 offset:548
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:520
		scratch_store_dword off, v33, s47 offset:524
		scratch_store_dword off, v34, s47 offset:528
		scratch_store_dword off, v35, s47 offset:532
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:504
		scratch_store_dword off, v33, s47 offset:508
		scratch_store_dword off, v34, s47 offset:512
		scratch_store_dword off, v35, s47 offset:516
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:488
		scratch_store_dword off, v33, s47 offset:492
		scratch_store_dword off, v34, s47 offset:496
		scratch_store_dword off, v35, s47 offset:500
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:472
		scratch_store_dword off, v33, s47 offset:476
		scratch_store_dword off, v34, s47 offset:480
		scratch_store_dword off, v35, s47 offset:484
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:456
		scratch_store_dword off, v33, s47 offset:460
		scratch_store_dword off, v34, s47 offset:464
		scratch_store_dword off, v35, s47 offset:468
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:440
		scratch_store_dword off, v33, s47 offset:444
		scratch_store_dword off, v34, s47 offset:448
		scratch_store_dword off, v35, s47 offset:452
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:424
		scratch_store_dword off, v33, s47 offset:428
		scratch_store_dword off, v34, s47 offset:432
		scratch_store_dword off, v35, s47 offset:436
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:408
		scratch_store_dword off, v33, s47 offset:412
		scratch_store_dword off, v34, s47 offset:416
		scratch_store_dword off, v35, s47 offset:420
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:392
		scratch_store_dword off, v33, s47 offset:396
		scratch_store_dword off, v34, s47 offset:400
		scratch_store_dword off, v35, s47 offset:404
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:376
		scratch_store_dword off, v33, s47 offset:380
		scratch_store_dword off, v34, s47 offset:384
		scratch_store_dword off, v35, s47 offset:388
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:360
		scratch_store_dword off, v33, s47 offset:364
		scratch_store_dword off, v34, s47 offset:368
		scratch_store_dword off, v35, s47 offset:372
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:344
		scratch_store_dword off, v33, s47 offset:348
		scratch_store_dword off, v34, s47 offset:352
		scratch_store_dword off, v35, s47 offset:356
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:328
		scratch_store_dword off, v33, s47 offset:332
		scratch_store_dword off, v34, s47 offset:336
		scratch_store_dword off, v35, s47 offset:340
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:312
		scratch_store_dword off, v33, s47 offset:316
		scratch_store_dword off, v34, s47 offset:320
		scratch_store_dword off, v35, s47 offset:324
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:296
		scratch_store_dword off, v33, s47 offset:300
		scratch_store_dword off, v34, s47 offset:304
		scratch_store_dword off, v35, s47 offset:308
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:280
		scratch_store_dword off, v33, s47 offset:284
		scratch_store_dword off, v34, s47 offset:288
		scratch_store_dword off, v35, s47 offset:292
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:264
		scratch_store_dword off, v33, s47 offset:268
		scratch_store_dword off, v34, s47 offset:272
		scratch_store_dword off, v35, s47 offset:276
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:248
		scratch_store_dword off, v33, s47 offset:252
		scratch_store_dword off, v34, s47 offset:256
		scratch_store_dword off, v35, s47 offset:260
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:232
		scratch_store_dword off, v33, s47 offset:236
		scratch_store_dword off, v34, s47 offset:240
		scratch_store_dword off, v35, s47 offset:244
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:216
		scratch_store_dword off, v33, s47 offset:220
		scratch_store_dword off, v34, s47 offset:224
		scratch_store_dword off, v35, s47 offset:228
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:200
		scratch_store_dword off, v33, s47 offset:204
		scratch_store_dword off, v34, s47 offset:208
		scratch_store_dword off, v35, s47 offset:212
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:160
		scratch_store_dword off, v33, s47 offset:164
		scratch_store_dword off, v34, s47 offset:168
		scratch_store_dword off, v35, s47 offset:172
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:144
		scratch_store_dword off, v33, s47 offset:148
		scratch_store_dword off, v34, s47 offset:152
		scratch_store_dword off, v35, s47 offset:156
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v2, s46
		v_mov_b32_e32 v3, 0
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x23000, v4
		s_waitcnt lgkmcnt(8)
		ds_read_b32 v32, v6
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x23800, v4
		ds_read_b32 v33, v6
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v34, v32, v2
		v_mul_hi_u32 v35, v32, v2
		v_mul_lo_u32 v4, v32, v3
		v_add_u32_e32 v35, v35, v4
		v_mul_lo_u32 v4, v33, v2
		v_add_u32_e32 v35, v35, v4
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v3, 0x22000, v2
		ds_read_b32 v2, v3
		v_lshlrev_b32_e32 v3, 2, v0
		v_add_u32_e32 v4, 0x22800, v3
		ds_read_b32 v3, v4
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v32, vcc, v2, v34
		v_addc_co_u32_e64 v33, vcc, v3, v35, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v3, 0x24000, v2
		ds_read_b32 v2, v3
		v_lshlrev_b32_e32 v3, 2, v0
		v_add_u32_e32 v4, 0x24800, v3
		ds_read_b32 v3, v4
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v36, vcc, v2, v34
		v_addc_co_u32_e64 v37, vcc, v3, v35, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v3, 0x25000, v2
		ds_read_b32 v2, v3
		v_lshlrev_b32_e32 v3, 2, v0
		v_add_u32_e32 v4, 0x25800, v3
		ds_read_b32 v3, v4
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v38, vcc, v2, v34
		v_addc_co_u32_e64 v39, vcc, v3, v35, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v3, 0x26000, v2
		ds_read_b32 v2, v3
		v_lshlrev_b32_e32 v3, 2, v0
		v_add_u32_e32 v4, 0x26800, v3
		ds_read_b32 v3, v4
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v40, vcc, v2, v34
		v_addc_co_u32_e64 v41, vcc, v3, v35, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v3, 0x27000, v2
		ds_read_b32 v2, v3
		v_lshlrev_b32_e32 v3, 2, v0
		v_add_u32_e32 v4, 0x27800, v3
		ds_read_b32 v3, v4
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v42, vcc, v2, v34
		v_addc_co_u32_e64 v43, vcc, v3, v35, vcc
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v2, off, s47
		scratch_load_dword v3, off, s47 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v44, vcc, v2, v34
		v_addc_co_u32_e64 v45, vcc, v3, v35, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:8
		scratch_load_dword v3, off, s47 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v46, vcc, v2, v34
		v_addc_co_u32_e64 v47, vcc, v3, v35, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:16
		scratch_load_dword v3, off, s47 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v48, vcc, v2, v34
		v_addc_co_u32_e64 v49, vcc, v3, v35, vcc
		v_mov_b32_e32 v2, s46
		v_mov_b32_e32 v3, 0
		s_mov_b32 s47, 0
		scratch_load_dword v50, off, s47 offset:32
		scratch_load_dword v51, off, s47 offset:36
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v52, v50, v2
		v_mul_hi_u32 v53, v50, v2
		v_mul_lo_u32 v4, v50, v3
		v_add_u32_e32 v53, v53, v4
		v_mul_lo_u32 v4, v51, v2
		v_add_u32_e32 v53, v53, v4
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:24
		scratch_load_dword v3, off, s47 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v50, vcc, v2, v52
		v_addc_co_u32_e64 v51, vcc, v3, v53, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:40
		scratch_load_dword v3, off, s47 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v54, vcc, v2, v52
		v_addc_co_u32_e64 v55, vcc, v3, v53, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:48
		scratch_load_dword v3, off, s47 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v56, vcc, v2, v52
		v_addc_co_u32_e64 v57, vcc, v3, v53, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v60, off, s47 offset:664
		scratch_load_dword v61, off, s47 offset:668
		scratch_load_dword v62, off, s47 offset:672
		scratch_load_dword v63, off, s47 offset:676
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v64, off, s47 offset:1212
		scratch_load_dword v65, off, s47 offset:1216
		scratch_load_dword v66, off, s47 offset:1220
		scratch_load_dword v67, off, s47 offset:1224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[12:15], v[64:67], v[60:63], v5, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s47, s46, 1
		s_lshl_b32 s48, s47, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s48, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v4, 6, v3
		v_lshlrev_b32_e32 v3, 4, v7
		v_add3_u32 v6, v2, v4, v3
		ds_read_b128 v[68:71], v6 offset:16384
		s_mov_b32 s49, 0
		scratch_load_dword v72, off, s49 offset:648
		scratch_load_dword v73, off, s49 offset:652
		scratch_load_dword v74, off, s49 offset:656
		scratch_load_dword v75, off, s49 offset:660
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v76, off, s49 offset:1196
		scratch_load_dword v77, off, s49 offset:1200
		scratch_load_dword v78, off, s49 offset:1204
		scratch_load_dword v79, off, s49 offset:1208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[12:15], v[76:79], v[72:75], v5, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v6 offset:17408
		s_mov_b32 s49, 0
		scratch_load_dword v84, off, s49 offset:632
		scratch_load_dword v85, off, s49 offset:636
		scratch_load_dword v86, off, s49 offset:640
		scratch_load_dword v87, off, s49 offset:644
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v88, off, s49 offset:1180
		scratch_load_dword v89, off, s49 offset:1184
		scratch_load_dword v90, off, s49 offset:1188
		scratch_load_dword v91, off, s49 offset:1192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[12:15], v[88:91], v[84:87], v5, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v6 offset:18432
		s_mov_b32 s49, 0
		scratch_load_dword v96, off, s49 offset:616
		scratch_load_dword v97, off, s49 offset:620
		scratch_load_dword v98, off, s49 offset:624
		scratch_load_dword v99, off, s49 offset:628
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v100, off, s49 offset:1164
		scratch_load_dword v101, off, s49 offset:1168
		scratch_load_dword v102, off, s49 offset:1172
		scratch_load_dword v103, off, s49 offset:1176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[12:15], v[100:103], v[96:99], v5, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v6 offset:19456
		s_mov_b32 s49, 0
		scratch_load_dword v108, off, s49 offset:600
		scratch_load_dword v109, off, s49 offset:604
		scratch_load_dword v110, off, s49 offset:608
		scratch_load_dword v111, off, s49 offset:612
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v112, off, s49 offset:1148
		scratch_load_dword v113, off, s49 offset:1152
		scratch_load_dword v114, off, s49 offset:1156
		scratch_load_dword v115, off, s49 offset:1160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[12:15], v[112:115], v[108:111], v5, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s48, v3
		v_lshlrev_b32_e32 v3, 13, v9
		v_lshlrev_b32_e32 v4, 4, v7
		v_add3_u32 v28, v2, v3, v4
		ds_read_b128 v[116:119], v28 offset:49152
		s_mov_b32 s48, 0
		scratch_load_dword v120, off, s48 offset:584
		scratch_load_dword v121, off, s48 offset:588
		scratch_load_dword v122, off, s48 offset:592
		scratch_load_dword v123, off, s48 offset:596
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v124, off, s48 offset:1132
		scratch_load_dword v125, off, s48 offset:1136
		scratch_load_dword v126, off, s48 offset:1140
		scratch_load_dword v127, off, s48 offset:1144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[12:15], v[124:127], v[120:123], v5, v29 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v28 offset:50176
		s_mov_b32 s48, 0
		scratch_load_dword v132, off, s48 offset:568
		scratch_load_dword v133, off, s48 offset:572
		scratch_load_dword v134, off, s48 offset:576
		scratch_load_dword v135, off, s48 offset:580
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v136, off, s48 offset:1116
		scratch_load_dword v137, off, s48 offset:1120
		scratch_load_dword v138, off, s48 offset:1124
		scratch_load_dword v139, off, s48 offset:1128
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[12:15], v[136:139], v[132:135], v5, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v28 offset:51200
		s_mov_b32 s48, 0
		scratch_load_dword v144, off, s48 offset:552
		scratch_load_dword v145, off, s48 offset:556
		scratch_load_dword v146, off, s48 offset:560
		scratch_load_dword v147, off, s48 offset:564
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v148, off, s48 offset:1100
		scratch_load_dword v149, off, s48 offset:1104
		scratch_load_dword v150, off, s48 offset:1108
		scratch_load_dword v151, off, s48 offset:1112
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[12:15], v[148:151], v[144:147], v5, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v28 offset:52224
		s_mov_b32 s48, 0
		scratch_load_dword v156, off, s48 offset:536
		scratch_load_dword v157, off, s48 offset:540
		scratch_load_dword v158, off, s48 offset:544
		scratch_load_dword v159, off, s48 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[64:67], v[156:159], v5, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v28 offset:53248
		s_mov_b32 s48, 0
		scratch_load_dword v164, off, s48 offset:520
		scratch_load_dword v165, off, s48 offset:524
		scratch_load_dword v166, off, s48 offset:528
		scratch_load_dword v167, off, s48 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[76:79], v[164:167], v5, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v28 offset:54272
		s_mov_b32 s48, 0
		scratch_load_dword v172, off, s48 offset:504
		scratch_load_dword v173, off, s48 offset:508
		scratch_load_dword v174, off, s48 offset:512
		scratch_load_dword v175, off, s48 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[88:91], v[172:175], v5, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v28 offset:55296
		s_mov_b32 s48, 0
		scratch_load_dword v180, off, s48 offset:488
		scratch_load_dword v181, off, s48 offset:492
		scratch_load_dword v182, off, s48 offset:496
		scratch_load_dword v183, off, s48 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[16:19], v[100:103], v[180:183], v5, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v28 offset:56320
		s_mov_b32 s48, 0
		scratch_load_dword v188, off, s48 offset:472
		scratch_load_dword v189, off, s48 offset:476
		scratch_load_dword v190, off, s48 offset:480
		scratch_load_dword v191, off, s48 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[16:19], v[112:115], v[188:191], v5, v29 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v32, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v192, off, s48 offset:456
		scratch_load_dword v193, off, s48 offset:460
		scratch_load_dword v194, off, s48 offset:464
		scratch_load_dword v195, off, s48 offset:468
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[16:19], v[124:127], v[192:195], v5, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v36, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v196, off, s48 offset:440
		scratch_load_dword v197, off, s48 offset:444
		scratch_load_dword v198, off, s48 offset:448
		scratch_load_dword v199, off, s48 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[16:19], v[136:139], v[196:199], v5, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v38, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v36, off, s48 offset:424
		scratch_load_dword v37, off, s48 offset:428
		scratch_load_dword v38, off, s48 offset:432
		scratch_load_dword v39, off, s48 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[16:19], v[148:151], v[36:39], v5, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v40, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v200, off, s48 offset:408
		scratch_load_dword v201, off, s48 offset:412
		scratch_load_dword v202, off, s48 offset:416
		scratch_load_dword v203, off, s48 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[20:23], v[64:67], v[200:203], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v42, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v40, off, s48 offset:392
		scratch_load_dword v41, off, s48 offset:396
		scratch_load_dword v42, off, s48 offset:400
		scratch_load_dword v43, off, s48 offset:404
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[20:23], v[76:79], v[40:43], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v44, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v204, off, s48 offset:376
		scratch_load_dword v205, off, s48 offset:380
		scratch_load_dword v206, off, s48 offset:384
		scratch_load_dword v207, off, s48 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], v[88:91], v[204:207], v8, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v46, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v44, off, s48 offset:360
		scratch_load_dword v45, off, s48 offset:364
		scratch_load_dword v46, off, s48 offset:368
		scratch_load_dword v47, off, s48 offset:372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[20:23], v[100:103], v[44:47], v8, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v48, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v208, off, s48 offset:344
		scratch_load_dword v209, off, s48 offset:348
		scratch_load_dword v210, off, s48 offset:352
		scratch_load_dword v211, off, s48 offset:356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[20:23], v[112:115], v[208:211], v8, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v50, s[4:7], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v48, off, s48 offset:328
		scratch_load_dword v49, off, s48 offset:332
		scratch_load_dword v50, off, s48 offset:336
		scratch_load_dword v51, off, s48 offset:340
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[20:23], v[124:127], v[48:51], v8, v29 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x20000
		s_nop 0
		buffer_load_dword v54, s[4:7], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:312
		scratch_load_dword v213, off, s48 offset:316
		scratch_load_dword v214, off, s48 offset:320
		scratch_load_dword v215, off, s48 offset:324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[20:23], v[136:139], v[212:215], v8, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x20000
		s_nop 0
		buffer_load_dwordx4 v56, s[24:27], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v56, off, s48 offset:296
		scratch_load_dword v57, off, s48 offset:300
		scratch_load_dword v58, off, s48 offset:304
		scratch_load_dword v59, off, s48 offset:308
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[20:23], v[148:151], v[56:59], v8, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[12:15], v6
		s_mov_b32 s48, 0
		scratch_load_dword v216, off, s48 offset:280
		scratch_load_dword v217, off, s48 offset:284
		scratch_load_dword v218, off, s48 offset:288
		scratch_load_dword v219, off, s48 offset:292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[64:67], v[216:219], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v6 offset:1024
		s_mov_b32 s48, 0
		scratch_load_dword v64, off, s48 offset:264
		scratch_load_dword v65, off, s48 offset:268
		scratch_load_dword v66, off, s48 offset:272
		scratch_load_dword v67, off, s48 offset:276
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[24:27], v[76:79], v[64:67], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v6 offset:2048
		s_mov_b32 s48, 0
		scratch_load_dword v76, off, s48 offset:248
		scratch_load_dword v77, off, s48 offset:252
		scratch_load_dword v78, off, s48 offset:256
		scratch_load_dword v79, off, s48 offset:260
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[24:27], v[88:91], v[76:79], v8, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v6 offset:3072
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s48 offset:680
		scratch_store_dword off, v89, s48 offset:684
		scratch_store_dword off, v90, s48 offset:688
		scratch_store_dword off, v91, s48 offset:692
		s_mov_b32 s48, 0
		scratch_store_dword off, v88, s48 offset:696
		scratch_store_dword off, v89, s48 offset:700
		scratch_store_dword off, v90, s48 offset:704
		scratch_store_dword off, v91, s48 offset:708
		s_mov_b32 s48, 0
		scratch_load_dword v88, off, s48 offset:232
		scratch_load_dword v89, off, s48 offset:236
		scratch_load_dword v90, off, s48 offset:240
		scratch_load_dword v91, off, s48 offset:244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[24:27], v[100:103], v[88:91], v8, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v28 offset:32768
		s_mov_b32 s48, 0
		scratch_load_dword v220, off, s48 offset:216
		scratch_load_dword v221, off, s48 offset:220
		scratch_load_dword v222, off, s48 offset:224
		scratch_load_dword v223, off, s48 offset:228
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], v[112:115], v[220:223], v8, v29 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v28 offset:33792
		s_mov_b32 s48, 0
		scratch_load_dword v224, off, s48 offset:200
		scratch_load_dword v225, off, s48 offset:204
		scratch_load_dword v226, off, s48 offset:208
		scratch_load_dword v227, off, s48 offset:212
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], v[124:127], v[224:227], v8, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v28 offset:34816
		s_mov_b32 s48, 0
		scratch_load_dword v228, off, s48 offset:160
		scratch_load_dword v229, off, s48 offset:164
		scratch_load_dword v230, off, s48 offset:168
		scratch_load_dword v231, off, s48 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[24:27], v[136:139], v[228:231], v8, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v28 offset:35840
		s_mov_b32 s48, 0
		scratch_load_dword v232, off, s48 offset:144
		scratch_load_dword v233, off, s48 offset:148
		scratch_load_dword v234, off, s48 offset:152
		scratch_load_dword v235, off, s48 offset:156
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[24:27], v[148:151], v[232:235], v8, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v28 offset:36864
		ds_read_b128 v[236:239], v28 offset:37888
		ds_read_b128 v[240:243], v28 offset:38912
		ds_read_b128 v[244:247], v28 offset:39936
		s_lshl_b32 s48, s47, 12
		s_add_i32 s47, s48, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v4, s47, v3, v2
		ds_read_b32 v2, v4
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s48 offset:196
		ds_read_b32 v2, v4 offset:256
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s48 offset:192
		v_lshlrev_b32_e32 v2, 10, v9
		v_lshlrev_b32_e32 v3, 2, v1
		v_add3_u32 v4, s47, v3, v2
		ds_read_b32 v2, v4 offset:2048
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:188
		ds_read_b32 v2, v4 offset:2304
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:184
		ds_read_b32 v2, v4 offset:2560
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:180
		ds_read_b32 v2, v4 offset:2816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[68:71], v[116:119], v[60:63], v5, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[68:71], v[128:131], v[72:75], v5, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[68:71], v[140:143], v[84:87], v5, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[68:71], v[152:155], v[96:99], v5, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[68:71], v[160:163], v[108:111], v5, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[168:171], v[120:123], v5, v29 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[176:179], v[132:135], v5, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[184:187], v[144:147], v5, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[80:83], v[116:119], v[156:159], v5, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[80:83], v[128:131], v[164:167], v5, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[80:83], v[140:143], v[172:175], v5, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[80:83], v[152:155], v[180:183], v5, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[80:83], v[160:163], v[188:191], v5, v29 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[80:83], v[168:171], v[192:195], v5, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[80:83], v[176:179], v[196:199], v5, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[80:83], v[184:187], v[36:39], v5, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[92:95], v[116:119], v[200:203], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[92:95], v[128:131], v[40:43], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[92:95], v[140:143], v[204:207], v8, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[92:95], v[152:155], v[44:47], v8, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[92:95], v[160:163], v[208:211], v8, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[92:95], v[168:171], v[48:51], v8, v29 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[92:95], v[176:179], v[212:215], v8, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[92:95], v[184:187], v[56:59], v8, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[104:107], v[116:119], v[216:219], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[104:107], v[128:131], v[64:67], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[104:107], v[140:143], v[76:79], v8, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[104:107], v[152:155], v[88:91], v8, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[104:107], v[160:163], v[220:223], v8, v29 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[104:107], v[168:171], v[224:227], v8, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[104:107], v[176:179], v[228:231], v8, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[104:107], v[184:187], v[232:235], v8, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s47, s46, 1
		s_and_b32 s48, s47, 1
		s_lshl_b32 s47, s48, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s47, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v4, 6, v3
		v_lshlrev_b32_e32 v3, 4, v7
		v_add3_u32 v6, v2, v4, v3
		s_mov_b32 s49, 0
		scratch_store_dword off, v6, s49 offset:1260
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v2, off, s49 offset:1260
		s_waitcnt vmcnt(0)
		ds_read_b128 v[68:71], v2
		s_mov_b32 s49, 0
		scratch_load_dword v2, off, s49 offset:1260
		s_waitcnt vmcnt(0)
		ds_read_b128 v[80:83], v2 offset:1024
		s_mov_b32 s49, 0
		scratch_load_dword v2, off, s49 offset:1260
		s_waitcnt vmcnt(0)
		ds_read_b128 v[92:95], v2 offset:2048
		s_mov_b32 s49, 0
		scratch_load_dword v2, off, s49 offset:1260
		s_waitcnt vmcnt(0)
		ds_read_b128 v[104:107], v2 offset:3072
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s47, v3
		v_lshlrev_b32_e32 v3, 13, v9
		v_lshlrev_b32_e32 v4, 4, v7
		v_add3_u32 v6, v2, v3, v4
		ds_read_b128 v[116:119], v6 offset:32768
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v116, s47 offset:1068
		scratch_store_dword off, v117, s47 offset:1072
		scratch_store_dword off, v118, s47 offset:1076
		scratch_store_dword off, v119, s47 offset:1080
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:1084
		scratch_store_dword off, v117, s47 offset:1088
		scratch_store_dword off, v118, s47 offset:1092
		scratch_store_dword off, v119, s47 offset:1096
		ds_read_b128 v[116:119], v6 offset:33792
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v116, s47 offset:1036
		scratch_store_dword off, v117, s47 offset:1040
		scratch_store_dword off, v118, s47 offset:1044
		scratch_store_dword off, v119, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:1052
		scratch_store_dword off, v117, s47 offset:1056
		scratch_store_dword off, v118, s47 offset:1060
		scratch_store_dword off, v119, s47 offset:1064
		ds_read_b128 v[116:119], v6 offset:34816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v116, s47 offset:1004
		scratch_store_dword off, v117, s47 offset:1008
		scratch_store_dword off, v118, s47 offset:1012
		scratch_store_dword off, v119, s47 offset:1016
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:1020
		scratch_store_dword off, v117, s47 offset:1024
		scratch_store_dword off, v118, s47 offset:1028
		scratch_store_dword off, v119, s47 offset:1032
		ds_read_b128 v[116:119], v6 offset:35840
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v116, s47 offset:972
		scratch_store_dword off, v117, s47 offset:976
		scratch_store_dword off, v118, s47 offset:980
		scratch_store_dword off, v119, s47 offset:984
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:988
		scratch_store_dword off, v117, s47 offset:992
		scratch_store_dword off, v118, s47 offset:996
		scratch_store_dword off, v119, s47 offset:1000
		ds_read_b128 v[116:119], v6 offset:36864
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v116, s47 offset:904
		scratch_store_dword off, v117, s47 offset:908
		scratch_store_dword off, v118, s47 offset:912
		scratch_store_dword off, v119, s47 offset:916
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:920
		scratch_store_dword off, v117, s47 offset:924
		scratch_store_dword off, v118, s47 offset:928
		scratch_store_dword off, v119, s47 offset:932
		ds_read_b128 v[116:119], v6 offset:37888
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v116, s47 offset:848
		scratch_store_dword off, v117, s47 offset:852
		scratch_store_dword off, v118, s47 offset:856
		scratch_store_dword off, v119, s47 offset:860
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:864
		scratch_store_dword off, v117, s47 offset:868
		scratch_store_dword off, v118, s47 offset:872
		scratch_store_dword off, v119, s47 offset:876
		ds_read_b128 v[116:119], v6 offset:38912
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v116, s47 offset:792
		scratch_store_dword off, v117, s47 offset:796
		scratch_store_dword off, v118, s47 offset:800
		scratch_store_dword off, v119, s47 offset:804
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:808
		scratch_store_dword off, v117, s47 offset:812
		scratch_store_dword off, v118, s47 offset:816
		scratch_store_dword off, v119, s47 offset:820
		ds_read_b128 v[116:119], v6 offset:39936
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v116, s47 offset:736
		scratch_store_dword off, v117, s47 offset:740
		scratch_store_dword off, v118, s47 offset:744
		scratch_store_dword off, v119, s47 offset:748
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:752
		scratch_store_dword off, v117, s47 offset:756
		scratch_store_dword off, v118, s47 offset:760
		scratch_store_dword off, v119, s47 offset:764
		s_lshl_b32 s47, s48, 12
		s_add_i32 s48, s47, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v4, s48, v3, v2
		ds_read_b32 v2, v4
		ds_read_b32 v3, v4 offset:256
		v_lshlrev_b32_e32 v4, 10, v9
		v_lshlrev_b32_e32 v28, 2, v1
		v_add3_u32 v31, s48, v28, v4
		ds_read_b32 v4, v31 offset:2048
		ds_read_b32 v28, v31 offset:2304
		ds_read_b32 v32, v31 offset:2560
		ds_read_b32 v33, v31 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s47, 0
		scratch_load_dword v54, off, s47 offset:56
		scratch_load_dword v55, off, s47 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v54, v34
		v_addc_co_u32_e64 v117, vcc, v55, v35, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:724
		scratch_store_dword off, v117, s47 offset:728
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v54, off, s47 offset:724
		scratch_load_dword v55, off, s47 offset:728
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v54, s47 offset:732
		s_mov_b32 s47, 0
		scratch_load_dword v54, off, s47 offset:64
		scratch_load_dword v55, off, s47 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v54, v34
		v_addc_co_u32_e64 v117, vcc, v55, v35, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:712
		scratch_store_dword off, v117, s47 offset:716
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v54, off, s47 offset:712
		scratch_load_dword v55, off, s47 offset:716
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v54, s47 offset:720
		s_mov_b32 s47, 0
		scratch_load_dword v54, off, s47 offset:72
		scratch_load_dword v55, off, s47 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v54, v34
		v_addc_co_u32_e64 v117, vcc, v55, v35, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:780
		scratch_store_dword off, v117, s47 offset:784
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v54, off, s47 offset:780
		scratch_load_dword v55, off, s47 offset:784
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v54, s47 offset:788
		s_mov_b32 s47, 0
		scratch_load_dword v54, off, s47 offset:80
		scratch_load_dword v55, off, s47 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v54, v34
		v_addc_co_u32_e64 v117, vcc, v55, v35, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:768
		scratch_store_dword off, v117, s47 offset:772
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v54, off, s47 offset:768
		scratch_load_dword v55, off, s47 offset:772
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v54, s47 offset:776
		s_mov_b32 s47, 0
		scratch_load_dword v54, off, s47 offset:88
		scratch_load_dword v55, off, s47 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v54, v34
		v_addc_co_u32_e64 v117, vcc, v55, v35, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:836
		scratch_store_dword off, v117, s47 offset:840
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v54, off, s47 offset:836
		scratch_load_dword v55, off, s47 offset:840
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v54, s47 offset:844
		s_mov_b32 s47, 0
		scratch_load_dword v54, off, s47 offset:96
		scratch_load_dword v55, off, s47 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v54, v34
		v_addc_co_u32_e64 v117, vcc, v55, v35, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:824
		scratch_store_dword off, v117, s47 offset:828
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v54, off, s47 offset:824
		scratch_load_dword v55, off, s47 offset:828
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v54, s47 offset:832
		s_mov_b32 s47, 0
		scratch_load_dword v54, off, s47 offset:104
		scratch_load_dword v55, off, s47 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v54, v34
		v_addc_co_u32_e64 v117, vcc, v55, v35, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:892
		scratch_store_dword off, v117, s47 offset:896
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v54, off, s47 offset:892
		scratch_load_dword v55, off, s47 offset:896
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v54, s47 offset:900
		s_mov_b32 s47, 0
		scratch_load_dword v54, off, s47 offset:112
		scratch_load_dword v55, off, s47 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v54, v34
		v_addc_co_u32_e64 v117, vcc, v55, v35, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:880
		scratch_store_dword off, v117, s47 offset:884
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v34, off, s47 offset:880
		scratch_load_dword v35, off, s47 offset:884
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v34, s47 offset:888
		s_mov_b32 s47, 0
		scratch_load_dword v34, off, s47 offset:120
		scratch_load_dword v35, off, s47 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v54, vcc, v34, v52
		v_addc_co_u32_e64 v55, vcc, v35, v53, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v54, s47 offset:960
		scratch_store_dword off, v55, s47 offset:964
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v34, off, s47 offset:960
		scratch_load_dword v35, off, s47 offset:964
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v34, s47 offset:968
		s_mov_b32 s47, 0
		scratch_load_dword v34, off, s47 offset:128
		scratch_load_dword v35, off, s47 offset:132
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v54, vcc, v34, v52
		v_addc_co_u32_e64 v55, vcc, v35, v53, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v54, s47 offset:948
		scratch_store_dword off, v55, s47 offset:952
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v34, off, s47 offset:948
		scratch_load_dword v35, off, s47 offset:952
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v34, s47 offset:956
		s_mov_b32 s47, 0
		scratch_load_dword v34, off, s47 offset:136
		scratch_load_dword v35, off, s47 offset:140
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v54, vcc, v34, v52
		v_addc_co_u32_e64 v55, vcc, v35, v53, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v54, s47 offset:936
		scratch_store_dword off, v55, s47 offset:940
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v34, off, s47 offset:936
		scratch_load_dword v35, off, s47 offset:940
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v34, s47 offset:944
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1084
		scratch_load_dword v53, off, s47 offset:1088
		scratch_load_dword v54, off, s47 offset:1092
		scratch_load_dword v55, off, s47 offset:1096
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[68:71], v[52:55], v[60:63], v2, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v31, off, s47 offset:1260
		s_waitcnt vmcnt(0)
		ds_read_b128 v[52:55], v31 offset:16384
		s_mov_b32 s47, 0
		scratch_load_dword v116, off, s47 offset:1052
		scratch_load_dword v117, off, s47 offset:1056
		scratch_load_dword v118, off, s47 offset:1060
		scratch_load_dword v119, off, s47 offset:1064
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[68:71], v[116:119], v[72:75], v2, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v31, off, s47 offset:1260
		s_waitcnt vmcnt(0)
		ds_read_b128 v[116:119], v31 offset:17408
		s_mov_b32 s47, 0
		scratch_load_dword v128, off, s47 offset:1020
		scratch_load_dword v129, off, s47 offset:1024
		scratch_load_dword v130, off, s47 offset:1028
		scratch_load_dword v131, off, s47 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[68:71], v[128:131], v[84:87], v2, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v31, off, s47 offset:1260
		s_waitcnt vmcnt(0)
		ds_read_b128 v[128:131], v31 offset:18432
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v128, s47 offset:1456
		scratch_store_dword off, v129, s47 offset:1460
		scratch_store_dword off, v130, s47 offset:1464
		scratch_store_dword off, v131, s47 offset:1468
		s_mov_b32 s47, 0
		scratch_store_dword off, v128, s47 offset:1472
		scratch_store_dword off, v129, s47 offset:1476
		scratch_store_dword off, v130, s47 offset:1480
		scratch_store_dword off, v131, s47 offset:1484
		s_mov_b32 s47, 0
		scratch_load_dword v128, off, s47 offset:988
		scratch_load_dword v129, off, s47 offset:992
		scratch_load_dword v130, off, s47 offset:996
		scratch_load_dword v131, off, s47 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[68:71], v[128:131], v[96:99], v2, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v31, off, s47 offset:1260
		s_waitcnt vmcnt(0)
		ds_read_b128 v[128:131], v31 offset:19456
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v128, s47 offset:1228
		scratch_store_dword off, v129, s47 offset:1232
		scratch_store_dword off, v130, s47 offset:1236
		scratch_store_dword off, v131, s47 offset:1240
		s_mov_b32 s47, 0
		scratch_store_dword off, v128, s47 offset:1244
		scratch_store_dword off, v129, s47 offset:1248
		scratch_store_dword off, v130, s47 offset:1252
		scratch_store_dword off, v131, s47 offset:1256
		s_mov_b32 s47, 0
		scratch_load_dword v128, off, s47 offset:920
		scratch_load_dword v129, off, s47 offset:924
		scratch_load_dword v130, off, s47 offset:928
		scratch_load_dword v131, off, s47 offset:932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[68:71], v[128:131], v[108:111], v2, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v6 offset:49152
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v128, s47 offset:1296
		scratch_store_dword off, v129, s47 offset:1300
		scratch_store_dword off, v130, s47 offset:1304
		scratch_store_dword off, v131, s47 offset:1308
		s_mov_b32 s47, 0
		scratch_store_dword off, v128, s47 offset:1312
		scratch_store_dword off, v129, s47 offset:1316
		scratch_store_dword off, v130, s47 offset:1320
		scratch_store_dword off, v131, s47 offset:1324
		s_mov_b32 s47, 0
		scratch_load_dword v128, off, s47 offset:864
		scratch_load_dword v129, off, s47 offset:868
		scratch_load_dword v130, off, s47 offset:872
		scratch_load_dword v131, off, s47 offset:876
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[128:131], v[120:123], v2, v32 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v6 offset:50176
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v128, s47 offset:1264
		scratch_store_dword off, v129, s47 offset:1268
		scratch_store_dword off, v130, s47 offset:1272
		scratch_store_dword off, v131, s47 offset:1276
		s_mov_b32 s47, 0
		scratch_store_dword off, v128, s47 offset:1280
		scratch_store_dword off, v129, s47 offset:1284
		scratch_store_dword off, v130, s47 offset:1288
		scratch_store_dword off, v131, s47 offset:1292
		s_mov_b32 s47, 0
		scratch_load_dword v128, off, s47 offset:808
		scratch_load_dword v129, off, s47 offset:812
		scratch_load_dword v130, off, s47 offset:816
		scratch_load_dword v131, off, s47 offset:820
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[128:131], v[132:135], v2, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v6 offset:51200
		s_mov_b32 s47, 0
		scratch_load_dword v140, off, s47 offset:752
		scratch_load_dword v141, off, s47 offset:756
		scratch_load_dword v142, off, s47 offset:760
		scratch_load_dword v143, off, s47 offset:764
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[140:143], v[144:147], v2, v33 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v6 offset:52224
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v68, s47 offset:1360
		scratch_store_dword off, v69, s47 offset:1364
		scratch_store_dword off, v70, s47 offset:1368
		scratch_store_dword off, v71, s47 offset:1372
		s_mov_b32 s47, 0
		scratch_store_dword off, v68, s47 offset:1376
		scratch_store_dword off, v69, s47 offset:1380
		scratch_store_dword off, v70, s47 offset:1384
		scratch_store_dword off, v71, s47 offset:1388
		s_mov_b32 s47, 0
		scratch_load_dword v68, off, s47 offset:1084
		scratch_load_dword v69, off, s47 offset:1088
		scratch_load_dword v70, off, s47 offset:1092
		scratch_load_dword v71, off, s47 offset:1096
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[80:83], v[68:71], v[156:159], v2, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v6 offset:53248
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v68, s47 offset:1328
		scratch_store_dword off, v69, s47 offset:1332
		scratch_store_dword off, v70, s47 offset:1336
		scratch_store_dword off, v71, s47 offset:1340
		s_mov_b32 s47, 0
		scratch_store_dword off, v68, s47 offset:1344
		scratch_store_dword off, v69, s47 offset:1348
		scratch_store_dword off, v70, s47 offset:1352
		scratch_store_dword off, v71, s47 offset:1356
		s_mov_b32 s47, 0
		scratch_load_dword v68, off, s47 offset:1052
		scratch_load_dword v69, off, s47 offset:1056
		scratch_load_dword v70, off, s47 offset:1060
		scratch_load_dword v71, off, s47 offset:1064
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[80:83], v[68:71], v[164:167], v2, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v6 offset:54272
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v68, s47 offset:1424
		scratch_store_dword off, v69, s47 offset:1428
		scratch_store_dword off, v70, s47 offset:1432
		scratch_store_dword off, v71, s47 offset:1436
		s_mov_b32 s47, 0
		scratch_store_dword off, v68, s47 offset:1440
		scratch_store_dword off, v69, s47 offset:1444
		scratch_store_dword off, v70, s47 offset:1448
		scratch_store_dword off, v71, s47 offset:1452
		s_mov_b32 s47, 0
		scratch_load_dword v68, off, s47 offset:1020
		scratch_load_dword v69, off, s47 offset:1024
		scratch_load_dword v70, off, s47 offset:1028
		scratch_load_dword v71, off, s47 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[80:83], v[68:71], v[172:175], v2, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v6 offset:55296
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v68, s47 offset:1392
		scratch_store_dword off, v69, s47 offset:1396
		scratch_store_dword off, v70, s47 offset:1400
		scratch_store_dword off, v71, s47 offset:1404
		s_mov_b32 s47, 0
		scratch_store_dword off, v68, s47 offset:1408
		scratch_store_dword off, v69, s47 offset:1412
		scratch_store_dword off, v70, s47 offset:1416
		scratch_store_dword off, v71, s47 offset:1420
		s_mov_b32 s47, 0
		scratch_load_dword v68, off, s47 offset:988
		scratch_load_dword v69, off, s47 offset:992
		scratch_load_dword v70, off, s47 offset:996
		scratch_load_dword v71, off, s47 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[80:83], v[68:71], v[180:183], v2, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v6 offset:56320
		s_mov_b32 s47, 0
		scratch_load_dword v140, off, s47 offset:920
		scratch_load_dword v141, off, s47 offset:924
		scratch_load_dword v142, off, s47 offset:928
		scratch_load_dword v143, off, s47 offset:932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[80:83], v[140:143], v[188:191], v2, v32 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:732
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v140, off, s47 offset:864
		scratch_load_dword v141, off, s47 offset:868
		scratch_load_dword v142, off, s47 offset:872
		scratch_load_dword v143, off, s47 offset:876
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[80:83], v[140:143], v[192:195], v2, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:720
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v140, off, s47 offset:808
		scratch_load_dword v141, off, s47 offset:812
		scratch_load_dword v142, off, s47 offset:816
		scratch_load_dword v143, off, s47 offset:820
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[80:83], v[140:143], v[196:199], v2, v33 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:788
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v140, off, s47 offset:752
		scratch_load_dword v141, off, s47 offset:756
		scratch_load_dword v142, off, s47 offset:760
		scratch_load_dword v143, off, s47 offset:764
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[80:83], v[140:143], v[36:39], v2, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:776
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1084
		scratch_load_dword v81, off, s47 offset:1088
		scratch_load_dword v82, off, s47 offset:1092
		scratch_load_dword v83, off, s47 offset:1096
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[92:95], v[80:83], v[200:203], v3, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:844
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1052
		scratch_load_dword v81, off, s47 offset:1056
		scratch_load_dword v82, off, s47 offset:1060
		scratch_load_dword v83, off, s47 offset:1064
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[92:95], v[80:83], v[40:43], v3, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:832
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1020
		scratch_load_dword v81, off, s47 offset:1024
		scratch_load_dword v82, off, s47 offset:1028
		scratch_load_dword v83, off, s47 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[92:95], v[80:83], v[204:207], v3, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s43
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:900
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:988
		scratch_load_dword v81, off, s47 offset:992
		scratch_load_dword v82, off, s47 offset:996
		scratch_load_dword v83, off, s47 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[92:95], v[80:83], v[44:47], v3, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:888
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:920
		scratch_load_dword v81, off, s47 offset:924
		scratch_load_dword v82, off, s47 offset:928
		scratch_load_dword v83, off, s47 offset:932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[92:95], v[80:83], v[208:211], v3, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:968
		s_waitcnt vmcnt(0)
		buffer_load_dword v6, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:864
		scratch_load_dword v81, off, s47 offset:868
		scratch_load_dword v82, off, s47 offset:872
		scratch_load_dword v83, off, s47 offset:876
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[92:95], v[80:83], v[48:51], v3, v32 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:956
		s_waitcnt vmcnt(0)
		buffer_load_dword v6, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:808
		scratch_load_dword v81, off, s47 offset:812
		scratch_load_dword v82, off, s47 offset:816
		scratch_load_dword v83, off, s47 offset:820
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[92:95], v[80:83], v[212:215], v3, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v6, off, s47 offset:944
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:752
		scratch_load_dword v81, off, s47 offset:756
		scratch_load_dword v82, off, s47 offset:760
		scratch_load_dword v83, off, s47 offset:764
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[92:95], v[80:83], v[56:59], v3, v33 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1084
		scratch_load_dword v81, off, s47 offset:1088
		scratch_load_dword v82, off, s47 offset:1092
		scratch_load_dword v83, off, s47 offset:1096
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[104:107], v[80:83], v[216:219], v3, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1052
		scratch_load_dword v81, off, s47 offset:1056
		scratch_load_dword v82, off, s47 offset:1060
		scratch_load_dword v83, off, s47 offset:1064
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[104:107], v[80:83], v[64:67], v3, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1020
		scratch_load_dword v81, off, s47 offset:1024
		scratch_load_dword v82, off, s47 offset:1028
		scratch_load_dword v83, off, s47 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[104:107], v[80:83], v[76:79], v3, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:988
		scratch_load_dword v81, off, s47 offset:992
		scratch_load_dword v82, off, s47 offset:996
		scratch_load_dword v83, off, s47 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[104:107], v[80:83], v[88:91], v3, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:920
		scratch_load_dword v81, off, s47 offset:924
		scratch_load_dword v82, off, s47 offset:928
		scratch_load_dword v83, off, s47 offset:932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[104:107], v[80:83], v[220:223], v3, v32 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:864
		scratch_load_dword v81, off, s47 offset:868
		scratch_load_dword v82, off, s47 offset:872
		scratch_load_dword v83, off, s47 offset:876
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[104:107], v[80:83], v[224:227], v3, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:808
		scratch_load_dword v81, off, s47 offset:812
		scratch_load_dword v82, off, s47 offset:816
		scratch_load_dword v83, off, s47 offset:820
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[104:107], v[80:83], v[228:231], v3, v33 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:752
		scratch_load_dword v81, off, s47 offset:756
		scratch_load_dword v82, off, s47 offset:760
		scratch_load_dword v83, off, s47 offset:764
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[104:107], v[80:83], v[232:235], v3, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v80, off, s47 offset:1312
		scratch_load_dword v81, off, s47 offset:1316
		scratch_load_dword v82, off, s47 offset:1320
		scratch_load_dword v83, off, s47 offset:1324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[52:55], v[80:83], v[60:63], v2, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v80, off, s47 offset:1280
		scratch_load_dword v81, off, s47 offset:1284
		scratch_load_dword v82, off, s47 offset:1288
		scratch_load_dword v83, off, s47 offset:1292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[52:55], v[80:83], v[72:75], v2, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[52:55], v[128:131], v[84:87], v2, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v80, off, s47 offset:1376
		scratch_load_dword v81, off, s47 offset:1380
		scratch_load_dword v82, off, s47 offset:1384
		scratch_load_dword v83, off, s47 offset:1388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[52:55], v[80:83], v[96:99], v2, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v80, off, s47 offset:1344
		scratch_load_dword v81, off, s47 offset:1348
		scratch_load_dword v82, off, s47 offset:1352
		scratch_load_dword v83, off, s47 offset:1356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[52:55], v[80:83], v[108:111], v2, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v80, off, s47 offset:1440
		scratch_load_dword v81, off, s47 offset:1444
		scratch_load_dword v82, off, s47 offset:1448
		scratch_load_dword v83, off, s47 offset:1452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[52:55], v[80:83], v[120:123], v2, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v80, off, s47 offset:1408
		scratch_load_dword v81, off, s47 offset:1412
		scratch_load_dword v82, off, s47 offset:1416
		scratch_load_dword v83, off, s47 offset:1420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[52:55], v[80:83], v[132:135], v2, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[52:55], v[68:71], v[144:147], v2, v33 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1312
		scratch_load_dword v53, off, s47 offset:1316
		scratch_load_dword v54, off, s47 offset:1320
		scratch_load_dword v55, off, s47 offset:1324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[116:119], v[52:55], v[156:159], v2, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1280
		scratch_load_dword v53, off, s47 offset:1284
		scratch_load_dword v54, off, s47 offset:1288
		scratch_load_dword v55, off, s47 offset:1292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[116:119], v[52:55], v[164:167], v2, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[116:119], v[128:131], v[172:175], v2, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1376
		scratch_load_dword v53, off, s47 offset:1380
		scratch_load_dword v54, off, s47 offset:1384
		scratch_load_dword v55, off, s47 offset:1388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[116:119], v[52:55], v[180:183], v2, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1344
		scratch_load_dword v53, off, s47 offset:1348
		scratch_load_dword v54, off, s47 offset:1352
		scratch_load_dword v55, off, s47 offset:1356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[116:119], v[52:55], v[188:191], v2, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1440
		scratch_load_dword v53, off, s47 offset:1444
		scratch_load_dword v54, off, s47 offset:1448
		scratch_load_dword v55, off, s47 offset:1452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[116:119], v[52:55], v[192:195], v2, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1408
		scratch_load_dword v53, off, s47 offset:1412
		scratch_load_dword v54, off, s47 offset:1416
		scratch_load_dword v55, off, s47 offset:1420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[116:119], v[52:55], v[196:199], v2, v33 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[116:119], v[68:71], v[36:39], v2, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1312
		scratch_load_dword v53, off, s47 offset:1316
		scratch_load_dword v54, off, s47 offset:1320
		scratch_load_dword v55, off, s47 offset:1324
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1472
		scratch_load_dword v81, off, s47 offset:1476
		scratch_load_dword v82, off, s47 offset:1480
		scratch_load_dword v83, off, s47 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[80:83], v[52:55], v[200:203], v3, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1280
		scratch_load_dword v53, off, s47 offset:1284
		scratch_load_dword v54, off, s47 offset:1288
		scratch_load_dword v55, off, s47 offset:1292
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1472
		scratch_load_dword v81, off, s47 offset:1476
		scratch_load_dword v82, off, s47 offset:1480
		scratch_load_dword v83, off, s47 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[80:83], v[52:55], v[40:43], v3, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1472
		scratch_load_dword v53, off, s47 offset:1476
		scratch_load_dword v54, off, s47 offset:1480
		scratch_load_dword v55, off, s47 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], v[128:131], v[204:207], v3, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1376
		scratch_load_dword v53, off, s47 offset:1380
		scratch_load_dword v54, off, s47 offset:1384
		scratch_load_dword v55, off, s47 offset:1388
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1472
		scratch_load_dword v81, off, s47 offset:1476
		scratch_load_dword v82, off, s47 offset:1480
		scratch_load_dword v83, off, s47 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[80:83], v[52:55], v[44:47], v3, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1344
		scratch_load_dword v53, off, s47 offset:1348
		scratch_load_dword v54, off, s47 offset:1352
		scratch_load_dword v55, off, s47 offset:1356
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1472
		scratch_load_dword v81, off, s47 offset:1476
		scratch_load_dword v82, off, s47 offset:1480
		scratch_load_dword v83, off, s47 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[80:83], v[52:55], v[208:211], v3, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1440
		scratch_load_dword v53, off, s47 offset:1444
		scratch_load_dword v54, off, s47 offset:1448
		scratch_load_dword v55, off, s47 offset:1452
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1472
		scratch_load_dword v81, off, s47 offset:1476
		scratch_load_dword v82, off, s47 offset:1480
		scratch_load_dword v83, off, s47 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[80:83], v[52:55], v[48:51], v3, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1408
		scratch_load_dword v53, off, s47 offset:1412
		scratch_load_dword v54, off, s47 offset:1416
		scratch_load_dword v55, off, s47 offset:1420
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1472
		scratch_load_dword v81, off, s47 offset:1476
		scratch_load_dword v82, off, s47 offset:1480
		scratch_load_dword v83, off, s47 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[80:83], v[52:55], v[212:215], v3, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1472
		scratch_load_dword v53, off, s47 offset:1476
		scratch_load_dword v54, off, s47 offset:1480
		scratch_load_dword v55, off, s47 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[52:55], v[68:71], v[56:59], v3, v33 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1244
		scratch_load_dword v53, off, s47 offset:1248
		scratch_load_dword v54, off, s47 offset:1252
		scratch_load_dword v55, off, s47 offset:1256
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1312
		scratch_load_dword v81, off, s47 offset:1316
		scratch_load_dword v82, off, s47 offset:1320
		scratch_load_dword v83, off, s47 offset:1324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], v[80:83], v[216:219], v3, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1244
		scratch_load_dword v53, off, s47 offset:1248
		scratch_load_dword v54, off, s47 offset:1252
		scratch_load_dword v55, off, s47 offset:1256
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1280
		scratch_load_dword v81, off, s47 offset:1284
		scratch_load_dword v82, off, s47 offset:1288
		scratch_load_dword v83, off, s47 offset:1292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[52:55], v[80:83], v[64:67], v3, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1244
		scratch_load_dword v53, off, s47 offset:1248
		scratch_load_dword v54, off, s47 offset:1252
		scratch_load_dword v55, off, s47 offset:1256
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[52:55], v[128:131], v[76:79], v3, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1244
		scratch_load_dword v53, off, s47 offset:1248
		scratch_load_dword v54, off, s47 offset:1252
		scratch_load_dword v55, off, s47 offset:1256
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1376
		scratch_load_dword v81, off, s47 offset:1380
		scratch_load_dword v82, off, s47 offset:1384
		scratch_load_dword v83, off, s47 offset:1388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[52:55], v[80:83], v[88:91], v3, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1244
		scratch_load_dword v53, off, s47 offset:1248
		scratch_load_dword v54, off, s47 offset:1252
		scratch_load_dword v55, off, s47 offset:1256
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1344
		scratch_load_dword v81, off, s47 offset:1348
		scratch_load_dword v82, off, s47 offset:1352
		scratch_load_dword v83, off, s47 offset:1356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], v[80:83], v[220:223], v3, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1244
		scratch_load_dword v53, off, s47 offset:1248
		scratch_load_dword v54, off, s47 offset:1252
		scratch_load_dword v55, off, s47 offset:1256
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1440
		scratch_load_dword v81, off, s47 offset:1444
		scratch_load_dword v82, off, s47 offset:1448
		scratch_load_dword v83, off, s47 offset:1452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[52:55], v[80:83], v[224:227], v3, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1244
		scratch_load_dword v53, off, s47 offset:1248
		scratch_load_dword v54, off, s47 offset:1252
		scratch_load_dword v55, off, s47 offset:1256
		s_mov_b32 s47, 0
		scratch_load_dword v80, off, s47 offset:1408
		scratch_load_dword v81, off, s47 offset:1412
		scratch_load_dword v82, off, s47 offset:1416
		scratch_load_dword v83, off, s47 offset:1420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[52:55], v[80:83], v[228:231], v3, v33 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v52, off, s47 offset:1244
		scratch_load_dword v53, off, s47 offset:1248
		scratch_load_dword v54, off, s47 offset:1252
		scratch_load_dword v55, off, s47 offset:1256
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], v[68:71], v[232:235], v3, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s46, s46, 2
		s_cmp_lt_i32 s46, s11
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:696
		scratch_load_dword v33, off, s47 offset:700
		scratch_load_dword v34, off, s47 offset:704
		scratch_load_dword v35, off, s47 offset:708
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v24, v32
		v_mov_b32_e32 v25, v33
		v_mov_b32_e32 v26, v34
		v_mov_b32_e32 v27, v35
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:196
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v5, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:192
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v8, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:188
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v10, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:184
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v11, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:180
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v29, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:176
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v30, v2
		s_mov_b32 s47, 0
		scratch_store_dword off, v40, s47 offset:392
		scratch_store_dword off, v41, s47 offset:396
		scratch_store_dword off, v42, s47 offset:400
		scratch_store_dword off, v43, s47 offset:404
		s_mov_b32 s47, 0
		scratch_store_dword off, v204, s47 offset:376
		scratch_store_dword off, v205, s47 offset:380
		scratch_store_dword off, v206, s47 offset:384
		scratch_store_dword off, v207, s47 offset:388
		s_mov_b32 s47, 0
		scratch_store_dword off, v44, s47 offset:360
		scratch_store_dword off, v45, s47 offset:364
		scratch_store_dword off, v46, s47 offset:368
		scratch_store_dword off, v47, s47 offset:372
		s_mov_b32 s47, 0
		scratch_store_dword off, v208, s47 offset:344
		scratch_store_dword off, v209, s47 offset:348
		scratch_store_dword off, v210, s47 offset:352
		scratch_store_dword off, v211, s47 offset:356
		s_mov_b32 s47, 0
		scratch_store_dword off, v48, s47 offset:328
		scratch_store_dword off, v49, s47 offset:332
		scratch_store_dword off, v50, s47 offset:336
		scratch_store_dword off, v51, s47 offset:340
		s_mov_b32 s47, 0
		scratch_store_dword off, v212, s47 offset:312
		scratch_store_dword off, v213, s47 offset:316
		scratch_store_dword off, v214, s47 offset:320
		scratch_store_dword off, v215, s47 offset:324
		s_mov_b32 s47, 0
		scratch_store_dword off, v56, s47 offset:296
		scratch_store_dword off, v57, s47 offset:300
		scratch_store_dword off, v58, s47 offset:304
		scratch_store_dword off, v59, s47 offset:308
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:280
		scratch_store_dword off, v217, s47 offset:284
		scratch_store_dword off, v218, s47 offset:288
		scratch_store_dword off, v219, s47 offset:292
		s_mov_b32 s47, 0
		scratch_store_dword off, v64, s47 offset:264
		scratch_store_dword off, v65, s47 offset:268
		scratch_store_dword off, v66, s47 offset:272
		scratch_store_dword off, v67, s47 offset:276
		s_mov_b32 s47, 0
		scratch_store_dword off, v76, s47 offset:248
		scratch_store_dword off, v77, s47 offset:252
		scratch_store_dword off, v78, s47 offset:256
		scratch_store_dword off, v79, s47 offset:260
		s_mov_b32 s47, 0
		scratch_store_dword off, v88, s47 offset:232
		scratch_store_dword off, v89, s47 offset:236
		scratch_store_dword off, v90, s47 offset:240
		scratch_store_dword off, v91, s47 offset:244
		s_mov_b32 s47, 0
		scratch_store_dword off, v220, s47 offset:216
		scratch_store_dword off, v221, s47 offset:220
		scratch_store_dword off, v222, s47 offset:224
		scratch_store_dword off, v223, s47 offset:228
		s_mov_b32 s47, 0
		scratch_store_dword off, v224, s47 offset:200
		scratch_store_dword off, v225, s47 offset:204
		scratch_store_dword off, v226, s47 offset:208
		scratch_store_dword off, v227, s47 offset:212
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:160
		scratch_store_dword off, v229, s47 offset:164
		scratch_store_dword off, v230, s47 offset:168
		scratch_store_dword off, v231, s47 offset:172
		s_mov_b32 s47, 0
		scratch_store_dword off, v232, s47 offset:144
		scratch_store_dword off, v233, s47 offset:148
		scratch_store_dword off, v234, s47 offset:152
		scratch_store_dword off, v235, s47 offset:156
		s_mov_b32 s47, 0
		scratch_store_dword off, v60, s47 offset:664
		scratch_store_dword off, v61, s47 offset:668
		scratch_store_dword off, v62, s47 offset:672
		scratch_store_dword off, v63, s47 offset:676
		s_mov_b32 s47, 0
		scratch_store_dword off, v72, s47 offset:648
		scratch_store_dword off, v73, s47 offset:652
		scratch_store_dword off, v74, s47 offset:656
		scratch_store_dword off, v75, s47 offset:660
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:632
		scratch_store_dword off, v85, s47 offset:636
		scratch_store_dword off, v86, s47 offset:640
		scratch_store_dword off, v87, s47 offset:644
		s_mov_b32 s47, 0
		scratch_store_dword off, v96, s47 offset:616
		scratch_store_dword off, v97, s47 offset:620
		scratch_store_dword off, v98, s47 offset:624
		scratch_store_dword off, v99, s47 offset:628
		s_mov_b32 s47, 0
		scratch_store_dword off, v108, s47 offset:600
		scratch_store_dword off, v109, s47 offset:604
		scratch_store_dword off, v110, s47 offset:608
		scratch_store_dword off, v111, s47 offset:612
		s_mov_b32 s47, 0
		scratch_store_dword off, v120, s47 offset:584
		scratch_store_dword off, v121, s47 offset:588
		scratch_store_dword off, v122, s47 offset:592
		scratch_store_dword off, v123, s47 offset:596
		s_mov_b32 s47, 0
		scratch_store_dword off, v132, s47 offset:568
		scratch_store_dword off, v133, s47 offset:572
		scratch_store_dword off, v134, s47 offset:576
		scratch_store_dword off, v135, s47 offset:580
		s_mov_b32 s47, 0
		scratch_store_dword off, v144, s47 offset:552
		scratch_store_dword off, v145, s47 offset:556
		scratch_store_dword off, v146, s47 offset:560
		scratch_store_dword off, v147, s47 offset:564
		s_mov_b32 s47, 0
		scratch_store_dword off, v156, s47 offset:536
		scratch_store_dword off, v157, s47 offset:540
		scratch_store_dword off, v158, s47 offset:544
		scratch_store_dword off, v159, s47 offset:548
		s_mov_b32 s47, 0
		scratch_store_dword off, v164, s47 offset:520
		scratch_store_dword off, v165, s47 offset:524
		scratch_store_dword off, v166, s47 offset:528
		scratch_store_dword off, v167, s47 offset:532
		s_mov_b32 s47, 0
		scratch_store_dword off, v172, s47 offset:504
		scratch_store_dword off, v173, s47 offset:508
		scratch_store_dword off, v174, s47 offset:512
		scratch_store_dword off, v175, s47 offset:516
		s_mov_b32 s47, 0
		scratch_store_dword off, v180, s47 offset:488
		scratch_store_dword off, v181, s47 offset:492
		scratch_store_dword off, v182, s47 offset:496
		scratch_store_dword off, v183, s47 offset:500
		s_mov_b32 s47, 0
		scratch_store_dword off, v188, s47 offset:472
		scratch_store_dword off, v189, s47 offset:476
		scratch_store_dword off, v190, s47 offset:480
		scratch_store_dword off, v191, s47 offset:484
		s_mov_b32 s47, 0
		scratch_store_dword off, v192, s47 offset:456
		scratch_store_dword off, v193, s47 offset:460
		scratch_store_dword off, v194, s47 offset:464
		scratch_store_dword off, v195, s47 offset:468
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:440
		scratch_store_dword off, v197, s47 offset:444
		scratch_store_dword off, v198, s47 offset:448
		scratch_store_dword off, v199, s47 offset:452
		s_mov_b32 s47, 0
		scratch_store_dword off, v36, s47 offset:424
		scratch_store_dword off, v37, s47 offset:428
		scratch_store_dword off, v38, s47 offset:432
		scratch_store_dword off, v39, s47 offset:436
		s_mov_b32 s47, 0
		scratch_store_dword off, v200, s47 offset:408
		scratch_store_dword off, v201, s47 offset:412
		scratch_store_dword off, v202, s47 offset:416
		scratch_store_dword off, v203, s47 offset:420
		s_mov_b32 s47, 0
		scratch_store_dword off, v100, s47 offset:1212
		scratch_store_dword off, v101, s47 offset:1216
		scratch_store_dword off, v102, s47 offset:1220
		scratch_store_dword off, v103, s47 offset:1224
		s_mov_b32 s47, 0
		scratch_store_dword off, v112, s47 offset:1196
		scratch_store_dword off, v113, s47 offset:1200
		scratch_store_dword off, v114, s47 offset:1204
		scratch_store_dword off, v115, s47 offset:1208
		s_mov_b32 s47, 0
		scratch_store_dword off, v124, s47 offset:1180
		scratch_store_dword off, v125, s47 offset:1184
		scratch_store_dword off, v126, s47 offset:1188
		scratch_store_dword off, v127, s47 offset:1192
		s_mov_b32 s47, 0
		scratch_store_dword off, v136, s47 offset:1164
		scratch_store_dword off, v137, s47 offset:1168
		scratch_store_dword off, v138, s47 offset:1172
		scratch_store_dword off, v139, s47 offset:1176
		s_mov_b32 s47, 0
		scratch_store_dword off, v148, s47 offset:1148
		scratch_store_dword off, v149, s47 offset:1152
		scratch_store_dword off, v150, s47 offset:1156
		scratch_store_dword off, v151, s47 offset:1160
		s_mov_b32 s47, 0
		scratch_store_dword off, v236, s47 offset:1132
		scratch_store_dword off, v237, s47 offset:1136
		scratch_store_dword off, v238, s47 offset:1140
		scratch_store_dword off, v239, s47 offset:1144
		s_mov_b32 s47, 0
		scratch_store_dword off, v240, s47 offset:1116
		scratch_store_dword off, v241, s47 offset:1120
		scratch_store_dword off, v242, s47 offset:1124
		scratch_store_dword off, v243, s47 offset:1128
		s_mov_b32 s47, 0
		scratch_store_dword off, v244, s47 offset:1100
		scratch_store_dword off, v245, s47 offset:1104
		scratch_store_dword off, v246, s47 offset:1108
		scratch_store_dword off, v247, s47 offset:1112
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v32, off, s0 offset:1212
		scratch_load_dword v33, off, s0 offset:1216
		scratch_load_dword v34, off, s0 offset:1220
		scratch_load_dword v35, off, s0 offset:1224
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v36, off, s0 offset:1196
		scratch_load_dword v37, off, s0 offset:1200
		scratch_load_dword v38, off, s0 offset:1204
		scratch_load_dword v39, off, s0 offset:1208
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v40, off, s0 offset:1180
		scratch_load_dword v41, off, s0 offset:1184
		scratch_load_dword v42, off, s0 offset:1188
		scratch_load_dword v43, off, s0 offset:1192
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v44, off, s0 offset:1164
		scratch_load_dword v45, off, s0 offset:1168
		scratch_load_dword v46, off, s0 offset:1172
		scratch_load_dword v47, off, s0 offset:1176
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v48, off, s0 offset:1148
		scratch_load_dword v49, off, s0 offset:1152
		scratch_load_dword v50, off, s0 offset:1156
		scratch_load_dword v51, off, s0 offset:1160
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v52, off, s0 offset:1132
		scratch_load_dword v53, off, s0 offset:1136
		scratch_load_dword v54, off, s0 offset:1140
		scratch_load_dword v55, off, s0 offset:1144
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v56, off, s0 offset:1116
		scratch_load_dword v57, off, s0 offset:1120
		scratch_load_dword v58, off, s0 offset:1124
		scratch_load_dword v59, off, s0 offset:1128
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v60, off, s0 offset:1100
		scratch_load_dword v61, off, s0 offset:1104
		scratch_load_dword v62, off, s0 offset:1108
		scratch_load_dword v63, off, s0 offset:1112
		s_mov_b32 s0, 0
		scratch_load_dword v64, off, s0 offset:664
		scratch_load_dword v65, off, s0 offset:668
		scratch_load_dword v66, off, s0 offset:672
		scratch_load_dword v67, off, s0 offset:676
		s_mov_b32 s0, 0
		scratch_load_dword v68, off, s0 offset:648
		scratch_load_dword v69, off, s0 offset:652
		scratch_load_dword v70, off, s0 offset:656
		scratch_load_dword v71, off, s0 offset:660
		s_mov_b32 s0, 0
		scratch_load_dword v72, off, s0 offset:632
		scratch_load_dword v73, off, s0 offset:636
		scratch_load_dword v74, off, s0 offset:640
		scratch_load_dword v75, off, s0 offset:644
		s_mov_b32 s0, 0
		scratch_load_dword v76, off, s0 offset:616
		scratch_load_dword v77, off, s0 offset:620
		scratch_load_dword v78, off, s0 offset:624
		scratch_load_dword v79, off, s0 offset:628
		s_mov_b32 s0, 0
		scratch_load_dword v80, off, s0 offset:600
		scratch_load_dword v81, off, s0 offset:604
		scratch_load_dword v82, off, s0 offset:608
		scratch_load_dword v83, off, s0 offset:612
		s_mov_b32 s0, 0
		scratch_load_dword v84, off, s0 offset:584
		scratch_load_dword v85, off, s0 offset:588
		scratch_load_dword v86, off, s0 offset:592
		scratch_load_dword v87, off, s0 offset:596
		s_mov_b32 s0, 0
		scratch_load_dword v88, off, s0 offset:568
		scratch_load_dword v89, off, s0 offset:572
		scratch_load_dword v90, off, s0 offset:576
		scratch_load_dword v91, off, s0 offset:580
		s_mov_b32 s0, 0
		scratch_load_dword v92, off, s0 offset:552
		scratch_load_dword v93, off, s0 offset:556
		scratch_load_dword v94, off, s0 offset:560
		scratch_load_dword v95, off, s0 offset:564
		s_mov_b32 s0, 0
		scratch_load_dword v96, off, s0 offset:536
		scratch_load_dword v97, off, s0 offset:540
		scratch_load_dword v98, off, s0 offset:544
		scratch_load_dword v99, off, s0 offset:548
		s_mov_b32 s0, 0
		scratch_load_dword v100, off, s0 offset:520
		scratch_load_dword v101, off, s0 offset:524
		scratch_load_dword v102, off, s0 offset:528
		scratch_load_dword v103, off, s0 offset:532
		s_mov_b32 s0, 0
		scratch_load_dword v104, off, s0 offset:504
		scratch_load_dword v105, off, s0 offset:508
		scratch_load_dword v106, off, s0 offset:512
		scratch_load_dword v107, off, s0 offset:516
		s_mov_b32 s0, 0
		scratch_load_dword v108, off, s0 offset:488
		scratch_load_dword v109, off, s0 offset:492
		scratch_load_dword v110, off, s0 offset:496
		scratch_load_dword v111, off, s0 offset:500
		s_mov_b32 s0, 0
		scratch_load_dword v112, off, s0 offset:472
		scratch_load_dword v113, off, s0 offset:476
		scratch_load_dword v114, off, s0 offset:480
		scratch_load_dword v115, off, s0 offset:484
		s_mov_b32 s0, 0
		scratch_load_dword v116, off, s0 offset:456
		scratch_load_dword v117, off, s0 offset:460
		scratch_load_dword v118, off, s0 offset:464
		scratch_load_dword v119, off, s0 offset:468
		s_mov_b32 s0, 0
		scratch_load_dword v120, off, s0 offset:440
		scratch_load_dword v121, off, s0 offset:444
		scratch_load_dword v122, off, s0 offset:448
		scratch_load_dword v123, off, s0 offset:452
		s_mov_b32 s0, 0
		scratch_load_dword v124, off, s0 offset:424
		scratch_load_dword v125, off, s0 offset:428
		scratch_load_dword v126, off, s0 offset:432
		scratch_load_dword v127, off, s0 offset:436
		s_mov_b32 s0, 0
		scratch_load_dword v128, off, s0 offset:408
		scratch_load_dword v129, off, s0 offset:412
		scratch_load_dword v130, off, s0 offset:416
		scratch_load_dword v131, off, s0 offset:420
		s_mov_b32 s0, 0
		scratch_load_dword v132, off, s0 offset:392
		scratch_load_dword v133, off, s0 offset:396
		scratch_load_dword v134, off, s0 offset:400
		scratch_load_dword v135, off, s0 offset:404
		s_mov_b32 s0, 0
		scratch_load_dword v136, off, s0 offset:376
		scratch_load_dword v137, off, s0 offset:380
		scratch_load_dword v138, off, s0 offset:384
		scratch_load_dword v139, off, s0 offset:388
		s_mov_b32 s0, 0
		scratch_load_dword v140, off, s0 offset:360
		scratch_load_dword v141, off, s0 offset:364
		scratch_load_dword v142, off, s0 offset:368
		scratch_load_dword v143, off, s0 offset:372
		s_mov_b32 s0, 0
		scratch_load_dword v144, off, s0 offset:344
		scratch_load_dword v145, off, s0 offset:348
		scratch_load_dword v146, off, s0 offset:352
		scratch_load_dword v147, off, s0 offset:356
		s_mov_b32 s0, 0
		scratch_load_dword v148, off, s0 offset:328
		scratch_load_dword v149, off, s0 offset:332
		scratch_load_dword v150, off, s0 offset:336
		scratch_load_dword v151, off, s0 offset:340
		s_mov_b32 s0, 0
		scratch_load_dword v152, off, s0 offset:312
		scratch_load_dword v153, off, s0 offset:316
		scratch_load_dword v154, off, s0 offset:320
		scratch_load_dword v155, off, s0 offset:324
		s_mov_b32 s0, 0
		scratch_load_dword v156, off, s0 offset:296
		scratch_load_dword v157, off, s0 offset:300
		scratch_load_dword v158, off, s0 offset:304
		scratch_load_dword v159, off, s0 offset:308
		s_mov_b32 s0, 0
		scratch_load_dword v160, off, s0 offset:280
		scratch_load_dword v161, off, s0 offset:284
		scratch_load_dword v162, off, s0 offset:288
		scratch_load_dword v163, off, s0 offset:292
		s_mov_b32 s0, 0
		scratch_load_dword v164, off, s0 offset:264
		scratch_load_dword v165, off, s0 offset:268
		scratch_load_dword v166, off, s0 offset:272
		scratch_load_dword v167, off, s0 offset:276
		s_mov_b32 s0, 0
		scratch_load_dword v168, off, s0 offset:248
		scratch_load_dword v169, off, s0 offset:252
		scratch_load_dword v170, off, s0 offset:256
		scratch_load_dword v171, off, s0 offset:260
		s_mov_b32 s0, 0
		scratch_load_dword v172, off, s0 offset:232
		scratch_load_dword v173, off, s0 offset:236
		scratch_load_dword v174, off, s0 offset:240
		scratch_load_dword v175, off, s0 offset:244
		s_mov_b32 s0, 0
		scratch_load_dword v176, off, s0 offset:216
		scratch_load_dword v177, off, s0 offset:220
		scratch_load_dword v178, off, s0 offset:224
		scratch_load_dword v179, off, s0 offset:228
		s_mov_b32 s0, 0
		scratch_load_dword v180, off, s0 offset:200
		scratch_load_dword v181, off, s0 offset:204
		scratch_load_dword v182, off, s0 offset:208
		scratch_load_dword v183, off, s0 offset:212
		s_mov_b32 s0, 0
		scratch_load_dword v184, off, s0 offset:160
		scratch_load_dword v185, off, s0 offset:164
		scratch_load_dword v186, off, s0 offset:168
		scratch_load_dword v187, off, s0 offset:172
		s_mov_b32 s0, 0
		scratch_load_dword v188, off, s0 offset:144
		scratch_load_dword v189, off, s0 offset:148
		scratch_load_dword v190, off, s0 offset:152
		scratch_load_dword v191, off, s0 offset:156
		s_add_i32 s0, s12, -1
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[12:15], v[32:35], v[64:67], v5, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s0, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v4, 6, v3
		v_lshlrev_b32_e32 v3, 4, v7
		v_add3_u32 v6, v2, v4, v3
		ds_read_b128 v[192:195], v6 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[12:15], v[36:39], v[68:71], v5, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v6 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[12:15], v[40:43], v[72:75], v5, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v6 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[12:15], v[44:47], v[76:79], v5, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v6 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[12:15], v[48:51], v[80:83], v5, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s0, v3
		v_lshlrev_b32_e32 v3, 13, v9
		v_lshlrev_b32_e32 v4, 4, v7
		v_add3_u32 v6, v2, v3, v4
		ds_read_b128 v[208:211], v6 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[12:15], v[52:55], v[84:87], v5, v29 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v6 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[12:15], v[56:59], v[88:91], v5, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v6 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[12:15], v[60:63], v[92:95], v5, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v6 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], v[32:35], v[96:99], v5, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[16:19], v[36:39], v[100:103], v5, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v6 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[16:19], v[40:43], v[104:107], v5, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v6 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[16:19], v[44:47], v[108:111], v5, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v6 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[16:19], v[48:51], v[112:115], v5, v29 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[52:55], v[116:119], v5, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[56:59], v[120:123], v5, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[60:63], v[124:127], v5, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(60)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[32:35], v[128:131], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(56)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[36:39], v[132:135], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(52)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[40:43], v[136:139], v8, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(48)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[44:47], v[140:143], v8, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[48:51], v[144:147], v8, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(40)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[52:55], v[148:151], v8, v29 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[56:59], v[152:155], v8, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(32)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[60:63], v[156:159], v8, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(28)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[32:35], v[160:163], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(24)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[36:39], v[164:167], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[40:43], v[168:171], v8, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(16)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[44:47], v[172:175], v8, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[48:51], v[176:179], v8, v29 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[52:55], v[180:183], v8, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[56:59], v[184:187], v8, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[60:63], v[188:191], v8, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[192:195], v[208:211], v[64:67], v5, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[192:195], v[212:215], v[68:71], v5, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[192:195], v[216:219], v[72:75], v5, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[192:195], v[12:15], v[76:79], v5, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[192:195], v[220:223], v[80:83], v5, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[192:195], v[224:227], v[84:87], v5, v29 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[192:195], v[228:231], v[88:91], v5, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[192:195], v[232:235], v[92:95], v5, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[196:199], v[208:211], v[96:99], v5, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[196:199], v[212:215], v[100:103], v5, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[196:199], v[216:219], v[104:107], v5, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[196:199], v[12:15], v[108:111], v5, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[196:199], v[220:223], v[112:115], v5, v29 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[196:199], v[224:227], v[116:119], v5, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[196:199], v[228:231], v[120:123], v5, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[196:199], v[232:235], v[124:127], v5, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[200:203], v[208:211], v[128:131], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[200:203], v[212:215], v[132:135], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[200:203], v[216:219], v[136:139], v8, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[200:203], v[12:15], v[140:143], v8, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[200:203], v[220:223], v[144:147], v8, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[200:203], v[224:227], v[148:151], v8, v29 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[200:203], v[228:231], v[152:155], v8, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[200:203], v[232:235], v[156:159], v8, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[204:207], v[208:211], v[160:163], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[204:207], v[212:215], v[164:167], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[204:207], v[216:219], v[168:171], v8, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[204:207], v[12:15], v[172:175], v8, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[204:207], v[220:223], v[176:179], v8, v29 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[204:207], v[224:227], v[180:183], v8, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[204:207], v[228:231], v[184:187], v8, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[204:207], v[232:235], v[188:191], v8, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s1, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v4, 6, v3
		v_lshlrev_b32_e32 v3, 4, v7
		v_add3_u32 v5, v2, v4, v3
		ds_read_b128 v[12:15], v5
		ds_read_b128 v[16:19], v5 offset:1024
		ds_read_b128 v[20:23], v5 offset:2048
		ds_read_b128 v[24:27], v5 offset:3072
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s1, v3
		v_lshlrev_b32_e32 v3, 13, v9
		v_lshlrev_b32_e32 v4, 4, v7
		v_add3_u32 v6, v2, v3, v4
		ds_read_b128 v[28:31], v6 offset:32768
		ds_read_b128 v[32:35], v6 offset:33792
		ds_read_b128 v[36:39], v6 offset:34816
		ds_read_b128 v[40:43], v6 offset:35840
		ds_read_b128 v[44:47], v6 offset:36864
		ds_read_b128 v[48:51], v6 offset:37888
		ds_read_b128 v[52:55], v6 offset:38912
		ds_read_b128 v[56:59], v6 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v4, s0, v3, v2
		ds_read_b32 v2, v4
		ds_read_b32 v3, v4 offset:256
		v_lshlrev_b32_e32 v4, 10, v9
		v_lshlrev_b32_e32 v7, 2, v1
		v_add3_u32 v1, s0, v7, v4
		ds_read_b32 v4, v1 offset:2048
		ds_read_b32 v7, v1 offset:2304
		ds_read_b32 v8, v1 offset:2560
		ds_read_b32 v9, v1 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[12:15], v[28:31], v[64:67], v2, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[60:63], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[12:15], v[32:35], v[68:71], v2, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v5 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[12:15], v[36:39], v[72:75], v2, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[12:15], v[40:43], v[76:79], v2, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v5 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[12:15], v[44:47], v[80:83], v2, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v6 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[12:15], v[48:51], v[84:87], v2, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v6 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[12:15], v[52:55], v[88:91], v2, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v6 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[12:15], v[56:59], v[92:95], v2, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v6 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], v[28:31], v[96:99], v2, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v6 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[16:19], v[32:35], v[100:103], v2, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[16:19], v[36:39], v[104:107], v2, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v6 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[16:19], v[40:43], v[108:111], v2, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v6 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[16:19], v[44:47], v[112:115], v2, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[48:51], v[116:119], v2, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v2, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v2, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[28:31], v[128:131], v3, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[32:35], v[132:135], v3, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[36:39], v[136:139], v3, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[40:43], v[140:143], v3, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[44:47], v[144:147], v3, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v3, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v3, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v3, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[28:31], v[160:163], v3, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[32:35], v[164:167], v3, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[36:39], v[168:171], v3, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[40:43], v[172:175], v3, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[44:47], v[176:179], v3, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v3, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v3, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v3, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[60:63], v[204:207], v[64:67], v2, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[60:63], v[208:211], v[68:71], v2, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[60:63], v[212:215], v[72:75], v2, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[60:63], v[12:15], v[76:79], v2, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[60:63], v[216:219], v[80:83], v2, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[60:63], v[220:223], v[84:87], v2, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[60:63], v[224:227], v[88:91], v2, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[60:63], v[228:231], v[92:95], v2, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[192:195], v[204:207], v[96:99], v2, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[192:195], v[208:211], v[100:103], v2, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[192:195], v[212:215], v[104:107], v2, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[192:195], v[12:15], v[108:111], v2, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[192:195], v[216:219], v[112:115], v2, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[192:195], v[220:223], v[116:119], v2, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[192:195], v[224:227], v[120:123], v2, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[192:195], v[228:231], v[124:127], v2, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[196:199], v[204:207], v[128:131], v3, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[196:199], v[208:211], v[132:135], v3, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[196:199], v[212:215], v[136:139], v3, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[196:199], v[12:15], v[140:143], v3, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[196:199], v[216:219], v[144:147], v3, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[196:199], v[220:223], v[148:151], v3, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[196:199], v[224:227], v[152:155], v3, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[196:199], v[228:231], v[156:159], v3, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[200:203], v[204:207], v[160:163], v3, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[200:203], v[208:211], v[164:167], v3, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[200:203], v[212:215], v[168:171], v3, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[200:203], v[12:15], v[172:175], v3, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[200:203], v[216:219], v[176:179], v3, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[200:203], v[220:223], v[180:183], v3, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[200:203], v[224:227], v[184:187], v3, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[200:203], v[228:231], v[188:191], v3, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v0, 3, v1
		v_accvgpr_read_b32 v1, a0
		v_lshl_add_u32 v4, v1, 14, v0
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v0, v68, v69
		v_cvt_pk_f16_f32 v1, v70, v71
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v72, v73
		v_cvt_pk_f16_f32 v1, v74, v75
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v92, v93
		v_cvt_pk_f16_f32 v1, v94, v95
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v104, v105
		v_cvt_pk_f16_f32 v1, v106, v107
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v152, v153
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v160, v161
		v_cvt_pk_f16_f32 v1, v162, v163
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 1488
		.amdhsa_kernarg_size 48
		.amdhsa_user_sgpr_count 13
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 11
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 1
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 249
		.amdhsa_next_free_sgpr 50
		.amdhsa_accum_offset 248
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 248
	.set .Lwmma_f16_matmul_tiled.num_agpr, 1
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 50
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 1488
	.set .Lwmma_f16_matmul_tiled.uses_vcc, 1
	.set .Lwmma_f16_matmul_tiled.uses_flat_scratch, 1
	.set .Lwmma_f16_matmul_tiled.has_dyn_sized_stack, 0
	.set .Lwmma_f16_matmul_tiled.has_recursion, 0
	.set .Lwmma_f16_matmul_tiled.has_indirect_call, 0
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
      - .address_space:  global
        .name:           arg4
        .offset:         32
        .size:           8
        .value_kind:     global_buffer
      - .name:           arg5
        .offset:         40
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 24576
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 1488
    .sgpr_count:     50
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     249
    .agpr_count:     1
    .vgpr_spill_count: 532
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
