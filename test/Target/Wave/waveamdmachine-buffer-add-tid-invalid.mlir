// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @stride_without_add_tid(
    %base: !waveamdmachine.reg<sgpr, 2>,
    %range: !waveamdmachine.imm) {
  // expected-error @below {{const_stride and const_add_tid_enable must be enabled together}}
  %desc = waveamdmachine.make_buffer_rsrc %base, %range {const_stride = 4 : i64}
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<sgpr, 4>
  return
}

// -----

func.func @add_tid_without_stride(
    %base: !waveamdmachine.reg<sgpr, 2>,
    %range: !waveamdmachine.imm) {
  // expected-error @below {{const_stride and const_add_tid_enable must be enabled together}}
  %desc = waveamdmachine.make_buffer_rsrc %base, %range {const_add_tid_enable = true}
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<sgpr, 4>
  return
}
