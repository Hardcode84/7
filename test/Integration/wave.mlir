// REQUIRES: host-supports-amdgpu
//
// Kernel side: wave dialect -> AMDGPU asm -> object -> HSACO.
// RUN: wave-translate --wave-to-amdgpu-asm %S/Inputs/wave_kernel.mlir \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=%chip -filetype=obj -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
//
// Host side: replace the stub `gpu.binary` with the freshly built HSACO,
// lower to LLVM, and run with the GPU runtime + our `memref_to_wave_ptr`
// shim.
// RUN: wave-opt %s \
// RUN:   --wave-attach-gpu-binary='path=%t.hsaco symbol=kernels chip=%chip' \
// RUN:   --convert-scf-to-cf \
// RUN:   --gpu-to-llvm=use-bare-pointers-for-kernels=true \
// RUN:   --convert-to-llvm \
// RUN:   --reconcile-unrealized-casts \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s

module attributes {gpu.container_module} {

// Stub: `gpu.launch_func` verifies against a same-named container at parse
// time, so we declare an empty `gpu.binary` and let `wave-attach-gpu-binary`
// rewrite its `objects` attr with the real HSACO bytes.
gpu.binary @kernels [#gpu.object<#rocdl.target<chip = "gfx1100">, bin = "">]

func.func private @wave_memref_to_ptr_global_i32(memref<32xi32>)
    -> !wave.ptr<i32, #wave.global> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

// CHECK: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c32 = arith.constant 32 : index
  %zero = arith.constant 0 : i32

  %storage = memref.alloc() : memref<32xi32>
  scf.for %i = %c0 to %c32 step %c1 {
    memref.store %zero, %storage[%i] : memref<32xi32>
  }

  %unranked = memref.cast %storage : memref<32xi32> to memref<*xi32>
  gpu.host_register %unranked : memref<*xi32>

  %p = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<32xi32>) -> !wave.ptr<i32, #wave.global>

  gpu.launch_func @kernels::@write_lane_ids
      blocks in (%c1, %c1, %c1) threads in (%c32, %c1, %c1)
      args(%p : !wave.ptr<i32, #wave.global>)

  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
