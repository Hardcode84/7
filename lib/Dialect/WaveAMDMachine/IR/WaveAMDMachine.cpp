//===- WaveAMDMachine.cpp - WaveAMDMachine dialect --------------------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/Utils/InferIntRangeCommon.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/MathExtras.h"

#include <cstdint>
#include <limits>

using namespace mlir;
using namespace mlir::waveamdmachine;

static constexpr StringLiteral kKernelMetadataAttr = "waveamdmachine.metadata";
static constexpr StringLiteral kKernelMetadataEntryName = "name";
static constexpr StringLiteral kKernelMetadataEntryValue = "value";

StringRef mlir::waveamdmachine::getKernelMetadataAttrName() {
  return kKernelMetadataAttr;
}

static FailureOr<KernelMetadataEntry> parseKernelMetadataEntry(Attribute attr,
                                                               Operation *op) {
  auto dict = dyn_cast<DictionaryAttr>(attr);
  if (!dict)
    return op->emitError() << kKernelMetadataAttr
                           << " entries must be dictionaries";
  auto name = dict.getAs<StringAttr>(kKernelMetadataEntryName);
  if (!name || name.getValue().empty())
    return op->emitError() << kKernelMetadataAttr
                           << " entries need non-empty string `"
                           << kKernelMetadataEntryName << "`";
  Attribute value = dict.get(kKernelMetadataEntryValue);
  if (!value)
    return op->emitError() << kKernelMetadataAttr << " entry `"
                           << name.getValue() << "` needs `"
                           << kKernelMetadataEntryValue << "`";
  return KernelMetadataEntry{name, value};
}

FailureOr<SmallVector<KernelMetadataEntry>>
mlir::waveamdmachine::getKernelMetadataEntries(Operation *op) {
  Attribute attr = op->getAttr(kKernelMetadataAttr);
  SmallVector<KernelMetadataEntry> entries;
  if (!attr || isa<UnitAttr>(attr))
    return entries;
  auto array = dyn_cast<ArrayAttr>(attr);
  if (!array)
    return op->emitError() << kKernelMetadataAttr
                           << " must be unit or an array";
  entries.reserve(array.size());
  for (Attribute entryAttr : array) {
    FailureOr<KernelMetadataEntry> entry =
        parseKernelMetadataEntry(entryAttr, op);
    if (failed(entry))
      return failure();
    entries.push_back(*entry);
  }
  return entries;
}

static DictionaryAttr
getKernelMetadataEntryAttr(Builder &builder, StringRef name, Attribute value) {
  return builder.getDictionaryAttr({
      builder.getNamedAttr(kKernelMetadataEntryName,
                           builder.getStringAttr(name)),
      builder.getNamedAttr(kKernelMetadataEntryValue, value),
  });
}

LogicalResult mlir::waveamdmachine::setKernelMetadataEntry(Operation *op,
                                                           Builder &builder,
                                                           StringRef name,
                                                           Attribute value) {
  FailureOr<SmallVector<KernelMetadataEntry>> entries =
      getKernelMetadataEntries(op);
  if (failed(entries))
    return failure();

  SmallVector<Attribute> newEntries;
  bool replaced = false;
  for (const KernelMetadataEntry &entry : *entries) {
    if (entry.name.getValue() == name) {
      if (!replaced) {
        newEntries.push_back(getKernelMetadataEntryAttr(builder, name, value));
        replaced = true;
      }
      continue;
    }
    newEntries.push_back(getKernelMetadataEntryAttr(
        builder, entry.name.getValue(), entry.value));
  }
  if (!replaced)
    newEntries.push_back(getKernelMetadataEntryAttr(builder, name, value));
  op->setAttr(kKernelMetadataAttr, builder.getArrayAttr(newEntries));
  return success();
}

LogicalResult mlir::waveamdmachine::removeKernelMetadataEntries(
    Operation *op, Builder &builder, ArrayRef<StringRef> names) {
  FailureOr<SmallVector<KernelMetadataEntry>> entries =
      getKernelMetadataEntries(op);
  if (failed(entries))
    return failure();

  SmallVector<Attribute> kept;
  for (const KernelMetadataEntry &entry : *entries) {
    if (llvm::is_contained(names, entry.name.getValue()))
      continue;
    kept.push_back(getKernelMetadataEntryAttr(builder, entry.name.getValue(),
                                              entry.value));
  }
  op->setAttr(kKernelMetadataAttr, builder.getArrayAttr(kept));
  return success();
}

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInterfaces.cpp.inc"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsDialect.cpp.inc"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsEnums.cpp.inc"

void WaveAMDMachineDialect::initialize() {
  registerTypes();
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.cpp.inc"
      >();
}

void WaveAMDMachineDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsTypes.cpp.inc"
      >();
}

static bool isSingletonFlagRegClass(RegClass regClass) {
  return regClass == RegClass::SCC || regClass == RegClass::VCC;
}

