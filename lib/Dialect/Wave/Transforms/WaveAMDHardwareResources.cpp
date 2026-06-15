//===- WaveAMDHardwareResources.cpp - Singleton resource helpers ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDHardwareResources.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"

#include <array>

using namespace mlir;

namespace mlir::wave {

static unsigned resourceIndex(HardwareResourceKind kind) {
  return static_cast<unsigned>(kind);
}

static void addUnique(SmallVectorImpl<HardwareResourceKind> &values,
                      HardwareResourceKind kind) {
  if (!llvm::is_contained(values, kind))
    values.push_back(kind);
}

StringRef getHardwareResourceName(HardwareResourceKind kind) {
  switch (kind) {
  case HardwareResourceKind::SCC:
    return "SCC";
  case HardwareResourceKind::VCC:
    return "VCC";
  case HardwareResourceKind::EXEC:
    return "EXEC";
  case HardwareResourceKind::M0:
    return "M0";
  }
  llvm_unreachable("unknown hardware resource");
}

std::optional<HardwareResourceKind> getHardwareResourceForValue(Value value) {
  Type type = value.getType();
  if (isa<waveamdmachine::M0Type>(type))
    return HardwareResourceKind::M0;
  waveamdmachine::RegType regType = dyn_cast<waveamdmachine::RegType>(type);
  if (!regType)
    return std::nullopt;
  if (regType.getRegClass() == waveamdmachine::RegClass::SCC)
    return HardwareResourceKind::SCC;
  if (regType.getRegClass() == waveamdmachine::RegClass::VCC)
    return HardwareResourceKind::VCC;
  return std::nullopt;
}

HardwareResourceEffects getHardwareResourceEffects(Operation *op) {
  HardwareResourceEffects effects;
  for (Value operand : op->getOperands())
    if (std::optional<HardwareResourceKind> kind =
            getHardwareResourceForValue(operand))
      addUnique(effects.reads, *kind);
  for (Value result : op->getResults())
    if (std::optional<HardwareResourceKind> kind =
            getHardwareResourceForValue(result))
      addUnique(effects.writes, *kind);

  namespace traits = OpTrait::waveamdmachine;
  if (op->hasTrait<traits::ReadsExecOp>())
    addUnique(effects.reads, HardwareResourceKind::EXEC);
  if (op->hasTrait<traits::WritesExecOp>())
    addUnique(effects.writes, HardwareResourceKind::EXEC);
  if (isa<waveamdmachine::ExecIfOp>(op))
    addUnique(effects.writes, HardwareResourceKind::SCC);
  return effects;
}

namespace {

struct ResourceBlockInfo {
  SmallVector<Operation *> ops;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, unsigned> lastUse;
  DenseSet<Value> definedInBlock;
};

static void noteResourceUse(Value value, Operation *owner,
                            ResourceBlockInfo &info) {
  if (!getHardwareResourceForValue(value))
    return;
  DenseMap<Operation *, unsigned>::iterator it = info.positions.find(owner);
  if (it == info.positions.end())
    return;
  unsigned &last = info.lastUse[value];
  last = std::max(last, it->second);
}

static void noteResourceResultUses(Operation *op, ResourceBlockInfo &info) {
  for (Value result : op->getResults()) {
    if (!getHardwareResourceForValue(result))
      continue;
    info.definedInBlock.insert(result);
    for (OpOperand &use : result.getUses()) {
      DenseMap<Operation *, unsigned>::iterator it =
          info.positions.find(use.getOwner());
      unsigned index =
          it == info.positions.end() ? info.ops.size() : it->second;
      unsigned &last = info.lastUse[result];
      last = std::max(last, index);
    }
  }
}

static ResourceBlockInfo collectResourceBlockInfo(Block &block) {
  ResourceBlockInfo info;
  for (auto [index, op] : llvm::enumerate(block)) {
    info.ops.push_back(&op);
    info.positions[&op] = index;
  }
  for (Operation *op : info.ops)
    for (Value operand : op->getOperands())
      noteResourceUse(operand, op, info);
  for (Operation *op : info.ops)
    noteResourceResultUses(op, info);
  return info;
}

static void eraseLiveValue(SmallVectorImpl<Value> &values, Value value) {
  SmallVectorImpl<Value>::iterator it = llvm::find(values, value);
  if (it != values.end())
    values.erase(it);
}

using LiveResources = std::array<SmallVector<Value, 4>, 4>;

static SmallVectorImpl<Value> &liveSet(HardwareResourceKind kind,
                                       LiveResources &live) {
  return live[resourceIndex(kind)];
}

static void initializeLiveResources(const ResourceBlockInfo &info,
                                    LiveResources &live) {
  for (const std::pair<Value, unsigned> &entry : info.lastUse) {
    Value value = entry.first;
    if (info.definedInBlock.contains(value))
      continue;
    std::optional<HardwareResourceKind> kind =
        getHardwareResourceForValue(value);
    if (kind)
      liveSet(*kind, live).push_back(value);
  }
}

static void retireResourceOperands(Operation *op, unsigned index,
                                   const ResourceBlockInfo &info,
                                   LiveResources &live) {
  for (Value operand : op->getOperands()) {
    std::optional<HardwareResourceKind> kind =
        getHardwareResourceForValue(operand);
    if (!kind || info.lastUse.lookup(operand) != index)
      continue;
    eraseLiveValue(liveSet(*kind, live), operand);
  }
}

static LogicalResult
verifyWritesAvailable(Operation *op, ArrayRef<HardwareResourceKind> written,
                      LiveResources &live, StringRef pass) {
  for (HardwareResourceKind kind : written) {
    SmallVectorImpl<Value> &values = liveSet(kind, live);
    if (!values.empty())
      return op->emitError(pass)
             << " found overlapping " << getHardwareResourceName(kind)
             << " live range after hardware-register preservation";
  }
  return success();
}

static void trackResourceResults(Operation *op, unsigned index,
                                 const ResourceBlockInfo &info,
                                 LiveResources &live) {
  for (Value result : op->getResults()) {
    std::optional<HardwareResourceKind> kind =
        getHardwareResourceForValue(result);
    DenseMap<Value, unsigned>::const_iterator it = info.lastUse.find(result);
    if (!kind || it == info.lastUse.end() || it->second <= index)
      continue;
    liveSet(*kind, live).push_back(result);
  }
}

static LogicalResult verifyNoResourceOverlap(Block &block, StringRef pass) {
  ResourceBlockInfo info = collectResourceBlockInfo(block);
  LiveResources live;
  initializeLiveResources(info, live);
  for (auto [index, op] : llvm::enumerate(info.ops)) {
    retireResourceOperands(op, index, info, live);
    HardwareResourceEffects effects = getHardwareResourceEffects(op);
    if (failed(verifyWritesAvailable(op, effects.writes, live, pass)))
      return failure();
    trackResourceResults(op, index, info, live);
  }
  return success();
}

static LogicalResult verifyNoResourceOverlap(Region &region, StringRef pass) {
  for (Block &block : region) {
    if (failed(verifyNoResourceOverlap(block, pass)))
      return failure();
    for (Operation &op : block)
      for (Region &nested : op.getRegions())
        if (failed(verifyNoResourceOverlap(nested, pass)))
          return failure();
  }
  return success();
}

} // namespace

LogicalResult verifyNoHardwareResourceLiveRangeOverlap(func::FuncOp func,
                                                       StringRef pass) {
  return verifyNoResourceOverlap(func.getBody(), pass);
}

} // namespace mlir::wave
