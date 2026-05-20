//===- WaveAMDHazardWaits.cpp - WaveAMD hazard waits ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Linear walk over a flattened pre-order of every waveamdmachine op in
// the function, including ops nested inside region-bearing ops such as
// `uniform_loop`. Cross-block control flow (branches, joins) is NOT
// analysed; the walk assumes each hazard producer and its consumer
// sit in the same straight-line region. Today's selector upholds this
// for every emitted op. The follow-up SSA-edge backward-query design
// (see docs/HazardMitigationDesign.md) crosses blocks correctly and
// supersedes this assumption.

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"
#include <functional>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDHAZARDWAITS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

//===----------------------------------------------------------------------===//
// Vendored AMDGPU hazard-delay encodings.
//
// Mirrors `llvm::AMDGPU::SNop` and `llvm::AMDGPU::SDelayAlu`, introduced
// upstream on the wave-dsl branch in commit 6490bb708b51 ("[mlir][wave]
// Share AMDGPU hazard delay encodings") but not yet merged into
// llvm/llvm-project main. When that commit lands, delete this block and
// replace `amdgpu_compat::` with `llvm::AMDGPU::` at the call sites below.
//===----------------------------------------------------------------------===//
namespace amdgpu_compat {
namespace SDelayAlu {

enum class DelayType { None, VALU, TRANS32, SALU };

inline unsigned encodeDelay(DelayType Type, unsigned Count) {
  switch (Type) {
  case DelayType::None:
    return 0;
  case DelayType::VALU:
    assert(Count < 5 && "VALU dependency id must fit s_delay_alu");
    return Count;
  case DelayType::TRANS32:
    assert(Count < 4 && "TRANS32 dependency id must fit s_delay_alu");
    return Count + 4;
  case DelayType::SALU:
    assert(Count < 4 && "SALU cycle id must fit s_delay_alu");
    return Count + 8;
  }
  llvm_unreachable("unknown s_delay_alu delay type");
}

inline unsigned encode(DelayType Type0, unsigned Count0, unsigned Skip = 0,
                       DelayType Type1 = DelayType::None, unsigned Count1 = 0) {
  unsigned Encoded = encodeDelay(Type0, Count0);
  unsigned Second = encodeDelay(Type1, Count1);
  if (!Second)
    return Encoded;
  assert(Skip < 8 && "skip count must fit s_delay_alu");
  return Encoded | (Skip << 4) | (Second << 7);
}

} // namespace SDelayAlu

namespace SNop {

inline unsigned getBitWidth(const llvm::MCSubtargetInfo &STI) {
  llvm::AMDGPU::IsaVersion Version = llvm::AMDGPU::getIsaVersion(STI.getCPU());
  if (Version.Major >= 12)
    return 7;
  if (Version.Major >= 8)
    return 4;
  return 3;
}

inline unsigned getMaxCount(const llvm::MCSubtargetInfo &STI) {
  return 1u << getBitWidth(STI);
}

inline unsigned encodeCount(unsigned Count) {
  assert(Count > 0 && "S_NOP count must be non-zero");
  return Count - 1;
}

} // namespace SNop
} // namespace amdgpu_compat

static Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
      static_cast<uint64_t>(value));
}

static void insertNoops(OpBuilder &builder, Location loc, unsigned count,
                        const llvm::MCSubtargetInfo &sti) {
  unsigned maxCount = amdgpu_compat::SNop::getMaxCount(sti);
  while (count > 0) {
    unsigned chunk = std::min(count, maxCount);
    count -= chunk;
    waveamdmachine::SNopOp::create(
        builder, loc,
        createImm(builder, loc, amdgpu_compat::SNop::encodeCount(chunk)));
  }
}

static FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
createSubtargetInfo(Operation *op) {
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    module = op->getParentOfType<ModuleOp>();
  if (!module)
    return op->emitError("waveamd-insert-hazard-waits requires a module");
  auto target = module->getAttrOfType<StringAttr>("waveamdmachine.target");
  if (!target)
    return module.emitError("waveamd-insert-hazard-waits requires a "
                            "waveamdmachine.target attribute");
  StringRef cpu = target.getValue();
  std::pair<StringRef, StringRef> split = cpu.rsplit("--");
  if (!split.second.empty())
    cpu = split.second;

  static llvm::once_flag initializeBackendOnce;
  llvm::call_once(initializeBackendOnce, []() {
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargetMCs();
  });

  llvm::Triple triple("amdgcn-amd-amdhsa");
  std::string error;
  const llvm::Target *llvmTarget =
      llvm::TargetRegistry::lookupTarget(triple, error);
  if (!llvmTarget)
    return op->emitError("failed to lookup AMDGPU target: ") << error;

  std::unique_ptr<llvm::MCSubtargetInfo> sti(
      llvmTarget->createMCSubtargetInfo(triple, cpu, /*Features=*/""));
  if (!sti)
    return module.emitError("unsupported AMDGPU target: ") << target.getValue();
  if (llvm::AMDGPU::getIsaVersion(cpu).Major == 0)
    return module.emitError("unsupported AMDGPU target: ") << target.getValue();
  return sti;
}

