//===- WaveAMDMaterializeSplitBarriers.cpp -------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

#include <limits>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMATERIALIZESPLITBARRIERS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct BarrierSlot {
  int64_t offset = 0;
};

struct LDSReservation {
  unsigned dynamicBytes = 0;
  unsigned base = 0;
  unsigned newFixedBytes = 0;
};

struct SplitBarrierOps {
  SmallVector<waveamdmachine::BarrierInitOp> inits;
  SmallVector<waveamdmachine::BarrierArriveOp> arrives;
  SmallVector<waveamdmachine::BarrierWaitOp> waits;

  bool empty() const {
    return inits.empty() && arrives.empty() && waits.empty();
  }
};

struct MachineTypes {
  Type imm;
  Type token;
  waveamdmachine::RegType vgpr1;
  waveamdmachine::RegType sgpr1;
  waveamdmachine::RegType sgpr2;
  waveamdmachine::RegType scc;
  Type m0;
};

static constexpr uint64_t kBarrierPollSleep = 1;

struct BarrierPoll {
  Value token;
  Value cont;
};

static bool isPowerOfTwo(unsigned value) {
  return value != 0 && (value & (value - 1)) == 0;
}

static int64_t alignTo(int64_t value, int64_t align) {
  return ((value + align - 1) / align) * align;
}

static MachineTypes getMachineTypes(MLIRContext *ctx) {
  using waveamdmachine::RegClass;
  return {waveamdmachine::ImmType::get(ctx),
          waveamdmachine::MemTokenType::get(ctx),
          waveamdmachine::RegType::get(ctx, RegClass::VGPR, 1, -1),
          waveamdmachine::RegType::get(ctx, RegClass::SGPR, 1, -1),
          waveamdmachine::RegType::get(ctx, RegClass::SGPR, 2, -1),
          waveamdmachine::RegType::get(ctx, RegClass::SCC, 1, -1),
          waveamdmachine::M0Type::get(ctx)};
}

static Value makeImm(OpBuilder &builder, Location loc, MachineTypes types,
                     uint64_t value) {
  return waveamdmachine::ImmOp::create(builder, loc, types.imm, value)
      .getResult();
}

static Value makeVGPRImm(OpBuilder &builder, Location loc, MachineTypes types,
                         uint64_t value) {
  Value imm = makeImm(builder, loc, types, value);
  return waveamdmachine::VMovB32TupleOp::create(builder, loc, types.vgpr1, imm)
      .getResult();
}

static std::optional<int64_t> getKnownWorkgroupDim(func::FuncOp func,
                                                   unsigned axis) {
  if (axis > 2)
    return std::nullopt;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr attr = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!attr)
      continue;
    int32_t dim = axis < attr.size() ? attr.asArrayRef()[axis] : 1;
    if (dim > 0)
      return dim;
  }
  return std::nullopt;
}

static std::optional<uint64_t> checkedMul(uint64_t lhs, uint64_t rhs) {
  if (lhs > std::numeric_limits<uint64_t>::max() / rhs)
    return std::nullopt;
  return lhs * rhs;
}

static std::optional<uint64_t> getFlatWorkgroupSize(func::FuncOp func) {
  uint64_t flat = 1;
  for (unsigned axis : llvm::seq<unsigned>(0, 3)) {
    std::optional<int64_t> dim = getKnownWorkgroupDim(func, axis);
    if (!dim)
      return std::nullopt;
    std::optional<uint64_t> next =
        checkedMul(flat, static_cast<uint64_t>(*dim));
    if (!next)
      return std::nullopt;
    flat = *next;
  }
  return flat;
}

static bool hasConsistentWavesPerWorkgroup(func::FuncOp func, unsigned waves) {
  IntegerAttr attr =
      func->getAttrOfType<IntegerAttr>("wave.waves_per_workgroup");
  return !attr || attr.getInt() == waves;
}

