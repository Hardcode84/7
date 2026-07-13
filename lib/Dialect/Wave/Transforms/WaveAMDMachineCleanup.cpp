//===- WaveAMDMachineCleanup.cpp - Machine cleanup pass ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDHardwareResources.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/MathExtras.h"

#include <array>
#include <limits>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINECLEANUP
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {
namespace traits = OpTrait::waveamdmachine;

static constexpr llvm::StringLiteral kMemoryCacheAttrName = "cache";

static void copyCacheAttr(Operation *dst, Operation *src) {
  if (Attribute cache = src->getAttr(kMemoryCacheAttrName))
    dst->setAttr(kMemoryCacheAttrName, cache);
}

struct ScaledLoopStep {
  SAddI32Op add;
  Value step;
  unsigned stepOperand = 1;
};

struct ScaledLoopCarryPlan {
  SmallVector<SLshlB32Op, 4> shifts;
  SmallVector<ScaledLoopStep, 2> steps;
  int64_t shift = 0;
};

static waveamdmachine::RegType getSCCType(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SCC, 1,
                                      -1);
}

static waveamdmachine::ImmOp createImm(OpBuilder &builder, Location loc,
                                       uint64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()), value);
}

static std::optional<int64_t> getImmValue(Value value) {
  auto imm = value.getDefiningOp<ImmOp>();
  if (!imm)
    return std::nullopt;
  return imm.getValue();
}

static Value createShiftedReg(OpBuilder &builder, Location loc, Value value,
                              int64_t shift) {
  auto shifted = SLshlB32Op::create(builder, loc, value.getType(),
                                    getSCCType(builder.getContext()), value,
                                    createImm(builder, loc, shift));
  return shifted.getResult();
}

static std::optional<uint64_t> shiftU32Imm(int64_t value, int64_t shift) {
  if (shift < 0 || shift >= 32)
    return std::nullopt;
  uint32_t bits = static_cast<uint32_t>(value);
  return static_cast<uint64_t>(bits << shift);
}

static bool operationIsInside(Operation *root, Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (cur == root)
      return true;
  return false;
}

static bool valueIsDefinedInside(Operation *root, Value value) {
  if (Operation *def = value.getDefiningOp())
    return operationIsInside(root, def);
  BlockArgument arg = dyn_cast<BlockArgument>(value);
  return arg && operationIsInside(root, arg.getOwner()->getParentOp());
}

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         WaveAMDMachineDialect::getDialectNamespace();
}

static bool hasOnlyLocalNonYieldUsers(Operation *root, Operation *op) {
  bool sawUse = false;
  for (OpResult result : op->getResults()) {
    for (OpOperand &use : result.getUses()) {
      Operation *owner = use.getOwner();
      if (isa<waveamdmachine::YieldOp>(owner))
        return false;
      if (!operationIsInside(root, owner))
        return false;
      sawUse = true;
    }
  }
  return sawUse;
}

static bool hasHoistableShape(Operation *op) {
  if (!isWaveAMDMachineOp(op))
    return false;
  if (op->getNumRegions() != 0)
    return false;
  return op->getNumResults() != 0;
}

static bool isHoistableKind(Operation *op) {
  if (!isa<ImmOp>(op) && !op->hasTrait<traits::VALUOp>() &&
      !op->hasTrait<traits::SALUOp>())
    return false;
  return true;
}

static bool isFlagResource(HardwareResourceKind kind) {
  return kind == HardwareResourceKind::SCC || kind == HardwareResourceKind::VCC;
}

static bool touchesOnlyUnusedFlags(Operation *op,
                                   const HardwareResourceEffects &effects) {
  if (!effects.reads.empty())
    return false;
  if (!llvm::all_of(effects.writes, [](HardwareResourceKind kind) {
        return isFlagResource(kind);
      }))
    return false;

  bool sawFlagResult = false;
  for (OpResult result : op->getResults()) {
    std::optional<HardwareResourceKind> kind =
        getHardwareResourceForValue(result);
    if (!kind)
      continue;
    if (!isFlagResource(*kind) || !result.use_empty())
      return false;
    sawFlagResult = true;
  }
  return sawFlagResult;
}

static bool hasHoistableSemantics(Operation *op) {
  if (!isMemoryEffectFree(op) || !isSpeculatable(op))
    return false;
  HardwareResourceEffects effects = getHardwareResourceEffects(op);
  if (effects.reads.empty() && effects.writes.empty())
    return true;
  return touchesOnlyUnusedFlags(op, effects);
}

static bool operandsAvailableBefore(Operation *root, Operation *op) {
  for (Value operand : op->getOperands())
    if (valueIsDefinedInside(root, operand))
      return false;
  return true;
}

static bool canHoistThroughExecIf(Operation *root, Operation *op) {
  if (!hasHoistableShape(op))
    return false;
  if (!isHoistableKind(op))
    return false;
  if (!hasHoistableSemantics(op))
    return false;
  if (!operandsAvailableBefore(root, op))
    return false;
  return hasOnlyLocalNonYieldUsers(root, op);
}

static bool hoistFromRegion(Operation *root, Region &region) {
  if (region.empty())
    return false;

  Block &block = region.front();
  Operation *terminator = block.getTerminator();
  SmallVector<Operation *> ops;
  for (Operation &op : block) {
    if (&op == terminator)
      break;
    ops.push_back(&op);
  }

  bool changed = false;
  for (Operation *op : ops) {
    if (!canHoistThroughExecIf(root, op))
      continue;
    op->moveBefore(root);
    changed = true;
  }
  return changed;
}

static bool hoistExecIf(ExecIfOp execIf) {
  bool changed = hoistFromRegion(execIf.getOperation(), execIf.getThenRegion());
  changed |= hoistFromRegion(execIf.getOperation(), execIf.getElseRegion());
  return changed;
}

static bool hoistFunction(func::FuncOp func) {
  SmallVector<ExecIfOp> execIfs;
  func.walk([&](ExecIfOp execIf) { execIfs.push_back(execIf); });

  bool changed = false;
  for (ExecIfOp execIf : llvm::reverse(execIfs))
    changed |= hoistExecIf(execIf);
  return changed;
}

static bool isLoopCarryTerminatorUse(OpOperand &use, ContinueIfOp term,
                                     unsigned index) {
  return use.getOwner() == term && use.getOperandNumber() == index + 1;
}

