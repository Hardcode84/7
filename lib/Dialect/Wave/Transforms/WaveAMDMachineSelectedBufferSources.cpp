//===- WaveAMDMachineSelectedBufferSources.cpp ---------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineSelector.h"

#include "llvm/ADT/StringRef.h"

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

static FailureOr<sym::ExprHandle> appendAddressExpr(WaveAMDMachineSelector &S,
                                                    sym::ExprHandle lhs,
                                                    sym::ExprHandle rhs) {
  if (!lhs)
    return rhs;
  if (!rhs)
    return lhs;
  return sym::composeExprBinary(S.symbolStore(), lhs, sym::ExprBinaryOp::Add,
                                rhs);
}

static FailureOr<BufferSelectedSourcePointer>
lookupBufferSelectedSourcePointer(WaveAMDMachineSelector &S, Operation *user,
                                  Value source, StringRef label) {
  auto baseIt = S.pointerBases.find(source);
  auto offsetIt = S.pointerIndexOffsets.find(source);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return user->emitError(label)
           << " selected buffer source has no pointer metadata";
  return BufferSelectedSourcePointer{offsetIt->second, baseIt->second,
                                     S.pointerBuffers.lookup(source)};
}

static FailureOr<sym::ExprHandle>
appendInstOffsetExpr(WaveAMDMachineSelector &S, sym::ExprHandle voffset,
                     const AddressPlan &plan, bool includeInstOffset) {
  if (!includeInstOffset || plan.instOffset == 0)
    return voffset;
  sym::ExprHandle instOffset =
      sym::composeExprInt(S.symbolStore(), plan.instOffset);
  return appendAddressExpr(S, voffset, instOffset);
}

static FailureOr<sym::ExprHandle>
composeFoldedVOffset(WaveAMDMachineSelector &S, const AddressPlan &plan,
                     bool includeInstOffset) {
  FailureOr<sym::ExprHandle> voffset =
      appendAddressExpr(S, plan.voffsetExpr, plan.soffsetExpr);
  if (failed(voffset))
    return failure();
  voffset = appendAddressExpr(S, *voffset, plan.fullAddressRemainderExpr);
  if (failed(voffset))
    return failure();
  return appendInstOffsetExpr(S, *voffset, plan, includeInstOffset);
}

static FailureOr<sym::ExprHandle>
buildVOffsetProof(sym::Analysis &analysis, sym::ExprHandle materialization) {
  sym::ExprHandle proof = analysis.expand(materialization);
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(proof);
  return succeeded(simplified) ? *simplified : proof;
}

static void clearFoldedAddressFields(AddressPlan &plan,
                                     bool includeInstOffset) {
  if (includeInstOffset)
    plan.instOffset = 0;
  plan.soffsetExpr = {};
  plan.soffsetNeedsWide = false;
  plan.fullAddressRemainderExpr = {};
}

static bool hasSelectedPtrAddArms(SelectOp select) {
  return select.getTrueValue().getDefiningOp<PtrAddOp>() &&
         select.getFalseValue().getDefiningOp<PtrAddOp>();
}

static bool hasMatchingBufferSources(const SelectedBufferSources &sources) {
  return sources.active.isBuffer && sources.inactive.isBuffer &&
         sources.active.base == sources.inactive.base;
}

} // namespace

LogicalResult foldBufferAddressFieldsIntoVOffset(WaveAMDMachineSelector &S,
                                                 AddressPlan &plan,
                                                 bool includeInstOffset) {
  FailureOr<sym::ExprHandle> voffset =
      composeFoldedVOffset(S, plan, includeInstOffset);
  if (failed(voffset))
    return failure();
  if (!*voffset) {
    clearFoldedAddressFields(plan, includeInstOffset);
    return success();
  }
  sym::ExprHandle materialization = *voffset;
  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(S.symbolStore(), plan.assumptions);
  if (failed(created))
    return success();
  sym::Analysis &analysis = **created;
  FailureOr<sym::ExprHandle> proof =
      buildVOffsetProof(analysis, materialization);
  sym::ExprHandle proofExpr = succeeded(proof) ? *proof : materialization;
  if (!S.slotFitsU32(analysis, proofExpr))
    return success();
  plan.voffsetExpr =
      succeeded(proof) && shouldUseSimplifiedIndexExpr(*proof, materialization)
          ? *proof
          : materialization;
  plan.voffsetNeedsWide =
      needsWideAddressMaterialization(plan.voffsetExpr, plan);
  clearFoldedAddressFields(plan, includeInstOffset);
  return success();
}

