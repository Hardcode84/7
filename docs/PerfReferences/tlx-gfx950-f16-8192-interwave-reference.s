	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 5
	.text
	.globl	a16w16_8wave                    ; -- Begin function a16w16_8wave
	.p2align	8
	.type	a16w16_8wave,@function
a16w16_8wave:                           ; @a16w16_8wave
.Lfunc_begin0:
	.cfi_sections .debug_frame
	.cfi_startproc
; %bb.14:
	.file	1 "/home/ibutygin/tlx-950/triton/third_party/tlx/tutorials/gfx9_gemm/inter_wave/a16w16" "matmul_kernel.py"
	.loc	1 49 0 prologue_end             ; matmul_kernel.py:49:0
	s_load_dwordx8 s[8:15], s[4:5], 0x0
	s_waitcnt lgkmcnt(0)
	s_branch .LBB0_0
	.loc	1 0 0 is_stmt 0                 ; :0:0
.Ltmp0:
	.p2align	8
; %bb.15:
.LBB0_0:
	.cfi_escape 0x0f, 0x04, 0x30, 0x36, 0xe9, 0x02 ; CFA is 0 in private_wave aspace
	.cfi_undefined 16
	s_mov_b64 s[24:25], s[10:11]
	s_load_dwordx2 s[28:29], s[4:5], 0x20
	s_load_dwordx2 s[30:31], s[4:5], 0x2c
	s_load_dword s20, s[4:5], 0x34
	v_and_b32_e32 v138, 0x3ff, v0
.Ltmp1:
	.loc	1 327 21 is_stmt 1              ; matmul_kernel.py:327:21
	s_nop 0
	v_readfirstlane_b32 s0, v138
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	s_bfe_u32 s21, s0, 0x30006
	.loc	1 86 16                         ; matmul_kernel.py:86:16
	s_ashr_i32 s0, s16, 31
	s_lshr_b32 s0, s0, 22
	s_add_i32 s0, s16, s0
	s_ashr_i32 s1, s0, 10
.Ltmp2:
	.file	2 "/home/ibutygin/tlx-950/triton/python/triton/language" "standard.py"
	.loc	2 43 13                         ; standard.py:43:13 @[ matmul_kernel.py:90:17 ]
	s_waitcnt lgkmcnt(0)
	s_add_i32 s2, s28, 0xff
	.loc	2 43 12 is_stmt 0               ; standard.py:43:12 @[ matmul_kernel.py:90:17 ]
	s_ashr_i32 s3, s2, 31
	s_lshr_b32 s3, s3, 24
	s_add_i32 s2, s2, s3
	s_ashr_i32 s2, s2, 8
.Ltmp3:
	.loc	2 43 13                         ; standard.py:43:13 @[ matmul_kernel.py:91:17 ]
	s_add_i32 s3, s29, 0xff
	.loc	2 43 12                         ; standard.py:43:12 @[ matmul_kernel.py:91:17 ]
	s_ashr_i32 s6, s3, 31
	s_lshr_b32 s6, s6, 24
	s_add_i32 s3, s3, s6
	s_ashr_i32 s3, s3, 8
.Ltmp4:
	.loc	1 87 11 is_stmt 1               ; matmul_kernel.py:87:11
	s_and_b32 s0, s0, 0xfffffc00
	s_sub_i32 s0, s16, s0
	.loc	1 99 21                         ; matmul_kernel.py:99:21
	s_bfe_u32 s6, s0, 0x3001c
	s_add_i32 s6, s0, s6
	.loc	1 109 28                        ; matmul_kernel.py:109:28
	s_lshl_b32 s3, s3, 2
	.loc	1 110 20                        ; matmul_kernel.py:110:20
	s_abs_i32 s7, s3
	v_cvt_f32_u32_e32 v1, s7
	.loc	1 99 21                         ; matmul_kernel.py:99:21
	s_sext_i32_i16 s6, s6
	s_ashr_i32 s6, s6, 3
	.loc	1 101 19                        ; matmul_kernel.py:101:19
	s_lshl_b32 s0, s0, 7
	.loc	1 110 20                        ; matmul_kernel.py:110:20
	v_rcp_f32_e32 v1, v1
	.loc	1 101 19                        ; matmul_kernel.py:101:19
	s_mulk_i32 s6, 0xfc01
	s_add_i32 s6, s6, s0
	.loc	1 110 20                        ; matmul_kernel.py:110:20
	s_xor_b32 s0, s6, s3
	v_mul_f32_e32 v1, 0x4f7ffffe, v1
	v_cvt_u32_f32_e32 v1, v1
	s_ashr_i32 s0, s0, 31
	s_abs_i32 s10, s6
	s_sub_i32 s11, 0, s7
	v_readfirstlane_b32 s14, v1
	s_mul_i32 s11, s11, s14
	s_mul_hi_u32 s11, s14, s11
	s_add_i32 s14, s14, s11
	s_mul_hi_u32 s11, s10, s14
	s_mul_i32 s14, s11, s7
	s_sub_i32 s10, s10, s14
	s_add_i32 s14, s11, 1
	s_sub_i32 s15, s10, s7
	s_cmp_ge_u32 s10, s7
	s_cselect_b32 s11, s14, s11
	s_cselect_b32 s10, s15, s10
	s_add_i32 s14, s11, 1
	s_cmp_ge_u32 s10, s7
	s_cselect_b32 s7, s14, s11
	s_xor_b32 s7, s7, s0
	s_sub_i32 s0, s7, s0
	.loc	1 111 23                        ; matmul_kernel.py:111:23
	s_lshl_b32 s7, s0, 2
	.loc	1 112 28                        ; matmul_kernel.py:112:28
	s_sub_i32 s2, s2, s7
	.loc	1 112 24 is_stmt 0              ; matmul_kernel.py:112:24
	s_min_i32 s2, s2, 4
	.loc	1 114 17 is_stmt 1              ; matmul_kernel.py:114:17
	s_abs_i32 s10, s2
	v_cvt_f32_u32_e32 v1, s10
	.loc	1 88 16                         ; matmul_kernel.py:88:16
	s_mul_i32 s22, s30, s1
	.loc	1 114 17                        ; matmul_kernel.py:114:17
	v_rcp_f32_e32 v1, v1
	.loc	1 113 31                        ; matmul_kernel.py:113:31
	s_mul_i32 s0, s0, s3
	s_sub_i32 s0, s6, s0
	.loc	1 114 17                        ; matmul_kernel.py:114:17
	s_xor_b32 s1, s0, s2
	v_mul_f32_e32 v1, 0x4f7ffffe, v1
	v_cvt_u32_f32_e32 v1, v1
	s_ashr_i32 s1, s1, 31
	s_abs_i32 s3, s0
	s_sub_i32 s6, 0, s10
	v_readfirstlane_b32 s11, v1
	s_mul_i32 s6, s6, s11
	s_mul_hi_u32 s6, s11, s6
	s_add_i32 s11, s11, s6
	s_mul_hi_u32 s6, s3, s11
	s_mul_i32 s11, s6, s10
	s_sub_i32 s3, s3, s11
	s_add_i32 s11, s6, 1
	s_sub_i32 s14, s3, s10
	s_cmp_ge_u32 s3, s10
	s_cselect_b32 s6, s11, s6
	s_cselect_b32 s3, s14, s3
	s_add_i32 s11, s6, 1
	s_cmp_ge_u32 s3, s10
	s_cselect_b32 s3, s11, s6
	s_xor_b32 s3, s3, s1
	s_sub_i32 s1, s3, s1
	.loc	1 113 31                        ; matmul_kernel.py:113:31
	s_mul_i32 s2, s1, s2
	s_sub_i32 s0, s0, s2
	.loc	1 113 17 is_stmt 0              ; matmul_kernel.py:113:17
	s_add_i32 s0, s0, s7
	.loc	1 148 15 is_stmt 1              ; matmul_kernel.py:148:15
	s_lshl_b32 s34, s0, 8
	.loc	1 148 33 is_stmt 0              ; matmul_kernel.py:148:33
	v_lshlrev_b32_e32 v1, 1, v138
	v_and_b32_e32 v1, 0x70, v1
	v_or_b32_e32 v1, s21, v1
	v_or_b32_e32 v2, 8, v1
	.loc	1 148 15                        ; matmul_kernel.py:148:15
	v_or_b32_e32 v3, s34, v1
	v_or_b32_e32 v4, s34, v2
	.loc	1 149 15 is_stmt 1              ; matmul_kernel.py:149:15
	s_lshl_b32 s33, s1, 8
	v_or_b32_e32 v1, s33, v1
	v_or_b32_e32 v2, s33, v2
	.loc	1 150 14                        ; matmul_kernel.py:150:14
	v_and_b32_e32 v139, 7, v0
	v_lshlrev_b32_e32 v128, 3, v139
	.loc	1 152 17                        ; matmul_kernel.py:152:17
	v_mad_u64_u32 v[130:131], s[0:1], v3, s31, v[128:129]
	v_mad_u64_u32 v[132:133], s[0:1], v4, s31, v[128:129]
	.loc	1 153 29                        ; matmul_kernel.py:153:29
	s_lshl_b32 s0, s31, 7
	.loc	1 153 17 is_stmt 0              ; matmul_kernel.py:153:17
	s_nop 0
	v_add_u32_e32 v140, s0, v130
	v_add_u32_e32 v141, s0, v132
	.loc	1 154 18 is_stmt 1              ; matmul_kernel.py:154:18
	v_mad_u64_u32 v[134:135], s[0:1], v1, s20, v[128:129]
	v_mad_u64_u32 v[136:137], s[0:1], v2, s20, v[128:129]
	.loc	1 155 32                        ; matmul_kernel.py:155:32
	s_lshl_b32 s36, s20, 7
	.loc	1 155 19 is_stmt 0              ; matmul_kernel.py:155:19
	v_add_u32_e32 v135, s36, v134
	v_add_u32_e32 v137, s36, v136
	.loc	1 158 19 is_stmt 1              ; matmul_kernel.py:158:19
	v_add_u32_e32 v142, 64, v130
	v_add_u32_e32 v143, 64, v132
	.loc	1 159 19                        ; matmul_kernel.py:159:19
	v_add_u32_e32 v144, 64, v140
	v_add_u32_e32 v145, 64, v141
	.loc	1 160 20                        ; matmul_kernel.py:160:20
	v_add_u32_e32 v146, 64, v134
	v_add_u32_e32 v147, 64, v136
	.loc	1 161 21                        ; matmul_kernel.py:161:21
	v_add_u32_e32 v148, 64, v135
	v_add_u32_e32 v149, 64, v137
	.loc	1 183 5                         ; matmul_kernel.py:183:5
	s_mov_b32 s27, 0x27000
	s_mov_b32 s26, 0x7ffffffe
	s_and_b32 s25, s25, 0xffff
	s_mul_i32 s45, s21, 0x420
	s_add_i32 s6, s45, 0x107c0
	v_add_lshl_u32 v1, v134, s22, 1
	s_mov_b32 m0, s6
	s_nop 0
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	s_add_i32 s7, s6, 0x2100
	v_add_lshl_u32 v1, v136, s22, 1
	s_mov_b32 m0, s7
	s_nop 0
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	; asyncmark
	.loc	1 185 5                         ; matmul_kernel.py:185:5
	s_and_b32 s9, s9, 0xffff
	s_mov_b32 s10, s26
	s_mov_b32 s11, s27
	s_add_i32 s14, s6, 0xfffef840
	v_add_lshl_u32 v1, v130, s22, 1
	s_mov_b32 m0, s14
	s_nop 0
	buffer_load_dwordx4 v1, s[8:11], 0 offen lds
	s_add_i32 s15, s6, 0xffff1940
	v_add_lshl_u32 v1, v132, s22, 1
	s_mov_b32 m0, s15
	s_nop 0
	buffer_load_dwordx4 v1, s[8:11], 0 offen lds
	; asyncmark
	.loc	1 187 5                         ; matmul_kernel.py:187:5
	s_add_i32 s16, s6, 0xffff7c20
	v_add_lshl_u32 v1, v140, s22, 1
	s_mov_b32 m0, s16
	s_nop 0
	buffer_load_dwordx4 v1, s[8:11], 0 offen lds
	s_add_i32 s17, s6, 0xffff9d20
	v_add_lshl_u32 v1, v141, s22, 1
	s_mov_b32 m0, s17
	s_nop 0
	buffer_load_dwordx4 v1, s[8:11], 0 offen lds
	; asyncmark
	.loc	1 189 5                         ; matmul_kernel.py:189:5
	s_add_i32 s18, s45, 0x18ba0
	v_add_lshl_u32 v1, v135, s22, 1
	s_mov_b32 m0, s18
	s_nop 0
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	s_add_i32 s19, s45, 0x1aca0
	v_add_lshl_u32 v1, v137, s22, 1
	s_mov_b32 m0, s19
	s_nop 0
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	; asyncmark
	.loc	1 192 5                         ; matmul_kernel.py:192:5
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_add_i32 s38, s45, 0x149c0
	v_add_lshl_u32 v1, v146, s22, 1
	s_mov_b32 m0, s38
	s_nop 0
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	s_add_i32 s39, s45, 0x16ac0
	v_add_lshl_u32 v1, v147, s22, 1
	s_mov_b32 m0, s39
	s_nop 0
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	; asyncmark
	.loc	1 194 5                         ; matmul_kernel.py:194:5
	s_add_i32 s40, s45, 0x4200
	v_add_lshl_u32 v1, v142, s22, 1
	s_mov_b32 m0, s40
	s_nop 0
	buffer_load_dwordx4 v1, s[8:11], 0 offen lds
	s_add_i32 s41, s45, 0x6300
	v_add_lshl_u32 v1, v143, s22, 1
	s_mov_b32 m0, s41
	s_nop 0
	buffer_load_dwordx4 v1, s[8:11], 0 offen lds
	; asyncmark
	.loc	1 196 5                         ; matmul_kernel.py:196:5
	s_add_i32 s42, s45, 0xc5e0
	v_add_lshl_u32 v1, v144, s22, 1
	s_mov_b32 m0, s42
	s_nop 0
	buffer_load_dwordx4 v1, s[8:11], 0 offen lds
	s_add_i32 s43, s45, 0xe6e0
	v_add_lshl_u32 v1, v145, s22, 1
	s_mov_b32 m0, s43
	s_nop 0
	buffer_load_dwordx4 v1, s[8:11], 0 offen lds
	; asyncmark
	.loc	1 198 5                         ; matmul_kernel.py:198:5
	s_add_i32 s44, s45, 0x1cda0
	v_add_lshl_u32 v1, v148, s22, 1
	s_mov_b32 m0, s44
	s_nop 0
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	s_add_i32 s45, s45, 0x1eea0
	v_add_lshl_u32 v1, v149, s22, 1
	s_mov_b32 m0, s45
	s_nop 0
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	s_movk_i32 s0, 0xff
	.loc	1 148 33                        ; matmul_kernel.py:148:33
	s_lshl_b32 s37, s21, 6
	v_and_b32_e32 v129, 15, v0
	s_movk_i32 s1, 0x100
	s_and_b32 s35, s37, 0x100
	; asyncmark
	; wait_asyncmark(6)
	.loc	1 204 5                         ; matmul_kernel.py:204:5
	s_waitcnt vmcnt(12) lgkmcnt(0)
	s_barrier
	.loc	1 205 14                        ; matmul_kernel.py:205:14
	v_lshlrev_b32_e32 v1, 10, v129
	s_and_b32 s23, s37, 0xc0
	s_lshl_b32 s2, s23, 1
	v_and_b32_e32 v2, 48, v0
	v_lshlrev_b32_e32 v3, 5, v129
	v_or_b32_e32 v0, v1, v2
	v_add3_u32 v0, v0, v3, s2
	v_add_u32_e32 v4, 0x107c0, v0
	ds_read_b128 v[186:189], v4
	ds_read_b128 v[190:193], v4 offset:64
	ds_read_b128 v[174:177], v4 offset:512
	ds_read_b128 v[170:173], v4 offset:576
	.loc	1 206 13                        ; matmul_kernel.py:206:13
	s_lshr_b32 s2, s35, 1
	v_or3_b32 v1, v2, s2, v1
	v_add3_u32 v131, v1, v3, 0
	ds_read_b128 v[194:197], v131
	ds_read_b128 v[198:201], v131 offset:64
	ds_read_b128 v[178:181], v131 offset:256
	ds_read_b128 v[182:185], v131 offset:320
	ds_read_b128 v[162:165], v131 offset:512
	ds_read_b128 v[166:169], v131 offset:576
	ds_read_b128 v[154:157], v131 offset:768
	ds_read_b128 v[158:161], v131 offset:832
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_waitcnt lgkmcnt(0)
	s_barrier
	v_cmp_gt_u32_e32 vcc, s1, v138
	v_cmp_lt_u32_e64 s[0:1], s0, v138
	s_and_saveexec_b64 s[2:3], s[0:1]
	s_cbranch_execz .LBB0_2