static std::optional<unsigned> getImmediate(Value value) {
  Operation *def = value.getDefiningOp();
  if (!def || !isa<waveamdmachine::ImmOp>(def))
    return std::nullopt;
  return static_cast<unsigned>(
      def->getAttrOfType<IntegerAttr>("value").getInt());
}

static bool consumesM0(Operation &op) {
  return llvm::any_of(op.getOperandTypes(), [](Type type) {
    return isa<waveamdmachine::M0Type>(type);
  });
}

static bool isVMEMStore(Operation &op) {
  return op.hasTrait<OpTrait::waveamdmachine::VMEMStoreOp>();
}

static bool emitsNoMachineInst(Operation &op) {
  return op.hasTrait<OpTrait::waveamdmachine::NoMachineInst>();
}

struct HazardConfig {
  bool hasDelayAlu;
  llvm::AMDGPU::IsaVersion isaVersion;
  unsigned defaultLgkmcnt;
  unsigned valuDep1;

  // Wait states between `s_mov_m0` and the next op reading `m0`.
  // One pipeline slot on every AMDGPU ISA that exposes M0; see
  // GCNHazardRecognizer.cpp's setreg / m0-write hazard checks.
  unsigned m0PipelineDelay;

  // Wait states between an MFMA result becoming readable and a
  // VMEM store consuming it. Conservative worst-case from
  // GCNHazardRecognizer.cpp's MFMA latency tables; per-variant
  // tightening (gfx950 has more granular cases) is left to a
  // future pass that knows the MFMA shape.
  unsigned mfmaResultLatency;
};

// Insert `count` `s_nop`s right before `op`.
static void insertSNopMitigation(Operation &op, unsigned count, OpBuilder &b,
                                 const llvm::MCSubtargetInfo &sti) {
  b.setInsertionPoint(&op);
  insertNoops(b, op.getLoc(), count, sti);
}

// Emit the VALU-after-LGKM mitigation right before `op`: `s_delay_alu`
// on gfx11+, plain `s_nop 0` otherwise.
static void insertValuMitigation(Operation &op, OpBuilder &b,
                                 const HazardConfig &cfg,
                                 const llvm::MCSubtargetInfo &sti) {
  b.setInsertionPoint(&op);
  if (cfg.hasDelayAlu) {
    waveamdmachine::SDelayAluOp::create(
        b, op.getLoc(), createImm(b, op.getLoc(), cfg.valuDep1));
    return;
  }
  insertNoops(b, op.getLoc(), /*count=*/1, sti);
}

// Decode `op` (an `s_waitcnt`) and return the new value of the LGKM
// pending flag, or `nullopt` if the immediate isn't statically known
// (the existing pending value should be kept).
static std::optional<bool> recomputePendingLgkm(Operation &op,
                                                const HazardConfig &cfg) {
  auto imm = getImmediate(op.getOperand(0));
  if (!imm)
    return std::nullopt;
  unsigned vm = 0, exp = 0, lg = 0;
  llvm::AMDGPU::decodeWaitcnt(cfg.isaVersion, *imm, vm, exp, lg);
  return cfg.hasDelayAlu ? lg != cfg.defaultLgkmcnt : true;
}

// Stage 1: every hazard runs through `LinearState` (pending-counter,
// decrement on counted ops, mitigate on consumer). Stage 2 will add
// `SsaEdge` (backward def-use query) -- the enum is here now so the
// catalog factory can mark each entry's future intent.
enum class HazardCategory { LinearState, SsaEdge };

using MitigateFn = std::function<unsigned(
    Operation &op, unsigned pending, OpBuilder &builder,
    const HazardConfig &cfg, const llvm::MCSubtargetInfo &sti)>;

using UpdateFn = std::function<unsigned(Operation &op, unsigned pending,
                                        const HazardConfig &cfg)>;

