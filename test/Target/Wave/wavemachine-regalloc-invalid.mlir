// RUN: wave-opt --waveamd-reg-alloc -split-input-file -verify-diagnostics %s

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @unsupported_register_class() {
  // expected-error @below {{waveamd-reg-alloc supports only SGPR and VGPR register classes}}
  %reg = wavemachine.arg {index = 0 : i64, pointer = false} : !wavemachine.reg<agpr, 1>
  return
}

}

// -----

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// expected-error @below {{WaveMachine register allocator ran out of registers}}
func.func @too_many_vgprs() {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %reg = wavemachine.v_mov_b32_tuple %zero {registers = 257 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 257>
  return
}

}

// -----

// expected-error @below {{waveamd-reg-alloc requires a wavemachine.target attribute}}
module {
  func.func @missing_target() {
    return
  }
}

// -----

// Wider SGPR tuple duplicates have no existing register-rename copy op
// in the dialect; the regalloc emits a clear error rather than silently
// producing a miscompile.
module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @duplicate_sgpr_wide_init() attributes {wave.kernel} {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %one = wavemachine.imm 1 : !wavemachine.imm
  %four = wavemachine.imm 4 : !wavemachine.imm
  %init = wavemachine.s_mov_b64_imm 0 : !wavemachine.reg<sgpr, 2>
  %iv = wavemachine.s_mov_b32_value %zero
      : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %ec = wavemachine.s_cmp_lt_i32 %zero, %four
      : (!wavemachine.imm, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
  // expected-error @+1 {{duplicateRegValue: unsupported register class / width}}
  %results:3 = wavemachine.uniform_loop if %ec : !wavemachine.reg<scc, 1>
      carries(%iv, %init, %init :
              !wavemachine.reg<sgpr, 1>,
              !wavemachine.reg<sgpr, 2>,
              !wavemachine.reg<sgpr, 2>) {
  ^bb0(%cur_iv: !wavemachine.reg<sgpr, 1>,
       %a: !wavemachine.reg<sgpr, 2>,
       %b: !wavemachine.reg<sgpr, 2>):
    %niv, %scc = wavemachine.s_add_i32 %cur_iv, %one
        : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm)
          -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
    %bc = wavemachine.s_cmp_lt_i32 %niv, %four
        : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
    wavemachine.continue_if %bc : !wavemachine.reg<scc, 1>
        carries(%niv, %a, %b :
                !wavemachine.reg<sgpr, 1>,
                !wavemachine.reg<sgpr, 2>,
                !wavemachine.reg<sgpr, 2>)
  } -> !wavemachine.reg<sgpr, 1>, !wavemachine.reg<sgpr, 2>, !wavemachine.reg<sgpr, 2>
  return
}

}