; %bb.1:
	s_barrier
.LBB0_2:
	.loc	1 0 5 is_stmt 0                 ; matmul_kernel.py:0:5
	s_or_b64 exec, exec, s[2:3]
	.loc	1 180 15 is_stmt 1              ; matmul_kernel.py:180:15
	s_ashr_i32 s0, s30, 31
	s_lshr_b32 s0, s0, 25
	s_add_i32 s0, s30, s0
	s_ashr_i32 s2, s0, 7
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_cmpk_lt_i32 s30, 0x100
	v_add_u32_e32 v133, 0, v0
	s_cbranch_scc1 .LBB0_9
; %bb.3:                                ; %.lr.ph
	.loc	1 209 26 is_stmt 0              ; matmul_kernel.py:209:26
	s_lshl1_add_u32 s0, s2, -2
	s_mov_b32 s1, 0
	v_mov_b32_e32 v20, 0
	v_add_u32_e32 v150, 0x18ba0, v133
	s_mov_b32 s10, s26
	s_mov_b32 s11, s27
	v_add_u32_e32 v151, 0x149c0, v133
	v_add_u32_e32 v152, 0x1cda0, v133
	v_add_u32_e32 v153, 0x107c0, v133
	v_mov_b32_e32 v21, v20
	v_mov_b32_e32 v22, v20
	v_mov_b32_e32 v23, v20
	v_mov_b32_e32 v28, v20
	v_mov_b32_e32 v29, v20
	v_mov_b32_e32 v30, v20
	v_mov_b32_e32 v31, v20
	v_mov_b32_e32 v24, v20
	v_mov_b32_e32 v25, v20
	v_mov_b32_e32 v26, v20
	v_mov_b32_e32 v27, v20
	v_mov_b32_e32 v16, v20
	v_mov_b32_e32 v17, v20
	v_mov_b32_e32 v18, v20
	v_mov_b32_e32 v19, v20
	v_mov_b32_e32 v12, v20
	v_mov_b32_e32 v13, v20
	v_mov_b32_e32 v14, v20
	v_mov_b32_e32 v15, v20
	v_mov_b32_e32 v8, v20
	v_mov_b32_e32 v9, v20
	v_mov_b32_e32 v10, v20
	v_mov_b32_e32 v11, v20
	v_mov_b32_e32 v4, v20
	v_mov_b32_e32 v5, v20
	v_mov_b32_e32 v6, v20
	v_mov_b32_e32 v7, v20
	v_mov_b32_e32 v0, v20
	v_mov_b32_e32 v1, v20
	v_mov_b32_e32 v2, v20
	v_mov_b32_e32 v3, v20
	v_mov_b32_e32 v60, v20
	v_mov_b32_e32 v61, v20
	v_mov_b32_e32 v62, v20
	v_mov_b32_e32 v63, v20
	v_mov_b32_e32 v56, v20
	v_mov_b32_e32 v57, v20
	v_mov_b32_e32 v58, v20
	v_mov_b32_e32 v59, v20
	v_mov_b32_e32 v52, v20
	v_mov_b32_e32 v53, v20
	v_mov_b32_e32 v54, v20
	v_mov_b32_e32 v55, v20
	v_mov_b32_e32 v48, v20
	v_mov_b32_e32 v49, v20
	v_mov_b32_e32 v50, v20
	v_mov_b32_e32 v51, v20
	v_mov_b32_e32 v44, v20
	v_mov_b32_e32 v45, v20
	v_mov_b32_e32 v46, v20
	v_mov_b32_e32 v47, v20
	v_mov_b32_e32 v40, v20
	v_mov_b32_e32 v41, v20
	v_mov_b32_e32 v42, v20
	v_mov_b32_e32 v43, v20
	v_mov_b32_e32 v36, v20
	v_mov_b32_e32 v37, v20
	v_mov_b32_e32 v38, v20
	v_mov_b32_e32 v39, v20
	v_mov_b32_e32 v32, v20
	v_mov_b32_e32 v33, v20
	v_mov_b32_e32 v34, v20
	v_mov_b32_e32 v35, v20
	v_mov_b32_e32 v92, v20
	v_mov_b32_e32 v93, v20
	v_mov_b32_e32 v94, v20
	v_mov_b32_e32 v95, v20
	v_mov_b32_e32 v88, v20
	v_mov_b32_e32 v89, v20
	v_mov_b32_e32 v90, v20
	v_mov_b32_e32 v91, v20
	v_mov_b32_e32 v84, v20
	v_mov_b32_e32 v85, v20
	v_mov_b32_e32 v86, v20
	v_mov_b32_e32 v87, v20
	v_mov_b32_e32 v80, v20
	v_mov_b32_e32 v81, v20
	v_mov_b32_e32 v82, v20
	v_mov_b32_e32 v83, v20
	v_mov_b32_e32 v76, v20
	v_mov_b32_e32 v77, v20
	v_mov_b32_e32 v78, v20
	v_mov_b32_e32 v79, v20
	v_mov_b32_e32 v72, v20
	v_mov_b32_e32 v73, v20
	v_mov_b32_e32 v74, v20
	v_mov_b32_e32 v75, v20
	v_mov_b32_e32 v68, v20
	v_mov_b32_e32 v69, v20
	v_mov_b32_e32 v70, v20
	v_mov_b32_e32 v71, v20
	v_mov_b32_e32 v64, v20
	v_mov_b32_e32 v65, v20
	v_mov_b32_e32 v66, v20
	v_mov_b32_e32 v67, v20
	v_mov_b32_e32 v124, v20
	v_mov_b32_e32 v125, v20
	v_mov_b32_e32 v126, v20
	v_mov_b32_e32 v127, v20
	v_mov_b32_e32 v120, v20
	v_mov_b32_e32 v121, v20
	v_mov_b32_e32 v122, v20
	v_mov_b32_e32 v123, v20
	v_mov_b32_e32 v116, v20
	v_mov_b32_e32 v117, v20
	v_mov_b32_e32 v118, v20
	v_mov_b32_e32 v119, v20
	v_mov_b32_e32 v112, v20
	v_mov_b32_e32 v113, v20
	v_mov_b32_e32 v114, v20
	v_mov_b32_e32 v115, v20
	v_mov_b32_e32 v108, v20
	v_mov_b32_e32 v109, v20
	v_mov_b32_e32 v110, v20
	v_mov_b32_e32 v111, v20
	v_mov_b32_e32 v104, v20
	v_mov_b32_e32 v105, v20
	v_mov_b32_e32 v106, v20
	v_mov_b32_e32 v107, v20
	v_mov_b32_e32 v100, v20
	v_mov_b32_e32 v101, v20
	v_mov_b32_e32 v102, v20
	v_mov_b32_e32 v103, v20
	v_mov_b32_e32 v96, v20
	v_mov_b32_e32 v97, v20
	v_mov_b32_e32 v98, v20
	v_mov_b32_e32 v99, v20
	s_mov_b32 s3, s22
