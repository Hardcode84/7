// RUN: wave-opt --waveamd-late-tuples %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

  // CHECK-LABEL: func.func @sinks_tuple_chain
  // CHECK-SAME: %[[SRC:.*]]: !waveamdmachine.reg<vgpr, 4>
  // CHECK-SAME: %[[LIVE:.*]]: !waveamdmachine.reg<vgpr, 1>
  // CHECK: %[[COPY0:.*]] = waveamdmachine.copy_tuple %[[LIVE]]
  // CHECK-NEXT: %[[COPY1:.*]] = waveamdmachine.copy_tuple %[[COPY0]]
  // CHECK-NEXT: %[[PARTS:.*]]:4 = waveamdmachine.tuple_to_elements %[[SRC]]
  // CHECK-NEXT: %[[TUPLE:.*]] = waveamdmachine.tuple_from_elements %[[PARTS]]#0, %[[PARTS]]#1
  // CHECK-NEXT: %[[USE:.*]] = waveamdmachine.copy_tuple %[[TUPLE]]
  // CHECK-NEXT: return %[[USE]]
  func.func @sinks_tuple_chain(
      %src: !waveamdmachine.reg<vgpr, 4>,
      %live: !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2> {
    %parts:4 = waveamdmachine.tuple_to_elements %src
        : (!waveamdmachine.reg<vgpr, 4>) ->
          (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>)
    %tuple = waveamdmachine.tuple_from_elements %parts#0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    %copy0 = waveamdmachine.copy_tuple %live
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %copy1 = waveamdmachine.copy_tuple %copy0
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %use = waveamdmachine.copy_tuple %tuple
        : (!waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
    return %use : !waveamdmachine.reg<vgpr, 2>
  }

}