static bool matchShiftUse(Operation *owner, Value value,
                          std::optional<int64_t> &shift,
                          SmallVectorImpl<SLshlB32Op> &shifts) {
  auto shl = dyn_cast<SLshlB32Op>(owner);
  if (!shl || shl.getLhs() != value || !shl.getScc().use_empty())
    return false;
  std::optional<int64_t> amount = getImmValue(shl.getRhs());
  if (!amount || *amount <= 0 || *amount >= 32)
    return false;
  if (shift && *shift != *amount)
    return false;
  shift = *amount;
  shifts.push_back(shl);
  return true;
}

static SAddI32Op matchStepUse(Operation *owner, Value value,
                              unsigned &stepOperand) {
  auto add = dyn_cast<SAddI32Op>(owner);
  if (!add || !add.getScc().use_empty())
    return {};
  bool lhs = add.getLhs() == value;
  bool rhs = add.getRhs() == value;
  if (lhs == rhs)
    return {};
  stepOperand = lhs ? 1 : 0;
  return add;
}

static LogicalResult
collectLoopCarryUse(OpOperand &use, Value current, ContinueIfOp term,
                    unsigned index, std::optional<int64_t> &shift,
                    SmallVectorImpl<SLshlB32Op> &shifts, SAddI32Op &stepAdd,
                    unsigned &stepOperand, bool &sawCarry) {
  Operation *user = use.getOwner();
  if (matchShiftUse(user, current, shift, shifts))
    return success();

  unsigned matchedStepOperand = 1;
  if (SAddI32Op add = matchStepUse(user, current, matchedStepOperand)) {
    if (stepAdd)
      return failure();
    stepAdd = add;
    stepOperand = matchedStepOperand;
    return success();
  }

  if (isLoopCarryTerminatorUse(use, term, index)) {
    sawCarry = true;
    return success();
  }
  return failure();
}

static LogicalResult
collectLoopCarryStep(Value current, ContinueIfOp term, unsigned index,
                     std::optional<int64_t> &shift,
                     SmallVectorImpl<SLshlB32Op> &shifts, SAddI32Op &stepAdd,
                     unsigned &stepOperand, bool &sawCarry) {
  for (OpOperand &use : llvm::make_early_inc_range(current.getUses()))
    if (failed(collectLoopCarryUse(use, current, term, index, shift, shifts,
                                   stepAdd, stepOperand, sawCarry)))
      return failure();
  return success();
}

static LogicalResult appendLoopCarryStep(UniformLoopOp loop, SAddI32Op stepAdd,
                                         unsigned stepOperand,
                                         ScaledLoopCarryPlan &plan,
                                         Value &current) {
  if (!stepAdd)
    return failure();
  Value step = stepAdd->getOperand(stepOperand);
  if (!getImmValue(step) && valueIsDefinedInside(loop, step))
    return failure();
  plan.steps.push_back({stepAdd, step, stepOperand});
  current = stepAdd.getResult();
  return success();
}

static FailureOr<ScaledLoopCarryPlan>
buildScaledLoopCarryPlan(UniformLoopOp loop, unsigned index) {
  if (!loop.getResult(index).use_empty())
    return failure();

  Block &body = loop.getBody().front();
  auto term = cast<ContinueIfOp>(body.getTerminator());
  Value current = body.getArgument(index);
  std::optional<int64_t> shift;
  ScaledLoopCarryPlan plan;

  while (true) {
    SAddI32Op stepAdd;
    unsigned stepOperand = 1;
    bool sawCarry = false;

    if (failed(collectLoopCarryStep(current, term, index, shift, plan.shifts,
                                    stepAdd, stepOperand, sawCarry)))
      return failure();

    if (sawCarry) {
      if (stepAdd)
        return failure();
      break;
    }
    if (failed(appendLoopCarryStep(loop, stepAdd, stepOperand, plan, current)))
      return failure();
  }

  if (!shift || plan.shifts.empty())
    return failure();
  plan.shift = *shift;
  return plan;
}

static bool valueAvailableBefore(Value value, Operation *op) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return true;
  if (def->getBlock() != op->getBlock())
    return true;
  return def->isBeforeInBlock(op);
}

static bool valueDefinedBeforeInBlock(Value value, Operation *op) {
  Operation *def = value.getDefiningOp();
  return def && def->getBlock() == op->getBlock() && def->isBeforeInBlock(op);
}

static bool isUniformWorkitemShift(unsigned shift, unsigned wavefrontSize) {
  return shift >= llvm::Log2_32(wavefrontSize);
}

static bool hasXLinearWorkgroupShape(func::FuncOp func) {
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr attr = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!attr)
      continue;
    if (attr.empty() || attr.size() > 3)
      return false;
    for (auto indexed : llvm::enumerate(attr.asArrayRef())) {
      if (indexed.value() <= 0)
        return false;
      if (indexed.index() > 0 && indexed.value() != 1)
        return false;
    }
    return true;
  }
  return false;
}

struct WorkitemShift {
  Value source;
  unsigned shift = 0;
};

static std::optional<WorkitemShift> matchWorkitemShift(Value value,
                                                       unsigned wavefrontSize) {
  auto shiftOp = value.getDefiningOp<VLshrrevB32Op>();
  if (!shiftOp)
    return std::nullopt;
  std::optional<int64_t> amount = getImmValue(shiftOp.getRhs());
  if (!amount || *amount < 0 || *amount >= 32)
    return std::nullopt;
  if (!isUniformWorkitemShift(*amount, wavefrontSize))
    return std::nullopt;
  Value source = shiftOp.getLhs();
  if (!source.getDefiningOp<VWorkitemIdXOp>())
    return std::nullopt;
  return WorkitemShift{source, static_cast<unsigned>(*amount)};
}

static std::optional<WorkitemShift>
matchScalarWorkitemShift(SLshrB32Op shiftOp, unsigned wavefrontSize) {
  std::optional<int64_t> amount = getImmValue(shiftOp.getRhs());
  if (!amount || *amount < 0 || *amount >= 32)
    return std::nullopt;
  if (!isUniformWorkitemShift(*amount, wavefrontSize))
    return std::nullopt;
  auto firstLane = shiftOp.getLhs().getDefiningOp<VReadfirstlaneB32Op>();
  if (!firstLane)
    return std::nullopt;
  Value source = firstLane.getSource();
  if (!source.getDefiningOp<VWorkitemIdXOp>())
    return std::nullopt;
  return WorkitemShift{source, static_cast<unsigned>(*amount)};
}