.LBB0_4:                                ; =>This Inner Loop Header: Depth=1
	.loc	1 0 0                           ; matmul_kernel.py:0
	s_addk_i32 s3, 0x80
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	; sched_barrier mask(0x00000000)
	; wait_asyncmark(5)
	.loc	1 211 9 is_stmt 1               ; matmul_kernel.py:211:9
	s_waitcnt vmcnt(10) lgkmcnt(0)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 213 22                        ; matmul_kernel.py:213:22
	v_mfma_f32_16x16x32_f16 v[124:127], v[186:189], v[194:197], v[124:127]
	v_mfma_f32_16x16x32_f16 v[124:127], v[190:193], v[198:201], v[124:127]
	v_mfma_f32_16x16x32_f16 v[120:123], v[174:177], v[194:197], v[120:123]
	v_mfma_f32_16x16x32_f16 v[120:123], v[170:173], v[198:201], v[120:123]
	v_mfma_f32_16x16x32_f16 v[116:119], v[186:189], v[178:181], v[116:119]
	v_mfma_f32_16x16x32_f16 v[116:119], v[190:193], v[182:185], v[116:119]
	v_mfma_f32_16x16x32_f16 v[112:115], v[174:177], v[178:181], v[112:115]
	v_mfma_f32_16x16x32_f16 v[112:115], v[170:173], v[182:185], v[112:115]
	v_mfma_f32_16x16x32_f16 v[108:111], v[186:189], v[162:165], v[108:111]
	v_mfma_f32_16x16x32_f16 v[108:111], v[190:193], v[166:169], v[108:111]
	v_mfma_f32_16x16x32_f16 v[104:107], v[174:177], v[162:165], v[104:107]
	v_mfma_f32_16x16x32_f16 v[104:107], v[170:173], v[166:169], v[104:107]
	v_mfma_f32_16x16x32_f16 v[100:103], v[186:189], v[154:157], v[100:103]
	v_mfma_f32_16x16x32_f16 v[100:103], v[190:193], v[158:161], v[100:103]
	v_mfma_f32_16x16x32_f16 v[96:99], v[174:177], v[154:157], v[96:99]
	v_mfma_f32_16x16x32_f16 v[96:99], v[170:173], v[158:161], v[96:99]
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 1
	; sched_barrier mask(0x00000000)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 216 13                        ; matmul_kernel.py:216:13
	s_mov_b32 m0, s6
	v_add_lshl_u32 v202, s3, v134, 1
	buffer_load_dwordx4 v202, s[24:27], 0 offen lds
	v_add_lshl_u32 v202, s3, v136, 1
	s_mov_b32 m0, s7
	s_nop 0
	buffer_load_dwordx4 v202, s[24:27], 0 offen lds
	.loc	1 215 21                        ; matmul_kernel.py:215:21
	ds_read_b128 v[202:205], v131 offset:33760
	ds_read_b128 v[206:209], v131 offset:33824
	ds_read_b128 v[210:213], v131 offset:34016
	ds_read_b128 v[214:217], v131 offset:34080
	ds_read_b128 v[218:221], v131 offset:34272
	ds_read_b128 v[222:225], v131 offset:34336
	ds_read_b128 v[226:229], v131 offset:34528
	ds_read_b128 v[230:233], v131 offset:34592
	; asyncmark
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	; sched_barrier mask(0x00000000)
	; wait_asyncmark(5)
	.loc	1 219 9                         ; matmul_kernel.py:219:9
	s_waitcnt vmcnt(10) lgkmcnt(0)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 221 22                        ; matmul_kernel.py:221:22
	v_mfma_f32_16x16x32_f16 v[92:95], v[186:189], v[202:205], v[92:95]
	v_mfma_f32_16x16x32_f16 v[92:95], v[190:193], v[206:209], v[92:95]
	v_mfma_f32_16x16x32_f16 v[88:91], v[174:177], v[202:205], v[88:91]
	v_mfma_f32_16x16x32_f16 v[88:91], v[170:173], v[206:209], v[88:91]
	v_mfma_f32_16x16x32_f16 v[84:87], v[186:189], v[210:213], v[84:87]
	v_mfma_f32_16x16x32_f16 v[84:87], v[190:193], v[214:217], v[84:87]
	v_mfma_f32_16x16x32_f16 v[80:83], v[174:177], v[210:213], v[80:83]
	v_mfma_f32_16x16x32_f16 v[80:83], v[170:173], v[214:217], v[80:83]
	v_mfma_f32_16x16x32_f16 v[76:79], v[186:189], v[218:221], v[76:79]
	v_mfma_f32_16x16x32_f16 v[76:79], v[190:193], v[222:225], v[76:79]
	v_mfma_f32_16x16x32_f16 v[72:75], v[174:177], v[218:221], v[72:75]
	v_mfma_f32_16x16x32_f16 v[72:75], v[170:173], v[222:225], v[72:75]
	v_mfma_f32_16x16x32_f16 v[68:71], v[186:189], v[226:229], v[68:71]
	v_mfma_f32_16x16x32_f16 v[68:71], v[190:193], v[230:233], v[68:71]
	v_mfma_f32_16x16x32_f16 v[64:67], v[174:177], v[226:229], v[64:67]
	v_mfma_f32_16x16x32_f16 v[64:67], v[170:173], v[230:233], v[64:67]
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 1
	; sched_barrier mask(0x00000000)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 224 13                        ; matmul_kernel.py:224:13
	s_mov_b32 m0, s14
	v_add_lshl_u32 v170, s3, v130, 1
	buffer_load_dwordx4 v170, s[8:11], 0 offen lds
	v_add_lshl_u32 v170, s3, v132, 1
	s_mov_b32 m0, s15
	s_nop 0
	buffer_load_dwordx4 v170, s[8:11], 0 offen lds
	.loc	1 223 23                        ; matmul_kernel.py:223:23
	ds_read_b128 v[170:173], v150
	ds_read_b128 v[174:177], v150 offset:64
	ds_read_b128 v[186:189], v150 offset:512
	ds_read_b128 v[190:193], v150 offset:576
	; asyncmark
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	; sched_barrier mask(0x00000000)
	; wait_asyncmark(5)
	.loc	1 227 9                         ; matmul_kernel.py:227:9
	s_waitcnt vmcnt(10) lgkmcnt(0)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 229 22                        ; matmul_kernel.py:229:22
	v_mfma_f32_16x16x32_f16 v[60:63], v[170:173], v[194:197], v[60:63]
	v_mfma_f32_16x16x32_f16 v[60:63], v[174:177], v[198:201], v[60:63]
	v_mfma_f32_16x16x32_f16 v[56:59], v[186:189], v[194:197], v[56:59]
	v_mfma_f32_16x16x32_f16 v[56:59], v[190:193], v[198:201], v[56:59]
	v_mfma_f32_16x16x32_f16 v[52:55], v[170:173], v[178:181], v[52:55]
	v_mfma_f32_16x16x32_f16 v[52:55], v[174:177], v[182:185], v[52:55]
	v_mfma_f32_16x16x32_f16 v[48:51], v[186:189], v[178:181], v[48:51]
	v_mfma_f32_16x16x32_f16 v[48:51], v[190:193], v[182:185], v[48:51]
	v_mfma_f32_16x16x32_f16 v[44:47], v[170:173], v[162:165], v[44:47]
	v_mfma_f32_16x16x32_f16 v[44:47], v[174:177], v[166:169], v[44:47]
	v_mfma_f32_16x16x32_f16 v[40:43], v[186:189], v[162:165], v[40:43]
	v_mfma_f32_16x16x32_f16 v[40:43], v[190:193], v[166:169], v[40:43]
	v_mfma_f32_16x16x32_f16 v[36:39], v[170:173], v[154:157], v[36:39]
	v_mfma_f32_16x16x32_f16 v[36:39], v[174:177], v[158:161], v[36:39]
	v_mfma_f32_16x16x32_f16 v[32:35], v[186:189], v[154:157], v[32:35]
	v_mfma_f32_16x16x32_f16 v[32:35], v[190:193], v[158:161], v[32:35]
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 1
	; sched_barrier mask(0x00000000)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 232 13                        ; matmul_kernel.py:232:13
	s_mov_b32 m0, s16
	v_add_lshl_u32 v154, s3, v140, 1
	buffer_load_dwordx4 v154, s[8:11], 0 offen lds
	v_add_lshl_u32 v154, s3, v141, 1
	s_mov_b32 m0, s17
	s_nop 0
	buffer_load_dwordx4 v154, s[8:11], 0 offen lds
	.loc	1 231 22                        ; matmul_kernel.py:231:22
	ds_read_b128 v[156:159], v151
	ds_read_b128 v[160:163], v151 offset:64
	ds_read_b128 v[164:167], v151 offset:512
	ds_read_b128 v[178:181], v151 offset:576
	; asyncmark
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	; sched_barrier mask(0x00000000)
	; wait_asyncmark(5)
	.loc	1 235 9                         ; matmul_kernel.py:235:9
	s_waitcnt vmcnt(10) lgkmcnt(0)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 237 22                        ; matmul_kernel.py:237:22
	v_mfma_f32_16x16x32_f16 v[20:23], v[170:173], v[202:205], v[20:23]
	v_mfma_f32_16x16x32_f16 v[20:23], v[174:177], v[206:209], v[20:23]
	v_mfma_f32_16x16x32_f16 v[28:31], v[186:189], v[202:205], v[28:31]
	v_mfma_f32_16x16x32_f16 v[28:31], v[190:193], v[206:209], v[28:31]
	v_mfma_f32_16x16x32_f16 v[24:27], v[170:173], v[210:213], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[174:177], v[214:217], v[24:27]
	v_mfma_f32_16x16x32_f16 v[16:19], v[186:189], v[210:213], v[16:19]
	v_mfma_f32_16x16x32_f16 v[16:19], v[190:193], v[214:217], v[16:19]
	v_mfma_f32_16x16x32_f16 v[12:15], v[170:173], v[218:221], v[12:15]
	v_mfma_f32_16x16x32_f16 v[12:15], v[174:177], v[222:225], v[12:15]
	v_mfma_f32_16x16x32_f16 v[8:11], v[186:189], v[218:221], v[8:11]
	v_mfma_f32_16x16x32_f16 v[8:11], v[190:193], v[222:225], v[8:11]
	v_mfma_f32_16x16x32_f16 v[4:7], v[170:173], v[226:229], v[4:7]
	v_mfma_f32_16x16x32_f16 v[4:7], v[174:177], v[230:233], v[4:7]
	v_mfma_f32_16x16x32_f16 v[0:3], v[186:189], v[226:229], v[0:3]
	v_mfma_f32_16x16x32_f16 v[0:3], v[190:193], v[230:233], v[0:3]
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 1
	; sched_barrier mask(0x00000000)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 240 13                        ; matmul_kernel.py:240:13
	s_mov_b32 m0, s18
	v_add_lshl_u32 v154, s3, v135, 1
	buffer_load_dwordx4 v154, s[24:27], 0 offen lds
	v_add_lshl_u32 v154, s3, v137, 1
	s_mov_b32 m0, s19
	s_nop 0
	buffer_load_dwordx4 v154, s[24:27], 0 offen lds
	.loc	1 239 21                        ; matmul_kernel.py:239:21
	ds_read_b128 v[168:171], v131 offset:16896
	ds_read_b128 v[172:175], v131 offset:16960
	ds_read_b128 v[182:185], v131 offset:17152
	ds_read_b128 v[186:189], v131 offset:17216
	ds_read_b128 v[190:193], v131 offset:17408
	ds_read_b128 v[194:197], v131 offset:17472
	ds_read_b128 v[198:201], v131 offset:17664
	ds_read_b128 v[202:205], v131 offset:17728
	; asyncmark
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	; sched_barrier mask(0x00000000)
	; wait_asyncmark(5)
	.loc	1 244 9                         ; matmul_kernel.py:244:9
	s_waitcnt vmcnt(10) lgkmcnt(0)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 246 22                        ; matmul_kernel.py:246:22
	v_mfma_f32_16x16x32_f16 v[124:127], v[156:159], v[168:171], v[124:127]
	v_mfma_f32_16x16x32_f16 v[124:127], v[160:163], v[172:175], v[124:127]
	v_mfma_f32_16x16x32_f16 v[120:123], v[164:167], v[168:171], v[120:123]
	v_mfma_f32_16x16x32_f16 v[120:123], v[178:181], v[172:175], v[120:123]
	v_mfma_f32_16x16x32_f16 v[116:119], v[156:159], v[182:185], v[116:119]
	v_mfma_f32_16x16x32_f16 v[116:119], v[160:163], v[186:189], v[116:119]
	v_mfma_f32_16x16x32_f16 v[112:115], v[164:167], v[182:185], v[112:115]
	v_mfma_f32_16x16x32_f16 v[112:115], v[178:181], v[186:189], v[112:115]
	v_mfma_f32_16x16x32_f16 v[108:111], v[156:159], v[190:193], v[108:111]
	v_mfma_f32_16x16x32_f16 v[108:111], v[160:163], v[194:197], v[108:111]
	v_mfma_f32_16x16x32_f16 v[104:107], v[164:167], v[190:193], v[104:107]
	v_mfma_f32_16x16x32_f16 v[104:107], v[178:181], v[194:197], v[104:107]
	v_mfma_f32_16x16x32_f16 v[100:103], v[156:159], v[198:201], v[100:103]
	v_mfma_f32_16x16x32_f16 v[100:103], v[160:163], v[202:205], v[100:103]
	v_mfma_f32_16x16x32_f16 v[96:99], v[164:167], v[198:201], v[96:99]
	v_mfma_f32_16x16x32_f16 v[96:99], v[178:181], v[202:205], v[96:99]
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 1
	; sched_barrier mask(0x00000000)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 249 13                        ; matmul_kernel.py:249:13
	s_mov_b32 m0, s38
	v_add_lshl_u32 v154, s3, v146, 1
	buffer_load_dwordx4 v154, s[24:27], 0 offen lds
	v_add_lshl_u32 v154, s3, v147, 1
	s_mov_b32 m0, s39
	s_nop 0
	buffer_load_dwordx4 v154, s[24:27], 0 offen lds
	.loc	1 248 21                        ; matmul_kernel.py:248:21
	ds_read_b128 v[206:209], v131 offset:50656
	ds_read_b128 v[210:213], v131 offset:50720
	ds_read_b128 v[214:217], v131 offset:50912
	ds_read_b128 v[218:221], v131 offset:50976
	ds_read_b128 v[222:225], v131 offset:51168
	ds_read_b128 v[226:229], v131 offset:51232
	ds_read_b128 v[230:233], v131 offset:51424
	ds_read_b128 v[234:237], v131 offset:51488
	; asyncmark
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	; sched_barrier mask(0x00000000)
	; wait_asyncmark(5)
	.loc	1 252 9                         ; matmul_kernel.py:252:9
	s_waitcnt vmcnt(10) lgkmcnt(0)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 254 22                        ; matmul_kernel.py:254:22
	v_mfma_f32_16x16x32_f16 v[92:95], v[156:159], v[206:209], v[92:95]
	v_mfma_f32_16x16x32_f16 v[92:95], v[160:163], v[210:213], v[92:95]
	v_mfma_f32_16x16x32_f16 v[88:91], v[164:167], v[206:209], v[88:91]
	v_mfma_f32_16x16x32_f16 v[88:91], v[178:181], v[210:213], v[88:91]
	v_mfma_f32_16x16x32_f16 v[84:87], v[156:159], v[214:217], v[84:87]
	v_mfma_f32_16x16x32_f16 v[84:87], v[160:163], v[218:221], v[84:87]
	v_mfma_f32_16x16x32_f16 v[80:83], v[164:167], v[214:217], v[80:83]
	v_mfma_f32_16x16x32_f16 v[80:83], v[178:181], v[218:221], v[80:83]
	v_mfma_f32_16x16x32_f16 v[76:79], v[156:159], v[222:225], v[76:79]
	v_mfma_f32_16x16x32_f16 v[76:79], v[160:163], v[226:229], v[76:79]
	v_mfma_f32_16x16x32_f16 v[72:75], v[164:167], v[222:225], v[72:75]
	v_mfma_f32_16x16x32_f16 v[72:75], v[178:181], v[226:229], v[72:75]
	v_mfma_f32_16x16x32_f16 v[68:71], v[156:159], v[230:233], v[68:71]
	v_mfma_f32_16x16x32_f16 v[68:71], v[160:163], v[234:237], v[68:71]
	v_mfma_f32_16x16x32_f16 v[64:67], v[164:167], v[230:233], v[64:67]
	v_mfma_f32_16x16x32_f16 v[64:67], v[178:181], v[234:237], v[64:67]
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 1
	; sched_barrier mask(0x00000000)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 257 13                        ; matmul_kernel.py:257:13
	s_mov_b32 m0, s40
	v_add_lshl_u32 v154, s3, v142, 1
	buffer_load_dwordx4 v154, s[8:11], 0 offen lds
	v_add_lshl_u32 v154, s3, v143, 1
	s_mov_b32 m0, s41
	s_nop 0
	buffer_load_dwordx4 v154, s[8:11], 0 offen lds
	.loc	1 256 23                        ; matmul_kernel.py:256:23
	ds_read_b128 v[156:159], v152
	ds_read_b128 v[160:163], v152 offset:64
	ds_read_b128 v[164:167], v152 offset:512
	ds_read_b128 v[178:181], v152 offset:576
	; asyncmark
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	; sched_barrier mask(0x00000000)
	; wait_asyncmark(5)
	.loc	1 260 9                         ; matmul_kernel.py:260:9
	s_waitcnt vmcnt(10) lgkmcnt(0)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 262 22                        ; matmul_kernel.py:262:22
	v_mfma_f32_16x16x32_f16 v[60:63], v[156:159], v[168:171], v[60:63]
	v_mfma_f32_16x16x32_f16 v[60:63], v[160:163], v[172:175], v[60:63]
	v_mfma_f32_16x16x32_f16 v[56:59], v[164:167], v[168:171], v[56:59]
	v_mfma_f32_16x16x32_f16 v[56:59], v[178:181], v[172:175], v[56:59]
	v_mfma_f32_16x16x32_f16 v[52:55], v[156:159], v[182:185], v[52:55]
	v_mfma_f32_16x16x32_f16 v[52:55], v[160:163], v[186:189], v[52:55]
	v_mfma_f32_16x16x32_f16 v[48:51], v[164:167], v[182:185], v[48:51]
	v_mfma_f32_16x16x32_f16 v[48:51], v[178:181], v[186:189], v[48:51]
	v_mfma_f32_16x16x32_f16 v[44:47], v[156:159], v[190:193], v[44:47]
	v_mfma_f32_16x16x32_f16 v[44:47], v[160:163], v[194:197], v[44:47]
	v_mfma_f32_16x16x32_f16 v[40:43], v[164:167], v[190:193], v[40:43]
	v_mfma_f32_16x16x32_f16 v[40:43], v[178:181], v[194:197], v[40:43]
	v_mfma_f32_16x16x32_f16 v[36:39], v[156:159], v[198:201], v[36:39]
	v_mfma_f32_16x16x32_f16 v[36:39], v[160:163], v[202:205], v[36:39]
	v_mfma_f32_16x16x32_f16 v[32:35], v[164:167], v[198:201], v[32:35]
	v_mfma_f32_16x16x32_f16 v[32:35], v[178:181], v[202:205], v[32:35]
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 1
	; sched_barrier mask(0x00000000)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 265 13                        ; matmul_kernel.py:265:13
	s_mov_b32 m0, s42
	v_add_lshl_u32 v154, s3, v144, 1
	buffer_load_dwordx4 v154, s[8:11], 0 offen lds
	v_add_lshl_u32 v154, s3, v145, 1
	s_mov_b32 m0, s43
	s_nop 0
	buffer_load_dwordx4 v154, s[8:11], 0 offen lds
	.loc	1 264 22                        ; matmul_kernel.py:264:22
	ds_read_b128 v[186:189], v153
	ds_read_b128 v[190:193], v153 offset:64
	ds_read_b128 v[174:177], v153 offset:512
	ds_read_b128 v[170:173], v153 offset:576
	; asyncmark
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	; sched_barrier mask(0x00000000)
	; wait_asyncmark(5)
	.loc	1 268 9                         ; matmul_kernel.py:268:9
	s_waitcnt vmcnt(10) lgkmcnt(0)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 270 22                        ; matmul_kernel.py:270:22
	v_mfma_f32_16x16x32_f16 v[20:23], v[156:159], v[206:209], v[20:23]
	v_mfma_f32_16x16x32_f16 v[20:23], v[160:163], v[210:213], v[20:23]
	v_mfma_f32_16x16x32_f16 v[28:31], v[164:167], v[206:209], v[28:31]
	v_mfma_f32_16x16x32_f16 v[28:31], v[178:181], v[210:213], v[28:31]
	v_mfma_f32_16x16x32_f16 v[24:27], v[156:159], v[214:217], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[160:163], v[218:221], v[24:27]
	v_mfma_f32_16x16x32_f16 v[16:19], v[164:167], v[214:217], v[16:19]
	v_mfma_f32_16x16x32_f16 v[16:19], v[178:181], v[218:221], v[16:19]
	v_mfma_f32_16x16x32_f16 v[12:15], v[156:159], v[222:225], v[12:15]
	v_mfma_f32_16x16x32_f16 v[12:15], v[160:163], v[226:229], v[12:15]
	v_mfma_f32_16x16x32_f16 v[8:11], v[164:167], v[222:225], v[8:11]
	v_mfma_f32_16x16x32_f16 v[8:11], v[178:181], v[226:229], v[8:11]
	v_mfma_f32_16x16x32_f16 v[4:7], v[156:159], v[230:233], v[4:7]
	v_mfma_f32_16x16x32_f16 v[4:7], v[160:163], v[234:237], v[4:7]
	v_mfma_f32_16x16x32_f16 v[0:3], v[164:167], v[230:233], v[0:3]
	v_mfma_f32_16x16x32_f16 v[0:3], v[178:181], v[234:237], v[0:3]
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 1
	; sched_barrier mask(0x00000000)
	s_barrier
	; sched_barrier mask(0x00000000)
	.loc	1 273 13                        ; matmul_kernel.py:273:13
	s_mov_b32 m0, s44
	v_add_lshl_u32 v154, s3, v148, 1
	buffer_load_dwordx4 v154, s[24:27], 0 offen lds
	v_add_lshl_u32 v154, s3, v149, 1
	s_mov_b32 m0, s45
	s_nop 0
	buffer_load_dwordx4 v154, s[24:27], 0 offen lds
	.loc	1 272 21                        ; matmul_kernel.py:272:21
	ds_read_b128 v[194:197], v131
	ds_read_b128 v[198:201], v131 offset:64
	ds_read_b128 v[178:181], v131 offset:256
	ds_read_b128 v[182:185], v131 offset:320
	ds_read_b128 v[162:165], v131 offset:512
	ds_read_b128 v[166:169], v131 offset:576
	ds_read_b128 v[154:157], v131 offset:768
	ds_read_b128 v[158:161], v131 offset:832
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_add_i32 s1, s1, 2
	s_cmp_lt_i32 s1, s0
	; asyncmark
	s_cbranch_scc1 .LBB0_4
