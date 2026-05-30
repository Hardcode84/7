//===- WaveAMDABI.cpp - Wave AMD ABI helpers --------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/WaveAMDABI.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"

#include <algorithm>

using namespace mlir;
using namespace mlir::waveamd;

static unsigned bitWidth(Type type) {
  if (auto mask = dyn_cast<wave::MaskType>(type))
    return mask.getWidth();
  if (auto vecTy = dyn_cast<VectorType>(type)) {
    Type elementType = vecTy.getElementType();
    if (elementType.isIntOrFloat())
      return elementType.getIntOrFloatBitWidth() * vecTy.getNumElements();
  }
  if (type.isIntOrFloat())
    return type.getIntOrFloatBitWidth();
  return 32;
}

bool mlir::waveamd::isKernargPointer(Type type) {
  return isa<wave::PtrType>(type);
}

bool mlir::waveamd::isKernargBufferPointer(Type type) {
  auto ptr = dyn_cast<wave::PtrType>(type);
  return ptr && isa<BufferAddressSpaceAttr>(ptr.getAddressSpace());
}

bool mlir::waveamd::isKernargGlobalBuffer(Type type) {
  return isKernargPointer(type) && !isKernargBufferPointer(type);
}

unsigned mlir::waveamd::getKernargRegisterWidth(Type type) {
  if (isKernargBufferPointer(type))
    return 4;
  if (isKernargPointer(type))
    return 2;
  if (auto simd = dyn_cast<wave::SimdType>(type))
    type = simd.getElementType();
  return (bitWidth(type) + 31) / 32;
}

unsigned mlir::waveamd::getKernargByteSize(Type type) {
  return getKernargByteSizeForRegisterWidth(getKernargRegisterWidth(type));
}

unsigned mlir::waveamd::getKernargByteSizeForRegisterWidth(unsigned width) {
  return width * 4u;
}

bool mlir::waveamd::isValidKernargRegisterWidth(bool pointer, unsigned width) {
  if (pointer)
    return width == 2 || width == 4;
  return width == 1 || width == 2 || width == 4;
}

SmallVector<KernargSlot> mlir::waveamd::getKernargLayout(TypeRange types) {
  SmallVector<KernargSlot> layout;
  layout.reserve(types.size());
  unsigned offset = 0;
  for (Type type : types) {
    unsigned size = getKernargByteSize(type);
    layout.push_back(KernargSlot{offset, size, isKernargGlobalBuffer(type)});
    offset += size;
  }
  return layout;
}

unsigned mlir::waveamd::alignKernargSegmentSize(unsigned byteSize) {
  return (std::max(byteSize, 4u) + 7u) & ~7u;
}

unsigned mlir::waveamd::getKernargSegmentSize(TypeRange types) {
  unsigned size = 0;
  for (Type type : types)
    size += getKernargByteSize(type);
  return alignKernargSegmentSize(size);
}
