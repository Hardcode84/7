//===- WaveTransformOps.cpp - Wave transform-dialect ops --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/Wave.h"

#include "../Transforms/RegAlloc/WaveAMDRegAllocTransformLoop.h"
#include "../Transforms/RegAlloc/WaveAMDRegAllocTransformState.h"
#include "../Transforms/RegAlloc/WaveAMDRegAllocTransformUtils.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Dialect/Transform/IR/TransformOps.h"
#include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OwningOpRef.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/IR/Threading.h"
#include "mlir/Support/Timing.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/TargetParser/TargetParser.h"
#include <limits>
#include <optional>

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveTransformOps.cpp.inc"

using namespace mlir;

DiagnosedSilenceableFailure
wave::TransformGetIntAttrOp::apply(transform::TransformRewriter &rewriter,
                                   transform::TransformResults &results,
                                   transform::TransformState &state) {
  StringRef key = getAttrName();
  SmallVector<Attribute> values;
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto attr = target->getAttrOfType<IntegerAttr>(key);
    if (!attr)
      return emitDefiniteFailure()
             << "target op missing IntegerAttr `" << key << "`";
    values.push_back(attr);
  }
  results.setParams(cast<OpResult>(getResult()), values);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformGetIntAttrOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.regalloc_loop
//===----------------------------------------------------------------------===//

namespace {

class RegAllocTransformStateExtension final
    : public transform::TransformState::Extension {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RegAllocTransformStateExtension)

  explicit RegAllocTransformStateExtension(transform::TransformState &state)
      : Extension(state) {}

  wave::regalloc_detail::RegAllocTransformStateCache cache;
};

static wave::regalloc_detail::RegAllocTransformStateCache &
getRegAllocTransformStateCache(transform::TransformState &state) {
  RegAllocTransformStateExtension *extension =
      state.getExtension<RegAllocTransformStateExtension>();
  if (!extension)
    extension = &state.addExtension<RegAllocTransformStateExtension>();
  return extension->cache;
}

static DiagnosedSilenceableFailure
runNamedSequence(transform::TransformOpInterface caller,
                 transform::NamedSequenceOp callee,
                 MutableArrayRef<SmallVector<transform::MappedValue>> bindings,
                 transform::TransformState &state,
                 SmallVectorImpl<SmallVector<transform::MappedValue>> &out);

static DiagnosedSilenceableFailure
collectHandleResults(wave::TransformRegAllocLoopOp op,
                     ArrayRef<transform::MappedValue> mappings,
                     SmallVectorImpl<Operation *> &result) {
  result.reserve(mappings.size());
  for (transform::MappedValue mapping : mappings) {
    Operation *payload = mapping.dyn_cast<Operation *>();
    if (!payload)
      return op.emitDefiniteFailure()
             << "regalloc loop body must yield an operation handle";
    result.push_back(payload);
  }
  return DiagnosedSilenceableFailure::success();
}

static SmallVector<transform::MappedValue>
buildHandleMapping(ArrayRef<Operation *> targets) {
  SmallVector<transform::MappedValue> mapping;
  mapping.reserve(targets.size());
  for (Operation *target : targets)
    mapping.push_back(target);
  return mapping;
}

static DiagnosedSilenceableFailure runRegAllocLoopIteration(
    wave::TransformRegAllocLoopOp op, transform::NamedSequenceOp body,
    ArrayRef<Operation *> current, transform::TransformState &state,
    SmallVectorImpl<Operation *> &yielded) {
  getRegAllocTransformStateCache(state).clear();
  for (Operation *target : current)
    wave::clearRegAllocTransformState(target);
  SmallVector<transform::MappedValue> targetMapping =
      buildHandleMapping(current);
  SmallVector<SmallVector<transform::MappedValue>> bindings;
  bindings.push_back(std::move(targetMapping));
  SmallVector<SmallVector<transform::MappedValue>> out;
  DiagnosedSilenceableFailure status =
      runNamedSequence(op, body, bindings, state, out);
  if (!status.succeeded())
    return status;
  if (out.size() != 1)
    return op.emitDefiniteFailure()
           << "regalloc loop body must yield one operation handle";
  return collectHandleResults(op, out[0], yielded);
}

static LogicalResult stampRegAllocLoopIteration(ArrayRef<Operation *> targets,
                                                Builder &builder,
                                                int64_t iteration) {
  for (Operation *target : targets)
    if (failed(wave::setRegAllocTransformLoopIteration(target, builder,
                                                       iteration)))
      return failure();
  return success();
}

static FailureOr<wave::RegAllocTransformLoopDecision>
classifyRegAllocLoopTargets(ArrayRef<Operation *> targets) {
  wave::RegAllocTransformLoopDecision decision =
      wave::RegAllocTransformLoopDecision::Done;
  for (Operation *target : targets) {
    FailureOr<wave::RegAllocTransformLoopDecision> targetDecision =
        wave::getRegAllocTransformLoopDecision(target);
    if (failed(targetDecision))
      return failure();
    if (*targetDecision == wave::RegAllocTransformLoopDecision::Restart)
      return wave::RegAllocTransformLoopDecision::Restart;
    if (*targetDecision == wave::RegAllocTransformLoopDecision::Stalled)
      decision = wave::RegAllocTransformLoopDecision::Stalled;
  }
  return decision;
}

struct RegAllocStageTiming {
  RegAllocStageTiming() {
    applyDefaultTimingManagerCLOptions(manager);
    rootScope = manager.getRootScope();
    regAllocScope = rootScope.nest("wave_regalloc_transform_stages");
  }

  DefaultTimingManager manager;
  TimingScope rootScope;
  TimingScope regAllocScope;
};

static TimingScope getRegAllocStageTimingScope(StringRef name) {
  static RegAllocStageTiming timing;
  return timing.regAllocScope.nest(name);
}