struct HazardKind {
  StringRef name;
  HazardCategory category;
  // Run at every op. Inserts mitigation if pending is non-zero and the
  // op consumes the hazard; returns updated pending.
  MitigateFn mitigate;
  // Run at every op, after mitigation. Producers raise pending;
  // counted ops decrement (counter kinds) or pass through (flag kinds).
  UpdateFn update;
  // True iff the loop-replay walk should be seeded with this kind's
  // final state. Today only VALU-after-LGKM persists; counter kinds
  // reset to 0 in the replay (matching pre-refactor semantics; see
  // bead hazard-loop-replay-double-emit-8qj for the Stage 2 fix).
  bool persistInReplay;
};

static HazardKind makeValuLgkmHazard() {
  return HazardKind{
      "valu-after-lgkm-wait",
      HazardCategory::LinearState,
      [](Operation &op, unsigned pending, OpBuilder &b, const HazardConfig &cfg,
         const llvm::MCSubtargetInfo &sti) -> unsigned {
        if (!pending || !op.hasTrait<OpTrait::waveamdmachine::VALUOp>())
          return pending;
        insertValuMitigation(op, b, cfg, sti);
        return 0;
      },
      [](Operation &op, unsigned pending, const HazardConfig &cfg) -> unsigned {
        if (!isa<waveamdmachine::SWaitcntOp>(op))
          return pending;
        std::optional<bool> next = recomputePendingLgkm(op, cfg);
        return next ? (*next ? 1u : 0u) : pending;
      },
      /*persistInReplay=*/true,
  };
}

static HazardKind makeM0Hazard() {
  return HazardKind{
      "m0-after-s-mov-m0",
      HazardCategory::LinearState,
      [](Operation &op, unsigned pending, OpBuilder &b, const HazardConfig &,
         const llvm::MCSubtargetInfo &sti) -> unsigned {
        if (!pending || !consumesM0(op))
          return pending;
        insertSNopMitigation(op, pending, b, sti);
        return 0;
      },
      [](Operation &op, unsigned pending, const HazardConfig &cfg) -> unsigned {
        if (isa<waveamdmachine::SMovM0Op>(op))
          return cfg.m0PipelineDelay;
        if (pending && !emitsNoMachineInst(op))
          return pending - 1;
        return pending;
      },
      /*persistInReplay=*/false,
  };
}

static HazardKind makeMfmaStoreHazard() {
  return HazardKind{
      "vmem-store-after-mfma",
      HazardCategory::LinearState,
      [](Operation &op, unsigned pending, OpBuilder &b, const HazardConfig &,
         const llvm::MCSubtargetInfo &sti) -> unsigned {
        if (!pending || !isVMEMStore(op))
          return pending;
        insertSNopMitigation(op, pending, b, sti);
        return 0;
      },
      [](Operation &op, unsigned pending, const HazardConfig &cfg) -> unsigned {
        if (op.hasTrait<OpTrait::waveamdmachine::MFMAOp>())
          return cfg.mfmaResultLatency;
        if (pending && !emitsNoMachineInst(op))
          return pending - 1;
        return pending;
      },
      /*persistInReplay=*/false,
  };
}

// Order matters only for mitigation insertion at a single op site
// (the inserted NOPs appear in catalog order between the cursor and
// `op`). Match the legacy order (M0, MFMA-store, VALU-LGKM) so any
// future CHECK that depends on instruction-pile ordering keeps
// matching.
static SmallVector<HazardKind> buildHazardCatalog(const HazardConfig &) {
  SmallVector<HazardKind> catalog;
  catalog.push_back(makeM0Hazard());
  catalog.push_back(makeMfmaStoreHazard());
  catalog.push_back(makeValuLgkmHazard());
  return catalog;
}

