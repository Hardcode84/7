//===- WaveAMDHazardWaits.cpp - WaveAMD hazard waits ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"
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

static wavemachine::ImmType getImmType(MLIRContext *ctx) {
  return wavemachine::ImmType::get(ctx);
}

static Operation *createWMOp(OpBuilder &builder, Location loc, StringRef name,
                             ValueRange operands, TypeRange resultTypes,
                             ArrayRef<NamedAttribute> attrs = {}) {
  OperationState state(loc, ("wavemachine." + name).str());
  state.addOperands(operands);
  state.addTypes(resultTypes);
  state.addAttributes(attrs);
  return builder.create(state);
}

static Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  Operation *op = createWMOp(
      builder, loc, "imm", {}, getImmType(builder.getContext()),
      {builder.getNamedAttr("value", builder.getI64IntegerAttr(value))});
  return op->getResult(0);
}

static Operation *createInstrNoResult(OpBuilder &builder, Location loc,
                                      StringRef name, ValueRange operands) {
  return createWMOp(builder, loc, name, operands, TypeRange{});
}

static void insertNoops(OpBuilder &builder, Location loc, unsigned count,
                        const llvm::MCSubtargetInfo &sti) {
  unsigned maxCount = amdgpu_compat::SNop::getMaxCount(sti);
  while (count > 0) {
    unsigned chunk = std::min(count, maxCount);
    count -= chunk;
    createInstrNoResult(
        builder, loc, "s_nop",
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
  auto target = module->getAttrOfType<StringAttr>("wavemachine.target");
  if (!target)
    return module.emitError("waveamd-insert-hazard-waits requires a "
                            "wavemachine.target attribute");
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
  if (!def || !isa<wavemachine::ImmOp>(def))
    return std::nullopt;
  return static_cast<unsigned>(
      def->getAttrOfType<IntegerAttr>("value").getInt());
}

struct HazardConfig {
  bool hasDelayAlu;
  llvm::AMDGPU::IsaVersion isaVersion;
  unsigned defaultLgkmcnt;
  unsigned valuDep1;
};

struct WaveAMDHazardWaitsPass
    : public wave::impl::WaveAMDHazardWaitsBase<WaveAMDHazardWaitsPass> {
  void runOnOperation() override {
    ModuleOp module = getOperation();
    OpBuilder builder(module.getContext());
    FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
        createSubtargetInfo(module);
    if (failed(sti))
      return signalPassFailure();
    HazardConfig cfg{llvm::AMDGPU::isGFX11Plus(**sti),
                     llvm::AMDGPU::getIsaVersion((*sti)->getCPU()), 0,
                     amdgpu_compat::SDelayAlu::encode(
                         amdgpu_compat::SDelayAlu::DelayType::VALU, 1)};
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
    return func->hasAttr("wave.kernel") && isa<wavemachine::ArgOp>(op);
  }
  // True for scalar memory loads missing the required `base` attribute.
  static bool isMalformedSMEMLoad(Operation &op) {
    return isa<wavemachine::SLoadB32Op, wavemachine::SLoadB64Op,
               wavemachine::SLoadB128Op>(op) &&
           !op.getAttrOfType<StringAttr>("base");
  }

  // Emit the VALU-after-SMEM mitigation right before `op`.
  void insertValuMitigation(Operation &op, OpBuilder &builder,
                            const HazardConfig &cfg,
                            const llvm::MCSubtargetInfo &sti) {
    builder.setInsertionPoint(&op);
    if (cfg.hasDelayAlu) {
      createInstrNoResult(builder, op.getLoc(), "s_delay_alu",
                          createImm(builder, op.getLoc(), cfg.valuDep1));
    } else {
      insertNoops(builder, op.getLoc(), /*count=*/1, sti);
    }
  }

  // Decide whether `op` (a `s_waitcnt`) cleared the LGKM counter; returns
  // the new `pendingLgkmWait` state, or `std::nullopt` to leave it
  // unchanged (immediate not statically known).
  std::optional<bool> recomputePendingLgkm(Operation &op,
                                           const HazardConfig &cfg) {
    auto imm = getImmediate(op.getOperand(0));
    if (!imm)
      return std::nullopt;
    unsigned vm = 0, exp = 0, lg = 0;
    llvm::AMDGPU::decodeWaitcnt(cfg.isaVersion, *imm, vm, exp, lg);
    return cfg.hasDelayAlu ? lg != cfg.defaultLgkmcnt : true;
  }

  // Walk every wavemachine op in the function in program order, including
  // ops nested inside structured regions such as `wavemachine.uniform_loop`.
  // Returns failure (via diagnostic emission) if a malformed op is found.
  LogicalResult collectOps(func::FuncOp func,
                           SmallVectorImpl<Operation *> &ops) {
    func.walk<WalkOrder::PreOrder>([&](Operation *op) {
      if (op->getName().getDialectNamespace() ==
          wavemachine::WaveMachineDialect::getDialectNamespace())
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

  // Linear scan that inserts VALU-after-LGKM mitigations. Returns the
  // value of `pendingLgkmWait` after the last op, which the caller may
  // use to decide whether a back-edge replay is required.
  bool processOnce(ArrayRef<Operation *> ops, bool startState,
                   OpBuilder &builder, const HazardConfig &cfg,
                   const llvm::MCSubtargetInfo &sti) {
    bool pendingLgkmWait = startState;
    for (Operation *op : ops) {
      if (op->hasTrait<OpTrait::wavemachine::VALUOp>() && pendingLgkmWait) {
        insertValuMitigation(*op, builder, cfg, sti);
        pendingLgkmWait = false;
      }
      if (isa<wavemachine::SWaitcntOp>(op))
        if (auto newState = recomputePendingLgkm(*op, cfg))
          pendingLgkmWait = *newState;
    }
    return pendingLgkmWait;
  }

  LogicalResult processFunction(func::FuncOp func, OpBuilder &builder,
                                const HazardConfig &cfg,
                                const llvm::MCSubtargetInfo &sti) {
    SmallVector<Operation *> ops;
    if (failed(collectOps(func, ops)))
      return failure();

    // Walk once with pendingLgkmWait=false (the linear fall-through
    // state at function entry). If the walk leaves pendingLgkmWait=true
    // and the function contains a uniform loop, re-walk with
    // pendingLgkmWait=true so that a VALU at the *top* of a loop body
    // picks up a leftover wait produced by the body's tail in the prior
    // iteration. The replay is bounded to one extra pass because
    // `insertValuMitigation` resets the flag inside the body.
    bool finalState = processOnce(ops, /*startState=*/false, builder, cfg, sti);
    if (finalState && containsLoop(func))
      processOnce(ops, /*startState=*/true, builder, cfg, sti);
    return success();
  }

  static bool containsLoop(func::FuncOp func) {
    bool found = false;
    func.walk([&](wavemachine::UniformLoopOp) {
      found = true;
      return WalkResult::interrupt();
    });
    return found;
  }
};

} // namespace
