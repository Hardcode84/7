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

static const PointerOffsetBinding *lookupBinding(const AddressPlan &plan,
                                                 StringRef name) {
  for (const PointerOffsetBinding &binding : plan.bindings)
    if (StringRef(binding.name) == name)
      return &binding;
  return nullptr;
}

static SmallVector<StringRef, 4> collectSymbolNames(sym::ExprHandle expr) {
  SmallVector<StringRef, 4> names;
  sym::walkSymbolNames(expr, [&](StringRef name) {
    if (!llvm::is_contained(names, name))
      names.push_back(name);
  });
  return names;
}

static std::optional<SmallVector<int64_t, 4>>
collectImmediateValues(WaveAMDMachineSelector &S, const AddressPlan &plan,
                       ArrayRef<StringRef> names) {
  SmallVector<int64_t, 4> values;
  values.reserve(names.size());
  for (StringRef name : names) {
    const PointerOffsetBinding *binding = lookupBinding(plan, name);
    if (!binding)
      return std::nullopt;
    std::optional<int64_t> value = S.getImmediateValue(binding->value);
    if (!value)
      return std::nullopt;
    values.push_back(*value);
  }
  return values;
}

static std::optional<SmallVector<sym::ExprSubstitution, 4>>
buildConstantSubstitutions(sym::Analysis &analysis, ArrayRef<StringRef> names,
                           ArrayRef<int64_t> values) {
  SmallVector<sym::ExprSubstitution, 4> substitutions;
  substitutions.reserve(names.size());
  for (size_t index : llvm::seq<size_t>(names.size())) {
    FailureOr<sym::ExprHandle> target = analysis.composeSymbol(names[index]);
    FailureOr<sym::ExprHandle> replacement =
        analysis.composeInteger(values[index]);
    if (failed(target) || failed(replacement))
      return std::nullopt;
    substitutions.push_back({*target, *replacement});
  }
  return substitutions;
}

static std::optional<int64_t> evaluateConstantExpr(WaveAMDMachineSelector &S,
                                                   const AddressPlan &plan,
                                                   sym::ExprHandle expr) {
  SmallVector<StringRef, 4> names = collectSymbolNames(expr);
  std::optional<SmallVector<int64_t, 4>> values =
      collectImmediateValues(S, plan, names);
  if (!values)
    return std::nullopt;

  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(S.symbolStore(), plan.assumptions);
  if (failed(created))
    return std::nullopt;
  sym::Analysis &analysis = **created;
  std::optional<SmallVector<sym::ExprSubstitution, 4>> substitutions =
      buildConstantSubstitutions(analysis, names, *values);
  if (!substitutions)
    return std::nullopt;
  FailureOr<sym::ExprHandle> substituted =
      analysis.substitute(expr, *substitutions);
  if (failed(substituted) || failed(analysis.substituteFacts(*substitutions)))
    return std::nullopt;
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(*substituted);
  if (failed(simplified))
    return std::nullopt;
  return sym::getIntegerLiteralValue(*simplified);
}

static FailureOr<sym::ExprHandle>
appendInstOffsetExpr(WaveAMDMachineSelector &S, sym::ExprHandle voffset,
                     const AddressPlan &plan, bool includeInstOffset) {
  if (!includeInstOffset || plan.instOffset == 0)
    return voffset;
  FailureOr<sym::ExprHandle> instOffset =
      sym::composeExprInt(S.symbolStore(), plan.instOffset);
  if (failed(instOffset))
    return failure();
  return appendAddressExpr(S, voffset, *instOffset);
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
  FailureOr<sym::ExprHandle> proof = analysis.expand(materialization);
  if (succeeded(proof)) {
    FailureOr<sym::ExprHandle> simplified = analysis.simplify(*proof);
    if (succeeded(simplified))
      return *simplified;
    return *proof;
  }
  return analysis.simplify(materialization);
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

bool isBufferSelectedSourceOobPlan(WaveAMDMachineSelector &S,
                                   const AddressPlan &plan) {
  if (!hasOnlyVOffsetField(plan) || !plan.voffsetExpr)
    return false;
  std::optional<int64_t> value =
      evaluateConstantExpr(S, plan, plan.voffsetExpr);
  return value && *value == kBufferSelectedSourceOobOffset;
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
