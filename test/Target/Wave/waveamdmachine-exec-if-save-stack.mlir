// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s --check-prefix=INFO
// RUN: not wave-opt --waveamd-reg-alloc='sgpr-limit=2' %s 2>&1 | FileCheck %s --check-prefix=ERR

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// INFO-LABEL: func.func @nested_exec_if_save_stack
// INFO-SAME: waveamdmachine.sgpr_count = 3 : i64
// ERR: waveamd-reg-alloc exec_if save stack requires 2 SGPRs but only 2 are available
func.func @nested_exec_if_save_stack() {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %cond {
    waveamdmachine.exec_if %cond {
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}
