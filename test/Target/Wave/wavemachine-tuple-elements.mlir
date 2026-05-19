// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// Pure SSA renames between a VGPR tuple and its per-slot scalar VGPRs.
// The selector / decomposition pass builds these around scalar memory
// ops; the regalloc coalesces each element into the tuple's physical
// block at `tuple_phys + slot`. Asm emit then skips them entirely.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @round_trip_tuple_elements
// CHECK: %[[T:.+]] = wavemachine.v_mov_b32_tuple
// CHECK: %[[E:.+]]:8 = wavemachine.tuple_to_elements %[[T]]
// CHECK: %{{.+}} = wavemachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3, %[[E]]#4, %[[E]]#5, %[[E]]#6, %[[E]]#7
func.func @round_trip_tuple_elements() {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %tuple = wavemachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 8>
  %elems:8 = wavemachine.tuple_to_elements %tuple
      : (!wavemachine.reg<vgpr, 8>) -> (!wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>,
                                        !wavemachine.reg<vgpr, 1>)
  %rebuilt = wavemachine.tuple_from_elements
      %elems#0, %elems#1, %elems#2, %elems#3,
      %elems#4, %elems#5, %elems#6, %elems#7
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>,
         !wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>)
      -> !wavemachine.reg<vgpr, 8>
  return
}

}
