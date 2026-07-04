// RUN: wave-sim-report --func=exec_if_region --timeline %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @exec_if_region(%cond: !waveamdmachine.reg<sgpr, 1>,
                            %a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>) {
    %r = waveamdmachine.exec_if %cond {
      %then = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.yield %then : !waveamdmachine.reg<vgpr, 1>
    } otherwise {
      %else = waveamdmachine.v_add_u32 %b, %a
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.yield %else : !waveamdmachine.reg<vgpr, 1>
    } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<vgpr, 1>
    %use = waveamdmachine.v_add_u32 %r, %a
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// CHECK: func: exec_if_region
// CHECK: issued_ops: 3
// CHECK: issue cycle=0 fu=VALU op=waveamdmachine.v_add_u32
// CHECK: issue cycle=5 fu=VALU op=waveamdmachine.v_add_u32
// CHECK: issue cycle=10 fu=VALU op=waveamdmachine.v_add_u32
// CHECK: value_ready cycle=10 op=waveamdmachine.yield
