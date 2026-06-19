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
		s_mov_b32 s16, s10
		s_mov_b32 s17, s11
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s26, 0x1000000
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, 0x1000000
		s_mov_b32 s31, 0x31016000
		s_lshr_b32 s32, s13, 3
		s_lshl_b32 s33, s14, 1
		s_add_i32 s34, s33, s32
		s_and_b32 s32, s13, 7
		s_lshl_b32 s33, s32, 5
		s_add_i32 s32, s34, s33
		s_lshr_b32 s33, s32, 6
		s_lshl_b32 s34, s33, 23
		s_and_b32 s35, s32, 63
		s_lshr_b32 s32, s35, 2
		s_lshl_b32 s36, s32, 17
		s_add_i32 s37, s34, s36
		s_and_b32 s34, s35, 3
		s_lshl_b32 s35, s34, 21
		s_add_i32 s36, s37, s35
		s_add_u32 s38, s6, s36
		s_addc_u32 s39, s7, 0
		s_mov_b32 s40, s38
		s_mov_b32 s41, s39
		s_mov_b32 s42, 0x20000
		s_mov_b32 s43, 0x31016000
		v_readfirstlane_b32 s35, v0
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_lshr_b32 s36, s35, 6
		s_lshl_b32 s37, s36, 10
		s_mov_b32 m0, s37
		s_lshl_b32 s38, s33, 22
		s_lshl_b32 s39, s34, 20
		s_add_i32 s44, s38, s39
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s44, v2
		v_and_b32_e32 v8, 63, v0
		v_lshrrev_b32_e32 v9, 2, v8
		v_lshlrev_b32_e32 v10, 12, v9
		v_lshrrev_b32_e32 v9, 3, v8
		v_and_b32_e32 v11, 3, v9
		v_and_b32_e32 v12, 3, v8
		v_xor_b32_e32 v13, v11, v12
		v_lshlrev_b32_e32 v11, 4, v13
		v_add3_u32 v12, v3, v10, v11
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_add_i32 s45, s37, 0x2000
		s_mov_b32 m0, s45
		s_add_i32 s45, s38, 0x80000
		s_add_i32 s46, s45, s39
		v_add_u32_e32 v3, s46, v2
		v_add3_u32 v12, v3, v10, v11
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_add_i32 s45, s37, 0x4000
		s_mov_b32 m0, s45
		s_add_i32 s45, s38, 64
		s_add_i32 s47, s45, s39
		v_add_u32_e32 v3, s47, v2
		v_add3_u32 v12, v3, v10, v11
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_add_i32 s45, s37, 0x6000
		s_mov_b32 m0, s45
		s_add_i32 s45, s38, 0x80040
		s_add_i32 s48, s45, s39
		v_add_u32_e32 v3, s48, v2
		v_add3_u32 v12, v3, v10, v11
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_add_i32 s45, s37, 0x8000
		s_mov_b32 m0, s45
		s_lshl_b32 s45, s32, 20
		v_add_u32_e32 v3, s45, v2
		v_add3_u32 v12, v3, v10, v11
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 s49, s37, 0xa000
		s_mov_b32 m0, s49
		s_add_i32 s49, s45, 0x80000
		v_add_u32_e32 v3, s49, v2
		v_add3_u32 v12, v3, v10, v11
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 s50, s37, 0xc000
		s_mov_b32 m0, s50
		s_add_i32 s50, s45, 64
		v_add_u32_e32 v3, s50, v2
		v_add3_u32 v12, v3, v10, v11
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 s51, s37, 0xe000
		s_mov_b32 m0, s51
		s_add_i32 s51, s45, 0x80040
		v_add_u32_e32 v3, s51, v2
		v_add3_u32 v12, v3, v10, v11
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_mov_b32_e32 v3, 1
		v_mov_b32_e32 v12, 39
		v_and_b32_e32 v13, v0, v12
		v_and_or_b32 v12, v1, v3, v13
		s_mov_b32 s52, 0
		v_cmp_eq_u32_e64 vcc, v12, s52
		s_mov_b64 s[54:55], vcc
		s_lshl_b32 s53, s33, 10
		s_lshr_b32 s33, s35, 7
		s_lshl_b32 s35, s33, 6
		s_add_i32 s56, s53, s35
		s_lshl_b32 s57, s34, 8
		s_add_i32 s34, s56, s57
		v_lshlrev_b32_e32 v3, 12, v9
		v_add_u32_e32 v9, s34, v3
		v_mov_b32_e32 v12, 0x7fffffff
		v_cndmask_b32_e64 v14, v12, v9, s[54:55]
		s_lshl_b32 s56, s33, 9
		s_add_i32 s33, s56, 0x20000
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 s33, s53, 16
		s_add_i32 s58, s33, s35
		s_add_i32 s33, s58, s57
		v_add_u32_e32 v9, s33, v3
		v_cndmask_b32_e64 v14, v12, v9, s[54:55]
		s_add_i32 s58, s56, 0x20010
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 s58, s53, 32
		s_add_i32 s59, s58, s35
		s_add_i32 s58, s59, s57
		v_add_u32_e32 v9, s58, v3
		v_cndmask_b32_e64 v14, v12, v9, s[54:55]
		s_add_i32 s59, s56, 0x20020
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 s59, s53, 48
		s_add_i32 s60, s59, s35
		s_add_i32 s59, s60, s57
		v_add_u32_e32 v9, s59, v3
		v_cndmask_b32_e64 v14, v12, v9, s[54:55]
		s_add_i32 s60, s56, 0x20030
		s_mov_b32 m0, s60
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_lshrrev_b32_e32 v9, 1, v1
		v_or_b32_e32 v14, v13, v9
		v_cmp_eq_u32_e64 vcc, v14, s52
		s_mov_b64 s[60:61], vcc
		s_lshl_b32 s62, s32, 8
		s_and_b32 s32, s36, 1
		s_lshl_b32 s36, s32, 7
		s_add_i32 s63, s62, s36
		v_add_u32_e32 v9, s63, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_lshl_b32 s64, s32, 10
		s_add_i32 s32, s64, 0x20800
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 16
		s_add_i32 s65, s32, s36
		v_add_u32_e32 v9, s65, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x20810
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 32
		s_add_i32 s66, s32, s36
		v_add_u32_e32 v9, s66, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x20820
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 48
		s_add_i32 s67, s32, s36
		v_add_u32_e32 v9, s67, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x20830
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 64
		s_add_i32 s68, s32, s36
		v_add_u32_e32 v9, s68, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x20a00
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x50
		s_add_i32 s69, s32, s36
		v_add_u32_e32 v9, s69, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x20a10
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x60
		s_add_i32 s70, s32, s36
		v_add_u32_e32 v9, s70, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x20a20
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x70
		s_add_i32 s71, s32, s36
		v_add_u32_e32 v9, s71, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x20a30
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s53, 0x4000
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x21000
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0x4010
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x21010
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0x4020
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x21020
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0x4030
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x21030
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s62, 0x4000
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x21800
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x4010
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x21810
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x4020
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x21820
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x4030
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x21830
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x4040
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x21a00
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x4050
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x21a10
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x4060
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x21a20
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x4070
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x21a30
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s53, 0x8000
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x22000
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0x8010
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x22010
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0x8020
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x22020
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0x8030
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x22030
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s62, 0x8000
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x22800
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x8010
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x22810
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x8020
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x22820
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x8030
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x22830
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x8040
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x22a00
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x8050
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x22a10
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x8060
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x22a20
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0x8070
		s_add_i32 s72, s32, s36
		v_add_u32_e32 v9, s72, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x22a30
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s53, 0xc000
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x23000
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0xc010
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x23010
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0xc020
		s_add_i32 s72, s32, s35
		s_add_i32 s32, s72, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x23020
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s53, 0xc030
		s_add_i32 s53, s32, s35
		s_add_i32 s32, s53, s57
		v_add_u32_e32 v9, s32, v3
		v_cndmask_b32_e64 v13, v12, v9, s[54:55]
		s_add_i32 s32, s56, 0x23030
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 s32, s62, 0xc000
		s_add_i32 s35, s32, s36
		v_add_u32_e32 v9, s35, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x23800
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0xc010
		s_add_i32 s35, s32, s36
		v_add_u32_e32 v9, s35, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x23810
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0xc020
		s_add_i32 s35, s32, s36
		v_add_u32_e32 v9, s35, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x23820
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0xc030
		s_add_i32 s35, s32, s36
		v_add_u32_e32 v9, s35, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x23830
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0xc040
		s_add_i32 s35, s32, s36
		v_add_u32_e32 v9, s35, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x23a00
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0xc050
		s_add_i32 s35, s32, s36
		v_add_u32_e32 v9, s35, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x23a10
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0xc060
		s_add_i32 s35, s32, s36
		v_add_u32_e32 v9, s35, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x23a20
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s62, 0xc070
		s_add_i32 s35, s32, s36
		v_add_u32_e32 v9, s35, v3
		v_cndmask_b32_e64 v13, v12, v9, s[60:61]
		s_add_i32 s32, s64, 0x23a30
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 s32, s37, 0x10000
		s_mov_b32 m0, s32
		s_add_i32 s32, s38, 0x80
		s_add_i32 s35, s32, s39
		v_add_u32_e32 v9, s35, v2
		v_add3_u32 v13, v9, v10, v11
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_add_i32 s32, s37, 0x12000
		s_mov_b32 m0, s32
		s_add_i32 s32, s38, 0x80080
		s_add_i32 s35, s32, s39
		v_add_u32_e32 v9, s35, v2
		v_add3_u32 v13, v9, v10, v11
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_add_i32 s32, s37, 0x14000
		s_mov_b32 m0, s32
		s_add_i32 s32, s38, 0xc0
		s_add_i32 s35, s32, s39
		v_add_u32_e32 v9, s35, v2
		v_add3_u32 v13, v9, v10, v11
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_add_i32 s32, s37, 0x16000
		s_mov_b32 m0, s32
		s_add_i32 s32, s38, 0x800c0
		s_add_i32 s35, s32, s39
		v_add_u32_e32 v9, s35, v2
		v_add3_u32 v13, v9, v10, v11
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_add_i32 s32, s37, 0x18000
		s_mov_b32 m0, s32
		s_add_i32 s32, s45, 0x80
		v_add_u32_e32 v9, s32, v2
		v_add3_u32 v13, v9, v10, v11
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s32, s37, 0x1a000
		s_mov_b32 m0, s32
		s_add_i32 s32, s45, 0x80080
		v_add_u32_e32 v9, s32, v2
		v_add3_u32 v13, v9, v10, v11
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s32, s37, 0x1c000
		s_mov_b32 m0, s32
		s_add_i32 s32, s45, 0xc0
		v_add_u32_e32 v9, s32, v2
		v_add3_u32 v13, v9, v10, v11
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s32, s37, 0x1e000
		s_mov_b32 m0, s32
		s_add_i32 s32, s45, 0x800c0
		v_add_u32_e32 v9, s32, v2
		v_add3_u32 v13, v9, v10, v11
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_waitcnt vmcnt(56)
		s_barrier
		v_and_b32_e32 v9, 15, v0
		v_lshrrev_b32_e32 v13, 1, v9
		v_lshrrev_b32_e32 v14, 4, v8
		v_and_b32_e32 v15, 3, v13
		v_lshrrev_b32_e32 v13, 7, v0
		v_xor_b32_e32 v16, v14, v15
		v_and_b32_e32 v14, 1, v1
		v_lshlrev_b32_e32 v15, 12, v13
		v_lshlrev_b32_e32 v17, 6, v9
		v_lshlrev_b32_e32 v9, 4, v16
		v_lshlrev_b32_e32 v16, 13, v14
		v_add3_u32 v18, v15, v17, v9
		v_add3_u32 v19, v17, v16, v9
		ds_read_b128 v[20:23], v18
		ds_read_b128 v[24:27], v18 offset:1024
		ds_read_b128 v[28:31], v18 offset:2048
		ds_read_b128 v[32:35], v18 offset:3072
		ds_read_b128 v[36:39], v18 offset:16384
		ds_read_b128 v[40:43], v18 offset:17408
		ds_read_b128 v[44:47], v18 offset:18432
		ds_read_b128 v[48:51], v18 offset:19456
		ds_read_b128 v[52:55], v19 offset:32768
		ds_read_b128 v[56:59], v19 offset:33792
		ds_read_b128 v[60:63], v19 offset:34816
		ds_read_b128 v[64:67], v19 offset:35840
		ds_read_b128 v[68:71], v19 offset:36864
		ds_read_b128 v[72:75], v19 offset:37888
		ds_read_b128 v[76:79], v19 offset:38912
		ds_read_b128 v[80:83], v19 offset:39936
		ds_read_b128 v[84:87], v19 offset:49152
		ds_read_b128 v[88:91], v19 offset:50176
		ds_read_b128 v[92:95], v19 offset:51200
		ds_read_b128 v[96:99], v19 offset:52224
		ds_read_b128 v[100:103], v19 offset:53248
		ds_read_b128 v[104:107], v19 offset:54272
		ds_read_b128 v[108:111], v19 offset:55296
		ds_read_b128 v[112:115], v19 offset:56320
		v_lshlrev_b32_e32 v18, 9, v13
		v_lshlrev_b32_e32 v13, 3, v8
		v_lshlrev_b32_e32 v8, 10, v14
		s_cmp_lt_i32 0, 30
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
		v_mov_b64_e32 v[176:177], 0
		v_mov_b64_e32 v[178:179], 0
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_add_i32 s32, s52, 2
		s_mul_i32 s35, s32, 0x80
		s_lshl_b32 s36, s35, 0
		s_add_i32 s35, s52, 1
		s_waitcnt vmcnt(32)
		s_barrier
		s_and_b32 s38, s52, 1
		s_lshl_b32 s39, s38, 13
		s_add_i32 s38, s39, 0x20000
		v_add3_u32 v19, s38, v18, v13
		ds_read_b64_tr_b8 v[240:241], v19
		ds_read_b64_tr_b8 v[242:243], v19 offset:4096
		v_add3_u32 v19, s38, v13, v8
		ds_read_b64_tr_b8 v[244:245], v19 offset:2048
		ds_read_b64_tr_b8 v[246:247], v19 offset:2560
		ds_read_b64_tr_b8 v[248:249], v19 offset:6144
		ds_read_b64_tr_b8 v[250:251], v19 offset:6656
		s_mul_i32 s38, s32, 2
		s_lshl_b32 s39, s38, 14
		s_add_i32 s53, s34, s39
		v_add_u32_e32 v19, s53, v3
		s_and_b32 s53, s32, 1
		v_cndmask_b32_e64 v252, v12, v19, s[54:55]
		s_lshl_b32 s32, s53, 13
		s_add_i32 s57, s56, s32
		s_add_i32 s62, s57, 0x20000
		s_mov_b32 m0, s62
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v252, s[20:23], 0 offen lds
		s_add_i32 s62, s33, s39
		v_add_u32_e32 v19, s62, v3
		s_add_i32 s62, s57, 0x20010
		v_cndmask_b32_e64 v252, v12, v19, s[54:55]
		s_mov_b32 m0, s62
		s_nop 0
		buffer_load_dwordx4 v252, s[20:23], 0 offen lds
		s_add_i32 s62, s58, s39
		v_add_u32_e32 v19, s62, v3
		s_add_i32 s62, s57, 0x20020
		v_cndmask_b32_e64 v252, v12, v19, s[54:55]
		s_mov_b32 m0, s62
		s_nop 0
		buffer_load_dwordx4 v252, s[20:23], 0 offen lds
		s_add_i32 s62, s59, s39
		v_add_u32_e32 v19, s62, v3
		s_add_i32 s62, s57, 0x20030
		v_cndmask_b32_e64 v252, v12, v19, s[54:55]
		s_mov_b32 m0, s62
		s_nop 0
		buffer_load_dwordx4 v252, s[20:23], 0 offen lds
		s_add_i32 s62, s63, s39
		v_add_u32_e32 v19, s62, v3
		s_add_i32 s62, s64, s32
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_add_i32 s32, s62, 0x20800
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s65, s39
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x20810
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s66, s39
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x20820
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s67, s39
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x20830
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s68, s39
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x20a00
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s69, s39
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x20a10
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s70, s39
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x20a20
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s71, s39
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x20a30
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s38, 1
		s_lshl_b32 s38, s32, 14
		s_add_i32 s32, s34, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s57, 0x21000
		v_cndmask_b32_e64 v252, v12, v19, s[54:55]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[20:23], 0 offen lds
		s_add_i32 s32, s33, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s57, 0x21010
		v_cndmask_b32_e64 v252, v12, v19, s[54:55]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[20:23], 0 offen lds
		s_add_i32 s32, s58, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s57, 0x21020
		v_cndmask_b32_e64 v252, v12, v19, s[54:55]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[20:23], 0 offen lds
		s_add_i32 s32, s59, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s57, 0x21030
		v_cndmask_b32_e64 v252, v12, v19, s[54:55]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[20:23], 0 offen lds
		s_add_i32 s32, s63, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x21800
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s65, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x21810
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s66, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x21820
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s67, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x21830
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s68, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x21a00
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s69, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x21a10
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s70, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x21a20
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		s_add_i32 s32, s71, s38
		v_add_u32_e32 v19, s32, v3
		s_add_i32 s32, s62, 0x21a30
		v_cndmask_b32_e64 v252, v12, v19, s[60:61]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v252, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[52:55], v[4:7], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[56:59], v[116:119], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[60:63], v[120:123], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[64:67], v[124:127], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[52:55], v[144:147], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[56:59], v[148:151], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[60:63], v[152:155], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[64:67], v[156:159], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[52:55], v[176:179], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[56:59], v[180:183], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[60:63], v[184:187], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[64:67], v[188:191], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[52:55], v[208:211], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[56:59], v[212:215], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[60:63], v[216:219], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[64:67], v[220:223], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[68:71], v[128:131], v240, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[72:75], v[132:135], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[76:79], v[136:139], v240, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[80:83], v[140:143], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[68:71], v[160:163], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[72:75], v[164:167], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[76:79], v[168:171], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[80:83], v[172:175], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[68:71], v[192:195], v240, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[72:75], v[196:199], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[76:79], v[200:203], v240, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[80:83], v[204:207], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[68:71], v[224:227], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[72:75], v[228:231], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[76:79], v[232:235], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[80:83], v[236:239], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[36:39], v[84:87], v[4:7], v242, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[88:91], v[116:119], v242, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[92:95], v[120:123], v242, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[96:99], v[124:127], v242, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[84:87], v[144:147], v242, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[88:91], v[148:151], v242, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[92:95], v[152:155], v242, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[96:99], v[156:159], v242, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[84:87], v[176:179], v242, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[88:91], v[180:183], v242, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[92:95], v[184:187], v242, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[96:99], v[188:191], v242, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[84:87], v[208:211], v242, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[88:91], v[212:215], v242, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[92:95], v[216:219], v242, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[96:99], v[220:223], v242, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[100:103], v[128:131], v242, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[104:107], v[132:135], v242, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[108:111], v[136:139], v242, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[112:115], v[140:143], v242, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[100:103], v[160:163], v242, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[104:107], v[164:167], v242, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[108:111], v[168:171], v242, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[112:115], v[172:175], v242, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[100:103], v[192:195], v242, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[104:107], v[196:199], v242, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[108:111], v[200:203], v242, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[112:115], v[204:207], v242, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[100:103], v[224:227], v242, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[104:107], v[228:231], v242, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[108:111], v[232:235], v242, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[112:115], v[236:239], v242, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(24)
		s_barrier
		s_lshl_b32 s32, s53, 16
		s_add_i32 s38, s37, s32
		s_mov_b32 m0, s38
		s_add_i32 s32, s44, s36
		v_add_u32_e32 v19, s32, v2
		s_add_i32 s32, s38, 0x2000
		v_add3_u32 v240, v19, v10, v11
		buffer_load_dwordx4 v240, s[24:27], 0 offen lds
		s_mov_b32 m0, s32
		s_add_i32 s32, s46, s36
		v_add_u32_e32 v19, s32, v2
		s_add_i32 s32, s38, 0x4000
		v_add3_u32 v240, v19, v10, v11
		buffer_load_dwordx4 v240, s[24:27], 0 offen lds
		s_mov_b32 m0, s32
		s_add_i32 s32, s47, s36
		v_add_u32_e32 v19, s32, v2
		s_add_i32 s32, s38, 0x6000
		v_add3_u32 v240, v19, v10, v11
		buffer_load_dwordx4 v240, s[24:27], 0 offen lds
		s_mov_b32 m0, s32
		s_add_i32 s32, s48, s36
		v_add_u32_e32 v19, s32, v2
		s_add_i32 s32, s38, 0x8000
		v_add3_u32 v240, v19, v10, v11
		buffer_load_dwordx4 v240, s[24:27], 0 offen lds
		s_mov_b32 m0, s32
		s_add_i32 s32, s45, s36
		v_add_u32_e32 v19, s32, v2
		s_add_i32 s32, s38, 0xa000
		v_add3_u32 v240, v19, v10, v11
		buffer_load_dwordx4 v240, s[28:31], 0 offen lds
		s_add_i32 s39, s49, s36
		v_add_u32_e32 v19, s39, v2
		s_mov_b32 m0, s32
		v_add3_u32 v240, v19, v10, v11
		buffer_load_dwordx4 v240, s[28:31], 0 offen lds
		s_add_i32 s32, s38, 0xc000
		s_add_i32 s39, s50, s36
		v_add_u32_e32 v19, s39, v2
		s_mov_b32 m0, s32
		v_add3_u32 v240, v19, v10, v11
		buffer_load_dwordx4 v240, s[28:31], 0 offen lds
		s_add_i32 s32, s38, 0xe000
		s_add_i32 s38, s51, s36
		v_add_u32_e32 v19, s38, v2
		s_mov_b32 m0, s32
		v_add3_u32 v240, v19, v10, v11
		buffer_load_dwordx4 v240, s[28:31], 0 offen lds
		s_and_b32 s32, s35, 1
		s_lshl_b32 s36, s32, 16
		v_add_u32_e32 v19, s36, v15
		v_add_u32_e32 v240, s36, v17
		v_add3_u32 v241, v19, v17, v9
		ds_read_b128 v[20:23], v241
		ds_read_b128 v[24:27], v241 offset:1024
		ds_read_b128 v[28:31], v241 offset:2048
		ds_read_b128 v[32:35], v241 offset:3072
		ds_read_b128 v[36:39], v241 offset:16384
		ds_read_b128 v[40:43], v241 offset:17408
		ds_read_b128 v[44:47], v241 offset:18432
		ds_read_b128 v[48:51], v241 offset:19456
		v_add3_u32 v19, v240, v16, v9
		ds_read_b128 v[52:55], v19 offset:32768
		ds_read_b128 v[56:59], v19 offset:33792
		ds_read_b128 v[60:63], v19 offset:34816
		ds_read_b128 v[64:67], v19 offset:35840
		ds_read_b128 v[68:71], v19 offset:36864
		ds_read_b128 v[72:75], v19 offset:37888
		ds_read_b128 v[76:79], v19 offset:38912
		ds_read_b128 v[80:83], v19 offset:39936
		ds_read_b128 v[84:87], v19 offset:49152
		ds_read_b128 v[88:91], v19 offset:50176
		ds_read_b128 v[92:95], v19 offset:51200
		ds_read_b128 v[96:99], v19 offset:52224
		ds_read_b128 v[100:103], v19 offset:53248
		ds_read_b128 v[104:107], v19 offset:54272
		ds_read_b128 v[108:111], v19 offset:55296
		ds_read_b128 v[112:115], v19 offset:56320
		s_cmp_lt_i32 s35, 30
		s_mov_b32 s52, s35
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(32)
		s_barrier
		v_add_u32_e32 v2, 0x20000, v18
		v_add_u32_e32 v3, v2, v13
		ds_read_b64_tr_b8 v[10:11], v3
		v_add_u32_e32 v2, 0x20000, v13
		v_lshl_add_u32 v8, v14, 10, v2
		ds_read_b64_tr_b8 v[18:19], v8 offset:2048
		ds_read_b64_tr_b8 v[240:241], v8 offset:2560
		ds_read_b64_tr_b8 v[242:243], v3 offset:4096
		ds_read_b64_tr_b8 v[244:245], v8 offset:6144
		ds_read_b64_tr_b8 v[246:247], v8 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[52:55], v[4:7], v10, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[56:59], v[116:119], v10, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[60:63], v[120:123], v10, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[64:67], v[124:127], v10, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[68:71], v[128:131], v10, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[72:75], v[132:135], v10, v240 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[76:79], v[136:139], v10, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[80:83], v[140:143], v10, v240 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[52:55], v[144:147], v10, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[56:59], v[148:151], v10, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[60:63], v[152:155], v10, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[64:67], v[156:159], v10, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[68:71], v[160:163], v10, v240 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[72:75], v[164:167], v10, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[76:79], v[168:171], v10, v240 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[80:83], v[172:175], v10, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[52:55], v[176:179], v10, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[56:59], v[180:183], v10, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[60:63], v[184:187], v10, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[64:67], v[188:191], v10, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[68:71], v[192:195], v10, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[72:75], v[196:199], v10, v240 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[76:79], v[200:203], v10, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[80:83], v[204:207], v10, v240 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[52:55], v[208:211], v10, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[56:59], v[212:215], v10, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[60:63], v[216:219], v10, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[64:67], v[220:223], v10, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[68:71], v[224:227], v10, v240 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[72:75], v[228:231], v10, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[76:79], v[232:235], v10, v240 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[80:83], v[236:239], v10, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[36:39], v[84:87], v[4:7], v242, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[88:91], v[116:119], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[92:95], v[120:123], v242, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[96:99], v[124:127], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[100:103], v[128:131], v242, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[104:107], v[132:135], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[108:111], v[136:139], v242, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[112:115], v[140:143], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[84:87], v[144:147], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[88:91], v[148:151], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[92:95], v[152:155], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[96:99], v[156:159], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[100:103], v[160:163], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[104:107], v[164:167], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[108:111], v[168:171], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[112:115], v[172:175], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[84:87], v[176:179], v242, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[88:91], v[180:183], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[92:95], v[184:187], v242, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[96:99], v[188:191], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[100:103], v[192:195], v242, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[104:107], v[196:199], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[108:111], v[200:203], v242, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[112:115], v[204:207], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[84:87], v[208:211], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[88:91], v[212:215], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[92:95], v[216:219], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[96:99], v[220:223], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[100:103], v[224:227], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[104:107], v[228:231], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[108:111], v[232:235], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[112:115], v[236:239], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v15
		v_add3_u32 v10, v2, v17, v9
		ds_read_b128 v[20:23], v10
		ds_read_b128 v[24:27], v10 offset:1024
		ds_read_b128 v[28:31], v10 offset:2048
		ds_read_b128 v[32:35], v10 offset:3072
		ds_read_b128 v[36:39], v10 offset:16384
		ds_read_b128 v[40:43], v10 offset:17408
		ds_read_b128 v[44:47], v10 offset:18432
		ds_read_b128 v[48:51], v10 offset:19456
		v_add_u32_e32 v2, 0x10000, v17
		v_add3_u32 v10, v2, v16, v9
		ds_read_b128 v[16:19], v10 offset:32768
		ds_read_b128 v[52:55], v10 offset:33792
		ds_read_b128 v[56:59], v10 offset:34816
		ds_read_b128 v[60:63], v10 offset:35840
		ds_read_b128 v[64:67], v10 offset:36864
		ds_read_b128 v[68:71], v10 offset:37888
		ds_read_b128 v[72:75], v10 offset:38912
		ds_read_b128 v[76:79], v10 offset:39936
		ds_read_b128 v[80:83], v10 offset:49152
		ds_read_b128 v[84:87], v10 offset:50176
		ds_read_b128 v[88:91], v10 offset:51200
		ds_read_b128 v[92:95], v10 offset:52224
		ds_read_b128 v[96:99], v10 offset:53248
		ds_read_b128 v[100:103], v10 offset:54272
		ds_read_b128 v[104:107], v10 offset:55296
		ds_read_b128 v[108:111], v10 offset:56320
		s_barrier
		ds_read_b64_tr_b8 v[10:11], v3 offset:8192
		ds_read_b64_tr_b8 v[14:15], v8 offset:10240
		ds_read_b64_tr_b8 v[112:113], v8 offset:10752
		ds_read_b64_tr_b8 v[114:115], v3 offset:12288
		ds_read_b64_tr_b8 v[2:3], v8 offset:14336
		ds_read_b64_tr_b8 v[240:241], v8 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[16:19], v[4:7], v10, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v10, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v10, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v10, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[16:19], v[144:147], v10, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v10, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v10, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v10, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[16:19], v[176:179], v10, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v10, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v10, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v10, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[16:19], v[208:211], v10, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v10, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v10, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v10, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[36:39], v[80:83], v[4:7], v114, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[84:87], v[116:119], v114, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v114, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v114, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[80:83], v[144:147], v114, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v114, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v114, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v114, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[80:83], v[176:179], v114, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v114, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v114, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v114, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[80:83], v[208:211], v114, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v114, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v114, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v114, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_f16_f32_e64 v2, v4
		v_cvt_f16_f32_e64 v3, v5
		v_cvt_f16_f32_e64 v4, v6
		v_cvt_f16_f32_e64 v5, v7
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		v_lshl_add_u32 v4, v1, 14, v13
		buffer_store_dwordx2 v[2:3], v4, s[40:43], 0 offen
		v_cvt_f16_f32_e64 v1, v116
		v_cvt_f16_f32_e64 v2, v117
		v_cvt_f16_f32_e64 v3, v118
		v_cvt_f16_f32_e64 v5, v119
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], 0 offen offset:512
		v_cvt_f16_f32_e64 v1, v120
		v_cvt_f16_f32_e64 v2, v121
		v_cvt_f16_f32_e64 v3, v122
		v_cvt_f16_f32_e64 v5, v123
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], 0 offen offset:1024
		v_cvt_f16_f32_e64 v1, v124
		v_cvt_f16_f32_e64 v2, v125
		v_cvt_f16_f32_e64 v3, v126
		v_cvt_f16_f32_e64 v5, v127
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], 0 offen offset:1536
		v_cvt_f16_f32_e64 v1, v144
		v_cvt_f16_f32_e64 v2, v145
		v_cvt_f16_f32_e64 v3, v146
		v_cvt_f16_f32_e64 v5, v147
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		s_mov_b32 s16, 0x1000
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s16 offen
		v_cvt_f16_f32_e64 v1, v148
		v_cvt_f16_f32_e64 v2, v149
		v_cvt_f16_f32_e64 v3, v150
		v_cvt_f16_f32_e64 v5, v151
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s16 offen offset:512
		v_cvt_f16_f32_e64 v1, v152
		v_cvt_f16_f32_e64 v2, v153
		v_cvt_f16_f32_e64 v3, v154
		v_cvt_f16_f32_e64 v5, v155
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s16 offen offset:1024
		v_cvt_f16_f32_e64 v1, v156
		v_cvt_f16_f32_e64 v2, v157
		v_cvt_f16_f32_e64 v3, v158
		v_cvt_f16_f32_e64 v5, v159
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s16 offen offset:1536
		v_cvt_f16_f32_e64 v1, v176
		v_cvt_f16_f32_e64 v2, v177
		v_cvt_f16_f32_e64 v3, v178
		v_cvt_f16_f32_e64 v5, v179
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		s_mov_b32 s17, 0x2000
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s17 offen
		v_cvt_f16_f32_e64 v1, v180
		v_cvt_f16_f32_e64 v2, v181
		v_cvt_f16_f32_e64 v3, v182
		v_cvt_f16_f32_e64 v5, v183
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s17 offen offset:512
		v_cvt_f16_f32_e64 v1, v184
		v_cvt_f16_f32_e64 v2, v185
		v_cvt_f16_f32_e64 v3, v186
		v_cvt_f16_f32_e64 v5, v187
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s17 offen offset:1024
		v_cvt_f16_f32_e64 v1, v188
		v_cvt_f16_f32_e64 v2, v189
		v_cvt_f16_f32_e64 v3, v190
		v_cvt_f16_f32_e64 v5, v191
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s17 offen offset:1536
		v_cvt_f16_f32_e64 v1, v208
		v_cvt_f16_f32_e64 v2, v209
		v_cvt_f16_f32_e64 v3, v210
		v_cvt_f16_f32_e64 v5, v211
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		s_mov_b32 s18, 0x3000
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s18 offen
		v_cvt_f16_f32_e64 v1, v212
		v_cvt_f16_f32_e64 v2, v213
		v_cvt_f16_f32_e64 v3, v214
		v_cvt_f16_f32_e64 v5, v215
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s18 offen offset:512
		v_cvt_f16_f32_e64 v1, v216
		v_cvt_f16_f32_e64 v2, v217
		v_cvt_f16_f32_e64 v3, v218
		v_cvt_f16_f32_e64 v5, v219
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s18 offen offset:1024
		v_cvt_f16_f32_e64 v1, v220
		v_cvt_f16_f32_e64 v2, v221
		v_cvt_f16_f32_e64 v3, v222
		v_cvt_f16_f32_e64 v5, v223
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s18 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v10, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v10, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v10, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v10, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v10, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v10, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v10, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v10, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v10, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v10, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v10, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v10, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v10, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v10, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v10, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v10, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v114, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v114, v240 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v114, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v114, v240 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v114, v240 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v114, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v114, v240 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v114, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v114, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v114, v240 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v114, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v114, v240 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v114, v240 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v114, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v114, v240 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v114, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_f16_f32_e64 v1, v128
		v_cvt_f16_f32_e64 v2, v129
		v_cvt_f16_f32_e64 v3, v130
		v_cvt_f16_f32_e64 v5, v131
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], 0 offen offset:2048
		v_cvt_f16_f32_e64 v1, v132
		v_cvt_f16_f32_e64 v2, v133
		v_cvt_f16_f32_e64 v3, v134
		v_cvt_f16_f32_e64 v5, v135
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], 0 offen offset:2560
		v_cvt_f16_f32_e64 v1, v136
		v_cvt_f16_f32_e64 v2, v137
		v_cvt_f16_f32_e64 v3, v138
		v_cvt_f16_f32_e64 v5, v139
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], 0 offen offset:3072
		v_cvt_f16_f32_e64 v1, v140
		v_cvt_f16_f32_e64 v2, v141
		v_cvt_f16_f32_e64 v3, v142
		v_cvt_f16_f32_e64 v5, v143
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], 0 offen offset:3584
		v_cvt_f16_f32_e64 v1, v160
		v_cvt_f16_f32_e64 v2, v161
		v_cvt_f16_f32_e64 v3, v162
		v_cvt_f16_f32_e64 v5, v163
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s16 offen offset:2048
		v_cvt_f16_f32_e64 v1, v164
		v_cvt_f16_f32_e64 v2, v165
		v_cvt_f16_f32_e64 v3, v166
		v_cvt_f16_f32_e64 v5, v167
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s16 offen offset:2560
		v_cvt_f16_f32_e64 v1, v168
		v_cvt_f16_f32_e64 v2, v169
		v_cvt_f16_f32_e64 v3, v170
		v_cvt_f16_f32_e64 v5, v171
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s16 offen offset:3072
		v_cvt_f16_f32_e64 v1, v172
		v_cvt_f16_f32_e64 v2, v173
		v_cvt_f16_f32_e64 v3, v174
		v_cvt_f16_f32_e64 v5, v175
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s16 offen offset:3584
		v_cvt_f16_f32_e64 v1, v192
		v_cvt_f16_f32_e64 v2, v193
		v_cvt_f16_f32_e64 v3, v194
		v_cvt_f16_f32_e64 v5, v195
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s17 offen offset:2048
		v_cvt_f16_f32_e64 v1, v196
		v_cvt_f16_f32_e64 v2, v197
		v_cvt_f16_f32_e64 v3, v198
		v_cvt_f16_f32_e64 v5, v199
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s17 offen offset:2560
		v_cvt_f16_f32_e64 v1, v200
		v_cvt_f16_f32_e64 v2, v201
		v_cvt_f16_f32_e64 v3, v202
		v_cvt_f16_f32_e64 v5, v203
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s17 offen offset:3072
		v_cvt_f16_f32_e64 v1, v204
		v_cvt_f16_f32_e64 v2, v205
		v_cvt_f16_f32_e64 v3, v206
		v_cvt_f16_f32_e64 v5, v207
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s17 offen offset:3584
		v_cvt_f16_f32_e64 v1, v224
		v_cvt_f16_f32_e64 v2, v225
		v_cvt_f16_f32_e64 v3, v226
		v_cvt_f16_f32_e64 v5, v227
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s18 offen offset:2048
		v_cvt_f16_f32_e64 v1, v228
		v_cvt_f16_f32_e64 v2, v229
		v_cvt_f16_f32_e64 v3, v230
		v_cvt_f16_f32_e64 v5, v231
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s18 offen offset:2560
		v_cvt_f16_f32_e64 v1, v232
		v_cvt_f16_f32_e64 v2, v233
		v_cvt_f16_f32_e64 v3, v234
		v_cvt_f16_f32_e64 v5, v235
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s18 offen offset:3072
		v_cvt_f16_f32_e64 v1, v236
		v_cvt_f16_f32_e64 v2, v237
		v_cvt_f16_f32_e64 v3, v238
		v_cvt_f16_f32_e64 v5, v239
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v5
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v4, s[40:43], s18 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 48
		.amdhsa_user_sgpr_count 13
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 11
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 253
		.amdhsa_next_free_sgpr 73
		.amdhsa_accum_offset 256
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
	.end_amdhsa_kernel
	.text
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 253
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 73
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 0
	.set .Lwmma_f16_matmul_tiled.uses_vcc, 0
	.set .Lwmma_f16_matmul_tiled.uses_flat_scratch, 0
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
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 1024
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     73
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     253
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
