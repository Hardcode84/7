// RUN: wave-opt -verify-diagnostics %s

func.func @unknown_waveamdmachine_op() {
  // expected-error @below {{unregistered operation 'waveamdmachine.unknown_op' found in dialect ('waveamdmachine') that does not allow unknown operations}}
  "waveamdmachine.unknown_op"() : () -> ()
  return
}
