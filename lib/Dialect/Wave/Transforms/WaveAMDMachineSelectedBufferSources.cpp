//===- WaveAMDMachineSelectedBufferSources.cpp ---------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineSelector.h"

#include "llvm/ADT/StringRef.h"
#include "llvm/Support/CheckedArithmetic.h"

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

static FailureOr<sym::ExprHandle>
appendAddressExpr(WaveAMDMachineSelector &S, sym::ExprHandle lhs,
                  sym::ExprHandle rhs, ArrayRef<sym::PredHandle> assumptions) {
  if (!lhs)
    return rhs;
  if (!rhs)
    return lhs;
  FailureOr<sym::ExprHandle> expr =
      sym::composeExprBinary(S.symbolStore(), lhs, sym::ExprBinaryOp::Add, rhs);
  if (failed(expr))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(S.symbolStore(), *expr, assumptions);
  return succeeded(simplified) ? *simplified : *expr;
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

static std::optional<int64_t> lookupConstantBinding(WaveAMDMachineSelector &S,
                                                    const AddressPlan &plan,
                                                    StringRef name) {
  for (const PointerOffsetBinding &binding : plan.bindings)
    if (StringRef(binding.name) == name)
      return S.getImmediateValue(binding.value);
  return std::nullopt;
}

static std::optional<int64_t> evaluateConstantExpr(WaveAMDMachineSelector &S,
                                                   const AddressPlan &plan,
                                                   sym::ExprHandle expr);

static std::optional<int64_t> evaluateConstantProduct(WaveAMDMachineSelector &S,
                                                      const AddressPlan &plan,
                                                      sym::ExprView view) {
  std::optional<int64_t> product =
      sym::getIntegerLiteralValue(view.getMulCoefficient()).value_or(1);
  for (uint32_t i = 0, e = view.getMulFactorCount(); i != e; ++i) {
    sym::MulFactor factor = view.getMulFactor(i);
    std::optional<int64_t> base = evaluateConstantExpr(S, plan, factor.base);
    if (!base || factor.exponent < 0)
      return std::nullopt;
    int64_t power = 1;
    for (int32_t exp = 0; exp != factor.exponent; ++exp) {
      std::optional<int64_t> next = llvm::checkedMul(power, *base);
      if (!next)
        return std::nullopt;
      power = *next;
    }
    product = llvm::checkedMul(*product, power);
    if (!product)
      return std::nullopt;
  }
  return product;
}

static std::optional<int64_t> evaluateConstantSum(WaveAMDMachineSelector &S,
                                                  const AddressPlan &plan,
                                                  sym::ExprView view) {
  std::optional<int64_t> sum =
      sym::getIntegerLiteralValue(view.getAddConstant()).value_or(0);
  for (uint32_t i = 0, e = view.getAddTermCount(); i != e; ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    std::optional<int64_t> value = evaluateConstantExpr(S, plan, term.term);
    std::optional<int64_t> coeff =
        sym::getIntegerLiteralValue(term.coefficient).value_or(1);
    if (!value)
      return std::nullopt;
    std::optional<int64_t> scaled = llvm::checkedMul(*coeff, *value);
    if (!scaled)
      return std::nullopt;
    sum = llvm::checkedAdd(*sum, *scaled);
    if (!sum)
      return std::nullopt;
  }
  return sum;
}

static std::optional<int64_t> evaluateConstantExpr(WaveAMDMachineSelector &S,
                                                   const AddressPlan &plan,
                                                   sym::ExprHandle expr) {
  if (std::optional<int64_t> value = sym::getIntegerLiteralValue(expr))
    return value;
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Symbol:
    return lookupConstantBinding(S, plan, view.getSymbolName());
  case sym::ExprKind::Add:
    return evaluateConstantSum(S, plan, view);
  case sym::ExprKind::Mul:
    return evaluateConstantProduct(S, plan, view);
  default:
    return std::nullopt;
  }
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
  return appendAddressExpr(S, voffset, *instOffset, plan.assumptions);
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
  FailureOr<sym::ExprHandle> voffset = appendAddressExpr(
      S, plan.voffsetExpr, plan.soffsetExpr, plan.assumptions);
  if (failed(voffset))
    return failure();
  voffset = appendAddressExpr(S, *voffset, plan.fullAddressRemainderExpr,
                              plan.assumptions);
  if (failed(voffset))
    return failure();
  voffset = appendInstOffsetExpr(S, *voffset, plan, includeInstOffset);
  if (failed(voffset))
    return failure();
  if (!*voffset) {
    if (includeInstOffset)
      plan.instOffset = 0;
    plan.soffsetExpr = {};
    plan.soffsetNeedsWide = false;
    plan.fullAddressRemainderExpr = {};
    return success();
  }
  if (!S.slotFitsU32(*voffset, plan.assumptions))
    return success();
  plan.voffsetExpr = *voffset;
  plan.voffsetNeedsWide = needsWideAddressMaterialization(*voffset, plan);
  if (includeInstOffset)
    plan.instOffset = 0;
  plan.soffsetExpr = {};
  plan.soffsetNeedsWide = false;
  plan.fullAddressRemainderExpr = {};
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