using ScalarWorkitemShiftMap =
    DenseMap<Value, SmallVector<std::pair<unsigned, Value>, 2>>;

static Value findScalarWorkitemShift(const ScalarWorkitemShiftMap &shifts,
                                     WorkitemShift match, Operation *op) {
  auto it = shifts.find(match.source);
  if (it == shifts.end())
    return {};
  for (auto [shift, value] : it->second)
    if (shift == match.shift && valueDefinedBeforeInBlock(value, op))
      return value;
  return {};
}

static bool isVOP3IntOp(Operation *op) {
  return isa<VAdd3U32Op, VMadI32I24Op, VMadU32U24Op, VLshlAddU32Op,
             VAddLshlU32Op, VAndOrB32Op, VOr3B32Op, VXadU32Op, VPermB32Op,
             VBitOp3B32Op>(op);
}

static bool canReplaceVOP3IntOperand(Operation *op, unsigned operand,
                                     Value replacement,
                                     const llvm::AMDGPU::IsaVersion &isa) {
  SmallVector<Value, 3> operands(op->operand_begin(), op->operand_end());
  if (operands.size() != 3)
    return false;
  operands[operand] = replacement;
  return canUseConstantBus(operands, isa, [](Value, Value) { return false; });
}

static bool reuseUniformWorkitemShiftOperands(
    Operation *op, const ScalarWorkitemShiftMap &scalarShifts,
    unsigned wavefrontSize, const llvm::AMDGPU::IsaVersion &isa) {
  if (!isVOP3IntOp(op))
    return false;

  bool changed = false;
  for (unsigned index : llvm::seq<unsigned>(0, op->getNumOperands())) {
    std::optional<WorkitemShift> match =
        matchWorkitemShift(op->getOperand(index), wavefrontSize);
    if (!match)
      continue;
    Value replacement = findScalarWorkitemShift(scalarShifts, *match, op);
    if (!replacement)
      continue;
    if (!canReplaceVOP3IntOperand(op, index, replacement, isa))
      continue;
    op->setOperand(index, replacement);
    changed = true;
  }
  return changed;
}

static FailureOr<bool> reuseUniformWorkitemShiftOperands(func::FuncOp func) {
  FailureOr<llvm::AMDGPU::IsaVersion> targetIsa =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          func, "uniform workitem shift cleanup");
  FailureOr<unsigned> wavefrontSize = waveamdmachine::getAMDGPUWavefrontSize(
      func, "uniform workitem shift cleanup");
  if (failed(targetIsa) || failed(wavefrontSize))
    return failure();
  if (!hasXLinearWorkgroupShape(func))
    return false;

  ScalarWorkitemShiftMap scalarShifts;
  func.walk([&](SLshrB32Op op) {
    std::optional<WorkitemShift> match =
        matchScalarWorkitemShift(op, *wavefrontSize);
    if (!match)
      return;
    scalarShifts[match->source].push_back({match->shift, op.getResult()});
  });
  if (scalarShifts.empty())
    return false;

  SmallVector<Operation *> users;
  func.walk([&](Operation *op) {
    if (isVOP3IntOp(op))
      users.push_back(op);
  });

  bool changed = false;
  for (Operation *op : users)
    changed |= reuseUniformWorkitemShiftOperands(op, scalarShifts,
                                                 *wavefrontSize, *targetIsa);
  return changed;
}

struct BytePackLane {
  Value source;
  unsigned shift = 0;
};

struct BytePackMatch {
  std::array<BytePackLane, 4> lanes;
  SmallVector<Operation *, 8> ops;
  SmallPtrSet<Operation *, 8> opSet;
};

enum class ByteTraceSourceKind { RawLoad, D16Low, D16High };

struct ByteTraceSource {
  ByteTraceSourceKind kind;
  BufferLoadU8Op load;
  Value value;
};

struct ByteTrace {
  SmallVector<ByteTraceSource, 2> sources;
  bool hasConstant = false;
  bool hasNonZeroConstant = false;
  bool hasTransparentUse = false;
};

struct ByteTraceContext {
  SmallPtrSet<Operation *, 8> packOps;
  SmallPtrSet<OpOperand *, 8> transparentUses;
  SmallPtrSet<Value, 8> visiting;
};

struct D16RewriteState {
  DenseMap<Value, Value> replacements;
  SmallVector<Operation *, 4> oldLoads;
  bool preservesUnusedBits = false;
};

static void addPackOp(BytePackMatch &match, Operation *op) {
  if (match.opSet.insert(op).second)
    match.ops.push_back(op);
}

static bool getU8Imm(Value value, uint64_t &imm) {
  std::optional<int64_t> raw = getImmValue(value);
  if (!raw || *raw < 0 || *raw > 0xff)
    return false;
  imm = static_cast<uint64_t>(*raw);
  return true;
}

static bool getU32Imm(Value value, uint64_t &imm) {
  std::optional<int64_t> raw = getImmValue(value);
  if (!raw || *raw < 0 || *raw > std::numeric_limits<uint32_t>::max())
    return false;
  imm = static_cast<uint64_t>(*raw);
  return true;
}

static bool isZeroImm(Value value) {
  uint64_t imm = 0;
  return getU32Imm(value, imm) && imm == 0;
}

static bool hasOnlyAllowedUses(Value value, const ByteTraceContext &ctx) {
  for (OpOperand &use : value.getUses()) {
    if (ctx.transparentUses.contains(&use))
      continue;
    if (ctx.packOps.contains(use.getOwner()))
      continue;
    auto d16Hi = dyn_cast<BufferLoadU8D16HiOp>(use.getOwner());
    if (d16Hi && &d16Hi.getPreservedMutable() == &use)
      continue;
    return false;
  }
  return true;
}

static ContinueIfOp getLoopTerminator(UniformLoopOp loop) {
  return cast<ContinueIfOp>(loop.getBody().front().getTerminator());
}

static LogicalResult collectByteTrace(Value value, ByteTraceContext &ctx,
                                      ByteTrace &trace);

