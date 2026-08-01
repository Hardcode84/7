//===- WaveAMDRegAllocStorage.cpp - Register storage semantics -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocStorage.h"

#include "../WaveAMDHardwareResources.h"

using namespace mlir;
using namespace mlir::wave::regalloc_detail;

std::optional<RegAllocStorageProperties>
mlir::wave::regalloc_detail::getRegAllocStorageProperties(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || wave::getHardwareResourceForValue(value))
    return std::nullopt;
  using waveamdmachine::RegClass;
  if (type.getRegClass() != RegClass::SGPR &&
      type.getRegClass() != RegClass::VGPR &&
      type.getRegClass() != RegClass::AGPR)
    return std::nullopt;

  RegAllocStorageProperties properties{type};
  // Vector live-ins are ordinary allocatable values at this stage.  Scalar
  // live-ins may overlap reserved kernel ABI lanes, so they retain an explicit
  // edge copy.  This is a machine-storage rule, not a control-flow rule.
  properties.mayAliasExclusiveJoin =
      type.getRegClass() == RegClass::VGPR && type.getIndex() < 0;
  return properties;
}

static waveamdmachine::RegType getUnassignedType(waveamdmachine::RegType type) {
  return waveamdmachine::RegType::get(type.getContext(), type.getRegClass(),
                                      type.getWidth(), /*index=*/-1);
}

static FailureOr<Value>
cloneImmediateTupleMove(OpBuilder &builder, Value value,
                        waveamdmachine::RegType resultType) {
  auto move = value.getDefiningOp<waveamdmachine::VMovB32TupleOp>();
  if (!move || !move.getSource().getDefiningOp<waveamdmachine::ImmOp>())
    return failure();
  Operation *clone = builder.clone(*move);
  clone->getResult(0).setType(resultType);
  return clone->getResult(0);
}

static Value materializeAGPRCopy(OpBuilder &builder, Location loc, Value value,
                                 waveamdmachine::RegType resultType) {
  Operation *def = value.getDefiningOp();
  if (isa_and_nonnull<waveamdmachine::UninitOp,
                      waveamdmachine::VAccvgprWriteB32TupleOp>(def)) {
    Operation *clone = builder.clone(*def);
    clone->getResult(0).setType(resultType);
    return clone->getResult(0);
  }

  waveamdmachine::RegType vgprType = waveamdmachine::RegType::get(
      resultType.getContext(), waveamdmachine::RegClass::VGPR,
      resultType.getWidth(), /*index=*/-1);
  Value vgpr = waveamdmachine::VAccvgprReadB32TupleOp::create(builder, loc,
                                                              vgprType, value)
                   .getResult();
  return waveamdmachine::VAccvgprWriteB32TupleOp::create(builder, loc,
                                                         resultType, vgpr)
      .getResult();
}

FailureOr<Value> mlir::wave::regalloc_detail::materializeRegAllocCopy(
    OpBuilder &builder, Location loc, Value value) {
  std::optional<RegAllocStorageProperties> properties =
      getRegAllocStorageProperties(value);
  if (!properties)
    return emitError(loc, "cannot copy non-allocatable register storage");
  waveamdmachine::RegType resultType = getUnassignedType(properties->type);

  FailureOr<Value> immediate =
      cloneImmediateTupleMove(builder, value, resultType);
  if (succeeded(immediate))
    return *immediate;

  if (properties->type.getRegClass() == waveamdmachine::RegClass::AGPR)
    return materializeAGPRCopy(builder, loc, value, resultType);
  return waveamdmachine::CopyTupleOp::create(builder, loc, resultType, value)
      .getResult();
}