FailureOr<std::optional<SelectedBufferSources>>
matchSelectedBufferSources(WaveAMDMachineSelector &S, Operation *user,
                           Value ptr, bool requirePtrAdd) {
  SelectOp select = ptr.getDefiningOp<SelectOp>();
  if (!select || !isa<MaskType>(select.getCondition().getType()))
    return std::optional<SelectedBufferSources>{};
  if (requirePtrAdd && !hasSelectedPtrAddArms(select))
    return std::optional<SelectedBufferSources>{};

  FailureOr<BufferSelectedSourcePointer> active =
      lookupBufferSelectedSourcePointer(S, user, select.getTrueValue(),
                                        "active");
  FailureOr<BufferSelectedSourcePointer> inactive =
      lookupBufferSelectedSourcePointer(S, user, select.getFalseValue(),
                                        "inactive");
  if (failed(active) || failed(inactive))
    return failure();
  SelectedBufferSources sources{*active, *inactive, select};
  if (!hasMatchingBufferSources(sources))
    return std::optional<SelectedBufferSources>{};
  return std::optional<SelectedBufferSources>{sources};
}

bool hasOnlyVOffsetField(const AddressPlan &plan) {
  return !plan.soffsetExpr && !plan.fullAddressRemainderExpr &&
         plan.instOffset == 0;
}

LogicalResult rebaseSelectedBufferPlan(WaveAMDMachineSelector &S,
                                       const AddressPlan &active,
                                       AddressPlan &inactive) {
  if (!active.soffsetExpr && active.instOffset == 0 && !inactive.soffsetExpr &&
      inactive.instOffset == 0)
    return success();

  for (const PointerOffsetBinding &binding : active.bindings) {
    auto existing = llvm::find_if(inactive.bindings,
                                  [&](const PointerOffsetBinding &candidate) {
                                    return candidate.name == binding.name;
                                  });
    if (existing != inactive.bindings.end()) {
      if (existing->value != binding.value || existing->kind != binding.kind)
        return failure();
      continue;
    }
    inactive.bindings.push_back(binding);
  }
  for (sym::PredHandle assumption : active.assumptions)
    if (!llvm::is_contained(inactive.assumptions, assumption))
      inactive.assumptions.push_back(assumption);

  sym::ExprHandle rebased = inactive.voffsetExpr;
  if (!rebased) {
    FailureOr<sym::ExprHandle> zero = sym::composeExprInt(S.symbolStore(), 0);
    if (failed(zero))
      return failure();
    rebased = *zero;
  }
  if (inactive.soffsetExpr) {
    FailureOr<sym::ExprHandle> sum = sym::composeExprBinary(
        S.symbolStore(), rebased, sym::ExprBinaryOp::Add, inactive.soffsetExpr);
    if (failed(sum))
      return failure();
    rebased = *sum;
  }
  if (inactive.instOffset != 0) {
    FailureOr<sym::ExprHandle> inst =
        sym::composeExprInt(S.symbolStore(), inactive.instOffset);
    if (failed(inst))
      return failure();
    FailureOr<sym::ExprHandle> sum = sym::composeExprBinary(
        S.symbolStore(), rebased, sym::ExprBinaryOp::Add, *inst);
    if (failed(sum))
      return failure();
    rebased = *sum;
  }
  if (active.soffsetExpr) {
    FailureOr<sym::ExprHandle> difference = sym::composeExprBinary(
        S.symbolStore(), rebased, sym::ExprBinaryOp::Sub, active.soffsetExpr);
    if (failed(difference))
      return failure();
    rebased = *difference;
  }
  if (active.instOffset != 0) {
    FailureOr<sym::ExprHandle> inst =
        sym::composeExprInt(S.symbolStore(), active.instOffset);
    if (failed(inst))
      return failure();
    FailureOr<sym::ExprHandle> difference = sym::composeExprBinary(
        S.symbolStore(), rebased, sym::ExprBinaryOp::Sub, *inst);
    if (failed(difference))
      return failure();
    rebased = *difference;
  }
  FailureOr<sym::ExprHandle> modulus =
      sym::composeExprInt(S.symbolStore(), int64_t{1} << 32);
  if (failed(modulus))
    return failure();
  FailureOr<sym::ExprHandle> wrapped = sym::composeExprBinary(
      S.symbolStore(), rebased, sym::ExprBinaryOp::Mod, *modulus);
  if (failed(wrapped))
    return failure();
  inactive.voffsetExpr = *wrapped;
  inactive.voffsetNeedsWide =
      needsWideAddressMaterialization(inactive.voffsetExpr, inactive);
  inactive.soffsetExpr = {};
  inactive.soffsetNeedsWide = false;
  inactive.instOffset = 0;
  return success();
}

std::optional<Value> lookupSelectedPointerVOffset(WaveAMDMachineSelector &S,
                                                  Value ptr) {
  auto offsetIt = S.pointerIndexOffsets.find(ptr);
  if (offsetIt == S.pointerIndexOffsets.end())
    return std::nullopt;
  const PointerOffset &offset = offsetIt->second;
  if (!offset.expr || offset.bindings.size() != 1)
    return std::nullopt;
  const PointerOffsetBinding &binding = offset.bindings.front();
  sym::ExprView view(offset.expr);
  if (view.getKind() != sym::ExprKind::Symbol ||
      view.getSymbolName() != binding.name)
    return std::nullopt;
  waveamdmachine::RegType type =
      dyn_cast<waveamdmachine::RegType>(binding.value.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
      type.getWidth() != 1)
    return std::nullopt;
  return binding.value;
}

} // namespace mlir::wave::wmsel