struct WaveAMDHazardWaitsPass
    : public wave::impl::WaveAMDHazardWaitsBase<WaveAMDHazardWaitsPass> {
  void runOnOperation() override {
    ModuleOp module = getOperation();
    OpBuilder builder(module.getContext());
    FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
        createSubtargetInfo(module);
    if (failed(sti))
      return signalPassFailure();
    HazardConfig cfg{
        llvm::AMDGPU::isGFX11Plus(**sti),
        llvm::AMDGPU::getIsaVersion((*sti)->getCPU()),
        /*defaultLgkmcnt=*/0,
        amdgpu_compat::SDelayAlu::encode(
            amdgpu_compat::SDelayAlu::DelayType::VALU, 1),
        /*m0PipelineDelay=*/1,
        /*mfmaResultLatency=*/8,
    };
    cfg.defaultLgkmcnt = llvm::AMDGPU::decodeLgkmcnt(
        cfg.isaVersion, llvm::AMDGPU::getWaitcntBitMask(cfg.isaVersion));
    for (func::FuncOp func : module.getOps<func::FuncOp>())
      if (failed(processFunction(func, builder, cfg, **sti)))
        return signalPassFailure();
  }

private:
  // True for ops that must not appear in `wave.kernel` funcs at this stage
  // (ABI lowering should have replaced them).
  static bool isUnloweredKernelArg(Operation &op, func::FuncOp func) {
    return func->hasAttr("wave.kernel") && isa<waveamdmachine::ArgOp>(op);
  }
  // True for scalar memory loads missing the required `base` attribute.
  static bool isMalformedSMEMLoad(Operation &op) {
    return isa<waveamdmachine::SLoadB32Op, waveamdmachine::SLoadB64Op,
               waveamdmachine::SLoadB128Op>(op) &&
           !op.getAttrOfType<StringAttr>("base");
  }

  // Pre-order walk over every waveamdmachine op in `func`, including
  // ops nested inside structured regions. Diagnoses malformed input.
  LogicalResult collectOps(func::FuncOp func,
                           SmallVectorImpl<Operation *> &ops) {
    func.walk<WalkOrder::PreOrder>([&](Operation *op) {
      if (op->getName().getDialectNamespace() ==
          waveamdmachine::WaveAMDMachineDialect::getDialectNamespace())
        ops.push_back(op);
    });
    for (Operation *op : ops) {
      if (isUnloweredKernelArg(*op, func))
        return op->emitError(
            "waveamd-insert-hazard-waits expects ABI-lowered kernel arguments");
      if (isMalformedSMEMLoad(*op))
        return op->emitError(
            "waveamd-insert-hazard-waits expects scalar memory loads to "
            "carry a base register attribute");
    }
    return success();
  }

  // Drive each catalog entry over `ops`. Returns the per-kind pending
  // state after the last op; the caller uses it to decide whether a
  // loop-replay walk is required.
  static SmallVector<unsigned>
  processOnce(ArrayRef<HazardKind> catalog, ArrayRef<Operation *> ops,
              ArrayRef<unsigned> initial, OpBuilder &builder,
              const HazardConfig &cfg, const llvm::MCSubtargetInfo &sti) {
    SmallVector<unsigned> state(initial.begin(), initial.end());
    for (Operation *op : ops) {
      for (size_t i = 0, e = catalog.size(); i < e; ++i)
        state[i] = catalog[i].mitigate(*op, state[i], builder, cfg, sti);
      for (size_t i = 0, e = catalog.size(); i < e; ++i)
        state[i] = catalog[i].update(*op, state[i], cfg);
    }
    return state;
  }

  LogicalResult processFunction(func::FuncOp func, OpBuilder &builder,
                                const HazardConfig &cfg,
                                const llvm::MCSubtargetInfo &sti) {
    SmallVector<Operation *> ops;
    if (failed(collectOps(func, ops)))
      return failure();

    SmallVector<HazardKind> catalog = buildHazardCatalog(cfg);
    SmallVector<unsigned> zero(catalog.size(), 0);

    SmallVector<unsigned> finalState =
        processOnce(catalog, ops, zero, builder, cfg, sti);

    // Loop replay: a back-edge can carry a kind's pending state from
    // the body's tail back to the top, so kinds flagged
    // `persistInReplay` get a second walk seeded with their final
    // state. Non-persistent kinds reset to 0 in the replay, matching
    // pre-refactor semantics (bead hazard-loop-replay-double-emit-8qj
    // tracks the resulting M0 / MFMA-store double-emit on Stage 2).
    if (!containsLoop(func))
      return success();
    SmallVector<unsigned> replaySeed(catalog.size(), 0);
    bool anyPersisted = false;
    for (size_t i = 0, e = catalog.size(); i < e; ++i) {
      if (catalog[i].persistInReplay && finalState[i]) {
        replaySeed[i] = finalState[i];
        anyPersisted = true;
      }
    }
    if (anyPersisted)
      processOnce(catalog, ops, replaySeed, builder, cfg, sti);
    return success();
  }

  static bool containsLoop(func::FuncOp func) {
    bool found = false;
    func.walk([&](waveamdmachine::UniformLoopOp) {
      found = true;
      return WalkResult::interrupt();
    });
    return found;
  }
};

} // namespace