static LogicalResult clearRegAllocLoopMetadata(ArrayRef<Operation *> targets,
                                               Builder &builder) {
  for (Operation *target : targets)
    if (failed(wave::clearRegAllocTransformMetadata(target, builder)))
      return failure();
  return success();
}

static LogicalResult finalizeRegAllocLoopMetadata(ArrayRef<Operation *> targets,
                                                  Builder &builder,
                                                  int64_t iterations) {
  for (Operation *target : targets)
    if (failed(wave::finalizeRegAllocTransformMetadata(target, builder,
                                                       iterations)))
      return failure();
  return success();
}

static void beginRegAllocPreparationTracking(ArrayRef<Operation *> targets) {
  for (Operation *target : targets)
    wave::beginRegAllocPreparationTracking(target);
}

static void endRegAllocPreparationTracking(ArrayRef<Operation *> targets) {
  for (Operation *target : targets)
    wave::endRegAllocPreparationTracking(target);
}

static DiagnosedSilenceableFailure
emitRegAllocLoopStalledFailure(wave::TransformRegAllocLoopOp op,
                               ArrayRef<Operation *> targets) {
  SmallVector<func::FuncOp> funcs;
  for (Operation *target : targets) {
    if (auto func = dyn_cast<func::FuncOp>(target)) {
      funcs.push_back(func);
      continue;
    }
    target->walk([&](func::FuncOp func) { funcs.push_back(func); });
  }

  for (func::FuncOp func : funcs) {
    FailureOr<std::optional<wave::regalloc_detail::RegAllocTransformFailure>>
        failure = wave::regalloc_detail::parseRegAllocTransformFailure(func);
    if (failed(failure))
      return op.emitDefiniteFailure()
             << "failed to read stalled regalloc state";
    if (!*failure)
      continue;
    const wave::regalloc_detail::RegAllocTransformFailure &record = **failure;
    DiagnosedDefiniteFailure diag = op.emitDefiniteFailure();
    diag << "regalloc stalled in @" << func.getSymName()
         << ": class=" << record.className << " reason=" << record.reason
         << " set=" << record.set << " position=" << record.position;
    if (record.pressure)
      diag << " pressure=" << *record.pressure;
    if (record.request)
      diag << " request=" << *record.request;
    if (record.limit)
      diag << " limit=" << *record.limit;
    return std::move(diag);
  }
  return op.emitDefiniteFailure()
         << "regalloc stalled without a linear-scan failure record";
}

static DiagnosedSilenceableFailure finishRegAllocLoopIteration(
    wave::TransformRegAllocLoopOp op, transform::TransformResults &results,
    ArrayRef<Operation *> yielded, Builder &builder,
    wave::RegAllocTransformLoopDecision decision, int64_t iterations) {
  if (decision == wave::RegAllocTransformLoopDecision::Stalled) {
    endRegAllocPreparationTracking(yielded);
    return emitRegAllocLoopStalledFailure(op, yielded);
  }
  assert(decision == wave::RegAllocTransformLoopDecision::Done &&
         "terminal regalloc decision must finish or stall");
  if (failed(finalizeRegAllocLoopMetadata(yielded, builder, iterations))) {
    endRegAllocPreparationTracking(yielded);
    return op.emitDefiniteFailure()
           << "failed to finalize regalloc transform metadata";
  }
  endRegAllocPreparationTracking(yielded);
  results.set(cast<OpResult>(op.getResult()), yielded);
  return DiagnosedSilenceableFailure::success();
}

static DiagnosedSilenceableFailure
runRegAllocLoopBody(wave::TransformRegAllocLoopOp op,
                    transform::TransformResults &results,
                    transform::TransformState &state) {
  wave::regalloc_detail::RegAllocTransformStateCache &cache =
      getRegAllocTransformStateCache(state);
  llvm::scope_exit clearCache([&] { cache.clear(); });
  transform::NamedSequenceOp body =
      SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          op.getOperation(), op.getBodyAttr());
  if (!body)
    return op.emitDefiniteFailure()
           << "body symbol `" << op.getBody()
           << "` does not resolve to a transform.named_sequence";

  SmallVector<Operation *> current;
  for (Operation *target : state.getPayloadOps(op.getTarget()))
    current.push_back(target);

  Builder builder(op.getContext());
  if (failed(clearRegAllocLoopMetadata(current, builder)))
    return op.emitDefiniteFailure()
           << "failed to clear regalloc transform metadata";
  beginRegAllocPreparationTracking(current);
  int64_t maxIterations = op.getMaxIterations();
  for (int64_t iteration = 0; iteration < maxIterations; ++iteration) {
    SmallVector<Operation *> yielded;
    DiagnosedSilenceableFailure status =
        runRegAllocLoopIteration(op, body, current, state, yielded);
    if (!status.succeeded())
      return status;
    if (failed(stampRegAllocLoopIteration(yielded, builder, iteration))) {
      endRegAllocPreparationTracking(yielded);
      return op.emitDefiniteFailure()
             << "failed to stamp regalloc loop iteration";
    }

    FailureOr<wave::RegAllocTransformLoopDecision> decision =
        classifyRegAllocLoopTargets(yielded);
    if (failed(decision)) {
      endRegAllocPreparationTracking(yielded);
      return op.emitDefiniteFailure()
             << "failed to read regalloc transform loop state";
    }

    if (*decision != wave::RegAllocTransformLoopDecision::Restart)
      return finishRegAllocLoopIteration(op, results, yielded, builder,
                                         *decision, iteration + 1);
    current = std::move(yielded);
  }
  endRegAllocPreparationTracking(current);
  return op.emitDefiniteFailure()
         << "regalloc transform loop exceeded max_iterations = "
         << maxIterations;
}

} // namespace

