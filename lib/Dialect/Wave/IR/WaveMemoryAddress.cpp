//===- WaveMemoryAddress.cpp - Wave memory address utilities ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/Wave.h"

#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringSet.h"

#include <algorithm>
#include <optional>
#include <string>

using namespace mlir;
using namespace mlir::wave;

namespace {

class MemoryAddressOffsetBuilder {
public:
  explicit MemoryAddressOffsetBuilder(WaveDialect &dialect)
      : store(dialect.getSymbolStore()) {}

  LogicalResult append(Value offset, bool &skip) {
    if (IndexExprOp indexExpr = offset.getDefiningOp<IndexExprOp>())
      return append(indexExpr, skip);
    if (std::optional<int64_t> value = getConstantIntValue(offset))
      return appendConstant(*value);
    if (offset.getType().isIndex()) {
      skip = true;
      return success();
    }
    return appendRaw(offset, skip);
  }

  FailureOr<MemoryAddress> finish(Value base) {
    if (!expr) {
      FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
      if (failed(zero))
        return failure();
      expr = *zero;
    }
    FailureOr<sym::ExprHandle> simplified =
        offset.assumptions.empty()
            ? sym::simplifyExpr(store, expr)
            : sym::simplifyExpr(store, expr, offset.assumptions);
    if (failed(simplified))
      return failure();
    offset.expr =
        shouldUseSimplifiedIndexExpr(*simplified, expr) ? *simplified : expr;
    return MemoryAddress{std::move(offset), base};
  }

private:
  LogicalResult append(IndexExprOp op, bool &) {
    FailureOr<SymbolicOffset> symbolic = getIndexExprSymbolicOffset(op);
    if (failed(symbolic))
      return failure();
    return appendSymbolicOffset(*symbolic);
  }

  LogicalResult appendSymbolicOffset(const SymbolicOffset &symbolic) {
    SmallVector<sym::ExprSubstitution> substitutions;
    for (const SymbolicOffsetBinding &binding : symbolic.bindings) {
      StringRef name = symbolName(binding);
      llvm::StringMap<Value>::iterator it = bindingByName.find(name);
      if (it == bindingByName.end()) {
        bindingByName[name] = binding.value;
        offset.bindings.push_back(binding);
        offset.laneWidth = std::max(offset.laneWidth, symbolic.laneWidth);
        continue;
      }

      if (it->second == binding.value)
        continue;

      std::string fresh = freshName(name);
      auto [freshIt, inserted] =
          bindingByName.try_emplace(fresh, binding.value);
      (void)inserted;
      StringRef freshRef = freshIt->getKey();
      FailureOr<sym::ExprHandle> replacement =
          sym::composeExprSym(store, freshRef);
      if (failed(replacement))
        return failure();
      offset.bindings.push_back({*replacement, binding.value, binding.kind});
      offset.laneWidth = std::max(offset.laneWidth, symbolic.laneWidth);
      substitutions.push_back({binding.name, *replacement});
    }
    FailureOr<SmallVector<sym::PredHandle>> assumptions =
        substituteIndexExprPredicates(store, symbolic.assumptions,
                                      substitutions);
    if (failed(assumptions))
      return failure();
    llvm::append_range(offset.assumptions, *assumptions);

    sym::ExprHandle expr = symbolic.expr;
    if (!substitutions.empty()) {
      FailureOr<sym::ExprHandle> substituted =
          sym::substituteExpr(store, expr, substitutions);
      if (failed(substituted))
        return failure();
      expr = *substituted;
    }
    return appendExpr(expr);
  }

  LogicalResult appendConstant(int64_t value) {
    FailureOr<sym::ExprHandle> constant = sym::composeExprInt(store, value);
    if (failed(constant))
      return failure();
    return appendExpr(*constant);
  }

  LogicalResult appendRaw(Value value, bool &skip) {
    FailureOr<sym::ExprHandle> valueExpr = buildValueExpr(value, skip);
    if (skip)
      return success();
    if (failed(valueExpr))
      return failure();
    return appendExpr(*valueExpr);
  }

  FailureOr<sym::ExprHandle> buildValueExpr(Value value, bool &skip,
                                            unsigned depth = 0) {
    if (depth > 8) {
      skip = true;
      return failure();
    }
    if (std::optional<int64_t> constant = getConstantIntValue(value))
      return sym::composeExprInt(store, *constant);
    if (value.getDefiningOp<LaneIdOp>())
      return bindSymbol(value);
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return buildValueExpr(splat.getSource(), skip, depth + 1);
    if (BinaryOp bin = value.getDefiningOp<BinaryOp>())
      return buildBinaryValueExpr(bin, skip, depth + 1);
    skip = true;
    return failure();
  }

