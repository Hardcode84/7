//===- WaveAMDMachineMultiWaveSpecialize.cpp -----------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDEntryRegs.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MathExtras.h"

#include <cstdint>
#include <limits>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINEMULTIWAVESPECIALIZE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static constexpr StringLiteral kScheduleMarkerAttr =
    "waveamdmachine.multi_wave_schedule";
static constexpr StringLiteral kScheduleInputAttr =
    "waveamdmachine.schedule_input";
static constexpr StringLiteral kEnableSpecializationAttr =
    "waveamdmachine.enable_multi_wave_specialization";
static constexpr StringLiteral kPairedBarriersAttr =
    "waveamdmachine.paired_barriers";
static constexpr StringLiteral kBarrierSitesAttr =
    "waveamdmachine.barrier_sites";

static const waveamdmachine::ArchData *resolveArch(Operation *op) {
  ModuleOp target = waveamdmachine::findAMDGPUTargetModule(op);
  if (!target)
    return nullptr;
  StringAttr attr = target->getAttrOfType<StringAttr>("waveamdmachine.target");
  if (!attr)
    return nullptr;
  std::optional<waveamdmachine::AMDGPUTarget> parsed =
      waveamdmachine::parseAMDGPUTargetAttr(attr.getValue());
  if (!parsed)
    return nullptr;
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(parsed->chip);
  if (!waveamdmachine::isArchSupported(isa))
    return nullptr;
  return &waveamdmachine::getArchData(isa);
}

static std::optional<uint64_t> flattenWorkgroupShape(DenseI32ArrayAttr shape) {
  if (shape.empty() || shape.size() > 3)
    return std::nullopt;
  uint64_t flat = 1;
  for (int32_t dim : shape.asArrayRef()) {
    if (dim <= 0 || flat > std::numeric_limits<uint64_t>::max() / dim)
      return std::nullopt;
    flat *= static_cast<uint64_t>(dim);
  }
  return flat;
}

static FailureOr<std::optional<uint64_t>>
getFlatWorkgroupSize(func::FuncOp func) {
  std::optional<uint64_t> flat;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr shape = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!shape)
      continue;
    std::optional<uint64_t> candidate = flattenWorkgroupShape(shape);
    if (!candidate || (flat && *flat != *candidate))
      return failure();
    flat = candidate;
  }
  return flat;
}

static bool hasLinearWorkitemX(func::FuncOp func) {
  bool found = false;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr shape = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!shape)
      continue;
    found = true;
    if (llvm::any_of(shape.asArrayRef().drop_front(),
                     [](int32_t dim) { return dim != 1; }))
      return false;
  }
  return found;
}

static FailureOr<std::optional<unsigned>>
deriveWorkgroupWaves(std::optional<uint64_t> flat, unsigned wavefront) {
  if (!flat)
    return std::optional<unsigned>();
  uint64_t waves = (*flat + wavefront - 1) / wavefront;
  if (waves > std::numeric_limits<unsigned>::max())
    return failure();
  return std::optional<unsigned>(static_cast<unsigned>(waves));
}

static std::optional<unsigned> getWorkgroupWaves(func::FuncOp func) {
  FailureOr<std::optional<uint64_t>> flat = getFlatWorkgroupSize(func);
  FailureOr<unsigned> wavefront = waveamdmachine::getAMDGPUWavefrontSize(
      func, "waveamd-machine-multi-wave-specialize");
  if (failed(flat) || failed(wavefront) || *wavefront == 0)
    return std::nullopt;
  FailureOr<std::optional<unsigned>> derived =
      deriveWorkgroupWaves(*flat, *wavefront);
  if (failed(derived))
    return std::nullopt;

  IntegerAttr explicitAttr =
      func->getAttrOfType<IntegerAttr>("wave.waves_per_workgroup");
  if (!explicitAttr)
    return *derived;
  if (explicitAttr.getInt() <= 0)
    return std::nullopt;
  unsigned explicitWaves = explicitAttr.getValue().getLimitedValue();
  if (*derived && **derived != explicitWaves)
    return std::nullopt;
  return explicitWaves;
}

