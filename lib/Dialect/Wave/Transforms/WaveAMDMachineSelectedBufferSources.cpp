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

static sym::ExprHandle buildVOffsetProof(sym::Analysis &analysis,
                                         sym::ExprHandle materialization) {
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
  sym::ExprHandle proof = buildVOffsetProof(analysis, materialization);
  if (!S.slotFitsU32(analysis, proof))
    return success();
  plan.voffsetExpr = shouldUseSimplifiedIndexExpr(proof, materialization)
                         ? proof
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

static LogicalResult foldSelectedPlanIntoVOffset(WaveAMDMachineSelector &S,
                                                 AddressPlan &plan) {
  FailureOr<sym::ExprHandle> complete =
      composeFoldedVOffset(S, plan, /*includeInstOffset=*/true);
  if (failed(complete))
    return failure();
  if (!*complete) {
    clearFoldedAddressFields(plan, /*includeInstOffset=*/true);
    return success();
  }
  FailureOr<sym::ExprHandle> modulus =
      sym::composeExprInt(S.symbolStore(), int64_t{1} << 32);
  if (failed(modulus))
    return failure();
  FailureOr<sym::ExprHandle> wrapped = sym::composeExprBinary(
      S.symbolStore(), *complete, sym::ExprBinaryOp::Mod, *modulus);
  if (failed(wrapped))
    return failure();
  plan.voffsetExpr = *wrapped;
  plan.voffsetNeedsWide =
      needsWideAddressMaterialization(plan.voffsetExpr, plan);
  plan.soffsetExpr = {};
  plan.soffsetNeedsWide = false;
  plan.instOffset = 0;
  return success();
}

LogicalResult normalizeSelectedBufferPlans(WaveAMDMachineSelector &S,
                                           AddressPlan &active,
                                           AddressPlan &inactive) {
  return failure(failed(foldSelectedPlanIntoVOffset(S, active)) ||
                 failed(foldSelectedPlanIntoVOffset(S, inactive)));
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