LogicalResult RegType::verify(function_ref<InFlightDiagnostic()> emitError,
                              RegClass regClass, int64_t width, int64_t index) {
  if (width <= 0)
    return emitError() << "register width must be positive";
  if (index < -1)
    return emitError() << "register index must be -1 (virtual) or non-negative";
  if (!isSingletonFlagRegClass(regClass))
    return success();
  if (width != 1)
    return emitError() << "SCC/VCC register width must be 1";
  if (index != -1)
    return emitError() << "SCC/VCC registers cannot have a physical index";
  return success();
}

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsTypes.cpp.inc"

static bool isRegClassWidth(Type type, RegClass regClass, int64_t width) {
  auto regType = dyn_cast<RegType>(type);
  return regType && regType.getRegClass() == regClass &&
         regType.getWidth() == width;
}

static bool isVGPROrAGPR(RegClass regClass) {
  return regClass == RegClass::VGPR || regClass == RegClass::AGPR;
}

static LogicalResult verifyVGPRWidth(Operation *op, Value value, int64_t width,
                                     StringRef name) {
  if (!isRegClassWidth(value.getType(), RegClass::VGPR, width))
    return op->emitOpError()
           << name << " must be !waveamdmachine.reg<vgpr, " << width << ">";
  return success();
}

static LogicalResult verifyAVGPRWidth(Operation *op, Value value, int64_t width,
                                      StringRef name) {
  auto regType = dyn_cast<RegType>(value.getType());
  if (!regType || !isVGPROrAGPR(regType.getRegClass()) ||
      regType.getWidth() != width)
    return op->emitOpError()
           << name << " must be !waveamdmachine.reg<vgpr|agpr, " << width
           << ">";
  return success();
}

static LogicalResult verifyImmediateOrVGPRWidth(Operation *op, Value value,
                                                int64_t width, StringRef name) {
  if (isa<ImmType>(value.getType()))
    return success();
  return verifyVGPRWidth(op, value, width, name);
}

static LogicalResult verifyImmediateOrAVGPRWidth(Operation *op, Value value,
                                                 int64_t width,
                                                 StringRef name) {
  if (isa<ImmType>(value.getType()))
    return success();
  return verifyAVGPRWidth(op, value, width, name);
}

static LogicalResult verifySameAVGPRClass(Operation *op, Value lhs, Value rhs,
                                          StringRef name) {
  auto lhsType = cast<RegType>(lhs.getType());
  auto rhsType = cast<RegType>(rhs.getType());
  if (lhsType.getRegClass() != rhsType.getRegClass())
    return op->emitOpError() << name << " register classes must match";
  return success();
}

static ConstantIntRanges
normalizeMachineU32Range(const ConstantIntRanges &range) {
  unsigned bits = range.umin().getBitWidth();
  if (bits == 32)
    return range;
  if (bits == 0 || bits > 32)
    return ConstantIntRanges::maxRange(32);
  return {range.umin().zext(32), range.umax().zext(32), range.smin().sext(32),
          range.smax().sext(32)};
}

static SmallVector<ConstantIntRanges, 2>
normalizeMachineU32Ranges(ArrayRef<ConstantIntRanges> ranges) {
  SmallVector<ConstantIntRanges, 2> normalized;
  normalized.reserve(ranges.size());
  for (const ConstantIntRanges &range : ranges)
    normalized.push_back(normalizeMachineU32Range(range));
  return normalized;
}

void ImmOp::inferResultRanges(ArrayRef<ConstantIntRanges>,
                              SetIntRangeFn setResultRange) {
  int64_t value = getValue();
  if (value < std::numeric_limits<int32_t>::min() ||
      value > std::numeric_limits<uint32_t>::max()) {
    setResultRange(getResult(), ConstantIntRanges::maxRange(32));
    return;
  }

  APInt bits(64, static_cast<uint64_t>(value), /*isSigned=*/true);
  setResultRange(getResult(), ConstantIntRanges::constant(bits.trunc(32)));
}

