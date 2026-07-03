// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s
// RUN: not wave-opt %s --waveamd-machine-schedule='apply-schedule=1 barriered-lds-dma-hoist=1' 2>&1 | FileCheck %s --check-prefix=ERR

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barrier_is_not_separator(%tok: !waveamdmachine.mem.token,
                                    %a: !waveamdmachine.reg<vgpr, 1>,
                                    %b: !waveamdmachine.reg<vgpr, 1>) {
  %btok = waveamdmachine.s_barrier %tok
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// CHECK-LABEL: func.func @barrier_is_not_separator
// CHECK: waveamdmachine.s_barrier
// CHECK-NEXT: waveamdmachine.v_add_u32
// ERR: waveamd-machine-schedule unsupported option: barriered-lds-dma-hoist
