//===- WaveToLLVM.cpp - Wave to LLVM conversion -----------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/WaveToLLVM/WaveToLLVM.h"

#include "mlir/Conversion/ConvertToLLVM/ToLLVMInterface.h"
#include "mlir/Conversion/LLVMCommon/TypeConverter.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/LLVMIR/LLVMTypes.h"
#include "mlir/Dialect/Wave/IR/Wave.h"

using namespace mlir;
using namespace mlir::wave;

namespace {

// AMDGPU address-space numbering (matches ROCDL / clang AMDGPU):
//   1 = global, 3 = shared (LDS), 5 = private (scratch).
constexpr unsigned kAddrSpaceGlobal = 1;
constexpr unsigned kAddrSpaceShared = 3;
constexpr unsigned kAddrSpacePrivate = 5;

std::optional<unsigned> waveAddressSpaceForAttr(Attribute attr) {
  if (isa<GlobalAddressSpaceAttr>(attr))
    return kAddrSpaceGlobal;
  if (isa<SharedAddressSpaceAttr>(attr))
    return kAddrSpaceShared;
  if (isa<PrivateAddressSpaceAttr>(attr))
    return kAddrSpacePrivate;
  return std::nullopt;
}

struct WaveToLLVMDialectInterface : public ConvertToLLVMPatternInterface {
  WaveToLLVMDialectInterface(Dialect *dialect)
      : ConvertToLLVMPatternInterface(dialect) {}

  void loadDependentDialects(MLIRContext *context) const final {
    context->loadDialect<LLVM::LLVMDialect>();
  }

  void populateConvertToLLVMConversionPatterns(
      ConversionTarget & /*target*/, LLVMTypeConverter &typeConverter,
      RewritePatternSet & /*patterns*/) const final {
    populateWaveToLLVMTypeConversions(typeConverter);
  }
};

} // namespace

void mlir::wave::populateWaveToLLVMTypeConversions(
    LLVMTypeConverter &converter) {
  converter.addConversion([&converter](wave::PtrType type) -> Type {
    auto addrSpace = waveAddressSpaceForAttr(type.getAddressSpace());
    if (!addrSpace)
      return nullptr;
    return LLVM::LLVMPointerType::get(&converter.getContext(), *addrSpace);
  });
}

void mlir::wave::registerConvertWaveToLLVMInterface(DialectRegistry &registry) {
  registry.addExtension(+[](MLIRContext * /*ctx*/, wave::WaveDialect *dialect) {
    dialect->addInterfaces<WaveToLLVMDialectInterface>();
  });
}