static std::optional<unsigned> getTargetWaves(func::FuncOp func) {
  IntegerAttr attr =
      func->getAttrOfType<IntegerAttr>("waveamdmachine.target_waves");
  if (!attr || attr.getInt() <= 0)
    return std::nullopt;
  return attr.getValue().getLimitedValue();
}

static bool isSupportedResultType(Type type) {
  if (isa<waveamdmachine::MemTokenType>(type))
    return true;
  auto reg = dyn_cast<waveamdmachine::RegType>(type);
  if (!reg)
    return false;
  return reg.getRegClass() == waveamdmachine::RegClass::SGPR ||
         reg.getRegClass() == waveamdmachine::RegClass::VGPR ||
         reg.getRegClass() == waveamdmachine::RegClass::AGPR;
}

static bool isTopLevelLoop(waveamdmachine::UniformLoopOp loop) {
  if (!isa<func::FuncOp>(loop->getParentOp()) ||
      loop.getBody().getBlocks().size() != 1 ||
      !llvm::all_of(loop.getResultTypes(), isSupportedResultType))
    return false;
  return true;
}

static FailureOr<DenseMap<Operation *, int64_t>>
buildBarrierLineage(waveamdmachine::UniformLoopOp loop) {
  DenseMap<Operation *, int64_t> sites;
  int64_t nextSite = 0;
  WalkResult walk = loop.walk([&](Operation *op) {
    if (isa<waveamdmachine::SBarrierOp, waveamdmachine::BarrierArriveOp>(op)) {
      sites.try_emplace(op, nextSite++);
      return WalkResult::advance();
    }
    auto wait = dyn_cast<waveamdmachine::BarrierWaitOp>(op);
    if (!wait)
      return WalkResult::advance();
    auto arrive =
        wait.getTicket().getDefiningOp<waveamdmachine::BarrierArriveOp>();
    DenseMap<Operation *, int64_t>::const_iterator it = sites.find(arrive);
    if (!arrive || it == sites.end())
      return WalkResult::interrupt();
    sites.try_emplace(op, it->second);
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return sites;
}

static void setBarrierLineage(const DenseMap<Operation *, int64_t> &sites,
                              IRMapping &mapping) {
  for (const auto &[op, site] : sites) {
    DenseI64ArrayAttr attr = DenseI64ArrayAttr::get(op->getContext(), {site});
    op->setAttr(kBarrierSitesAttr, attr);
    mapping.lookup(op)->setAttr(kBarrierSitesAttr, attr);
  }
}

static Value getFirstWorkitemX(OpBuilder &builder, Location loc,
                               func::FuncOp func,
                               waveamdmachine::UniformLoopOp loop) {
  MLIRContext *context = builder.getContext();
  for (Operation &op : *loop->getBlock()) {
    if (&op == loop.getOperation())
      break;
    auto read = dyn_cast<waveamdmachine::VReadfirstlaneB32Op>(op);
    if (read && isa_and_nonnull<waveamdmachine::VWorkitemIdXOp>(
                    read->getOperand(0).getDefiningOp()))
      return read.getResult();
  }

  WaveAMDKernelEntryRegs entryRegs = getWaveAMDKernelEntryRegs(func);
  Type vgpr = waveamdmachine::RegType::get(
      context, waveamdmachine::RegClass::VGPR, 1, entryRegs.workitemIdVGPR(0));
  Type sgpr = waveamdmachine::RegType::get(
      context, waveamdmachine::RegClass::SGPR, 1, -1);
  Value workitem =
      waveamdmachine::VWorkitemIdXOp::create(builder, loc, vgpr).getResult();
  return waveamdmachine::VReadfirstlaneB32Op::create(builder, loc, sgpr,
                                                     workitem)
      .getResult();
}

static Value buildClassCondition(OpBuilder &builder, Location loc,
                                 func::FuncOp func,
                                 waveamdmachine::UniformLoopOp loop,
                                 const waveamdmachine::ArchData &arch,
                                 unsigned wavefront, unsigned targetWaves,
                                 bool multipleWorkgroups) {
  MLIRContext *context = builder.getContext();
  Type sgpr = waveamdmachine::RegType::get(
      context, waveamdmachine::RegClass::SGPR, 1, -1);
  Type scc = waveamdmachine::RegType::get(context,
                                          waveamdmachine::RegClass::SCC, 1, -1);
  Type imm = waveamdmachine::ImmType::get(context);
  Value parity;
  if (multipleWorkgroups) {
    unsigned idOffset = targetWaves > 1 ? arch.waveIdOffset : arch.simdIdOffset;
    parity =
        waveamdmachine::SGetregHwIdOp::create(builder, loc, sgpr, idOffset, 1)
            .getResult();
  } else {
    unsigned classShift = llvm::Log2_32(wavefront);
    if (targetWaves > 1)
      classShift += llvm::Log2_32(arch.simdsPerCU);
    Value shift = waveamdmachine::ImmOp::create(builder, loc, imm, classShift)
                      .getResult();
    Value one = waveamdmachine::ImmOp::create(builder, loc, imm, 1).getResult();
    Value firstWorkitem = getFirstWorkitemX(builder, loc, func, loop);
    Value ordinal = waveamdmachine::SLshrB32Op::create(builder, loc, sgpr, scc,
                                                       firstWorkitem, shift)
                        .getResult();
    parity =
        waveamdmachine::SAndB32Op::create(builder, loc, sgpr, scc, ordinal, one)
            .getResult();
  }
  Value zero = waveamdmachine::ImmOp::create(builder, loc, imm, 0).getResult();
  return waveamdmachine::SCmpEqU32Op::create(builder, loc, scc, parity, zero)
      .getResult();
}

static SmallVector<SmallVector<OpOperand *, 2>>
saveResultUses(waveamdmachine::UniformLoopOp loop) {
  SmallVector<SmallVector<OpOperand *, 2>> saved;
  saved.reserve(loop.getNumResults());
  for (Value result : loop.getResults()) {
    SmallVector<OpOperand *, 2> uses;
    for (OpOperand &use : result.getUses())
      uses.push_back(&use);
    saved.push_back(std::move(uses));
  }
  return saved;
}

static void replaceSavedUses(waveamdmachine::UniformIfOp uniformIf,
                             ArrayRef<SmallVector<OpOperand *, 2>> savedUses) {
  for (auto [result, uses] : llvm::zip_equal(uniformIf.getResults(), savedUses))
    for (OpOperand *use : uses)
      use->set(result);
}

static LogicalResult specializeLoop(waveamdmachine::UniformLoopOp loop,
                                    const waveamdmachine::ArchData &arch,
                                    unsigned wavefront, unsigned targetWaves,
                                    bool multipleWorkgroups) {
  FailureOr<DenseMap<Operation *, int64_t>> barrierSites =
      buildBarrierLineage(loop);
  if (failed(barrierSites))
    return loop.emitOpError(
        "barrier wait must reference an arrive in the specialized loop");
  SmallVector<SmallVector<OpOperand *, 2>> savedUses = saveResultUses(loop);

  IRMapping mapping;
  Operation *cloned = loop->clone(mapping);
  auto alternate = cast<waveamdmachine::UniformLoopOp>(cloned);
  if (!barrierSites->empty())
    setBarrierLineage(*barrierSites, mapping);

  OpBuilder builder(loop);
  Location loc = loop.getLoc();
  Value firstClass = buildClassCondition(
      builder, loc, loop->getParentOfType<func::FuncOp>(), loop, arch,
      wavefront, targetWaves, multipleWorkgroups);
  waveamdmachine::UniformIfOp uniformIf = waveamdmachine::UniformIfOp::create(
      builder, loc, loop.getResultTypes(), firstClass);
  uniformIf->setAttr(kScheduleMarkerAttr, builder.getUnitAttr());
  if (!barrierSites->empty())
    uniformIf->setAttr(kPairedBarriersAttr, builder.getUnitAttr());

  Block *thenBlock = builder.createBlock(&uniformIf.getThenRegion());
  loop->moveBefore(thenBlock, thenBlock->end());
  builder.setInsertionPointToEnd(thenBlock);
  waveamdmachine::YieldOp::create(builder, loc, loop.getResults());

  Block *elseBlock = builder.createBlock(&uniformIf.getElseRegion());
  elseBlock->getOperations().push_back(alternate);
  builder.setInsertionPointToEnd(elseBlock);
  waveamdmachine::YieldOp::create(builder, loc, alternate.getResults());
  replaceSavedUses(uniformIf, savedUses);
  return success();
}

struct SpecializationConfig {
  const waveamdmachine::ArchData *arch;
  unsigned wavefront;
  unsigned targetWaves;
  bool multipleWorkgroups;
};

static bool hasValidWaveTopology(const waveamdmachine::ArchData &arch,
                                 unsigned wavefront) {
  return llvm::isPowerOf2_32(wavefront) &&
         llvm::isPowerOf2_32(arch.simdsPerCU) && arch.simdIdOffset >= 0 &&
         arch.waveIdOffset >= 0;
}

static std::optional<SpecializationConfig>
getSpecializationConfig(func::FuncOp func) {
  const waveamdmachine::ArchData *arch = resolveArch(func);
  if (!arch || !hasLinearWorkitemX(func))
    return std::nullopt;
  std::optional<unsigned> targetWaves = getTargetWaves(func);
  std::optional<unsigned> workgroupWaves = getWorkgroupWaves(func);
  if (!targetWaves || !workgroupWaves)
    return std::nullopt;
  FailureOr<unsigned> wavefront = waveamdmachine::getAMDGPUWavefrontSize(
      func, "waveamd-machine-multi-wave-specialize");
  if (failed(wavefront))
    return std::nullopt;
  if (!hasValidWaveTopology(*arch, *wavefront))
    return std::nullopt;
  if (*targetWaves > static_cast<unsigned>(arch->wavesPerSIMD))
    return std::nullopt;
  unsigned residentWaves =
      static_cast<unsigned>(arch->simdsPerCU) * *targetWaves;
  if (residentWaves % *workgroupWaves != 0)
    return std::nullopt;
  return SpecializationConfig{arch, *wavefront, *targetWaves,
                              *workgroupWaves != residentWaves};
}

static SmallVector<waveamdmachine::UniformLoopOp, 2>
collectSpecializationLoops(func::FuncOp func) {
  SmallVector<waveamdmachine::UniformLoopOp, 2> loops;
  func.walk([&](waveamdmachine::UniformLoopOp loop) {
    if (isTopLevelLoop(loop))
      loops.push_back(loop);
  });
  return loops;
}

static LogicalResult specializeFunction(func::FuncOp func) {
  std::optional<SpecializationConfig> config = getSpecializationConfig(func);
  if (!config)
    return success();
  for (waveamdmachine::UniformLoopOp loop : collectSpecializationLoops(func))
    if (failed(specializeLoop(loop, *config->arch, config->wavefront,
                              config->targetWaves, config->multipleWorkgroups)))
      return failure();
  return success();
}

struct WaveAMDMachineMultiWaveSpecializePass
    : public wave::impl::WaveAMDMachineMultiWaveSpecializeBase<
          WaveAMDMachineMultiWaveSpecializePass> {
  using WaveAMDMachineMultiWaveSpecializeBase::
      WaveAMDMachineMultiWaveSpecializeBase;

  void runOnOperation() override {
    WalkResult walk = getOperation()->walk([&](func::FuncOp func) {
      if (func.isExternal() || !func->hasAttr(kScheduleInputAttr) ||
          !func->hasAttr(kEnableSpecializationAttr))
        return WalkResult::advance();
      return failed(specializeFunction(func)) ? WalkResult::interrupt()
                                              : WalkResult::advance();
    });
    if (walk.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