static LogicalResult appendTraceSource(Value value, ByteTraceSourceKind kind,
                                       BufferLoadU8Op load,
                                       ByteTraceContext &ctx,
                                       ByteTrace &trace) {
  if (!hasOnlyAllowedUses(value, ctx))
    return failure();
  trace.sources.push_back({kind, load, value});
  return success();
}

static LogicalResult collectLoopResultTrace(UniformLoopOp loop, unsigned index,
                                            ByteTraceContext &ctx,
                                            ByteTrace &trace) {
  if (!hasOnlyAllowedUses(loop.getResult(index), ctx))
    return failure();

  ContinueIfOp term = getLoopTerminator(loop);
  OpOperand &carryUse = term->getOpOperand(index + 1);
  ctx.transparentUses.insert(&carryUse);
  trace.hasTransparentUse = true;
  if (failed(collectByteTrace(term.getCarries()[index], ctx, trace)))
    return failure();

  if (!loop.getEntryCond())
    return success();
  OpOperand &initUse = loop.getInitsMutable()[index];
  ctx.transparentUses.insert(&initUse);
  trace.hasTransparentUse = true;
  return collectByteTrace(loop.getInits()[index], ctx, trace);
}

static LogicalResult collectLoopArgTrace(BlockArgument arg,
                                         ByteTraceContext &ctx,
                                         ByteTrace &trace) {
  auto loop = dyn_cast<UniformLoopOp>(arg.getOwner()->getParentOp());
  if (!loop || arg.getOwner() != &loop.getBody().front())
    return failure();

  unsigned index = arg.getArgNumber();
  ContinueIfOp term = getLoopTerminator(loop);
  OpOperand &carryUse = term->getOpOperand(index + 1);
  OpOperand &initUse = loop.getInitsMutable()[index];
  ctx.transparentUses.insert(&carryUse);
  ctx.transparentUses.insert(&initUse);
  trace.hasTransparentUse = true;
  if (!hasOnlyAllowedUses(arg, ctx))
    return failure();

  if (failed(collectByteTrace(loop.getInits()[index], ctx, trace)))
    return failure();
  return collectByteTrace(term.getCarries()[index], ctx, trace);
}

static LogicalResult collectNonConstantByteTrace(Value value,
                                                 ByteTraceContext &ctx,
                                                 ByteTrace &trace) {
  if (BufferLoadU8Op load = value.getDefiningOp<BufferLoadU8Op>()) {
    return appendTraceSource(value, ByteTraceSourceKind::RawLoad, load, ctx,
                             trace);
  }
  if (value.getDefiningOp<BufferLoadU8D16Op>())
    return appendTraceSource(value, ByteTraceSourceKind::D16Low, {}, ctx,
                             trace);
  if (value.getDefiningOp<BufferLoadU8D16HiOp>())
    return appendTraceSource(value, ByteTraceSourceKind::D16High, {}, ctx,
                             trace);
  if (OpResult opResult = dyn_cast<OpResult>(value)) {
    if (auto loop = dyn_cast<UniformLoopOp>(opResult.getOwner()))
      return collectLoopResultTrace(loop, opResult.getResultNumber(), ctx,
                                    trace);
  }
  if (BlockArgument arg = dyn_cast<BlockArgument>(value))
    return collectLoopArgTrace(arg, ctx, trace);
  return failure();
}

static LogicalResult collectByteTrace(Value value, ByteTraceContext &ctx,
                                      ByteTrace &trace) {
  uint64_t imm = 0;
  if (getU8Imm(value, imm)) {
    trace.hasConstant = true;
    trace.hasNonZeroConstant |= imm != 0;
    return success();
  }

  if (!ctx.visiting.insert(value).second)
    return failure();

  LogicalResult result = collectNonConstantByteTrace(value, ctx, trace);

  ctx.visiting.erase(value);
  return result;
}

static bool canFoldPackOp(Operation *op, Operation *root, Value result) {
  if (op != root && !result.hasOneUse())
    return false;
  return true;
}

static std::optional<unsigned> getBytePackShift(VLshlrevB32Op shl) {
  std::optional<int64_t> amount = getImmValue(shl.getRhs());
  if (!amount || (*amount != 8 && *amount != 16 && *amount != 24))
    return std::nullopt;
  return static_cast<unsigned>(*amount);
}

static bool collectPackLanes(Value value, Operation *root, unsigned baseShift,
                             BytePackMatch &match,
                             SmallVectorImpl<BytePackLane> &lanes);

static bool collectPackLanesFromOr(Operation *def, Operation *root,
                                   unsigned baseShift, BytePackMatch &match,
                                   SmallVectorImpl<BytePackLane> &lanes) {
  if (auto orOp = dyn_cast<VOrB32Op>(def)) {
    if (!canFoldPackOp(def, root, orOp.getResult()))
      return false;
    addPackOp(match, def);
    return collectPackLanes(orOp.getLhs(), root, baseShift, match, lanes) &&
           collectPackLanes(orOp.getRhs(), root, baseShift, match, lanes);
  }

  if (auto or3Op = dyn_cast<VOr3B32Op>(def)) {
    if (!canFoldPackOp(def, root, or3Op.getResult()))
      return false;
    addPackOp(match, def);
    return collectPackLanes(or3Op.getA(), root, baseShift, match, lanes) &&
           collectPackLanes(or3Op.getB(), root, baseShift, match, lanes) &&
           collectPackLanes(or3Op.getC(), root, baseShift, match, lanes);
  }
  return false;
}

static bool collectPackLanesFromShift(VLshlrevB32Op shl, Operation *root,
                                      unsigned baseShift, BytePackMatch &match,
                                      SmallVectorImpl<BytePackLane> &lanes) {
  if (!canFoldPackOp(shl, root, shl.getResult()))
    return false;
  std::optional<unsigned> amount = getBytePackShift(shl);
  if (!amount)
    return false;
  unsigned shift = baseShift + *amount;
  if (shift > 24)
    return false;
  addPackOp(match, shl);
  return collectPackLanes(shl.getLhs(), root, shift, match, lanes);
}

static bool collectPackLanes(Value value, Operation *root, unsigned baseShift,
                             BytePackMatch &match,
                             SmallVectorImpl<BytePackLane> &lanes) {
  Operation *def = value.getDefiningOp();
  if (!def) {
    lanes.push_back({value, baseShift});
    return true;
  }

  if (isa<VOrB32Op, VOr3B32Op>(def))
    return collectPackLanesFromOr(def, root, baseShift, match, lanes);

  if (auto shl = dyn_cast<VLshlrevB32Op>(def)) {
    return collectPackLanesFromShift(shl, root, baseShift, match, lanes);
  }

  lanes.push_back({value, baseShift});
  return true;
}