static std::optional<unsigned> getExpectedWaves(func::FuncOp func,
                                                unsigned wavefrontSize) {
  std::optional<uint64_t> flat = getFlatWorkgroupSize(func);
  if (!flat || wavefrontSize == 0)
    return std::nullopt;

  uint64_t waves64 = ((*flat - 1) / wavefrontSize) + 1;
  if (waves64 > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  unsigned waves = static_cast<unsigned>(waves64);
  if (!isPowerOfTwo(waves))
    return std::nullopt;
  if (!hasConsistentWavesPerWorkgroup(func, waves))
    return std::nullopt;
  return waves;
}

static FailureOr<unsigned> getUnsignedAttr(Operation *op, StringRef name) {
  IntegerAttr attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return 0;
  int64_t value = attr.getInt();
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return op->emitError(name) << " must fit unsigned";
  return static_cast<unsigned>(value);
}

static FailureOr<unsigned> getDynamicLDSBytes(func::FuncOp func) {
  FailureOr<unsigned> waveBytes =
      getUnsignedAttr(func, "wave.dynamic_lds_size");
  FailureOr<unsigned> machineBytes =
      getUnsignedAttr(func, "waveamdmachine.dynamic_lds_size");
  if (failed(waveBytes) || failed(machineBytes))
    return failure();
  if (*waveBytes != 0 && *machineBytes != 0 && *waveBytes != *machineBytes)
    return func.emitError("dynamic LDS attrs disagree");
  return std::max(*waveBytes, *machineBytes);
}

static FailureOr<unsigned> getFixedLDSBytes(func::FuncOp func,
                                            unsigned dynamicBytes) {
  FailureOr<unsigned> waveBytes = getUnsignedAttr(func, "wave.lds_size");
  FailureOr<unsigned> machineBytes =
      getUnsignedAttr(func, "waveamdmachine.lds_size");
  if (failed(waveBytes) || failed(machineBytes))
    return failure();
  if (*waveBytes != 0 || *machineBytes == 0)
    return *waveBytes;
  if (*machineBytes < dynamicBytes)
    return func.emitError("dynamic LDS size exceeds total LDS size");
  return *machineBytes - dynamicBytes;
}

static void setLDSAttrs(func::FuncOp func, OpBuilder &builder,
                        unsigned fixedBytes, unsigned dynamicBytes) {
  func->setAttr("wave.lds_size", builder.getI64IntegerAttr(fixedBytes));
  if (func->hasAttr("waveamdmachine.lds_size")) {
    unsigned totalBytes = fixedBytes + dynamicBytes;
    func->setAttr("waveamdmachine.lds_size",
                  builder.getI64IntegerAttr(totalBytes));
  }
}

static std::optional<unsigned> checkedAddBytes(unsigned lhs, unsigned rhs) {
  uint64_t sum = static_cast<uint64_t>(lhs) + rhs;
  if (sum > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(sum);
}

static std::optional<unsigned> getLDSByteImm(Value value) {
  waveamdmachine::ImmOp imm = value.getDefiningOp<waveamdmachine::ImmOp>();
  if (!imm || imm.getValue() > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(imm.getValue());
}

struct FoldedSGPROffset {
  Value base;
  unsigned bytes = 0;
};

static std::optional<FoldedSGPROffset> foldSGPRByteOffsets(Value value) {
  FoldedSGPROffset folded{value, 0};
  while (waveamdmachine::SAddI32Op add =
             folded.base.getDefiningOp<waveamdmachine::SAddI32Op>()) {
    std::optional<unsigned> rhs = getLDSByteImm(add.getRhs());
    if (!rhs)
      break;
    std::optional<unsigned> bytes = checkedAddBytes(folded.bytes, *rhs);
    if (!bytes)
      return std::nullopt;
    folded.base = add.getLhs();
    folded.bytes = *bytes;
  }
  return folded;
}

static Value materializeM0FromSGPROffset(OpBuilder &builder, Location loc,
                                         MachineTypes types,
                                         FoldedSGPROffset folded) {
  if (folded.bytes == 0)
    return waveamdmachine::SMovM0Op::create(builder, loc, types.m0, folded.base)
        .getResult();
  return waveamdmachine::SAddM0I32Op::create(
             builder, loc, types.m0, types.scc, folded.base,
             makeImm(builder, loc, types, folded.bytes))
      .getM0();
}

static FailureOr<Value> shiftM0Value(OpBuilder &builder, Location loc,
                                     MachineTypes types, Value m0,
                                     unsigned bytes) {
  if (waveamdmachine::SMovM0Op mov =
          m0.getDefiningOp<waveamdmachine::SMovM0Op>()) {
    std::optional<FoldedSGPROffset> folded =
        foldSGPRByteOffsets(mov.getSource());
    if (!folded)
      return failure();
    std::optional<unsigned> shifted = checkedAddBytes(folded->bytes, bytes);
    if (!shifted)
      return failure();
    folded->bytes = *shifted;
    return materializeM0FromSGPROffset(builder, loc, types, *folded);
  }

  if (waveamdmachine::SAddM0I32Op add =
          m0.getDefiningOp<waveamdmachine::SAddM0I32Op>()) {
    if (isa<waveamdmachine::M0Type>(add.getLhs().getType()))
      return failure();
    FoldedSGPROffset folded{add.getLhs(), 0};
    if (std::optional<unsigned> rhs = getLDSByteImm(add.getRhs())) {
      std::optional<unsigned> shifted = checkedAddBytes(*rhs, bytes);
      if (!shifted)
        return failure();
      folded.bytes = *shifted;
      return materializeM0FromSGPROffset(builder, loc, types, folded);
    }
    waveamdmachine::SAddI32Op sum = waveamdmachine::SAddI32Op::create(
        builder, loc, types.sgpr1, types.scc, add.getLhs(), add.getRhs());
    folded.base = sum.getResult();
    folded.bytes = bytes;
    return materializeM0FromSGPROffset(builder, loc, types, folded);
  }

  return failure();
}

static bool allResultsUnused(Operation *op) {
  return llvm::all_of(op->getResults(),
                      [](Value result) { return result.use_empty(); });
}

static bool isErasableAddressOp(Operation *op) {
  return op && isa<waveamdmachine::ImmOp, waveamdmachine::SAddI32Op,
                   waveamdmachine::SAddM0I32Op, waveamdmachine::SMovM0Op>(op);
}

static void eraseDeadAddressOp(Operation *op) {
  if (!isErasableAddressOp(op) || !allResultsUnused(op))
    return;
  SmallVector<Value, 4> operands(op->operand_begin(), op->operand_end());
  op->erase();
  for (Value operand : operands)
    eraseDeadAddressOp(operand.getDefiningOp());
}

static Value addVGPRByteOffset(OpBuilder &builder, Location loc,
                               MachineTypes types, Value value,
                               unsigned bytes) {
  if (bytes == 0)
    return value;
  return waveamdmachine::VAddU32Op::create(builder, loc, types.vgpr1, value,
                                           makeImm(builder, loc, types, bytes))
      .getResult();
}

static bool canShiftM0AtDef(Value m0, Operation *consumer) {
  Operation *def = m0.getDefiningOp();
  if (!isErasableAddressOp(def) || def->getBlock() != consumer->getBlock() ||
      !m0.hasOneUse())
    return false;
  return llvm::all_of(def->getResults(), [&](Value result) {
    return result == m0 || result.use_empty();
  });
}

static DenseSet<Value>
collectM0ValuesShiftedAtDef(ArrayRef<Operation *> ldsOps) {
  DenseSet<Value> values;
  for (Operation *op : ldsOps)
    for (Value operand : op->getOperands())
      if (isa<waveamdmachine::M0Type>(operand.getType()) &&
          canShiftM0AtDef(operand, op))
        values.insert(operand);
  return values;
}

static Value findM0ChainRoot(Value m0) {
  while (waveamdmachine::SAddM0I32Op add =
             m0.getDefiningOp<waveamdmachine::SAddM0I32Op>()) {
    if (!isa<waveamdmachine::M0Type>(add.getLhs().getType()))
      break;
    m0 = add.getLhs();
  }
  return m0;
}

static bool isLDSAddressUser(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::LDSLoadOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::LDSStoreOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>();
}

static bool m0ChainOnlyAddressesLDS(Value m0, DenseSet<Value> &visited) {
  if (!visited.insert(m0).second)
    return true;
  for (OpOperand &use : m0.getUses()) {
    Operation *owner = use.getOwner();
    if (isLDSAddressUser(owner))
      continue;
    waveamdmachine::SAddM0I32Op add =
        dyn_cast<waveamdmachine::SAddM0I32Op>(owner);
    if (!add || use.getOperandNumber() != 0 ||
        !m0ChainOnlyAddressesLDS(add.getM0(), visited))
      return false;
  }
  return true;
}

static DenseSet<Value> collectM0ChainRoots(func::FuncOp func) {
  DenseSet<Value> roots;
  func.walk([&](waveamdmachine::SAddM0I32Op add) {
    if (isa<waveamdmachine::M0Type>(add.getLhs().getType()))
      roots.insert(findM0ChainRoot(add.getM0()));
  });
  return roots;
}

static LogicalResult shiftM0ChainRoot(OpBuilder &builder, MachineTypes types,
                                      Value root, unsigned bytes) {
  Operation *oldDef = root.getDefiningOp();
  if (!isa_and_nonnull<waveamdmachine::SMovM0Op, waveamdmachine::SAddM0I32Op>(
          oldDef))
    return emitError(root.getLoc(), "cannot find dynamic LDS M0 chain root");
  if (llvm::any_of(oldDef->getResults(), [&](Value result) {
        return result != root && !result.use_empty();
      }))
    return oldDef->emitError("cannot shift M0 chain with live flag result");
  DenseSet<Value> visited;
  if (!m0ChainOnlyAddressesLDS(root, visited))
    return oldDef->emitError("M0 chain has a non-LDS address use");

  builder.setInsertionPoint(oldDef);
  FailureOr<Value> shifted =
      shiftM0Value(builder, oldDef->getLoc(), types, root, bytes);
  if (failed(shifted))
    return oldDef->emitError("cannot shift dynamic LDS M0 chain root");
  root.replaceAllUsesWith(*shifted);
  eraseDeadAddressOp(oldDef);
  return success();
}

static LogicalResult shiftLDSAddressOperand(OpBuilder &builder,
                                            MachineTypes types, Operation *op,
                                            unsigned bytes,
                                            const DenseSet<Value> &m0AtDefs) {
  for (OpOperand &operand : op->getOpOperands()) {
    if (!isa<waveamdmachine::M0Type>(operand.get().getType()))
      continue;
    Value oldM0 = operand.get();
    Operation *oldDef = oldM0.getDefiningOp();
    builder.setInsertionPoint(m0AtDefs.contains(oldM0) ? oldDef : op);
    FailureOr<Value> shifted =
        shiftM0Value(builder, op->getLoc(), types, oldM0, bytes);
    if (failed(shifted))
      return op->emitError("cannot shift dynamic LDS M0 address");
    operand.set(*shifted);
    eraseDeadAddressOp(oldDef);
    return success();
  }

  if (op->getNumOperands() == 0)
    return success();
  Value addr = op->getOperand(0);
  if (!waveamdmachine::isVGPRValue(addr))
    return success();
  builder.setInsertionPoint(op);
  op->setOperand(0,
                 addVGPRByteOffset(builder, op->getLoc(), types, addr, bytes));
  return success();
}

static SmallVector<Operation *, 64> collectLDSOps(func::FuncOp func) {
  SmallVector<Operation *, 64> ldsOps;
  func.walk([&](Operation *op) {
    if (isLDSAddressUser(op))
      ldsOps.push_back(op);
  });
  return ldsOps;
}

static void collectUsedM0Chains(ArrayRef<Operation *> ldsOps,
                                const DenseSet<Value> &chainRoots,
                                DenseSet<Value> &usedRoots,
                                DenseSet<Operation *> &chainLDSOps) {
  for (Operation *op : ldsOps)
    for (Value operand : op->getOperands()) {
      if (!isa<waveamdmachine::M0Type>(operand.getType()))
        continue;
      Value root = findM0ChainRoot(operand);
      if (!chainRoots.contains(root))
        continue;
      usedRoots.insert(root);
      chainLDSOps.insert(op);
    }
}

static LogicalResult shiftM0ChainRoots(OpBuilder &builder, MachineTypes types,
                                       const DenseSet<Value> &roots,
                                       unsigned bytes) {
  for (Value root : roots)
    if (failed(shiftM0ChainRoot(builder, types, root, bytes)))
      return failure();
  return success();
}

static LogicalResult
shiftUnchainedLDSAddresses(OpBuilder &builder, MachineTypes types,
                           ArrayRef<Operation *> ldsOps,
                           const DenseSet<Operation *> &chainLDSOps,
                           const DenseSet<Value> &m0AtDefs, unsigned bytes) {
  for (Operation *op : ldsOps)
    if (!chainLDSOps.contains(op) &&
        failed(shiftLDSAddressOperand(builder, types, op, bytes, m0AtDefs)))
      return failure();
  return success();
}

static LogicalResult shiftExistingLDSAddresses(func::FuncOp func,
                                               MachineTypes types,
                                               unsigned bytes) {
  if (bytes == 0)
    return success();

  SmallVector<Operation *, 64> ldsOps = collectLDSOps(func);
  DenseSet<Value> m0AtDefs = collectM0ValuesShiftedAtDef(ldsOps);
  OpBuilder builder(func.getContext());
  DenseSet<Value> chainRoots = collectM0ChainRoots(func);
  DenseSet<Value> usedRoots;
  DenseSet<Operation *> chainLDSOps;
  collectUsedM0Chains(ldsOps, chainRoots, usedRoots, chainLDSOps);
  if (failed(shiftM0ChainRoots(builder, types, usedRoots, bytes)))
    return failure();
  return shiftUnchainedLDSAddresses(builder, types, ldsOps, chainLDSOps,
                                    m0AtDefs, bytes);
}

static Value makeBarrierAddress(OpBuilder &builder, Location loc,
                                MachineTypes types, BarrierSlot slot) {
  return makeVGPRImm(builder, loc, types, slot.offset);
}

static Value makeAfterDependency(OpBuilder &builder, Location loc,
                                 MachineTypes types, ValueRange deps) {
  if (deps.empty())
    return Value();
  return waveamdmachine::AfterOp::create(builder, loc, types.token, deps)
      .getResult();
}

static Value enterOneLanePerWave(OpBuilder &builder, Location loc,
                                 MachineTypes types, unsigned wavefrontSize) {
  if (wavefrontSize == 64) {
    Value lane0 =
        waveamdmachine::SMovB64ImmOp::create(builder, loc, types.sgpr2, 1)
            .getResult();
    return waveamdmachine::SAndSaveexecB64Op::create(builder, loc, types.sgpr2,
                                                     types.scc, lane0)
        .getSavedExec();
  }
  Value one = makeImm(builder, loc, types, 1);
  Value lane0 =
      waveamdmachine::SMovB32TupleOp::create(builder, loc, types.sgpr1, one)
          .getResult();
  return waveamdmachine::SAndSaveexecB32Op::create(builder, loc, types.sgpr1,
                                                   types.scc, lane0)
      .getSavedExec();
}

static void restoreExec(OpBuilder &builder, Location loc,
                        unsigned wavefrontSize, Value savedExec) {
  if (wavefrontSize == 64) {
    waveamdmachine::SMovExecB64Op::create(builder, loc, savedExec);
    return;
  }
  waveamdmachine::SMovExecLoOp::create(builder, loc, savedExec);
}

static FailureOr<LDSReservation> reserveLDSForBarriers(func::FuncOp func,
                                                       MachineTypes types,
                                                       unsigned barrierCount) {
  if (barrierCount > (std::numeric_limits<unsigned>::max() - 15) / 4)
    return func.emitError("too many split barriers");
  unsigned reservedBytes = static_cast<unsigned>(alignTo(barrierCount * 4, 16));

  FailureOr<unsigned> dynamicBytes = getDynamicLDSBytes(func);
  if (failed(dynamicBytes))
    return failure();
  FailureOr<unsigned> fixedBytes = getFixedLDSBytes(func, *dynamicBytes);
  if (failed(fixedBytes))
    return failure();

  bool hasDynamicLDS = *dynamicBytes != 0;
  unsigned base =
      hasDynamicLDS ? 0 : static_cast<unsigned>(alignTo(*fixedBytes, 4));
  unsigned newFixedBytes =
      hasDynamicLDS ? *fixedBytes + reservedBytes : base + reservedBytes;
  if (hasDynamicLDS &&
      failed(shiftExistingLDSAddresses(func, types, reservedBytes)))
    return failure();

  return LDSReservation{*dynamicBytes, base, newFixedBytes};
}

static void assignBarrierSlots(ArrayRef<waveamdmachine::BarrierInitOp> inits,
                               unsigned base,
                               DenseMap<Value, BarrierSlot> &slots) {
  for (auto [index, initRef] : llvm::enumerate(inits)) {
    waveamdmachine::BarrierInitOp init = initRef;
    unsigned offset = base + static_cast<unsigned>(index) * 4;
    slots[init.getBarrier()] = BarrierSlot{offset};
  }
}

static void emitBarrierInitStores(func::FuncOp func, MachineTypes types,
                                  ArrayRef<waveamdmachine::BarrierInitOp> inits,
                                  const DenseMap<Value, BarrierSlot> &slots,
                                  unsigned wavefrontSize) {
  Block &entry = func.getBody().front();
  OpBuilder builder(&entry.front());
  waveamdmachine::BarrierInitOp firstInit = inits.front();
  Location loc = firstInit.getLoc();
  Value zero = makeVGPRImm(builder, loc, types, 0);
  Value savedExec = enterOneLanePerWave(builder, loc, types, wavefrontSize);
  SmallVector<Value, 8> storeTokens;
  for (waveamdmachine::BarrierInitOp init : inits) {
    Value addr = makeBarrierAddress(builder, loc, types,
                                    slots.lookup(init.getBarrier()));
    waveamdmachine::DsStoreB32Op store = waveamdmachine::DsStoreB32Op::create(
        builder, loc, types.token, addr, zero, Value(), 0);
    storeTokens.push_back(store.getToken());
  }
  restoreExec(builder, loc, wavefrontSize, savedExec);
  waveamdmachine::SBarrierOp::create(builder, loc, TypeRange{}, storeTokens);
}

static LogicalResult
materializeInit(func::FuncOp func, MachineTypes types,
                ArrayRef<waveamdmachine::BarrierInitOp> inits,
                DenseMap<Value, BarrierSlot> &slots, unsigned wavefrontSize) {
  if (inits.empty())
    return success();

  FailureOr<LDSReservation> reservation =
      reserveLDSForBarriers(func, types, inits.size());
  if (failed(reservation))
    return failure();

  assignBarrierSlots(inits, reservation->base, slots);
  OpBuilder attrBuilder(func.getContext());
  setLDSAttrs(func, attrBuilder, reservation->newFixedBytes,
              reservation->dynamicBytes);
  emitBarrierInitStores(func, types, inits, slots, wavefrontSize);
  return success();
}

static FailureOr<waveamdmachine::BarrierArriveOp>
getMatchingArrive(waveamdmachine::BarrierWaitOp wait) {
  waveamdmachine::BarrierArriveOp ticketArrive =
      wait.getTicket().getDefiningOp<waveamdmachine::BarrierArriveOp>();
  if (!ticketArrive)
    return wait.emitError("barrier_wait ticket must come from barrier_arrive");

  waveamdmachine::BarrierArriveOp tokenArrive =
      wait.getArrival().getDefiningOp<waveamdmachine::BarrierArriveOp>();
  if (tokenArrive != ticketArrive)
    return wait.emitError("barrier_wait arrival must come from ticket arrive");
  if (ticketArrive.getBarrier() != wait.getBarrier())
    return wait.emitError("barrier_wait uses different barrier than arrive");
  if (!ticketArrive.getToken().hasOneUse())
    return ticketArrive.emitError("barrier_arrive token must feed one wait");
  return ticketArrive;
}

static LogicalResult
validateArriveWaitPairs(ArrayRef<waveamdmachine::BarrierArriveOp> arrives,
                        ArrayRef<waveamdmachine::BarrierWaitOp> waits) {
  DenseSet<Operation *> matched;
  for (waveamdmachine::BarrierWaitOp wait : waits) {
    FailureOr<waveamdmachine::BarrierArriveOp> arrive = getMatchingArrive(wait);
    if (failed(arrive))
      return failure();
    matched.insert(arrive->getOperation());
  }
  for (waveamdmachine::BarrierArriveOp arrive : arrives)
    if (!matched.contains(arrive.getOperation()))
      return arrive.emitError("barrier_arrive must feed barrier_wait");
  return success();
}

static LogicalResult materializeArrive(OpBuilder &builder,
                                       waveamdmachine::BarrierArriveOp arrive,
                                       BarrierSlot slot, MachineTypes types,
                                       unsigned wavefrontSize) {
  builder.setInsertionPoint(arrive);
  Location loc = arrive.getLoc();
  Value addr = makeBarrierAddress(builder, loc, types, slot);
  Value one = makeVGPRImm(builder, loc, types, 1);
  Value dependency =
      makeAfterDependency(builder, loc, types, arrive.getDependencies());
  Value savedExec = enterOneLanePerWave(builder, loc, types, wavefrontSize);
  waveamdmachine::DsAddRtnU32Op atomic = waveamdmachine::DsAddRtnU32Op::create(
      builder, loc, types.vgpr1, types.token, addr, one, dependency, 0);
  restoreExec(builder, loc, wavefrontSize, savedExec);

  arrive.getTicket().replaceAllUsesWith(atomic.getResult());
  arrive.getToken().replaceAllUsesWith(atomic.getToken());
  arrive.erase();
  return success();
}

static waveamdmachine::DsLoadB32Op
materializePollLoad(OpBuilder &builder, Location loc, MachineTypes types,
                    Value addr, Value dependency) {
  return waveamdmachine::DsLoadB32Op::create(builder, loc, types.vgpr1,
                                             types.token, addr, dependency, 0);
}

static Value materializeNegTarget(OpBuilder &builder, Location loc,
                                  MachineTypes types, Value target) {
  Value notTarget = waveamdmachine::SXorB32Op::create(
                        builder, loc, types.sgpr1, types.scc, target,
                        makeImm(builder, loc, types, 0xffffffffu))
                        .getResult();
  return waveamdmachine::SAddI32Op::create(builder, loc, types.sgpr1, types.scc,
                                           notTarget,
                                           makeImm(builder, loc, types, 1))
      .getResult();
}

static BarrierPoll finishPoll(OpBuilder &builder, Location loc,
                              MachineTypes types,
                              waveamdmachine::DsLoadB32Op seen,
                              Value negTarget) {
  Value seenScalar = waveamdmachine::VReadfirstlaneB32Op::create(
                         builder, loc, types.sgpr1, seen.getResult())
                         .getResult();
  Value delta = waveamdmachine::SAddI32Op::create(
                    builder, loc, types.sgpr1, types.scc, seenScalar, negTarget)
                    .getResult();
  Value cont = waveamdmachine::SCmpGeU32Op::create(
                   builder, loc, types.scc, delta,
                   makeImm(builder, loc, types, 0x80000000u))
                   .getResult();
  return {seen.getToken(), cont};
}

static Value materializePollLoop(OpBuilder &builder, Location loc,
                                 MachineTypes types, BarrierSlot slot,
                                 Value target, Value arrivalToken,
                                 unsigned wavefrontSize) {
  Value savedExec = enterOneLanePerWave(builder, loc, types, wavefrontSize);
  Value addr = makeBarrierAddress(builder, loc, types, slot);
  waveamdmachine::DsLoadB32Op firstSeen =
      materializePollLoad(builder, loc, types, addr, arrivalToken);
  Value negTarget = materializeNegTarget(builder, loc, types, target);
  BarrierPoll firstPoll = finishPoll(builder, loc, types, firstSeen, negTarget);

  waveamdmachine::UniformIfOp slowPath = waveamdmachine::UniformIfOp::create(
      builder, loc, TypeRange{types.token}, firstPoll.cont);
  Block *thenBlock = builder.createBlock(&slowPath.getThenRegion());
  builder.setInsertionPointToStart(thenBlock);

  waveamdmachine::UniformLoopOp loop = waveamdmachine::UniformLoopOp::create(
      builder, loc, TypeRange{types.token}, Value(),
      ValueRange{firstPoll.token});
  SmallVector<Location, 1> argLocs(1, loc);
  Block *body = builder.createBlock(&loop.getBody(), loop.getBody().end(),
                                    TypeRange{types.token}, argLocs);
  builder.setInsertionPointToStart(body);

  waveamdmachine::SSleepOp::create(
      builder, loc, makeImm(builder, loc, types, kBarrierPollSleep));
  waveamdmachine::DsLoadB32Op loopSeen =
      materializePollLoad(builder, loc, types, addr, body->getArgument(0));
  BarrierPoll loopPoll = finishPoll(builder, loc, types, loopSeen, negTarget);
  waveamdmachine::ContinueIfOp::create(builder, loc, loopPoll.cont,
                                       ValueRange{loopPoll.token});
  builder.setInsertionPointAfter(loop);
  waveamdmachine::YieldOp::create(builder, loc, loop.getResult(0));

  Block *elseBlock = builder.createBlock(&slowPath.getElseRegion());
  builder.setInsertionPointToStart(elseBlock);
  waveamdmachine::YieldOp::create(builder, loc, firstPoll.token);

  builder.setInsertionPointAfter(slowPath);
  restoreExec(builder, loc, wavefrontSize, savedExec);
  return slowPath.getResult(0);
}

static LogicalResult materializeWait(OpBuilder &builder,
                                     waveamdmachine::BarrierWaitOp wait,
                                     BarrierSlot slot, MachineTypes types,
                                     unsigned expectedWaves,
                                     unsigned wavefrontSize) {
  builder.setInsertionPoint(wait);
  Location loc = wait.getLoc();

  Value ticket = waveamdmachine::VReadfirstlaneB32Op::create(
                     builder, loc, types.sgpr1, wait.getTicket())
                     .getResult();
  uint32_t targetMask = ~(static_cast<uint32_t>(expectedWaves) - 1u);
  Value base = waveamdmachine::SAndB32Op::create(
                   builder, loc, types.sgpr1, types.scc, ticket,
                   makeImm(builder, loc, types, targetMask))
                   .getResult();
  Value target = waveamdmachine::SAddI32Op::create(
                     builder, loc, types.sgpr1, types.scc, base,
                     makeImm(builder, loc, types, expectedWaves))
                     .getResult();
  Value ready = materializePollLoop(builder, loc, types, slot, target,
                                    wait.getArrival(), wavefrontSize);
  wait.getToken().replaceAllUsesWith(ready);
  wait.erase();
  return success();
}

static SplitBarrierOps collectSplitBarrierOps(func::FuncOp func) {
  SplitBarrierOps ops;
  func.walk([&](Operation *op) {
    if (auto init = dyn_cast<waveamdmachine::BarrierInitOp>(op))
      ops.inits.push_back(init);
    else if (auto arrive = dyn_cast<waveamdmachine::BarrierArriveOp>(op))
      ops.arrives.push_back(arrive);
    else if (auto wait = dyn_cast<waveamdmachine::BarrierWaitOp>(op))
      ops.waits.push_back(wait);
  });
  return ops;
}

static FailureOr<unsigned> getMaterializationWavefrontSize(func::FuncOp func) {
  FailureOr<unsigned> wavefrontSize = waveamdmachine::getAMDGPUWavefrontSize(
      func, "waveamd-materialize-split-barriers");
  if (failed(wavefrontSize))
    return failure();
  if (*wavefrontSize != 32 && *wavefrontSize != 64)
    return func.emitError("split barrier materialization requires wave32/64");
  return *wavefrontSize;
}

static FailureOr<unsigned>
getMaterializationExpectedWaves(func::FuncOp func, unsigned wavefrontSize) {
  std::optional<unsigned> expectedWaves = getExpectedWaves(func, wavefrontSize);
  if (!expectedWaves)
    return func.emitError(
        "split barriers require known power-of-two waves per workgroup");
  return *expectedWaves;
}

static LogicalResult
materializeArrives(OpBuilder &builder,
                   ArrayRef<waveamdmachine::BarrierArriveOp> arrives,
                   const DenseMap<Value, BarrierSlot> &slots,
                   MachineTypes types, unsigned wavefrontSize) {
  for (waveamdmachine::BarrierArriveOp arrive : arrives) {
    auto it = slots.find(arrive.getBarrier());
    if (it == slots.end())
      return arrive.emitError("barrier_arrive uses unknown barrier_init");
    if (failed(materializeArrive(builder, arrive, it->second, types,
                                 wavefrontSize)))
      return failure();
  }
  return success();
}

static LogicalResult
materializeWaits(OpBuilder &builder,
                 ArrayRef<waveamdmachine::BarrierWaitOp> waits,
                 const DenseMap<Value, BarrierSlot> &slots, MachineTypes types,
                 unsigned expectedWaves, unsigned wavefrontSize) {
  for (waveamdmachine::BarrierWaitOp wait : waits) {
    auto it = slots.find(wait.getBarrier());
    if (it == slots.end())
      return wait.emitError("barrier_wait uses unknown barrier_init");
    if (failed(materializeWait(builder, wait, it->second, types, expectedWaves,
                               wavefrontSize)))
      return failure();
  }
  return success();
}

static LogicalResult
eraseMaterializedInits(ArrayRef<waveamdmachine::BarrierInitOp> inits) {
  for (waveamdmachine::BarrierInitOp init : inits) {
    if (!init.use_empty())
      return init.emitError("barrier_init survived materialization");
    init.erase();
  }
  return success();
}

static LogicalResult materializeFunc(func::FuncOp func) {
  if (func.isExternal())
    return success();

  SplitBarrierOps ops = collectSplitBarrierOps(func);
  if (ops.empty())
    return success();
  if (ops.inits.empty())
    return func.emitError("split barrier materialization found no init ops");

  FailureOr<unsigned> wavefrontSize = getMaterializationWavefrontSize(func);
  if (failed(wavefrontSize))
    return failure();
  FailureOr<unsigned> expectedWaves =
      getMaterializationExpectedWaves(func, *wavefrontSize);
  if (failed(expectedWaves))
    return failure();
  if (failed(validateArriveWaitPairs(ops.arrives, ops.waits)))
    return failure();

  MachineTypes types = getMachineTypes(func.getContext());
  DenseMap<Value, BarrierSlot> slots;
  if (failed(materializeInit(func, types, ops.inits, slots, *wavefrontSize)))
    return failure();

  OpBuilder builder(func.getContext());
  if (failed(materializeArrives(builder, ops.arrives, slots, types,
                                *wavefrontSize)))
    return failure();
  if (failed(materializeWaits(builder, ops.waits, slots, types, *expectedWaves,
                              *wavefrontSize)))
    return failure();
  return eraseMaterializedInits(ops.inits);
}

struct WaveAMDMaterializeSplitBarriersPass
    : public wave::impl::WaveAMDMaterializeSplitBarriersBase<
          WaveAMDMaterializeSplitBarriersPass> {
  using WaveAMDMaterializeSplitBarriersBase::
      WaveAMDMaterializeSplitBarriersBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    WalkResult result = root->walk([&](func::FuncOp func) {
      if (failed(materializeFunc(func)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
