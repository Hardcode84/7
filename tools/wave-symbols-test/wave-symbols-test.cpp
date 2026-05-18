//===- wave-symbols-test.cpp - Smoke test for Wave symbolic algebra ------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Stand-alone executable exercising the `wave::sym` infrastructure end to
// end without ever booting MLIR. Run from `test/Dialect/Wave/symbols-cpp.mlir`
// via FileCheck.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/WaveSymbols.h"

#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"

#include <cstdlib>
#include <optional>

using namespace mlir;
using namespace mlir::wave;

namespace {

void printLiteral(llvm::StringRef label, std::optional<int64_t> value) {
  llvm::outs() << label << ": ";
  if (value)
    llvm::outs() << *value;
  else
    llvm::outs() << "none";
  llvm::outs() << "\n";
}

// Write `<label>: <rendered-expr>` for FileCheck.
void printRendered(sym::Store &store, llvm::StringRef label,
                   sym::ExprHandle handle) {
  llvm::outs() << label << ": " << store.render(handle.raw()) << "\n";
}

sym::ExprHandle mustBuildInt(sym::Store &store, int64_t value) {
  auto handle = sym::composeExprInt(store, value);
  if (failed(handle)) {
    llvm::errs() << "failed to build integer literal\n";
    std::exit(1);
  }
  return *handle;
}

sym::ExprHandle mustBuildSym(sym::Store &store, llvm::StringRef name) {
  auto handle = sym::composeExprSym(store, name);
  if (failed(handle)) {
    llvm::errs() << "failed to build symbol '" << name << "'\n";
    std::exit(1);
  }
  return *handle;
}

sym::ExprHandle mustCompose(sym::Store &store, sym::ExprHandle lhs,
                            sym::ExprBinaryOp op, sym::ExprHandle rhs) {
  auto handle = sym::composeExprBinary(store, lhs, op, rhs);
  if (failed(handle)) {
    llvm::errs() << "failed to compose binary expression\n";
    std::exit(1);
  }
  return *handle;
}

sym::ExprHandle mustSimplify(sym::Store &store, sym::ExprHandle value) {
  std::string diagnostic;
  auto handle = sym::simplifyExpr(store, value, &diagnostic);
  if (failed(handle)) {
    llvm::errs() << "failed to simplify: " << diagnostic << "\n";
    std::exit(1);
  }
  return *handle;
}

void printRange(llvm::StringRef label, sym::Store &store, sym::ExprHandle expr,
                llvm::ArrayRef<sym::PredHandle> assumptions, int64_t lo,
                int64_t hi) {
  llvm::outs() << label << ": "
               << (sym::provablyInRange(store, expr, assumptions, lo, hi)
                       ? "true"
                       : "false")
               << "\n";
}

// (4) Range queries: under `x in [0, 31]`, probe `4*x + 1` against
// several candidate ranges. Hits both bounds plus the assumption-set
// fast path.
void runRangeQueries(sym::Store &store, sym::ExprHandle x,
                     sym::ExprHandle fourX) {
  auto rangeAssumption = sym::rangeAssumption(store, "x", 0, 31);
  if (failed(rangeAssumption)) {
    llvm::errs() << "failed to build range assumption\n";
    std::exit(1);
  }
  llvm::SmallVector<sym::PredHandle, 1> assumptions{*rangeAssumption};

  printRange("x-nonneg", store, x, assumptions, 0, 31);

  // 4*x + 1 over x in [0, 31] -> [1, 125].
  sym::ExprHandle one = mustBuildInt(store, 1);
  sym::ExprHandle linear =
      mustCompose(store, fourX, sym::ExprBinaryOp::Add, one);

  printRange("fits-tight", store, linear, assumptions, 1, 125);
  printRange("fits-loose", store, linear, assumptions, -1000, 1000);
  printRange("overflows-upper", store, linear, assumptions, 0, 100);
  // No assumptions -> `x` unbounded, even the loose range fails to prove.
  printRange("no-assumptions", store, linear, {}, -1000, 1000);
}

} // namespace

