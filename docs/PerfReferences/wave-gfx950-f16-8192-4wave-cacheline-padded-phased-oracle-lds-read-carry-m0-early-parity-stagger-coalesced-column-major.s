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
		s_mov_b32 s14, 0x8000000
		s_mov_b32 s15, 0x31016000
		s_mov_b32 s12, s2
		s_mov_b32 s13, s3
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s14
		s_mov_b32 s3, s15
	; Dense C: XCD-remapped M in bytes, N in 8192-element columns.
		s_lshl_b32 s4, s10, 22
		s_lshr_b32 s5, s9, 3
		s_lshl_b32 s5, s5, 22
		s_and_b32 s8, s9, 7
		s_lshl_b32 s8, s8, 24
		s_lshr_b32 s16, s5, 13
		s_add_i32 s4, s4, s16
		s_lshr_b32 s16, s8, 13
		s_add_i32 s4, s4, s16
		v_readfirstlane_b32 s9, v0
		s_lshr_b32 s9, s9, 6
		s_lshl_b32 s11, s9, 10
		s_lshl_b32 s19, s9, 4
		s_add_i32 s11, s11, s19
		s_mov_b32 s23, s11
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 3, v1
		v_lshlrev_b32_e32 v2, 14, v2
		v_lshl_add_u32 v2, s9, 17, v2
		v_and_b32_e32 v3, 7, v1
		v_lshl_add_u32 v2, v3, 4, v2
		s_add_i32 s16, s5, s8
		v_add_u32_e32 v3, s16, v2
		s_lshl_b32 s10, s10, 22
		v_add_u32_e32 v9, s10, v2
		s_mov_b32 s24, 0x80000
		s_mov_b32 s25, 0x100000
		s_mov_b32 s26, 0x180000
		s_mov_b32 s27, 0x200000
		s_mov_b32 s28, 0x280000
		s_mov_b32 s29, 0x300000
		s_mov_b32 s30, 0x380000
	; Part 13: eight lanes fetch one complete K64 cache line.
		s_mov_b32 m0, s11
		buffer_load_dwordx4 v3, s[12:15], 0 offen lds
		s_add_i32 m0, s11, 0x1040
		buffer_load_dwordx4 v3, s[12:15], s24 offen lds
		s_add_i32 m0, s11, 0x2080
		buffer_load_dwordx4 v3, s[12:15], s25 offen lds
		s_add_i32 m0, s11, 0x30c0
		buffer_load_dwordx4 v3, s[12:15], s26 offen lds
		s_add_i32 m0, s11, 0x4100
		buffer_load_dwordx4 v3, s[12:15], s27 offen lds
		s_add_i32 m0, s11, 0x5140
		buffer_load_dwordx4 v3, s[12:15], s28 offen lds
		s_add_i32 m0, s11, 0x6180
		buffer_load_dwordx4 v3, s[12:15], s29 offen lds
		s_add_i32 m0, s11, 0x71c0
		buffer_load_dwordx4 v3, s[12:15], s30 offen lds
		s_add_i32 m0, s11, 0x8200
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_add_i32 m0, s11, 0x9240
		buffer_load_dwordx4 v9, s[0:3], s24 offen lds
		s_add_i32 m0, s11, 0xa280
		buffer_load_dwordx4 v9, s[0:3], s25 offen lds
		s_add_i32 m0, s11, 0xb2c0
		buffer_load_dwordx4 v9, s[0:3], s26 offen lds
		s_add_i32 m0, s11, 0xc300
		buffer_load_dwordx4 v9, s[0:3], s27 offen lds
		s_add_i32 m0, s11, 0xd340
		buffer_load_dwordx4 v9, s[0:3], s28 offen lds
		s_add_i32 m0, s11, 0xe380
		buffer_load_dwordx4 v9, s[0:3], s29 offen lds
		s_add_i32 m0, s11, 0xf3c0
		buffer_load_dwordx4 v9, s[0:3], s30 offen lds
		s_add_i32 m0, s11, 0x10380
		buffer_load_dwordx4 v3, s[12:15], 0 offen offset:128 lds
		s_add_i32 m0, s11, 0x113c0
		buffer_load_dwordx4 v3, s[12:15], s24 offen offset:128 lds
		s_add_i32 m0, s11, 0x12400
		buffer_load_dwordx4 v3, s[12:15], s25 offen offset:128 lds
		s_add_i32 m0, s11, 0x13440
		buffer_load_dwordx4 v3, s[12:15], s26 offen offset:128 lds
		s_add_i32 m0, s11, 0x14480
		buffer_load_dwordx4 v3, s[12:15], s27 offen offset:128 lds
		s_add_i32 m0, s11, 0x154c0
		buffer_load_dwordx4 v3, s[12:15], s28 offen offset:128 lds
		s_add_i32 m0, s11, 0x16500
		buffer_load_dwordx4 v3, s[12:15], s29 offen offset:128 lds
		s_add_i32 m0, s11, 0x17540
		buffer_load_dwordx4 v3, s[12:15], s30 offen offset:128 lds
		s_add_i32 m0, s11, 0x18580
		buffer_load_dwordx4 v9, s[0:3], 0 offen offset:128 lds
		s_add_i32 m0, s11, 0x195c0
		buffer_load_dwordx4 v9, s[0:3], s24 offen offset:128 lds
		s_add_i32 m0, s11, 0x1a600
		buffer_load_dwordx4 v9, s[0:3], s25 offen offset:128 lds
		s_add_i32 m0, s11, 0x1b640
		buffer_load_dwordx4 v9, s[0:3], s26 offen offset:128 lds
		s_add_i32 m0, s11, 0x1c680
		buffer_load_dwordx4 v9, s[0:3], s27 offen offset:128 lds
		s_add_i32 m0, s11, 0x1d6c0
		buffer_load_dwordx4 v9, s[0:3], s28 offen offset:128 lds
		s_add_i32 m0, s11, 0x1e700
		buffer_load_dwordx4 v9, s[0:3], s29 offen offset:128 lds
		s_add_i32 m0, s11, 0x1f740
		buffer_load_dwordx4 v9, s[0:3], s30 offen offset:128 lds
		v_lshlrev_b32_e32 v12, 3, v1
		v_add_u32_e32 v4, 0x80, v3
		v_add_u32_e32 v21, 0x80, v9
	; hipBLASLt line map: 1024-byte payload plus 16-byte pad.
		v_and_b32_e32 v10, 15, v1
		v_lshlrev_b32_e32 v14, 10, v10
		v_lshlrev_b32_e32 v0, 4, v10
		v_add_u32_e32 v10, v14, v0
		v_lshrrev_b32_e32 v14, 4, v1
		v_lshlrev_b32_e32 v14, 4, v14
		v_add_u32_e32 v10, v10, v14
		s_and_b32 s10, s9, 1
		s_lshl_b32 s19, s10, 14
		s_lshl_b32 s10, s10, 8
		s_add_i32 s10, s10, s19
		v_add_u32_e32 v9, s10, v10
		s_lshr_b32 s10, s9, 1
		s_lshl_b32 s19, s10, 14
		s_lshl_b32 s10, s10, 8
		s_add_i32 s10, s10, s19
		v_add_u32_e32 v2, 0x8200, v10
		v_add_u32_e32 v2, s10, v2
		s_mov_b32 s18, 0
	; Current LDS buffer addresses cross the loop backedge.
		v_mov_b32_e32 v3, v9
		v_mov_b32_e32 v6, v2
		s_add_u32 s20, s6, s4
		s_addc_u32 s21, s7, 0
		s_mov_b32 s22, 0xffffffff
		s_mov_b32 s16, 0x6000
		s_mov_b32 s17, 0x4000
		s_mov_b32 s4, 0x7000
		s_mov_b32 s5, 0x5000
		s_mov_b32 s6, 0x3000
		s_mov_b32 s7, 0x2000
		s_mov_b32 s8, 0x1000
	; Both prefetched full-line buffers must be complete.
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[28:31], v9
		ds_read_b128 v[64:67], v9 offset:128
		ds_read_b128 v[68:71], v9 offset:256
		ds_read_b128 v[72:75], v9 offset:384
		ds_read_b128 v[76:79], v9 offset:512
		ds_read_b128 v[80:83], v9 offset:640
		ds_read_b128 v[84:87], v9 offset:768
		ds_read_b128 v[88:91], v9 offset:896
		ds_read_b128 v[32:35], v2
		ds_read_b128 v[36:39], v2 offset:128
		ds_read_b128 v[40:43], v2 offset:256
		ds_read_b128 v[44:47], v2 offset:384
		ds_read_b128 v[48:51], v2 offset:512
		ds_read_b128 v[52:55], v2 offset:640
		ds_read_b128 v[56:59], v2 offset:768
		ds_read_b128 v[60:63], v2 offset:896
	.p2align	2
	; Part 7: isolate operand buffers from full-AGPR accumulators.
		v_accvgpr_write_b32 a0, 0
		v_accvgpr_write_b32 a1, 0
		v_accvgpr_write_b32 a2, 0
		v_accvgpr_write_b32 a3, 0
		v_accvgpr_write_b32 a4, 0
		v_accvgpr_write_b32 a5, 0
		v_accvgpr_write_b32 a6, 0
		v_accvgpr_write_b32 a7, 0
		v_accvgpr_write_b32 a8, 0
		v_accvgpr_write_b32 a9, 0
		v_accvgpr_write_b32 a10, 0
		v_accvgpr_write_b32 a11, 0
		v_accvgpr_write_b32 a12, 0
		v_accvgpr_write_b32 a13, 0
		v_accvgpr_write_b32 a14, 0
		v_accvgpr_write_b32 a15, 0
		v_accvgpr_write_b32 a16, 0
		v_accvgpr_write_b32 a17, 0
		v_accvgpr_write_b32 a18, 0
		v_accvgpr_write_b32 a19, 0
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		v_accvgpr_write_b32 a32, 0
		v_accvgpr_write_b32 a33, 0
		v_accvgpr_write_b32 a34, 0
		v_accvgpr_write_b32 a35, 0
		v_accvgpr_write_b32 a36, 0
		v_accvgpr_write_b32 a37, 0
		v_accvgpr_write_b32 a38, 0
		v_accvgpr_write_b32 a39, 0
		v_accvgpr_write_b32 a40, 0
		v_accvgpr_write_b32 a41, 0
		v_accvgpr_write_b32 a42, 0
		v_accvgpr_write_b32 a43, 0
		v_accvgpr_write_b32 a44, 0
		v_accvgpr_write_b32 a45, 0
		v_accvgpr_write_b32 a46, 0
		v_accvgpr_write_b32 a47, 0
		v_accvgpr_write_b32 a48, 0
		v_accvgpr_write_b32 a49, 0
		v_accvgpr_write_b32 a50, 0
		v_accvgpr_write_b32 a51, 0
		v_accvgpr_write_b32 a52, 0
		v_accvgpr_write_b32 a53, 0
		v_accvgpr_write_b32 a54, 0
		v_accvgpr_write_b32 a55, 0
		v_accvgpr_write_b32 a56, 0
		v_accvgpr_write_b32 a57, 0
		v_accvgpr_write_b32 a58, 0
		v_accvgpr_write_b32 a59, 0
		v_accvgpr_write_b32 a60, 0
		v_accvgpr_write_b32 a61, 0
		v_accvgpr_write_b32 a62, 0
		v_accvgpr_write_b32 a63, 0
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
		v_accvgpr_write_b32 a208, 0
		v_accvgpr_write_b32 a209, 0
		v_accvgpr_write_b32 a210, 0
		v_accvgpr_write_b32 a211, 0
		v_accvgpr_write_b32 a212, 0
		v_accvgpr_write_b32 a213, 0
		v_accvgpr_write_b32 a214, 0
		v_accvgpr_write_b32 a215, 0
		v_accvgpr_write_b32 a216, 0
		v_accvgpr_write_b32 a217, 0
		v_accvgpr_write_b32 a218, 0
		v_accvgpr_write_b32 a219, 0
		v_accvgpr_write_b32 a220, 0
		v_accvgpr_write_b32 a221, 0
		v_accvgpr_write_b32 a222, 0
		v_accvgpr_write_b32 a223, 0
		v_accvgpr_write_b32 a224, 0
		v_accvgpr_write_b32 a225, 0
		v_accvgpr_write_b32 a226, 0
		v_accvgpr_write_b32 a227, 0
		v_accvgpr_write_b32 a228, 0
		v_accvgpr_write_b32 a229, 0
		v_accvgpr_write_b32 a230, 0
		v_accvgpr_write_b32 a231, 0
		v_accvgpr_write_b32 a232, 0
		v_accvgpr_write_b32 a233, 0
		v_accvgpr_write_b32 a234, 0
		v_accvgpr_write_b32 a235, 0
		v_accvgpr_write_b32 a236, 0
		v_accvgpr_write_b32 a237, 0
		v_accvgpr_write_b32 a238, 0
		v_accvgpr_write_b32 a239, 0
		v_accvgpr_write_b32 a240, 0
		v_accvgpr_write_b32 a241, 0
		v_accvgpr_write_b32 a242, 0
		v_accvgpr_write_b32 a243, 0
		v_accvgpr_write_b32 a244, 0
		v_accvgpr_write_b32 a245, 0
		v_accvgpr_write_b32 a246, 0
		v_accvgpr_write_b32 a247, 0
		v_accvgpr_write_b32 a248, 0
		v_accvgpr_write_b32 a249, 0
		v_accvgpr_write_b32 a250, 0
		v_accvgpr_write_b32 a251, 0
		v_accvgpr_write_b32 a252, 0
		v_accvgpr_write_b32 a253, 0
		v_accvgpr_write_b32 a254, 0
		v_accvgpr_write_b32 a255, 0
	; Select one steady loop per SIMD parity.
		s_getreg_b32 s19, hwreg(HW_REG_HW_ID, 4, 1)
		s_cmp_eq_u32 s19, 0
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_head_odd
.Lwmma_f16_matmul_tiled.loop_head_0:
	; M0 producers keep one MFMA between DirectToLds issues.
	; Prepare next LDS buffer in MFMA issue holes.
	; Advance SRDs at oracle MFMA ordinals.
	; All next-tile operands must be resident at loop entry.
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 a[0:3], v[32:35], v[28:31], a[0:3]
		ds_read_b128 v[92:95], v3 offset:64
		v_mfma_f32_16x16x32_f16 a[32:35], v[36:39], v[28:31], a[32:35]
		s_add_i32 s18, s18, 1
		v_mfma_f32_16x16x32_f16 a[64:67], v[40:43], v[28:31], a[64:67]
		ds_read_b128 v[96:99], v3 offset:192
		v_mfma_f32_16x16x32_f16 a[96:99], v[44:47], v[28:31], a[96:99]
		s_and_b32 s10, s18, 1
		s_add_u32 s12, s12, 0x80
		v_mfma_f32_16x16x32_f16 a[128:131], v[48:51], v[28:31], a[128:131]
		ds_read_b128 v[100:103], v3 offset:320
		v_mfma_f32_16x16x32_f16 a[160:163], v[52:55], v[28:31], a[160:163]
		s_addc_u32 s13, s13, 0
		v_mfma_f32_16x16x32_f16 a[192:195], v[56:59], v[28:31], a[192:195]
		s_lshl_b32 s19, s10, 10
		ds_read_b128 v[104:107], v3 offset:448
		v_mfma_f32_16x16x32_f16 a[224:227], v[60:63], v[28:31], a[224:227]
		s_lshl_b32 s10, s10, 16
		v_mfma_f32_16x16x32_f16 a[4:7], v[32:35], v[64:67], a[4:7]
		ds_read_b128 v[108:111], v3 offset:576
		v_mfma_f32_16x16x32_f16 a[36:39], v[36:39], v[64:67], a[36:39]
		s_add_i32 s10, s10, s19
		v_mfma_f32_16x16x32_f16 a[68:71], v[40:43], v[64:67], a[68:71]
		ds_read_b128 v[112:115], v3 offset:704
		v_mfma_f32_16x16x32_f16 a[100:103], v[44:47], v[64:67], a[100:103]
		v_mfma_f32_16x16x32_f16 a[132:135], v[48:51], v[64:67], a[132:135]
		ds_read_b128 v[116:119], v3 offset:832
		v_mfma_f32_16x16x32_f16 a[164:167], v[52:55], v[64:67], a[164:167]
		s_add_u32 s0, s0, 0x80
		s_addc_u32 s1, s1, 0
		v_mfma_f32_16x16x32_f16 a[196:199], v[56:59], v[64:67], a[196:199]
		ds_read_b128 v[120:123], v3 offset:960
		v_mfma_f32_16x16x32_f16 a[228:231], v[60:63], v[64:67], a[228:231]
		s_mov_b32 m0, s11
		v_mfma_f32_16x16x32_f16 a[8:11], v[32:35], v[68:71], a[8:11]
		v_mfma_f32_16x16x32_f16 a[40:43], v[36:39], v[68:71], a[40:43]
		s_mov_b32 s11, s10
		v_mfma_f32_16x16x32_f16 a[72:75], v[40:43], v[68:71], a[72:75]
		v_mfma_f32_16x16x32_f16 a[104:107], v[44:47], v[68:71], a[104:107]
		s_add_i32 s11, s11, s23
		v_mfma_f32_16x16x32_f16 a[136:139], v[48:51], v[68:71], a[136:139]
		v_mfma_f32_16x16x32_f16 a[168:171], v[52:55], v[68:71], a[168:171]
	; Full-line A DMA waits for A X1 reads.
		s_waitcnt lgkmcnt(0)
		s_barrier
	; Part 6: match even-SIMD oracle load ordinals.
		v_mfma_f32_16x16x32_f16 a[200:203], v[56:59], v[68:71], a[200:203]
		buffer_load_dwordx4 v4, s[12:15], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[232:235], v[60:63], v[68:71], a[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[12:15], v[32:35], v[72:75], a[12:15]
		ds_read_b128 v[124:127], v6 offset:64
		v_mfma_f32_16x16x32_f16 a[44:47], v[36:39], v[72:75], a[44:47]
		buffer_load_dwordx4 v4, s[12:15], s24 offen lds
		v_mfma_f32_16x16x32_f16 a[76:79], v[40:43], v[72:75], a[76:79]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[108:111], v[44:47], v[72:75], a[108:111]
		ds_read_b128 v[128:131], v6 offset:192
		v_mfma_f32_16x16x32_f16 a[140:143], v[48:51], v[72:75], a[140:143]
		buffer_load_dwordx4 v4, s[12:15], s25 offen lds
		v_mfma_f32_16x16x32_f16 a[172:175], v[52:55], v[72:75], a[172:175]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[204:207], v[56:59], v[72:75], a[204:207]
		ds_read_b128 v[132:135], v6 offset:320
		v_mfma_f32_16x16x32_f16 a[236:239], v[60:63], v[72:75], a[236:239]
		buffer_load_dwordx4 v4, s[12:15], s26 offen lds
		v_mfma_f32_16x16x32_f16 a[16:19], v[32:35], v[76:79], a[16:19]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[48:51], v[36:39], v[76:79], a[48:51]
		ds_read_b128 v[136:139], v6 offset:448
		v_mfma_f32_16x16x32_f16 a[80:83], v[40:43], v[76:79], a[80:83]
		buffer_load_dwordx4 v4, s[12:15], s27 offen lds
		v_mfma_f32_16x16x32_f16 a[112:115], v[44:47], v[76:79], a[112:115]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[144:147], v[48:51], v[76:79], a[144:147]
		ds_read_b128 v[140:143], v6 offset:576
		v_mfma_f32_16x16x32_f16 a[176:179], v[52:55], v[76:79], a[176:179]
		v_mfma_f32_16x16x32_f16 a[208:211], v[56:59], v[76:79], a[208:211]
		ds_read_b128 v[144:147], v6 offset:704
		v_mfma_f32_16x16x32_f16 a[240:243], v[60:63], v[76:79], a[240:243]
		v_mfma_f32_16x16x32_f16 a[20:23], v[32:35], v[80:83], a[20:23]
		ds_read_b128 v[148:151], v6 offset:832
		v_mfma_f32_16x16x32_f16 a[52:55], v[36:39], v[80:83], a[52:55]
		v_mfma_f32_16x16x32_f16 a[84:87], v[40:43], v[80:83], a[84:87]
		ds_read_b128 v[152:155], v6 offset:960
		v_mfma_f32_16x16x32_f16 a[116:119], v[44:47], v[80:83], a[116:119]
		v_mfma_f32_16x16x32_f16 a[148:151], v[48:51], v[80:83], a[148:151]
		v_mfma_f32_16x16x32_f16 a[180:183], v[52:55], v[80:83], a[180:183]
		v_mfma_f32_16x16x32_f16 a[212:215], v[56:59], v[80:83], a[212:215]
		v_mfma_f32_16x16x32_f16 a[244:247], v[60:63], v[80:83], a[244:247]
		v_mfma_f32_16x16x32_f16 a[24:27], v[32:35], v[84:87], a[24:27]
		v_mfma_f32_16x16x32_f16 a[56:59], v[36:39], v[84:87], a[56:59]
		v_mfma_f32_16x16x32_f16 a[88:91], v[40:43], v[84:87], a[88:91]
		v_mfma_f32_16x16x32_f16 a[120:123], v[44:47], v[84:87], a[120:123]
	; Full-line B DMA waits for B X1 reads.
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 a[152:155], v[48:51], v[84:87], a[152:155]
		buffer_load_dwordx4 v4, s[12:15], s28 offen lds
		v_mfma_f32_16x16x32_f16 a[184:187], v[52:55], v[84:87], a[184:187]
		v_add_u32_e32 v3, s10, v9
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[216:219], v[56:59], v[84:87], a[216:219]
		v_mfma_f32_16x16x32_f16 a[248:251], v[60:63], v[84:87], a[248:251]
		v_add_u32_e32 v6, s10, v2
		buffer_load_dwordx4 v4, s[12:15], s29 offen lds
		v_mfma_f32_16x16x32_f16 a[252:255], v[60:63], v[88:91], a[252:255]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[28:31], v[32:35], v[88:91], a[28:31]
		v_mfma_f32_16x16x32_f16 a[60:63], v[36:39], v[88:91], a[60:63]
		buffer_load_dwordx4 v4, s[12:15], s30 offen lds
		v_mfma_f32_16x16x32_f16 a[92:95], v[40:43], v[88:91], a[92:95]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[124:127], v[44:47], v[88:91], a[124:127]
		v_mfma_f32_16x16x32_f16 a[156:159], v[48:51], v[88:91], a[156:159]
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[188:191], v[52:55], v[88:91], a[188:191]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[220:223], v[56:59], v[88:91], a[220:223]
		v_mfma_f32_16x16x32_f16 a[0:3], v[124:127], v[92:95], a[0:3]
		buffer_load_dwordx4 v21, s[0:3], s24 offen lds
		v_mfma_f32_16x16x32_f16 a[32:35], v[128:131], v[92:95], a[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[64:67], v[132:135], v[92:95], a[64:67]
		v_mfma_f32_16x16x32_f16 a[96:99], v[136:139], v[92:95], a[96:99]
		v_mfma_f32_16x16x32_f16 a[128:131], v[140:143], v[92:95], a[128:131]
		v_mfma_f32_16x16x32_f16 a[160:163], v[144:147], v[92:95], a[160:163]
		v_mfma_f32_16x16x32_f16 a[192:195], v[148:151], v[92:95], a[192:195]
		v_mfma_f32_16x16x32_f16 a[224:227], v[152:155], v[92:95], a[224:227]
		v_mfma_f32_16x16x32_f16 a[228:231], v[152:155], v[96:99], a[228:231]
		v_mfma_f32_16x16x32_f16 a[4:7], v[124:127], v[96:99], a[4:7]
		v_mfma_f32_16x16x32_f16 a[36:39], v[128:131], v[96:99], a[36:39]
		v_mfma_f32_16x16x32_f16 a[68:71], v[132:135], v[96:99], a[68:71]
		v_mfma_f32_16x16x32_f16 a[100:103], v[136:139], v[96:99], a[100:103]
		v_mfma_f32_16x16x32_f16 a[132:135], v[140:143], v[96:99], a[132:135]
		v_mfma_f32_16x16x32_f16 a[164:167], v[144:147], v[96:99], a[164:167]
		v_mfma_f32_16x16x32_f16 a[196:199], v[148:151], v[96:99], a[196:199]
		v_mfma_f32_16x16x32_f16 a[200:203], v[148:151], v[100:103], a[200:203]
		v_mfma_f32_16x16x32_f16 a[8:11], v[124:127], v[100:103], a[8:11]
		v_mfma_f32_16x16x32_f16 a[40:43], v[128:131], v[100:103], a[40:43]
		v_mfma_f32_16x16x32_f16 a[72:75], v[132:135], v[100:103], a[72:75]
		v_mfma_f32_16x16x32_f16 a[104:107], v[136:139], v[100:103], a[104:107]
		v_mfma_f32_16x16x32_f16 a[136:139], v[140:143], v[100:103], a[136:139]
		buffer_load_dwordx4 v21, s[0:3], s25 offen lds
		v_mfma_f32_16x16x32_f16 a[168:171], v[144:147], v[100:103], a[168:171]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[232:235], v[152:155], v[100:103], a[232:235]
		buffer_load_dwordx4 v21, s[0:3], s26 offen lds
		v_mfma_f32_16x16x32_f16 a[236:239], v[152:155], v[104:107], a[236:239]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[12:15], v[124:127], v[104:107], a[12:15]
		buffer_load_dwordx4 v21, s[0:3], s27 offen lds
		v_mfma_f32_16x16x32_f16 a[44:47], v[128:131], v[104:107], a[44:47]
		v_mfma_f32_16x16x32_f16 a[76:79], v[132:135], v[104:107], a[76:79]
	; Three A lines visible; 13 writes stay overlapped.
		s_waitcnt vmcnt(13)
		v_mfma_f32_16x16x32_f16 a[108:111], v[136:139], v[104:107], a[108:111]
		s_barrier
	; Preserve write buffer while read buffer flips.
	; Part 4: release four dead A rows at MFMA 92.
		v_mfma_f32_16x16x32_f16 a[140:143], v[140:143], v[104:107], a[140:143]
		ds_read_b128 v[28:31], v3
		v_mfma_f32_16x16x32_f16 a[172:175], v[144:147], v[104:107], a[172:175]
		ds_read_b128 v[64:67], v3 offset:128
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[204:207], v[148:151], v[104:107], a[204:207]
		ds_read_b128 v[68:71], v3 offset:256
		v_mfma_f32_16x16x32_f16 a[16:19], v[124:127], v[108:111], a[16:19]
	; Tail B DMA overlaps X0 local reads.
		buffer_load_dwordx4 v21, s[0:3], s28 offen lds
		s_nop 0
	; Part 3: retire each A row before reloading its register.
		v_mfma_f32_16x16x32_f16 a[48:51], v[128:131], v[108:111], a[48:51]
		ds_read_b128 v[72:75], v3 offset:384
		v_mfma_f32_16x16x32_f16 a[20:23], v[124:127], v[112:115], a[20:23]
		ds_read_b128 v[76:79], v3 offset:512
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[52:55], v[128:131], v[112:115], a[52:55]
		v_mfma_f32_16x16x32_f16 a[84:87], v[132:135], v[112:115], a[84:87]
		buffer_load_dwordx4 v21, s[0:3], s29 offen lds
		v_mfma_f32_16x16x32_f16 a[116:119], v[136:139], v[112:115], a[116:119]
		v_mfma_f32_16x16x32_f16 a[148:151], v[140:143], v[112:115], a[148:151]
		ds_read_b128 v[80:83], v3 offset:640
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[180:183], v[144:147], v[112:115], a[180:183]
		ds_read_b128 v[84:87], v3 offset:768
		v_mfma_f32_16x16x32_f16 a[212:215], v[148:151], v[112:115], a[212:215]
		ds_read_b128 v[88:91], v3 offset:896
		v_mfma_f32_16x16x32_f16 a[244:247], v[152:155], v[112:115], a[244:247]
		ds_read_b128 v[32:35], v6
		v_mfma_f32_16x16x32_f16 a[80:83], v[132:135], v[108:111], a[80:83]
		ds_read_b128 v[36:39], v6 offset:128
		v_mfma_f32_16x16x32_f16 a[112:115], v[136:139], v[108:111], a[112:115]
		v_mfma_f32_16x16x32_f16 a[144:147], v[140:143], v[108:111], a[144:147]
		v_mfma_f32_16x16x32_f16 a[176:179], v[144:147], v[108:111], a[176:179]
		ds_read_b128 v[40:43], v6 offset:256
		v_mfma_f32_16x16x32_f16 a[208:211], v[148:151], v[108:111], a[208:211]
		v_mfma_f32_16x16x32_f16 a[240:243], v[152:155], v[108:111], a[240:243]
		v_mfma_f32_16x16x32_f16 a[24:27], v[124:127], v[116:119], a[24:27]
		ds_read_b128 v[44:47], v6 offset:384
		v_mfma_f32_16x16x32_f16 a[56:59], v[128:131], v[116:119], a[56:59]
		v_mfma_f32_16x16x32_f16 a[88:91], v[132:135], v[116:119], a[88:91]
		ds_read_b128 v[48:51], v6 offset:512
		v_mfma_f32_16x16x32_f16 a[120:123], v[136:139], v[116:119], a[120:123]
		v_mfma_f32_16x16x32_f16 a[152:155], v[140:143], v[116:119], a[152:155]
		v_mfma_f32_16x16x32_f16 a[184:187], v[144:147], v[116:119], a[184:187]
		ds_read_b128 v[52:55], v6 offset:640
		v_mfma_f32_16x16x32_f16 a[216:219], v[148:151], v[116:119], a[216:219]
		v_mfma_f32_16x16x32_f16 a[248:251], v[152:155], v[116:119], a[248:251]
		v_mfma_f32_16x16x32_f16 a[28:31], v[124:127], v[120:123], a[28:31]
		ds_read_b128 v[56:59], v6 offset:768
		v_mfma_f32_16x16x32_f16 a[60:63], v[128:131], v[120:123], a[60:63]
		v_mfma_f32_16x16x32_f16 a[92:95], v[132:135], v[120:123], a[92:95]
		v_mfma_f32_16x16x32_f16 a[124:127], v[136:139], v[120:123], a[124:127]
		ds_read_b128 v[60:63], v6 offset:896
		v_mfma_f32_16x16x32_f16 a[156:159], v[140:143], v[120:123], a[156:159]
		buffer_load_dwordx4 v21, s[0:3], s30 offen lds
		v_mfma_f32_16x16x32_f16 a[188:191], v[144:147], v[120:123], a[188:191]
		v_mfma_f32_16x16x32_f16 a[220:223], v[148:151], v[120:123], a[220:223]
		v_mfma_f32_16x16x32_f16 a[252:255], v[152:155], v[120:123], a[252:255]
	; Wave-local m0 base is loop invariant.
		s_cmp_lt_i32 s18, 0x7e
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
		s_branch .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_odd:
	; M0 producers keep one MFMA between DirectToLds issues.
	; Odd SIMD shifts shared-pipe DMA/read issue.
	; Prepare next LDS buffer in MFMA issue holes.
	; Advance SRDs at oracle MFMA ordinals.
	; All next-tile operands must be resident at loop entry.
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 a[0:3], v[32:35], v[28:31], a[0:3]
		ds_read_b128 v[92:95], v3 offset:64
		v_mfma_f32_16x16x32_f16 a[32:35], v[36:39], v[28:31], a[32:35]
		s_add_i32 s18, s18, 1
		v_mfma_f32_16x16x32_f16 a[64:67], v[40:43], v[28:31], a[64:67]
		ds_read_b128 v[96:99], v3 offset:192
		v_mfma_f32_16x16x32_f16 a[96:99], v[44:47], v[28:31], a[96:99]
		s_and_b32 s10, s18, 1
		s_add_u32 s12, s12, 0x80
		v_mfma_f32_16x16x32_f16 a[128:131], v[48:51], v[28:31], a[128:131]
		ds_read_b128 v[100:103], v3 offset:320
		v_mfma_f32_16x16x32_f16 a[160:163], v[52:55], v[28:31], a[160:163]
		s_addc_u32 s13, s13, 0
		v_mfma_f32_16x16x32_f16 a[192:195], v[56:59], v[28:31], a[192:195]
		s_lshl_b32 s19, s10, 10
		ds_read_b128 v[104:107], v3 offset:448
		v_mfma_f32_16x16x32_f16 a[224:227], v[60:63], v[28:31], a[224:227]
		s_lshl_b32 s10, s10, 16
		v_mfma_f32_16x16x32_f16 a[4:7], v[32:35], v[64:67], a[4:7]
		ds_read_b128 v[108:111], v3 offset:576
		v_mfma_f32_16x16x32_f16 a[36:39], v[36:39], v[64:67], a[36:39]
		s_add_i32 s10, s10, s19
		v_mfma_f32_16x16x32_f16 a[68:71], v[40:43], v[64:67], a[68:71]
		ds_read_b128 v[112:115], v3 offset:704
		v_mfma_f32_16x16x32_f16 a[100:103], v[44:47], v[64:67], a[100:103]
		v_mfma_f32_16x16x32_f16 a[132:135], v[48:51], v[64:67], a[132:135]
		ds_read_b128 v[116:119], v3 offset:832
		v_mfma_f32_16x16x32_f16 a[164:167], v[52:55], v[64:67], a[164:167]
		s_add_u32 s0, s0, 0x80
		s_addc_u32 s1, s1, 0
		v_mfma_f32_16x16x32_f16 a[196:199], v[56:59], v[64:67], a[196:199]
		ds_read_b128 v[120:123], v3 offset:960
		v_mfma_f32_16x16x32_f16 a[228:231], v[60:63], v[64:67], a[228:231]
		s_mov_b32 m0, s11
		v_mfma_f32_16x16x32_f16 a[8:11], v[32:35], v[68:71], a[8:11]
		v_mfma_f32_16x16x32_f16 a[40:43], v[36:39], v[68:71], a[40:43]
		s_mov_b32 s11, s10
		v_mfma_f32_16x16x32_f16 a[72:75], v[40:43], v[68:71], a[72:75]
		v_mfma_f32_16x16x32_f16 a[104:107], v[44:47], v[68:71], a[104:107]
		s_add_i32 s11, s11, s23
		v_mfma_f32_16x16x32_f16 a[136:139], v[48:51], v[68:71], a[136:139]
		v_mfma_f32_16x16x32_f16 a[168:171], v[52:55], v[68:71], a[168:171]
	; Full-line A DMA waits for A X1 reads.
		s_waitcnt lgkmcnt(0)
		s_barrier
	; Part 6: match even-SIMD oracle load ordinals.
		v_mfma_f32_16x16x32_f16 a[200:203], v[56:59], v[68:71], a[200:203]
		ds_read_b128 v[124:127], v6 offset:64
		v_mfma_f32_16x16x32_f16 a[232:235], v[60:63], v[68:71], a[232:235]
		buffer_load_dwordx4 v4, s[12:15], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[12:15], v[32:35], v[72:75], a[12:15]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[44:47], v[36:39], v[72:75], a[44:47]
		ds_read_b128 v[128:131], v6 offset:192
		v_mfma_f32_16x16x32_f16 a[76:79], v[40:43], v[72:75], a[76:79]
		buffer_load_dwordx4 v4, s[12:15], s24 offen lds
		v_mfma_f32_16x16x32_f16 a[108:111], v[44:47], v[72:75], a[108:111]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[140:143], v[48:51], v[72:75], a[140:143]
		ds_read_b128 v[132:135], v6 offset:320
		v_mfma_f32_16x16x32_f16 a[172:175], v[52:55], v[72:75], a[172:175]
		buffer_load_dwordx4 v4, s[12:15], s25 offen lds
		v_mfma_f32_16x16x32_f16 a[204:207], v[56:59], v[72:75], a[204:207]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[236:239], v[60:63], v[72:75], a[236:239]
		ds_read_b128 v[136:139], v6 offset:448
		v_mfma_f32_16x16x32_f16 a[16:19], v[32:35], v[76:79], a[16:19]
		buffer_load_dwordx4 v4, s[12:15], s26 offen lds
		v_mfma_f32_16x16x32_f16 a[48:51], v[36:39], v[76:79], a[48:51]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], v[40:43], v[76:79], a[80:83]
		ds_read_b128 v[140:143], v6 offset:576
		v_mfma_f32_16x16x32_f16 a[112:115], v[44:47], v[76:79], a[112:115]
		buffer_load_dwordx4 v4, s[12:15], s27 offen lds
		v_mfma_f32_16x16x32_f16 a[144:147], v[48:51], v[76:79], a[144:147]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[176:179], v[52:55], v[76:79], a[176:179]
		v_mfma_f32_16x16x32_f16 a[208:211], v[56:59], v[76:79], a[208:211]
		ds_read_b128 v[144:147], v6 offset:704
		v_mfma_f32_16x16x32_f16 a[240:243], v[60:63], v[76:79], a[240:243]
		v_mfma_f32_16x16x32_f16 a[20:23], v[32:35], v[80:83], a[20:23]
		ds_read_b128 v[148:151], v6 offset:832
		v_mfma_f32_16x16x32_f16 a[52:55], v[36:39], v[80:83], a[52:55]
		v_mfma_f32_16x16x32_f16 a[84:87], v[40:43], v[80:83], a[84:87]
		ds_read_b128 v[152:155], v6 offset:960
		v_mfma_f32_16x16x32_f16 a[116:119], v[44:47], v[80:83], a[116:119]
		v_mfma_f32_16x16x32_f16 a[148:151], v[48:51], v[80:83], a[148:151]
		v_mfma_f32_16x16x32_f16 a[180:183], v[52:55], v[80:83], a[180:183]
		v_mfma_f32_16x16x32_f16 a[212:215], v[56:59], v[80:83], a[212:215]
		v_mfma_f32_16x16x32_f16 a[244:247], v[60:63], v[80:83], a[244:247]
		v_mfma_f32_16x16x32_f16 a[24:27], v[32:35], v[84:87], a[24:27]
		v_mfma_f32_16x16x32_f16 a[56:59], v[36:39], v[84:87], a[56:59]
		v_mfma_f32_16x16x32_f16 a[88:91], v[40:43], v[84:87], a[88:91]
		v_mfma_f32_16x16x32_f16 a[120:123], v[44:47], v[84:87], a[120:123]
	; Full-line B DMA waits for B X1 reads.
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 a[152:155], v[48:51], v[84:87], a[152:155]
		v_mfma_f32_16x16x32_f16 a[184:187], v[52:55], v[84:87], a[184:187]
		v_add_u32_e32 v3, s10, v9
		buffer_load_dwordx4 v4, s[12:15], s28 offen lds
		v_mfma_f32_16x16x32_f16 a[216:219], v[56:59], v[84:87], a[216:219]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[248:251], v[60:63], v[84:87], a[248:251]
		v_add_u32_e32 v6, s10, v2
		v_mfma_f32_16x16x32_f16 a[252:255], v[60:63], v[88:91], a[252:255]
		buffer_load_dwordx4 v4, s[12:15], s29 offen lds
		v_mfma_f32_16x16x32_f16 a[28:31], v[32:35], v[88:91], a[28:31]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[60:63], v[36:39], v[88:91], a[60:63]
		v_mfma_f32_16x16x32_f16 a[92:95], v[40:43], v[88:91], a[92:95]
		buffer_load_dwordx4 v4, s[12:15], s30 offen lds
		v_mfma_f32_16x16x32_f16 a[124:127], v[44:47], v[88:91], a[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[156:159], v[48:51], v[88:91], a[156:159]
		v_mfma_f32_16x16x32_f16 a[188:191], v[52:55], v[88:91], a[188:191]
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[220:223], v[56:59], v[88:91], a[220:223]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[0:3], v[124:127], v[92:95], a[0:3]
		v_mfma_f32_16x16x32_f16 a[32:35], v[128:131], v[92:95], a[32:35]
		buffer_load_dwordx4 v21, s[0:3], s24 offen lds
		v_mfma_f32_16x16x32_f16 a[64:67], v[132:135], v[92:95], a[64:67]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[96:99], v[136:139], v[92:95], a[96:99]
		v_mfma_f32_16x16x32_f16 a[128:131], v[140:143], v[92:95], a[128:131]
		v_mfma_f32_16x16x32_f16 a[160:163], v[144:147], v[92:95], a[160:163]
		v_mfma_f32_16x16x32_f16 a[192:195], v[148:151], v[92:95], a[192:195]
		v_mfma_f32_16x16x32_f16 a[224:227], v[152:155], v[92:95], a[224:227]
		v_mfma_f32_16x16x32_f16 a[228:231], v[152:155], v[96:99], a[228:231]
		v_mfma_f32_16x16x32_f16 a[4:7], v[124:127], v[96:99], a[4:7]
		v_mfma_f32_16x16x32_f16 a[36:39], v[128:131], v[96:99], a[36:39]
		v_mfma_f32_16x16x32_f16 a[68:71], v[132:135], v[96:99], a[68:71]
		v_mfma_f32_16x16x32_f16 a[100:103], v[136:139], v[96:99], a[100:103]
		v_mfma_f32_16x16x32_f16 a[132:135], v[140:143], v[96:99], a[132:135]
		v_mfma_f32_16x16x32_f16 a[164:167], v[144:147], v[96:99], a[164:167]
		v_mfma_f32_16x16x32_f16 a[196:199], v[148:151], v[96:99], a[196:199]
		v_mfma_f32_16x16x32_f16 a[200:203], v[148:151], v[100:103], a[200:203]
		v_mfma_f32_16x16x32_f16 a[8:11], v[124:127], v[100:103], a[8:11]
		v_mfma_f32_16x16x32_f16 a[40:43], v[128:131], v[100:103], a[40:43]
		v_mfma_f32_16x16x32_f16 a[72:75], v[132:135], v[100:103], a[72:75]
		v_mfma_f32_16x16x32_f16 a[104:107], v[136:139], v[100:103], a[104:107]
		buffer_load_dwordx4 v21, s[0:3], s25 offen lds
		v_mfma_f32_16x16x32_f16 a[136:139], v[140:143], v[100:103], a[136:139]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[168:171], v[144:147], v[100:103], a[168:171]
		buffer_load_dwordx4 v21, s[0:3], s26 offen lds
		v_mfma_f32_16x16x32_f16 a[232:235], v[152:155], v[100:103], a[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[236:239], v[152:155], v[104:107], a[236:239]
		buffer_load_dwordx4 v21, s[0:3], s27 offen lds
		v_mfma_f32_16x16x32_f16 a[12:15], v[124:127], v[104:107], a[12:15]
		v_mfma_f32_16x16x32_f16 a[44:47], v[128:131], v[104:107], a[44:47]
		v_mfma_f32_16x16x32_f16 a[76:79], v[132:135], v[104:107], a[76:79]
	; Three A lines visible; 13 writes stay overlapped.
		s_waitcnt vmcnt(13)
		v_mfma_f32_16x16x32_f16 a[108:111], v[136:139], v[104:107], a[108:111]
		s_barrier
	; Preserve write buffer while read buffer flips.
	; Part 4: release four dead A rows at MFMA 92.
		v_mfma_f32_16x16x32_f16 a[140:143], v[140:143], v[104:107], a[140:143]
		ds_read_b128 v[28:31], v3
		v_mfma_f32_16x16x32_f16 a[172:175], v[144:147], v[104:107], a[172:175]
		ds_read_b128 v[64:67], v3 offset:128
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[204:207], v[148:151], v[104:107], a[204:207]
		buffer_load_dwordx4 v21, s[0:3], s28 offen lds
		v_mfma_f32_16x16x32_f16 a[16:19], v[124:127], v[108:111], a[16:19]
		s_nop 0
	; Part 3: retire each A row before reloading its register.
		ds_read_b128 v[68:71], v3 offset:256
		v_mfma_f32_16x16x32_f16 a[48:51], v[128:131], v[108:111], a[48:51]
		ds_read_b128 v[72:75], v3 offset:384
		v_mfma_f32_16x16x32_f16 a[20:23], v[124:127], v[112:115], a[20:23]
		ds_read_b128 v[76:79], v3 offset:512
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[52:55], v[128:131], v[112:115], a[52:55]
		buffer_load_dwordx4 v21, s[0:3], s29 offen lds
		v_mfma_f32_16x16x32_f16 a[84:87], v[132:135], v[112:115], a[84:87]
		v_mfma_f32_16x16x32_f16 a[116:119], v[136:139], v[112:115], a[116:119]
		v_mfma_f32_16x16x32_f16 a[148:151], v[140:143], v[112:115], a[148:151]
		ds_read_b128 v[80:83], v3 offset:640
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[180:183], v[144:147], v[112:115], a[180:183]
		ds_read_b128 v[84:87], v3 offset:768
		v_mfma_f32_16x16x32_f16 a[212:215], v[148:151], v[112:115], a[212:215]
		ds_read_b128 v[88:91], v3 offset:896
		v_mfma_f32_16x16x32_f16 a[244:247], v[152:155], v[112:115], a[244:247]
		ds_read_b128 v[32:35], v6
		v_mfma_f32_16x16x32_f16 a[80:83], v[132:135], v[108:111], a[80:83]
		ds_read_b128 v[36:39], v6 offset:128
		v_mfma_f32_16x16x32_f16 a[112:115], v[136:139], v[108:111], a[112:115]
		v_mfma_f32_16x16x32_f16 a[144:147], v[140:143], v[108:111], a[144:147]
		v_mfma_f32_16x16x32_f16 a[176:179], v[144:147], v[108:111], a[176:179]
		ds_read_b128 v[40:43], v6 offset:256
		v_mfma_f32_16x16x32_f16 a[208:211], v[148:151], v[108:111], a[208:211]
		v_mfma_f32_16x16x32_f16 a[240:243], v[152:155], v[108:111], a[240:243]
		v_mfma_f32_16x16x32_f16 a[24:27], v[124:127], v[116:119], a[24:27]
		ds_read_b128 v[44:47], v6 offset:384
		v_mfma_f32_16x16x32_f16 a[56:59], v[128:131], v[116:119], a[56:59]
		v_mfma_f32_16x16x32_f16 a[88:91], v[132:135], v[116:119], a[88:91]
		ds_read_b128 v[48:51], v6 offset:512
		v_mfma_f32_16x16x32_f16 a[120:123], v[136:139], v[116:119], a[120:123]
		v_mfma_f32_16x16x32_f16 a[152:155], v[140:143], v[116:119], a[152:155]
		v_mfma_f32_16x16x32_f16 a[184:187], v[144:147], v[116:119], a[184:187]
		ds_read_b128 v[52:55], v6 offset:640
		v_mfma_f32_16x16x32_f16 a[216:219], v[148:151], v[116:119], a[216:219]
		v_mfma_f32_16x16x32_f16 a[248:251], v[152:155], v[116:119], a[248:251]
		v_mfma_f32_16x16x32_f16 a[28:31], v[124:127], v[120:123], a[28:31]
		ds_read_b128 v[56:59], v6 offset:768
		v_mfma_f32_16x16x32_f16 a[60:63], v[128:131], v[120:123], a[60:63]
		v_mfma_f32_16x16x32_f16 a[92:95], v[132:135], v[120:123], a[92:95]
		ds_read_b128 v[60:63], v6 offset:896
		v_mfma_f32_16x16x32_f16 a[124:127], v[136:139], v[120:123], a[124:127]
		buffer_load_dwordx4 v21, s[0:3], s30 offen lds
		v_mfma_f32_16x16x32_f16 a[156:159], v[140:143], v[120:123], a[156:159]
		v_mfma_f32_16x16x32_f16 a[188:191], v[144:147], v[120:123], a[188:191]
		v_mfma_f32_16x16x32_f16 a[220:223], v[148:151], v[120:123], a[220:223]
		v_mfma_f32_16x16x32_f16 a[252:255], v[152:155], v[120:123], a[252:255]
	; Wave-local m0 base is loop invariant.
		s_cmp_lt_i32 s18, 0x7e
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_odd
.Lwmma_f16_matmul_tiled.loop_exit_0:
	; Grouped carry puts B0 behind all eight A reads.
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 a[0:3], v[32:35], v[28:31], a[0:3]
		ds_read_b128 v[92:95], v2 offset:64
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 a[32:35], v[36:39], v[28:31], a[32:35]
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 a[64:67], v[40:43], v[28:31], a[64:67]
		ds_read_b128 v[96:99], v2 offset:192
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 a[96:99], v[44:47], v[28:31], a[96:99]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 a[128:131], v[48:51], v[28:31], a[128:131]
		ds_read_b128 v[100:103], v2 offset:320
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[160:163], v[52:55], v[28:31], a[160:163]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 a[192:195], v[56:59], v[28:31], a[192:195]
		ds_read_b128 v[104:107], v2 offset:448
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 a[224:227], v[60:63], v[28:31], a[224:227]
		v_mfma_f32_16x16x32_f16 a[4:7], v[32:35], v[64:67], a[4:7]
		ds_read_b128 v[28:31], v2 offset:576
		v_mfma_f32_16x16x32_f16 a[36:39], v[36:39], v[64:67], a[36:39]
		v_mfma_f32_16x16x32_f16 a[68:71], v[40:43], v[64:67], a[68:71]
		ds_read_b128 v[108:111], v2 offset:704
		v_mfma_f32_16x16x32_f16 a[100:103], v[44:47], v[64:67], a[100:103]
		v_mfma_f32_16x16x32_f16 a[132:135], v[48:51], v[64:67], a[132:135]
		ds_read_b128 v[112:115], v2 offset:832
		v_mfma_f32_16x16x32_f16 a[164:167], v[52:55], v[64:67], a[164:167]
		v_mfma_f32_16x16x32_f16 a[196:199], v[56:59], v[64:67], a[196:199]
		ds_read_b128 v[116:119], v2 offset:960
		v_mfma_f32_16x16x32_f16 a[228:231], v[60:63], v[64:67], a[228:231]
		v_mfma_f32_16x16x32_f16 a[232:235], v[60:63], v[68:71], a[232:235]
		v_mfma_f32_16x16x32_f16 a[8:11], v[32:35], v[68:71], a[8:11]
		v_mfma_f32_16x16x32_f16 a[40:43], v[36:39], v[68:71], a[40:43]
		v_mfma_f32_16x16x32_f16 a[72:75], v[40:43], v[68:71], a[72:75]
		v_mfma_f32_16x16x32_f16 a[104:107], v[44:47], v[68:71], a[104:107]
		v_mfma_f32_16x16x32_f16 a[136:139], v[48:51], v[68:71], a[136:139]
		v_mfma_f32_16x16x32_f16 a[168:171], v[52:55], v[68:71], a[168:171]
		v_mfma_f32_16x16x32_f16 a[200:203], v[56:59], v[68:71], a[200:203]
		v_mfma_f32_16x16x32_f16 a[204:207], v[56:59], v[72:75], a[204:207]
		v_mfma_f32_16x16x32_f16 a[12:15], v[32:35], v[72:75], a[12:15]
		v_mfma_f32_16x16x32_f16 a[44:47], v[36:39], v[72:75], a[44:47]
		v_mfma_f32_16x16x32_f16 a[76:79], v[40:43], v[72:75], a[76:79]
		v_mfma_f32_16x16x32_f16 a[108:111], v[44:47], v[72:75], a[108:111]
		v_mfma_f32_16x16x32_f16 a[140:143], v[48:51], v[72:75], a[140:143]
		v_mfma_f32_16x16x32_f16 a[172:175], v[52:55], v[72:75], a[172:175]
		v_mfma_f32_16x16x32_f16 a[236:239], v[60:63], v[72:75], a[236:239]
		v_mfma_f32_16x16x32_f16 a[240:243], v[60:63], v[76:79], a[240:243]
		v_mfma_f32_16x16x32_f16 a[16:19], v[32:35], v[76:79], a[16:19]
		v_mfma_f32_16x16x32_f16 a[48:51], v[36:39], v[76:79], a[48:51]
		v_mfma_f32_16x16x32_f16 a[80:83], v[40:43], v[76:79], a[80:83]
		v_mfma_f32_16x16x32_f16 a[112:115], v[44:47], v[76:79], a[112:115]
		v_mfma_f32_16x16x32_f16 a[144:147], v[48:51], v[76:79], a[144:147]
		v_mfma_f32_16x16x32_f16 a[176:179], v[52:55], v[76:79], a[176:179]
		v_mfma_f32_16x16x32_f16 a[208:211], v[56:59], v[76:79], a[208:211]
		v_mfma_f32_16x16x32_f16 a[212:215], v[56:59], v[80:83], a[212:215]
		v_mfma_f32_16x16x32_f16 a[20:23], v[32:35], v[80:83], a[20:23]
		v_mfma_f32_16x16x32_f16 a[52:55], v[36:39], v[80:83], a[52:55]
		v_mfma_f32_16x16x32_f16 a[84:87], v[40:43], v[80:83], a[84:87]
		v_mfma_f32_16x16x32_f16 a[116:119], v[44:47], v[80:83], a[116:119]
		v_mfma_f32_16x16x32_f16 a[148:151], v[48:51], v[80:83], a[148:151]
		v_mfma_f32_16x16x32_f16 a[180:183], v[52:55], v[80:83], a[180:183]
		v_mfma_f32_16x16x32_f16 a[244:247], v[60:63], v[80:83], a[244:247]
		v_mfma_f32_16x16x32_f16 a[248:251], v[60:63], v[84:87], a[248:251]
		v_mfma_f32_16x16x32_f16 a[24:27], v[32:35], v[84:87], a[24:27]
		v_mfma_f32_16x16x32_f16 a[56:59], v[36:39], v[84:87], a[56:59]
		v_mfma_f32_16x16x32_f16 a[88:91], v[40:43], v[84:87], a[88:91]
		v_mfma_f32_16x16x32_f16 a[120:123], v[44:47], v[84:87], a[120:123]
		v_mfma_f32_16x16x32_f16 a[152:155], v[48:51], v[84:87], a[152:155]
		v_mfma_f32_16x16x32_f16 a[184:187], v[52:55], v[84:87], a[184:187]
		v_mfma_f32_16x16x32_f16 a[216:219], v[56:59], v[84:87], a[216:219]
		v_mfma_f32_16x16x32_f16 a[220:223], v[56:59], v[88:91], a[220:223]
		v_mfma_f32_16x16x32_f16 a[28:31], v[32:35], v[88:91], a[28:31]
		v_mfma_f32_16x16x32_f16 a[60:63], v[36:39], v[88:91], a[60:63]
		v_mfma_f32_16x16x32_f16 a[92:95], v[40:43], v[88:91], a[92:95]
		v_mfma_f32_16x16x32_f16 a[124:127], v[44:47], v[88:91], a[124:127]
		v_mfma_f32_16x16x32_f16 a[156:159], v[48:51], v[88:91], a[156:159]
		v_mfma_f32_16x16x32_f16 a[188:191], v[52:55], v[88:91], a[188:191]
		v_mfma_f32_16x16x32_f16 a[252:255], v[60:63], v[88:91], a[252:255]
		ds_read_b128 v[136:139], v9 offset:64
		ds_read_b128 v[140:143], v9 offset:192
		ds_read_b128 v[144:147], v9 offset:320
		ds_read_b128 v[148:151], v9 offset:448
		ds_read_b128 v[64:67], v9 offset:576
		ds_read_b128 v[68:71], v9 offset:704
		ds_read_b128 v[72:75], v9 offset:832
		ds_read_b128 v[132:135], v9 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], v[92:95], v[136:139], a[0:3]
		v_mfma_f32_16x16x32_f16 a[32:35], v[96:99], v[136:139], a[32:35]
		v_mfma_f32_16x16x32_f16 a[64:67], v[100:103], v[136:139], a[64:67]
		v_mfma_f32_16x16x32_f16 a[96:99], v[104:107], v[136:139], a[96:99]
		v_mfma_f32_16x16x32_f16 a[128:131], v[28:31], v[136:139], a[128:131]
		v_mfma_f32_16x16x32_f16 a[160:163], v[108:111], v[136:139], a[160:163]
		v_mfma_f32_16x16x32_f16 a[192:195], v[112:115], v[136:139], a[192:195]
		v_mfma_f32_16x16x32_f16 a[224:227], v[116:119], v[136:139], a[224:227]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 a[228:231], v[116:119], v[140:143], a[228:231]
		v_mfma_f32_16x16x32_f16 a[4:7], v[92:95], v[140:143], a[4:7]
		v_mfma_f32_16x16x32_f16 a[36:39], v[96:99], v[140:143], a[36:39]
		v_mfma_f32_16x16x32_f16 a[68:71], v[100:103], v[140:143], a[68:71]
		v_mfma_f32_16x16x32_f16 a[100:103], v[104:107], v[140:143], a[100:103]
		v_mfma_f32_16x16x32_f16 a[132:135], v[28:31], v[140:143], a[132:135]
		v_mfma_f32_16x16x32_f16 a[164:167], v[108:111], v[140:143], a[164:167]
		v_mfma_f32_16x16x32_f16 a[196:199], v[112:115], v[140:143], a[196:199]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 a[200:203], v[112:115], v[144:147], a[200:203]
		v_mfma_f32_16x16x32_f16 a[8:11], v[92:95], v[144:147], a[8:11]
		v_mfma_f32_16x16x32_f16 a[40:43], v[96:99], v[144:147], a[40:43]
		v_mfma_f32_16x16x32_f16 a[72:75], v[100:103], v[144:147], a[72:75]
		v_mfma_f32_16x16x32_f16 a[104:107], v[104:107], v[144:147], a[104:107]
		v_mfma_f32_16x16x32_f16 a[136:139], v[28:31], v[144:147], a[136:139]
		v_mfma_f32_16x16x32_f16 a[168:171], v[108:111], v[144:147], a[168:171]
		v_mfma_f32_16x16x32_f16 a[232:235], v[116:119], v[144:147], a[232:235]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 a[236:239], v[116:119], v[148:151], a[236:239]
		v_mfma_f32_16x16x32_f16 a[12:15], v[92:95], v[148:151], a[12:15]
		v_mfma_f32_16x16x32_f16 a[44:47], v[96:99], v[148:151], a[44:47]
		v_mfma_f32_16x16x32_f16 a[76:79], v[100:103], v[148:151], a[76:79]
		v_mfma_f32_16x16x32_f16 a[108:111], v[104:107], v[148:151], a[108:111]
		v_mfma_f32_16x16x32_f16 a[140:143], v[28:31], v[148:151], a[140:143]
		v_mfma_f32_16x16x32_f16 a[172:175], v[108:111], v[148:151], a[172:175]
		v_mfma_f32_16x16x32_f16 a[204:207], v[112:115], v[148:151], a[204:207]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 a[208:211], v[112:115], v[64:67], a[208:211]
		v_mfma_f32_16x16x32_f16 a[16:19], v[92:95], v[64:67], a[16:19]
		v_mfma_f32_16x16x32_f16 a[48:51], v[96:99], v[64:67], a[48:51]
		v_mfma_f32_16x16x32_f16 a[80:83], v[100:103], v[64:67], a[80:83]
		v_mfma_f32_16x16x32_f16 a[112:115], v[104:107], v[64:67], a[112:115]
		v_mfma_f32_16x16x32_f16 a[144:147], v[28:31], v[64:67], a[144:147]
		v_mfma_f32_16x16x32_f16 a[176:179], v[108:111], v[64:67], a[176:179]
		v_mfma_f32_16x16x32_f16 a[240:243], v[116:119], v[64:67], a[240:243]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 a[244:247], v[116:119], v[68:71], a[244:247]
		v_mfma_f32_16x16x32_f16 a[20:23], v[92:95], v[68:71], a[20:23]
		v_mfma_f32_16x16x32_f16 a[52:55], v[96:99], v[68:71], a[52:55]
		v_mfma_f32_16x16x32_f16 a[84:87], v[100:103], v[68:71], a[84:87]
		v_mfma_f32_16x16x32_f16 a[116:119], v[104:107], v[68:71], a[116:119]
		v_mfma_f32_16x16x32_f16 a[148:151], v[28:31], v[68:71], a[148:151]
		v_mfma_f32_16x16x32_f16 a[180:183], v[108:111], v[68:71], a[180:183]
		v_mfma_f32_16x16x32_f16 a[212:215], v[112:115], v[68:71], a[212:215]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 a[216:219], v[112:115], v[72:75], a[216:219]
		v_mfma_f32_16x16x32_f16 a[24:27], v[92:95], v[72:75], a[24:27]
		v_mfma_f32_16x16x32_f16 a[56:59], v[96:99], v[72:75], a[56:59]
		v_mfma_f32_16x16x32_f16 a[88:91], v[100:103], v[72:75], a[88:91]
		v_mfma_f32_16x16x32_f16 a[120:123], v[104:107], v[72:75], a[120:123]
		v_mfma_f32_16x16x32_f16 a[152:155], v[28:31], v[72:75], a[152:155]
		v_mfma_f32_16x16x32_f16 a[184:187], v[108:111], v[72:75], a[184:187]
		v_mfma_f32_16x16x32_f16 a[248:251], v[116:119], v[72:75], a[248:251]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 a[252:255], v[116:119], v[132:135], a[252:255]
		v_mfma_f32_16x16x32_f16 a[28:31], v[92:95], v[132:135], a[28:31]
		v_mfma_f32_16x16x32_f16 a[60:63], v[96:99], v[132:135], a[60:63]
		v_mfma_f32_16x16x32_f16 a[92:95], v[100:103], v[132:135], a[92:95]
		v_mfma_f32_16x16x32_f16 a[124:127], v[104:107], v[132:135], a[124:127]
		v_mfma_f32_16x16x32_f16 a[156:159], v[28:31], v[132:135], a[156:159]
		v_mfma_f32_16x16x32_f16 a[188:191], v[108:111], v[132:135], a[188:191]
		v_mfma_f32_16x16x32_f16 a[220:223], v[112:115], v[132:135], a[220:223]
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v0, 0x10400, v2
		v_add_u32_e32 v2, 0x10400, v9
		ds_read_b128 v[136:139], v2
		ds_read_b128 v[152:155], v2 offset:128
		ds_read_b128 v[140:143], v2 offset:256
		ds_read_b128 v[144:147], v2 offset:384
		ds_read_b128 v[148:151], v2 offset:512
		ds_read_b128 v[28:31], v2 offset:640
		ds_read_b128 v[64:67], v2 offset:768
		ds_read_b128 v[68:71], v2 offset:896
		ds_read_b128 v[72:75], v0
		ds_read_b128 v[76:79], v0 offset:128
		ds_read_b128 v[80:83], v0 offset:256
		ds_read_b128 v[84:87], v0 offset:384
		ds_read_b128 v[88:91], v0 offset:512
		ds_read_b128 v[32:35], v0 offset:640
		ds_read_b128 v[36:39], v0 offset:768
		ds_read_b128 v[40:43], v0 offset:896
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], v[72:75], v[136:139], a[0:3]
		ds_read_b128 v[44:47], v0 offset:64
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[32:35], v[76:79], v[136:139], a[32:35]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 a[64:67], v[80:83], v[136:139], a[64:67]
		ds_read_b128 v[48:51], v0 offset:192
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 a[96:99], v[84:87], v[136:139], a[96:99]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 a[128:131], v[88:91], v[136:139], a[128:131]
		ds_read_b128 v[52:55], v0 offset:320
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 a[160:163], v[32:35], v[136:139], a[160:163]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 a[192:195], v[36:39], v[136:139], a[192:195]
		ds_read_b128 v[56:59], v0 offset:448
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 a[224:227], v[40:43], v[136:139], a[224:227]
		v_mfma_f32_16x16x32_f16 a[4:7], v[72:75], v[152:155], a[4:7]
		ds_read_b128 v[60:63], v0 offset:576
		v_mfma_f32_16x16x32_f16 a[36:39], v[76:79], v[152:155], a[36:39]
		v_mfma_f32_16x16x32_f16 a[68:71], v[80:83], v[152:155], a[68:71]
		ds_read_b128 v[92:95], v0 offset:704
		v_mfma_f32_16x16x32_f16 a[100:103], v[84:87], v[152:155], a[100:103]
		v_mfma_f32_16x16x32_f16 a[132:135], v[88:91], v[152:155], a[132:135]
		ds_read_b128 v[96:99], v0 offset:832
		v_mfma_f32_16x16x32_f16 a[164:167], v[32:35], v[152:155], a[164:167]
		v_mfma_f32_16x16x32_f16 a[196:199], v[36:39], v[152:155], a[196:199]
		ds_read_b128 v[100:103], v0 offset:960
		v_mfma_f32_16x16x32_f16 a[228:231], v[40:43], v[152:155], a[228:231]
		v_mfma_f32_16x16x32_f16 a[232:235], v[40:43], v[140:143], a[232:235]
		v_mfma_f32_16x16x32_f16 a[8:11], v[72:75], v[140:143], a[8:11]
		v_mfma_f32_16x16x32_f16 a[40:43], v[76:79], v[140:143], a[40:43]
		v_mfma_f32_16x16x32_f16 a[72:75], v[80:83], v[140:143], a[72:75]
		v_mfma_f32_16x16x32_f16 a[104:107], v[84:87], v[140:143], a[104:107]
		v_mfma_f32_16x16x32_f16 a[136:139], v[88:91], v[140:143], a[136:139]
		v_mfma_f32_16x16x32_f16 a[168:171], v[32:35], v[140:143], a[168:171]
		v_mfma_f32_16x16x32_f16 a[200:203], v[36:39], v[140:143], a[200:203]
		v_mfma_f32_16x16x32_f16 a[204:207], v[36:39], v[144:147], a[204:207]
		v_mfma_f32_16x16x32_f16 a[12:15], v[72:75], v[144:147], a[12:15]
		v_mfma_f32_16x16x32_f16 a[44:47], v[76:79], v[144:147], a[44:47]
		v_mfma_f32_16x16x32_f16 a[76:79], v[80:83], v[144:147], a[76:79]
		v_mfma_f32_16x16x32_f16 a[108:111], v[84:87], v[144:147], a[108:111]
		v_mfma_f32_16x16x32_f16 a[140:143], v[88:91], v[144:147], a[140:143]
		v_mfma_f32_16x16x32_f16 a[172:175], v[32:35], v[144:147], a[172:175]
		v_mfma_f32_16x16x32_f16 a[236:239], v[40:43], v[144:147], a[236:239]
		v_mfma_f32_16x16x32_f16 a[240:243], v[40:43], v[148:151], a[240:243]
		v_mfma_f32_16x16x32_f16 a[16:19], v[72:75], v[148:151], a[16:19]
		v_mfma_f32_16x16x32_f16 a[48:51], v[76:79], v[148:151], a[48:51]
		v_mfma_f32_16x16x32_f16 a[80:83], v[80:83], v[148:151], a[80:83]
		v_mfma_f32_16x16x32_f16 a[112:115], v[84:87], v[148:151], a[112:115]
		v_mfma_f32_16x16x32_f16 a[144:147], v[88:91], v[148:151], a[144:147]
		v_mfma_f32_16x16x32_f16 a[176:179], v[32:35], v[148:151], a[176:179]
		v_mfma_f32_16x16x32_f16 a[208:211], v[36:39], v[148:151], a[208:211]
		v_mfma_f32_16x16x32_f16 a[212:215], v[36:39], v[28:31], a[212:215]
		v_mfma_f32_16x16x32_f16 a[20:23], v[72:75], v[28:31], a[20:23]
		v_mfma_f32_16x16x32_f16 a[52:55], v[76:79], v[28:31], a[52:55]
		v_mfma_f32_16x16x32_f16 a[84:87], v[80:83], v[28:31], a[84:87]
		v_mfma_f32_16x16x32_f16 a[116:119], v[84:87], v[28:31], a[116:119]
		v_mfma_f32_16x16x32_f16 a[148:151], v[88:91], v[28:31], a[148:151]
		v_mfma_f32_16x16x32_f16 a[180:183], v[32:35], v[28:31], a[180:183]
		v_mfma_f32_16x16x32_f16 a[244:247], v[40:43], v[28:31], a[244:247]
		v_mfma_f32_16x16x32_f16 a[248:251], v[40:43], v[64:67], a[248:251]
		v_mfma_f32_16x16x32_f16 a[24:27], v[72:75], v[64:67], a[24:27]
		v_mfma_f32_16x16x32_f16 a[56:59], v[76:79], v[64:67], a[56:59]
		v_mfma_f32_16x16x32_f16 a[88:91], v[80:83], v[64:67], a[88:91]
		v_mfma_f32_16x16x32_f16 a[120:123], v[84:87], v[64:67], a[120:123]
		v_mfma_f32_16x16x32_f16 a[152:155], v[88:91], v[64:67], a[152:155]
		v_mfma_f32_16x16x32_f16 a[184:187], v[32:35], v[64:67], a[184:187]
		v_mfma_f32_16x16x32_f16 a[216:219], v[36:39], v[64:67], a[216:219]
		v_mfma_f32_16x16x32_f16 a[220:223], v[36:39], v[68:71], a[220:223]
		v_mfma_f32_16x16x32_f16 a[28:31], v[72:75], v[68:71], a[28:31]
		v_mfma_f32_16x16x32_f16 a[60:63], v[76:79], v[68:71], a[60:63]
		v_mfma_f32_16x16x32_f16 a[92:95], v[80:83], v[68:71], a[92:95]
		v_mfma_f32_16x16x32_f16 a[124:127], v[84:87], v[68:71], a[124:127]
		v_mfma_f32_16x16x32_f16 a[156:159], v[88:91], v[68:71], a[156:159]
		v_mfma_f32_16x16x32_f16 a[188:191], v[32:35], v[68:71], a[188:191]
		v_mfma_f32_16x16x32_f16 a[252:255], v[40:43], v[68:71], a[252:255]
		ds_read_b128 v[136:139], v2 offset:64
		ds_read_b128 v[152:155], v2 offset:192
		ds_read_b128 v[140:143], v2 offset:320
		ds_read_b128 v[144:147], v2 offset:448
		ds_read_b128 v[148:151], v2 offset:576
		ds_read_b128 v[28:31], v2 offset:704
		ds_read_b128 v[64:67], v2 offset:832
		ds_read_b128 v[132:135], v2 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], v[44:47], v[136:139], a[0:3]
		v_lshl_add_u32 v0, s9, 15, v12
		v_mfma_f32_16x16x32_f16 a[32:35], v[48:51], v[136:139], a[32:35]
		v_mfma_f32_16x16x32_f16 a[64:67], v[52:55], v[136:139], a[64:67]
		v_mfma_f32_16x16x32_f16 a[96:99], v[56:59], v[136:139], a[96:99]
		v_mfma_f32_16x16x32_f16 a[128:131], v[60:63], v[136:139], a[128:131]
		v_mfma_f32_16x16x32_f16 a[160:163], v[92:95], v[136:139], a[160:163]
		v_mfma_f32_16x16x32_f16 a[192:195], v[96:99], v[136:139], a[192:195]
		v_mfma_f32_16x16x32_f16 a[224:227], v[100:103], v[136:139], a[224:227]
		v_accvgpr_read_b32 v156, a0
		v_accvgpr_read_b32 v157, a1
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a2
		v_accvgpr_read_b32 v157, a3
		v_cvt_pk_f16_f32 v3, v156, v157
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 a[228:231], v[100:103], v[152:155], a[228:231]
		v_mfma_f32_16x16x32_f16 a[4:7], v[44:47], v[152:155], a[4:7]
		v_mfma_f32_16x16x32_f16 a[36:39], v[48:51], v[152:155], a[36:39]
		v_mfma_f32_16x16x32_f16 a[68:71], v[52:55], v[152:155], a[68:71]
		v_mfma_f32_16x16x32_f16 a[100:103], v[56:59], v[152:155], a[100:103]
		v_mfma_f32_16x16x32_f16 a[132:135], v[60:63], v[152:155], a[132:135]
		v_mfma_f32_16x16x32_f16 a[164:167], v[92:95], v[152:155], a[164:167]
		v_mfma_f32_16x16x32_f16 a[196:199], v[96:99], v[152:155], a[196:199]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 a[200:203], v[96:99], v[140:143], a[200:203]
		v_mfma_f32_16x16x32_f16 a[8:11], v[44:47], v[140:143], a[8:11]
		v_mfma_f32_16x16x32_f16 a[40:43], v[48:51], v[140:143], a[40:43]
		v_mfma_f32_16x16x32_f16 a[72:75], v[52:55], v[140:143], a[72:75]
		v_mfma_f32_16x16x32_f16 a[104:107], v[56:59], v[140:143], a[104:107]
		v_mfma_f32_16x16x32_f16 a[136:139], v[60:63], v[140:143], a[136:139]
		v_mfma_f32_16x16x32_f16 a[168:171], v[92:95], v[140:143], a[168:171]
		v_mfma_f32_16x16x32_f16 a[232:235], v[100:103], v[140:143], a[232:235]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 a[236:239], v[100:103], v[144:147], a[236:239]
		v_mfma_f32_16x16x32_f16 a[12:15], v[44:47], v[144:147], a[12:15]
		v_mfma_f32_16x16x32_f16 a[44:47], v[48:51], v[144:147], a[44:47]
		v_mfma_f32_16x16x32_f16 a[76:79], v[52:55], v[144:147], a[76:79]
		v_mfma_f32_16x16x32_f16 a[108:111], v[56:59], v[144:147], a[108:111]
		v_mfma_f32_16x16x32_f16 a[140:143], v[60:63], v[144:147], a[140:143]
		v_mfma_f32_16x16x32_f16 a[172:175], v[92:95], v[144:147], a[172:175]
		v_mfma_f32_16x16x32_f16 a[204:207], v[96:99], v[144:147], a[204:207]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 a[208:211], v[96:99], v[148:151], a[208:211]
		v_mfma_f32_16x16x32_f16 a[16:19], v[44:47], v[148:151], a[16:19]
		v_mfma_f32_16x16x32_f16 a[48:51], v[48:51], v[148:151], a[48:51]
		v_mfma_f32_16x16x32_f16 a[80:83], v[52:55], v[148:151], a[80:83]
		v_mfma_f32_16x16x32_f16 a[112:115], v[56:59], v[148:151], a[112:115]
		v_mfma_f32_16x16x32_f16 a[144:147], v[60:63], v[148:151], a[144:147]
		v_mfma_f32_16x16x32_f16 a[176:179], v[92:95], v[148:151], a[176:179]
		v_mfma_f32_16x16x32_f16 a[240:243], v[100:103], v[148:151], a[240:243]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 a[244:247], v[100:103], v[28:31], a[244:247]
		v_mfma_f32_16x16x32_f16 a[20:23], v[44:47], v[28:31], a[20:23]
		v_mfma_f32_16x16x32_f16 a[52:55], v[48:51], v[28:31], a[52:55]
		v_mfma_f32_16x16x32_f16 a[84:87], v[52:55], v[28:31], a[84:87]
		v_mfma_f32_16x16x32_f16 a[116:119], v[56:59], v[28:31], a[116:119]
		v_mfma_f32_16x16x32_f16 a[148:151], v[60:63], v[28:31], a[148:151]
		v_mfma_f32_16x16x32_f16 a[180:183], v[92:95], v[28:31], a[180:183]
		v_mfma_f32_16x16x32_f16 a[212:215], v[96:99], v[28:31], a[212:215]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 a[216:219], v[96:99], v[64:67], a[216:219]
		v_mfma_f32_16x16x32_f16 a[24:27], v[44:47], v[64:67], a[24:27]
		v_mfma_f32_16x16x32_f16 a[56:59], v[48:51], v[64:67], a[56:59]
		v_mfma_f32_16x16x32_f16 a[88:91], v[52:55], v[64:67], a[88:91]
		v_mfma_f32_16x16x32_f16 a[120:123], v[56:59], v[64:67], a[120:123]
		v_mfma_f32_16x16x32_f16 a[152:155], v[60:63], v[64:67], a[152:155]
		v_mfma_f32_16x16x32_f16 a[184:187], v[92:95], v[64:67], a[184:187]
		v_mfma_f32_16x16x32_f16 a[248:251], v[100:103], v[64:67], a[248:251]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 a[252:255], v[100:103], v[132:135], a[252:255]
		v_mfma_f32_16x16x32_f16 a[28:31], v[44:47], v[132:135], a[28:31]
		v_mfma_f32_16x16x32_f16 a[60:63], v[48:51], v[132:135], a[60:63]
		v_mfma_f32_16x16x32_f16 a[92:95], v[52:55], v[132:135], a[92:95]
		v_mfma_f32_16x16x32_f16 a[124:127], v[56:59], v[132:135], a[124:127]
		v_mfma_f32_16x16x32_f16 a[156:159], v[60:63], v[132:135], a[156:159]
		v_mfma_f32_16x16x32_f16 a[188:191], v[92:95], v[132:135], a[188:191]
		v_mfma_f32_16x16x32_f16 a[220:223], v[96:99], v[132:135], a[220:223]
	; Transposed MFMA lanes make each store one contiguous M span.
		s_mov_b32 s23, s15
		s_mov_b32 s4, 0x4000
		v_lshrrev_b32_e32 v1, 3, v12
		v_and_b32_e32 v0, 15, v1
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshrrev_b32_e32 v1, 4, v1
		v_lshl_add_u32 v0, v1, 19, v0
		s_and_b32 s5, s9, 1
		s_lshl_b32 s5, s5, 8
		s_lshr_b32 s6, s9, 1
		s_lshl_b32 s6, s6, 21
		s_add_i32 s5, s5, s6
		v_add_u32_e32 v0, s5, v0
		v_accvgpr_read_b32 v156, a0
		v_accvgpr_read_b32 v157, a4
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a8
		v_accvgpr_read_b32 v157, a12
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a16
		v_accvgpr_read_b32 v157, a20
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a24
		v_accvgpr_read_b32 v157, a28
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a32
		v_accvgpr_read_b32 v157, a36
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a40
		v_accvgpr_read_b32 v157, a44
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a48
		v_accvgpr_read_b32 v157, a52
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a56
		v_accvgpr_read_b32 v157, a60
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a64
		v_accvgpr_read_b32 v157, a68
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a72
		v_accvgpr_read_b32 v157, a76
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a80
		v_accvgpr_read_b32 v157, a84
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a88
		v_accvgpr_read_b32 v157, a92
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a96
		v_accvgpr_read_b32 v157, a100
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a104
		v_accvgpr_read_b32 v157, a108
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a112
		v_accvgpr_read_b32 v157, a116
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a120
		v_accvgpr_read_b32 v157, a124
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a128
		v_accvgpr_read_b32 v157, a132
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a136
		v_accvgpr_read_b32 v157, a140
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a144
		v_accvgpr_read_b32 v157, a148
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a152
		v_accvgpr_read_b32 v157, a156
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a160
		v_accvgpr_read_b32 v157, a164
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a168
		v_accvgpr_read_b32 v157, a172
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a176
		v_accvgpr_read_b32 v157, a180
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a184
		v_accvgpr_read_b32 v157, a188
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a192
		v_accvgpr_read_b32 v157, a196
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a200
		v_accvgpr_read_b32 v157, a204
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a208
		v_accvgpr_read_b32 v157, a212
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a216
		v_accvgpr_read_b32 v157, a220
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a224
		v_accvgpr_read_b32 v157, a228
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a232
		v_accvgpr_read_b32 v157, a236
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a240
		v_accvgpr_read_b32 v157, a244
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a248
		v_accvgpr_read_b32 v157, a252
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a1
		v_accvgpr_read_b32 v157, a5
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a9
		v_accvgpr_read_b32 v157, a13
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a17
		v_accvgpr_read_b32 v157, a21
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a25
		v_accvgpr_read_b32 v157, a29
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a33
		v_accvgpr_read_b32 v157, a37
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a41
		v_accvgpr_read_b32 v157, a45
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a49
		v_accvgpr_read_b32 v157, a53
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a57
		v_accvgpr_read_b32 v157, a61
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a65
		v_accvgpr_read_b32 v157, a69
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a73
		v_accvgpr_read_b32 v157, a77
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a81
		v_accvgpr_read_b32 v157, a85
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a89
		v_accvgpr_read_b32 v157, a93
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a97
		v_accvgpr_read_b32 v157, a101
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a105
		v_accvgpr_read_b32 v157, a109
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a113
		v_accvgpr_read_b32 v157, a117
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a121
		v_accvgpr_read_b32 v157, a125
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a129
		v_accvgpr_read_b32 v157, a133
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a137
		v_accvgpr_read_b32 v157, a141
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a145
		v_accvgpr_read_b32 v157, a149
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a153
		v_accvgpr_read_b32 v157, a157
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a161
		v_accvgpr_read_b32 v157, a165
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a169
		v_accvgpr_read_b32 v157, a173
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a177
		v_accvgpr_read_b32 v157, a181
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a185
		v_accvgpr_read_b32 v157, a189
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a193
		v_accvgpr_read_b32 v157, a197
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a201
		v_accvgpr_read_b32 v157, a205
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a209
		v_accvgpr_read_b32 v157, a213
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a217
		v_accvgpr_read_b32 v157, a221
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a225
		v_accvgpr_read_b32 v157, a229
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a233
		v_accvgpr_read_b32 v157, a237
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a241
		v_accvgpr_read_b32 v157, a245
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a249
		v_accvgpr_read_b32 v157, a253
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a2
		v_accvgpr_read_b32 v157, a6
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a10
		v_accvgpr_read_b32 v157, a14
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a18
		v_accvgpr_read_b32 v157, a22
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a26
		v_accvgpr_read_b32 v157, a30
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a34
		v_accvgpr_read_b32 v157, a38
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a42
		v_accvgpr_read_b32 v157, a46
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a50
		v_accvgpr_read_b32 v157, a54
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a58
		v_accvgpr_read_b32 v157, a62
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a66
		v_accvgpr_read_b32 v157, a70
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a74
		v_accvgpr_read_b32 v157, a78
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a82
		v_accvgpr_read_b32 v157, a86
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a90
		v_accvgpr_read_b32 v157, a94
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a98
		v_accvgpr_read_b32 v157, a102
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a106
		v_accvgpr_read_b32 v157, a110
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a114
		v_accvgpr_read_b32 v157, a118
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a122
		v_accvgpr_read_b32 v157, a126
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a130
		v_accvgpr_read_b32 v157, a134
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a138
		v_accvgpr_read_b32 v157, a142
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a146
		v_accvgpr_read_b32 v157, a150
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a154
		v_accvgpr_read_b32 v157, a158
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a162
		v_accvgpr_read_b32 v157, a166
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a170
		v_accvgpr_read_b32 v157, a174
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a178
		v_accvgpr_read_b32 v157, a182
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a186
		v_accvgpr_read_b32 v157, a190
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a194
		v_accvgpr_read_b32 v157, a198
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a202
		v_accvgpr_read_b32 v157, a206
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a210
		v_accvgpr_read_b32 v157, a214
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a218
		v_accvgpr_read_b32 v157, a222
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a226
		v_accvgpr_read_b32 v157, a230
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a234
		v_accvgpr_read_b32 v157, a238
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a242
		v_accvgpr_read_b32 v157, a246
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a250
		v_accvgpr_read_b32 v157, a254
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a3
		v_accvgpr_read_b32 v157, a7
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a11
		v_accvgpr_read_b32 v157, a15
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a19
		v_accvgpr_read_b32 v157, a23
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a27
		v_accvgpr_read_b32 v157, a31
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a35
		v_accvgpr_read_b32 v157, a39
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a43
		v_accvgpr_read_b32 v157, a47
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a51
		v_accvgpr_read_b32 v157, a55
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a59
		v_accvgpr_read_b32 v157, a63
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a67
		v_accvgpr_read_b32 v157, a71
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a75
		v_accvgpr_read_b32 v157, a79
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a83
		v_accvgpr_read_b32 v157, a87
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a91
		v_accvgpr_read_b32 v157, a95
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a99
		v_accvgpr_read_b32 v157, a103
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a107
		v_accvgpr_read_b32 v157, a111
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a115
		v_accvgpr_read_b32 v157, a119
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a123
		v_accvgpr_read_b32 v157, a127
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a131
		v_accvgpr_read_b32 v157, a135
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a139
		v_accvgpr_read_b32 v157, a143
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a147
		v_accvgpr_read_b32 v157, a151
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a155
		v_accvgpr_read_b32 v157, a159
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a163
		v_accvgpr_read_b32 v157, a167
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a171
		v_accvgpr_read_b32 v157, a175
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a179
		v_accvgpr_read_b32 v157, a183
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a187
		v_accvgpr_read_b32 v157, a191
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a195
		v_accvgpr_read_b32 v157, a199
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a203
		v_accvgpr_read_b32 v157, a207
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a211
		v_accvgpr_read_b32 v157, a215
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a219
		v_accvgpr_read_b32 v157, a223
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
		s_add_u32 s20, s20, s4
		s_addc_u32 s21, s21, 0
		v_accvgpr_read_b32 v156, a227
		v_accvgpr_read_b32 v157, a231
		v_cvt_pk_f16_f32 v2, v156, v157
		v_accvgpr_read_b32 v156, a235
		v_accvgpr_read_b32 v157, a239
		v_cvt_pk_f16_f32 v3, v156, v157
		v_accvgpr_read_b32 v156, a243
		v_accvgpr_read_b32 v157, a247
		v_cvt_pk_f16_f32 v4, v156, v157
		v_accvgpr_read_b32 v156, a251
		v_accvgpr_read_b32 v157, a255
		v_cvt_pk_f16_f32 v5, v156, v157
		buffer_store_dwordx4 v[2:5], v0, s[20:23], 0 offen nt
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
		.amdhsa_next_free_vgpr 420
		.amdhsa_next_free_sgpr 31
		.amdhsa_accum_offset 164
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 164
	.set .Lwmma_f16_matmul_tiled.num_agpr, 256
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 31
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
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     31
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     420
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 72
    wave.regalloc.agpr.dwords: 284
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
