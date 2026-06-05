// RUN: wave-opt --waveamd-to-machine --split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-to-machine --split-input-file %s | wave-opt --split-input-file | FileCheck %s
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering \
// RUN:   --waveamd-decompose-mem-tuples --waveamd-linearize-exec-if \
// RUN:   --waveamd-insert-ticket-waits \
// RUN:   --waveamd-reg-alloc --waveamd-insert-hazard-waits \
// RUN:   --split-input-file %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file %s | FileCheck %s --check-prefix=ASM

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @scalar_poison
// CHECK: %[[POISON:.+]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
// CHECK: waveamdmachine.s_add_i32 %[[POISON]]
// REGALLOC-LABEL: func.func @scalar_poison
// REGALLOC: waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>
func.func @scalar_poison(%x: i32) -> i32 {
  %p = ub.poison : i32
  %sum = wave.binary addi %p, %x : i32, i32 -> i32
  return %sum : i32
}

// CHECK-LABEL: func.func @simd_poison_store
// CHECK: %[[POISON:.+]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
// CHECK: waveamdmachine.global_store_b32 {{.*}}, %[[POISON]]
// REGALLOC-LABEL: func.func @simd_poison_store
// REGALLOC: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, {{[0-9]+}}>
// ASM-LABEL: simd_poison_store:
// ASM-NOT: v_mov
// ASM: global_store_b32
func.func @simd_poison_store(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %p = ub.poison : !wave.simd<i32, 32>
  %tok = wave.store %p -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @packed_simd_poison_store
// CHECK: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
// CHECK: waveamdmachine.global_store_tuple_b32
// REGALLOC-LABEL: func.func @packed_simd_poison_store
// REGALLOC: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, {{[0-9]+}}>
func.func @packed_simd_poison_store(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %p = ub.poison : !wave.simd<vector<2xi32>, 32>
  %tok = wave.store %p -> %ptrs
      : (!wave.simd<vector<2xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @mask_poison_where32
// CHECK: %[[MASK:.+]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
// CHECK: waveamdmachine.exec_if %[[MASK]]
// REGALLOC-LABEL: func.func @mask_poison_where32
// REGALLOC: waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>
func.func @mask_poison_where32(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %mask = ub.poison : !wave.mask<32>
  wave.where %mask {
    %tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// CHECK-LABEL: func.func @mask_poison_where64
// CHECK: %[[MASK:.+]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
// CHECK: waveamdmachine.exec_if %[[MASK]]
// REGALLOC-LABEL: func.func @mask_poison_where64
// REGALLOC: waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, {{[0-9]+}}>
func.func @mask_poison_where64() attributes {wave.kernel} {
  %mask = ub.poison : !wave.mask<64>
  wave.where %mask {
    wave.yield
  } : !wave.mask<64>
  return
}

}
