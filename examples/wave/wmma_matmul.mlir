// Example: gfx11/gfx12 WMMA-accelerated 16x16 matrix multiply.
//
// Compile the `gpu.module` below into a HSACO-carrying `gpu.binary`
// entirely in-process:
//
//   wave-opt wmma_matmul.mlir --wave-compile-kernels='chip=gfx1100'
//
// To inspect the AMDGPU assembly instead, replace the surrounding
// `gpu.module @kernels { ... }` with a plain `module attributes {
// wavemachine.target = "amdgcn-amd-amdhsa--gfx1100" } { ... }` and run:
//
//   wave-opt <single-kernel.mlir> --waveamd-to-wavemachine \
//       --waveamd-abi-lowering --waveamd-insert-hazard-waits \
//       --waveamd-reg-alloc --waveamd-resource-info --waveamd-metadata \
//     | wave-translate --wave-to-amdgpu-asm
//
// (See `test/Target/Wave/wavemachine-matrix.mlir` for a worked example
// of the asm-inspection pipeline.)
//
// ---------------------------------------------------------------------------
// What the WMMA fragment types mean
// ---------------------------------------------------------------------------
// `!waveamd.fragment<role, eltType, rows, cols, waveSize, regs>` describes a
// wave-cooperative tile distributed across the active wavefront's VGPRs:
//
//   role     = 0 (A), 1 (B), or 2 (accumulator/result).
//   eltType  = per-element scalar type of the *logical* tile.
//   rows/cols= logical tile shape (16x16 here).
//   waveSize = number of cooperating lanes (32 on gfx11 wave32).
//   regs     = number of i32 VGPRs that each lane contributes to the tile.
//
// For the two kinds supported by this dialect today:
//   wmma.i32.16x16x16.iu8  : A,B = <_, i8 , 16,16, 32, 4>, Acc/D = <2, i32, 16,16, 32, 8>
//   wmma.f32.16x16x16.f16  : A,B = <_, f16, 16,16, 32, 8>, Acc/D = <2, f32, 16,16, 32, 8>
//
// ---------------------------------------------------------------------------
// Loading inputs
// ---------------------------------------------------------------------------
// The dialect currently only provides `waveamd.fragment_fill`, which broadcasts
// a single i32 bit pattern across every VGPR slot of every lane in the
// fragment. The two kernels below therefore compute *constant* matmuls:
// A and B end up filled with a uniform value chosen via the bit pattern.
// A future `waveamd.fragment_load` would read a real tile from global memory;
// the rest of the WMMA + store sequence shown here would not change.

module attributes {gpu.container_module} {

gpu.module @kernels {

  // wmma.i32.16x16x16.iu8 :  D = A * B + Acc  (all elements integer)
  //
  // 0x01010101 sets every i8 lane of A and B to 1, so for every (i,j):
  //   D[i][j] = sum_{k=0..15} 1 * 1 + 0 = 16
  //
  // `fragment_store` writes the 8-register accumulator as 8 consecutive i32s
  // per lane, starting at byte offset `lane_id * 32` into `%out`. With 32
  // lanes that lays the full 16x16 = 256-element result out contiguously,
  // so a 256-element output buffer receives all 16s.
  func.func @wmma_iu8_matmul_const(%out: !wave.ptr<i32, #wave.global>)
      attributes {gpu.kernel, wave.kernel} {
    %ones_i8x4 = arith.constant 0x01010101 : i32
    %acc_init  = arith.constant 0 : i32
    %base      = arith.constant 0 : index

    %ptr = wave.ptr_add %out, %base
        : !wave.ptr<i32, #wave.global>, index -> !wave.ptr<i32, #wave.global>

    %a   = waveamd.fragment_fill %ones_i8x4
        : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
    %b   = waveamd.fragment_fill %ones_i8x4
        : i32 -> !waveamd.fragment<1, i8, 16, 16, 32, 4>
    %acc = waveamd.fragment_fill %acc_init
        : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>

    %d = waveamd.mma "wmma.i32.16x16x16.iu8" %a, %b, %acc
        : !waveamd.fragment<0, i8 , 16, 16, 32, 4>,
          !waveamd.fragment<1, i8 , 16, 16, 32, 4>,
          !waveamd.fragment<2, i32, 16, 16, 32, 8>
       -> !waveamd.fragment<2, i32, 16, 16, 32, 8>

    %tok = waveamd.fragment_store %d -> %ptr
        : (!waveamd.fragment<2, i32, 16, 16, 32, 8>,
           !wave.ptr<i32, #wave.global>) -> !wave.mem.token
    return
  }

  // wmma.f32.16x16x16.f16 :  D = A * B + Acc  (f16 inputs, f32 accumulator)
  //
  // 0x3c003c00 holds two halves of (f16)1.0 packed into one i32, so the f16
  // fragments end up all-ones. The f32 accumulator starts at 0.0f, so:
  //   D[i][j] = sum_{k=0..15} 1.0 * 1.0 + 0.0 = 16.0  (bit pattern 0x41800000)
  //
  // The output pointer is still typed `!wave.ptr<i32, ...>` because
  // `fragment_store` works on a 32-bit-element pointer regardless of whether
  // the fragment holds i32 or f32; reinterpret the resulting buffer as f32
  // on the host side.
  func.func @wmma_f16_matmul_const(%out: !wave.ptr<i32, #wave.global>)
      attributes {gpu.kernel, wave.kernel} {
    %ones_f16x2 = arith.constant 0x3c003c00 : i32  // (f16)1.0 in both halves
    %acc_init   = arith.constant 0 : i32           // (f32)0.0
    %base       = arith.constant 0 : index

    %ptr = wave.ptr_add %out, %base
        : !wave.ptr<i32, #wave.global>, index -> !wave.ptr<i32, #wave.global>

    %a   = waveamd.fragment_fill %ones_f16x2
        : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 8>
    %b   = waveamd.fragment_fill %ones_f16x2
        : i32 -> !waveamd.fragment<1, f16, 16, 16, 32, 8>
    %acc = waveamd.fragment_fill %acc_init
        : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 8>

    %d = waveamd.mma "wmma.f32.16x16x16.f16" %a, %b, %acc
        : !waveamd.fragment<0, f16, 16, 16, 32, 8>,
          !waveamd.fragment<1, f16, 16, 16, 32, 8>,
          !waveamd.fragment<2, f32, 16, 16, 32, 8>
       -> !waveamd.fragment<2, f32, 16, 16, 32, 8>

    %tok = waveamd.fragment_store %d -> %ptr
        : (!waveamd.fragment<2, f32, 16, 16, 32, 8>,
           !wave.ptr<i32, #wave.global>) -> !wave.mem.token
    return
  }
}

} // module