LogicalResult wave::TransformRegAllocLoopOp::verifySymbolUses(
    SymbolTableCollection &symbolTable) {
  transform::NamedSequenceOp body =
      symbolTable.lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          getOperation(), getBodyAttr());
  if (!body)
    return emitOpError() << "body symbol `" << getBody()
                         << "` does not resolve to a transform.named_sequence";
  if (getMaxIterations() <= 0)
    return emitOpError() << "requires positive max_iterations";
  return success();
}

DiagnosedSilenceableFailure
wave::TransformRegAllocLoopOp::apply(transform::TransformRewriter &rewriter,
                                     transform::TransformResults &results,
                                     transform::TransformState &state) {
  return runRegAllocLoopBody(*this, results, state);
}

void wave::TransformRegAllocLoopOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure wave::TransformRegAllocBuildAliasStateOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  TimingScope timing =
      getRegAllocStageTimingScope("regalloc_build_alias_state");
  wave::regalloc_detail::RegAllocTransformStateCache &cache =
      getRegAllocTransformStateCache(state);
  cache.clear();
  SmallVector<Operation *> targets;
  Builder builder(getContext());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    targets.push_back(target);
    if (failed(wave::buildRegAllocTransformAliasState(
            target, builder, getCoalesceMfmaAccResult(), &cache)))
      return emitDefiniteFailure() << "failed to build regalloc alias state";
  }
  results.set(cast<OpResult>(getResult()), targets);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformRegAllocBuildAliasStateOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure wave::TransformRegAllocLinearScanOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  TimingScope timing = getRegAllocStageTimingScope("regalloc_linear_scan");
  wave::regalloc_detail::RegAllocTransformStateCache &cache =
      getRegAllocTransformStateCache(state);
  SmallVector<Operation *> targets;
  Builder builder(getContext());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    targets.push_back(target);
    if (failed(wave::runRegAllocTransformLinearScan(target, builder, &cache)))
      return emitDefiniteFailure() << "failed to run regalloc linear scan";
  }
  results.set(cast<OpResult>(getResult()), targets);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformRegAllocLinearScanOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure wave::TransformRegAllocAGPRReliefOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  TimingScope timing = getRegAllocStageTimingScope("regalloc_agpr_relief");
  wave::regalloc_detail::RegAllocTransformStateCache &cache =
      getRegAllocTransformStateCache(state);
  SmallVector<Operation *> targets;
  Builder builder(getContext());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    targets.push_back(target);
    if (failed(wave::runRegAllocTransformAGPRRelief(target, builder, &cache)))
      return emitDefiniteFailure() << "failed to run regalloc AGPR relief";
  }
  results.set(cast<OpResult>(getResult()), targets);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformRegAllocAGPRReliefOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure wave::TransformRegAllocRematReliefOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  TimingScope timing = getRegAllocStageTimingScope("regalloc_remat_relief");
  wave::regalloc_detail::RegAllocTransformStateCache &cache =
      getRegAllocTransformStateCache(state);
  SmallVector<Operation *> targets;
  Builder builder(getContext());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    targets.push_back(target);
    if (failed(wave::runRegAllocTransformRematRelief(target, builder, &cache)))
      return emitDefiniteFailure() << "failed to run regalloc remat relief";
  }
  results.set(cast<OpResult>(getResult()), targets);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformRegAllocRematReliefOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure wave::TransformRegAllocSGPRToVGPRReliefOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  TimingScope timing =
      getRegAllocStageTimingScope("regalloc_sgpr_to_vgpr_relief");
  wave::regalloc_detail::RegAllocTransformStateCache &cache =
      getRegAllocTransformStateCache(state);
  SmallVector<Operation *> targets;
  Builder builder(getContext());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    targets.push_back(target);
    if (failed(wave::runRegAllocTransformSGPRToVGPRRelief(target, builder,
                                                          &cache)))
      return emitDefiniteFailure()
             << "failed to run regalloc SGPR to VGPR relief";
  }
  results.set(cast<OpResult>(getResult()), targets);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformRegAllocSGPRToVGPRReliefOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure wave::TransformRegAllocLDSReliefOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  TimingScope timing = getRegAllocStageTimingScope("regalloc_lds_relief");
  wave::regalloc_detail::RegAllocTransformStateCache &cache =
      getRegAllocTransformStateCache(state);
  SmallVector<Operation *> targets;
  Builder builder(getContext());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    targets.push_back(target);
    if (failed(wave::runRegAllocTransformLDSRelief(target, builder, &cache)))
      return emitDefiniteFailure() << "failed to run regalloc LDS relief";
  }
  results.set(cast<OpResult>(getResult()), targets);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformRegAllocLDSReliefOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure wave::TransformRegAllocScratchReliefOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  TimingScope timing = getRegAllocStageTimingScope("regalloc_scratch_relief");
  wave::regalloc_detail::RegAllocTransformStateCache &cache =
      getRegAllocTransformStateCache(state);
  SmallVector<Operation *> targets;
  Builder builder(getContext());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    targets.push_back(target);
    if (failed(
            wave::runRegAllocTransformScratchRelief(target, builder, &cache)))
      return emitDefiniteFailure() << "failed to run regalloc scratch relief";
  }
  results.set(cast<OpResult>(getResult()), targets);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformRegAllocScratchReliefOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.estimate_cycles + wave.transform.pressure_report
//===----------------------------------------------------------------------===//