static bool matchMaskedByte(Value value, Value &source, BytePackMatch &match) {
  auto andOp = value.getDefiningOp<VAndB32Op>();
  if (!andOp || !andOp.getResult().hasOneUse())
    return false;

  uint64_t imm = 0;
  if (getU8Imm(andOp.getRhs(), imm) && imm == 0xff) {
    source = andOp.getLhs();
    addPackOp(match, andOp);
    return true;
  }
  if (getU8Imm(andOp.getLhs(), imm) && imm == 0xff) {
    source = andOp.getRhs();
    addPackOp(match, andOp);
    return true;
  }
  return false;
}

static bool matchBytePackTerm(BytePackLane term, BytePackLane &lane,
                              BytePackMatch &match) {
  Value source;
  if (matchMaskedByte(term.source, source, match)) {
    lane = {source, term.shift};
    return true;
  }

  ByteTraceContext ctx;
  ctx.packOps = match.opSet;
  ByteTrace trace;
  if (failed(collectByteTrace(term.source, ctx, trace)))
    return false;

  std::optional<unsigned> sourceShift;
  for (const ByteTraceSource &traceSource : trace.sources) {
    if (traceSource.kind == ByteTraceSourceKind::RawLoad)
      return false;
    unsigned shift = traceSource.kind == ByteTraceSourceKind::D16High ? 16 : 0;
    if (sourceShift && *sourceShift != shift)
      return false;
    sourceShift = shift;
  }
  if (!sourceShift || term.shift + *sourceShift > 24)
    return false;
  lane = {term.source, term.shift + *sourceShift};
  return true;
}

static std::optional<unsigned> getBytePackLaneIndex(BytePackLane lane,
                                                    ArrayRef<bool> seen) {
  if (lane.shift % 8 != 0 || lane.shift > 24)
    return std::nullopt;
  unsigned index = lane.shift / 8;
  if (seen[index])
    return std::nullopt;
  return index;
}

static bool collectBytePackLanes(ArrayRef<BytePackLane> terms,
                                 BytePackMatch &match) {
  std::array<bool, 4> seen = {};
  for (BytePackLane term : terms) {
    BytePackLane lane;
    if (!matchBytePackTerm(term, lane, match))
      return false;
    std::optional<unsigned> index = getBytePackLaneIndex(lane, seen);
    if (!index)
      return false;
    seen[*index] = true;
    match.lanes[*index] = lane;
  }
  return true;
}

static std::optional<BytePackMatch> matchBytePack(Operation *root) {
  if ((!isa<VOrB32Op>(root) && !isa<VOr3B32Op>(root)) ||
      root->getNumResults() != 1)
    return std::nullopt;

  BytePackMatch match;
  SmallVector<BytePackLane, 4> terms;
  if (!collectPackLanes(root->getResult(0), root, 0, match, terms) ||
      terms.size() != 4)
    return std::nullopt;

  if (!collectBytePackLanes(terms, match))
    return std::nullopt;
  return match;
}

static bool tracesCanPair(const ByteTrace &low, const ByteTrace &high) {
  if (high.sources.empty())
    return true;
  if (low.sources.empty())
    return true;
  return low.sources.size() == high.sources.size();
}

static Value createZeroVGPR(OpBuilder &builder, Operation *insertPoint,
                            Type type) {
  builder.setInsertionPoint(insertPoint);
  Value zero = createImm(builder, insertPoint->getLoc(), 0);
  return VMovB32TupleOp::create(builder, insertPoint->getLoc(), type, zero)
      .getResult();
}

static Value getReplacement(D16RewriteState &state, Value value) {
  auto it = state.replacements.find(value);
  if (it == state.replacements.end())
    return value;
  return it->second;
}

static Value createD16Low(OpBuilder &builder, BufferLoadU8Op load,
                          D16RewriteState &state) {
  auto [it, inserted] = state.replacements.try_emplace(load.getResult());
  if (!inserted)
    return it->second;

  builder.setInsertionPoint(load);
  Value token = load.getToken();
  Type tokenType = token ? token.getType() : Type{};
  auto d16 = BufferLoadU8D16Op::create(
      builder, load.getLoc(), load.getResult().getType(), tokenType,
      load.getOffset(), load.getDescriptor(), load.getSoffset(),
      load.getDependency(), load.getInstOffset());
  copyCacheAttr(d16.getOperation(), load.getOperation());
  it->second = d16.getResult();
  state.oldLoads.push_back(load.getOperation());
  load.getResult().replaceAllUsesWith(d16.getResult());
  if (token)
    token.replaceAllUsesWith(d16.getToken());
  return d16.getResult();
}

static Value createD16Hi(OpBuilder &builder, BufferLoadU8Op load,
                         Value preserved, D16RewriteState &state) {
  auto [it, inserted] = state.replacements.try_emplace(load.getResult());
  if (!inserted)
    return it->second;

  builder.setInsertionPoint(load);
  Value token = load.getToken();
  Type tokenType = token ? token.getType() : Type{};
  auto d16 = BufferLoadU8D16HiOp::create(
      builder, load.getLoc(), load.getResult().getType(), tokenType,
      load.getOffset(), preserved, load.getDescriptor(), load.getSoffset(),
      load.getDependency(), load.getInstOffset());
  copyCacheAttr(d16.getOperation(), load.getOperation());
  it->second = d16.getResult();
  state.oldLoads.push_back(load.getOperation());
  load.getResult().replaceAllUsesWith(d16.getResult());
  if (token)
    token.replaceAllUsesWith(d16.getToken());
  return d16.getResult();
}

static FailureOr<Value> getOrCreateD16Low(OpBuilder &builder,
                                          const ByteTraceSource &source,
                                          D16RewriteState &state) {
  switch (source.kind) {
  case ByteTraceSourceKind::RawLoad:
    return createD16Low(builder, source.load, state);
  case ByteTraceSourceKind::D16Low:
    return source.value;
  case ByteTraceSourceKind::D16High:
    return failure();
  }
  llvm_unreachable("unknown byte trace source kind");
}