; %bb.5:                                ; %Flow375
	.loc	1 0 5 is_stmt 0                 ; matmul_kernel.py:0:5
	s_load_dword s38, s[4:5], 0x38
	.loc	1 209 5                         ; matmul_kernel.py:209:5
	s_setprio 0
	s_and_saveexec_b64 s[0:1], vcc
	s_cbranch_execz .LBB0_7
.LBB0_6:
	s_barrier
.LBB0_7:
	.loc	1 0 5                           ; matmul_kernel.py:0:5
	s_or_b64 exec, exec, s[0:1]
	.loc	1 280 14 is_stmt 1              ; matmul_kernel.py:280:14
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[124:127], v[186:189], v[194:197], v[124:127]
	v_mfma_f32_16x16x32_f16 v[124:127], v[190:193], v[198:201], v[124:127]
	v_mfma_f32_16x16x32_f16 v[120:123], v[174:177], v[194:197], v[120:123]
	v_mfma_f32_16x16x32_f16 v[120:123], v[170:173], v[198:201], v[120:123]
	v_mfma_f32_16x16x32_f16 v[116:119], v[186:189], v[178:181], v[116:119]
	v_mfma_f32_16x16x32_f16 v[116:119], v[190:193], v[182:185], v[116:119]
	v_mfma_f32_16x16x32_f16 v[112:115], v[174:177], v[178:181], v[112:115]
	v_mfma_f32_16x16x32_f16 v[112:115], v[170:173], v[182:185], v[112:115]
	v_mfma_f32_16x16x32_f16 v[108:111], v[186:189], v[162:165], v[108:111]
	v_mfma_f32_16x16x32_f16 v[108:111], v[190:193], v[166:169], v[108:111]
	v_mfma_f32_16x16x32_f16 v[104:107], v[174:177], v[162:165], v[104:107]
	v_mfma_f32_16x16x32_f16 v[104:107], v[170:173], v[166:169], v[104:107]
	v_mfma_f32_16x16x32_f16 v[100:103], v[186:189], v[154:157], v[100:103]
	v_mfma_f32_16x16x32_f16 v[100:103], v[190:193], v[158:161], v[100:103]
	v_mfma_f32_16x16x32_f16 v[96:99], v[174:177], v[154:157], v[96:99]
	v_mfma_f32_16x16x32_f16 v[96:99], v[170:173], v[158:161], v[96:99]
	; wait_asyncmark(0)
	.loc	1 281 5                         ; matmul_kernel.py:281:5
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_barrier
	.loc	1 283 13                        ; matmul_kernel.py:283:13
	ds_read_b128 v[202:205], v131 offset:33760
	ds_read_b128 v[206:209], v131 offset:33824
	.loc	1 285 14                        ; matmul_kernel.py:285:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[92:95], v[186:189], v[202:205], v[92:95]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[92:95], v[190:193], v[206:209], v[92:95]
	v_mfma_f32_16x16x32_f16 v[88:91], v[174:177], v[202:205], v[88:91]
	v_mfma_f32_16x16x32_f16 v[88:91], v[170:173], v[206:209], v[88:91]
	.loc	1 283 13                        ; matmul_kernel.py:283:13
	ds_read_b128 v[210:213], v131 offset:34016
	ds_read_b128 v[214:217], v131 offset:34080
	.loc	1 285 14                        ; matmul_kernel.py:285:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[84:87], v[186:189], v[210:213], v[84:87]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[84:87], v[190:193], v[214:217], v[84:87]
	v_mfma_f32_16x16x32_f16 v[80:83], v[174:177], v[210:213], v[80:83]
	v_mfma_f32_16x16x32_f16 v[80:83], v[170:173], v[214:217], v[80:83]
	.loc	1 283 13                        ; matmul_kernel.py:283:13
	ds_read_b128 v[218:221], v131 offset:34272
	ds_read_b128 v[222:225], v131 offset:34336
	.loc	1 285 14                        ; matmul_kernel.py:285:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[76:79], v[186:189], v[218:221], v[76:79]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[134:137], v[190:193], v[222:225], v[76:79]
	v_mfma_f32_16x16x32_f16 v[72:75], v[174:177], v[218:221], v[72:75]
	v_mfma_f32_16x16x32_f16 v[72:75], v[170:173], v[222:225], v[72:75]
	.loc	1 283 13                        ; matmul_kernel.py:283:13
	s_nop 3
	ds_read_b128 v[76:79], v131 offset:34528
	ds_read_b128 v[226:229], v131 offset:34592
	.loc	1 285 14                        ; matmul_kernel.py:285:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[68:71], v[186:189], v[76:79], v[68:71]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[140:143], v[190:193], v[226:229], v[68:71]
	v_mfma_f32_16x16x32_f16 v[64:67], v[174:177], v[76:79], v[64:67]
	.loc	1 287 15                        ; matmul_kernel.py:287:15
	s_nop 4
	v_add_u32_e32 v68, 0x18ba0, v133
	ds_read_b128 v[186:189], v68
	.loc	1 285 14                        ; matmul_kernel.py:285:14
	v_mfma_f32_16x16x32_f16 v[64:67], v[170:173], v[226:229], v[64:67]
	.loc	1 287 15                        ; matmul_kernel.py:287:15
	ds_read_b128 v[190:193], v68 offset:64
	.loc	1 289 14                        ; matmul_kernel.py:289:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[60:63], v[186:189], v[194:197], v[60:63]
	.loc	1 287 15                        ; matmul_kernel.py:287:15
	ds_read_b128 v[230:233], v68 offset:512
	.loc	1 289 14                        ; matmul_kernel.py:289:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[144:147], v[190:193], v[198:201], v[60:63]
	.loc	1 287 15                        ; matmul_kernel.py:287:15
	s_nop 4
	ds_read_b128 v[60:63], v68 offset:576
	.loc	1 289 14                        ; matmul_kernel.py:289:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[56:59], v[230:233], v[194:197], v[56:59]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[148:151], v[60:63], v[198:201], v[56:59]
	v_mfma_f32_16x16x32_f16 v[52:55], v[186:189], v[178:181], v[52:55]
	v_mfma_f32_16x16x32_f16 v[52:55], v[190:193], v[182:185], v[52:55]
	v_mfma_f32_16x16x32_f16 v[48:51], v[230:233], v[178:181], v[48:51]
	v_mfma_f32_16x16x32_f16 v[170:173], v[60:63], v[182:185], v[48:51]
	v_mfma_f32_16x16x32_f16 v[44:47], v[186:189], v[162:165], v[44:47]
	v_mfma_f32_16x16x32_f16 v[44:47], v[190:193], v[166:169], v[44:47]
	v_mfma_f32_16x16x32_f16 v[40:43], v[230:233], v[162:165], v[40:43]
	v_mfma_f32_16x16x32_f16 v[162:165], v[60:63], v[166:169], v[40:43]
	v_mfma_f32_16x16x32_f16 v[36:39], v[186:189], v[154:157], v[36:39]
	v_mfma_f32_16x16x32_f16 v[166:169], v[190:193], v[158:161], v[36:39]
	v_mfma_f32_16x16x32_f16 v[32:35], v[230:233], v[154:157], v[32:35]
	v_mfma_f32_16x16x32_f16 v[152:155], v[60:63], v[158:161], v[32:35]
	.loc	1 294 14                        ; matmul_kernel.py:294:14
	v_mfma_f32_16x16x32_f16 v[20:23], v[186:189], v[202:205], v[20:23]
	v_mfma_f32_16x16x32_f16 v[20:23], v[190:193], v[206:209], v[20:23]
	v_mfma_f32_16x16x32_f16 v[28:31], v[230:233], v[202:205], v[28:31]
	v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[206:209], v[28:31]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[210:213], v[24:27]
	v_mfma_f32_16x16x32_f16 v[174:177], v[190:193], v[214:217], v[24:27]
	v_mfma_f32_16x16x32_f16 v[16:19], v[230:233], v[210:213], v[16:19]
	v_mfma_f32_16x16x32_f16 v[16:19], v[60:63], v[214:217], v[16:19]
	v_mfma_f32_16x16x32_f16 v[12:15], v[186:189], v[218:221], v[12:15]
	v_mfma_f32_16x16x32_f16 v[12:15], v[190:193], v[222:225], v[12:15]
	v_mfma_f32_16x16x32_f16 v[8:11], v[230:233], v[218:221], v[8:11]
	v_mfma_f32_16x16x32_f16 v[8:11], v[60:63], v[222:225], v[8:11]
	v_mfma_f32_16x16x32_f16 v[4:7], v[186:189], v[76:79], v[4:7]
	v_mfma_f32_16x16x32_f16 v[4:7], v[190:193], v[226:229], v[4:7]
	.loc	1 292 14                        ; matmul_kernel.py:292:14
	v_add_u32_e32 v28, 0x149c0, v133
	.loc	1 294 14                        ; matmul_kernel.py:294:14
	v_mfma_f32_16x16x32_f16 v[0:3], v[230:233], v[76:79], v[0:3]
	.loc	1 292 14                        ; matmul_kernel.py:292:14
	ds_read_b128 v[30:33], v28
	ds_read_b128 v[34:37], v28 offset:64
	.loc	1 294 14                        ; matmul_kernel.py:294:14
	v_mfma_f32_16x16x32_f16 v[0:3], v[60:63], v[226:229], v[0:3]
	.loc	1 296 13                        ; matmul_kernel.py:296:13
	ds_read_b128 v[178:181], v131 offset:16896
	ds_read_b128 v[182:185], v131 offset:16960
	.loc	1 300 14                        ; matmul_kernel.py:300:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[30:33], v[178:181], v[124:127]
	.loc	1 292 14                        ; matmul_kernel.py:292:14
	ds_read_b128 v[186:189], v28 offset:512
	.loc	1 300 14                        ; matmul_kernel.py:300:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[124:127], v[34:37], v[182:185], v[24:27]
	.loc	1 292 14                        ; matmul_kernel.py:292:14
	ds_read_b128 v[190:193], v28 offset:576
	.loc	1 300 14                        ; matmul_kernel.py:300:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[178:181], v[120:123]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[120:123], v[190:193], v[182:185], v[24:27]
	.loc	1 296 13                        ; matmul_kernel.py:296:13
	ds_read_b128 v[194:197], v131 offset:17152
	ds_read_b128 v[198:201], v131 offset:17216
	.loc	1 300 14                        ; matmul_kernel.py:300:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[30:33], v[194:197], v[116:119]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[116:119], v[34:37], v[198:201], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[194:197], v[112:115]
	v_mfma_f32_16x16x32_f16 v[112:115], v[190:193], v[198:201], v[24:27]
	.loc	1 296 13                        ; matmul_kernel.py:296:13
	ds_read_b128 v[202:205], v131 offset:17408
	ds_read_b128 v[206:209], v131 offset:17472
	.loc	1 300 14                        ; matmul_kernel.py:300:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[30:33], v[202:205], v[108:111]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[108:111], v[34:37], v[206:209], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[202:205], v[104:107]
	v_mfma_f32_16x16x32_f16 v[104:107], v[190:193], v[206:209], v[24:27]
	.loc	1 296 13                        ; matmul_kernel.py:296:13
	ds_read_b128 v[210:213], v131 offset:17664
	ds_read_b128 v[214:217], v131 offset:17728
	.loc	1 300 14                        ; matmul_kernel.py:300:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[30:33], v[210:213], v[100:103]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[100:103], v[34:37], v[214:217], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[210:213], v[96:99]
	v_mfma_f32_16x16x32_f16 v[96:99], v[190:193], v[214:217], v[24:27]
	.loc	1 302 13                        ; matmul_kernel.py:302:13
	ds_read_b128 v[218:221], v131 offset:50656
	ds_read_b128 v[222:225], v131 offset:50720
	.loc	1 304 14                        ; matmul_kernel.py:304:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[30:33], v[218:221], v[92:95]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[76:79], v[34:37], v[222:225], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[218:221], v[88:91]
	v_mfma_f32_16x16x32_f16 v[68:71], v[190:193], v[222:225], v[24:27]
	.loc	1 302 13                        ; matmul_kernel.py:302:13
	ds_read_b128 v[226:229], v131 offset:50912
	ds_read_b128 v[230:233], v131 offset:50976
	.loc	1 304 14                        ; matmul_kernel.py:304:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[30:33], v[226:229], v[84:87]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[60:63], v[34:37], v[230:233], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[226:229], v[80:83]
	v_mfma_f32_16x16x32_f16 v[56:59], v[190:193], v[230:233], v[24:27]
	.loc	1 302 13                        ; matmul_kernel.py:302:13
	ds_read_b128 v[234:237], v131 offset:51168
	ds_read_b128 v[238:241], v131 offset:51232
	.loc	1 304 14                        ; matmul_kernel.py:304:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[30:33], v[234:237], v[134:137]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[48:51], v[34:37], v[238:241], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[234:237], v[72:75]
	v_mfma_f32_16x16x32_f16 v[40:43], v[190:193], v[238:241], v[24:27]
	.loc	1 302 13                        ; matmul_kernel.py:302:13
	ds_read_b128 v[134:137], v131 offset:51424
	ds_read_b128 v[242:245], v131 offset:51488
	.loc	1 304 14                        ; matmul_kernel.py:304:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[30:33], v[134:137], v[140:143]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[36:39], v[34:37], v[242:245], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[134:137], v[64:67]
	.loc	1 306 15                        ; matmul_kernel.py:306:15
	v_add_u32_e32 v28, 0x1cda0, v133
	ds_read_b128 v[130:133], v28
	.loc	1 304 14                        ; matmul_kernel.py:304:14
	v_mfma_f32_16x16x32_f16 v[32:35], v[190:193], v[242:245], v[24:27]
	.loc	1 306 15                        ; matmul_kernel.py:306:15
	ds_read_b128 v[140:143], v28 offset:64
	.loc	1 308 14                        ; matmul_kernel.py:308:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[130:133], v[178:181], v[144:147]
	.loc	1 306 15                        ; matmul_kernel.py:306:15
	s_nop 2
	ds_read_b128 v[144:147], v28 offset:512
	.loc	1 308 14                        ; matmul_kernel.py:308:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[92:95], v[140:143], v[182:185], v[24:27]
	.loc	1 306 15                        ; matmul_kernel.py:306:15
	ds_read_b128 v[186:189], v28 offset:576
	.loc	1 308 14                        ; matmul_kernel.py:308:14
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[24:27], v[144:147], v[178:181], v[148:151]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[88:91], v[186:189], v[182:185], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[130:133], v[194:197], v[52:55]
	v_mfma_f32_16x16x32_f16 v[84:87], v[140:143], v[198:201], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[144:147], v[194:197], v[170:173]
	v_mfma_f32_16x16x32_f16 v[80:83], v[186:189], v[198:201], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[130:133], v[202:205], v[44:47]
	v_mfma_f32_16x16x32_f16 v[72:75], v[140:143], v[206:209], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[144:147], v[202:205], v[162:165]
	v_mfma_f32_16x16x32_f16 v[64:67], v[186:189], v[206:209], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[130:133], v[210:213], v[166:169]
	v_mfma_f32_16x16x32_f16 v[52:55], v[140:143], v[214:217], v[24:27]
	v_mfma_f32_16x16x32_f16 v[24:27], v[144:147], v[210:213], v[152:155]
	v_mfma_f32_16x16x32_f16 v[44:47], v[186:189], v[214:217], v[24:27]
	.loc	1 309 14                        ; matmul_kernel.py:309:14
	v_mfma_f32_16x16x32_f16 v[20:23], v[130:133], v[218:221], v[20:23]
	v_mfma_f32_16x16x32_f16 v[28:31], v[140:143], v[222:225], v[20:23]
	v_mfma_f32_16x16x32_f16 v[20:23], v[144:147], v[218:221], v[156:159]
	v_mfma_f32_16x16x32_f16 v[24:27], v[186:189], v[222:225], v[20:23]
	v_mfma_f32_16x16x32_f16 v[20:23], v[130:133], v[226:229], v[174:177]
	v_mfma_f32_16x16x32_f16 v[20:23], v[140:143], v[230:233], v[20:23]
	v_mfma_f32_16x16x32_f16 v[16:19], v[144:147], v[226:229], v[16:19]
	v_mfma_f32_16x16x32_f16 v[16:19], v[186:189], v[230:233], v[16:19]
	v_mfma_f32_16x16x32_f16 v[12:15], v[130:133], v[234:237], v[12:15]
	v_mfma_f32_16x16x32_f16 v[12:15], v[140:143], v[238:241], v[12:15]
	v_mfma_f32_16x16x32_f16 v[8:11], v[144:147], v[234:237], v[8:11]
	v_mfma_f32_16x16x32_f16 v[8:11], v[186:189], v[238:241], v[8:11]
	v_mfma_f32_16x16x32_f16 v[4:7], v[130:133], v[134:137], v[4:7]
	v_mfma_f32_16x16x32_f16 v[4:7], v[140:143], v[242:245], v[4:7]
	v_mfma_f32_16x16x32_f16 v[0:3], v[144:147], v[134:137], v[0:3]
	.loc	1 318 24                        ; matmul_kernel.py:318:24
	s_lshl_b32 s40, s2, 7
	.loc	1 318 5 is_stmt 0               ; matmul_kernel.py:318:5
	s_cmp_lt_i32 s40, s30
	.loc	1 309 14 is_stmt 1              ; matmul_kernel.py:309:14
	v_mfma_f32_16x16x32_f16 v[0:3], v[186:189], v[242:245], v[0:3]
	s_cbranch_scc1 .LBB0_10