namespace {

static std::optional<waveamdmachine::AMDGPUTarget>
readTargetFromEnclosingModule(Operation *op) {
  ModuleOp mod = waveamdmachine::findAMDGPUTargetModule(op);
  if (!mod)
    return std::nullopt;
  StringAttr attr = mod->getAttrOfType<StringAttr>("waveamdmachine.target");
  return waveamdmachine::parseAMDGPUTargetAttr(attr.getValue());
}

// Failure if enclosing target attr is missing, malformed, or unsupported.
static FailureOr<const waveamdmachine::ArchData *>
resolveArch(Operation *target) {
  std::optional<waveamdmachine::AMDGPUTarget> parsed =
      readTargetFromEnclosingModule(target);
  if (!parsed)
    return failure();
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(parsed->chip);
  if (!waveamdmachine::isArchSupported(isa))
    return failure();
  return &waveamdmachine::getArchData(isa);
}

static FailureOr<int64_t> sumFuncCycles(Operation *target,
                                        const waveamdmachine::ArchData &arch) {
  int64_t total = 0;
  auto runOne = [&](func::FuncOp f) -> LogicalResult {
    waveamdmachine::EventSimConfig config;
    waveamdmachine::EventSimResult result;
    if (failed(waveamdmachine::simulateEventTimeline(f, arch, config, result)))
      return failure();
    total += result.totalCycles;
    return success();
  };
  if (auto f = dyn_cast<func::FuncOp>(target))
    return failed(runOne(f)) ? FailureOr<int64_t>(failure())
                             : FailureOr<int64_t>(total);
  WalkResult walk = target->walk([&](func::FuncOp f) {
    return failed(runOne(f)) ? WalkResult::interrupt() : WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return total;
}

} // namespace

DiagnosedSilenceableFailure
wave::TransformEstimateCyclesOp::apply(transform::TransformRewriter &rewriter,
                                       transform::TransformResults &results,
                                       transform::TransformState &state) {
  Builder b(getContext());
  SmallVector<Attribute> values;
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto arch = resolveArch(target);
    if (failed(arch))
      return emitDefiniteFailure()
             << "target has no enclosing module with `waveamdmachine.target` "
                "or arch is unsupported";
    auto cycles = sumFuncCycles(target, **arch);
    if (failed(cycles))
      return emitDefiniteFailure() << "cycle estimate failed on target";
    values.push_back(b.getI64IntegerAttr(*cycles));
  }
  results.setParams(cast<OpResult>(getResult()), values);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformEstimateCyclesOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
}

namespace {

// Walk wave.amd.machine ops in `target` (a func or module);
// accumulate issue cycles per FU from classifier + funit. Pure
// static walk -- no dataflow needed.
static llvm::DenseMap<waveamdmachine::FunctionalUnit, int64_t>
computePerFuCycles(Operation *target, const waveamdmachine::ArchData &arch) {
  llvm::DenseMap<waveamdmachine::FunctionalUnit, int64_t> counts;
  target->walk([&](Operation *op) {
    if (op == target)
      return;
    if (!waveamdmachine::isWaveAMDMachineOp(op))
      return;
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    if (cls == waveamdmachine::SchedClass::NoInst)
      return;
    waveamdmachine::FunctionalUnit fu = waveamdmachine::funit(arch, cls);
    if (fu == waveamdmachine::FunctionalUnit::None)
      return;
    counts[fu] += 1;
  });
  return counts;
}

} // namespace

DiagnosedSilenceableFailure
wave::TransformPressureReportOp::apply(transform::TransformRewriter &rewriter,
                                       transform::TransformResults &results,
                                       transform::TransformState &state) {
  Builder b(getContext());
  StringAttr attrName = b.getStringAttr(getAttrName());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto arch = resolveArch(target);
    if (failed(arch))
      return emitDefiniteFailure()
             << "target has no enclosing module with `waveamdmachine.target` "
                "or arch is unsupported";
    auto counts = computePerFuCycles(target, **arch);
    SmallVector<NamedAttribute> entries;
    for (int i = 0; i < static_cast<int>(
                            waveamdmachine::FunctionalUnit::NumFunctionalUnits);
         ++i) {
      auto fu = static_cast<waveamdmachine::FunctionalUnit>(i);
      if (fu == waveamdmachine::FunctionalUnit::None)
        continue;
      auto it = counts.find(fu);
      if (it == counts.end())
        continue;
      entries.emplace_back(
          b.getStringAttr(waveamdmachine::getFunctionalUnitName(fu)),
          b.getI64IntegerAttr(it->second));
    }
    target->setAttr(attrName, b.getDictionaryAttr(entries));
  }
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformPressureReportOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::modifiesPayload(effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.pingpong_score
//===----------------------------------------------------------------------===//

namespace {

struct SimpleRegion {
  Operation *begin = nullptr;
  waveamdmachine::FunctionalUnit fu = waveamdmachine::FunctionalUnit::None;
  int64_t issueOps = 0;
};

struct SimplePingpongPick {
  int64_t delay = 0;
  int64_t peakPermille = 0;
};

static void maybeAppendRegion(SimpleRegion &current,
                              SmallVectorImpl<SimpleRegion> &regions) {
  if (current.begin && current.issueOps >= 16)
    regions.push_back(current);
  current = {};
}

static void collectSimpleRegions(Block &block,
                                 const waveamdmachine::ArchData &arch,
                                 SmallVectorImpl<SimpleRegion> &regions);

static void collectSimpleRegionOp(Operation &op,
                                  const waveamdmachine::ArchData &arch,
                                  SmallVectorImpl<SimpleRegion> &regions,
                                  SimpleRegion &current) {
  if (op.getNumRegions() != 0) {
    maybeAppendRegion(current, regions);
    for (Region &region : op.getRegions())
      for (Block &nested : region)
        collectSimpleRegions(nested, arch, regions);
    return;
  }
  if (!waveamdmachine::isWaveAMDMachineOp(&op))
    return;
  waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(&op);
  if (cls == waveamdmachine::SchedClass::NoInst)
    return;
  waveamdmachine::FunctionalUnit fu = waveamdmachine::funit(arch, cls);
  if (fu == waveamdmachine::FunctionalUnit::None)
    return;
  if (current.begin && current.fu != fu)
    maybeAppendRegion(current, regions);
  if (!current.begin) {
    current.begin = &op;
    current.fu = fu;
  }
  ++current.issueOps;
}

static void collectSimpleRegions(Block &block,
                                 const waveamdmachine::ArchData &arch,
                                 SmallVectorImpl<SimpleRegion> &regions) {
  SimpleRegion current;
  for (Operation &op : block)
    collectSimpleRegionOp(op, arch, regions, current);
  maybeAppendRegion(current, regions);
}

static SmallVector<SimpleRegion>
partitionSimpleRegions(func::FuncOp f, const waveamdmachine::ArchData &arch) {
  SmallVector<SimpleRegion> regions;
  for (Block &block : f.getBody())
    collectSimpleRegions(block, arch, regions);
  return regions;
}

static FailureOr<SimplePingpongPick>
scorePingpongFunc(func::FuncOp f, const waveamdmachine::ArchData &arch) {
  SmallVector<SimpleRegion> regions = partitionSimpleRegions(f, arch);
  SimplePingpongPick pick;
  if (regions.empty())
    return pick;

  int64_t total = 0;
  int64_t peak = 0;
  for (const SimpleRegion &region : regions) {
    total += region.issueOps;
    peak = std::max(peak, region.issueOps);
  }
  pick.delay = regions.front().issueOps;
  pick.peakPermille = total == 0 ? 0 : (peak * 1000) / total;
  return pick;
}

static FailureOr<SimplePingpongPick>
scorePingpongTarget(Operation *target, const waveamdmachine::ArchData &arch) {
  if (auto f = dyn_cast<func::FuncOp>(target))
    return scorePingpongFunc(f, arch);

  bool sawFunc = false;
  SimplePingpongPick best;
  WalkResult walk = target->walk([&](func::FuncOp f) {
    FailureOr<SimplePingpongPick> pick = scorePingpongFunc(f, arch);
    if (failed(pick))
      return WalkResult::interrupt();
    if (!sawFunc || pick->peakPermille > best.peakPermille)
      best = *pick;
    sawFunc = true;
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return best;
}

} // namespace

DiagnosedSilenceableFailure
wave::TransformPingpongScoreOp::apply(transform::TransformRewriter &rewriter,
                                      transform::TransformResults &results,
                                      transform::TransformState &state) {
  Builder b(getContext());
  SmallVector<Attribute> delays;
  SmallVector<Attribute> peaks;
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto arch = resolveArch(target);
    if (failed(arch))
      return emitDefiniteFailure()
             << "target has no enclosing module with `waveamdmachine.target` "
                "or arch is unsupported";
    FailureOr<SimplePingpongPick> pick = scorePingpongTarget(target, **arch);
    if (failed(pick))
      return emitDefiniteFailure() << "region partition failed";
    delays.push_back(b.getI64IntegerAttr(pick->delay));
    peaks.push_back(b.getI64IntegerAttr(pick->peakPermille));
  }
  results.setParams(cast<OpResult>(getDelay()), delays);
  results.setParams(cast<OpResult>(getPeak()), peaks);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformPingpongScoreOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.insert_pingpong_barriers
//===----------------------------------------------------------------------===//

namespace {

// Insert a wave-id-prio nudge at func entry and an s_barrier before
// every region boundary after the first. Empty-token barriers --
// ticket-wait insertion runs later and threads dependencies.
static LogicalResult insertBarriersInFunc(func::FuncOp f,
                                          const waveamdmachine::ArchData &arch,
                                          int64_t prio) {
  SmallVector<SimpleRegion> regions = partitionSimpleRegions(f, arch);
  OpBuilder b(f.getContext());
  Block &entry = f.getBody().front();
  b.setInsertionPointToStart(&entry);
  Value imm = waveamdmachine::ImmOp::create(
      b, f.getLoc(), waveamdmachine::ImmType::get(f.getContext()),
      static_cast<uint64_t>(prio));
  waveamdmachine::SSetprioOp::create(b, f.getLoc(), imm);
  for (size_t i = 1; i < regions.size(); ++i) {
    Operation *begin = regions[i].begin;
    if (!begin)
      continue;
    b.setInsertionPoint(begin);
    waveamdmachine::SBarrierOp::create(b, begin->getLoc(), TypeRange{},
                                       ValueRange{});
  }
  return success();
}

} // namespace

DiagnosedSilenceableFailure wave::TransformInsertPingpongBarriersOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  int64_t prio = getPrio();
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto arch = resolveArch(target);
    if (failed(arch))
      return emitDefiniteFailure()
             << "target has no enclosing module with `waveamdmachine.target` "
                "or arch is unsupported";
    auto runOne = [&](func::FuncOp f) {
      return insertBarriersInFunc(f, **arch, prio);
    };
    if (auto f = dyn_cast<func::FuncOp>(target)) {
      if (failed(runOne(f)))
        return emitDefiniteFailure() << "region partition failed";
    } else {
      WalkResult w = target->walk([&](func::FuncOp f) {
        return failed(runOne(f)) ? WalkResult::interrupt()
                                 : WalkResult::advance();
      });
      if (w.wasInterrupted())
        return emitDefiniteFailure() << "region partition failed";
    }
  }
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformInsertPingpongBarriersOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure
wave::TransformBindParamOp::apply(transform::TransformRewriter &rewriter,
                                  transform::TransformResults &results,
                                  transform::TransformState &state) {
  auto targets = state.getPayloadOps(getTarget());
  if (llvm::range_size(targets) != 1)
    return emitDefiniteFailure() << "expected exactly one target op, got "
                                 << llvm::range_size(targets);
  Operation *target = *targets.begin();
  auto mod = dyn_cast<ModuleOp>(target);
  if (!mod)
    return emitDefiniteFailure() << "target must be a `builtin.module` op";

  ArrayRef<Attribute> values = state.getParams(getValue());
  if (values.size() != 1)
    return emitDefiniteFailure()
           << "expected the value param to hold one attribute, got "
           << values.size();

  Builder builder(mod.getContext());
  Attribute valueAttr = values.front();
  if (TypeAttr resultTypeAttr = getResultTypeAttr()) {
    Type resultType = resultTypeAttr.getValue();
    if (!resultType.isIntOrIndex())
      return emitDefiniteFailure()
             << "`as` clause requires an integer or index type, got "
             << resultType;
    auto intAttr = dyn_cast<IntegerAttr>(valueAttr);
    if (!intAttr)
      return emitDefiniteFailure()
             << "`as` clause requires the value to be an IntegerAttr, got "
             << valueAttr;
    valueAttr = IntegerAttr::get(resultType, intAttr.getValue().getSExtValue());
  }
  StringAttr paramsName =
      builder.getStringAttr(wavemeta::WaveMetaDialect::getParamsAttrName());
  StringAttr keyAttr = builder.getStringAttr(getAttrName());
  SmallVector<NamedAttribute> entries;
  if (auto existing = mod->getAttrOfType<DictionaryAttr>(paramsName)) {
    for (NamedAttribute na : existing) {
      if (na.getName() != keyAttr)
        entries.push_back(na);
    }
  }
  entries.emplace_back(keyAttr, valueAttr);
  mod->setAttr(paramsName, builder.getDictionaryAttr(entries));
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformBindParamOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::onlyReadsHandle(getValueMutable(), effects);
  transform::modifiesPayload(effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.tune
//===----------------------------------------------------------------------===//

namespace {

// Enumerate one variable's domain into a flat `int64_t` list.
static FailureOr<SmallVector<int64_t>>
expandDomain(Attribute domainAttr, Operation *errOp, StringAttr name) {
  if (auto e = dyn_cast<wave::TuneEnumAttr>(domainAttr))
    return SmallVector<int64_t>(e.getValues().begin(), e.getValues().end());
  if (auto r = dyn_cast<wave::TuneRangeAttr>(domainAttr)) {
    SmallVector<int64_t> result;
    for (int64_t v = r.getLower(); v < r.getUpper(); v += r.getStep())
      result.push_back(v);
    return result;
  }
  if (auto p = dyn_cast<wave::TunePow2InAttr>(domainAttr)) {
    SmallVector<int64_t> result;
    uint64_t v = 1;
    while (v < static_cast<uint64_t>(p.getLower()))
      v <<= 1;
    for (; v <= static_cast<uint64_t>(p.getUpper()); v <<= 1)
      result.push_back(static_cast<int64_t>(v));
    return result;
  }
  return errOp->emitError("unrecognized tune-var domain for `")
         << name.getValue() << "`";
}

// Walk the Cartesian product of `domains` in lex order (first variable
// is the slow axis). `out` receives one i64 vector per config.
static void enumerateCartesian(ArrayRef<SmallVector<int64_t>> domains,
                               SmallVector<SmallVector<int64_t>> &out) {
  size_t n = domains.size();
  if (n == 0) {
    out.emplace_back();
    return;
  }
  size_t total = 1;
  for (const auto &d : domains)
    total *= d.size();
  out.reserve(total);
  for (size_t k = 0; k < total; ++k) {
    SmallVector<int64_t> config(n);
    size_t rem = k;
    for (size_t i = n; i > 0; --i) {
      size_t idx = rem % domains[i - 1].size();
      config[i - 1] = domains[i - 1][idx];
      rem /= domains[i - 1].size();
    }
    out.push_back(std::move(config));
  }
}

// Run a `transform.named_sequence` with explicit block-argument bindings.
// Mirrors `IncludeOp::apply` minus the failure-propagation knobs.
//   `bindings[i]` is the mapping for the i-th block argument of `callee`.
//   `out` receives one mapping per terminator operand.
static DiagnosedSilenceableFailure
runNamedSequence(transform::TransformOpInterface caller,
                 transform::NamedSequenceOp callee,
                 MutableArrayRef<SmallVector<transform::MappedValue>> bindings,
                 transform::TransformState &state,
                 SmallVectorImpl<SmallVector<transform::MappedValue>> &out) {
  if (callee.isExternal())
    return caller.emitDefiniteFailure()
           << "named sequence `" << callee.getSymName()
           << "` is external; cannot invoke";
  Block &block = callee.getBody().front();
  if (block.getNumArguments() != bindings.size())
    return caller.emitDefiniteFailure()
           << "named sequence `" << callee.getSymName() << "` expects "
           << block.getNumArguments() << " arguments, got " << bindings.size();
  auto scope = state.make_region_scope(callee.getBody());
  for (auto &&[arg, mapping] :
       llvm::zip_equal(block.getArguments(), bindings)) {
    if (failed(state.mapBlockArgument(arg, mapping)))
      return DiagnosedSilenceableFailure::definiteFailure();
  }
  for (Operation &op : block.without_terminator()) {
    DiagnosedSilenceableFailure res =
        state.applyTransform(cast<transform::TransformOpInterface>(op));
    if (!res.succeeded())
      return res;
  }
  // Materialise mappings for the terminator operands.
  Operation *yield = block.getTerminator();
  transform::detail::prepareValueMappings(out, yield->getOperands(), state);
  return DiagnosedSilenceableFailure::success();
}

// Expand every `$variables` entry's domain. Definite-failure on bad or
// empty domain. Outputs in declared key order.
static DiagnosedSilenceableFailure
tuneCollectDomains(transform::TransformOpInterface op, DictionaryAttr variables,
                   SmallVectorImpl<StringAttr> &names,
                   SmallVectorImpl<SmallVector<int64_t>> &domains) {
  for (NamedAttribute na : variables) {
    FailureOr<SmallVector<int64_t>> dom =
        expandDomain(na.getValue(), op.getOperation(), na.getName());
    if (failed(dom))
      return DiagnosedSilenceableFailure::definiteFailure();
    if (dom->empty())
      return op.emitDefiniteFailure()
             << "tune variable `" << na.getName().getValue()
             << "` has an empty domain after expansion";
    names.push_back(na.getName());
    domains.push_back(std::move(*dom));
  }
  return DiagnosedSilenceableFailure::success();
}

// Build the per-variable `!transform.param<i64>` bindings for one config.
static SmallVector<SmallVector<transform::MappedValue>>
buildParamBindings(Builder &builder, ArrayRef<int64_t> config) {
  SmallVector<SmallVector<transform::MappedValue>> bindings(config.size());
  for (size_t i = 0; i < config.size(); ++i)
    bindings[i].push_back(
        static_cast<Attribute>(builder.getI64IntegerAttr(config[i])));
  return bindings;
}

enum class TrialStatus { Definite, Skip, Ok };

struct TrialOutcome {
  TrialStatus status = TrialStatus::Skip;
  OwningOpRef<ModuleOp> clone;
  int64_t score = 0;
  DiagnosedSilenceableFailure diag = DiagnosedSilenceableFailure::success();
};

// Helper: pull the i64 out of a score-sequence yield. Returns the score
// on success, or `failure()` after setting `out.diag` to a definite
// failure on a malformed yield.
static FailureOr<int64_t>
extractScore(transform::TransformOpInterface caller,
             ArrayRef<SmallVector<transform::MappedValue>> scoreOut,
             TrialOutcome &out) {
  if (scoreOut.size() != 1 || scoreOut[0].size() != 1) {
    out.status = TrialStatus::Definite;
    out.diag = caller.emitDefiniteFailure()
               << "score sequence must yield a single !transform.param<i64> "
                  "with one associated value";
    return failure();
  }
  auto scoreAttr = dyn_cast<IntegerAttr>(cast<Attribute>(scoreOut[0][0]));
  if (!scoreAttr) {
    out.status = TrialStatus::Definite;
    out.diag = caller.emitDefiniteFailure()
               << "score sequence must yield an IntegerAttr-shaped param";
    return failure();
  }
  return scoreAttr.getInt();
}

// Invoke `callee` and translate the three failure modes into a
// `TrialStatus`. `Ok` here just means "no failure"; the caller still
// needs to check terminator output if any.
static TrialStatus
invokeOrClassify(transform::TransformOpInterface caller,
                 transform::NamedSequenceOp callee,
                 MutableArrayRef<SmallVector<transform::MappedValue>> bindings,
                 transform::TransformState &state,
                 SmallVectorImpl<SmallVector<transform::MappedValue>> &out,
                 TrialOutcome &outcome) {
  DiagnosedSilenceableFailure r =
      runNamedSequence(caller, callee, bindings, state, out);
  if (r.isDefiniteFailure()) {
    outcome.status = TrialStatus::Definite;
    outcome.diag = std::move(r);
    return TrialStatus::Definite;
  }
  if (!r.succeeded()) {
    (void)r.silence();
    return TrialStatus::Skip;
  }
  return TrialStatus::Ok;
}

// Evaluate one trial: assumes-check, clone, body, score. Constructs
// per-trial `TransformState` instances so the runtime stack and
// payload mappings are isolated from the outer interpreter -- this is
// what lets trials run on a thread pool. `Ok` carries the clone and
// its score; `Skip` is a silenceable prune; `Definite` is a
// propagating failure.
static TrialOutcome
runTrial(transform::TransformOpInterface caller, ModuleOp origModule,
         transform::NamedSequenceOp bodyCallee,
         transform::NamedSequenceOp scoreCallee,
         transform::NamedSequenceOp assumesCallee,
         MutableArrayRef<SmallVector<transform::MappedValue>> paramBindings) {
  TrialOutcome out;
  // Each sub-sequence runs against its own `TransformState`. The
  // public ctor is private; `makeTransformStateForTesting` is the only
  // public factory and the cross-thread isolation it gives is the
  // whole point of using it here, not just testing.
  if (assumesCallee) {
    transform::TransformState assumesState =
        transform::detail::makeTransformStateForTesting(
            /*region=*/nullptr, /*payloadRoot=*/origModule);
    SmallVector<SmallVector<transform::MappedValue>> dummy;
    TrialStatus st = invokeOrClassify(caller, assumesCallee, paramBindings,
                                      assumesState, dummy, out);
    if (st != TrialStatus::Ok)
      return out;
  }

  out.clone = cast<ModuleOp>(origModule->clone());

  SmallVector<SmallVector<transform::MappedValue>> bodyBindings;
  bodyBindings.reserve(1 + paramBindings.size());
  SmallVector<transform::MappedValue> targetMapping;
  targetMapping.push_back(static_cast<Operation *>(out.clone->getOperation()));
  bodyBindings.push_back(std::move(targetMapping));
  for (const SmallVector<transform::MappedValue> &m : paramBindings)
    bodyBindings.push_back(m);

  transform::TransformState bodyState =
      transform::detail::makeTransformStateForTesting(
          /*region=*/nullptr,
          /*payloadRoot=*/out.clone->getOperation());
  SmallVector<SmallVector<transform::MappedValue>> bodyOut;
  TrialStatus bst = invokeOrClassify(caller, bodyCallee, bodyBindings,
                                     bodyState, bodyOut, out);
  if (bst != TrialStatus::Ok)
    return out;

  transform::TransformState scoreState =
      transform::detail::makeTransformStateForTesting(
          /*region=*/nullptr,
          /*payloadRoot=*/out.clone->getOperation());
  SmallVector<SmallVector<transform::MappedValue>> scoreOut;
  TrialStatus sst = invokeOrClassify(caller, scoreCallee, bodyBindings,
                                     scoreState, scoreOut, out);
  if (sst != TrialStatus::Ok)
    return out;

  FailureOr<int64_t> sc = extractScore(caller, scoreOut, out);
  if (failed(sc))
    return out;
  out.score = *sc;
  out.status = TrialStatus::Ok;
  return out;
}

// Per-tune-op resolved callees.
struct TuneCallees {
  transform::NamedSequenceOp body;
  transform::NamedSequenceOp score;
  transform::NamedSequenceOp assumes; // May be null.
};

// Drive the enumeration: dispatch every trial in parallel via the
// context thread pool, then reduce sequentially in enumeration order
// for deterministic tie-breaking. Each trial runs on its own clone
// with its own `TransformState`, so the only shared state during the
// parallel phase is the unifying StorageUniquer and the source
// module's read-only IR. `bestClone`/`bestScore` are valid only when
// `anyFeasible` flips to true.
static DiagnosedSilenceableFailure
tuneRunAllTrials(transform::TransformOpInterface caller, ModuleOp orig,
                 const TuneCallees &callees,
                 ArrayRef<SmallVector<int64_t>> configs, Builder &builder,
                 OwningOpRef<ModuleOp> &bestClone, int64_t &bestScore,
                 bool &anyFeasible) {
  SmallVector<SmallVector<SmallVector<transform::MappedValue>>> allBindings;
  allBindings.reserve(configs.size());
  for (const SmallVector<int64_t> &config : configs)
    allBindings.push_back(buildParamBindings(builder, config));
  SmallVector<TrialOutcome> outcomes(configs.size());
  // MLIR wrapper buffers diagnostics per config and flushes in order.
  mlir::parallelFor(caller->getContext(), 0, configs.size(), [&](size_t i) {
    outcomes[i] = runTrial(caller, orig, callees.body, callees.score,
                           callees.assumes, allBindings[i]);
  });
  for (TrialOutcome &o : outcomes) {
    if (o.status == TrialStatus::Definite)
      return std::move(o.diag);
    if (o.status == TrialStatus::Skip)
      continue;
    if (!anyFeasible || o.score > bestScore) {
      bestClone = std::move(o.clone);
      bestScore = o.score;
    }
    anyFeasible = true;
  }
  return DiagnosedSilenceableFailure::success();
}

// Move the winner's non-transform contents into `orig`'s body and adopt
// its module-level attributes. Transform-dialect ops on both sides
// survive: orig still hosts the running interpreter.
static void installWinner(ModuleOp orig, ModuleOp winner) {
  Block &origBody = orig.getBodyRegion().front();
  Block &winBody = winner.getBodyRegion().front();
  auto isTransformOp = [](Operation &op) {
    Dialect *d = op.getDialect();
    return d && isa<transform::TransformDialect>(d);
  };
  for (Operation &op : llvm::make_early_inc_range(origBody)) {
    if (!isTransformOp(op))
      op.erase();
  }
  SmallVector<Operation *> toMove;
  for (Operation &op : winBody) {
    if (!isTransformOp(op))
      toMove.push_back(&op);
  }
  for (Operation *op : toMove)
    op->moveBefore(&origBody, origBody.end());
  // Clone's attrs >= orig's (clone started as a copy).
  orig->setAttrs(winner->getAttrs());
}

} // namespace

LogicalResult
wave::TransformTuneOp::verifySymbolUses(SymbolTableCollection &symbolTable) {
  auto checkExists = [&](SymbolRefAttr ref, StringRef role) -> LogicalResult {
    auto callee =
        symbolTable.lookupNearestSymbolFrom<transform::NamedSequenceOp>(
            getOperation(), ref);
    if (!callee)
      return emitOpError()
             << role << " symbol `" << ref
             << "` does not resolve to a transform.named_sequence";
    return success();
  };
  if (failed(checkExists(getBodyAttr(), "body")))
    return failure();
  if (failed(checkExists(getScoreAttr(), "score")))
    return failure();
  if (SymbolRefAttr assumes = getAssumesAttr())
    if (failed(checkExists(assumes, "assumes")))
      return failure();
  return success();
}

DiagnosedSilenceableFailure
wave::TransformTuneOp::apply(transform::TransformRewriter &rewriter,
                             transform::TransformResults &results,
                             transform::TransformState &state) {
  auto targets = state.getPayloadOps(getTarget());
  if (llvm::range_size(targets) != 1)
    return emitDefiniteFailure() << "expected exactly one target op, got "
                                 << llvm::range_size(targets);
  auto origModule = dyn_cast<ModuleOp>(*targets.begin());
  if (!origModule)
    return emitDefiniteFailure() << "target must be a `builtin.module` op";

  TuneCallees callees;
  callees.body =
      SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          getOperation(), getBodyAttr());
  callees.score =
      SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          getOperation(), getScoreAttr());
  if (SymbolRefAttr assumes = getAssumesAttr())
    callees.assumes =
        SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
            getOperation(), assumes);

  SmallVector<StringAttr> varNames;
  SmallVector<SmallVector<int64_t>> varDomains;
  if (DiagnosedSilenceableFailure r =
          tuneCollectDomains(*this, getVariables(), varNames, varDomains);
      !r.succeeded())
    return r;

  SmallVector<SmallVector<int64_t>> configs;
  enumerateCartesian(varDomains, configs);

  Builder builder(getContext());
  OwningOpRef<ModuleOp> bestClone;
  int64_t bestScore = std::numeric_limits<int64_t>::min();
  bool anyFeasible = false;
  if (DiagnosedSilenceableFailure r =
          tuneRunAllTrials(*this, origModule, callees, configs, builder,
                           bestClone, bestScore, anyFeasible);
      !r.succeeded())
    return r;
  if (!anyFeasible)
    return emitDefiniteFailure() << "no feasible tune trial";

  installWinner(origModule, *bestClone);
  results.set(cast<OpResult>(getWinner()), {origModule});
  results.setParams(cast<OpResult>(getBestScore()),
                    {builder.getI64IntegerAttr(bestScore)});
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformTuneOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}
