//===- wave_runtime.cpp - Wave host-side runtime helpers ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Thin runtime shims that adapt host-side `memref<...>` descriptors into
// `void *` device pointers suitable for passing through MLIR's GPU launch
// machinery as `!wave.ptr<T, #wave.global>` arguments. The kernel side
// (where Wave ops live) is emitted by `wave-translate` and does not go
// through these helpers.
//
// The C-interface ABI follows MLIR's standard: `_mlir_ciface_*` wrappers
// take a pointer to a `StridedMemRefType<T, N>` produced by
// `--convert-func-to-llvm emit-c-wrappers=true` (or the `llvm.emit_c_interface`
// per-function attribute on the MLIR declaration).
//
//===----------------------------------------------------------------------===//

#include <cstdint>

namespace {

// Matches MLIR's `StridedMemRefType<T, 1>` ABI (CRunnerUtils.h).
template <typename T> struct StridedMemRef1D {
  T *basePtr;
  T *data;
  int64_t offset;
  int64_t sizes[1];
  int64_t strides[1];
};

template <typename T> void *toGlobalPtr(StridedMemRef1D<T> *desc) {
  // `data + offset` is the host-side handle for the first logical element.
  // For ROCm/HIP host-allocated buffers registered with `gpu.host_register`
  // or returned by `mgpuMemAlloc`, this is the address the device will see.
  return static_cast<void *>(desc->data + desc->offset);
}

} // namespace

extern "C" {

void *_mlir_ciface_wave_memref_to_ptr_global_i32(StridedMemRef1D<int32_t> *m) {
  return toGlobalPtr(m);
}

void *_mlir_ciface_wave_memref_to_ptr_global_f32(StridedMemRef1D<float> *m) {
  return toGlobalPtr(m);
}

// 16-bit floats use uint16_t slots; helper only needs the bit address.
void *_mlir_ciface_wave_memref_to_ptr_global_f16(StridedMemRef1D<uint16_t> *m) {
  return toGlobalPtr(m);
}

void *
_mlir_ciface_wave_memref_to_ptr_global_bf16(StridedMemRef1D<uint16_t> *m) {
  return toGlobalPtr(m);
}

void *_mlir_ciface_wave_memref_to_ptr_global_i64(StridedMemRef1D<int64_t> *m) {
  return toGlobalPtr(m);
}

void *_mlir_ciface_wave_memref_to_ptr_global_f64(StridedMemRef1D<double> *m) {
  return toGlobalPtr(m);
}

} // extern "C"