static bool d16HighIncludesLow(Value high, Value low) {
  auto d16Hi = high.getDefiningOp<BufferLoadU8D16HiOp>();
  return d16Hi && d16Hi.getPreserved() == low;
}

static FailureOr<Value>
getOrCreateD16High(OpBuilder &builder, const ByteTraceSource &source,
                   Value preserved, D16RewriteState &state, bool &includesLow) {
  switch (source.kind) {
  case ByteTraceSourceKind::RawLoad:
    return createD16Hi(builder, source.load, preserved, state);
  case ByteTraceSourceKind::D16Low:
    return failure();
  case ByteTraceSourceKind::D16High:
    includesLow &= d16HighIncludesLow(source.value, preserved);
    return source.value;
  }
  llvm_unreachable("unknown byte trace source kind");
}

static LogicalResult collectLowD16s(OpBuilder &builder, const ByteTrace &low,
                                    D16RewriteState &state,
                                    SmallVectorImpl<Value> &lowD16s) {
  lowD16s.reserve(low.sources.size());
  for (const ByteTraceSource &source : low.sources) {
    FailureOr<Value> lowD16 = getOrCreateD16Low(builder, source, state);
    if (failed(lowD16))
      return failure();
    lowD16s.push_back(*lowD16);
  }
  return success();
}

static bool updateExistingD16High(const ByteTraceSource &source,
                                  ArrayRef<Value> lowD16s, unsigned index) {
  return index < lowD16s.size() &&
         d16HighIncludesLow(source.value, lowD16s[index]);
}

static FailureOr<Value>
getD16HighPreserved(OpBuilder &builder, const ByteTraceSource &source,
                    ArrayRef<Value> lowD16s, unsigned index,
                    D16RewriteState &state, bool &highIncludesLow) {
  Operation *insertPoint = source.value.getDefiningOp();
  if (!insertPoint)
    return failure();
  if (state.preservesUnusedBits && index < lowD16s.size() &&
      valueAvailableBefore(lowD16s[index], insertPoint))
    return lowD16s[index];
  highIncludesLow = false;
  return createZeroVGPR(builder, insertPoint, source.value.getType());
}

static LogicalResult
rewriteHighTraceSource(OpBuilder &builder, const ByteTraceSource &source,
                       ArrayRef<Value> lowD16s, unsigned index,
                       D16RewriteState &state, bool &highIncludesLow) {
  if (source.kind == ByteTraceSourceKind::D16High) {
    highIncludesLow &= updateExistingD16High(source, lowD16s, index);
    return success();
  }
  if (source.kind != ByteTraceSourceKind::RawLoad)
    return failure();

  FailureOr<Value> preserved = getD16HighPreserved(
      builder, source, lowD16s, index, state, highIncludesLow);
  if (failed(preserved))
    return failure();
  FailureOr<Value> highD16 =
      getOrCreateD16High(builder, source, *preserved, state, highIncludesLow);
  if (failed(highD16))
    return failure();
  return success();
}

static FailureOr<bool> rewriteTracePairLoads(OpBuilder &builder,
                                             const ByteTrace &low,
                                             const ByteTrace &high,
                                             D16RewriteState &state) {
  if (!tracesCanPair(low, high))
    return failure();

  SmallVector<Value, 2> lowD16s;
  if (failed(collectLowD16s(builder, low, state, lowD16s)))
    return failure();

  bool highIncludesLow = !high.sources.empty();
  for (auto [index, source] : llvm::enumerate(high.sources))
    if (failed(rewriteHighTraceSource(builder, source, lowD16s, index, state,
                                      highIncludesLow)))
      return failure();

  if (highIncludesLow && high.hasConstant && low.hasNonZeroConstant)
    highIncludesLow = false;
  return highIncludesLow;
}

static Value createShiftLeft(OpBuilder &builder, Location loc, Value value,
                             unsigned shift, Type resultType) {
  if (shift == 0)
    return value;
  uint64_t imm = 0;
  if (getU8Imm(value, imm))
    return createImm(builder, loc, imm << shift);
  return VLshlrevB32Op::create(builder, loc, resultType, value,
                               createImm(builder, loc, shift))
      .getResult();
}

static Value createOr(OpBuilder &builder, Location loc, Value lhs, Value rhs,
                      Type resultType) {
  if (isZeroImm(lhs))
    return rhs;
  if (isZeroImm(rhs))
    return lhs;

  uint64_t lhsImm = 0;
  uint64_t rhsImm = 0;
  if (getU32Imm(lhs, lhsImm) && getU32Imm(rhs, rhsImm))
    return createImm(builder, loc, lhsImm | rhsImm);
  return VOrB32Op::create(builder, loc, resultType, lhs, rhs).getResult();
}

static Value createOr3(OpBuilder &builder, Location loc, Value a, Value b,
                       Value c, Type resultType) {
  if (isZeroImm(a))
    return createOr(builder, loc, b, c, resultType);
  if (isZeroImm(b))
    return createOr(builder, loc, a, c, resultType);
  if (isZeroImm(c))
    return createOr(builder, loc, a, b, resultType);

  uint64_t aImm = 0;
  uint64_t bImm = 0;
  uint64_t cImm = 0;
  if (getU32Imm(a, aImm) && getU32Imm(b, bImm) && getU32Imm(c, cImm))
    return createImm(builder, loc, aImm | bImm | cImm);
  return VOr3B32Op::create(builder, loc, resultType, a, b, c).getResult();
}

static Value ensureVGPR(OpBuilder &builder, Location loc, Value value,
                        Type resultType) {
  if (isa<ImmType>(value.getType()))
    return VMovB32TupleOp::create(builder, loc, resultType, value).getResult();
  return value;
}

static Value createPairValue(OpBuilder &builder, Operation *root,
                             BytePackLane lowLane, const ByteTrace &lowTrace,
                             BytePackLane highLane, const ByteTrace &highTrace,
                             bool highIncludesLow, D16RewriteState &state) {
  Type resultType = root->getResult(0).getType();
  Location loc = root->getLoc();
  Value low = getReplacement(state, lowLane.source);
  Value high = getReplacement(state, highLane.source);
  if (highTrace.sources.empty())
    high = createShiftLeft(builder, loc, high, 16, resultType);
  else if (highIncludesLow)
    return high;
  return createOr(builder, loc, low, high, resultType);
}

