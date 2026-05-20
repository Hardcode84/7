// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// Pure SSA renames between a VGPR tuple and its per-slot scalar VGPRs.
// The selector / decomposition pass builds these around scalar memory
// ops; the regalloc coalesces each element into the tuple's physical
// block at `tuple_phys + slot`. Asm emit then skips them entirely.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @round_trip_tuple_elements
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple
// CHECK: %[[E:.+]]:8 = waveamdmachine.tuple_to_elements %[[T]]
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3, %[[E]]#4, %[[E]]#5, %[[E]]#6, %[[E]]#7
func.func @round_trip_tuple_elements() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %tuple = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %elems:8 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>,
                                        !waveamdmachine.reg<vgpr, 1>)
  %rebuilt = waveamdmachine.tuple_from_elements
      %elems#0, %elems#1, %elems#2, %elems#3,
      %elems#4, %elems#5, %elems#6, %elems#7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 8>
  return
}

}
