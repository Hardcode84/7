// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule' -o %t.parallel 2> %t.parallel.log
// RUN: FileCheck %s < %t.parallel
// RUN: wave-opt %s --mlir-disable-threading --waveamd-machine-schedule='apply-schedule' -o %t.serial 2> %t.serial.log
// RUN: diff %t.parallel %t.serial
// RUN: diff %t.parallel.log %t.serial.log
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
// CHECK-LABEL: func.func @idle
// CHECK-COUNT-2: waveamdmachine.candidate_yield {cycles = 4 : i64}
func.func @idle(%off: !waveamdmachine.reg<vgpr, 1>, %base: !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1> {
  %token = waveamdmachine.token : !waveamdmachine.mem.token
  waveamdmachine.materialization_candidates %token : !waveamdmachine.mem.token {
  ^bb0(%dep: !waveamdmachine.mem.token):
    waveamdmachine.s_barrier %dep : (!waveamdmachine.mem.token) -> ()
    waveamdmachine.candidate_yield
  }, {
  ^bb0(%dep: !waveamdmachine.mem.token):
    waveamdmachine.s_barrier %dep : (!waveamdmachine.mem.token) -> ()
    waveamdmachine.candidate_yield
  }
  return %off : !waveamdmachine.reg<vgpr, 1>
}
// CHECK-LABEL: func.func @busy
// CHECK: waveamdmachine.global_load_b32
// CHECK-COUNT-2: waveamdmachine.candidate_yield {cycles = 80 : i64}
func.func @busy(%off: !waveamdmachine.reg<vgpr, 1>, %base: !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1> {
  %token = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %ready = waveamdmachine.global_load_b32 %off, %base after %token : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  waveamdmachine.materialization_candidates %ready : !waveamdmachine.mem.token {
  ^bb0(%dep: !waveamdmachine.mem.token):
    waveamdmachine.s_barrier %dep : (!waveamdmachine.mem.token) -> ()
    waveamdmachine.candidate_yield
  }, {
  ^bb0(%dep: !waveamdmachine.mem.token):
    waveamdmachine.s_barrier %dep : (!waveamdmachine.mem.token) -> ()
    waveamdmachine.candidate_yield
  }
  return %loaded : !waveamdmachine.reg<vgpr, 1>
}
}