static bool eraseDeadPackOps(BytePackMatch &match) {
  bool changed = false;
  bool erased = true;
  while (erased) {
    erased = false;
    for (Operation *&op : match.ops) {
      if (!op)
        continue;
      if (!llvm::all_of(op->getResults(),
                        [](Value result) { return result.use_empty(); }))
        continue;
      op->erase();
      op = nullptr;
      erased = true;
      changed = true;
    }
  }
  return changed;
}

static bool hasByteMaskPackOp(const BytePackMatch &match) {
  return llvm::any_of(match.ops,
                      [](Operation *op) { return op && isa<VAndB32Op>(op); });
}

static void eraseDeadOldLoads(D16RewriteState &state) {
  for (Operation *op : state.oldLoads) {
    if (llvm::all_of(op->getResults(),
                     [](Value result) { return result.use_empty(); }))
      op->erase();
  }
}

static LogicalResult collectBytePackTraces(BytePackMatch &match,
                                           std::array<ByteTrace, 4> &traces) {
  ByteTraceContext ctx;
  ctx.packOps = match.opSet;
  for (auto [index, lane] : llvm::enumerate(match.lanes)) {
    if (failed(collectByteTrace(lane.source, ctx, traces[index])))
      return failure();
  }
  return success();
}

static bool canRewriteBytePackTraces(const std::array<ByteTrace, 4> &traces) {
  if (traces[2].hasNonZeroConstant && !traces[2].sources.empty())
    return false;
  if (traces[3].hasNonZeroConstant && !traces[3].sources.empty())
    return false;
  return tracesCanPair(traces[0], traces[2]) &&
         tracesCanPair(traces[1], traces[3]);
}

static FailureOr<std::array<bool, 2>>
rewriteBytePackLoads(OpBuilder &builder, const std::array<ByteTrace, 4> &traces,
                     D16RewriteState &state) {
  FailureOr<bool> evenHighIncludesLow =
      rewriteTracePairLoads(builder, traces[0], traces[2], state);
  if (failed(evenHighIncludesLow))
    return failure();
  FailureOr<bool> oddHighIncludesLow =
      rewriteTracePairLoads(builder, traces[1], traces[3], state);
  if (failed(oddHighIncludesLow))
    return failure();
  return std::array<bool, 2>{*evenHighIncludesLow, *oddHighIncludesLow};
}

static void replaceBytePackRoot(OpBuilder &builder, Operation *root,
                                BytePackMatch &match,
                                const std::array<ByteTrace, 4> &traces,
                                std::array<bool, 2> highIncludesLow,
                                D16RewriteState &state) {
  builder.setInsertionPoint(root);
  Type resultType = root->getResult(0).getType();
  Location loc = root->getLoc();
  Value odd =
      createPairValue(builder, root, match.lanes[1], traces[1], match.lanes[3],
                      traces[3], highIncludesLow[1], state);
  odd = createShiftLeft(builder, loc, odd, 8, resultType);
  Value word;
  if (!highIncludesLow[0] && !traces[2].sources.empty()) {
    Value low = getReplacement(state, match.lanes[0].source);
    Value high = getReplacement(state, match.lanes[2].source);
    word = createOr3(builder, loc, low, high, odd, resultType);
  } else {
    Value even =
        createPairValue(builder, root, match.lanes[0], traces[0],
                        match.lanes[2], traces[2], highIncludesLow[0], state);
    word = createOr(builder, loc, even, odd, resultType);
  }
  word = ensureVGPR(builder, loc, word, resultType);
  root->getResult(0).replaceAllUsesWith(word);
  eraseDeadPackOps(match);
  eraseDeadOldLoads(state);
}

static FailureOr<bool> rewriteBytePack(Operation *root,
                                       bool preservesUnusedBits) {
  std::optional<BytePackMatch> match = matchBytePack(root);
  if (!match)
    return false;

  std::array<ByteTrace, 4> traces;
  if (failed(collectBytePackTraces(*match, traces)) ||
      !canRewriteBytePackTraces(traces))
    return false;

  OpBuilder builder(root->getContext());
  D16RewriteState state;
  state.preservesUnusedBits = preservesUnusedBits;
  FailureOr<std::array<bool, 2>> highIncludesLow =
      rewriteBytePackLoads(builder, traces, state);
  if (failed(highIncludesLow))
    return false;
  if (isa<VOr3B32Op>(root) && state.replacements.empty() &&
      !(*highIncludesLow)[0] && !hasByteMaskPackOp(*match))
    return false;

  replaceBytePackRoot(builder, root, *match, traces, *highIncludesLow, state);
  return true;
}

static FailureOr<bool> formD16ByteLoadPacks(func::FuncOp func) {
  FailureOr<llvm::AMDGPU::IsaVersion> targetIsa =
      waveamdmachine::getAMDGPUTargetIsaVersion(func, "D16 byte pack cleanup");
  if (failed(targetIsa))
    return failure();
  if (!BufferLoadU8D16Op::isSupportedOnIsa(*targetIsa) ||
      !BufferLoadU8D16HiOp::isSupportedOnIsa(*targetIsa))
    return false;

  FailureOr<bool> preservesUnusedBits =
      waveamdmachine::getAMDGPUD16PreservesUnusedBits(func,
                                                      "D16 byte pack cleanup");
  if (failed(preservesUnusedBits))
    return failure();

  SmallVector<Operation *> roots;
  func.walk([&](Operation *op) {
    if (isa<VOrB32Op>(op) || isa<VOr3B32Op>(op))
      roots.push_back(op);
  });

  bool changed = false;
  for (Operation *root : roots) {
    FailureOr<bool> rewritten = rewriteBytePack(root, *preservesUnusedBits);
    if (failed(rewritten))
      return failure();
    changed |= *rewritten;
  }
  return changed;
}

static bool planValuesAvailableBefore(UniformLoopOp loop, unsigned index,
                                      const ScaledLoopCarryPlan &plan,
                                      Operation *op) {
  if (!valueAvailableBefore(loop.getInits()[index], op))
    return false;
  for (const ScaledLoopStep &step : plan.steps)
    if (!getImmValue(step.step) && !valueAvailableBefore(step.step, op))
      return false;
  return true;
}

