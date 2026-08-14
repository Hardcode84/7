//===- WaveSymbolicMemoryPreparation.h - symbolic access maps -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVESYMBOLICMEMORYPREPARATION_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVESYMBOLICMEMORYPREPARATION_H
#include "../IR/WaveIndexMap.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/SmallVector.h"
#include <cstdint>
#include <optional>
#include <string>
namespace mlir::wave::symbolic_memory {
struct MemoryAccess {
  SmallVector<Value> bases;
  SmallVector<Value> bindings;
  SmallVector<std::string> bindingNames;
  SmallVector<Value> inactiveComponents;
  MemoryMappingAttr mapping;
  SimdType packetType;
  Value packet, dependency, ambientCondition, inactiveToken;
  Attribute cache;
  Type tokenType;
  Operation *op = nullptr;
  WhereOp packetWhere;
  bool gather = false;
};
struct AccessShape {
  int64_t slotCount = 0, elementBits = 0;
};
struct AccessAxes {
  sym::ExprHandle block, slot;
  std::optional<sym::ExprHandle> item;
  Value itemValue;
};
struct PacketActivityDomain {
  sym::PredHandle active;
  SmallVector<sym::PredHandle> facts;
  Value condition;
  int64_t firstSlot = 0, slotCount = 0;
};
struct AccessMap {
  MemoryAccess *access = nullptr;
  AccessShape shape;
  AccessAxes axes;
  indexing::IndexAddress address;
  sym::ExprHandle baseSelector;
  SmallVector<PacketActivityDomain, 2> packetActivityDomains;
  Value condition;
  int64_t transactionFirstSlot = 0, transactionSlotCount = 0;
  Location getLoc() const { return access->op->getLoc(); }
};
using AccessGroup = SmallVector<AccessMap, 2>;
class Preparation {
public:
  explicit Preparation(IRRewriter &rewriter);
  ~Preparation();
  void track(Operation *op);
  void prepareForParentErasure(Operation *parent);
  void commit();

private:
  IRRewriter &rewriter;
  SmallVector<Operation *, 8> createdOps;
};
Type getComponentType(const MemoryAccess &access);
SmallVector<Value> getPacketComponents(IRRewriter &rewriter,
                                       const MemoryAccess &access, Value packet,
                                       int64_t slotCount,
                                       Preparation *preparation = nullptr);
bool isOwnedPacketRegion(Block &block, Operation *memory = nullptr);
PtrType getMemoryBasePtrType(Type type);
AccessMap specializeTransactionRange(const AccessMap &access, int64_t firstSlot,
                                     int64_t slotCount);
AccessMap specializePacketActivity(const AccessMap &access,
                                   const PacketActivityDomain &domain);
FailureOr<AccessGroup>
prepareAccessGroup(IRRewriter &rewriter, MutableArrayRef<MemoryAccess> accesses,
                   WaveDialect &dialect, Preparation &transaction);
} // namespace mlir::wave::symbolic_memory
#endif
