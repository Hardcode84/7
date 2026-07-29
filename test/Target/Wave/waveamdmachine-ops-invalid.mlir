// RUN: wave-opt -split-input-file -verify-diagnostics %s

func.func @bad_v_add_operand_count(%x: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{'waveamdmachine.v_add_u32' op expected 2 operands}}
  %r = "waveamdmachine.v_add_u32"(%x) : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @bad_s_cmp_eq_u64_lhs(
    %lhs: !waveamdmachine.reg<sgpr, 1>,
    %rhs: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{operand #0 must be WaveAMDMachine SGPR pair or VCC}}
  %cmp = "waveamdmachine.s_cmp_eq_u64"(%lhs, %rhs)
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<scc, 1>
  return
}

// -----

func.func @bad_s_cmp_lg_u64_rhs(
    %lhs: !waveamdmachine.reg<sgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{operand #1 must be WaveAMDMachine SGPR pair or VCC}}
  %cmp = "waveamdmachine.s_cmp_lg_u64"(%lhs, %rhs)
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<scc, 1>
  return
}

// -----

func.func @bad_v_mbcnt_result_type() {
  // expected-error @below {{result #0 must be WaveAMDMachine scalar VGPR register}}
  %r = "waveamdmachine.v_mbcnt_lo"() : () -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_s_load_result_type(%offset: !waveamdmachine.imm) {
  // expected-error @below {{result #0 must be WaveAMDMachine SGPR pair register}}
  %r = "waveamdmachine.s_load_b64"(%offset) {base = "s[0:1]"} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_global_store_base(%offset: !waveamdmachine.reg<vgpr, 1>, %value: !waveamdmachine.reg<vgpr, 1>, %base: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{operand #2 must be WaveAMDMachine SGPR pair register}}
  "waveamdmachine.global_store_b32"(%offset, %value, %base) : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> ()
  return
}

// -----

func.func @bad_wmma_width(%a: !waveamdmachine.reg<vgpr, 8>, %b: !waveamdmachine.reg<vgpr, 4>, %acc: !waveamdmachine.reg<vgpr, 8>) {
  // expected-error @below {{A operand must be !waveamdmachine.reg<vgpr, 4>}}
  %r = waveamdmachine.wmma_i32_16x16x16_iu8 %a, %b, %acc : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

// -----

func.func @bad_gfx1250_wmma_neg_lo_source(
    %a: !waveamdmachine.reg<vgpr, 8>,
    %b: !waveamdmachine.reg<vgpr, 8>,
    %acc: !waveamdmachine.reg<vgpr, 8>) {
  // expected-error @below {{neg_lo selects an unsupported source}}
  %r = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      {neg_lo = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
         !waveamdmachine.reg<vgpr, 8>)
        -> !waveamdmachine.reg<vgpr, 8>
  return
}

// -----

func.func @bad_gfx1250_wmma_neg_hi_source(
    %a: !waveamdmachine.reg<vgpr, 8>,
    %b: !waveamdmachine.reg<vgpr, 8>,
    %acc: !waveamdmachine.reg<vgpr, 8>) {
  // expected-error @below {{neg_hi selects an unsupported source}}
  %r = waveamdmachine.wmma_f32_16x16x32_bf16 %a, %b, %acc
      {neg_hi = 2 : i64}
      : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
         !waveamdmachine.reg<vgpr, 8>)
        -> !waveamdmachine.reg<vgpr, 8>
  return
}

// -----

func.func @bad_mfma_scale_index(%a: !waveamdmachine.reg<vgpr, 4>,
                                %b: !waveamdmachine.reg<vgpr, 4>,
                                %acc: !waveamdmachine.reg<vgpr, 4>,
                                %scale: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{attribute 'scale_idx_a' failed to satisfy constraint}}
  %r = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 %a, %b, %acc, %scale, %scale {scale_idx_a = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @bad_mfma_scale_b_index(%a: !waveamdmachine.reg<vgpr, 4>,
                                  %b: !waveamdmachine.reg<vgpr, 4>,
                                  %acc: !waveamdmachine.reg<vgpr, 4>,
                                  %scale: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{attribute 'scale_idx_b' failed to satisfy constraint}}
  %r = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 %a, %b, %acc, %scale, %scale {scale_idx_b = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @bad_mfma_scale_a_width(%a: !waveamdmachine.reg<vgpr, 2>,
                                  %b: !waveamdmachine.reg<vgpr, 4>,
                                  %acc: !waveamdmachine.reg<vgpr, 4>,
                                  %scale: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{A operand must be !waveamdmachine.reg<vgpr|agpr, 4>}}
  %r = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 %a, %b, %acc, %scale, %scale
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @bad_mfma_scale_b_width(%a: !waveamdmachine.reg<vgpr, 4>,
                                  %b: !waveamdmachine.reg<vgpr, 2>,
                                  %acc: !waveamdmachine.reg<vgpr, 4>,
                                  %scale: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{B operand must be !waveamdmachine.reg<vgpr|agpr, 4>}}
  %r = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 %a, %b, %acc, %scale, %scale
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @bad_mfma_scale_acc_width(%a: !waveamdmachine.reg<vgpr, 4>,
                                    %b: !waveamdmachine.reg<vgpr, 4>,
                                    %acc: !waveamdmachine.reg<vgpr, 2>,
                                    %scale: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{accumulator operand must be !waveamdmachine.reg<vgpr|agpr, 4>}}
  %r = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 %a, %b, %acc, %scale, %scale
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @bad_mfma_scale_32x32_acc_width(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %scale: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{accumulator operand must be !waveamdmachine.reg<vgpr|agpr, 16>}}
  %r = waveamdmachine.mfma_scale_f32_32x32x64_f4_f4
      %a, %b, %acc, %scale, %scale
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 16>
  return
}

// -----

func.func @bad_mfma_scale_a_scale_width(%a: !waveamdmachine.reg<vgpr, 4>,
                                        %b: !waveamdmachine.reg<vgpr, 4>,
                                        %acc: !waveamdmachine.reg<vgpr, 4>,
                                        %scale: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{operand #3 must be WaveAMDMachine scalar VGPR register}}
  %r = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 %a, %b, %acc, %scale, %scale
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @bad_mfma_scale_b_scale_width(%a: !waveamdmachine.reg<vgpr, 4>,
                                        %b: !waveamdmachine.reg<vgpr, 4>,
                                        %acc: !waveamdmachine.reg<vgpr, 4>,
                                        %good_scale: !waveamdmachine.reg<vgpr, 1>,
                                        %bad_scale: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{operand #4 must be WaveAMDMachine scalar VGPR register}}
  %r = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 %a, %b, %acc, %good_scale, %bad_scale
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @bad_mfma_scale_result_width(%a: !waveamdmachine.reg<vgpr, 4>,
                                       %b: !waveamdmachine.reg<vgpr, 4>,
                                       %acc: !waveamdmachine.reg<vgpr, 4>,
                                       %scale: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{result must be !waveamdmachine.reg<vgpr|agpr, 4>}}
  %r = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 %a, %b, %acc, %scale, %scale
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
  return
}

// -----

func.func @bad_mfma_acc_result_bank(%a: !waveamdmachine.reg<vgpr, 4>,
                                    %b: !waveamdmachine.reg<vgpr, 4>,
                                    %acc: !waveamdmachine.reg<agpr, 4>) {
  // expected-error @below {{accumulator/result register classes must match}}
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @bad_agpr_store_value(%offset: !waveamdmachine.reg<vgpr, 1>,
                                %value: !waveamdmachine.reg<agpr, 1>,
                                %base: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{operand #1 must be WaveAMDMachine SGPR/VGPR register or immediate}}
  %token = waveamdmachine.global_store_b32 %offset, %value, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<agpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

// -----

func.func @bad_v_add_u64_u32_tuple_offset(%base: !waveamdmachine.reg<vgpr, 2>,
                                          %offset: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{operand #1 must be WaveAMDMachine one-dword SGPR/VGPR register or immediate}}
  %r, %vcc = waveamdmachine.v_add_u64_u32 %base, %offset
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  return
}

// -----

func.func @bad_v_lshlrev_b64_tuple_shift(%shift: !waveamdmachine.reg<vgpr, 2>,
                                         %value: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{operand #0 must be WaveAMDMachine one-dword SGPR/VGPR register or immediate}}
  %r = waveamdmachine.v_lshlrev_b64 %shift, %value
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return
}

// -----

func.func @bad_accvgpr_read_width(%source: !waveamdmachine.reg<agpr, 2>) {
  // expected-error @below {{source and result widths must match}}
  %r = waveamdmachine.v_accvgpr_read_b32_tuple %source
      : (!waveamdmachine.reg<agpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @bad_accvgpr_write_width(%source: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{source and result widths must match}}
  %r = waveamdmachine.v_accvgpr_write_b32_tuple %source
      : (!waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<agpr, 1>
  return
}

// -----

func.func @bad_accvgpr_write_non_inline_imm() {
  %literal = waveamdmachine.imm 65 : !waveamdmachine.imm
  // expected-error @below {{immediate source must be an inline 32-bit constant}}
  %r = waveamdmachine.v_accvgpr_write_b32_tuple %literal
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<agpr, 1>
  return
}

// -----

func.func @tuple_to_elements_wrong_count(%t: !waveamdmachine.reg<vgpr, 8>) {
  // expected-error @below {{element widths sum (4) must match tuple register width (8)}}
  %e:4 = waveamdmachine.tuple_to_elements %t
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  return
}

// -----

func.func @tuple_from_elements_wrong_count(%a: !waveamdmachine.reg<vgpr, 1>,
                                           %b: !waveamdmachine.reg<vgpr, 1>,
                                           %c: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{element widths sum (3) must match tuple register width (8)}}
  %t = waveamdmachine.tuple_from_elements %a, %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

// -----

func.func @tuple_from_elements_subtuple_width_mismatch(%a: !waveamdmachine.reg<vgpr, 4>,
                                                       %b: !waveamdmachine.reg<vgpr, 2>,
                                                       %c: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{element widths sum (7) must match tuple register width (8)}}
  %t = waveamdmachine.tuple_from_elements %a, %b, %c
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

// -----

func.func @tuple_from_elements_mixed_class(%a: !waveamdmachine.reg<vgpr, 2>,
                                           %b: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{element register class must match tuple's}}
  %t = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @copy_tuple_mixed_class(%src: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{source register class must match result}}
  %r = waveamdmachine.copy_tuple %src
      : (!waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
  return
}

// -----

func.func @copy_tuple_width(%src: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{source width must match result width}}
  %r = waveamdmachine.copy_tuple %src
      : (!waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @copy_tuple_agpr(%src: !waveamdmachine.reg<agpr, 2>) {
  // expected-error @below {{supports only SGPR and VGPR copies}}
  %r = waveamdmachine.copy_tuple %src
      : (!waveamdmachine.reg<agpr, 2>) -> !waveamdmachine.reg<agpr, 2>
  return
}

// -----

func.func @update_tuple_base_class(%base: !waveamdmachine.reg<vgpr, 4>) {
  // expected-error @below {{base register class must match result}}
  "waveamdmachine.update_tuple"(%base) {offsets = []}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<sgpr, 4>
  return
}

// -----

func.func @update_tuple_base_width(%base: !waveamdmachine.reg<vgpr, 4>) {
  // expected-error @below {{base width must match result width}}
  "waveamdmachine.update_tuple"(%base) {offsets = []}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 2>
  return
}

// -----

func.func @update_tuple_offset_count(%base: !waveamdmachine.reg<vgpr, 4>,
                                     %a: !waveamdmachine.reg<vgpr, 1>,
                                     %b: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{offset count must match update count}}
  %r = waveamdmachine.update_tuple %base, %a, %b {offsets = [0 : i64]}
      : (!waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @update_tuple_non_integer_offset(%base: !waveamdmachine.reg<vgpr, 4>,
                                           %a: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{offsets must be integer attributes}}
  "waveamdmachine.update_tuple"(%base, %a) {offsets = ["x"]}
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @update_tuple_negative_offset(%base: !waveamdmachine.reg<vgpr, 4>,
                                        %a: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{offsets must be non-negative}}
  %r = waveamdmachine.update_tuple %base, %a {offsets = [-1 : i64]}
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @update_tuple_overlapping(%base: !waveamdmachine.reg<vgpr, 4>,
                                    %a: !waveamdmachine.reg<vgpr, 2>,
                                    %b: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{offsets must be sorted and non-overlapping}}
  %r = waveamdmachine.update_tuple %base, %a, %b {offsets = [1 : i64, 2 : i64]}
      : (!waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @update_tuple_update_class(%base: !waveamdmachine.reg<vgpr, 4>,
                                     %a: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{update register class must match base}}
  %r = waveamdmachine.update_tuple %base, %a {offsets = [0 : i64]}
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @update_tuple_exceeds_width(%base: !waveamdmachine.reg<vgpr, 4>,
                                      %a: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{update exceeds tuple width}}
  %r = waveamdmachine.update_tuple %base, %a {offsets = [3 : i64]}
      : (!waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

// Memory-token result group is optional, not variadic.
func.func @memop_two_tokens(%off: !waveamdmachine.reg<vgpr, 1>,
                            %base: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{requires 0 or 1 element, but found 2}}
  %r, %t0, %t1 = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.mem.token)
  return
}

// -----

// Covers "registers attribute must match result register width" emitted by
// both v_mov_b32_tuple and s_mov_b32_tuple -- substring match.
func.func @v_mov_b32_tuple_registers_mismatch(%src: !waveamdmachine.imm) {
  // expected-error @below {{registers attribute must match result register width}}
  %r = waveamdmachine.v_mov_b32_tuple %src {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @v_cndmask_immediate_wide_result(%src: !waveamdmachine.reg<vgpr, 2>,
                                           %cond: !waveamdmachine.reg<sgpr, 1>) {
  %imm = waveamdmachine.imm 7 : !waveamdmachine.imm
  // expected-error @below {{immediate source requires width-1 result}}
  %r = waveamdmachine.v_cndmask_b32_tuple %imm, %src, %cond
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
  return
}

// -----

func.func @v_cndmask_source_width_mismatch(%narrow: !waveamdmachine.reg<vgpr, 1>,
                                           %wide: !waveamdmachine.reg<vgpr, 2>,
                                           %cond: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{source width 1 must match result width 2}}
  %r = waveamdmachine.v_cndmask_b32_tuple %narrow, %wide, %cond
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
  return
}

// -----

func.func @v_cndmask_flag_source(%flag: !waveamdmachine.reg<vcc, 1>,
                                 %src: !waveamdmachine.reg<vgpr, 1>,
                                 %cond: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{operand #0 must be WaveAMDMachine SGPR/VGPR register or immediate}}
  %r = waveamdmachine.v_cndmask_b32_tuple %flag, %src, %cond
      : (!waveamdmachine.reg<vcc, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @v_cndmask_bad_condition_width(%false: !waveamdmachine.reg<vgpr, 1>,
                                         %true: !waveamdmachine.reg<vgpr, 1>,
                                         %cond: !waveamdmachine.reg<sgpr, 4>) {
  // expected-error @below {{condition width must be 1 or 2}}
  %r = waveamdmachine.v_cndmask_b32_tuple %false, %true, %cond
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @exec_if_bad_condition(%cond: !waveamdmachine.reg<sgpr, 4>) {
  // expected-error @below {{condition must be SGPR1 or SGPR2}}
  waveamdmachine.exec_if %cond {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 4>
  return
}

// -----

func.func @exec_if_vcc_missing_width(%cond: !waveamdmachine.reg<vcc, 1>) {
  // expected-error @below {{VCC condition requires mask_width 32 or 64}}
  waveamdmachine.exec_if %cond {
    waveamdmachine.yield
  } : !waveamdmachine.reg<vcc, 1>
  return
}

// -----

func.func @exec_if_vcc_bad_width(%cond: !waveamdmachine.reg<vcc, 1>) {
  // expected-error @below {{VCC condition requires mask_width 32 or 64}}
  waveamdmachine.exec_if %cond {
    waveamdmachine.yield
  } {mask_width = 16 : i64} : !waveamdmachine.reg<vcc, 1>
  return
}

// -----

func.func @exec_if_sgpr_with_width(%cond: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{SGPR condition must not set mask_width}}
  waveamdmachine.exec_if %cond {
    waveamdmachine.yield
  } {mask_width = 64 : i64} : !waveamdmachine.reg<sgpr, 2>
  return
}

// -----

func.func @exec_if_bad_terminator(%cond: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{then region must terminate with yield}}
  waveamdmachine.exec_if %cond {
  ^bb0:
    cf.br ^bb0
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @exec_if_yield_count_mismatch(%cond: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{then yield operand count must match result count}}
  %r = waveamdmachine.exec_if %cond {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @exec_if_yield_type_mismatch(%cond: !waveamdmachine.reg<sgpr, 1>,
                                       %value: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{then yield type must match result type}}
  %r = waveamdmachine.exec_if %cond {
    waveamdmachine.yield %value : !waveamdmachine.reg<sgpr, 1>
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @uniform_if_result_without_else(%cond: !waveamdmachine.reg<scc, 1>,
                                          %value: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{results require else region}}
  %r = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %value : !waveamdmachine.reg<sgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @uniform_if_yield_type_mismatch(%cond: !waveamdmachine.reg<scc, 1>,
                                          %sgpr: !waveamdmachine.reg<sgpr, 1>,
                                          %vgpr: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{else yield type must match result type}}
  %r = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %sgpr : !waveamdmachine.reg<sgpr, 1>
  } otherwise {
    waveamdmachine.yield %vgpr : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @uniform_if_fixed_register_yields(
    %cond: !waveamdmachine.reg<scc, 1>,
    %x: !waveamdmachine.reg<sgpr, 1, 4>,
    %y: !waveamdmachine.reg<sgpr, 1, 5>) {
  %r = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %x : !waveamdmachine.reg<sgpr, 1, 4>
  } otherwise {
    waveamdmachine.yield %y : !waveamdmachine.reg<sgpr, 1, 5>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1, 6>
  return
}

// -----

func.func @uniform_if_fixed_vgpr_yields(
    %cond: !waveamdmachine.reg<scc, 1>,
    %x: !waveamdmachine.reg<vgpr, 1, 2>,
    %y: !waveamdmachine.reg<vgpr, 1, 3>) {
  %r = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %x : !waveamdmachine.reg<vgpr, 1, 2>
  } otherwise {
    waveamdmachine.yield %y : !waveamdmachine.reg<vgpr, 1, 3>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1, 4>
  return
}

// -----

// Zero-width tuples die in RegType verification before op checks.
func.func @global_load_tuple_b32_zero_width(%off: !waveamdmachine.reg<vgpr, 1>,
                                            %base: !waveamdmachine.reg<sgpr, 2>) {
  %r, %t = waveamdmachine.global_load_tuple_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
      // expected-error @below {{register width must be positive}}
      -> (!waveamdmachine.reg<vgpr, 0>, !waveamdmachine.mem.token)
  return
}

// -----

func.func @uniform_loop_block_arg_count_mismatch(%init: !waveamdmachine.reg<sgpr, 1>,
                                                  %sc: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{body block must have one argument per init carry}}
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>, %extra: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.continue_if %sc : !waveamdmachine.reg<scc, 1> carries(%iv : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @uniform_loop_block_arg_type_mismatch(%init: !waveamdmachine.reg<sgpr, 1>,
                                                 %sc: !waveamdmachine.reg<scc, 1>,
                                                 %v: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{init carry types must match body block argument types}}
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<vgpr, 1>):
    waveamdmachine.continue_if %sc : !waveamdmachine.reg<scc, 1> carries(%v : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @uniform_loop_results_count_mismatch(%init: !waveamdmachine.reg<sgpr, 1>,
                                                %sc: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{results count must match inits count}}
  waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.continue_if %sc : !waveamdmachine.reg<scc, 1> carries(%iv : !waveamdmachine.reg<sgpr, 1>)
  }
  return
}

// -----

func.func @uniform_loop_result_type_mismatch(%init: !waveamdmachine.reg<sgpr, 1>,
                                              %sc: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{init carry types must match result types}}
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.continue_if %sc : !waveamdmachine.reg<scc, 1> carries(%iv : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @uniform_loop_bad_terminator(%init: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{body must be terminated by a waveamdmachine.continue_if}}
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.label "foo"
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @uniform_loop_phase_without_alignment(
    %cond: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{fetch_phase requires fetch_alignment}}
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  } {fetch_phase = 16 : i64}
  return
}

// -----

func.func @uniform_loop_bad_fetch_alignment(
    %cond: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{fetch_alignment must be a power of two from 4 to 256 bytes}}
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  } {fetch_alignment = 24 : i64}
  return
}

// -----

func.func @uniform_loop_out_of_range_fetch_phase(
    %cond: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{fetch_phase must be non-negative and smaller than fetch_alignment}}
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  } {fetch_alignment = 32 : i64, fetch_phase = 32 : i64}
  return
}

// -----

func.func @uniform_loop_unaligned_fetch_phase(
    %cond: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{fetch_phase must be 4-byte aligned}}
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  } {fetch_alignment = 32 : i64, fetch_phase = 6 : i64}
  return
}

// -----

func.func @permlane32_odd_tuple(
    %source: !waveamdmachine.reg<vgpr, 3>) {
  // expected-error @below {{source and result widths must be positive even tuples}}
  %result = waveamdmachine.v_permlane32_swap_b32_tuple %source
      : (!waveamdmachine.reg<vgpr, 3>)
      -> !waveamdmachine.reg<vgpr, 3>
  return
}

// -----

func.func @permlane32_width_mismatch(
    %source: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @below {{source and result widths must match}}
  %result = waveamdmachine.v_permlane32_swap_b32_tuple %source
      : (!waveamdmachine.reg<vgpr, 2>)
      -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @dma_issue_delay_nonpositive(
    %dep: !waveamdmachine.mem.token, %m0: !waveamdmachine.m0) {
  // expected-error @below {{requires positive cycles}}
  %delayed_m0 = waveamdmachine.dma_issue_delay %dep, %m0
      {cycles = 0 : i64}
      : (!waveamdmachine.mem.token, !waveamdmachine.m0)
        -> !waveamdmachine.m0
  return
}

// -----

func.func @dma_issue_delay_negative_overlap(
    %dep: !waveamdmachine.mem.token, %m0: !waveamdmachine.m0) {
  // expected-error @below {{requires non-negative overlap_cycles}}
  %delayed_m0 = waveamdmachine.dma_issue_delay %dep, %m0
      {cycles = 4 : i64, overlap_cycles = -1 : i64}
      : (!waveamdmachine.mem.token, !waveamdmachine.m0)
        -> !waveamdmachine.m0
  return
}

// -----

func.func @dma_issue_delay_overlap_exceeds_cycles(
    %dep: !waveamdmachine.mem.token, %m0: !waveamdmachine.m0) {
  // expected-error @below {{overlap_cycles cannot exceed cycles}}
  %delayed_m0 = waveamdmachine.dma_issue_delay %dep, %m0
      {cycles = 4 : i64, overlap_cycles = 5 : i64}
      : (!waveamdmachine.mem.token, !waveamdmachine.m0)
        -> !waveamdmachine.m0
  return
}

// -----

func.func @reg_after_without_dependency(
    %source: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{requires at least one dependency}}
  %result = "waveamdmachine.reg_after"(%source)
      : (!waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<sgpr, 2>
  return
}

// -----

func.func @reg_after_type_mismatch(
    %source: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token) {
  // expected-error @below {{source and result types must match}}
  %result = "waveamdmachine.reg_after"(%source, %dep)
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}