  FailureOr<sym::ExprHandle> buildBinaryValueExpr(BinaryOp bin, bool &skip,
                                                  unsigned depth) {
    if (bin.getKind() == BinaryKind::AddI && bin.hasNoSignedWrap())
      return buildBinaryExpr(bin.getLhs(), sym::ExprBinaryOp::Add, bin.getRhs(),
                             skip, depth);
    if (bin.getKind() == BinaryKind::MulI && bin.hasNoSignedWrap())
      return buildBinaryExpr(bin.getLhs(), sym::ExprBinaryOp::Mul, bin.getRhs(),
                             skip, depth);
    if (bin.getKind() == BinaryKind::ShLI && bin.hasNoSignedWrap())
      return buildShiftExpr(bin, skip, depth);
    if (bin.getKind() == BinaryKind::XOrI)
      return buildBinaryExpr(bin.getLhs(), sym::ExprBinaryOp::Xor, bin.getRhs(),
                             skip, depth);
    skip = true;
    return failure();
  }

  FailureOr<sym::ExprHandle> buildBinaryExpr(Value lhs, sym::ExprBinaryOp op,
                                             Value rhs, bool &skip,
                                             unsigned depth) {
    FailureOr<sym::ExprHandle> lhsExpr = buildValueExpr(lhs, skip, depth);
    if (skip || failed(lhsExpr))
      return failure();
    FailureOr<sym::ExprHandle> rhsExpr = buildValueExpr(rhs, skip, depth);
    if (skip || failed(rhsExpr))
      return failure();
    return sym::composeExprBinary(store, *lhsExpr, op, *rhsExpr);
  }

  FailureOr<sym::ExprHandle> buildShiftExpr(BinaryOp op, bool &skip,
                                            unsigned depth) {
    std::optional<int64_t> shift = getConstantIntValue(op.getRhs());
    if (!shift || *shift < 0 || *shift >= 63) {
      skip = true;
      return failure();
    }
    FailureOr<sym::ExprHandle> lhs = buildValueExpr(op.getLhs(), skip, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> scale =
        sym::composeExprInt(store, int64_t{1} << *shift);
    if (failed(scale))
      return failure();
    return sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mul, *scale);
  }

  FailureOr<sym::ExprHandle> bindSymbol(Value value) {
    std::string name = freshName();
    FailureOr<sym::ExprHandle> sym = sym::composeExprSym(store, name);
    if (failed(sym))
      return failure();
    SymbolicOffsetBindingKind kind = SymbolicOffsetBindingKind::Uniform;
    if (auto simdType = dyn_cast<SimdType>(value.getType())) {
      kind = SymbolicOffsetBindingKind::Lane;
      offset.laneWidth =
          std::max(offset.laneWidth, unsigned(simdType.getWidth()));
    } else if (auto intType = dyn_cast<IntegerType>(value.getType())) {
      if (!intType.isSignless())
        return failure();
    } else if (!value.getType().isIndex()) {
      return failure();
    }
    bindingByName[name] = value;
    offset.bindings.push_back({*sym, value, kind});
    return *sym;
  }

  LogicalResult appendExpr(sym::ExprHandle term) {
    if (!expr) {
      expr = term;
      return success();
    }
    FailureOr<sym::ExprHandle> sum =
        sym::composeExprBinary(store, expr, sym::ExprBinaryOp::Add, term);
    if (failed(sum))
      return failure();
    expr = *sum;
    return success();
  }

  std::string freshName(StringRef stem = "raw") {
    return getFreshIndexExprBindingName(stem, bindingByName, nextRawSymbol);
  }

  static StringRef symbolName(const SymbolicOffsetBinding &binding) {
    return sym::ExprView(binding.name).getSymbolName();
  }