void VAddU32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                  SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferAdd(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VAndB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                  SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferAnd(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VOrB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                 SetIntRangeFn setResultRange) {
  setResultRange(getResult(),
                 mlir::intrange::inferOr(normalizeMachineU32Ranges(argRanges)));
}

void VXorB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                  SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferXor(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VLshlrevB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                      SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferShl(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VLshrrevB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                      SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferShrU(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VAshrrevI32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                      SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferShrS(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VMulLoU32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                    SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferMul(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VMulHiU32Op::inferResultRanges(ArrayRef<ConstantIntRanges>,
                                    SetIntRangeFn setResultRange) {
  setResultRange(getResult(), ConstantIntRanges::maxRange(32));
}

LogicalResult VMovB32TupleOp::verify() {
  auto resultType = cast<RegType>(getResult().getType());
  if (auto registers = (*this)->getAttrOfType<IntegerAttr>("registers")) {
    if (registers.getInt() != resultType.getWidth())
      return emitOpError(
          "registers attribute must match result register width");
  }
  return success();
}

LogicalResult VPermlane32SwapB32TupleOp::verify() {
  RegType sourceType = cast<RegType>(getSource().getType());
  RegType resultType = cast<RegType>(getResult().getType());
  if (sourceType.getWidth() != resultType.getWidth())
    return emitOpError("source and result widths must match");
  if (sourceType.getWidth() < 2 || sourceType.getWidth() % 2 != 0)
    return emitOpError("source and result widths must be positive even tuples");
  return success();
}

static LogicalResult verifyAllocatedPairAlignment(Operation *op, RegType type,
                                                  StringRef name) {
  if (type.getIndex() >= 0 && type.getIndex() % 2 != 0)
    return op->emitOpError() << name << " must be 64-bit aligned";
  return success();
}

LogicalResult VMovB64TupleOp::verify() {
  auto resultType = cast<RegType>(getResult().getType());
  if (failed(verifyAllocatedPairAlignment(*this, resultType, "result")))
    return failure();
  auto sourceType = dyn_cast<RegType>(getSource().getType());
  if (!sourceType)
    return success();
  if (sourceType.getWidth() != 2)
    return emitOpError("register source must be two dwords");
  return verifyAllocatedPairAlignment(*this, sourceType, "source");
}

LogicalResult VMovB64FromElementsOp::verify() {
  auto resultType = cast<RegType>(getResult().getType());
  if (failed(verifyAllocatedPairAlignment(*this, resultType, "result")))
    return failure();
  auto loType = cast<RegType>(getSourceLo().getType());
  auto hiType = cast<RegType>(getSourceHi().getType());
  if (failed(verifyAllocatedPairAlignment(*this, loType, "source")))
    return failure();
  if (loType.getIndex() >= 0 && hiType.getIndex() >= 0 &&
      hiType.getIndex() != loType.getIndex() + 1)
    return emitOpError("source elements must be adjacent");
  return success();
}

static bool isExecIfMergeRegClass(RegClass regClass) {
  return regClass == RegClass::VGPR || regClass == RegClass::SGPR;
}

static LogicalResult verifyExecIfTokenMergeSource(ExecIfOp op, Type resultType,
                                                  Value value, StringRef arm) {
  if (value.getType() == resultType)
    return success();
  return op.emitOpError() << arm << " yield type must match memory token";
}

static LogicalResult verifyExecIfRegMergeSource(ExecIfOp op, RegType resultReg,
                                                RegType sourceReg,
                                                StringRef arm) {
  if (sourceReg.getWidth() != resultReg.getWidth())
    return op.emitOpError()
           << arm << " yield register width must match result width";
  if (!isExecIfMergeRegClass(sourceReg.getRegClass()))
    return op.emitOpError() << arm << " yield must be VGPR or SGPR";
  return success();
}

static LogicalResult verifyExecIfDataMergeSource(ExecIfOp op, Type resultType,
                                                 Value value, StringRef arm) {
  RegType resultReg = dyn_cast<RegType>(resultType);
  if (!resultReg || resultReg.getRegClass() != RegClass::VGPR)
    return op.emitOpError()
           << "data results with otherwise must be VGPR values";
  if (RegType sourceReg = dyn_cast<RegType>(value.getType()))
    return verifyExecIfRegMergeSource(op, resultReg, sourceReg, arm);
  if (isa<ImmType>(value.getType()) && resultReg.getWidth() == 1)
    return success();
  return op.emitOpError() << arm << " yield must be register or immediate";
}

static LogicalResult verifyExecIfMergeSource(ExecIfOp op, Type resultType,
                                             Value value, StringRef arm) {
  if (isa<MemTokenType>(resultType))
    return verifyExecIfTokenMergeSource(op, resultType, value, arm);
  return verifyExecIfDataMergeSource(op, resultType, value, arm);
}

static LogicalResult verifyExecIfNoElseSource(ExecIfOp op, Type resultType,
                                              Value value, StringRef arm) {
  if (resultType != value.getType())
    return op.emitOpError() << arm << " yield type must match result type";
  return success();
}

static LogicalResult verifyExecIfYield(ExecIfOp op, Region &region,
                                       StringRef arm, bool hasElse) {
  if (region.empty())
    return success();
  YieldOp yield = dyn_cast<YieldOp>(region.front().getTerminator());
  if (!yield)
    return op.emitOpError() << arm << " region must terminate with yield";
  if (yield.getValues().size() != op.getNumResults())
    return op.emitOpError()
           << arm << " yield operand count must match result count";
  for (auto [result, value] :
       llvm::zip_equal(op.getResults(), yield.getValues())) {
    LogicalResult verified =
        hasElse ? verifyExecIfMergeSource(op, result.getType(), value, arm)
                : verifyExecIfNoElseSource(op, result.getType(), value, arm);
    if (failed(verified))
      return failure();
  }
  return success();
}

static LogicalResult verifyExecIfCondition(ExecIfOp op) {
  RegType condType = cast<RegType>(op.getCondition().getType());
  IntegerAttr maskWidth = op->getAttrOfType<IntegerAttr>("mask_width");
  if (condType.getRegClass() == RegClass::SGPR) {
    if (condType.getWidth() != 1 && condType.getWidth() != 2)
      return op.emitOpError("condition must be SGPR1 or SGPR2");
    if (maskWidth)
      return op.emitOpError("SGPR condition must not set mask_width");
    return success();
  }
  if (!maskWidth)
    return op.emitOpError("VCC condition requires mask_width 32 or 64");
  if (maskWidth.getInt() != 32 && maskWidth.getInt() != 64)
    return op.emitOpError("VCC condition requires mask_width 32 or 64");
  return success();
}

LogicalResult ExecIfOp::verify() {
  if (failed(verifyExecIfCondition(*this)))
    return failure();
  bool hasElse = !getElseRegion().empty();
  if (failed(verifyExecIfYield(*this, getThenRegion(), "then", hasElse)))
    return failure();
  return verifyExecIfYield(*this, getElseRegion(), "else", hasElse);
}

void ExecIfOp::getSuccessorRegions(RegionBranchPoint point,
                                   SmallVectorImpl<RegionSuccessor> &regions) {
  bool hasElse = !getElseRegion().empty();
  if (point.isParent()) {
    regions.push_back(RegionSuccessor(&getThenRegion()));
    if (hasElse)
      regions.push_back(RegionSuccessor(&getElseRegion()));
    else if (getNumResults() == 0)
      regions.push_back(RegionSuccessor(getOperation()));
    return;
  }

  RegionBranchTerminatorOpInterface term =
      point.getTerminatorPredecessorOrNull();
  Region *source = term->getParentRegion();
  if (source == &getThenRegion() && hasElse)
    regions.push_back(RegionSuccessor(&getElseRegion()));
  regions.push_back(RegionSuccessor(getOperation()));
}

OperandRange ExecIfOp::getEntrySuccessorOperands(RegionSuccessor successor) {
  return OperandRange((*this)->operand_end(), (*this)->operand_end());
}

ValueRange ExecIfOp::getSuccessorInputs(RegionSuccessor successor) {
  if (successor.isOperation())
    return getResults();
  return ValueRange();
}

bool ExecIfOp::areTypesCompatible(Type lhs, Type rhs) {
  if (lhs == rhs)
    return true;
  RegType resultReg = dyn_cast<RegType>(rhs);
  if (!resultReg || resultReg.getRegClass() != RegClass::VGPR)
    return false;
  if (RegType sourceReg = dyn_cast<RegType>(lhs))
    return sourceReg.getWidth() == resultReg.getWidth() &&
           isExecIfMergeRegClass(sourceReg.getRegClass());
  return isa<ImmType>(lhs) && resultReg.getWidth() == 1;
}

static bool isUniformIfResultRegClass(RegClass regClass) {
  return regClass == RegClass::VGPR || regClass == RegClass::SGPR;
}

bool UniformIfOp::areTypesCompatible(Type lhs, Type rhs) {
  if (lhs == rhs)
    return true;
  RegType resultReg = dyn_cast<RegType>(rhs);
  RegType sourceReg = dyn_cast<RegType>(lhs);
  if (!resultReg || !sourceReg)
    return false;
  return isUniformIfResultRegClass(resultReg.getRegClass()) &&
         sourceReg.getRegClass() == resultReg.getRegClass() &&
         sourceReg.getWidth() == resultReg.getWidth();
}

LogicalResult SGetregHwIdOp::verify() {
  int64_t offset = getOffset();
  int64_t width = getWidth();
  if (offset < 0 || offset >= 32)
    return emitOpError("offset must be in [0, 31]");
  if (width <= 0 || width > 32 || offset + width > 32)
    return emitOpError("width must be in [1, 32 - offset]");
  return success();
}

static LogicalResult verifyUniformIfYieldSource(UniformIfOp op, Type resultType,
                                                Value value, StringRef arm) {
  if (isa<MemTokenType>(resultType)) {
    if (resultType == value.getType())
      return success();
    return op.emitOpError() << arm << " yield type must match result type";
  }

  RegType resultReg = cast<RegType>(resultType);
  if (!isUniformIfResultRegClass(resultReg.getRegClass()))
    return op.emitOpError() << "results must be SGPR, VGPR, or memory tokens";

  RegType sourceReg = dyn_cast<RegType>(value.getType());
  if (!sourceReg || sourceReg.getRegClass() != resultReg.getRegClass() ||
      sourceReg.getWidth() != resultReg.getWidth())
    return op.emitOpError() << arm << " yield type must match result type";
  return success();
}

static LogicalResult verifyUniformIfYield(UniformIfOp op, Region &region,
                                          StringRef arm) {
  if (region.empty())
    return success();
  YieldOp yield = dyn_cast<YieldOp>(region.front().getTerminator());
  if (!yield)
    return op.emitOpError() << arm << " region must terminate with yield";
  if (yield.getValues().size() != op.getNumResults())
    return op.emitOpError()
           << arm << " yield operand count must match result count";
  for (auto [result, value] :
       llvm::zip_equal(op.getResults(), yield.getValues())) {
    if (failed(verifyUniformIfYieldSource(op, result.getType(), value, arm)))
      return failure();
  }
  return success();
}

LogicalResult UniformIfOp::verify() {
  bool hasElse = !getElseRegion().empty();
  if (!hasElse && getNumResults() != 0)
    return emitOpError("results require else region");
  if (failed(verifyUniformIfYield(*this, getThenRegion(), "then")))
    return failure();
  return verifyUniformIfYield(*this, getElseRegion(), "else");
}

void UniformIfOp::getSuccessorRegions(
    RegionBranchPoint point, SmallVectorImpl<RegionSuccessor> &regions) {
  bool hasElse = !getElseRegion().empty();
  if (point.isParent()) {
    regions.push_back(RegionSuccessor(&getThenRegion()));
    if (hasElse)
      regions.push_back(RegionSuccessor(&getElseRegion()));
    else
      regions.push_back(RegionSuccessor(getOperation()));
    return;
  }
  regions.push_back(RegionSuccessor(getOperation()));
}

OperandRange UniformIfOp::getEntrySuccessorOperands(RegionSuccessor successor) {
  return OperandRange((*this)->operand_end(), (*this)->operand_end());
}

ValueRange UniformIfOp::getSuccessorInputs(RegionSuccessor successor) {
  if (successor.isOperation())
    return getResults();
  return ValueRange();
}

MutableOperandRange
YieldOp::getMutableSuccessorOperands(RegionSuccessor successor) {
  MutableOperandRange values = getValuesMutable();
  if (successor.isOperation())
    return values;
  return values.slice(0, 0);
}

static LogicalResult verifyCndmaskSource(Operation *op, Value value,
                                         unsigned resultWidth, StringRef name) {
  RegType regType = dyn_cast<RegType>(value.getType());
  if (!regType) {
    assert(isa<ImmType>(value.getType()) &&
           "ODS permits only registers or immediates");
    if (resultWidth != 1)
      return op->emitOpError(name)
             << " immediate source requires width-1 result";
    return success();
  }
  if (regType.getWidth() != resultWidth)
    return op->emitOpError(name) << " source width " << regType.getWidth()
                                 << " must match result width " << resultWidth;
  return success();
}

LogicalResult VCndmaskB32TupleOp::verify() {
  RegType resultType = cast<RegType>(getResult().getType());
  if (failed(verifyCndmaskSource(*this, getFalseValue(), resultType.getWidth(),
                                 "false")) ||
      failed(verifyCndmaskSource(*this, getTrueValue(), resultType.getWidth(),
                                 "true")))
    return failure();
  RegType conditionType = cast<RegType>(getCondition().getType());
  if (conditionType.getWidth() != 1 && conditionType.getWidth() != 2)
    return emitOpError("condition width must be 1 or 2");
  return success();
}

LogicalResult VCndmaskB32VccOp::verify() {
  RegType resultType = cast<RegType>(getResult().getType());
  if (failed(verifyCndmaskSource(*this, getFalseValue(), resultType.getWidth(),
                                 "false")) ||
      failed(verifyCndmaskSource(*this, getTrueValue(), resultType.getWidth(),
                                 "true")))
    return failure();
  return success();
}

LogicalResult VAccvgprReadB32TupleOp::verify() {
  auto sourceType = cast<RegType>(getSource().getType());
  auto resultType = cast<RegType>(getResult().getType());
  if (sourceType.getWidth() != resultType.getWidth())
    return emitOpError("source and result widths must match");
  return success();
}

LogicalResult VAccvgprWriteB32TupleOp::verify() {
  RegType resultType = cast<RegType>(getResult().getType());
  if (isa<ImmType>(getSource().getType())) {
    if (!isInlineImm32(getSource()))
      return emitOpError("immediate source must be an inline 32-bit constant");
    return success();
  }
  RegType sourceType = cast<RegType>(getSource().getType());
  if (sourceType.getWidth() != resultType.getWidth())
    return emitOpError("source and result widths must match");
  return success();
}

LogicalResult SMovB32TupleOp::verify() {
  auto resultType = cast<RegType>(getResult().getType());
  if (auto registers = (*this)->getAttrOfType<IntegerAttr>("registers")) {
    if (registers.getInt() != resultType.getWidth())
      return emitOpError(
          "registers attribute must match result register width");
  }
  return success();
}

static int64_t sumElementWidths(ValueRange elements) {
  int64_t total = 0;
  for (Value e : elements)
    total += cast<RegType>(e.getType()).getWidth();
  return total;
}

static LogicalResult verifyTupleElements(Operation *op, RegType tupleType,
                                         ValueRange elements) {
  int64_t total = sumElementWidths(elements);
  if (tupleType.getWidth() != total)
    return op->emitOpError("element widths sum (")
           << total << ") must match tuple register width ("
           << tupleType.getWidth() << ")";
  for (Value e : elements) {
    auto eType = cast<RegType>(e.getType());
    if (eType.getRegClass() != tupleType.getRegClass())
      return op->emitOpError("element register class must match tuple's");
  }
  return success();
}

LogicalResult TupleToElementsOp::verify() {
  return verifyTupleElements(*this, cast<RegType>(getTuple().getType()),
                             getElements());
}

static bool canFoldTupleJoinSplit(TupleFromElementsOp joined,
                                  ValueRange splitElements) {
  if (joined.getElements().size() != splitElements.size())
    return false;
  RegType tupleType = cast<RegType>(joined.getTuple().getType());
  int64_t offset = 0;
  for (auto [source, result] :
       llvm::zip_equal(joined.getElements(), splitElements)) {
    if (source.getType() != result.getType())
      return false;
    RegType sourceType = cast<RegType>(source.getType());
    if (tupleType.getIndex() >= 0 &&
        sourceType.getIndex() != tupleType.getIndex() + offset)
      return false;
    offset += sourceType.getWidth();
  }
  return true;
}

LogicalResult TupleToElementsOp::fold(FoldAdaptor,
                                      SmallVectorImpl<OpFoldResult> &results) {
  if (getElements().size() == 1 &&
      getElements().front().getType() == getTuple().getType()) {
    results.push_back(getTuple());
    return success();
  }
  TupleFromElementsOp joined = getTuple().getDefiningOp<TupleFromElementsOp>();
  if (!joined || !canFoldTupleJoinSplit(joined, getElements()))
    return failure();
  llvm::append_range(results, joined.getElements());
  return success();
}

LogicalResult TupleFromElementsOp::verify() {
  return verifyTupleElements(*this, cast<RegType>(getTuple().getType()),
                             getElements());
}

static TupleToElementsOp getExactRoundTripSplit(Value element, unsigned index,
                                                size_t resultCount) {
  auto result = dyn_cast<OpResult>(element);
  if (!result || result.getResultNumber() != index)
    return {};
  auto split = dyn_cast_or_null<TupleToElementsOp>(result.getOwner());
  if (!split || split->getNumResults() != resultCount)
    return {};
  return split;
}

static Value getExactRoundTripSource(ValueRange elements) {
  Value sourceTuple;
  for (auto [i, element] : llvm::enumerate(elements)) {
    TupleToElementsOp split =
        getExactRoundTripSplit(element, i, elements.size());
    if (!split)
      return {};
    if (!sourceTuple) {
      sourceTuple = split.getTuple();
      continue;
    }
    if (sourceTuple != split.getTuple())
      return {};
  }
  return sourceTuple;
}

OpFoldResult TupleFromElementsOp::fold(FoldAdaptor) {
  if (getElements().size() == 1 &&
      getElements().front().getType() == getTuple().getType())
    return getElements().front();
  Value sourceTuple = getExactRoundTripSource(getElements());
  if (sourceTuple && sourceTuple.getType() == getTuple().getType())
    return sourceTuple;
  return {};
}

LogicalResult CopyTupleOp::verify() {
  auto sourceType = cast<RegType>(getSource().getType());
  auto resultType = cast<RegType>(getResult().getType());
  if (sourceType.getRegClass() != resultType.getRegClass())
    return emitOpError("source register class must match result");
  if (sourceType.getWidth() != resultType.getWidth())
    return emitOpError("source width must match result width");
  RegClass regClass = resultType.getRegClass();
  if (regClass != RegClass::SGPR && regClass != RegClass::VGPR)
    return emitOpError("supports only SGPR and VGPR copies");
  return success();
}

LogicalResult UpdateTupleOp::verify() {
  auto baseType = cast<RegType>(getBase().getType());
  auto resultType = cast<RegType>(getResult().getType());
  if (baseType.getRegClass() != resultType.getRegClass())
    return emitOpError("base register class must match result");
  if (baseType.getWidth() != resultType.getWidth())
    return emitOpError("base width must match result width");

  ArrayAttr offsets = getOffsets();
  if (offsets.size() != getUpdates().size())
    return emitOpError("offset count must match update count");

  int64_t lastEnd = 0;
  for (auto [offsetAttr, update] : llvm::zip_equal(offsets, getUpdates())) {
    auto offsetInt = dyn_cast<IntegerAttr>(offsetAttr);
    if (!offsetInt)
      return emitOpError("offsets must be integer attributes");
    int64_t offset = offsetInt.getInt();
    if (offset < 0)
      return emitOpError("offsets must be non-negative");
    if (offset < lastEnd)
      return emitOpError("offsets must be sorted and non-overlapping");

    auto updateType = cast<RegType>(update.getType());
    if (updateType.getRegClass() != baseType.getRegClass())
      return emitOpError("update register class must match base");
    int64_t end = offset + updateType.getWidth();
    if (end > baseType.getWidth())
      return emitOpError("update exceeds tuple width");
    lastEnd = end;
  }
  return success();
}

using VerifyRegWidthFn = LogicalResult (*)(Operation *, Value, int64_t,
                                           StringRef);

static LogicalResult verifyMMA(MMAOpInterface mma, int64_t abWidth,
                               int64_t accWidth,
                               VerifyRegWidthFn verifyRegWidth,
                               VerifyRegWidthFn verifyAccWidth) {
  Operation *op = mma.getOperation();
  if (failed(verifyRegWidth(op, mma.getA(), abWidth, "A operand")) ||
      failed(verifyRegWidth(op, mma.getB(), abWidth, "B operand")) ||
      failed(
          verifyAccWidth(op, mma.getAcc(), accWidth, "accumulator operand")) ||
      failed(verifyRegWidth(op, mma.getAccResult(), accWidth, "result")))
    return failure();
  return success();
}

static LogicalResult verifyWMMA(Operation *op, int64_t abWidth) {
  MMAOpInterface mma = cast<MMAOpInterface>(op);
  return verifyMMA(mma, abWidth, /*accWidth=*/8, verifyVGPRWidth,
                   verifyImmediateOrVGPRWidth);
}

LogicalResult WmmaI32_16x16x16_IU8Op::verify() {
  return verifyWMMA(*this, /*abWidth=*/4);
}

LogicalResult WmmaF32_16x16x16_F16Op::verify() {
  return verifyWMMA(*this, /*abWidth=*/8);
}

LogicalResult WmmaF32_16x16x16_BF16Op::verify() {
  return verifyWMMA(*this, /*abWidth=*/8);
}

static LogicalResult verifyMFMA(Operation *op, int64_t abWidth,
                                int64_t accWidth, bool hasScale) {
  MMAOpInterface mma = cast<MMAOpInterface>(op);
  VerifyRegWidthFn verifyAccWidth =
      hasScale ? verifyAVGPRWidth : verifyImmediateOrAVGPRWidth;
  if (failed(
          verifyMMA(mma, abWidth, accWidth, verifyAVGPRWidth, verifyAccWidth)))
    return failure();
  if (!isa<ImmType>(mma.getAcc().getType()) &&
      failed(verifySameAVGPRClass(op, mma.getAcc(), mma.getAccResult(),
                                  "accumulator/result")))
    return failure();
  if (!hasScale)
    return success();
  Value aScale = mma.getAScale();
  Value bScale = mma.getBScale();
  assert(aScale && bScale && "scaled MFMA scale operands required");
  if (failed(verifyVGPRWidth(op, aScale, 1, "A scale operand")) ||
      failed(verifyVGPRWidth(op, bScale, 1, "B scale operand")))
    return failure();
  return success();
}

LogicalResult MfmaF32_16x16x16_F16Op::verify() {
  return verifyMFMA(*this, /*abWidth=*/2, /*accWidth=*/4,
                    /*hasScale=*/false);
}

LogicalResult MfmaF32_16x16x16_BF16Op::verify() {
  return verifyMFMA(*this, /*abWidth=*/2, /*accWidth=*/4,
                    /*hasScale=*/false);
}

LogicalResult MfmaF32_16x16x32_F16Op::verify() {
  return verifyMFMA(*this, /*abWidth=*/4, /*accWidth=*/4,
                    /*hasScale=*/false);
}

LogicalResult MfmaF32_16x16x32_BF16Op::verify() {
  return verifyMFMA(*this, /*abWidth=*/4, /*accWidth=*/4,
                    /*hasScale=*/false);
}

LogicalResult MfmaF32_32x32x16_F16Op::verify() {
  return verifyMFMA(*this, /*abWidth=*/4, /*accWidth=*/16,
                    /*hasScale=*/false);
}

LogicalResult MfmaF32_32x32x16_BF16Op::verify() {
  return verifyMFMA(*this, /*abWidth=*/4, /*accWidth=*/16,
                    /*hasScale=*/false);
}

LogicalResult MfmaScaleF32_16x16x128_F4F4Op::verify() {
  return verifyMFMA(*this, /*abWidth=*/4, /*accWidth=*/4, /*hasScale=*/true);
}

static bool isUniformLoopInitUse(OpOperand &use, UniformLoopOp loop) {
  if (use.getOwner() != loop.getOperation())
    return false;
  for (OpOperand &init : loop.getInitsMutable())
    if (&init == &use)
      return true;
  return false;
}

static bool hasNestedUniformLoopInitUse(Operation *op, Value value) {
  UniformLoopOp parentLoop = op->getParentOfType<UniformLoopOp>();
  if (!parentLoop)
    return false;
  for (OpOperand &use : value.getUses()) {
    UniformLoopOp loop = dyn_cast<UniformLoopOp>(use.getOwner());
    if (loop && parentLoop->isProperAncestor(loop.getOperation()) &&
        isUniformLoopInitUse(use, loop))
      return true;
  }
  return false;
}

static void addNestedUniformLoopInitEffect(
    Operation *op, Value value,
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  if (hasNestedUniformLoopInitUse(op, value))
    effects.emplace_back(MemoryEffects::Write::get());
}

void CopyTupleOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  addNestedUniformLoopInitEffect(getOperation(), getResult(), effects);
}

void SMovB32ValueOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  addNestedUniformLoopInitEffect(getOperation(), getResult(), effects);
}

void SMovB32TupleOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  addNestedUniformLoopInitEffect(getOperation(), getResult(), effects);
}

void VMovB32TupleOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  addNestedUniformLoopInitEffect(getOperation(), getResult(), effects);
}

void VMovB64TupleOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  addNestedUniformLoopInitEffect(getOperation(), getResult(), effects);
}

static LogicalResult verifyUniformLoopTerminator(UniformLoopOp loop,
                                                 ContinueIfOp terminator) {
  if (terminator.getCarries().size() != loop.getInits().size())
    return terminator.emitOpError(
        "carries count must match parent uniform_loop inits");
  for (auto [carry, init] :
       llvm::zip(terminator.getCarries(), loop.getInits())) {
    if (carry.getType() != init.getType())
      return terminator.emitOpError(
                 "carry types must match parent uniform_loop init types: ")
             << carry.getType() << " vs " << init.getType();
  }
  return success();
}

LogicalResult DmaIssueDelayOp::verify() {
  int64_t cycles = getCyclesAttr().getInt();
  IntegerAttr overlapAttr = getOverlapCyclesAttr();
  int64_t overlap = overlapAttr ? overlapAttr.getInt() : 0;
  if (cycles <= 0)
    return emitOpError("requires positive cycles");
  if (overlap < 0)
    return emitOpError("requires non-negative overlap_cycles");
  if (overlap > cycles)
    return emitOpError("overlap_cycles cannot exceed cycles");
  return success();
}

static LogicalResult verifyUniformLoopFetchAlignment(UniformLoopOp loop) {
  IntegerAttr alignmentAttr = loop.getFetchAlignmentAttr();
  if (!alignmentAttr)
    return success();
  int64_t alignment = alignmentAttr.getInt();
  if (alignment < 4 || alignment > 256 ||
      !llvm::isPowerOf2_64(static_cast<uint64_t>(alignment)))
    return loop.emitOpError(
        "fetch_alignment must be a power of two from 4 to 256 bytes");
  return success();
}

static LogicalResult verifyUniformLoopFetchPhase(UniformLoopOp loop) {
  IntegerAttr phaseAttr = loop.getFetchPhaseAttr();
  if (!phaseAttr)
    return success();
  IntegerAttr alignmentAttr = loop.getFetchAlignmentAttr();
  if (!alignmentAttr)
    return loop.emitOpError("fetch_phase requires fetch_alignment");
  int64_t phase = phaseAttr.getInt();
  int64_t alignment = alignmentAttr.getInt();
  if (phase < 0 || phase >= alignment)
    return loop.emitOpError(
        "fetch_phase must be non-negative and smaller than fetch_alignment");
  if (phase % 4 != 0)
    return loop.emitOpError("fetch_phase must be 4-byte aligned");
  return success();
}

static LogicalResult verifyUniformLoopFetchPlacement(UniformLoopOp loop) {
  if (failed(verifyUniformLoopFetchAlignment(loop)))
    return failure();
  return verifyUniformLoopFetchPhase(loop);
}

LogicalResult UniformLoopOp::verify() {
  if (failed(verifyUniformLoopFetchPlacement(*this)))
    return failure();
  Block &body = getBody().front();
  if (body.getNumArguments() != getInits().size())
    return emitOpError("body block must have one argument per init carry");
  for (auto [init, arg] : llvm::zip(getInits(), body.getArguments())) {
    if (init.getType() != arg.getType())
      return emitOpError(
                 "init carry types must match body block argument types: ")
             << init.getType() << " vs " << arg.getType();
  }
  if (getResults().size() != getInits().size())
    return emitOpError("results count must match inits count");
  for (auto [init, result] : llvm::zip(getInits(), getResults())) {
    if (init.getType() != result.getType())
      return emitOpError("init carry types must match result types: ")
             << init.getType() << " vs " << result.getType();
  }
  if (body.empty() || !isa<ContinueIfOp>(body.back()))
    return emitOpError(
        "body must be terminated by a waveamdmachine.continue_if");
  ContinueIfOp terminator = cast<ContinueIfOp>(body.back());
  return verifyUniformLoopTerminator(*this, terminator);
}

// Body region successors (from the WaveAMDMachine perspective):
//   - From parent: if entry_cond is missing, only the body is a
//     successor (always entered); else both the body (cond=1) and the
//     parent (cond=0; results = inits) are.
//   - From body: both the body again (continue_if cond=1) and the
//     parent (cond=0; results = continue_if.carries).
void UniformLoopOp::getSuccessorRegions(
    RegionBranchPoint point, SmallVectorImpl<RegionSuccessor> &regions) {
  if (point.isParent()) {
    regions.push_back(RegionSuccessor(&getBody()));
    if (getEntryCond())
      regions.push_back(RegionSuccessor(getOperation()));
    return;
  }
  regions.push_back(RegionSuccessor(&getBody()));
  regions.push_back(RegionSuccessor(getOperation()));
}

OperandRange
UniformLoopOp::getEntrySuccessorOperands(RegionSuccessor successor) {
  return getInits();
}

ValueRange UniformLoopOp::getSuccessorInputs(RegionSuccessor successor) {
  if (successor.isOperation())
    return getResults();
  return getBody().getArguments();
}

llvm::SmallVector<Region *> UniformLoopOp::getLoopRegions() {
  return {&getBody()};
}

Block::BlockArgListType UniformLoopOp::getRegionIterArgs() {
  return getBody().front().getArguments();
}

std::optional<MutableArrayRef<OpOperand>>
UniformLoopOp::getYieldedValuesMutable() {
  return cast<ContinueIfOp>(getBody().front().getTerminator())
      .getCarriesMutable();
}

std::optional<ResultRange> UniformLoopOp::getLoopResults() {
  return getResults();
}

// continue_if forwards $carries to either the body block (back-edge,
// cond=1) or the parent results (exit, cond=0). The SCC `$cond`
// operand is local to the s_cbranch_scc1 the printer emits and is
// *not* forwarded.
MutableOperandRange
ContinueIfOp::getMutableSuccessorOperands(RegionSuccessor successor) {
  return getCarriesMutable();
}

#define GET_OP_CLASSES
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.cpp.inc"