static Operation *getScaleInsertPoint(UniformLoopOp loop, unsigned index,
                                      const ScaledLoopCarryPlan &plan) {
  Value entryCond = loop.getEntryCond();
  Operation *condDef = entryCond ? entryCond.getDefiningOp() : nullptr;
  if (condDef && condDef->getBlock() == loop->getBlock() &&
      planValuesAvailableBefore(loop, index, plan, condDef))
    return condDef;
  return loop;
}

static Value createScaledStep(OpBuilder &builder, Operation *insertPoint,
                              Value step, int64_t shift) {
  if (std::optional<int64_t> imm = getImmValue(step)) {
    std::optional<uint64_t> shifted = shiftU32Imm(*imm, shift);
    if (!shifted)
      return {};
    return createImm(builder, step.getLoc(), *shifted);
  }
  builder.setInsertionPoint(insertPoint);
  return createShiftedReg(builder, step.getLoc(), step, shift);
}

static bool scaleLoopCarry(UniformLoopOp loop, unsigned index,
                           const ScaledLoopCarryPlan &plan) {
  OpBuilder builder(loop.getContext());
  Value init = loop.getInits()[index];
  Operation *insertPoint = getScaleInsertPoint(loop, index, plan);
  builder.setInsertionPoint(insertPoint);
  Value scaledInit = createShiftedReg(builder, loop.getLoc(), init, plan.shift);
  loop.getInitsMutable()[index].assign(scaledInit);

  for (SLshlB32Op shl : plan.shifts) {
    shl.getResult().replaceAllUsesWith(shl.getLhs());
    shl.erase();
  }

  for (const ScaledLoopStep &step : plan.steps) {
    Value scaledStep =
        createScaledStep(builder, insertPoint, step.step, plan.shift);
    if (!scaledStep)
      return false;
    step.add->setOperand(step.stepOperand, scaledStep);
  }
  return true;
}

static bool scaleLoopCarries(UniformLoopOp loop) {
  SmallVector<std::pair<unsigned, ScaledLoopCarryPlan>, 2> plans;
  for (unsigned index : llvm::seq<unsigned>(0, loop.getInits().size())) {
    FailureOr<ScaledLoopCarryPlan> plan = buildScaledLoopCarryPlan(loop, index);
    if (succeeded(plan))
      plans.push_back({index, std::move(*plan)});
  }

  bool changed = false;
  for (auto &[index, plan] : plans)
    changed |= scaleLoopCarry(loop, index, plan);
  return changed;
}

static bool scaleLoopCarries(func::FuncOp func) {
  SmallVector<UniformLoopOp> loops;
  func.walk([&](UniformLoopOp loop) { loops.push_back(loop); });

  bool changed = false;
  for (UniformLoopOp loop : loops)
    changed |= scaleLoopCarries(loop);
  return changed;
}

static bool isVccCompare(Operation *op) {
  return isa_and_nonnull<VCmpEqU32VccOp, VCmpNeU32VccOp, VCmpLtU32VccOp,
                         VCmpLeU32VccOp, VCmpGtU32VccOp, VCmpGeU32VccOp,
                         VCmpLtI32VccOp, VCmpLeI32VccOp, VCmpGtI32VccOp,
                         VCmpGeI32VccOp>(op);
}

static bool writesVcc(Operation *op) {
  HardwareResourceEffects effects = getHardwareResourceEffects(op);
  return llvm::is_contained(effects.writes, HardwareResourceKind::VCC);
}

static bool transitivelyWritesVcc(Operation *root) {
  return root
      ->walk([&](Operation *op) {
        return writesVcc(op) ? WalkResult::interrupt() : WalkResult::advance();
      })
      .wasInterrupted();
}

static bool hasInterveningVccWriter(Operation *from, Operation *to) {
  for (Operation *op = from->getNextNode(); op && op != to;
       op = op->getNextNode())
    if (transitivelyWritesVcc(op))
      return true;
  return false;
}

static bool isVGPR(Value value) {
  RegType type = dyn_cast<RegType>(value.getType());
  return type && type.getRegClass() == RegClass::VGPR;
}

static Value ensureVccCndmaskTrueVGPR(OpBuilder &builder,
                                      VCndmaskB32TupleOp select) {
  Value trueValue = select.getTrueValue();
  if (isVGPR(trueValue))
    return trueValue;
  return VMovB32TupleOp::create(builder, select.getLoc(),
                                select.getResult().getType(), trueValue)
      .getResult();
}

static bool foldVccCndmask(func::FuncOp func) {
  SmallVector<VCndmaskB32TupleOp> selects;
  func.walk([&](VCndmaskB32TupleOp op) { selects.push_back(op); });

  OpBuilder builder(func.getContext());
  bool changed = false;
  for (VCndmaskB32TupleOp select : selects) {
    Value condition = select.getCondition();
    Operation *compare = condition.getDefiningOp();
    if (!isVccCompare(compare) || compare->getBlock() != select->getBlock())
      continue;
    if (hasInterveningVccWriter(compare, select))
      continue;

    builder.setInsertionPoint(select);
    Value trueValue = ensureVccCndmaskTrueVGPR(builder, select);
    Value replacement =
        VCndmaskB32VccOp::create(
            builder, select.getLoc(), select.getResult().getType(),
            select.getFalseValue(), trueValue, compare->getResult(1))
            .getResult();
    select.getResult().replaceAllUsesWith(replacement);
    select.erase();
    changed = true;
  }
  return changed;
}

struct WaveAMDMachineCleanupPass
    : public wave::impl::WaveAMDMachineCleanupBase<WaveAMDMachineCleanupPass> {
  void runOnOperation() override {
    bool failedPass = false;
    getOperation()->walk([&](func::FuncOp func) {
      bool changed = true;
      while (changed) {
        FailureOr<bool> d16Changed = formD16ByteLoadPacks(func);
        if (failed(d16Changed)) {
          failedPass = true;
          return;
        }
        changed = *d16Changed;
        changed |= hoistFunction(func);
        changed |= scaleLoopCarries(func);
        changed |= foldVccCndmask(func);
        FailureOr<bool> uniformShiftChanged =
            reuseUniformWorkitemShiftOperands(func);
        if (failed(uniformShiftChanged)) {
          failedPass = true;
          return;
        }
        changed |= *uniformShiftChanged;
      }
    });
    if (failedPass)
      signalPassFailure();
  }
};
} // namespace