  SymbolicOffset offset;
  llvm::StringMap<Value> bindingByName;
  sym::Store &store;
  sym::ExprHandle expr;
  unsigned nextRawSymbol = 0;
};

static SmallVector<PtrAddOp> collectPtrAddChain(PtrAddOp op) {
  SmallVector<PtrAddOp> chain;
  for (PtrAddOp cur = op; cur; cur = cur.getBase().getDefiningOp<PtrAddOp>())
    chain.push_back(cur);
  return chain;
}

struct RemappedOffset {
  SmallVector<sym::PredHandle> assumptions;
  sym::ExprHandle expr;
};

static bool assumptionsUseBoundSymbols(const SymbolicOffset &offset) {
  llvm::StringSet<> bound;
  for (const SymbolicOffsetBinding &binding : offset.bindings) {
    StringRef name = sym::ExprView(binding.name).getSymbolName();
    if (name.empty())
      return false;
    bound.insert(name);
  }
  for (sym::PredHandle assumption : offset.assumptions) {
    bool valid = true;
    sym::walkSymbolNames(assumption, [&](StringRef name) {
      if (!bound.contains(name))
        valid = false;
    });
    if (!valid)
      return false;
  }
  return true;
}

static FailureOr<RemappedOffset>
substituteDeltaBindings(WaveDialect &dialect, const MemoryAddress &lhs,
                        const MemoryAddress &rhs) {
  sym::Store &store = dialect.getSymbolStore();

  SmallVector<sym::ExprSubstitution> substitutions;
  for (const SymbolicOffsetBinding &binding : rhs.offset.bindings) {
    auto lhsByName = llvm::find_if(lhs.offset.bindings,
                                   [&](const SymbolicOffsetBinding &candidate) {
                                     return candidate.name == binding.name;
                                   });
    if (lhsByName != lhs.offset.bindings.end()) {
      if (lhsByName->value != binding.value)
        return failure();
      continue;
    }

    auto lhsByValue = llvm::find_if(
        lhs.offset.bindings, [&](const SymbolicOffsetBinding &candidate) {
          return candidate.value == binding.value;
        });
    if (lhsByValue == lhs.offset.bindings.end())
      continue;
    substitutions.push_back({binding.name, lhsByValue->name});
  }

  sym::ExprHandle expr = rhs.offset.expr;
  if (!substitutions.empty()) {
    FailureOr<sym::ExprHandle> substituted =
        sym::substituteExpr(store, expr, substitutions);
    if (failed(substituted))
      return failure();
    expr = *substituted;
  }
  FailureOr<SmallVector<sym::PredHandle>> assumptions =
      substituteIndexExprPredicates(store, rhs.offset.assumptions,
                                    substitutions);
  if (failed(assumptions))
    return failure();
  return RemappedOffset{std::move(*assumptions), expr};
}

static FailureOr<sym::ExprHandle>
computeDefinedAddressDelta(sym::Analysis &analysis, sym::ExprHandle lhs,
                           sym::ExprHandle rhs) {
  if (std::optional<int64_t> delta = analysis.constantDifference(lhs, rhs))
    return analysis.composeInteger(*delta);
  FailureOr<sym::ExprHandle> diff =
      analysis.compose(lhs, sym::ExprBinaryOp::Sub, rhs);
  if (failed(diff))
    return failure();
  return analysis.simplify(*diff);
}

} // namespace

FailureOr<std::optional<MemoryAddress>>
mlir::wave::normalizeMemoryAddress(Value ptr, WaveDialect &dialect) {
  if (!isWavePointerLikeType(ptr.getType()))
    return std::optional<MemoryAddress>{};

  MemoryAddressOffsetBuilder builder(dialect);
  if (PtrAddOp ptrAdd = ptr.getDefiningOp<PtrAddOp>()) {
    bool skip = false;
    SmallVector<PtrAddOp> chain = collectPtrAddChain(ptrAdd);
    for (PtrAddOp add : llvm::reverse(chain)) {
      if (failed(builder.append(add.getOffset(), skip)))
        return failure();
      if (skip)
        return std::optional<MemoryAddress>{};
    }
    FailureOr<MemoryAddress> address = builder.finish(chain.back().getBase());
    if (failed(address))
      return failure();
    return std::optional<MemoryAddress>{std::move(*address)};
  }

  FailureOr<MemoryAddress> address = builder.finish(ptr);
  if (failed(address))
    return failure();
  return std::optional<MemoryAddress>{std::move(*address)};
}

FailureOr<std::optional<sym::ExprHandle>> mlir::wave::computeMemoryAddressDelta(
    WaveDialect &dialect, const MemoryAddress &lhs, const MemoryAddress &rhs) {
  if (lhs.base != rhs.base)
    return std::optional<sym::ExprHandle>{};
  if (!assumptionsUseBoundSymbols(lhs.offset) ||
      !assumptionsUseBoundSymbols(rhs.offset))
    return std::optional<sym::ExprHandle>{};

  FailureOr<RemappedOffset> rhsOffset =
      substituteDeltaBindings(dialect, lhs, rhs);
  if (failed(rhsOffset))
    return std::optional<sym::ExprHandle>{};

  sym::Store &store = dialect.getSymbolStore();
  SmallVector<sym::PredHandle> assumptions;
  llvm::append_range(assumptions, lhs.offset.assumptions);
  llvm::append_range(assumptions, rhsOffset->assumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis))
    return failure();
  if ((*analysis)->defined(lhs.offset.expr) != sym::CheckResult::True ||
      (*analysis)->defined(rhsOffset->expr) != sym::CheckResult::True)
    return std::optional<sym::ExprHandle>{};
  FailureOr<sym::ExprHandle> delta =
      computeDefinedAddressDelta(**analysis, lhs.offset.expr, rhsOffset->expr);
  if (failed(delta))
    return failure();
  return std::optional<sym::ExprHandle>{*delta};
}

FailureOr<std::optional<int64_t>> mlir::wave::computeConstantMemoryAddressDelta(
    WaveDialect &dialect, const MemoryAddress &lhs, const MemoryAddress &rhs) {
  FailureOr<std::optional<sym::ExprHandle>> delta =
      computeMemoryAddressDelta(dialect, lhs, rhs);
  if (failed(delta))
    return failure();
  if (!*delta)
    return std::optional<int64_t>{};
  return sym::getIntegerLiteralValue(**delta);
}