; %bb.8:                                ; %.._crit_edge778_crit_edge
	.loc	1 350 18                        ; matmul_kernel.py:350:18
	s_or_b32 s39, s33, 0x80
	s_mov_b64 vcc, exec
	v_and_or_b32 v140, v138, 63, s37
	s_cbranch_execz .LBB0_11
	s_branch .LBB0_13
.LBB0_9:
	.loc	1 0 18 is_stmt 0                ; matmul_kernel.py:0:18
	v_mov_b32_e32 v3, 0
	v_mov_b32_e32 v2, v3
	v_mov_b32_e32 v1, v3
	v_mov_b32_e32 v0, v3
	v_mov_b32_e32 v7, v3
	v_mov_b32_e32 v6, v3
	v_mov_b32_e32 v5, v3
	v_mov_b32_e32 v4, v3
	v_mov_b32_e32 v11, v3
	v_mov_b32_e32 v10, v3
	v_mov_b32_e32 v9, v3
	v_mov_b32_e32 v8, v3
	v_mov_b32_e32 v15, v3
	v_mov_b32_e32 v14, v3
	v_mov_b32_e32 v13, v3
	v_mov_b32_e32 v12, v3
	v_mov_b32_e32 v19, v3
	v_mov_b32_e32 v18, v3
	v_mov_b32_e32 v17, v3
	v_mov_b32_e32 v16, v3
	v_mov_b32_e32 v27, v3
	v_mov_b32_e32 v26, v3
	v_mov_b32_e32 v25, v3
	v_mov_b32_e32 v24, v3
	v_mov_b32_e32 v31, v3
	v_mov_b32_e32 v30, v3
	v_mov_b32_e32 v29, v3
	v_mov_b32_e32 v28, v3
	v_mov_b32_e32 v23, v3
	v_mov_b32_e32 v22, v3
	v_mov_b32_e32 v21, v3
	v_mov_b32_e32 v20, v3
	v_mov_b32_e32 v35, v3
	v_mov_b32_e32 v34, v3
	v_mov_b32_e32 v33, v3
	v_mov_b32_e32 v32, v3
	v_mov_b32_e32 v39, v3
	v_mov_b32_e32 v38, v3
	v_mov_b32_e32 v37, v3
	v_mov_b32_e32 v36, v3
	v_mov_b32_e32 v43, v3
	v_mov_b32_e32 v42, v3
	v_mov_b32_e32 v41, v3
	v_mov_b32_e32 v40, v3
	v_mov_b32_e32 v47, v3
	v_mov_b32_e32 v46, v3
	v_mov_b32_e32 v45, v3
	v_mov_b32_e32 v44, v3
	v_mov_b32_e32 v51, v3
	v_mov_b32_e32 v50, v3
	v_mov_b32_e32 v49, v3
	v_mov_b32_e32 v48, v3
	v_mov_b32_e32 v55, v3
	v_mov_b32_e32 v54, v3
	v_mov_b32_e32 v53, v3
	v_mov_b32_e32 v52, v3
	v_mov_b32_e32 v59, v3
	v_mov_b32_e32 v58, v3
	v_mov_b32_e32 v57, v3
	v_mov_b32_e32 v56, v3
	v_mov_b32_e32 v63, v3
	v_mov_b32_e32 v62, v3
	v_mov_b32_e32 v61, v3
	v_mov_b32_e32 v60, v3
	v_mov_b32_e32 v67, v3
	v_mov_b32_e32 v66, v3
	v_mov_b32_e32 v65, v3
	v_mov_b32_e32 v64, v3
	v_mov_b32_e32 v71, v3
	v_mov_b32_e32 v70, v3
	v_mov_b32_e32 v69, v3
	v_mov_b32_e32 v68, v3
	v_mov_b32_e32 v75, v3
	v_mov_b32_e32 v74, v3
	v_mov_b32_e32 v73, v3
	v_mov_b32_e32 v72, v3
	v_mov_b32_e32 v79, v3
	v_mov_b32_e32 v78, v3
	v_mov_b32_e32 v77, v3
	v_mov_b32_e32 v76, v3
	v_mov_b32_e32 v83, v3
	v_mov_b32_e32 v82, v3
	v_mov_b32_e32 v81, v3
	v_mov_b32_e32 v80, v3
	v_mov_b32_e32 v87, v3
	v_mov_b32_e32 v86, v3
	v_mov_b32_e32 v85, v3
	v_mov_b32_e32 v84, v3
	v_mov_b32_e32 v91, v3
	v_mov_b32_e32 v90, v3
	v_mov_b32_e32 v89, v3
	v_mov_b32_e32 v88, v3
	v_mov_b32_e32 v95, v3
	v_mov_b32_e32 v94, v3
	v_mov_b32_e32 v93, v3
	v_mov_b32_e32 v92, v3
	v_mov_b32_e32 v99, v3
	v_mov_b32_e32 v98, v3
	v_mov_b32_e32 v97, v3
	v_mov_b32_e32 v96, v3
	v_mov_b32_e32 v103, v3
	v_mov_b32_e32 v102, v3
	v_mov_b32_e32 v101, v3
	v_mov_b32_e32 v100, v3
	v_mov_b32_e32 v107, v3
	v_mov_b32_e32 v106, v3
	v_mov_b32_e32 v105, v3
	v_mov_b32_e32 v104, v3
	v_mov_b32_e32 v111, v3
	v_mov_b32_e32 v110, v3
	v_mov_b32_e32 v109, v3
	v_mov_b32_e32 v108, v3
	v_mov_b32_e32 v115, v3
	v_mov_b32_e32 v114, v3
	v_mov_b32_e32 v113, v3
	v_mov_b32_e32 v112, v3
	v_mov_b32_e32 v119, v3
	v_mov_b32_e32 v118, v3
	v_mov_b32_e32 v117, v3
	v_mov_b32_e32 v116, v3
	v_mov_b32_e32 v123, v3
	v_mov_b32_e32 v122, v3
	v_mov_b32_e32 v121, v3
	v_mov_b32_e32 v120, v3
	v_mov_b32_e32 v127, v3
	v_mov_b32_e32 v126, v3
	v_mov_b32_e32 v125, v3
	v_mov_b32_e32 v124, v3
	s_load_dword s38, s[4:5], 0x38
	.loc	1 209 5 is_stmt 1               ; matmul_kernel.py:209:5
	s_setprio 0
	s_and_saveexec_b64 s[0:1], vcc
	s_cbranch_execnz .LBB0_6
	s_branch .LBB0_7
.LBB0_10:
                                        ; implicit-def: $sgpr39
	.loc	1 0 5 is_stmt 0                 ; matmul_kernel.py:0:5
	s_mov_b64 vcc, 0
	v_and_or_b32 v140, v138, 63, s37
.LBB0_11:                               ; %.lr.ph777
	.loc	1 148 33 is_stmt 1              ; matmul_kernel.py:148:33
	v_lshrrev_b32_e32 v134, 3, v140
	v_or_b32_e32 v136, 64, v134
	.loc	1 148 15 is_stmt 0              ; matmul_kernel.py:148:15
	v_or_b32_e32 v130, s34, v134
	v_or_b32_e32 v131, s34, v136
	.loc	1 149 15 is_stmt 1              ; matmul_kernel.py:149:15
	v_or_b32_e32 v132, s33, v134
	v_or_b32_e32 v133, s33, v136
	.loc	1 316 19                        ; matmul_kernel.py:316:19
	s_movk_i32 s39, 0x80
	v_or_b32_e32 v135, 0x80, v130
	v_or_b32_e32 v137, 0x80, v131
	.loc	1 317 21                        ; matmul_kernel.py:317:21
	v_or_b32_e32 v141, 0x80, v132
	v_or_b32_e32 v142, 0x80, v133
	.loc	1 322 33                        ; matmul_kernel.py:322:33
	v_cmp_gt_i32_e32 vcc, s28, v130
	v_cmp_gt_i32_e64 s[0:1], s28, v131
	.loc	1 324 33                        ; matmul_kernel.py:324:33
	v_cmp_gt_i32_e64 s[2:3], s28, v135
	v_cmp_gt_i32_e64 s[4:5], s28, v137
	.loc	1 323 27                        ; matmul_kernel.py:323:27
	s_or_b32 s10, s34, 0x80
	.loc	1 326 52                        ; matmul_kernel.py:326:52
	v_cmp_gt_i32_e64 s[6:7], s29, v132
	v_cmp_gt_i32_e64 s[14:15], s29, v133
	.loc	1 328 53                        ; matmul_kernel.py:328:53
	v_cmp_gt_i32_e64 s[16:17], s29, v141
	v_cmp_gt_i32_e64 s[18:19], s29, v142
	.loc	1 323 27                        ; matmul_kernel.py:323:27
	s_mul_i32 s42, s10, s31
	.loc	1 321 27                        ; matmul_kernel.py:321:27
	s_mul_i32 s41, s34, s31
	s_add_i32 s41, s41, s22
	v_mad_u64_u32 v[130:131], s[10:11], v134, s31, v[128:129]
	v_mad_u64_u32 v[132:133], s[10:11], v136, s31, v[128:129]
	s_lshl_b32 s10, s21, 8
	s_and_b32 s10, s10, 0x600
	v_and_b32_e32 v131, 8, v138
	v_bfe_i32 v133, v138, 3, 1
	v_lshlrev_b32_e32 v135, 1, v131
	v_and_b32_e32 v141, 16, v138
	v_bfe_i32 v137, v138, 4, 1
	v_and_b32_e32 v137, 0x840, v137
	v_and_b32_e32 v142, 32, v138
	v_bfe_i32 v143, v138, 5, 1
	v_lshlrev_b32_e32 v142, 3, v142
	s_and_b32 s21, s37, 64
	s_bfe_i32 s11, s37, 0x10006
	s_movk_i32 s37, 0x1080
	s_and_b32 s11, s11, 0x1080
	v_lshl_or_b32 v139, v139, 5, s10
	v_bitop3_b32 v137, s11, v139, v137 bitop3:0x36
	v_add3_u32 v139, 0, v135, v137
	v_lshlrev_b32_e32 v135, 1, v140
	v_lshlrev_b32_e32 v137, 4, v138
	v_and_b32_e32 v144, 16, v137
	v_bfe_i32 v137, v138, 1, 1
	v_and_b32_e32 v137, 0x840, v137
	v_lshlrev_b32_e32 v145, 6, v138
	v_and_b32_e32 v145, 0x100, v145
	v_and_b32_e32 v133, 0x1080, v133
	s_movk_i32 s10, 0x260
	v_bitop3_b32 v135, v135, v137, s10 bitop3:0x6c
	v_or3_b32 v133, v133, v135, v145
	v_or_b32_e32 v146, v133, v144
	v_bitop3_b32 v147, v133, s39, v144 bitop3:0x36
	s_add_i32 s31, s42, s22
	s_mul_i32 s42, s33, s20
	v_mad_u64_u32 v[134:135], s[10:11], v134, s20, v[128:129]
	v_mad_u64_u32 v[136:137], s[10:11], v136, s20, v[128:129]
	v_and_b32_e32 v133, 6, v138
	v_lshlrev_b32_e32 v135, 10, v133
	v_lshlrev_b32_e32 v133, 5, v133
	v_lshlrev_b32_e32 v137, 2, v140
	v_and_b32_e32 v137, 0x660, v137
	s_lshl_b32 s10, s21, 1
	v_xor_b32_e32 v133, s10, v133
	v_xad_u32 v133, v133, v137, 0
	v_add3_u32 v144, v133, v135, v144
	v_lshlrev_b32_e32 v133, 5, v138
	v_and_b32_e32 v133, 0x60, v133
	s_lshl_b32 s10, s23, 3
	v_lshlrev_b32_e32 v131, 4, v131
	v_and_b32_e32 v135, 0x840, v143
	v_bitop3_b32 v133, s10, v135, v133 bitop3:0x36
	v_or3_b32 v131, v133, v131, v145
	v_or_b32_e32 v143, v131, v141
	v_bitop3_b32 v141, v131, s37, v141 bitop3:0x36
	s_or_b32 s39, s33, 0x80
	.loc	1 318 5                         ; matmul_kernel.py:318:5
	s_add_i32 s37, s22, s42
	v_bfrev_b32_e32 v131, 1
	s_mov_b32 s10, s26
	s_mov_b32 s11, s27
	v_add_u32_e32 v133, v139, v142
	v_add_u32_e32 v135, 0, v146
	v_add_u32_e32 v137, 0, v147
	v_add_u32_e32 v138, v144, v142
	v_add_u32_e32 v139, 0, v143
	v_add_u32_e32 v141, 0, v141
