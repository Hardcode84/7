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
		scratch_store_dword off, v4, s8 offset:668
		scratch_store_dword off, v5, s8 offset:672
		scratch_store_dword off, v6, s8 offset:676
		scratch_store_dword off, v7, s8 offset:680
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_accvgpr_write_b32 a0, v1
		v_accvgpr_read_b32 v1, a0
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v1, s9, v2
		v_and_b32_e32 v3, 63, v0
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x22000, v4
		ds_write_b32 v5, v3
		v_lshlrev_b32_e32 v3, 2, v0
		v_add_u32_e32 v4, 0x22000, v3
		s_waitcnt lgkmcnt(0)
		ds_read_b32 v3, v4
		s_waitcnt lgkmcnt(0)
		v_lshrrev_b32_e32 v4, 2, v3
		v_lshlrev_b32_e32 v3, 12, v4
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x22000, v4
		ds_read_b32 v4, v5
		s_waitcnt lgkmcnt(0)
		v_lshrrev_b32_e32 v5, 3, v4
		v_and_b32_e32 v4, 3, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v6, 0x22000, v5
		ds_read_b32 v5, v6
		s_waitcnt lgkmcnt(0)
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
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v5, 9, v1
		s_mov_b32 s37, 0
		scratch_store_dword off, v5, s37 offset:144
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v6, 0x22000, v5
		ds_read_b32 v5, v6
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v6, 2, v5
		s_mov_b32 s37, 0
		scratch_store_dword off, v6, s37 offset:724
		s_mov_b32 s37, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v5, off, s37 offset:144
		s_mov_b32 s37, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s37 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v7, s36, v5, v6
		s_lshr_b32 s37, s8, 7
		s_lshl_b32 s8, s37, 9
		s_add_i32 s37, s9, 0x100
		s_add_i32 s38, s37, s35
		s_mov_b32 s37, 0
		scratch_load_dword v5, off, s37 offset:144
		s_mov_b32 s37, 0
		scratch_load_dword v6, off, s37 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v8, s38, v5, v6
		s_add_i32 s37, s8, 0x100
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v6, 0x22000, v5
		ds_read_b32 v5, v6
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v6, 4, v5
		v_accvgpr_read_b32 v5, a0
		v_and_b32_e32 v9, 1, v5
		v_lshlrev_b32_e32 v5, 10, v9
		s_mov_b32 s38, 0
		scratch_store_dword off, v5, s38 offset:140
		s_mov_b32 s38, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v5, off, s38 offset:140
		s_waitcnt vmcnt(0)
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
		v_lshlrev_b32_e32 v5, 12, v1
		s_mov_b32 s38, 0
		scratch_store_dword off, v5, s38 offset:136
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v5, 6, v1
		s_mov_b32 s38, 0
		scratch_store_dword off, v5, s38 offset:720
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v7, 0x22000, v5
		ds_read_b32 v5, v7
		s_waitcnt lgkmcnt(0)
		v_lshrrev_b32_e32 v7, 4, v5
		v_lshrrev_b32_e32 v5, 1, v1
		v_and_b32_e32 v1, 3, v5
		v_xor_b32_e32 v5, v7, v1
		v_lshlrev_b32_e32 v1, 4, v5
		s_mov_b32 s38, 0
		scratch_store_dword off, v1, s38 offset:716
		s_mov_b32 s38, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v1, off, s38 offset:136
		s_mov_b32 s38, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v5, off, s38 offset:716
		s_mov_b32 s38, 0
		scratch_load_dword v7, off, s38 offset:720
		s_waitcnt vmcnt(0)
		v_add3_u32 v8, v1, v7, v5
		ds_read_b128 v[12:15], v8
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:1104
		scratch_store_dword off, v13, s38 offset:1108
		scratch_store_dword off, v14, s38 offset:1112
		scratch_store_dword off, v15, s38 offset:1116
		ds_read_b128 v[12:15], v8 offset:1024
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:1088
		scratch_store_dword off, v13, s38 offset:1092
		scratch_store_dword off, v14, s38 offset:1096
		scratch_store_dword off, v15, s38 offset:1100
		ds_read_b128 v[12:15], v8 offset:2048
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:1072
		scratch_store_dword off, v13, s38 offset:1076
		scratch_store_dword off, v14, s38 offset:1080
		scratch_store_dword off, v15, s38 offset:1084
		ds_read_b128 v[12:15], v8 offset:3072
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:1056
		scratch_store_dword off, v13, s38 offset:1060
		scratch_store_dword off, v14, s38 offset:1064
		scratch_store_dword off, v15, s38 offset:1068
		v_lshlrev_b32_e32 v1, 13, v9
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v7, 0x27800, v5
		ds_write_b32 v7, v1
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v5, 0x27800, v1
		s_waitcnt lgkmcnt(0)
		ds_read_b32 v1, v5
		s_mov_b32 s38, 0
		scratch_load_dword v5, off, s38 offset:716
		s_mov_b32 s38, 0
		scratch_load_dword v7, off, s38 offset:720
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v8, v7, v1, v5
		ds_read_b128 v[12:15], v8 offset:32768
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:1000
		scratch_store_dword off, v13, s38 offset:1004
		scratch_store_dword off, v14, s38 offset:1008
		scratch_store_dword off, v15, s38 offset:1012
		ds_read_b128 v[12:15], v8 offset:33792
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:984
		scratch_store_dword off, v13, s38 offset:988
		scratch_store_dword off, v14, s38 offset:992
		scratch_store_dword off, v15, s38 offset:996
		ds_read_b128 v[12:15], v8 offset:34816
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:968
		scratch_store_dword off, v13, s38 offset:972
		scratch_store_dword off, v14, s38 offset:976
		scratch_store_dword off, v15, s38 offset:980
		ds_read_b128 v[12:15], v8 offset:35840
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:952
		scratch_store_dword off, v13, s38 offset:956
		scratch_store_dword off, v14, s38 offset:960
		scratch_store_dword off, v15, s38 offset:964
		ds_read_b128 v[12:15], v8 offset:36864
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:936
		scratch_store_dword off, v13, s38 offset:940
		scratch_store_dword off, v14, s38 offset:944
		scratch_store_dword off, v15, s38 offset:948
		ds_read_b128 v[12:15], v8 offset:37888
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:920
		scratch_store_dword off, v13, s38 offset:924
		scratch_store_dword off, v14, s38 offset:928
		scratch_store_dword off, v15, s38 offset:932
		ds_read_b128 v[12:15], v8 offset:38912
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:904
		scratch_store_dword off, v13, s38 offset:908
		scratch_store_dword off, v14, s38 offset:912
		scratch_store_dword off, v15, s38 offset:916
		ds_read_b128 v[12:15], v8 offset:39936
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s38 offset:888
		scratch_store_dword off, v13, s38 offset:892
		scratch_store_dword off, v14, s38 offset:896
		scratch_store_dword off, v15, s38 offset:900
		s_mov_b32 s38, 0
		scratch_load_dword v1, off, s38 offset:144
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x20000, v1
		s_mov_b32 s38, 0
		scratch_load_dword v1, off, s38 offset:724
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v7, v5, v1
		ds_read_b32 v1, v7
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s38 offset:1144
		ds_read_b32 v1, v7 offset:256
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s38 offset:1140
		s_mov_b32 s38, 0
		scratch_load_dword v1, off, s38 offset:724
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x20000, v1
		s_mov_b32 s38, 0
		scratch_load_dword v1, off, s38 offset:140
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v7, v5, v1
		ds_read_b32 v1, v7 offset:2048
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s38 offset:1136
		ds_read_b32 v1, v7 offset:2304
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s38 offset:1132
		ds_read_b32 v1, v7 offset:2560
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s38 offset:1128
		ds_read_b32 v1, v7 offset:2816
		s_mov_b32 s38, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s38 offset:1124
		s_add_i32 s38, s9, 0x80
		v_add_u32_e32 v1, s38, v2
		v_add3_u32 v5, v1, v3, v4
		s_add_i32 s38, s9, 0x80080
		v_add_u32_e32 v1, s38, v2
		v_add3_u32 v7, v1, v3, v4
		s_add_i32 s38, s9, 0xc0
		v_add_u32_e32 v1, s38, v2
		v_add3_u32 v8, v1, v3, v4
		s_add_i32 s38, s9, 0x800c0
		v_add_u32_e32 v1, s38, v2
		v_add3_u32 v9, v1, v3, v4
		s_add_i32 s38, s10, 0x80
		v_add_u32_e32 v1, s38, v2
		v_add3_u32 v10, v1, v3, v4
		s_add_i32 s38, s10, 0x80080
		v_add_u32_e32 v1, s38, v2
		v_add3_u32 v11, v1, v3, v4
		s_add_i32 s38, s10, 0xc0
		v_add_u32_e32 v1, s38, v2
		v_add3_u32 v12, v1, v3, v4
		s_add_i32 s38, s10, 0x800c0
		v_add_u32_e32 v1, s38, v2
		v_add3_u32 v2, v1, v3, v4
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
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s45, s9, 0x800
		s_add_i32 s46, s45, s35
		s_mov_b32 s45, 0
		scratch_load_dword v1, off, s45 offset:144
		s_mov_b32 s45, 0
		scratch_load_dword v2, off, s45 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, s46, v1, v2
		s_add_i32 s45, s8, 0x1000
		s_add_i32 s47, s9, 0x900
		s_add_i32 s9, s47, s35
		s_mov_b32 s35, 0
		scratch_load_dword v1, off, s35 offset:144
		s_mov_b32 s35, 0
		scratch_load_dword v2, off, s35 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, s9, v1, v2
		s_add_i32 s9, s8, 0x1100
		s_mov_b32 s35, 0
		scratch_load_dword v1, off, s35 offset:140
		s_waitcnt vmcnt(0)
		v_add3_u32 v2, s46, v6, v1
		s_add_i32 s35, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dword v3, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x21100
		s_nop 0
		buffer_load_dword v4, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s11, s12, 1
		s_mov_b32 s46, 2
		v_mov_b32_e32 v2, s13
		v_mov_b32_e32 v3, 0
		s_mov_b32 s48, 0x100000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v4, s48
		v_mov_b32_e32 v5, s49
		v_mul_lo_u32 v6, v4, v2
		v_mul_hi_u32 v7, v4, v2
		v_mul_lo_u32 v1, v4, v3
		v_add_u32_e32 v7, v7, v1
		v_mul_lo_u32 v1, v5, v2
		v_add_u32_e32 v7, v7, v1
		s_mov_b32 s48, 1
		s_mov_b32 s49, 0
		v_mov_b32_e32 v8, v0
		v_mov_b32_e32 v9, 0
		v_mov_b32_e32 v10, s48
		v_mov_b32_e32 v11, s49
		v_mul_lo_u32 v12, v10, v8
		v_mul_hi_u32 v13, v10, v8
		v_mul_lo_u32 v1, v10, v9
		v_add_u32_e32 v13, v13, v1
		v_mul_lo_u32 v1, v11, v8
		v_add_u32_e32 v13, v13, v1
		v_lshrrev_b64 v[14:15], 6, v[12:13]
		s_mov_b32 s48, 0x10000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v16, s48
		v_mov_b32_e32 v17, s49
		v_mul_lo_u32 v18, v16, v14
		v_mul_hi_u32 v19, v16, v14
		v_mul_lo_u32 v1, v16, v15
		v_add_u32_e32 v19, v19, v1
		v_mul_lo_u32 v1, v17, v14
		v_add_u32_e32 v19, v19, v1
		v_add_co_u32_e64 v20, vcc, v6, v18
		v_addc_co_u32_e64 v21, vcc, v7, v19, vcc
		v_mov_b32_e32 v1, 63
		v_and_b32_e32 v22, v8, v1
		v_and_b32_e32 v23, v3, v3
		v_mul_lo_u32 v8, v10, v22
		v_mul_hi_u32 v9, v10, v22
		v_mul_lo_u32 v1, v10, v23
		v_add_u32_e32 v9, v9, v1
		v_mul_lo_u32 v1, v11, v22
		v_add_u32_e32 v9, v9, v1
		v_lshrrev_b64 v[10:11], 2, v[8:9]
		s_mov_b32 s48, 0x1000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v24, s48
		v_mov_b32_e32 v25, s49
		v_mul_lo_u32 v26, v24, v10
		v_mul_hi_u32 v27, v24, v10
		v_mul_lo_u32 v1, v24, v11
		v_add_u32_e32 v27, v27, v1
		v_mul_lo_u32 v1, v25, v10
		v_add_u32_e32 v27, v27, v1
		v_add_co_u32_e64 v10, vcc, v20, v26
		v_addc_co_u32_e64 v11, vcc, v21, v27, vcc
		v_lshrrev_b64 v[20:21], 3, v[8:9]
		v_mov_b32_e32 v1, 3
		v_and_b32_e32 v8, v20, v1
		v_and_b32_e32 v9, v21, v3
		v_and_b32_e32 v20, v22, v1
		v_and_b32_e32 v21, v23, v3
		v_xor_b32_e32 v24, v8, v20
		v_xor_b32_e32 v25, v9, v21
		s_mov_b32 s48, 16
		s_mov_b32 s49, 0
		v_mov_b32_e32 v8, s48
		v_mov_b32_e32 v9, s49
		v_mul_lo_u32 v20, v8, v24
		v_mul_hi_u32 v21, v8, v24
		v_mul_lo_u32 v1, v8, v25
		v_add_u32_e32 v21, v21, v1
		v_mul_lo_u32 v1, v9, v24
		v_add_u32_e32 v21, v21, v1
		v_add_co_u32_e64 v24, vcc, v10, v20
		v_addc_co_u32_e64 v25, vcc, v11, v21, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x22800, v1
		ds_write_b32 v2, v24
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x23000, v1
		ds_write_b32 v2, v25
		s_mov_b32 s48, 0x80
		s_mov_b32 s49, 0
		v_mov_b32_e32 v10, s48
		v_mov_b32_e32 v11, s49
		s_mov_b32 s47, 0
		scratch_store_dword off, v10, s47 offset:1148
		scratch_store_dword off, v11, s47 offset:1152
		v_mov_b32_e32 v1, 0x80000
		v_add_co_u32_e64 v10, vcc, v6, v1
		v_addc_co_u32_e64 v11, vcc, v7, 0, vcc
		v_add_co_u32_e64 v24, vcc, v10, v18
		v_addc_co_u32_e64 v25, vcc, v11, v19, vcc
		v_add_co_u32_e64 v10, vcc, v24, v26
		v_addc_co_u32_e64 v11, vcc, v25, v27, vcc
		v_add_co_u32_e64 v24, vcc, v10, v20
		v_addc_co_u32_e64 v25, vcc, v11, v21, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v10, 0x23800, v2
		ds_write_b32 v10, v24
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v10, 0x24000, v2
		ds_write_b32 v10, v25
		v_mov_b32_e32 v2, 64
		v_add_co_u32_e64 v10, vcc, v6, v2
		v_addc_co_u32_e64 v11, vcc, v7, 0, vcc
		v_add_co_u32_e64 v24, vcc, v10, v18
		v_addc_co_u32_e64 v25, vcc, v11, v19, vcc
		v_add_co_u32_e64 v10, vcc, v24, v26
		v_addc_co_u32_e64 v11, vcc, v25, v27, vcc
		v_add_co_u32_e64 v24, vcc, v10, v20
		v_addc_co_u32_e64 v25, vcc, v11, v21, vcc
		v_lshlrev_b32_e32 v10, 2, v0
		v_add_u32_e32 v11, 0x24800, v10
		ds_write_b32 v11, v24
		v_lshlrev_b32_e32 v10, 2, v0
		v_add_u32_e32 v11, 0x25000, v10
		ds_write_b32 v11, v25
		v_mov_b32_e32 v10, 0x80040
		v_add_co_u32_e64 v24, vcc, v6, v10
		v_addc_co_u32_e64 v25, vcc, v7, 0, vcc
		v_add_co_u32_e64 v28, vcc, v24, v18
		v_addc_co_u32_e64 v29, vcc, v25, v19, vcc
		v_add_co_u32_e64 v24, vcc, v28, v26
		v_addc_co_u32_e64 v25, vcc, v29, v27, vcc
		v_add_co_u32_e64 v28, vcc, v24, v20
		v_addc_co_u32_e64 v29, vcc, v25, v21, vcc
		v_lshlrev_b32_e32 v11, 2, v0
		v_add_u32_e32 v24, 0x25800, v11
		ds_write_b32 v24, v28
		v_lshlrev_b32_e32 v11, 2, v0
		v_add_u32_e32 v24, 0x26000, v11
		ds_write_b32 v24, v29
		v_mov_b32_e32 v24, s14
		v_mov_b32_e32 v25, 0
		v_mul_lo_u32 v28, v4, v24
		v_mul_hi_u32 v29, v4, v24
		v_mul_lo_u32 v11, v4, v25
		v_add_u32_e32 v29, v29, v11
		v_mul_lo_u32 v11, v5, v24
		v_add_u32_e32 v29, v29, v11
		v_add_co_u32_e64 v4, vcc, v28, v18
		v_addc_co_u32_e64 v5, vcc, v29, v19, vcc
		v_add_co_u32_e64 v30, vcc, v4, v26
		v_addc_co_u32_e64 v31, vcc, v5, v27, vcc
		v_add_co_u32_e64 v4, vcc, v30, v20
		v_addc_co_u32_e64 v5, vcc, v31, v21, vcc
		v_lshlrev_b32_e32 v11, 2, v0
		v_add_u32_e32 v30, 0x26800, v11
		ds_write_b32 v30, v4
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v11, 0x27000, v4
		ds_write_b32 v11, v5
		v_add_co_u32_e64 v4, vcc, v28, v1
		v_addc_co_u32_e64 v5, vcc, v29, 0, vcc
		v_add_co_u32_e64 v30, vcc, v4, v18
		v_addc_co_u32_e64 v31, vcc, v5, v19, vcc
		v_add_co_u32_e64 v4, vcc, v30, v26
		v_addc_co_u32_e64 v5, vcc, v31, v27, vcc
		v_add_co_u32_e64 v30, vcc, v4, v20
		v_addc_co_u32_e64 v31, vcc, v5, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v30, s47
		scratch_store_dword off, v31, s47 offset:4
		v_add_co_u32_e64 v4, vcc, v28, v2
		v_addc_co_u32_e64 v5, vcc, v29, 0, vcc
		v_add_co_u32_e64 v30, vcc, v4, v18
		v_addc_co_u32_e64 v31, vcc, v5, v19, vcc
		v_add_co_u32_e64 v4, vcc, v30, v26
		v_addc_co_u32_e64 v5, vcc, v31, v27, vcc
		v_add_co_u32_e64 v30, vcc, v4, v20
		v_addc_co_u32_e64 v31, vcc, v5, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v30, s47 offset:8
		scratch_store_dword off, v31, s47 offset:12
		v_add_co_u32_e64 v4, vcc, v28, v10
		v_addc_co_u32_e64 v5, vcc, v29, 0, vcc
		v_add_co_u32_e64 v10, vcc, v4, v18
		v_addc_co_u32_e64 v11, vcc, v5, v19, vcc
		v_add_co_u32_e64 v4, vcc, v10, v26
		v_addc_co_u32_e64 v5, vcc, v11, v27, vcc
		v_add_co_u32_e64 v10, vcc, v4, v20
		v_addc_co_u32_e64 v11, vcc, v5, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v10, s47 offset:16
		scratch_store_dword off, v11, s47 offset:20
		v_mul_lo_u32 v4, v16, v24
		v_mul_hi_u32 v5, v16, v24
		v_mul_lo_u32 v1, v16, v25
		v_add_u32_e32 v5, v5, v1
		v_mul_lo_u32 v1, v17, v24
		v_add_u32_e32 v5, v5, v1
		v_add_co_u32_e64 v10, vcc, v6, v4
		v_addc_co_u32_e64 v11, vcc, v7, v5, vcc
		v_lshrrev_b64 v[16:17], 7, v[12:13]
		s_mov_b32 s50, 0x200
		s_mov_b32 s51, 0
		v_mov_b32_e32 v12, s50
		v_mov_b32_e32 v13, s51
		v_mul_lo_u32 v24, v12, v16
		v_mul_hi_u32 v25, v12, v16
		v_mul_lo_u32 v1, v12, v17
		v_add_u32_e32 v25, v25, v1
		v_mul_lo_u32 v1, v13, v16
		v_add_u32_e32 v25, v25, v1
		v_add_co_u32_e64 v12, vcc, v10, v24
		v_addc_co_u32_e64 v13, vcc, v11, v25, vcc
		s_mov_b32 s50, 4
		s_mov_b32 s51, 0
		v_mov_b32_e32 v16, s50
		v_mov_b32_e32 v17, s51
		v_mul_lo_u32 v30, v16, v22
		v_mul_hi_u32 v31, v16, v22
		v_mul_lo_u32 v1, v16, v23
		v_add_u32_e32 v31, v31, v1
		v_mul_lo_u32 v1, v17, v22
		v_add_u32_e32 v31, v31, v1
		v_add_co_u32_e64 v16, vcc, v12, v30
		v_addc_co_u32_e64 v17, vcc, v13, v31, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v16, s47 offset:24
		scratch_store_dword off, v17, s47 offset:28
		s_mov_b32 s50, 0x800
		s_mov_b32 s51, 0
		v_mov_b32_e32 v1, 0x100
		v_add_co_u32_e64 v12, vcc, v6, v1
		v_addc_co_u32_e64 v13, vcc, v7, 0, vcc
		v_add_co_u32_e64 v16, vcc, v12, v4
		v_addc_co_u32_e64 v17, vcc, v13, v5, vcc
		v_add_co_u32_e64 v12, vcc, v16, v24
		v_addc_co_u32_e64 v13, vcc, v17, v25, vcc
		v_add_co_u32_e64 v16, vcc, v12, v30
		v_addc_co_u32_e64 v17, vcc, v13, v31, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v16, s47 offset:32
		scratch_store_dword off, v17, s47 offset:36
		v_mul_lo_u32 v12, v8, v22
		v_mul_hi_u32 v13, v8, v22
		v_mul_lo_u32 v1, v8, v23
		v_add_u32_e32 v13, v13, v1
		v_mul_lo_u32 v1, v9, v22
		v_add_u32_e32 v13, v13, v1
		v_add_co_u32_e64 v8, vcc, v10, v12
		v_addc_co_u32_e64 v9, vcc, v11, v13, vcc
		v_mov_b32_e32 v1, 1
		v_and_b32_e32 v10, v14, v1
		v_and_b32_e32 v11, v15, v3
		s_mov_b32 s52, 0x400
		s_mov_b32 s53, 0
		v_mov_b32_e32 v2, s52
		v_mov_b32_e32 v3, s53
		v_mul_lo_u32 v14, v2, v10
		v_mul_hi_u32 v15, v2, v10
		v_mul_lo_u32 v1, v2, v11
		v_add_u32_e32 v15, v15, v1
		v_mul_lo_u32 v1, v3, v10
		v_add_u32_e32 v15, v15, v1
		v_add_co_u32_e64 v2, vcc, v8, v14
		v_addc_co_u32_e64 v3, vcc, v9, v15, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:40
		scratch_store_dword off, v3, s47 offset:44
		v_mov_b32_e32 v1, 0x80
		v_add_co_u32_e64 v2, vcc, v6, v1
		v_addc_co_u32_e64 v3, vcc, v7, 0, vcc
		v_add_co_u32_e64 v8, vcc, v2, v18
		v_addc_co_u32_e64 v9, vcc, v3, v19, vcc
		v_add_co_u32_e64 v2, vcc, v8, v26
		v_addc_co_u32_e64 v3, vcc, v9, v27, vcc
		v_add_co_u32_e64 v8, vcc, v2, v20
		v_addc_co_u32_e64 v9, vcc, v3, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v8, s47 offset:48
		scratch_store_dword off, v9, s47 offset:52
		v_mov_b32_e32 v2, 0x80080
		v_add_co_u32_e64 v8, vcc, v6, v2
		v_addc_co_u32_e64 v9, vcc, v7, 0, vcc
		v_add_co_u32_e64 v10, vcc, v8, v18
		v_addc_co_u32_e64 v11, vcc, v9, v19, vcc
		v_add_co_u32_e64 v8, vcc, v10, v26
		v_addc_co_u32_e64 v9, vcc, v11, v27, vcc
		v_add_co_u32_e64 v10, vcc, v8, v20
		v_addc_co_u32_e64 v11, vcc, v9, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v10, s47 offset:56
		scratch_store_dword off, v11, s47 offset:60
		v_mov_b32_e32 v3, 0xc0
		v_add_co_u32_e64 v8, vcc, v6, v3
		v_addc_co_u32_e64 v9, vcc, v7, 0, vcc
		v_add_co_u32_e64 v10, vcc, v8, v18
		v_addc_co_u32_e64 v11, vcc, v9, v19, vcc
		v_add_co_u32_e64 v8, vcc, v10, v26
		v_addc_co_u32_e64 v9, vcc, v11, v27, vcc
		v_add_co_u32_e64 v10, vcc, v8, v20
		v_addc_co_u32_e64 v11, vcc, v9, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v10, s47 offset:64
		scratch_store_dword off, v11, s47 offset:68
		v_mov_b32_e32 v8, 0x800c0
		v_add_co_u32_e64 v10, vcc, v6, v8
		v_addc_co_u32_e64 v11, vcc, v7, 0, vcc
		v_add_co_u32_e64 v16, vcc, v10, v18
		v_addc_co_u32_e64 v17, vcc, v11, v19, vcc
		v_add_co_u32_e64 v10, vcc, v16, v26
		v_addc_co_u32_e64 v11, vcc, v17, v27, vcc
		v_add_co_u32_e64 v16, vcc, v10, v20
		v_addc_co_u32_e64 v17, vcc, v11, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v16, s47 offset:72
		scratch_store_dword off, v17, s47 offset:76
		v_add_co_u32_e64 v10, vcc, v28, v1
		v_addc_co_u32_e64 v11, vcc, v29, 0, vcc
		v_add_co_u32_e64 v16, vcc, v10, v18
		v_addc_co_u32_e64 v17, vcc, v11, v19, vcc
		v_add_co_u32_e64 v10, vcc, v16, v26
		v_addc_co_u32_e64 v11, vcc, v17, v27, vcc
		v_add_co_u32_e64 v16, vcc, v10, v20
		v_addc_co_u32_e64 v17, vcc, v11, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v16, s47 offset:80
		scratch_store_dword off, v17, s47 offset:84
		v_add_co_u32_e64 v10, vcc, v28, v2
		v_addc_co_u32_e64 v11, vcc, v29, 0, vcc
		v_add_co_u32_e64 v16, vcc, v10, v18
		v_addc_co_u32_e64 v17, vcc, v11, v19, vcc
		v_add_co_u32_e64 v10, vcc, v16, v26
		v_addc_co_u32_e64 v11, vcc, v17, v27, vcc
		v_add_co_u32_e64 v16, vcc, v10, v20
		v_addc_co_u32_e64 v17, vcc, v11, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v16, s47 offset:88
		scratch_store_dword off, v17, s47 offset:92
		v_add_co_u32_e64 v10, vcc, v28, v3
		v_addc_co_u32_e64 v11, vcc, v29, 0, vcc
		v_add_co_u32_e64 v2, vcc, v10, v18
		v_addc_co_u32_e64 v3, vcc, v11, v19, vcc
		v_add_co_u32_e64 v10, vcc, v2, v26
		v_addc_co_u32_e64 v11, vcc, v3, v27, vcc
		v_add_co_u32_e64 v2, vcc, v10, v20
		v_addc_co_u32_e64 v3, vcc, v11, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:96
		scratch_store_dword off, v3, s47 offset:100
		v_add_co_u32_e64 v2, vcc, v28, v8
		v_addc_co_u32_e64 v3, vcc, v29, 0, vcc
		v_add_co_u32_e64 v8, vcc, v2, v18
		v_addc_co_u32_e64 v9, vcc, v3, v19, vcc
		v_add_co_u32_e64 v2, vcc, v8, v26
		v_addc_co_u32_e64 v3, vcc, v9, v27, vcc
		v_add_co_u32_e64 v8, vcc, v2, v20
		v_addc_co_u32_e64 v9, vcc, v3, v21, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v8, s47 offset:104
		scratch_store_dword off, v9, s47 offset:108
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v2, vcc, v6, v1
		v_addc_co_u32_e64 v3, vcc, v7, 0, vcc
		v_add_co_u32_e64 v8, vcc, v2, v4
		v_addc_co_u32_e64 v9, vcc, v3, v5, vcc
		v_add_co_u32_e64 v2, vcc, v8, v24
		v_addc_co_u32_e64 v3, vcc, v9, v25, vcc
		v_add_co_u32_e64 v10, vcc, v2, v30
		v_addc_co_u32_e64 v11, vcc, v3, v31, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v10, s47 offset:112
		scratch_store_dword off, v11, s47 offset:116
		v_mov_b32_e32 v1, 0x900
		v_add_co_u32_e64 v2, vcc, v6, v1
		v_addc_co_u32_e64 v3, vcc, v7, 0, vcc
		v_add_co_u32_e64 v6, vcc, v2, v4
		v_addc_co_u32_e64 v7, vcc, v3, v5, vcc
		v_add_co_u32_e64 v2, vcc, v6, v24
		v_addc_co_u32_e64 v3, vcc, v7, v25, vcc
		v_add_co_u32_e64 v4, vcc, v2, v30
		v_addc_co_u32_e64 v5, vcc, v3, v31, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:120
		scratch_store_dword off, v5, s47 offset:124
		v_add_co_u32_e64 v2, vcc, v8, v12
		v_addc_co_u32_e64 v3, vcc, v9, v13, vcc
		v_add_co_u32_e64 v4, vcc, v2, v14
		v_addc_co_u32_e64 v5, vcc, v3, v15, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:128
		scratch_store_dword off, v5, s47 offset:132
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:652
		scratch_store_dword off, v5, s47 offset:656
		scratch_store_dword off, v6, s47 offset:660
		scratch_store_dword off, v7, s47 offset:664
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:636
		scratch_store_dword off, v5, s47 offset:640
		scratch_store_dword off, v6, s47 offset:644
		scratch_store_dword off, v7, s47 offset:648
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:620
		scratch_store_dword off, v5, s47 offset:624
		scratch_store_dword off, v6, s47 offset:628
		scratch_store_dword off, v7, s47 offset:632
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:604
		scratch_store_dword off, v5, s47 offset:608
		scratch_store_dword off, v6, s47 offset:612
		scratch_store_dword off, v7, s47 offset:616
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:588
		scratch_store_dword off, v5, s47 offset:592
		scratch_store_dword off, v6, s47 offset:596
		scratch_store_dword off, v7, s47 offset:600
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:572
		scratch_store_dword off, v5, s47 offset:576
		scratch_store_dword off, v6, s47 offset:580
		scratch_store_dword off, v7, s47 offset:584
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:556
		scratch_store_dword off, v5, s47 offset:560
		scratch_store_dword off, v6, s47 offset:564
		scratch_store_dword off, v7, s47 offset:568
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:540
		scratch_store_dword off, v5, s47 offset:544
		scratch_store_dword off, v6, s47 offset:548
		scratch_store_dword off, v7, s47 offset:552
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:524
		scratch_store_dword off, v5, s47 offset:528
		scratch_store_dword off, v6, s47 offset:532
		scratch_store_dword off, v7, s47 offset:536
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:508
		scratch_store_dword off, v5, s47 offset:512
		scratch_store_dword off, v6, s47 offset:516
		scratch_store_dword off, v7, s47 offset:520
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:492
		scratch_store_dword off, v5, s47 offset:496
		scratch_store_dword off, v6, s47 offset:500
		scratch_store_dword off, v7, s47 offset:504
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:476
		scratch_store_dword off, v5, s47 offset:480
		scratch_store_dword off, v6, s47 offset:484
		scratch_store_dword off, v7, s47 offset:488
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:460
		scratch_store_dword off, v5, s47 offset:464
		scratch_store_dword off, v6, s47 offset:468
		scratch_store_dword off, v7, s47 offset:472
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:444
		scratch_store_dword off, v5, s47 offset:448
		scratch_store_dword off, v6, s47 offset:452
		scratch_store_dword off, v7, s47 offset:456
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:428
		scratch_store_dword off, v5, s47 offset:432
		scratch_store_dword off, v6, s47 offset:436
		scratch_store_dword off, v7, s47 offset:440
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:412
		scratch_store_dword off, v5, s47 offset:416
		scratch_store_dword off, v6, s47 offset:420
		scratch_store_dword off, v7, s47 offset:424
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:396
		scratch_store_dword off, v5, s47 offset:400
		scratch_store_dword off, v6, s47 offset:404
		scratch_store_dword off, v7, s47 offset:408
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:380
		scratch_store_dword off, v5, s47 offset:384
		scratch_store_dword off, v6, s47 offset:388
		scratch_store_dword off, v7, s47 offset:392
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:364
		scratch_store_dword off, v5, s47 offset:368
		scratch_store_dword off, v6, s47 offset:372
		scratch_store_dword off, v7, s47 offset:376
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:348
		scratch_store_dword off, v5, s47 offset:352
		scratch_store_dword off, v6, s47 offset:356
		scratch_store_dword off, v7, s47 offset:360
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:332
		scratch_store_dword off, v5, s47 offset:336
		scratch_store_dword off, v6, s47 offset:340
		scratch_store_dword off, v7, s47 offset:344
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:316
		scratch_store_dword off, v5, s47 offset:320
		scratch_store_dword off, v6, s47 offset:324
		scratch_store_dword off, v7, s47 offset:328
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:276
		scratch_store_dword off, v5, s47 offset:280
		scratch_store_dword off, v6, s47 offset:284
		scratch_store_dword off, v7, s47 offset:288
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:260
		scratch_store_dword off, v5, s47 offset:264
		scratch_store_dword off, v6, s47 offset:268
		scratch_store_dword off, v7, s47 offset:272
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:244
		scratch_store_dword off, v5, s47 offset:248
		scratch_store_dword off, v6, s47 offset:252
		scratch_store_dword off, v7, s47 offset:256
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:228
		scratch_store_dword off, v5, s47 offset:232
		scratch_store_dword off, v6, s47 offset:236
		scratch_store_dword off, v7, s47 offset:240
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:212
		scratch_store_dword off, v5, s47 offset:216
		scratch_store_dword off, v6, s47 offset:220
		scratch_store_dword off, v7, s47 offset:224
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:196
		scratch_store_dword off, v5, s47 offset:200
		scratch_store_dword off, v6, s47 offset:204
		scratch_store_dword off, v7, s47 offset:208
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:180
		scratch_store_dword off, v5, s47 offset:184
		scratch_store_dword off, v6, s47 offset:188
		scratch_store_dword off, v7, s47 offset:192
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:164
		scratch_store_dword off, v5, s47 offset:168
		scratch_store_dword off, v6, s47 offset:172
		scratch_store_dword off, v7, s47 offset:176
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:148
		scratch_store_dword off, v5, s47 offset:152
		scratch_store_dword off, v6, s47 offset:156
		scratch_store_dword off, v7, s47 offset:160
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v2, s46
		v_mov_b32_e32 v3, 0
		v_mov_b32_e32 v4, s48
		v_mov_b32_e32 v5, s49
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v4, off, s47 offset:1148
		scratch_load_dword v5, off, s47 offset:1152
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v6, v4, v2
		v_mul_hi_u32 v7, v4, v2
		v_mul_lo_u32 v1, v4, v3
		v_add_u32_e32 v7, v7, v1
		v_mul_lo_u32 v1, v5, v2
		v_add_u32_e32 v7, v7, v1
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x22800, v1
		s_waitcnt lgkmcnt(8)
		ds_read_b32 v4, v2
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x23000, v1
		ds_read_b32 v5, v2
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v2, vcc, v4, v6
		v_addc_co_u32_e64 v3, vcc, v5, v7, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x23800, v1
		ds_read_b32 v4, v3
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x24000, v1
		ds_read_b32 v5, v3
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v8, vcc, v4, v6
		v_addc_co_u32_e64 v9, vcc, v5, v7, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x24800, v1
		ds_read_b32 v4, v3
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x25000, v1
		ds_read_b32 v5, v3
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v10, vcc, v4, v6
		v_addc_co_u32_e64 v11, vcc, v5, v7, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x25800, v1
		ds_read_b32 v4, v3
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x26000, v1
		ds_read_b32 v5, v3
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v12, vcc, v4, v6
		v_addc_co_u32_e64 v13, vcc, v5, v7, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x26800, v1
		ds_read_b32 v4, v3
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x27000, v1
		ds_read_b32 v5, v3
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v14, vcc, v4, v6
		v_addc_co_u32_e64 v15, vcc, v5, v7, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47
		scratch_load_dword v5, off, s47 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v16, vcc, v4, v6
		v_addc_co_u32_e64 v17, vcc, v5, v7, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:8
		scratch_load_dword v5, off, s47 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v18, vcc, v4, v6
		v_addc_co_u32_e64 v19, vcc, v5, v7, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:16
		scratch_load_dword v5, off, s47 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v20, vcc, v4, v6
		v_addc_co_u32_e64 v21, vcc, v5, v7, vcc
		v_mov_b32_e32 v4, s46
		v_mov_b32_e32 v5, 0
		v_mov_b32_e32 v4, s50
		v_mov_b32_e32 v5, s51
		v_mov_b32_e32 v4, s50
		v_mov_b32_e32 v5, s51
		v_mov_b32_e32 v6, s46
		v_mov_b32_e32 v7, 0
		v_mul_lo_u32 v22, v4, v6
		v_mul_hi_u32 v23, v4, v6
		v_mul_lo_u32 v1, v4, v7
		v_add_u32_e32 v23, v23, v1
		v_mul_lo_u32 v1, v5, v6
		v_add_u32_e32 v23, v23, v1
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:24
		scratch_load_dword v5, off, s47 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v6, vcc, v4, v22
		v_addc_co_u32_e64 v7, vcc, v5, v23, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:32
		scratch_load_dword v5, off, s47 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v24, vcc, v4, v22
		v_addc_co_u32_e64 v25, vcc, v5, v23, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:40
		scratch_load_dword v5, off, s47 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v26, vcc, v4, v22
		v_addc_co_u32_e64 v27, vcc, v5, v23, vcc
		s_mov_b32 s47, 0
		scratch_load_dword v28, off, s47 offset:668
		scratch_load_dword v29, off, s47 offset:672
		scratch_load_dword v30, off, s47 offset:676
		scratch_load_dword v31, off, s47 offset:680
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v32, off, s47 offset:1104
		scratch_load_dword v33, off, s47 offset:1108
		scratch_load_dword v34, off, s47 offset:1112
		scratch_load_dword v35, off, s47 offset:1116
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v36, off, s47 offset:1000
		scratch_load_dword v37, off, s47 offset:1004
		scratch_load_dword v38, off, s47 offset:1008
		scratch_load_dword v39, off, s47 offset:1012
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v1, off, s47 offset:1144
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v3, off, s47 offset:1136
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[32:35], v[36:39], v[28:31], v1, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s47, s46, 1
		s_lshl_b32 s52, s47, 16
		s_mov_b32 s53, 0
		scratch_load_dword v4, off, s53 offset:136
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, s52, v4
		s_mov_b32 s53, 0
		scratch_load_dword v4, off, s53 offset:716
		s_mov_b32 s53, 0
		scratch_load_dword v7, off, s53 offset:720
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, v5, v7, v4
		ds_read_b128 v[40:43], v9 offset:16384
		s_mov_b32 s53, 0
		scratch_load_dword v44, off, s53 offset:652
		scratch_load_dword v45, off, s53 offset:656
		scratch_load_dword v46, off, s53 offset:660
		scratch_load_dword v47, off, s53 offset:664
		s_mov_b32 s53, 0
		scratch_load_dword v48, off, s53 offset:984
		scratch_load_dword v49, off, s53 offset:988
		scratch_load_dword v50, off, s53 offset:992
		scratch_load_dword v51, off, s53 offset:996
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[32:35], v[48:51], v[44:47], v1, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v9 offset:17408
		s_mov_b32 s53, 0
		scratch_load_dword v56, off, s53 offset:636
		scratch_load_dword v57, off, s53 offset:640
		scratch_load_dword v58, off, s53 offset:644
		scratch_load_dword v59, off, s53 offset:648
		s_mov_b32 s53, 0
		scratch_load_dword v60, off, s53 offset:968
		scratch_load_dword v61, off, s53 offset:972
		scratch_load_dword v62, off, s53 offset:976
		scratch_load_dword v63, off, s53 offset:980
		s_mov_b32 s53, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v4, off, s53 offset:1132
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[32:35], v[60:63], v[56:59], v1, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v9 offset:18432
		s_mov_b32 s53, 0
		scratch_load_dword v68, off, s53 offset:620
		scratch_load_dword v69, off, s53 offset:624
		scratch_load_dword v70, off, s53 offset:628
		scratch_load_dword v71, off, s53 offset:632
		s_mov_b32 s53, 0
		scratch_load_dword v72, off, s53 offset:952
		scratch_load_dword v73, off, s53 offset:956
		scratch_load_dword v74, off, s53 offset:960
		scratch_load_dword v75, off, s53 offset:964
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[32:35], v[72:75], v[68:71], v1, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v9 offset:19456
		s_mov_b32 s53, 0
		scratch_load_dword v80, off, s53 offset:604
		scratch_load_dword v81, off, s53 offset:608
		scratch_load_dword v82, off, s53 offset:612
		scratch_load_dword v83, off, s53 offset:616
		s_mov_b32 s53, 0
		scratch_load_dword v84, off, s53 offset:936
		scratch_load_dword v85, off, s53 offset:940
		scratch_load_dword v86, off, s53 offset:944
		scratch_load_dword v87, off, s53 offset:948
		s_mov_b32 s53, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v5, off, s53 offset:1128
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[32:35], v[84:87], v[80:83], v1, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s53, 0
		scratch_load_dword v7, off, s53 offset:720
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v11, s52, v7
		v_lshlrev_b32_e32 v7, 2, v0
		v_add_u32_e32 v13, 0x27800, v7
		ds_read_b32 v7, v13
		s_mov_b32 s52, 0
		scratch_load_dword v13, off, s52 offset:716
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v15, v11, v7, v13
		ds_read_b128 v[88:91], v15 offset:49152
		s_mov_b32 s52, 0
		scratch_load_dword v92, off, s52 offset:588
		scratch_load_dword v93, off, s52 offset:592
		scratch_load_dword v94, off, s52 offset:596
		scratch_load_dword v95, off, s52 offset:600
		s_mov_b32 s52, 0
		scratch_load_dword v96, off, s52 offset:920
		scratch_load_dword v97, off, s52 offset:924
		scratch_load_dword v98, off, s52 offset:928
		scratch_load_dword v99, off, s52 offset:932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[32:35], v[96:99], v[92:95], v1, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v15 offset:50176
		s_mov_b32 s52, 0
		scratch_load_dword v104, off, s52 offset:572
		scratch_load_dword v105, off, s52 offset:576
		scratch_load_dword v106, off, s52 offset:580
		scratch_load_dword v107, off, s52 offset:584
		s_mov_b32 s52, 0
		scratch_load_dword v108, off, s52 offset:904
		scratch_load_dword v109, off, s52 offset:908
		scratch_load_dword v110, off, s52 offset:912
		scratch_load_dword v111, off, s52 offset:916
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v7, off, s52 offset:1124
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[32:35], v[108:111], v[104:107], v1, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v15 offset:51200
		s_mov_b32 s52, 0
		scratch_load_dword v116, off, s52 offset:556
		scratch_load_dword v117, off, s52 offset:560
		scratch_load_dword v118, off, s52 offset:564
		scratch_load_dword v119, off, s52 offset:568
		s_mov_b32 s52, 0
		scratch_load_dword v120, off, s52 offset:888
		scratch_load_dword v121, off, s52 offset:892
		scratch_load_dword v122, off, s52 offset:896
		scratch_load_dword v123, off, s52 offset:900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[120:123], v[116:119], v1, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v15 offset:52224
		s_mov_b32 s52, 0
		scratch_load_dword v124, off, s52 offset:540
		scratch_load_dword v125, off, s52 offset:544
		scratch_load_dword v126, off, s52 offset:548
		scratch_load_dword v127, off, s52 offset:552
		s_mov_b32 s52, 0
		scratch_load_dword v128, off, s52 offset:1088
		scratch_load_dword v129, off, s52 offset:1092
		scratch_load_dword v130, off, s52 offset:1096
		scratch_load_dword v131, off, s52 offset:1100
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[128:131], v[36:39], v[124:127], v1, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v15 offset:53248
		s_mov_b32 s52, 0
		scratch_load_dword v136, off, s52 offset:524
		scratch_load_dword v137, off, s52 offset:528
		scratch_load_dword v138, off, s52 offset:532
		scratch_load_dword v139, off, s52 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[128:131], v[48:51], v[136:139], v1, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v15 offset:54272
		s_mov_b32 s52, 0
		scratch_load_dword v144, off, s52 offset:508
		scratch_load_dword v145, off, s52 offset:512
		scratch_load_dword v146, off, s52 offset:516
		scratch_load_dword v147, off, s52 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[128:131], v[60:63], v[144:147], v1, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v15 offset:55296
		s_mov_b32 s52, 0
		scratch_load_dword v152, off, s52 offset:492
		scratch_load_dword v153, off, s52 offset:496
		scratch_load_dword v154, off, s52 offset:500
		scratch_load_dword v155, off, s52 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[128:131], v[72:75], v[152:155], v1, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v15 offset:56320
		s_mov_b32 s52, 0
		scratch_load_dword v160, off, s52 offset:476
		scratch_load_dword v161, off, s52 offset:480
		scratch_load_dword v162, off, s52 offset:484
		scratch_load_dword v163, off, s52 offset:488
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[128:131], v[84:87], v[160:163], v1, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v164, off, s52 offset:460
		scratch_load_dword v165, off, s52 offset:464
		scratch_load_dword v166, off, s52 offset:468
		scratch_load_dword v167, off, s52 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[128:131], v[96:99], v[164:167], v1, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v168, off, s52 offset:444
		scratch_load_dword v169, off, s52 offset:448
		scratch_load_dword v170, off, s52 offset:452
		scratch_load_dword v171, off, s52 offset:456
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[128:131], v[108:111], v[168:171], v1, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v172, off, s52 offset:428
		scratch_load_dword v173, off, s52 offset:432
		scratch_load_dword v174, off, s52 offset:436
		scratch_load_dword v175, off, s52 offset:440
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[128:131], v[120:123], v[172:175], v1, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v128, off, s52 offset:412
		scratch_load_dword v129, off, s52 offset:416
		scratch_load_dword v130, off, s52 offset:420
		scratch_load_dword v131, off, s52 offset:424
		s_mov_b32 s52, 0
		scratch_load_dword v176, off, s52 offset:1072
		scratch_load_dword v177, off, s52 offset:1076
		scratch_load_dword v178, off, s52 offset:1080
		scratch_load_dword v179, off, s52 offset:1084
		s_mov_b32 s52, 0
		scratch_load_dword v2, off, s52 offset:1140
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[176:179], v[36:39], v[128:131], v2, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v180, off, s52 offset:396
		scratch_load_dword v181, off, s52 offset:400
		scratch_load_dword v182, off, s52 offset:404
		scratch_load_dword v183, off, s52 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[176:179], v[48:51], v[180:183], v2, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v184, off, s52 offset:380
		scratch_load_dword v185, off, s52 offset:384
		scratch_load_dword v186, off, s52 offset:388
		scratch_load_dword v187, off, s52 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[176:179], v[60:63], v[184:187], v2, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v16, off, s52 offset:364
		scratch_load_dword v17, off, s52 offset:368
		scratch_load_dword v18, off, s52 offset:372
		scratch_load_dword v19, off, s52 offset:376
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[176:179], v[72:75], v[16:19], v2, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v20, off, s52 offset:348
		scratch_load_dword v21, off, s52 offset:352
		scratch_load_dword v22, off, s52 offset:356
		scratch_load_dword v23, off, s52 offset:360
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[176:179], v[84:87], v[20:23], v2, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v6, s[4:7], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v188, off, s52 offset:332
		scratch_load_dword v189, off, s52 offset:336
		scratch_load_dword v190, off, s52 offset:340
		scratch_load_dword v191, off, s52 offset:344
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[176:179], v[96:99], v[188:191], v2, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x20000
		s_nop 0
		buffer_load_dword v24, s[4:7], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v192, off, s52 offset:316
		scratch_load_dword v193, off, s52 offset:320
		scratch_load_dword v194, off, s52 offset:324
		scratch_load_dword v195, off, s52 offset:328
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[176:179], v[108:111], v[192:195], v2, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x20000
		s_nop 0
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_mov_b32 s52, 0
		scratch_load_dword v24, off, s52 offset:276
		scratch_load_dword v25, off, s52 offset:280
		scratch_load_dword v26, off, s52 offset:284
		scratch_load_dword v27, off, s52 offset:288
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[176:179], v[120:123], v[24:27], v2, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[176:179], v9
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v176, s52 offset:1316
		scratch_store_dword off, v177, s52 offset:1320
		scratch_store_dword off, v178, s52 offset:1324
		scratch_store_dword off, v179, s52 offset:1328
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v176, off, s52 offset:1316
		scratch_load_dword v177, off, s52 offset:1320
		scratch_load_dword v178, off, s52 offset:1324
		scratch_load_dword v179, off, s52 offset:1328
		s_mov_b32 s52, 0
		scratch_load_dword v196, off, s52 offset:260
		scratch_load_dword v197, off, s52 offset:264
		scratch_load_dword v198, off, s52 offset:268
		scratch_load_dword v199, off, s52 offset:272
		s_mov_b32 s52, 0
		scratch_load_dword v200, off, s52 offset:1056
		scratch_load_dword v201, off, s52 offset:1060
		scratch_load_dword v202, off, s52 offset:1064
		scratch_load_dword v203, off, s52 offset:1068
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[200:203], v[36:39], v[196:199], v2, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v9 offset:1024
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v36, s52 offset:1300
		scratch_store_dword off, v37, s52 offset:1304
		scratch_store_dword off, v38, s52 offset:1308
		scratch_store_dword off, v39, s52 offset:1312
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v36, off, s52 offset:1300
		scratch_load_dword v37, off, s52 offset:1304
		scratch_load_dword v38, off, s52 offset:1308
		scratch_load_dword v39, off, s52 offset:1312
		s_mov_b32 s52, 0
		scratch_load_dword v204, off, s52 offset:244
		scratch_load_dword v205, off, s52 offset:248
		scratch_load_dword v206, off, s52 offset:252
		scratch_load_dword v207, off, s52 offset:256
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[200:203], v[48:51], v[204:207], v2, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v9 offset:2048
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v48, s52 offset:1284
		scratch_store_dword off, v49, s52 offset:1288
		scratch_store_dword off, v50, s52 offset:1292
		scratch_store_dword off, v51, s52 offset:1296
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v48, off, s52 offset:1284
		scratch_load_dword v49, off, s52 offset:1288
		scratch_load_dword v50, off, s52 offset:1292
		scratch_load_dword v51, off, s52 offset:1296
		s_mov_b32 s52, 0
		scratch_load_dword v208, off, s52 offset:228
		scratch_load_dword v209, off, s52 offset:232
		scratch_load_dword v210, off, s52 offset:236
		scratch_load_dword v211, off, s52 offset:240
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[200:203], v[60:63], v[208:211], v2, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[60:63], v9 offset:3072
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v60, s52 offset:684
		scratch_store_dword off, v61, s52 offset:688
		scratch_store_dword off, v62, s52 offset:692
		scratch_store_dword off, v63, s52 offset:696
		s_mov_b32 s52, 0
		scratch_store_dword off, v60, s52 offset:700
		scratch_store_dword off, v61, s52 offset:704
		scratch_store_dword off, v62, s52 offset:708
		scratch_store_dword off, v63, s52 offset:712
		s_mov_b32 s52, 0
		scratch_load_dword v8, off, s52 offset:212
		scratch_load_dword v9, off, s52 offset:216
		scratch_load_dword v10, off, s52 offset:220
		scratch_load_dword v11, off, s52 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[200:203], v[72:75], v[8:11], v2, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[60:63], v15 offset:32768
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v60, s52 offset:1268
		scratch_store_dword off, v61, s52 offset:1272
		scratch_store_dword off, v62, s52 offset:1276
		scratch_store_dword off, v63, s52 offset:1280
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v60, off, s52 offset:1268
		scratch_load_dword v61, off, s52 offset:1272
		scratch_load_dword v62, off, s52 offset:1276
		scratch_load_dword v63, off, s52 offset:1280
		s_mov_b32 s52, 0
		scratch_load_dword v72, off, s52 offset:196
		scratch_load_dword v73, off, s52 offset:200
		scratch_load_dword v74, off, s52 offset:204
		scratch_load_dword v75, off, s52 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[200:203], v[84:87], v[72:75], v2, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v15 offset:33792
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v84, s52 offset:1252
		scratch_store_dword off, v85, s52 offset:1256
		scratch_store_dword off, v86, s52 offset:1260
		scratch_store_dword off, v87, s52 offset:1264
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v84, off, s52 offset:1252
		scratch_load_dword v85, off, s52 offset:1256
		scratch_load_dword v86, off, s52 offset:1260
		scratch_load_dword v87, off, s52 offset:1264
		s_mov_b32 s52, 0
		scratch_load_dword v212, off, s52 offset:180
		scratch_load_dword v213, off, s52 offset:184
		scratch_load_dword v214, off, s52 offset:188
		scratch_load_dword v215, off, s52 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[200:203], v[96:99], v[212:215], v2, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v15 offset:34816
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s52 offset:1236
		scratch_store_dword off, v97, s52 offset:1240
		scratch_store_dword off, v98, s52 offset:1244
		scratch_store_dword off, v99, s52 offset:1248
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v96, off, s52 offset:1236
		scratch_load_dword v97, off, s52 offset:1240
		scratch_load_dword v98, off, s52 offset:1244
		scratch_load_dword v99, off, s52 offset:1248
		s_mov_b32 s52, 0
		scratch_load_dword v216, off, s52 offset:164
		scratch_load_dword v217, off, s52 offset:168
		scratch_load_dword v218, off, s52 offset:172
		scratch_load_dword v219, off, s52 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[200:203], v[108:111], v[216:219], v2, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v15 offset:35840
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v108, s52 offset:1220
		scratch_store_dword off, v109, s52 offset:1224
		scratch_store_dword off, v110, s52 offset:1228
		scratch_store_dword off, v111, s52 offset:1232
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v108, off, s52 offset:1220
		scratch_load_dword v109, off, s52 offset:1224
		scratch_load_dword v110, off, s52 offset:1228
		scratch_load_dword v111, off, s52 offset:1232
		s_mov_b32 s52, 0
		scratch_load_dword v220, off, s52 offset:148
		scratch_load_dword v221, off, s52 offset:152
		scratch_load_dword v222, off, s52 offset:156
		scratch_load_dword v223, off, s52 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[200:203], v[120:123], v[220:223], v2, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v15 offset:36864
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v120, s52 offset:1204
		scratch_store_dword off, v121, s52 offset:1208
		scratch_store_dword off, v122, s52 offset:1212
		scratch_store_dword off, v123, s52 offset:1216
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v120, off, s52 offset:1204
		scratch_load_dword v121, off, s52 offset:1208
		scratch_load_dword v122, off, s52 offset:1212
		scratch_load_dword v123, off, s52 offset:1216
		ds_read_b128 v[200:203], v15 offset:37888
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v200, s52 offset:1188
		scratch_store_dword off, v201, s52 offset:1192
		scratch_store_dword off, v202, s52 offset:1196
		scratch_store_dword off, v203, s52 offset:1200
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v200, off, s52 offset:1188
		scratch_load_dword v201, off, s52 offset:1192
		scratch_load_dword v202, off, s52 offset:1196
		scratch_load_dword v203, off, s52 offset:1200
		ds_read_b128 v[224:227], v15 offset:38912
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v224, s52 offset:1172
		scratch_store_dword off, v225, s52 offset:1176
		scratch_store_dword off, v226, s52 offset:1180
		scratch_store_dword off, v227, s52 offset:1184
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v224, off, s52 offset:1172
		scratch_load_dword v225, off, s52 offset:1176
		scratch_load_dword v226, off, s52 offset:1180
		scratch_load_dword v227, off, s52 offset:1184
		ds_read_b128 v[228:231], v15 offset:39936
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s52 offset:1156
		scratch_store_dword off, v229, s52 offset:1160
		scratch_store_dword off, v230, s52 offset:1164
		scratch_store_dword off, v231, s52 offset:1168
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v12, off, s52 offset:1156
		scratch_load_dword v13, off, s52 offset:1160
		scratch_load_dword v14, off, s52 offset:1164
		scratch_load_dword v15, off, s52 offset:1168
		s_lshl_b32 s52, s47, 12
		s_add_i32 s47, s52, 0x20000
		s_mov_b32 s52, 0
		scratch_load_dword v6, off, s52 offset:144
		s_mov_b32 s52, 0
		scratch_load_dword v228, off, s52 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v229, s47, v6, v228
		ds_read_b32 v6, v229
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s52 offset:312
		ds_read_b32 v6, v229 offset:256
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s52 offset:308
		s_mov_b32 s52, 0
		scratch_load_dword v6, off, s52 offset:140
		s_mov_b32 s52, 0
		scratch_load_dword v228, off, s52 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v229, s47, v228, v6
		ds_read_b32 v6, v229 offset:2048
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s47 offset:304
		ds_read_b32 v6, v229 offset:2304
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s47 offset:300
		ds_read_b32 v6, v229 offset:2560
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s47 offset:296
		ds_read_b32 v6, v229 offset:2816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s47 offset:292
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[40:43], v[88:91], v[28:31], v1, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[40:43], v[100:103], v[44:47], v1, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[40:43], v[112:115], v[56:59], v1, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[40:43], v[32:35], v[68:71], v1, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[40:43], v[132:135], v[80:83], v1, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[40:43], v[140:143], v[92:95], v1, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[40:43], v[148:151], v[104:107], v1, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[40:43], v[156:159], v[116:119], v1, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[52:55], v[88:91], v[124:127], v1, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[52:55], v[100:103], v[136:139], v1, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[52:55], v[112:115], v[144:147], v1, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[52:55], v[32:35], v[152:155], v1, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[52:55], v[132:135], v[160:163], v1, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[52:55], v[140:143], v[164:167], v1, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], v[148:151], v[168:171], v1, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], v[156:159], v[172:175], v1, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[64:67], v[88:91], v[128:131], v2, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[64:67], v[100:103], v[180:183], v2, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[64:67], v[112:115], v[184:187], v2, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[64:67], v[32:35], v[16:19], v2, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[64:67], v[132:135], v[20:23], v2, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[64:67], v[140:143], v[188:191], v2, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[64:67], v[148:151], v[192:195], v2, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[64:67], v[156:159], v[24:27], v2, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[76:79], v[88:91], v[196:199], v2, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[76:79], v[100:103], v[204:207], v2, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[76:79], v[112:115], v[208:211], v2, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[76:79], v[32:35], v[8:11], v2, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[76:79], v[132:135], v[72:75], v2, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[76:79], v[140:143], v[212:215], v2, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[76:79], v[148:151], v[216:219], v2, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[76:79], v[156:159], v[220:223], v2, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s47, s46, 1
		s_and_b32 s52, s47, 1
		s_lshl_b32 s47, s52, 16
		s_mov_b32 s53, 0
		scratch_load_dword v1, off, s53 offset:136
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s47, v1
		s_mov_b32 s53, 0
		scratch_load_dword v1, off, s53 offset:716
		s_mov_b32 s53, 0
		scratch_load_dword v3, off, s53 offset:720
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, v2, v3, v1
		ds_read_b128 v[32:35], v4
		ds_read_b128 v[40:43], v4 offset:1024
		ds_read_b128 v[52:55], v4 offset:2048
		ds_read_b128 v[64:67], v4 offset:3072
		s_mov_b32 s53, 0
		scratch_load_dword v1, off, s53 offset:720
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s47, v1
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x27800, v1
		ds_read_b32 v1, v3
		s_mov_b32 s47, 0
		scratch_load_dword v3, off, s47 offset:716
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v5, v2, v1, v3
		ds_read_b128 v[76:79], v5 offset:32768
		ds_read_b128 v[88:91], v5 offset:33792
		ds_read_b128 v[100:103], v5 offset:34816
		ds_read_b128 v[112:115], v5 offset:35840
		ds_read_b128 v[132:135], v5 offset:36864
		ds_read_b128 v[140:143], v5 offset:37888
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v140, s47 offset:1608
		scratch_store_dword off, v141, s47 offset:1612
		scratch_store_dword off, v142, s47 offset:1616
		scratch_store_dword off, v143, s47 offset:1620
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1624
		scratch_store_dword off, v141, s47 offset:1628
		scratch_store_dword off, v142, s47 offset:1632
		scratch_store_dword off, v143, s47 offset:1636
		ds_read_b128 v[140:143], v5 offset:38912
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v140, s47 offset:1512
		scratch_store_dword off, v141, s47 offset:1516
		scratch_store_dword off, v142, s47 offset:1520
		scratch_store_dword off, v143, s47 offset:1524
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1528
		scratch_store_dword off, v141, s47 offset:1532
		scratch_store_dword off, v142, s47 offset:1536
		scratch_store_dword off, v143, s47 offset:1540
		ds_read_b128 v[140:143], v5 offset:39936
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v140, s47 offset:1464
		scratch_store_dword off, v141, s47 offset:1468
		scratch_store_dword off, v142, s47 offset:1472
		scratch_store_dword off, v143, s47 offset:1476
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1480
		scratch_store_dword off, v141, s47 offset:1484
		scratch_store_dword off, v142, s47 offset:1488
		scratch_store_dword off, v143, s47 offset:1492
		s_lshl_b32 s47, s52, 12
		s_add_i32 s52, s47, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:144
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, s52, v1, v2
		ds_read_b32 v1, v3
		ds_read_b32 v2, v3 offset:256
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:140
		s_mov_b32 s47, 0
		scratch_load_dword v3, off, s47 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v6, s52, v3, v2
		ds_read_b32 v2, v6 offset:2048
		ds_read_b32 v3, v6 offset:2304
		ds_read_b32 v7, v6 offset:2560
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v7, s47 offset:1052
		ds_read_b32 v7, v6 offset:2816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v7, s47 offset:1048
		v_mov_b32_e32 v6, s48
		v_mov_b32_e32 v7, s49
		v_mov_b32_e32 v140, s46
		v_mov_b32_e32 v141, 0
		v_mul_lo_u32 v142, v6, v140
		v_mul_hi_u32 v143, v6, v140
		v_mul_lo_u32 v148, v6, v141
		v_add_u32_e32 v143, v143, v148
		v_mul_lo_u32 v148, v7, v140
		v_add_u32_e32 v143, v143, v148
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:48
		scratch_load_dword v7, off, s47 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1452
		scratch_store_dword off, v141, s47 offset:1456
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1452
		scratch_load_dword v7, off, s47 offset:1456
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1460
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:56
		scratch_load_dword v7, off, s47 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1440
		scratch_store_dword off, v141, s47 offset:1444
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1440
		scratch_load_dword v7, off, s47 offset:1444
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1448
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:64
		scratch_load_dword v7, off, s47 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1428
		scratch_store_dword off, v141, s47 offset:1432
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1428
		scratch_load_dword v7, off, s47 offset:1432
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1436
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:72
		scratch_load_dword v7, off, s47 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1416
		scratch_store_dword off, v141, s47 offset:1420
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1416
		scratch_load_dword v7, off, s47 offset:1420
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1424
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:80
		scratch_load_dword v7, off, s47 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1404
		scratch_store_dword off, v141, s47 offset:1408
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1404
		scratch_load_dword v7, off, s47 offset:1408
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1412
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:88
		scratch_load_dword v7, off, s47 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1392
		scratch_store_dword off, v141, s47 offset:1396
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1392
		scratch_load_dword v7, off, s47 offset:1396
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1400
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:96
		scratch_load_dword v7, off, s47 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1380
		scratch_store_dword off, v141, s47 offset:1384
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1380
		scratch_load_dword v7, off, s47 offset:1384
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1388
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:104
		scratch_load_dword v7, off, s47 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1368
		scratch_store_dword off, v141, s47 offset:1372
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1368
		scratch_load_dword v7, off, s47 offset:1372
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1376
		v_mov_b32_e32 v6, s50
		v_mov_b32_e32 v7, s51
		v_mov_b32_e32 v140, s46
		v_mov_b32_e32 v141, 0
		v_mul_lo_u32 v142, v6, v140
		v_mul_hi_u32 v143, v6, v140
		v_mul_lo_u32 v148, v6, v141
		v_add_u32_e32 v143, v143, v148
		v_mul_lo_u32 v148, v7, v140
		v_add_u32_e32 v143, v143, v148
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:112
		scratch_load_dword v7, off, s47 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1356
		scratch_store_dword off, v141, s47 offset:1360
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1356
		scratch_load_dword v7, off, s47 offset:1360
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1364
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:120
		scratch_load_dword v7, off, s47 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1344
		scratch_store_dword off, v141, s47 offset:1348
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1344
		scratch_load_dword v7, off, s47 offset:1348
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1352
		s_mov_b32 s47, 0
		scratch_load_dword v6, off, s47 offset:128
		scratch_load_dword v7, off, s47 offset:132
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v140, vcc, v6, v142
		v_addc_co_u32_e64 v141, vcc, v7, v143, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:1332
		scratch_store_dword off, v141, s47 offset:1336
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s47 offset:1332
		scratch_load_dword v7, off, s47 offset:1336
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v6, s47 offset:1340
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[32:35], v[76:79], v[28:31], v1, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v4 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[32:35], v[88:91], v[44:47], v1, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v4 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[32:35], v[100:103], v[56:59], v1, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v4 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[32:35], v[112:115], v[68:71], v1, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v4 offset:19456
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:1496
		scratch_store_dword off, v229, s47 offset:1500
		scratch_store_dword off, v230, s47 offset:1504
		scratch_store_dword off, v231, s47 offset:1508
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:1016
		scratch_store_dword off, v229, s47 offset:1020
		scratch_store_dword off, v230, s47 offset:1024
		scratch_store_dword off, v231, s47 offset:1028
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v228, off, s47 offset:1496
		scratch_load_dword v229, off, s47 offset:1500
		scratch_load_dword v230, off, s47 offset:1504
		scratch_load_dword v231, off, s47 offset:1508
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v228, s47 offset:1032
		scratch_store_dword off, v229, s47 offset:1036
		scratch_store_dword off, v230, s47 offset:1040
		scratch_store_dword off, v231, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1052
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[32:35], v[132:135], v[80:83], v1, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v5 offset:49152
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:1576
		scratch_store_dword off, v229, s47 offset:1580
		scratch_store_dword off, v230, s47 offset:1584
		scratch_store_dword off, v231, s47 offset:1588
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:1592
		scratch_store_dword off, v229, s47 offset:1596
		scratch_store_dword off, v230, s47 offset:1600
		scratch_store_dword off, v231, s47 offset:1604
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:1624
		scratch_load_dword v229, off, s47 offset:1628
		scratch_load_dword v230, off, s47 offset:1632
		scratch_load_dword v231, off, s47 offset:1636
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[32:35], v[228:231], v[92:95], v1, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v5 offset:50176
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:1544
		scratch_store_dword off, v229, s47 offset:1548
		scratch_store_dword off, v230, s47 offset:1552
		scratch_store_dword off, v231, s47 offset:1556
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:1560
		scratch_store_dword off, v229, s47 offset:1564
		scratch_store_dword off, v230, s47 offset:1568
		scratch_store_dword off, v231, s47 offset:1572
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:1528
		scratch_load_dword v229, off, s47 offset:1532
		scratch_load_dword v230, off, s47 offset:1536
		scratch_load_dword v231, off, s47 offset:1540
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[32:35], v[228:231], v[104:107], v1, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v5 offset:51200
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:1640
		scratch_store_dword off, v229, s47 offset:1644
		scratch_store_dword off, v230, s47 offset:1648
		scratch_store_dword off, v231, s47 offset:1652
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:1656
		scratch_store_dword off, v229, s47 offset:1660
		scratch_store_dword off, v230, s47 offset:1664
		scratch_store_dword off, v231, s47 offset:1668
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:1480
		scratch_load_dword v229, off, s47 offset:1484
		scratch_load_dword v230, off, s47 offset:1488
		scratch_load_dword v231, off, s47 offset:1492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[228:231], v[116:119], v1, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:52224
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s47 offset:856
		scratch_store_dword off, v33, s47 offset:860
		scratch_store_dword off, v34, s47 offset:864
		scratch_store_dword off, v35, s47 offset:868
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:872
		scratch_store_dword off, v33, s47 offset:876
		scratch_store_dword off, v34, s47 offset:880
		scratch_store_dword off, v35, s47 offset:884
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[40:43], v[76:79], v[124:127], v1, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:53248
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s47 offset:824
		scratch_store_dword off, v33, s47 offset:828
		scratch_store_dword off, v34, s47 offset:832
		scratch_store_dword off, v35, s47 offset:836
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:840
		scratch_store_dword off, v33, s47 offset:844
		scratch_store_dword off, v34, s47 offset:848
		scratch_store_dword off, v35, s47 offset:852
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[40:43], v[88:91], v[136:139], v1, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:54272
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s47 offset:792
		scratch_store_dword off, v33, s47 offset:796
		scratch_store_dword off, v34, s47 offset:800
		scratch_store_dword off, v35, s47 offset:804
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:808
		scratch_store_dword off, v33, s47 offset:812
		scratch_store_dword off, v34, s47 offset:816
		scratch_store_dword off, v35, s47 offset:820
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[100:103], v[144:147], v1, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:55296
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s47 offset:760
		scratch_store_dword off, v33, s47 offset:764
		scratch_store_dword off, v34, s47 offset:768
		scratch_store_dword off, v35, s47 offset:772
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:776
		scratch_store_dword off, v33, s47 offset:780
		scratch_store_dword off, v34, s47 offset:784
		scratch_store_dword off, v35, s47 offset:788
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[112:115], v[152:155], v1, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:56320
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s47 offset:728
		scratch_store_dword off, v33, s47 offset:732
		scratch_store_dword off, v34, s47 offset:736
		scratch_store_dword off, v35, s47 offset:740
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:744
		scratch_store_dword off, v33, s47 offset:748
		scratch_store_dword off, v34, s47 offset:752
		scratch_store_dword off, v35, s47 offset:756
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1052
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[132:135], v[160:163], v1, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1460
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1624
		scratch_load_dword v33, off, s47 offset:1628
		scratch_load_dword v34, off, s47 offset:1632
		scratch_load_dword v35, off, s47 offset:1636
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[32:35], v[164:167], v1, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1448
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1528
		scratch_load_dword v33, off, s47 offset:1532
		scratch_load_dword v34, off, s47 offset:1536
		scratch_load_dword v35, off, s47 offset:1540
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[32:35], v[168:171], v1, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1436
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1480
		scratch_load_dword v33, off, s47 offset:1484
		scratch_load_dword v34, off, s47 offset:1488
		scratch_load_dword v35, off, s47 offset:1492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[32:35], v[172:175], v1, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1424
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[52:55], v[76:79], v[128:131], v4, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1412
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[52:55], v[88:91], v[180:183], v4, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1400
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[52:55], v[100:103], v[184:187], v4, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s43
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1388
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[52:55], v[112:115], v[16:19], v4, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1376
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v5, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[52:55], v[132:135], v[20:23], v5, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1364
		s_waitcnt vmcnt(0)
		buffer_load_dword v4, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v5, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1624
		scratch_load_dword v33, off, s47 offset:1628
		scratch_load_dword v34, off, s47 offset:1632
		scratch_load_dword v35, off, s47 offset:1636
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], v[32:35], v[188:191], v5, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1352
		s_waitcnt vmcnt(0)
		buffer_load_dword v4, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v5, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1528
		scratch_load_dword v33, off, s47 offset:1532
		scratch_load_dword v34, off, s47 offset:1536
		scratch_load_dword v35, off, s47 offset:1540
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], v[32:35], v[192:195], v5, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1340
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v5, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1480
		scratch_load_dword v33, off, s47 offset:1484
		scratch_load_dword v34, off, s47 offset:1488
		scratch_load_dword v35, off, s47 offset:1492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[52:55], v[32:35], v[24:27], v5, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[64:67], v[76:79], v[196:199], v4, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[64:67], v[88:91], v[204:207], v4, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], v[100:103], v[208:211], v4, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[64:67], v[112:115], v[8:11], v4, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v5, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[64:67], v[132:135], v[72:75], v5, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v5, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1624
		scratch_load_dword v33, off, s47 offset:1628
		scratch_load_dword v34, off, s47 offset:1632
		scratch_load_dword v35, off, s47 offset:1636
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], v[32:35], v[212:215], v5, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v5, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1528
		scratch_load_dword v33, off, s47 offset:1532
		scratch_load_dword v34, off, s47 offset:1536
		scratch_load_dword v35, off, s47 offset:1540
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[64:67], v[32:35], v[216:219], v5, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v5, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1480
		scratch_load_dword v33, off, s47 offset:1484
		scratch_load_dword v34, off, s47 offset:1488
		scratch_load_dword v35, off, s47 offset:1492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], v[32:35], v[220:223], v5, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v4, off, s47 offset:1592
		scratch_load_dword v5, off, s47 offset:1596
		scratch_load_dword v6, off, s47 offset:1600
		scratch_load_dword v7, off, s47 offset:1604
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[140:143], v[4:7], v[28:31], v1, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v4, off, s47 offset:1560
		scratch_load_dword v5, off, s47 offset:1564
		scratch_load_dword v6, off, s47 offset:1568
		scratch_load_dword v7, off, s47 offset:1572
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[140:143], v[4:7], v[44:47], v1, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v4, off, s47 offset:1656
		scratch_load_dword v5, off, s47 offset:1660
		scratch_load_dword v6, off, s47 offset:1664
		scratch_load_dword v7, off, s47 offset:1668
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[140:143], v[4:7], v[56:59], v1, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v4, off, s47 offset:872
		scratch_load_dword v5, off, s47 offset:876
		scratch_load_dword v6, off, s47 offset:880
		scratch_load_dword v7, off, s47 offset:884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[140:143], v[4:7], v[68:71], v1, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v4, off, s47 offset:840
		scratch_load_dword v5, off, s47 offset:844
		scratch_load_dword v6, off, s47 offset:848
		scratch_load_dword v7, off, s47 offset:852
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1052
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[140:143], v[4:7], v[80:83], v1, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v4, off, s47 offset:808
		scratch_load_dword v5, off, s47 offset:812
		scratch_load_dword v6, off, s47 offset:816
		scratch_load_dword v7, off, s47 offset:820
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1052
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[140:143], v[4:7], v[92:95], v1, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v4, off, s47 offset:776
		scratch_load_dword v5, off, s47 offset:780
		scratch_load_dword v6, off, s47 offset:784
		scratch_load_dword v7, off, s47 offset:788
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1048
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[140:143], v[4:7], v[104:107], v1, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v4, off, s47 offset:744
		scratch_load_dword v5, off, s47 offset:748
		scratch_load_dword v6, off, s47 offset:752
		scratch_load_dword v7, off, s47 offset:756
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1048
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[140:143], v[4:7], v[116:119], v1, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1592
		scratch_load_dword v5, off, s47 offset:1596
		scratch_load_dword v6, off, s47 offset:1600
		scratch_load_dword v7, off, s47 offset:1604
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[148:151], v[4:7], v[124:127], v1, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1560
		scratch_load_dword v5, off, s47 offset:1564
		scratch_load_dword v6, off, s47 offset:1568
		scratch_load_dword v7, off, s47 offset:1572
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[148:151], v[4:7], v[136:139], v1, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1656
		scratch_load_dword v5, off, s47 offset:1660
		scratch_load_dword v6, off, s47 offset:1664
		scratch_load_dword v7, off, s47 offset:1668
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[148:151], v[4:7], v[144:147], v1, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:872
		scratch_load_dword v5, off, s47 offset:876
		scratch_load_dword v6, off, s47 offset:880
		scratch_load_dword v7, off, s47 offset:884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[148:151], v[4:7], v[152:155], v1, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:840
		scratch_load_dword v5, off, s47 offset:844
		scratch_load_dword v6, off, s47 offset:848
		scratch_load_dword v7, off, s47 offset:852
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1052
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[148:151], v[4:7], v[160:163], v1, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:808
		scratch_load_dword v5, off, s47 offset:812
		scratch_load_dword v6, off, s47 offset:816
		scratch_load_dword v7, off, s47 offset:820
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1052
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[148:151], v[4:7], v[164:167], v1, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:776
		scratch_load_dword v5, off, s47 offset:780
		scratch_load_dword v6, off, s47 offset:784
		scratch_load_dword v7, off, s47 offset:788
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1048
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[148:151], v[4:7], v[168:171], v1, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:744
		scratch_load_dword v5, off, s47 offset:748
		scratch_load_dword v6, off, s47 offset:752
		scratch_load_dword v7, off, s47 offset:756
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1048
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[148:151], v[4:7], v[172:175], v1, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1592
		scratch_load_dword v5, off, s47 offset:1596
		scratch_load_dword v6, off, s47 offset:1600
		scratch_load_dword v7, off, s47 offset:1604
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[156:159], v[4:7], v[128:131], v1, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1560
		scratch_load_dword v5, off, s47 offset:1564
		scratch_load_dword v6, off, s47 offset:1568
		scratch_load_dword v7, off, s47 offset:1572
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[156:159], v[4:7], v[180:183], v1, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1656
		scratch_load_dword v5, off, s47 offset:1660
		scratch_load_dword v6, off, s47 offset:1664
		scratch_load_dword v7, off, s47 offset:1668
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[156:159], v[4:7], v[184:187], v1, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:872
		scratch_load_dword v5, off, s47 offset:876
		scratch_load_dword v6, off, s47 offset:880
		scratch_load_dword v7, off, s47 offset:884
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[156:159], v[4:7], v[16:19], v1, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:840
		scratch_load_dword v5, off, s47 offset:844
		scratch_load_dword v6, off, s47 offset:848
		scratch_load_dword v7, off, s47 offset:852
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[156:159], v[4:7], v[20:23], v32, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:808
		scratch_load_dword v5, off, s47 offset:812
		scratch_load_dword v6, off, s47 offset:816
		scratch_load_dword v7, off, s47 offset:820
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[156:159], v[4:7], v[188:191], v32, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:776
		scratch_load_dword v5, off, s47 offset:780
		scratch_load_dword v6, off, s47 offset:784
		scratch_load_dword v7, off, s47 offset:788
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[156:159], v[4:7], v[192:195], v32, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:744
		scratch_load_dword v5, off, s47 offset:748
		scratch_load_dword v6, off, s47 offset:752
		scratch_load_dword v7, off, s47 offset:756
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[156:159], v[4:7], v[24:27], v32, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1032
		scratch_load_dword v5, off, s47 offset:1036
		scratch_load_dword v6, off, s47 offset:1040
		scratch_load_dword v7, off, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1592
		scratch_load_dword v33, off, s47 offset:1596
		scratch_load_dword v34, off, s47 offset:1600
		scratch_load_dword v35, off, s47 offset:1604
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[4:7], v[32:35], v[196:199], v1, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1032
		scratch_load_dword v5, off, s47 offset:1036
		scratch_load_dword v6, off, s47 offset:1040
		scratch_load_dword v7, off, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1560
		scratch_load_dword v33, off, s47 offset:1564
		scratch_load_dword v34, off, s47 offset:1568
		scratch_load_dword v35, off, s47 offset:1572
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[4:7], v[32:35], v[204:207], v1, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:1032
		scratch_load_dword v5, off, s47 offset:1036
		scratch_load_dword v6, off, s47 offset:1040
		scratch_load_dword v7, off, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1120
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1656
		scratch_load_dword v33, off, s47 offset:1660
		scratch_load_dword v34, off, s47 offset:1664
		scratch_load_dword v35, off, s47 offset:1668
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[4:7], v[32:35], v[208:211], v1, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:872
		scratch_load_dword v5, off, s47 offset:876
		scratch_load_dword v6, off, s47 offset:880
		scratch_load_dword v7, off, s47 offset:884
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1032
		scratch_load_dword v33, off, s47 offset:1036
		scratch_load_dword v34, off, s47 offset:1040
		scratch_load_dword v35, off, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[4:7], v[8:11], v1, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:840
		scratch_load_dword v5, off, s47 offset:844
		scratch_load_dword v6, off, s47 offset:848
		scratch_load_dword v7, off, s47 offset:852
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1032
		scratch_load_dword v33, off, s47 offset:1036
		scratch_load_dword v34, off, s47 offset:1040
		scratch_load_dword v35, off, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[32:35], v[4:7], v[72:75], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:808
		scratch_load_dword v5, off, s47 offset:812
		scratch_load_dword v6, off, s47 offset:816
		scratch_load_dword v7, off, s47 offset:820
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1032
		scratch_load_dword v33, off, s47 offset:1036
		scratch_load_dword v34, off, s47 offset:1040
		scratch_load_dword v35, off, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[4:7], v[212:215], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:776
		scratch_load_dword v5, off, s47 offset:780
		scratch_load_dword v6, off, s47 offset:784
		scratch_load_dword v7, off, s47 offset:788
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1032
		scratch_load_dword v33, off, s47 offset:1036
		scratch_load_dword v34, off, s47 offset:1040
		scratch_load_dword v35, off, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[4:7], v[216:219], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:744
		scratch_load_dword v5, off, s47 offset:748
		scratch_load_dword v6, off, s47 offset:752
		scratch_load_dword v7, off, s47 offset:756
		s_mov_b32 s47, 0
		scratch_load_dword v32, off, s47 offset:1032
		scratch_load_dword v33, off, s47 offset:1036
		scratch_load_dword v34, off, s47 offset:1040
		scratch_load_dword v35, off, s47 offset:1044
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1048
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:1120
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[4:7], v[220:223], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s46, s46, 2
		s_cmp_lt_i32 s46, s11
		s_mov_b32 s47, 0
		scratch_load_dword v4, off, s47 offset:700
		scratch_load_dword v5, off, s47 offset:704
		scratch_load_dword v6, off, s47 offset:708
		scratch_load_dword v7, off, s47 offset:712
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v4
		v_mov_b32_e32 v33, v5
		v_mov_b32_e32 v34, v6
		v_mov_b32_e32 v35, v7
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:312
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v2, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:308
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v3, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:304
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v4, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:300
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v5, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:296
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v6, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:292
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v7, v1
		s_mov_b32 s47, 0
		scratch_store_dword off, v28, s47 offset:668
		scratch_store_dword off, v29, s47 offset:672
		scratch_store_dword off, v30, s47 offset:676
		scratch_store_dword off, v31, s47 offset:680
		s_mov_b32 s47, 0
		scratch_store_dword off, v44, s47 offset:652
		scratch_store_dword off, v45, s47 offset:656
		scratch_store_dword off, v46, s47 offset:660
		scratch_store_dword off, v47, s47 offset:664
		s_mov_b32 s47, 0
		scratch_store_dword off, v56, s47 offset:636
		scratch_store_dword off, v57, s47 offset:640
		scratch_store_dword off, v58, s47 offset:644
		scratch_store_dword off, v59, s47 offset:648
		s_mov_b32 s47, 0
		scratch_store_dword off, v68, s47 offset:620
		scratch_store_dword off, v69, s47 offset:624
		scratch_store_dword off, v70, s47 offset:628
		scratch_store_dword off, v71, s47 offset:632
		s_mov_b32 s47, 0
		scratch_store_dword off, v80, s47 offset:604
		scratch_store_dword off, v81, s47 offset:608
		scratch_store_dword off, v82, s47 offset:612
		scratch_store_dword off, v83, s47 offset:616
		s_mov_b32 s47, 0
		scratch_store_dword off, v92, s47 offset:588
		scratch_store_dword off, v93, s47 offset:592
		scratch_store_dword off, v94, s47 offset:596
		scratch_store_dword off, v95, s47 offset:600
		s_mov_b32 s47, 0
		scratch_store_dword off, v104, s47 offset:572
		scratch_store_dword off, v105, s47 offset:576
		scratch_store_dword off, v106, s47 offset:580
		scratch_store_dword off, v107, s47 offset:584
		s_mov_b32 s47, 0
		scratch_store_dword off, v116, s47 offset:556
		scratch_store_dword off, v117, s47 offset:560
		scratch_store_dword off, v118, s47 offset:564
		scratch_store_dword off, v119, s47 offset:568
		s_mov_b32 s47, 0
		scratch_store_dword off, v124, s47 offset:540
		scratch_store_dword off, v125, s47 offset:544
		scratch_store_dword off, v126, s47 offset:548
		scratch_store_dword off, v127, s47 offset:552
		s_mov_b32 s47, 0
		scratch_store_dword off, v136, s47 offset:524
		scratch_store_dword off, v137, s47 offset:528
		scratch_store_dword off, v138, s47 offset:532
		scratch_store_dword off, v139, s47 offset:536
		s_mov_b32 s47, 0
		scratch_store_dword off, v144, s47 offset:508
		scratch_store_dword off, v145, s47 offset:512
		scratch_store_dword off, v146, s47 offset:516
		scratch_store_dword off, v147, s47 offset:520
		s_mov_b32 s47, 0
		scratch_store_dword off, v152, s47 offset:492
		scratch_store_dword off, v153, s47 offset:496
		scratch_store_dword off, v154, s47 offset:500
		scratch_store_dword off, v155, s47 offset:504
		s_mov_b32 s47, 0
		scratch_store_dword off, v160, s47 offset:476
		scratch_store_dword off, v161, s47 offset:480
		scratch_store_dword off, v162, s47 offset:484
		scratch_store_dword off, v163, s47 offset:488
		s_mov_b32 s47, 0
		scratch_store_dword off, v164, s47 offset:460
		scratch_store_dword off, v165, s47 offset:464
		scratch_store_dword off, v166, s47 offset:468
		scratch_store_dword off, v167, s47 offset:472
		s_mov_b32 s47, 0
		scratch_store_dword off, v168, s47 offset:444
		scratch_store_dword off, v169, s47 offset:448
		scratch_store_dword off, v170, s47 offset:452
		scratch_store_dword off, v171, s47 offset:456
		s_mov_b32 s47, 0
		scratch_store_dword off, v172, s47 offset:428
		scratch_store_dword off, v173, s47 offset:432
		scratch_store_dword off, v174, s47 offset:436
		scratch_store_dword off, v175, s47 offset:440
		s_mov_b32 s47, 0
		scratch_store_dword off, v128, s47 offset:412
		scratch_store_dword off, v129, s47 offset:416
		scratch_store_dword off, v130, s47 offset:420
		scratch_store_dword off, v131, s47 offset:424
		s_mov_b32 s47, 0
		scratch_store_dword off, v180, s47 offset:396
		scratch_store_dword off, v181, s47 offset:400
		scratch_store_dword off, v182, s47 offset:404
		scratch_store_dword off, v183, s47 offset:408
		s_mov_b32 s47, 0
		scratch_store_dword off, v184, s47 offset:380
		scratch_store_dword off, v185, s47 offset:384
		scratch_store_dword off, v186, s47 offset:388
		scratch_store_dword off, v187, s47 offset:392
		s_mov_b32 s47, 0
		scratch_store_dword off, v16, s47 offset:364
		scratch_store_dword off, v17, s47 offset:368
		scratch_store_dword off, v18, s47 offset:372
		scratch_store_dword off, v19, s47 offset:376
		s_mov_b32 s47, 0
		scratch_store_dword off, v20, s47 offset:348
		scratch_store_dword off, v21, s47 offset:352
		scratch_store_dword off, v22, s47 offset:356
		scratch_store_dword off, v23, s47 offset:360
		s_mov_b32 s47, 0
		scratch_store_dword off, v188, s47 offset:332
		scratch_store_dword off, v189, s47 offset:336
		scratch_store_dword off, v190, s47 offset:340
		scratch_store_dword off, v191, s47 offset:344
		s_mov_b32 s47, 0
		scratch_store_dword off, v192, s47 offset:316
		scratch_store_dword off, v193, s47 offset:320
		scratch_store_dword off, v194, s47 offset:324
		scratch_store_dword off, v195, s47 offset:328
		s_mov_b32 s47, 0
		scratch_store_dword off, v24, s47 offset:276
		scratch_store_dword off, v25, s47 offset:280
		scratch_store_dword off, v26, s47 offset:284
		scratch_store_dword off, v27, s47 offset:288
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:260
		scratch_store_dword off, v197, s47 offset:264
		scratch_store_dword off, v198, s47 offset:268
		scratch_store_dword off, v199, s47 offset:272
		s_mov_b32 s47, 0
		scratch_store_dword off, v204, s47 offset:244
		scratch_store_dword off, v205, s47 offset:248
		scratch_store_dword off, v206, s47 offset:252
		scratch_store_dword off, v207, s47 offset:256
		s_mov_b32 s47, 0
		scratch_store_dword off, v208, s47 offset:228
		scratch_store_dword off, v209, s47 offset:232
		scratch_store_dword off, v210, s47 offset:236
		scratch_store_dword off, v211, s47 offset:240
		s_mov_b32 s47, 0
		scratch_store_dword off, v8, s47 offset:212
		scratch_store_dword off, v9, s47 offset:216
		scratch_store_dword off, v10, s47 offset:220
		scratch_store_dword off, v11, s47 offset:224
		s_mov_b32 s47, 0
		scratch_store_dword off, v72, s47 offset:196
		scratch_store_dword off, v73, s47 offset:200
		scratch_store_dword off, v74, s47 offset:204
		scratch_store_dword off, v75, s47 offset:208
		s_mov_b32 s47, 0
		scratch_store_dword off, v212, s47 offset:180
		scratch_store_dword off, v213, s47 offset:184
		scratch_store_dword off, v214, s47 offset:188
		scratch_store_dword off, v215, s47 offset:192
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:164
		scratch_store_dword off, v217, s47 offset:168
		scratch_store_dword off, v218, s47 offset:172
		scratch_store_dword off, v219, s47 offset:176
		s_mov_b32 s47, 0
		scratch_store_dword off, v220, s47 offset:148
		scratch_store_dword off, v221, s47 offset:152
		scratch_store_dword off, v222, s47 offset:156
		scratch_store_dword off, v223, s47 offset:160
		s_mov_b32 s47, 0
		scratch_store_dword off, v176, s47 offset:1104
		scratch_store_dword off, v177, s47 offset:1108
		scratch_store_dword off, v178, s47 offset:1112
		scratch_store_dword off, v179, s47 offset:1116
		s_mov_b32 s47, 0
		scratch_store_dword off, v36, s47 offset:1088
		scratch_store_dword off, v37, s47 offset:1092
		scratch_store_dword off, v38, s47 offset:1096
		scratch_store_dword off, v39, s47 offset:1100
		s_mov_b32 s47, 0
		scratch_store_dword off, v48, s47 offset:1072
		scratch_store_dword off, v49, s47 offset:1076
		scratch_store_dword off, v50, s47 offset:1080
		scratch_store_dword off, v51, s47 offset:1084
		s_mov_b32 s47, 0
		scratch_store_dword off, v32, s47 offset:1056
		scratch_store_dword off, v33, s47 offset:1060
		scratch_store_dword off, v34, s47 offset:1064
		scratch_store_dword off, v35, s47 offset:1068
		s_mov_b32 s47, 0
		scratch_store_dword off, v60, s47 offset:1000
		scratch_store_dword off, v61, s47 offset:1004
		scratch_store_dword off, v62, s47 offset:1008
		scratch_store_dword off, v63, s47 offset:1012
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:984
		scratch_store_dword off, v85, s47 offset:988
		scratch_store_dword off, v86, s47 offset:992
		scratch_store_dword off, v87, s47 offset:996
		s_mov_b32 s47, 0
		scratch_store_dword off, v96, s47 offset:968
		scratch_store_dword off, v97, s47 offset:972
		scratch_store_dword off, v98, s47 offset:976
		scratch_store_dword off, v99, s47 offset:980
		s_mov_b32 s47, 0
		scratch_store_dword off, v108, s47 offset:952
		scratch_store_dword off, v109, s47 offset:956
		scratch_store_dword off, v110, s47 offset:960
		scratch_store_dword off, v111, s47 offset:964
		s_mov_b32 s47, 0
		scratch_store_dword off, v120, s47 offset:936
		scratch_store_dword off, v121, s47 offset:940
		scratch_store_dword off, v122, s47 offset:944
		scratch_store_dword off, v123, s47 offset:948
		s_mov_b32 s47, 0
		scratch_store_dword off, v200, s47 offset:920
		scratch_store_dword off, v201, s47 offset:924
		scratch_store_dword off, v202, s47 offset:928
		scratch_store_dword off, v203, s47 offset:932
		s_mov_b32 s47, 0
		scratch_store_dword off, v224, s47 offset:904
		scratch_store_dword off, v225, s47 offset:908
		scratch_store_dword off, v226, s47 offset:912
		scratch_store_dword off, v227, s47 offset:916
		s_mov_b32 s47, 0
		scratch_store_dword off, v12, s47 offset:888
		scratch_store_dword off, v13, s47 offset:892
		scratch_store_dword off, v14, s47 offset:896
		scratch_store_dword off, v15, s47 offset:900
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:1144
		s_mov_b32 s47, 0
		scratch_store_dword off, v3, s47 offset:1140
		s_mov_b32 s47, 0
		scratch_store_dword off, v4, s47 offset:1136
		s_mov_b32 s47, 0
		scratch_store_dword off, v5, s47 offset:1132
		s_mov_b32 s47, 0
		scratch_store_dword off, v6, s47 offset:1128
		s_mov_b32 s47, 0
		scratch_store_dword off, v7, s47 offset:1124
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v4, off, s0 offset:668
		scratch_load_dword v5, off, s0 offset:672
		scratch_load_dword v6, off, s0 offset:676
		scratch_load_dword v7, off, s0 offset:680
		s_mov_b32 s0, 0
		scratch_load_dword v8, off, s0 offset:652
		scratch_load_dword v9, off, s0 offset:656
		scratch_load_dword v10, off, s0 offset:660
		scratch_load_dword v11, off, s0 offset:664
		s_mov_b32 s0, 0
		scratch_load_dword v12, off, s0 offset:636
		scratch_load_dword v13, off, s0 offset:640
		scratch_load_dword v14, off, s0 offset:644
		scratch_load_dword v15, off, s0 offset:648
		s_mov_b32 s0, 0
		scratch_load_dword v16, off, s0 offset:620
		scratch_load_dword v17, off, s0 offset:624
		scratch_load_dword v18, off, s0 offset:628
		scratch_load_dword v19, off, s0 offset:632
		s_mov_b32 s0, 0
		scratch_load_dword v20, off, s0 offset:604
		scratch_load_dword v21, off, s0 offset:608
		scratch_load_dword v22, off, s0 offset:612
		scratch_load_dword v23, off, s0 offset:616
		s_mov_b32 s0, 0
		scratch_load_dword v24, off, s0 offset:588
		scratch_load_dword v25, off, s0 offset:592
		scratch_load_dword v26, off, s0 offset:596
		scratch_load_dword v27, off, s0 offset:600
		s_mov_b32 s0, 0
		scratch_load_dword v28, off, s0 offset:572
		scratch_load_dword v29, off, s0 offset:576
		scratch_load_dword v30, off, s0 offset:580
		scratch_load_dword v31, off, s0 offset:584
		s_mov_b32 s0, 0
		scratch_load_dword v32, off, s0 offset:556
		scratch_load_dword v33, off, s0 offset:560
		scratch_load_dword v34, off, s0 offset:564
		scratch_load_dword v35, off, s0 offset:568
		s_mov_b32 s0, 0
		scratch_load_dword v36, off, s0 offset:540
		scratch_load_dword v37, off, s0 offset:544
		scratch_load_dword v38, off, s0 offset:548
		scratch_load_dword v39, off, s0 offset:552
		s_mov_b32 s0, 0
		scratch_load_dword v40, off, s0 offset:524
		scratch_load_dword v41, off, s0 offset:528
		scratch_load_dword v42, off, s0 offset:532
		scratch_load_dword v43, off, s0 offset:536
		s_mov_b32 s0, 0
		scratch_load_dword v44, off, s0 offset:508
		scratch_load_dword v45, off, s0 offset:512
		scratch_load_dword v46, off, s0 offset:516
		scratch_load_dword v47, off, s0 offset:520
		s_mov_b32 s0, 0
		scratch_load_dword v48, off, s0 offset:492
		scratch_load_dword v49, off, s0 offset:496
		scratch_load_dword v50, off, s0 offset:500
		scratch_load_dword v51, off, s0 offset:504
		s_mov_b32 s0, 0
		scratch_load_dword v52, off, s0 offset:476
		scratch_load_dword v53, off, s0 offset:480
		scratch_load_dword v54, off, s0 offset:484
		scratch_load_dword v55, off, s0 offset:488
		s_mov_b32 s0, 0
		scratch_load_dword v56, off, s0 offset:460
		scratch_load_dword v57, off, s0 offset:464
		scratch_load_dword v58, off, s0 offset:468
		scratch_load_dword v59, off, s0 offset:472
		s_mov_b32 s0, 0
		scratch_load_dword v60, off, s0 offset:444
		scratch_load_dword v61, off, s0 offset:448
		scratch_load_dword v62, off, s0 offset:452
		scratch_load_dword v63, off, s0 offset:456
		s_mov_b32 s0, 0
		scratch_load_dword v64, off, s0 offset:428
		scratch_load_dword v65, off, s0 offset:432
		scratch_load_dword v66, off, s0 offset:436
		scratch_load_dword v67, off, s0 offset:440
		s_mov_b32 s0, 0
		scratch_load_dword v68, off, s0 offset:412
		scratch_load_dword v69, off, s0 offset:416
		scratch_load_dword v70, off, s0 offset:420
		scratch_load_dword v71, off, s0 offset:424
		s_mov_b32 s0, 0
		scratch_load_dword v72, off, s0 offset:396
		scratch_load_dword v73, off, s0 offset:400
		scratch_load_dword v74, off, s0 offset:404
		scratch_load_dword v75, off, s0 offset:408
		s_mov_b32 s0, 0
		scratch_load_dword v76, off, s0 offset:380
		scratch_load_dword v77, off, s0 offset:384
		scratch_load_dword v78, off, s0 offset:388
		scratch_load_dword v79, off, s0 offset:392
		s_mov_b32 s0, 0
		scratch_load_dword v80, off, s0 offset:364
		scratch_load_dword v81, off, s0 offset:368
		scratch_load_dword v82, off, s0 offset:372
		scratch_load_dword v83, off, s0 offset:376
		s_mov_b32 s0, 0
		scratch_load_dword v84, off, s0 offset:348
		scratch_load_dword v85, off, s0 offset:352
		scratch_load_dword v86, off, s0 offset:356
		scratch_load_dword v87, off, s0 offset:360
		s_mov_b32 s0, 0
		scratch_load_dword v88, off, s0 offset:332
		scratch_load_dword v89, off, s0 offset:336
		scratch_load_dword v90, off, s0 offset:340
		scratch_load_dword v91, off, s0 offset:344
		s_mov_b32 s0, 0
		scratch_load_dword v92, off, s0 offset:316
		scratch_load_dword v93, off, s0 offset:320
		scratch_load_dword v94, off, s0 offset:324
		scratch_load_dword v95, off, s0 offset:328
		s_mov_b32 s0, 0
		scratch_load_dword v96, off, s0 offset:276
		scratch_load_dword v97, off, s0 offset:280
		scratch_load_dword v98, off, s0 offset:284
		scratch_load_dword v99, off, s0 offset:288
		s_mov_b32 s0, 0
		scratch_load_dword v100, off, s0 offset:260
		scratch_load_dword v101, off, s0 offset:264
		scratch_load_dword v102, off, s0 offset:268
		scratch_load_dword v103, off, s0 offset:272
		s_mov_b32 s0, 0
		scratch_load_dword v104, off, s0 offset:244
		scratch_load_dword v105, off, s0 offset:248
		scratch_load_dword v106, off, s0 offset:252
		scratch_load_dword v107, off, s0 offset:256
		s_mov_b32 s0, 0
		scratch_load_dword v108, off, s0 offset:228
		scratch_load_dword v109, off, s0 offset:232
		scratch_load_dword v110, off, s0 offset:236
		scratch_load_dword v111, off, s0 offset:240
		s_mov_b32 s0, 0
		scratch_load_dword v112, off, s0 offset:212
		scratch_load_dword v113, off, s0 offset:216
		scratch_load_dword v114, off, s0 offset:220
		scratch_load_dword v115, off, s0 offset:224
		s_mov_b32 s0, 0
		scratch_load_dword v116, off, s0 offset:196
		scratch_load_dword v117, off, s0 offset:200
		scratch_load_dword v118, off, s0 offset:204
		scratch_load_dword v119, off, s0 offset:208
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(62)
		scratch_load_dword v120, off, s0 offset:180
		scratch_load_dword v121, off, s0 offset:184
		scratch_load_dword v122, off, s0 offset:188
		scratch_load_dword v123, off, s0 offset:192
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(58)
		scratch_load_dword v124, off, s0 offset:164
		scratch_load_dword v125, off, s0 offset:168
		scratch_load_dword v126, off, s0 offset:172
		scratch_load_dword v127, off, s0 offset:176
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(54)
		scratch_load_dword v128, off, s0 offset:148
		scratch_load_dword v129, off, s0 offset:152
		scratch_load_dword v130, off, s0 offset:156
		scratch_load_dword v131, off, s0 offset:160
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v132, off, s0 offset:1104
		scratch_load_dword v133, off, s0 offset:1108
		scratch_load_dword v134, off, s0 offset:1112
		scratch_load_dword v135, off, s0 offset:1116
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v136, off, s0 offset:1088
		scratch_load_dword v137, off, s0 offset:1092
		scratch_load_dword v138, off, s0 offset:1096
		scratch_load_dword v139, off, s0 offset:1100
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v140, off, s0 offset:1072
		scratch_load_dword v141, off, s0 offset:1076
		scratch_load_dword v142, off, s0 offset:1080
		scratch_load_dword v143, off, s0 offset:1084
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v144, off, s0 offset:1056
		scratch_load_dword v145, off, s0 offset:1060
		scratch_load_dword v146, off, s0 offset:1064
		scratch_load_dword v147, off, s0 offset:1068
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v148, off, s0 offset:1000
		scratch_load_dword v149, off, s0 offset:1004
		scratch_load_dword v150, off, s0 offset:1008
		scratch_load_dword v151, off, s0 offset:1012
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v152, off, s0 offset:984
		scratch_load_dword v153, off, s0 offset:988
		scratch_load_dword v154, off, s0 offset:992
		scratch_load_dword v155, off, s0 offset:996
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v156, off, s0 offset:968
		scratch_load_dword v157, off, s0 offset:972
		scratch_load_dword v158, off, s0 offset:976
		scratch_load_dword v159, off, s0 offset:980
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v160, off, s0 offset:952
		scratch_load_dword v161, off, s0 offset:956
		scratch_load_dword v162, off, s0 offset:960
		scratch_load_dword v163, off, s0 offset:964
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(18)
		scratch_load_dword v164, off, s0 offset:936
		scratch_load_dword v165, off, s0 offset:940
		scratch_load_dword v166, off, s0 offset:944
		scratch_load_dword v167, off, s0 offset:948
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v168, off, s0 offset:920
		scratch_load_dword v169, off, s0 offset:924
		scratch_load_dword v170, off, s0 offset:928
		scratch_load_dword v171, off, s0 offset:932
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v172, off, s0 offset:904
		scratch_load_dword v173, off, s0 offset:908
		scratch_load_dword v174, off, s0 offset:912
		scratch_load_dword v175, off, s0 offset:916
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v176, off, s0 offset:888
		scratch_load_dword v177, off, s0 offset:892
		scratch_load_dword v178, off, s0 offset:896
		scratch_load_dword v179, off, s0 offset:900
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v1, off, s0 offset:1144
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v2, off, s0 offset:1140
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v3, off, s0 offset:1136
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v180, off, s0 offset:1132
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v181, off, s0 offset:1128
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v182, off, s0 offset:1124
		s_add_i32 s0, s12, -1
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[132:135], v[148:151], v[4:7], v1, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		s_mov_b32 s1, 0
		scratch_load_dword v183, off, s1 offset:136
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v184, s0, v183
		s_mov_b32 s1, 0
		scratch_load_dword v183, off, s1 offset:716
		s_mov_b32 s1, 0
		scratch_load_dword v185, off, s1 offset:720
		s_waitcnt vmcnt(0)
		v_add3_u32 v186, v184, v185, v183
		ds_read_b128 v[188:191], v186 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[132:135], v[152:155], v[8:11], v1, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v186 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[132:135], v[156:159], v[12:15], v1, v180 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v186 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[132:135], v[160:163], v[16:19], v1, v180 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v186 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[132:135], v[164:167], v[20:23], v1, v181 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s1, 0
		scratch_load_dword v183, off, s1 offset:720
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v184, s0, v183
		v_lshlrev_b32_e32 v183, 2, v0
		v_add_u32_e32 v185, 0x27800, v183
		ds_read_b32 v183, v185
		s_mov_b32 s0, 0
		scratch_load_dword v185, off, s0 offset:716
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v186, v184, v183, v185
		ds_read_b128 v[204:207], v186 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[132:135], v[168:171], v[24:27], v1, v181 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v186 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[132:135], v[172:175], v[28:31], v1, v182 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v186 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[132:135], v[176:179], v[32:35], v1, v182 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v186 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[136:139], v[148:151], v[36:39], v1, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v186 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[136:139], v[152:155], v[40:43], v1, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v186 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[136:139], v[156:159], v[44:47], v1, v180 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v186 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[136:139], v[160:163], v[48:51], v1, v180 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v186 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[136:139], v[164:167], v[52:55], v1, v181 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[136:139], v[168:171], v[56:59], v1, v181 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[136:139], v[172:175], v[60:63], v1, v182 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[136:139], v[176:179], v[64:67], v1, v182 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[140:143], v[148:151], v[68:71], v2, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[140:143], v[152:155], v[72:75], v2, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[140:143], v[156:159], v[76:79], v2, v180 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[140:143], v[160:163], v[80:83], v2, v180 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[140:143], v[164:167], v[84:87], v2, v181 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[140:143], v[168:171], v[88:91], v2, v181 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[140:143], v[172:175], v[92:95], v2, v182 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[140:143], v[176:179], v[96:99], v2, v182 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[144:147], v[148:151], v[100:103], v2, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[144:147], v[152:155], v[104:107], v2, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[144:147], v[156:159], v[108:111], v2, v180 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[144:147], v[160:163], v[112:115], v2, v180 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[144:147], v[164:167], v[116:119], v2, v181 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[144:147], v[168:171], v[120:123], v2, v181 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[144:147], v[172:175], v[124:127], v2, v182 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[144:147], v[176:179], v[128:131], v2, v182 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[188:191], v[204:207], v[4:7], v1, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[188:191], v[208:211], v[8:11], v1, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[188:191], v[212:215], v[12:15], v1, v180 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[188:191], v[132:135], v[16:19], v1, v180 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[188:191], v[216:219], v[20:23], v1, v181 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[188:191], v[220:223], v[24:27], v1, v181 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[188:191], v[224:227], v[28:31], v1, v182 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[188:191], v[228:231], v[32:35], v1, v182 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[192:195], v[204:207], v[36:39], v1, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[192:195], v[208:211], v[40:43], v1, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[192:195], v[212:215], v[44:47], v1, v180 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[192:195], v[132:135], v[48:51], v1, v180 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[192:195], v[216:219], v[52:55], v1, v181 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[192:195], v[220:223], v[56:59], v1, v181 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[192:195], v[224:227], v[60:63], v1, v182 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[192:195], v[228:231], v[64:67], v1, v182 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[196:199], v[204:207], v[68:71], v2, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[196:199], v[208:211], v[72:75], v2, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[196:199], v[212:215], v[76:79], v2, v180 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[196:199], v[132:135], v[80:83], v2, v180 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[196:199], v[216:219], v[84:87], v2, v181 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[196:199], v[220:223], v[88:91], v2, v181 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[196:199], v[224:227], v[92:95], v2, v182 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[196:199], v[228:231], v[96:99], v2, v182 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[200:203], v[204:207], v[100:103], v2, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[200:203], v[208:211], v[104:107], v2, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[200:203], v[212:215], v[108:111], v2, v180 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[200:203], v[132:135], v[112:115], v2, v180 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[200:203], v[216:219], v[116:119], v2, v181 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[200:203], v[220:223], v[120:123], v2, v181 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[200:203], v[224:227], v[124:127], v2, v182 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[200:203], v[228:231], v[128:131], v2, v182 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:136
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s1, v1
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:716
		s_mov_b32 s2, 0
		scratch_load_dword v3, off, s2 offset:720
		s_waitcnt vmcnt(0)
		v_add3_u32 v132, v2, v3, v1
		ds_read_b128 v[136:139], v132
		ds_read_b128 v[140:143], v132 offset:1024
		ds_read_b128 v[144:147], v132 offset:2048
		ds_read_b128 v[148:151], v132 offset:3072
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:720
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s1, v1
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x27800, v1
		ds_read_b32 v1, v3
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:716
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v133, v2, v1, v3
		ds_read_b128 v[152:155], v133 offset:32768
		ds_read_b128 v[156:159], v133 offset:33792
		ds_read_b128 v[160:163], v133 offset:34816
		ds_read_b128 v[164:167], v133 offset:35840
		ds_read_b128 v[168:171], v133 offset:36864
		ds_read_b128 v[172:175], v133 offset:37888
		ds_read_b128 v[176:179], v133 offset:38912
		ds_read_b128 v[180:183], v133 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:144
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, s0, v1, v2
		ds_read_b32 v1, v3
		ds_read_b32 v2, v3 offset:256
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:140
		s_mov_b32 s1, 0
		scratch_load_dword v134, off, s1 offset:724
		s_waitcnt vmcnt(0)
		v_add3_u32 v135, s0, v134, v3
		ds_read_b32 v3, v135 offset:2048
		ds_read_b32 v134, v135 offset:2304
		ds_read_b32 v184, v135 offset:2560
		ds_read_b32 v185, v135 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[136:139], v[152:155], v[4:7], v1, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v132 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[136:139], v[156:159], v[8:11], v1, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v132 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[136:139], v[160:163], v[12:15], v1, v134 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v132 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[136:139], v[164:167], v[16:19], v1, v134 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v132 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[136:139], v[168:171], v[20:23], v1, v184 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v133 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[136:139], v[172:175], v[24:27], v1, v184 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v133 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[136:139], v[176:179], v[28:31], v1, v185 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v133 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[136:139], v[180:183], v[32:35], v1, v185 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v133 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[140:143], v[152:155], v[36:39], v1, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v133 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[140:143], v[156:159], v[40:43], v1, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v133 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[140:143], v[160:163], v[44:47], v1, v134 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v133 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[140:143], v[164:167], v[48:51], v1, v134 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v133 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[140:143], v[168:171], v[52:55], v1, v184 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[140:143], v[172:175], v[56:59], v1, v184 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[140:143], v[176:179], v[60:63], v1, v185 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[140:143], v[180:183], v[64:67], v1, v185 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[144:147], v[152:155], v[68:71], v2, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[144:147], v[156:159], v[72:75], v2, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[144:147], v[160:163], v[76:79], v2, v134 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[144:147], v[164:167], v[80:83], v2, v134 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[144:147], v[168:171], v[84:87], v2, v184 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[144:147], v[172:175], v[88:91], v2, v184 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[144:147], v[176:179], v[92:95], v2, v185 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[144:147], v[180:183], v[96:99], v2, v185 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[148:151], v[152:155], v[100:103], v2, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[148:151], v[156:159], v[104:107], v2, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[148:151], v[160:163], v[108:111], v2, v134 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[148:151], v[164:167], v[112:115], v2, v134 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[148:151], v[168:171], v[116:119], v2, v184 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[148:151], v[172:175], v[120:123], v2, v184 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[148:151], v[176:179], v[124:127], v2, v185 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[148:151], v[180:183], v[128:131], v2, v185 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[188:191], v[204:207], v[4:7], v1, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[188:191], v[208:211], v[8:11], v1, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[188:191], v[212:215], v[12:15], v1, v134 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[188:191], v[136:139], v[16:19], v1, v134 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[188:191], v[216:219], v[20:23], v1, v184 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[188:191], v[220:223], v[24:27], v1, v184 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[188:191], v[224:227], v[28:31], v1, v185 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[188:191], v[228:231], v[32:35], v1, v185 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[192:195], v[204:207], v[36:39], v1, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[192:195], v[208:211], v[40:43], v1, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[192:195], v[212:215], v[44:47], v1, v134 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[192:195], v[136:139], v[48:51], v1, v134 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[192:195], v[216:219], v[52:55], v1, v184 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[192:195], v[220:223], v[56:59], v1, v184 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[192:195], v[224:227], v[60:63], v1, v185 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[192:195], v[228:231], v[64:67], v1, v185 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[196:199], v[204:207], v[68:71], v2, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[196:199], v[208:211], v[72:75], v2, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[196:199], v[212:215], v[76:79], v2, v134 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[196:199], v[136:139], v[80:83], v2, v134 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[196:199], v[216:219], v[84:87], v2, v184 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[196:199], v[220:223], v[88:91], v2, v184 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[196:199], v[224:227], v[92:95], v2, v185 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[196:199], v[228:231], v[96:99], v2, v185 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[200:203], v[204:207], v[100:103], v2, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[200:203], v[208:211], v[104:107], v2, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[200:203], v[212:215], v[108:111], v2, v134 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[200:203], v[136:139], v[112:115], v2, v134 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[200:203], v[216:219], v[116:119], v2, v184 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[200:203], v[220:223], v[120:123], v2, v184 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[200:203], v[224:227], v[124:127], v2, v185 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[200:203], v[228:231], v[128:131], v2, v185 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v0, 0x22000, v1
		ds_read_b32 v1, v0
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v0, 3, v1
		v_accvgpr_read_b32 v1, a0
		v_lshl_add_u32 v4, v1, 14, v0
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v0, v8, v9
		v_cvt_pk_f16_f32 v1, v10, v11
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v12, v13
		v_cvt_pk_f16_f32 v1, v14, v15
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v16, v17
		v_cvt_pk_f16_f32 v1, v18, v19
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v20, v21
		v_cvt_pk_f16_f32 v1, v22, v23
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v24, v25
		v_cvt_pk_f16_f32 v1, v26, v27
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v28, v29
		v_cvt_pk_f16_f32 v1, v30, v31
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v32, v33
		v_cvt_pk_f16_f32 v1, v34, v35
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v36, v37
		v_cvt_pk_f16_f32 v1, v38, v39
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v40, v41
		v_cvt_pk_f16_f32 v1, v42, v43
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v44, v45
		v_cvt_pk_f16_f32 v1, v46, v47
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v48, v49
		v_cvt_pk_f16_f32 v1, v50, v51
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v52, v53
		v_cvt_pk_f16_f32 v1, v54, v55
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v56, v57
		v_cvt_pk_f16_f32 v1, v58, v59
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v60, v61
		v_cvt_pk_f16_f32 v1, v62, v63
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v64, v65
		v_cvt_pk_f16_f32 v1, v66, v67
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v68, v69
		v_cvt_pk_f16_f32 v1, v70, v71
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v72, v73
		v_cvt_pk_f16_f32 v1, v74, v75
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v92, v93
		v_cvt_pk_f16_f32 v1, v94, v95
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v0, v104, v105
		v_cvt_pk_f16_f32 v1, v106, v107
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 1672
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
		.amdhsa_next_free_vgpr 233
		.amdhsa_next_free_sgpr 54
		.amdhsa_accum_offset 232
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 232
	.set .Lwmma_f16_matmul_tiled.num_agpr, 1
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 54
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 1672
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
    .private_segment_fixed_size: 1672
    .sgpr_count:     54
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     233
    .agpr_count:     1
    .vgpr_spill_count: 600
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