int main() {
  sym::Store store;

  //===--------------------------------------------------------------------===//
  // (1) Integer-literal introspection round-trip (mirrors the 5/5 sanity
  // check on `getIntegerLiteralValue`). Lock the session only for the leaf
  // builds.
  //===--------------------------------------------------------------------===//
  {
    sym::Session session(store);
    printLiteral("int", sym::getIntegerLiteralValue(
                            sym::ExprHandle(ixs_int(session.raw(), -42))));
    printLiteral("unit-rat", sym::getIntegerLiteralValue(sym::ExprHandle(
                                 ixs_rat(session.raw(), 7, 1))));
    printLiteral("non-unit-rat", sym::getIntegerLiteralValue(sym::ExprHandle(
                                     ixs_rat(session.raw(), 7, 2))));
    printLiteral("symbol", sym::getIntegerLiteralValue(
                               sym::ExprHandle(ixs_sym(session.raw(), "N"))));
  }

  //===--------------------------------------------------------------------===//
  // (2) Two structurally distinct expressions that should collapse to the
  // same hash-consed form after `ixs_simplify`. This is the load-bearing
  // property: the simplifier returns a canonical handle that pointer-
  // equals across composition paths.
  //
  //   lhs = floor((4*x + 2*x) / 3)
  //   rhs = floor((6*x) / 3)
  //   simplified(lhs) == simplified(rhs) == 2*x.
  //===--------------------------------------------------------------------===//
  sym::ExprHandle x = mustBuildSym(store, "x");
  sym::ExprHandle two = mustBuildInt(store, 2);
  sym::ExprHandle three = mustBuildInt(store, 3);
  sym::ExprHandle four = mustBuildInt(store, 4);
  sym::ExprHandle six = mustBuildInt(store, 6);

  sym::ExprHandle fourX = mustCompose(store, four, sym::ExprBinaryOp::Mul, x);
  sym::ExprHandle twoX = mustCompose(store, two, sym::ExprBinaryOp::Mul, x);
  sym::ExprHandle fourXPlusTwoX =
      mustCompose(store, fourX, sym::ExprBinaryOp::Add, twoX);
  sym::ExprHandle lhsDiv =
      mustCompose(store, fourXPlusTwoX, sym::ExprBinaryOp::Div, three);
  sym::ExprHandle lhs = [&] {
    auto handle = sym::composeExprFloor(store, lhsDiv);
    if (failed(handle)) {
      llvm::errs() << "failed to build floor(lhs)\n";
      std::exit(1);
    }
    return *handle;
  }();

  sym::ExprHandle sixX = mustCompose(store, six, sym::ExprBinaryOp::Mul, x);
  sym::ExprHandle rhsDiv =
      mustCompose(store, sixX, sym::ExprBinaryOp::Div, three);
  sym::ExprHandle rhs = [&] {
    auto handle = sym::composeExprFloor(store, rhsDiv);
    if (failed(handle)) {
      llvm::errs() << "failed to build floor(rhs)\n";
      std::exit(1);
    }
    return *handle;
  }();

  printRendered(store, "lhs-raw", lhs);
  printRendered(store, "rhs-raw", rhs);

  sym::ExprHandle lhsSimplified = mustSimplify(store, lhs);
  sym::ExprHandle rhsSimplified = mustSimplify(store, rhs);

  printRendered(store, "lhs-simplified", lhsSimplified);
  printRendered(store, "rhs-simplified", rhsSimplified);
  llvm::outs() << "pointer-equal-after-simplify: "
               << (lhsSimplified == rhsSimplified ? "true" : "false") << "\n";

  //===--------------------------------------------------------------------===//
  // (3) Hash-consing of leaf nodes built in independent sessions. Two
  // separately-constructed `ixs_sym(... "x")` calls must yield the same
  // pointer (the store dedup-tables leaves by structure).
  //===--------------------------------------------------------------------===//
  sym::ExprHandle xAgain = mustBuildSym(store, "x");
  llvm::outs() << "hash-consed-symbol: " << (x == xAgain ? "true" : "false")
               << "\n";

  runRangeQueries(store, x, fourX);

  return 0;
}