.LBB0_12:                               ; =>This Inner Loop Header: Depth=1
	.loc	1 319 19                        ; matmul_kernel.py:319:19
	v_or_b32_e32 v142, s40, v128
	.loc	1 321 27                        ; matmul_kernel.py:321:27
	s_add_i32 s22, s41, s40
	.loc	1 323 27                        ; matmul_kernel.py:323:27
	s_add_i32 s23, s31, s40
	s_add_i32 s42, s40, s37
	.loc	1 320 18                        ; matmul_kernel.py:320:18
	v_cmp_gt_i32_e64 s[20:21], s30, v142
	.loc	1 321 19                        ; matmul_kernel.py:321:19
	v_add_lshl_u32 v142, s22, v130, 1
	v_add_lshl_u32 v143, s22, v132, 1
	.loc	1 323 19                        ; matmul_kernel.py:323:19
	v_add_lshl_u32 v144, s23, v130, 1
	v_add_lshl_u32 v145, s23, v132, 1
	.loc	1 325 20                        ; matmul_kernel.py:325:20
	v_add_lshl_u32 v146, s42, v134, 1
	v_add_lshl_u32 v147, s42, v136, 1
	.loc	1 322 32                        ; matmul_kernel.py:322:32
	s_and_b64 s[22:23], vcc, s[20:21]
	.loc	1 321 19                        ; matmul_kernel.py:321:19
	v_cndmask_b32_e64 v142, v131, v142, s[22:23]
	.loc	1 322 32                        ; matmul_kernel.py:322:32
	s_and_b64 s[22:23], s[0:1], s[20:21]
	.loc	1 321 19                        ; matmul_kernel.py:321:19
	v_cndmask_b32_e64 v143, v131, v143, s[22:23]
	.loc	1 324 32                        ; matmul_kernel.py:324:32
	s_and_b64 s[22:23], s[2:3], s[20:21]
	.loc	1 323 19                        ; matmul_kernel.py:323:19
	v_cndmask_b32_e64 v150, v131, v144, s[22:23]
	.loc	1 324 32                        ; matmul_kernel.py:324:32
	s_and_b64 s[22:23], s[4:5], s[20:21]
	.loc	1 323 19                        ; matmul_kernel.py:323:19
	v_cndmask_b32_e64 v151, v131, v145, s[22:23]
	.loc	1 326 33                        ; matmul_kernel.py:326:33
	s_and_b64 s[22:23], s[6:7], s[20:21]
	.loc	1 325 20                        ; matmul_kernel.py:325:20
	v_cndmask_b32_e64 v166, v131, v146, s[22:23]
	.loc	1 326 33                        ; matmul_kernel.py:326:33
	s_and_b64 s[22:23], s[14:15], s[20:21]
	.loc	1 325 20                        ; matmul_kernel.py:325:20
	v_cndmask_b32_e64 v167, v131, v147, s[22:23]
	.loc	1 321 19                        ; matmul_kernel.py:321:19
	buffer_load_dwordx4 v[144:147], v142, s[8:11], 0 offen
	buffer_load_dwordx4 v[152:155], v143, s[8:11], 0 offen
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(1)
	ds_write_b128 v133, v[144:147]
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_read_b128 v[202:205], v135
	ds_read_b128 v[198:201], v135 offset:1024
	ds_read_b128 v[146:149], v137
	ds_read_b128 v[142:145], v137 offset:1024
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(0)
	ds_write_b128 v133, v[152:155]
	s_waitcnt lgkmcnt(0)
	s_barrier
	.loc	1 323 19                        ; matmul_kernel.py:323:19
	buffer_load_dwordx4 v[158:161], v150, s[8:11], 0 offen
	buffer_load_dwordx4 v[168:171], v151, s[8:11], 0 offen
	.loc	1 321 19                        ; matmul_kernel.py:321:19
	ds_read_b128 v[194:197], v135
	ds_read_b128 v[190:193], v135 offset:1024
	ds_read_b128 v[154:157], v137
	ds_read_b128 v[150:153], v137 offset:1024
	.loc	1 323 19                        ; matmul_kernel.py:323:19
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(1)
	ds_write_b128 v133, v[158:161]
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_read_b128 v[186:189], v135
	ds_read_b128 v[182:185], v135 offset:1024
	ds_read_b128 v[162:165], v137
	ds_read_b128 v[158:161], v137 offset:1024
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(0)
	ds_write_b128 v133, v[168:171]
	s_waitcnt lgkmcnt(0)
	s_barrier
	.loc	1 325 20                        ; matmul_kernel.py:325:20
	buffer_load_dwordx4 v[206:209], v166, s[24:27], 0 offen
	buffer_load_dwordx4 v[210:213], v167, s[24:27], 0 offen
	.loc	1 323 19                        ; matmul_kernel.py:323:19
	ds_read_b128 v[178:181], v135
	ds_read_b128 v[174:177], v135 offset:1024
	ds_read_b128 v[170:173], v137
	ds_read_b128 v[166:169], v137 offset:1024
	.loc	1 325 20                        ; matmul_kernel.py:325:20
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(1)
	ds_write_b128 v138, v[206:209]
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_read_b128 v[206:209], v139
	ds_read_b128 v[214:217], v141
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(0)
	ds_write_b128 v138, v[210:213]
	s_waitcnt lgkmcnt(0)
	s_barrier
	.loc	1 329 18                        ; matmul_kernel.py:329:18
	v_mfma_f32_16x16x32_f16 v[124:127], v[206:209], v[202:205], v[124:127]
	.loc	1 325 20                        ; matmul_kernel.py:325:20
	ds_read_b128 v[210:213], v139
	ds_read_b128 v[218:221], v141
	.loc	1 329 18                        ; matmul_kernel.py:329:18
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[120:123], v[210:213], v[202:205], v[120:123]
	v_mfma_f32_16x16x32_f16 v[116:119], v[206:209], v[198:201], v[116:119]
	v_mfma_f32_16x16x32_f16 v[112:115], v[210:213], v[198:201], v[112:115]
	v_mfma_f32_16x16x32_f16 v[108:111], v[206:209], v[194:197], v[108:111]
	v_mfma_f32_16x16x32_f16 v[104:107], v[210:213], v[194:197], v[104:107]
	v_mfma_f32_16x16x32_f16 v[100:103], v[206:209], v[190:193], v[100:103]
	v_mfma_f32_16x16x32_f16 v[96:99], v[210:213], v[190:193], v[96:99]
	.loc	1 330 18                        ; matmul_kernel.py:330:18
	v_mfma_f32_16x16x32_f16 v[76:79], v[206:209], v[186:189], v[76:79]
	v_mfma_f32_16x16x32_f16 v[68:71], v[210:213], v[186:189], v[68:71]
	v_mfma_f32_16x16x32_f16 v[60:63], v[206:209], v[182:185], v[60:63]
	v_mfma_f32_16x16x32_f16 v[56:59], v[210:213], v[182:185], v[56:59]
	v_mfma_f32_16x16x32_f16 v[48:51], v[206:209], v[178:181], v[48:51]
	v_mfma_f32_16x16x32_f16 v[40:43], v[210:213], v[178:181], v[40:43]
	v_mfma_f32_16x16x32_f16 v[36:39], v[206:209], v[174:177], v[36:39]
	v_mfma_f32_16x16x32_f16 v[32:35], v[210:213], v[174:177], v[32:35]
	.loc	1 329 18                        ; matmul_kernel.py:329:18
	v_mfma_f32_16x16x32_f16 v[124:127], v[214:217], v[146:149], v[124:127]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[120:123], v[218:221], v[146:149], v[120:123]
	v_mfma_f32_16x16x32_f16 v[116:119], v[214:217], v[142:145], v[116:119]
	v_mfma_f32_16x16x32_f16 v[112:115], v[218:221], v[142:145], v[112:115]
	v_mfma_f32_16x16x32_f16 v[108:111], v[214:217], v[154:157], v[108:111]
	v_mfma_f32_16x16x32_f16 v[104:107], v[218:221], v[154:157], v[104:107]
	v_mfma_f32_16x16x32_f16 v[100:103], v[214:217], v[150:153], v[100:103]
	v_mfma_f32_16x16x32_f16 v[96:99], v[218:221], v[150:153], v[96:99]
	.loc	1 330 18                        ; matmul_kernel.py:330:18
	v_mfma_f32_16x16x32_f16 v[76:79], v[214:217], v[162:165], v[76:79]
	v_mfma_f32_16x16x32_f16 v[68:71], v[218:221], v[162:165], v[68:71]
	v_mfma_f32_16x16x32_f16 v[60:63], v[214:217], v[158:161], v[60:63]
	.loc	1 327 29                        ; matmul_kernel.py:327:29
	s_add_i32 s42, s42, s36
	.loc	1 330 18                        ; matmul_kernel.py:330:18
	v_mfma_f32_16x16x32_f16 v[56:59], v[218:221], v[158:161], v[56:59]
	.loc	1 327 21                        ; matmul_kernel.py:327:21
	v_add_lshl_u32 v206, s42, v136, 1
	.loc	1 328 34                        ; matmul_kernel.py:328:34
	s_and_b64 s[22:23], s[18:19], s[20:21]
	.loc	1 327 21                        ; matmul_kernel.py:327:21
	v_add_lshl_u32 v207, s42, v134, 1
	.loc	1 330 18                        ; matmul_kernel.py:330:18
	v_mfma_f32_16x16x32_f16 v[48:51], v[214:217], v[170:173], v[48:51]
	.loc	1 328 34                        ; matmul_kernel.py:328:34
	s_and_b64 s[20:21], s[16:17], s[20:21]
	.loc	1 327 21                        ; matmul_kernel.py:327:21
	v_cndmask_b32_e64 v207, v131, v207, s[20:21]
	v_cndmask_b32_e64 v206, v131, v206, s[22:23]
	.loc	1 330 18                        ; matmul_kernel.py:330:18
	v_mfma_f32_16x16x32_f16 v[40:43], v[218:221], v[170:173], v[40:43]
	.loc	1 327 21                        ; matmul_kernel.py:327:21
	buffer_load_dwordx4 v[208:211], v207, s[24:27], 0 offen
	.loc	1 330 18                        ; matmul_kernel.py:330:18
	v_mfma_f32_16x16x32_f16 v[36:39], v[214:217], v[166:169], v[36:39]
	.loc	1 327 21                        ; matmul_kernel.py:327:21
	buffer_load_dwordx4 v[212:215], v206, s[24:27], 0 offen
	s_waitcnt lgkmcnt(0)
	s_barrier
	.loc	1 330 18                        ; matmul_kernel.py:330:18
	v_mfma_f32_16x16x32_f16 v[32:35], v[218:221], v[166:169], v[32:35]
	.loc	1 327 21                        ; matmul_kernel.py:327:21
	s_waitcnt vmcnt(1)
	ds_write_b128 v138, v[208:211]
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_read_b128 v[206:209], v139
	ds_read_b128 v[216:219], v141
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(0)
	ds_write_b128 v138, v[212:215]
	s_waitcnt lgkmcnt(0)
	s_barrier
	.loc	1 331 18                        ; matmul_kernel.py:331:18
	v_mfma_f32_16x16x32_f16 v[92:95], v[206:209], v[202:205], v[92:95]
	.loc	1 327 21                        ; matmul_kernel.py:327:21
	ds_read_b128 v[210:213], v139
	ds_read_b128 v[220:223], v141
	.loc	1 331 18                        ; matmul_kernel.py:331:18
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_f16 v[88:91], v[210:213], v[202:205], v[88:91]
	v_mfma_f32_16x16x32_f16 v[84:87], v[206:209], v[198:201], v[84:87]
	v_mfma_f32_16x16x32_f16 v[80:83], v[210:213], v[198:201], v[80:83]
	v_mfma_f32_16x16x32_f16 v[72:75], v[206:209], v[194:197], v[72:75]
	v_mfma_f32_16x16x32_f16 v[64:67], v[210:213], v[194:197], v[64:67]
	v_mfma_f32_16x16x32_f16 v[52:55], v[206:209], v[190:193], v[52:55]
	v_mfma_f32_16x16x32_f16 v[44:47], v[210:213], v[190:193], v[44:47]
	.loc	1 332 18                        ; matmul_kernel.py:332:18
	v_mfma_f32_16x16x32_f16 v[28:31], v[206:209], v[186:189], v[28:31]
	v_mfma_f32_16x16x32_f16 v[24:27], v[210:213], v[186:189], v[24:27]
	v_mfma_f32_16x16x32_f16 v[20:23], v[206:209], v[182:185], v[20:23]
	v_mfma_f32_16x16x32_f16 v[16:19], v[210:213], v[182:185], v[16:19]
	v_mfma_f32_16x16x32_f16 v[12:15], v[206:209], v[178:181], v[12:15]
	v_mfma_f32_16x16x32_f16 v[8:11], v[210:213], v[178:181], v[8:11]
	v_mfma_f32_16x16x32_f16 v[4:7], v[206:209], v[174:177], v[4:7]
	v_mfma_f32_16x16x32_f16 v[0:3], v[210:213], v[174:177], v[0:3]
	.loc	1 331 18                        ; matmul_kernel.py:331:18
	v_mfma_f32_16x16x32_f16 v[92:95], v[216:219], v[146:149], v[92:95]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_f16 v[88:91], v[220:223], v[146:149], v[88:91]
	v_mfma_f32_16x16x32_f16 v[84:87], v[216:219], v[142:145], v[84:87]
	v_mfma_f32_16x16x32_f16 v[80:83], v[220:223], v[142:145], v[80:83]
	v_mfma_f32_16x16x32_f16 v[72:75], v[216:219], v[154:157], v[72:75]
	v_mfma_f32_16x16x32_f16 v[64:67], v[220:223], v[154:157], v[64:67]
	v_mfma_f32_16x16x32_f16 v[52:55], v[216:219], v[150:153], v[52:55]
	v_mfma_f32_16x16x32_f16 v[44:47], v[220:223], v[150:153], v[44:47]
	.loc	1 332 18                        ; matmul_kernel.py:332:18
	v_mfma_f32_16x16x32_f16 v[28:31], v[216:219], v[162:165], v[28:31]
	v_mfma_f32_16x16x32_f16 v[24:27], v[220:223], v[162:165], v[24:27]
	v_mfma_f32_16x16x32_f16 v[20:23], v[216:219], v[158:161], v[20:23]
	v_mfma_f32_16x16x32_f16 v[16:19], v[220:223], v[158:161], v[16:19]
	v_mfma_f32_16x16x32_f16 v[12:15], v[216:219], v[170:173], v[12:15]
	v_mfma_f32_16x16x32_f16 v[8:11], v[220:223], v[170:173], v[8:11]
	v_mfma_f32_16x16x32_f16 v[4:7], v[216:219], v[166:169], v[4:7]
	v_mfma_f32_16x16x32_f16 v[0:3], v[220:223], v[166:169], v[0:3]
	.loc	1 318 5                         ; matmul_kernel.py:318:5
	s_add_i32 s40, s40, 64
	s_cmp_lt_i32 s40, s30
	s_cbranch_scc1 .LBB0_12
