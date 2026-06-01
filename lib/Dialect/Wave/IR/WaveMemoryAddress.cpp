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
#include "llvm/Support/FormatVariadic.h"

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
    FailureOr<sym::ExprHandle> simplified = sym::simplifyExpr(store, expr);
    if (failed(simplified))
      return failure();
    offset.expr = *simplified;
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
    llvm::append_range(offset.assumptions, symbolic.assumptions);

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
    if (AddiOp add = value.getDefiningOp<AddiOp>())
      return buildBinaryExpr(add.getLhs(), sym::ExprBinaryOp::Add, add.getRhs(),
                             skip, depth + 1);
    if (MuliOp mul = value.getDefiningOp<MuliOp>())
      return buildBinaryExpr(mul.getLhs(), sym::ExprBinaryOp::Mul, mul.getRhs(),
                             skip, depth + 1);
    if (ShliOp shl = value.getDefiningOp<ShliOp>())
      return buildShiftExpr(shl, skip, depth + 1);
    if (BinaryOp bin = value.getDefiningOp<BinaryOp>())
      if (bin.getKind() == "xori")
        return buildBinaryExpr(bin.getLhs(), sym::ExprBinaryOp::Xor,
                               bin.getRhs(), skip, depth + 1);
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

  FailureOr<sym::ExprHandle> buildShiftExpr(ShliOp op, bool &skip,
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
    for (;;) {
      std::string name = llvm::formatv("{0}{1}", stem, nextRawSymbol++).str();
      if (!bindingByName.contains(name))
        return name;
    }
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

static FailureOr<sym::ExprHandle>
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

  if (substitutions.empty())
    return rhs.offset.expr;
  return sym::substituteExpr(store, rhs.offset.expr, substitutions);
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

  FailureOr<sym::ExprHandle> rhsExpr =
      substituteDeltaBindings(dialect, lhs, rhs);
  if (failed(rhsExpr))
    return std::optional<sym::ExprHandle>{};

  sym::Store &store = dialect.getSymbolStore();
  FailureOr<sym::ExprHandle> diff = sym::composeExprBinary(
      store, lhs.offset.expr, sym::ExprBinaryOp::Sub, *rhsExpr);
  if (failed(diff))
    return failure();
  FailureOr<sym::ExprHandle> simplified = sym::simplifyExpr(store, *diff);
  if (failed(simplified))
    return failure();
  return std::optional<sym::ExprHandle>{*simplified};
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
