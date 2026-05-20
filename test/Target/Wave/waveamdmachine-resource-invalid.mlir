// RUN: wave-opt --waveamd-resource-info -split-input-file -verify-diagnostics %s

func.func @unallocated_register() {
  // expected-error @below {{waveamd-resource-info requires allocated register results}}
  %reg = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  return
}