.LBB0_13:                               ; %._crit_edge778
	.loc	1 148 33                        ; matmul_kernel.py:148:33
	v_lshrrev_b32_e32 v128, 2, v140
	v_and_b32_e32 v128, 60, v128
	v_or_b32_e32 v130, 64, v128
	.loc	1 149 15                        ; matmul_kernel.py:149:15
	v_or_b32_e32 v131, s33, v130
	.loc	1 317 21                        ; matmul_kernel.py:317:21
	v_or_b32_e32 v132, 0x80, v131
	.loc	1 149 15                        ; matmul_kernel.py:149:15
	v_or_b32_e32 v133, s33, v128
	.loc	1 317 21                        ; matmul_kernel.py:317:21
	v_or_b32_e32 v134, 0x80, v133
	.loc	1 148 33                        ; matmul_kernel.py:148:33
	s_lshr_b32 s0, s35, 4
	v_or_b32_e32 v129, s0, v129
	v_or_b32_e32 v135, 0x60, v129
	.loc	1 148 15 is_stmt 0              ; matmul_kernel.py:148:15
	v_or_b32_e32 v136, s34, v135
	.loc	1 316 19 is_stmt 1              ; matmul_kernel.py:316:19
	v_or_b32_e32 v137, 0x80, v136
	.loc	1 148 33                        ; matmul_kernel.py:148:33
	v_or_b32_e32 v138, 64, v129
	.loc	1 148 15 is_stmt 0              ; matmul_kernel.py:148:15
	v_or_b32_e32 v139, s34, v138
	.loc	1 316 19 is_stmt 1              ; matmul_kernel.py:316:19
	v_or_b32_e32 v140, 0x80, v139
	.loc	1 148 33                        ; matmul_kernel.py:148:33
	v_or_b32_e32 v141, 32, v129
	.loc	1 148 15 is_stmt 0              ; matmul_kernel.py:148:15
	v_or_b32_e32 v142, s34, v141
	.loc	1 316 19 is_stmt 1              ; matmul_kernel.py:316:19
	v_or_b32_e32 v143, 0x80, v142
	.loc	1 148 15                        ; matmul_kernel.py:148:15
	v_or_b32_e32 v144, s34, v129
	.loc	1 316 19                        ; matmul_kernel.py:316:19
	v_or_b32_e32 v145, 0x80, v144
	.loc	1 338 13                        ; matmul_kernel.py:338:13
	v_cmp_gt_i32_e64 s[20:21], s28, v144
	v_cmp_gt_i32_e64 s[18:19], s28, v142
	v_cmp_gt_i32_e64 s[16:17], s28, v139
	v_cmp_gt_i32_e64 s[10:11], s28, v136
	.loc	1 339 13                        ; matmul_kernel.py:339:13
	v_cmp_gt_i32_e64 s[8:9], s28, v145
	v_cmp_gt_i32_e64 s[6:7], s28, v143
	v_cmp_gt_i32_e64 s[4:5], s28, v140
	v_cmp_gt_i32_e32 vcc, s28, v137
	.loc	1 340 14                        ; matmul_kernel.py:340:14
	v_cmp_gt_i32_e64 s[24:25], s29, v133
	v_cmp_gt_i32_e64 s[22:23], s29, v131
	.loc	1 341 15                        ; matmul_kernel.py:341:15
	v_cmp_gt_i32_e64 s[2:3], s29, v134
	v_cmp_gt_i32_e64 s[0:1], s29, v132
	.loc	1 346 18                        ; matmul_kernel.py:346:18
	s_mul_i32 s28, s34, s38
	v_mul_lo_u32 v129, v129, s38
	v_mul_lo_u32 v131, v141, s38
	v_mul_lo_u32 v132, v138, s38
	v_mul_lo_u32 v133, v135, s38
	s_add_i32 s29, s28, s33
	v_add_u32_e32 v134, v129, v128
	v_add_u32_e32 v129, v129, v130
	v_add_u32_e32 v135, v131, v128
	v_add_u32_e32 v131, v131, v130
	v_add_u32_e32 v136, v132, v128
	v_add_u32_e32 v132, v132, v130
	v_add_u32_e32 v128, v133, v128
	v_add_u32_e32 v130, v133, v130
	.loc	1 346 96 is_stmt 0              ; matmul_kernel.py:346:96
	v_cvt_pk_f16_f32 v124, v124, v125
	v_cvt_pk_f16_f32 v125, v126, v127
	v_cvt_pk_f16_f32 v120, v120, v121
	v_cvt_pk_f16_f32 v121, v122, v123
	v_cvt_pk_f16_f32 v116, v116, v117
	v_cvt_pk_f16_f32 v117, v118, v119
	v_cvt_pk_f16_f32 v112, v112, v113
	v_cvt_pk_f16_f32 v113, v114, v115
	v_cvt_pk_f16_f32 v108, v108, v109
	v_cvt_pk_f16_f32 v109, v110, v111
	v_cvt_pk_f16_f32 v104, v104, v105
	v_cvt_pk_f16_f32 v105, v106, v107
	v_cvt_pk_f16_f32 v100, v100, v101
	v_cvt_pk_f16_f32 v101, v102, v103
	v_cvt_pk_f16_f32 v96, v96, v97
	v_cvt_pk_f16_f32 v97, v98, v99
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	s_and_b32 s13, s13, 0xffff
	s_mov_b32 s15, 0x27000
	s_mov_b32 s14, 0x7ffffffe
	v_add_lshl_u32 v98, v134, s29, 1
	v_bfrev_b32_e32 v99, 1
	.loc	1 347 23 is_stmt 1              ; matmul_kernel.py:347:23
	s_and_b64 s[26:27], s[20:21], s[24:25]
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	v_cndmask_b32_e64 v98, v99, v98, s[26:27]
	buffer_store_dwordx2 v[124:125], v98, s[12:15], 0 offen
	v_add_lshl_u32 v98, v129, s29, 1
	.loc	1 347 23                        ; matmul_kernel.py:347:23
	s_and_b64 s[26:27], s[20:21], s[22:23]
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	v_cndmask_b32_e64 v98, v99, v98, s[26:27]
	buffer_store_dwordx2 v[120:121], v98, s[12:15], 0 offen
	v_add_lshl_u32 v98, v135, s29, 1
	.loc	1 347 23                        ; matmul_kernel.py:347:23
	s_and_b64 s[26:27], s[24:25], s[18:19]
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	v_cndmask_b32_e64 v98, v99, v98, s[26:27]
	buffer_store_dwordx2 v[116:117], v98, s[12:15], 0 offen
	v_add_lshl_u32 v98, v131, s29, 1
	.loc	1 347 23                        ; matmul_kernel.py:347:23
	s_and_b64 s[26:27], s[18:19], s[22:23]
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	v_cndmask_b32_e64 v98, v99, v98, s[26:27]
	buffer_store_dwordx2 v[112:113], v98, s[12:15], 0 offen
	v_add_lshl_u32 v98, v136, s29, 1
	.loc	1 347 23                        ; matmul_kernel.py:347:23
	s_and_b64 s[26:27], s[24:25], s[16:17]
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	v_cndmask_b32_e64 v98, v99, v98, s[26:27]
	buffer_store_dwordx2 v[108:109], v98, s[12:15], 0 offen
	v_add_lshl_u32 v98, v132, s29, 1
	.loc	1 347 23                        ; matmul_kernel.py:347:23
	s_and_b64 s[26:27], s[16:17], s[22:23]
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	v_cndmask_b32_e64 v98, v99, v98, s[26:27]
	buffer_store_dwordx2 v[104:105], v98, s[12:15], 0 offen
	v_add_lshl_u32 v98, v128, s29, 1
	.loc	1 347 23                        ; matmul_kernel.py:347:23
	s_and_b64 s[26:27], s[24:25], s[10:11]
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	v_cndmask_b32_e64 v98, v99, v98, s[26:27]
	buffer_store_dwordx2 v[100:101], v98, s[12:15], 0 offen
	v_add_lshl_u32 v98, v130, s29, 1
	.loc	1 347 23                        ; matmul_kernel.py:347:23
	s_and_b64 s[26:27], s[10:11], s[22:23]
	.loc	1 346 9                         ; matmul_kernel.py:346:9
	v_cndmask_b32_e64 v98, v99, v98, s[26:27]
	buffer_store_dwordx2 v[96:97], v98, s[12:15], 0 offen
	.loc	1 348 18                        ; matmul_kernel.py:348:18
	s_lshl_b32 s26, s38, 7
	s_add_i32 s28, s28, s26
	s_add_i32 s30, s28, s33
	.loc	1 348 96 is_stmt 0              ; matmul_kernel.py:348:96
	v_cvt_pk_f16_f32 v76, v76, v77
	v_cvt_pk_f16_f32 v77, v78, v79
	v_cvt_pk_f16_f32 v68, v68, v69
	v_cvt_pk_f16_f32 v69, v70, v71
	v_cvt_pk_f16_f32 v60, v60, v61
	v_cvt_pk_f16_f32 v61, v62, v63
	v_cvt_pk_f16_f32 v56, v56, v57
	v_cvt_pk_f16_f32 v57, v58, v59
	v_cvt_pk_f16_f32 v48, v48, v49
	v_cvt_pk_f16_f32 v49, v50, v51
	v_cvt_pk_f16_f32 v40, v40, v41
	v_cvt_pk_f16_f32 v41, v42, v43
	v_cvt_pk_f16_f32 v36, v36, v37
	v_cvt_pk_f16_f32 v37, v38, v39
	v_cvt_pk_f16_f32 v32, v32, v33
	v_cvt_pk_f16_f32 v33, v34, v35
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_add_lshl_u32 v34, s30, v134, 1
	.loc	1 349 23 is_stmt 1              ; matmul_kernel.py:349:23
	s_and_b64 s[26:27], s[24:25], s[8:9]
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_cndmask_b32_e64 v34, v99, v34, s[26:27]
	buffer_store_dwordx2 v[76:77], v34, s[12:15], 0 offen
	v_add_lshl_u32 v34, s30, v129, 1
	.loc	1 349 23                        ; matmul_kernel.py:349:23
	s_and_b64 s[26:27], s[8:9], s[22:23]
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_cndmask_b32_e64 v34, v99, v34, s[26:27]
	buffer_store_dwordx2 v[68:69], v34, s[12:15], 0 offen
	v_add_lshl_u32 v34, v135, s30, 1
	.loc	1 349 23                        ; matmul_kernel.py:349:23
	s_and_b64 s[26:27], s[24:25], s[6:7]
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_cndmask_b32_e64 v34, v99, v34, s[26:27]
	buffer_store_dwordx2 v[60:61], v34, s[12:15], 0 offen
	v_add_lshl_u32 v34, v131, s30, 1
	.loc	1 349 23                        ; matmul_kernel.py:349:23
	s_and_b64 s[26:27], s[22:23], s[6:7]
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_cndmask_b32_e64 v34, v99, v34, s[26:27]
	buffer_store_dwordx2 v[56:57], v34, s[12:15], 0 offen
	v_add_lshl_u32 v34, v136, s30, 1
	.loc	1 349 23                        ; matmul_kernel.py:349:23
	s_and_b64 s[26:27], s[24:25], s[4:5]
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_cndmask_b32_e64 v34, v99, v34, s[26:27]
	buffer_store_dwordx2 v[48:49], v34, s[12:15], 0 offen
	v_add_lshl_u32 v34, v132, s30, 1
	.loc	1 349 23                        ; matmul_kernel.py:349:23
	s_and_b64 s[26:27], s[22:23], s[4:5]
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_cndmask_b32_e64 v34, v99, v34, s[26:27]
	buffer_store_dwordx2 v[40:41], v34, s[12:15], 0 offen
	v_add_lshl_u32 v34, v128, s30, 1
	.loc	1 349 23                        ; matmul_kernel.py:349:23
	s_and_b64 s[24:25], s[24:25], vcc
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_cndmask_b32_e64 v34, v99, v34, s[24:25]
	buffer_store_dwordx2 v[36:37], v34, s[12:15], 0 offen
	v_add_lshl_u32 v34, v130, s30, 1
	.loc	1 349 23                        ; matmul_kernel.py:349:23
	s_and_b64 s[22:23], s[22:23], vcc
	.loc	1 348 9                         ; matmul_kernel.py:348:9
	v_cndmask_b32_e64 v34, v99, v34, s[22:23]
	buffer_store_dwordx2 v[32:33], v34, s[12:15], 0 offen
	.loc	1 350 18                        ; matmul_kernel.py:350:18
	s_addk_i32 s29, 0x80
	.loc	1 350 97 is_stmt 0              ; matmul_kernel.py:350:97
	v_cvt_pk_f16_f32 v32, v92, v93
	v_cvt_pk_f16_f32 v33, v94, v95
	v_cvt_pk_f16_f32 v34, v88, v89
	v_cvt_pk_f16_f32 v35, v90, v91
	v_cvt_pk_f16_f32 v36, v84, v85
	v_cvt_pk_f16_f32 v37, v86, v87
	v_cvt_pk_f16_f32 v38, v80, v81
	v_cvt_pk_f16_f32 v39, v82, v83
	v_cvt_pk_f16_f32 v40, v72, v73
	v_cvt_pk_f16_f32 v41, v74, v75
	v_cvt_pk_f16_f32 v42, v64, v65
	v_cvt_pk_f16_f32 v43, v66, v67
	v_cvt_pk_f16_f32 v48, v52, v53
	v_cvt_pk_f16_f32 v49, v54, v55
	v_cvt_pk_f16_f32 v44, v44, v45
	v_cvt_pk_f16_f32 v45, v46, v47
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_add_lshl_u32 v46, v134, s29, 1
	.loc	1 351 23 is_stmt 1              ; matmul_kernel.py:351:23
	s_and_b64 s[22:23], s[20:21], s[2:3]
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_cndmask_b32_e64 v46, v99, v46, s[22:23]
	buffer_store_dwordx2 v[32:33], v46, s[12:15], 0 offen
	v_add_lshl_u32 v32, v129, s29, 1
	.loc	1 351 23                        ; matmul_kernel.py:351:23
	s_and_b64 s[20:21], s[20:21], s[0:1]
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_cndmask_b32_e64 v32, v99, v32, s[20:21]
	buffer_store_dwordx2 v[34:35], v32, s[12:15], 0 offen
	v_add_lshl_u32 v32, v135, s29, 1
	.loc	1 351 23                        ; matmul_kernel.py:351:23
	s_and_b64 s[20:21], s[18:19], s[2:3]
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_cndmask_b32_e64 v32, v99, v32, s[20:21]
	buffer_store_dwordx2 v[36:37], v32, s[12:15], 0 offen
	v_add_lshl_u32 v32, v131, s29, 1
	.loc	1 351 23                        ; matmul_kernel.py:351:23
	s_and_b64 s[18:19], s[18:19], s[0:1]
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_cndmask_b32_e64 v32, v99, v32, s[18:19]
	buffer_store_dwordx2 v[38:39], v32, s[12:15], 0 offen
	v_add_lshl_u32 v32, v136, s29, 1
	.loc	1 351 23                        ; matmul_kernel.py:351:23
	s_and_b64 s[18:19], s[16:17], s[2:3]
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_cndmask_b32_e64 v32, v99, v32, s[18:19]
	buffer_store_dwordx2 v[40:41], v32, s[12:15], 0 offen
	v_add_lshl_u32 v32, v132, s29, 1
	.loc	1 351 23                        ; matmul_kernel.py:351:23
	s_and_b64 s[16:17], s[16:17], s[0:1]
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_cndmask_b32_e64 v32, v99, v32, s[16:17]
	buffer_store_dwordx2 v[42:43], v32, s[12:15], 0 offen
	v_add_lshl_u32 v32, v128, s29, 1
	.loc	1 351 23                        ; matmul_kernel.py:351:23
	s_and_b64 s[16:17], s[10:11], s[2:3]
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_cndmask_b32_e64 v32, v99, v32, s[16:17]
	buffer_store_dwordx2 v[48:49], v32, s[12:15], 0 offen
	v_add_lshl_u32 v32, v130, s29, 1
	.loc	1 351 23                        ; matmul_kernel.py:351:23
	s_and_b64 s[10:11], s[10:11], s[0:1]
	.loc	1 350 9                         ; matmul_kernel.py:350:9
	v_cndmask_b32_e64 v32, v99, v32, s[10:11]
	buffer_store_dwordx2 v[44:45], v32, s[12:15], 0 offen
	.loc	1 352 18                        ; matmul_kernel.py:352:18
	s_add_i32 s28, s28, s39
	.loc	1 352 97 is_stmt 0              ; matmul_kernel.py:352:97
	v_cvt_pk_f16_f32 v28, v28, v29
	v_cvt_pk_f16_f32 v29, v30, v31
	v_cvt_pk_f16_f32 v24, v24, v25
	v_cvt_pk_f16_f32 v25, v26, v27
	v_cvt_pk_f16_f32 v20, v20, v21
	v_cvt_pk_f16_f32 v21, v22, v23
	v_cvt_pk_f16_f32 v16, v16, v17
	v_cvt_pk_f16_f32 v17, v18, v19
	v_cvt_pk_f16_f32 v12, v12, v13
	v_cvt_pk_f16_f32 v13, v14, v15
	v_cvt_pk_f16_f32 v8, v8, v9
	v_cvt_pk_f16_f32 v9, v10, v11
	v_cvt_pk_f16_f32 v4, v4, v5
	v_cvt_pk_f16_f32 v5, v6, v7
	v_cvt_pk_f16_f32 v0, v0, v1
	v_cvt_pk_f16_f32 v1, v2, v3
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_add_lshl_u32 v2, s28, v134, 1
	.loc	1 353 23 is_stmt 1              ; matmul_kernel.py:353:23
	s_and_b64 s[10:11], s[8:9], s[2:3]
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_cndmask_b32_e64 v2, v99, v2, s[10:11]
	buffer_store_dwordx2 v[28:29], v2, s[12:15], 0 offen
	v_add_lshl_u32 v2, s28, v129, 1
	.loc	1 353 23                        ; matmul_kernel.py:353:23
	s_and_b64 s[8:9], s[8:9], s[0:1]
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_cndmask_b32_e64 v2, v99, v2, s[8:9]
	buffer_store_dwordx2 v[24:25], v2, s[12:15], 0 offen
	v_add_lshl_u32 v2, v135, s28, 1
	.loc	1 353 23                        ; matmul_kernel.py:353:23
	s_and_b64 s[8:9], s[2:3], s[6:7]
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_cndmask_b32_e64 v2, v99, v2, s[8:9]
	buffer_store_dwordx2 v[20:21], v2, s[12:15], 0 offen
	v_add_lshl_u32 v2, v131, s28, 1
	.loc	1 353 23                        ; matmul_kernel.py:353:23
	s_and_b64 s[6:7], s[6:7], s[0:1]
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_cndmask_b32_e64 v2, v99, v2, s[6:7]
	buffer_store_dwordx2 v[16:17], v2, s[12:15], 0 offen
	v_add_lshl_u32 v2, v136, s28, 1
	.loc	1 353 23                        ; matmul_kernel.py:353:23
	s_and_b64 s[6:7], s[2:3], s[4:5]
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_cndmask_b32_e64 v2, v99, v2, s[6:7]
	buffer_store_dwordx2 v[12:13], v2, s[12:15], 0 offen
	v_add_lshl_u32 v2, v132, s28, 1
	.loc	1 353 23                        ; matmul_kernel.py:353:23
	s_and_b64 s[4:5], s[4:5], s[0:1]
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_cndmask_b32_e64 v2, v99, v2, s[4:5]
	buffer_store_dwordx2 v[8:9], v2, s[12:15], 0 offen
	v_add_lshl_u32 v2, v128, s28, 1
	.loc	1 353 23                        ; matmul_kernel.py:353:23
	s_and_b64 s[2:3], s[2:3], vcc
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_cndmask_b32_e64 v2, v99, v2, s[2:3]
	buffer_store_dwordx2 v[4:5], v2, s[12:15], 0 offen
	v_add_lshl_u32 v2, v130, s28, 1
	.loc	1 353 23                        ; matmul_kernel.py:353:23
	s_and_b64 vcc, vcc, s[0:1]
	.loc	1 352 9                         ; matmul_kernel.py:352:9
	v_cndmask_b32_e32 v2, v99, v2, vcc
	buffer_store_dwordx2 v[0:1], v2, s[12:15], 0 offen
	.loc	1 49 1                          ; matmul_kernel.py:49:1
	s_endpgm
