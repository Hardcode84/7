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
		s_load_dword s8, s[0:1], 0x18
		s_waitcnt lgkmcnt(0)
		s_branch .Lwmma_f16_matmul_tiled.kernarg_preload_entry
	.p2align	8
.Lwmma_f16_matmul_tiled.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_mov_b32 s12, s2
		s_mov_b32 s13, s3
		s_mov_b32 s14, 0x4000000
		s_mov_b32 s15, 0x31016000
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, 0x4000000
		s_mov_b32 s3, 0x31016000
		v_readfirstlane_b32 s4, v0
		s_lshr_b32 s5, s9, 3
		v_lshrrev_b32_e32 v1, 6, v0
		s_lshl_b32 s8, s10, 1
		v_and_b32_e32 v2, 63, v0
		s_add_i32 s5, s8, s5
		v_lshrrev_b32_e32 v3, 2, v2
		s_and_b32 s8, s9, 7
		v_lshlrev_b32_e32 v3, 14, v3
		s_lshl_b32 s8, s8, 5
		v_lshl_add_u32 v3, v1, 18, v3
		s_add_i32 s5, s5, s8
		v_lshrrev_b32_e32 v4, 3, v2
		s_lshr_b32 s8, s5, 6
		v_and_b32_e32 v4, 3, v4
		s_lshl_b32 s9, s8, 23
		v_and_b32_e32 v5, 3, v2
		s_and_b32 s5, s5, 63
		v_xor_b32_e32 v4, v4, v5
		s_lshr_b32 s10, s5, 2
		v_lshl_add_u32 v3, v4, 4, v3
		s_lshl_b32 s11, s10, 17
		s_add_i32 s9, s9, s11
		s_and_b32 s5, s5, 3
		s_lshl_b32 s11, s5, 21
		s_add_i32 s9, s9, s11
		s_add_u32 s6, s6, s9
		s_addc_u32 s7, s7, 0
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s18, 0x20000
		s_mov_b32 s19, 0x31016000
		s_lshr_b32 s4, s4, 6
		s_lshl_b32 s4, s4, 10
		s_mov_b32 m0, s4
		s_lshl_b32 s6, s8, 24
		s_lshl_b32 s5, s5, 22
		s_add_i32 s7, s6, s5
		v_add_u32_e32 v4, s7, v3
		buffer_load_dwordx4 v4, s[12:15], 0 offen lds
		s_add_i32 m0, s4, 0x4000
		s_lshl_b32 s7, s10, 22
		v_add_u32_e32 v5, s7, v3
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_add_i32 m0, s4, 0x8000
		s_add_i32 s6, s6, 64
		s_add_i32 s5, s6, s5
		v_add_u32_e32 v6, s5, v3
		buffer_load_dwordx4 v6, s[12:15], 0 offen lds
		v_add3_u32 v3, s7, 64, v3
		s_add_i32 m0, s4, 0xc000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_waitcnt vmcnt(2)
		s_barrier
		v_and_b32_e32 v3, 15, v0
		v_lshrrev_b32_e32 v6, 1, v3
		v_lshrrev_b32_e32 v7, 4, v2
		v_and_b32_e32 v6, 3, v6
		v_lshrrev_b32_e32 v0, 8, v0
		v_xor_b32_e32 v6, v7, v6
		v_and_b32_e32 v7, 3, v1
		v_lshlrev_b32_e32 v0, 12, v0
		v_lshlrev_b32_e32 v3, 6, v3
		v_lshlrev_b32_e32 v6, 4, v6
		v_lshlrev_b32_e32 v7, 12, v7
		v_add3_u32 v12, v0, v3, v6
		v_add3_u32 v13, v3, v7, v6
		ds_read_b128 v[16:19], v12
		ds_read_b128 v[20:23], v12 offset:1024
		ds_read_b128 v[24:27], v12 offset:2048
		ds_read_b128 v[28:31], v12 offset:3072
		ds_read_b128 v[32:35], v13 offset:16384
		ds_read_b128 v[36:39], v13 offset:17408
		ds_read_b128 v[40:43], v13 offset:18432
		ds_read_b128 v[44:47], v13 offset:19456
		v_add_u32_e32 v12, 0x80, v4
		v_add_u32_e32 v4, 0x80, v5
		s_add_i32 s5, s4, 0x10000
		s_add_i32 s6, s4, 0x14000
		s_mov_b32 s4, 0
		s_cmp_lt_i32 0, 0xfe
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
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_mov_b32 m0, s5
		s_lshl_b32 s7, s4, 6
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v12, s[12:15], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[8:11], v[16:19], v[32:35], v[8:11]
		v_mfma_f32_16x16x32_f16 v[48:51], v[16:19], v[36:39], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], v[40:43], v[52:55]
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], v[44:47], v[56:59]
		v_mfma_f32_16x16x32_f16 v[60:63], v[20:23], v[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[20:23], v[36:39], v[64:67]
		s_mov_b32 m0, s6
		v_mfma_f32_16x16x32_f16 v[68:71], v[20:23], v[40:43], v[68:71]
		buffer_load_dwordx4 v4, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[72:75], v[20:23], v[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[24:27], v[32:35], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[24:27], v[36:39], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[24:27], v[40:43], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[24:27], v[44:47], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[28:31], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[28:31], v[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[44:47], v[104:107]
		s_waitcnt vmcnt(2)
		s_barrier
		s_add_i32 s4, s4, 1
		s_and_b32 s7, s4, 3
		s_lshl_b32 s7, s7, 15
		v_add_u32_e32 v5, s7, v0
		v_add3_u32 v5, v5, v3, v6
		ds_read_b128 v[16:19], v5
		ds_read_b128 v[20:23], v5 offset:1024
		ds_read_b128 v[24:27], v5 offset:2048
		ds_read_b128 v[28:31], v5 offset:3072
		v_add_u32_e32 v5, s7, v3
		v_add3_u32 v5, v5, v7, v6
		ds_read_b128 v[32:35], v5 offset:16384
		ds_read_b128 v[36:39], v5 offset:17408
		ds_read_b128 v[40:43], v5 offset:18432
		ds_read_b128 v[44:47], v5 offset:19456
		s_add_i32 s5, s5, 0x8000
		s_and_b32 s5, s5, 0x1ffff
		s_add_i32 s6, s6, 0x8000
		s_and_b32 s6, s6, 0x1ffff
		s_cmp_lt_i32 s4, 0xfe
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[8:11], v[16:19], v[32:35], v[8:11]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[48:51], v[16:19], v[36:39], v[48:51]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], v[40:43], v[52:55]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], v[44:47], v[56:59]
		v_mfma_f32_16x16x32_f16 v[60:63], v[20:23], v[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[20:23], v[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[20:23], v[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[20:23], v[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[24:27], v[32:35], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[24:27], v[36:39], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[24:27], v[40:43], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[24:27], v[44:47], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[28:31], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[28:31], v[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[44:47], v[104:107]
		v_add_u32_e32 v0, 0x10000, v0
		v_add3_u32 v0, v0, v3, v6
		ds_read_b128 v[12:15], v0 offset:32768
		ds_read_b128 v[16:19], v0 offset:33792
		ds_read_b128 v[20:23], v0 offset:34816
		ds_read_b128 v[24:27], v0 offset:35840
		v_add_u32_e32 v0, 0x10000, v3
		v_add3_u32 v0, v0, v7, v6
		ds_read_b128 v[4:7], v0 offset:49152
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[8:11], v[12:15], v[4:7], v[8:11]
		ds_read_b128 v[28:31], v0 offset:50176
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[48:51], v[12:15], v[28:31], v[48:51]
		ds_read_b128 v[32:35], v0 offset:51200
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[52:55], v[12:15], v[32:35], v[52:55]
		ds_read_b128 v[36:39], v0 offset:52224
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], v[36:39], v[56:59]
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], v[4:7], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[16:19], v[28:31], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[16:19], v[32:35], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[16:19], v[36:39], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[20:23], v[4:7], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[20:23], v[28:31], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[20:23], v[32:35], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[20:23], v[36:39], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[24:27], v[4:7], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[24:27], v[28:31], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[24:27], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[24:27], v[36:39], v[104:107]
		v_cvt_pk_f16_f32 v4, v8, v9
		v_cvt_pk_f16_f32 v5, v10, v11
		v_lshlrev_b32_e32 v0, 3, v2
		v_lshl_add_u32 v0, v1, 13, v0
		buffer_store_dwordx2 v[4:5], v0, s[16:19], 0 offen
		v_cvt_pk_f16_f32 v2, v48, v49
		v_cvt_pk_f16_f32 v3, v50, v51
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		s_mov_b32 s0, 0x1000
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
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
		.amdhsa_next_free_vgpr 108
		.amdhsa_next_free_sgpr 20
		.amdhsa_accum_offset 108
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 108
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 20
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
      - .name:           arg3
        .offset:         24
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 32
    .max_flat_workgroup_size: 1024
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     20
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     108
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