.Ltmp5:
.Lfunc_end0:
	.size	a16w16_8wave, .Lfunc_end0-a16w16_8wave
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel a16w16_8wave
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 336
		.amdhsa_user_sgpr_count 16
		.amdhsa_user_sgpr_dispatch_ptr 1
		.amdhsa_user_sgpr_queue_ptr 1
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 1
		.amdhsa_user_sgpr_kernarg_preload_length 8
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 1
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 2
		.amdhsa_next_free_vgpr 246
		.amdhsa_next_free_sgpr 46
		.amdhsa_accum_offset 248
		.amdhsa_reserve_vcc 1
		.amdhsa_reserve_xnack_mask 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_tg_split 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text
                                        ; -- End function
	.set .La16w16_8wave.num_vgpr, 246
	.set .La16w16_8wave.num_agpr, 0
	.set .La16w16_8wave.numbered_sgpr, 46
	.set .La16w16_8wave.num_named_barrier, 0
	.set .La16w16_8wave.private_seg_size, 0
	.set .La16w16_8wave.uses_vcc, 1
	.set .La16w16_8wave.uses_flat_scratch, 0
	.set .La16w16_8wave.has_dyn_sized_stack, 0
	.set .La16w16_8wave.has_recursion, 0
	.set .La16w16_8wave.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 9720
; TotalNumSgprs: 52
; NumVgprs: 246
; NumAgprs: 0
; TotalNumVgprs: 246
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 6
; VGPRBlocks: 30
; NumSGPRsForWavesPerEU: 52
; NumVGPRsForWavesPerEU: 246
; AccumOffset: 248
; Occupancy: 2
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 16
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 1
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 2
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 61
; COMPUTE_PGM_RSRC3_GFX90A:TG_SPLIT: 0
	.text
	.p2alignl 6, 3212836864
	.fill 256, 4, 3212836864
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.set amdgpu.max_num_named_barrier, 0
	.text
	.section	.debug_abbrev,"",@progbits
	.byte	1                               ; Abbreviation Code
	.byte	17                              ; DW_TAG_compile_unit
	.byte	1                               ; DW_CHILDREN_yes
	.byte	37                              ; DW_AT_producer
	.byte	14                              ; DW_FORM_strp
	.byte	19                              ; DW_AT_language
	.byte	5                               ; DW_FORM_data2
	.byte	3                               ; DW_AT_name
	.byte	14                              ; DW_FORM_strp
	.byte	16                              ; DW_AT_stmt_list
	.byte	23                              ; DW_FORM_sec_offset
	.byte	27                              ; DW_AT_comp_dir
	.byte	14                              ; DW_FORM_strp
	.byte	17                              ; DW_AT_low_pc
	.byte	1                               ; DW_FORM_addr
	.byte	18                              ; DW_AT_high_pc
	.byte	6                               ; DW_FORM_data4
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	2                               ; Abbreviation Code
	.byte	46                              ; DW_TAG_subprogram
	.byte	0                               ; DW_CHILDREN_no
	.byte	3                               ; DW_AT_name
	.byte	14                              ; DW_FORM_strp
	.byte	32                              ; DW_AT_inline
	.byte	11                              ; DW_FORM_data1
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	3                               ; Abbreviation Code
	.byte	46                              ; DW_TAG_subprogram
	.byte	1                               ; DW_CHILDREN_yes
	.byte	17                              ; DW_AT_low_pc
	.byte	1                               ; DW_FORM_addr
	.byte	18                              ; DW_AT_high_pc
	.byte	6                               ; DW_FORM_data4
	.byte	49                              ; DW_AT_abstract_origin
	.byte	19                              ; DW_FORM_ref4
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	4                               ; Abbreviation Code
	.byte	29                              ; DW_TAG_inlined_subroutine
	.byte	0                               ; DW_CHILDREN_no
	.byte	49                              ; DW_AT_abstract_origin
	.byte	19                              ; DW_FORM_ref4
	.byte	17                              ; DW_AT_low_pc
	.byte	1                               ; DW_FORM_addr
	.byte	18                              ; DW_AT_high_pc
	.byte	6                               ; DW_FORM_data4
	.byte	88                              ; DW_AT_call_file
	.byte	11                              ; DW_FORM_data1
	.byte	89                              ; DW_AT_call_line
	.byte	11                              ; DW_FORM_data1
	.byte	87                              ; DW_AT_call_column
	.byte	11                              ; DW_FORM_data1
	.byte	0                               ; EOM(1)
	.byte	0                               ; EOM(2)
	.byte	0                               ; EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 ; Length of Unit
.Ldebug_info_start0:
	.short	4                               ; DWARF version number
	.long	.debug_abbrev                   ; Offset Into Abbrev. Section
	.byte	8                               ; Address Size (in bytes)
	.byte	1                               ; Abbrev [1] 0xb:0x60 DW_TAG_compile_unit
	.long	.Linfo_string0                  ; DW_AT_producer
	.short	2                               ; DW_AT_language
	.long	.Linfo_string1                  ; DW_AT_name
	.long	.Lline_table_start0             ; DW_AT_stmt_list
	.long	.Linfo_string2                  ; DW_AT_comp_dir
	.quad	.Lfunc_begin0                   ; DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       ; DW_AT_high_pc
	.byte	2                               ; Abbrev [2] 0x2a:0x6 DW_TAG_subprogram
	.long	.Linfo_string3                  ; DW_AT_name
	.byte	1                               ; DW_AT_inline
	.byte	3                               ; Abbrev [3] 0x30:0x3a DW_TAG_subprogram
	.quad	.Lfunc_begin0                   ; DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       ; DW_AT_high_pc
	.long	42                              ; DW_AT_abstract_origin
	.byte	4                               ; Abbrev [4] 0x41:0x14 DW_TAG_inlined_subroutine
	.long	42                              ; DW_AT_abstract_origin
	.quad	.Ltmp2                          ; DW_AT_low_pc
	.long	.Ltmp3-.Ltmp2                   ; DW_AT_high_pc
	.byte	1                               ; DW_AT_call_file
	.byte	90                              ; DW_AT_call_line
	.byte	17                              ; DW_AT_call_column
	.byte	4                               ; Abbrev [4] 0x55:0x14 DW_TAG_inlined_subroutine
	.long	42                              ; DW_AT_abstract_origin
	.quad	.Ltmp3                          ; DW_AT_low_pc
	.long	.Ltmp4-.Ltmp3                   ; DW_AT_high_pc
	.byte	1                               ; DW_AT_call_file
	.byte	91                              ; DW_AT_call_line
	.byte	17                              ; DW_AT_call_column
	.byte	0                               ; End Of Children Mark
	.byte	0                               ; End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"triton"                        ; string offset=0 ; triton
.Linfo_string1:
	.asciz	"matmul_kernel.py"              ; string offset=7 ; matmul_kernel.py
.Linfo_string2:
	.asciz	"/home/ibutygin/tlx-950/triton/third_party/tlx/tutorials/gfx9_gemm/inter_wave/a16w16" ; string offset=24 ; /home/ibutygin/tlx-950/triton/third_party/tlx/tutorials/gfx9_gemm/inter_wave/a16w16
.Linfo_string3:
	.asciz	"a16w16_8wave"                  ; string offset=108 ; a16w16_8wave
	.section	".note.GNU-stack","",@progbits
	.amdgpu_metadata
---
amdhsa.kernels:
  - .agpr_count:     0
    .args:
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .offset:         32
        .size:           4
        .value_kind:     by_value
      - .offset:         36
        .size:           4
        .value_kind:     by_value
      - .offset:         40
        .size:           4
        .value_kind:     by_value
      - .offset:         44
        .size:           4
        .value_kind:     by_value
      - .offset:         48
        .size:           4
        .value_kind:     by_value
      - .offset:         52
        .size:           4
        .value_kind:     by_value
      - .offset:         56
        .size:           4
        .value_kind:     by_value
      - .address_space:  global
        .offset:         64
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         72
        .size:           8
        .value_kind:     global_buffer
      - .offset:         80
        .size:           4
        .value_kind:     hidden_block_count_x
      - .offset:         84
        .size:           4
        .value_kind:     hidden_block_count_y
      - .offset:         88
        .size:           4
        .value_kind:     hidden_block_count_z
      - .offset:         92
        .size:           2
        .value_kind:     hidden_group_size_x
      - .offset:         94
        .size:           2
        .value_kind:     hidden_group_size_y
      - .offset:         96
        .size:           2
        .value_kind:     hidden_group_size_z
      - .offset:         98
        .size:           2
        .value_kind:     hidden_remainder_x
      - .offset:         100
        .size:           2
        .value_kind:     hidden_remainder_y
      - .offset:         102
        .size:           2
        .value_kind:     hidden_remainder_z
      - .offset:         120
        .size:           8
        .value_kind:     hidden_global_offset_x
      - .offset:         128
        .size:           8
        .value_kind:     hidden_global_offset_y
      - .offset:         136
        .size:           8
        .value_kind:     hidden_global_offset_z
      - .offset:         144
        .size:           2
        .value_kind:     hidden_grid_dims
      - .offset:         160
        .size:           8
        .value_kind:     hidden_hostcall_buffer
      - .offset:         168
        .size:           8
        .value_kind:     hidden_multigrid_sync_arg
      - .offset:         176
        .size:           8
        .value_kind:     hidden_heap_v1
      - .offset:         184
        .size:           8
        .value_kind:     hidden_default_queue
      - .offset:         192
        .size:           8
        .value_kind:     hidden_completion_action
      - .offset:         200
        .size:           4
        .value_kind:     hidden_dynamic_lds_size
      - .offset:         280
        .size:           8
        .value_kind:     hidden_queue_ptr
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 336
    .max_flat_workgroup_size: 512
    .name:           a16w16_8wave
    .private_segment_fixed_size: 0
    .sgpr_count:     52
    .sgpr_spill_count: 0
    .symbol:         a16w16_8wave.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     246
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
	.section	.debug_line,"",@progbits
.Lline_table_start0:
