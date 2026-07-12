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

#include <array>
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

const char *boolName(bool value) { return value ? "true" : "false"; }

const char *exprKindName(sym::ExprKind kind) {
  static constexpr std::array<const char *, 15> names = {
      "invalid", "integer", "rational", "symbol", "add",
      "mul",     "floor",   "ceil",     "mod",    "piecewise",
      "max",     "min",     "xor",      "error",  "parse-error",
  };
  size_t index = static_cast<size_t>(kind);
  return index < names.size() ? names[index] : "invalid";
}

const char *predKindName(sym::PredKind kind) {
  static constexpr std::array<const char *, 9> names = {
      "invalid", "cmp",   "and",   "or",          "not",
      "true",    "false", "error", "parse-error",
  };
  size_t index = static_cast<size_t>(kind);
  return index < names.size() ? names[index] : "invalid";
}

const char *pow2FactName(sym::Pow2Fact fact) {
  switch (fact) {
  case sym::Pow2Fact::Unknown:
    return "unknown";
  case sym::Pow2Fact::OrZero:
    return "or-zero";
  case sym::Pow2Fact::Positive:
    return "positive";
  }
  llvm_unreachable("unknown pow2 fact");
}

// Write `<label>: <rendered-expr>` for FileCheck.
void printRendered(sym::Store &store, llvm::StringRef label,
                   sym::ExprHandle handle) {
  llvm::outs() << label << ": " << store.render(handle) << "\n";
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

sym::ExprHandle mustParseExpr(sym::Store &store, llvm::StringRef text) {
  std::string diagnostic;
  auto handle = sym::parseExpr(store, text, &diagnostic);
  if (failed(handle)) {
    llvm::errs() << "failed to parse '" << text << "': " << diagnostic << "\n";
    std::exit(1);
  }
  return *handle;
}

sym::PredHandle mustParsePred(sym::Store &store, llvm::StringRef text) {
  std::string diagnostic;
  auto handle = sym::parsePred(store, text, &diagnostic);
  if (failed(handle)) {
    llvm::errs() << "failed to parse '" << text << "': " << diagnostic << "\n";
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

sym::ExprHandle mustExpand(sym::Store &store, sym::ExprHandle value) {
  std::string diagnostic;
  auto handle = sym::expandExpr(store, value, &diagnostic);
  if (failed(handle)) {
    llvm::errs() << "failed to expand: " << diagnostic << "\n";
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

void printRational(llvm::StringRef label,
                   std::optional<sym::RationalEndpoint> value) {
  llvm::outs() << label << ": ";
  if (!value) {
    llvm::outs() << "none\n";
    return;
  }
  llvm::outs() << value->numerator;
  if (value->denominator != 1)
    llvm::outs() << "/" << value->denominator;
  llvm::outs() << "\n";
}

void printUtilitySmoke(sym::Store &store, sym::ExprHandle x) {
  sym::ExprHandle one = mustBuildInt(store, 1);
  sym::ExprHandle two = mustBuildInt(store, 2);
  sym::ExprHandle four = mustBuildInt(store, 4);
  sym::ExprHandle seven = mustBuildInt(store, 7);
  sym::ExprHandle xPlusOne = mustCompose(store, x, sym::ExprBinaryOp::Add, one);
  sym::ExprHandle xPlusTwo = mustCompose(store, x, sym::ExprBinaryOp::Add, two);
  sym::ExprHandle product =
      mustCompose(store, xPlusOne, sym::ExprBinaryOp::Mul, xPlusTwo);
  printRendered(store, "expanded-product", mustExpand(store, product));

  sym::ExprHandle sevenHalf =
      mustCompose(store, seven, sym::ExprBinaryOp::Div, two);
  sym::ExprHandle xQuarter =
      mustCompose(store, x, sym::ExprBinaryOp::Div, four);
  sym::ExprHandle xHalf = mustCompose(store, x, sym::ExprBinaryOp::Div, two);
  sym::ExprHandle denomExpr =
      mustCompose(store, sevenHalf, sym::ExprBinaryOp::Add, xQuarter);
  printLiteral("denominator-lcm", sym::collectDenominator(denomExpr));
  sym::ExprHandle modQuarter =
      mustCompose(store, xQuarter, sym::ExprBinaryOp::Mod, xHalf);
  printLiteral("denominator-mod-rational", sym::collectDenominator(modQuarter));
  sym::ExprHandle piecewise =
      mustParseExpr(store, "Piecewise((7/2, x >= 0), (x/4, True))");
  printLiteral("denominator-piecewise", sym::collectDenominator(piecewise));

  auto rangeAssumption = sym::rangeAssumption(store, "x", 0, 31);
  if (failed(rangeAssumption)) {
    llvm::errs() << "failed to build range assumption\n";
    std::exit(1);
  }
  llvm::SmallVector<sym::PredHandle, 1> assumptions{*rangeAssumption};
  llvm::outs() << "fits-u32: "
               << boolName(sym::provablyFitsU32(store, x, assumptions)) << "\n";
  llvm::outs() << "fits-u32-unbounded: "
               << boolName(sym::provablyFitsU32(store, x, {})) << "\n";
}

void printFacadeSmoke(sym::Store &store, sym::ExprHandle x,
                      sym::ExprHandle five, sym::ExprHandle threeX) {
  sym::ExprHandle affine =
      mustCompose(store, threeX, sym::ExprBinaryOp::Add, five);
  sym::ExprView addView(affine);
  llvm::outs() << "view-add-valid: " << boolName(addView.isValid()) << "\n";
  llvm::outs() << "view-add-kind: " << exprKindName(addView.getKind()) << "\n";
  printLiteral("view-add-constant",
               sym::getIntegerLiteralValue(addView.getAddConstant()));
  llvm::outs() << "view-add-terms: " << addView.getAddTermCount() << "\n";
  sym::AddTerm addTerm = addView.getAddTerm(0);
  printLiteral("view-add-term-coeff",
               sym::getIntegerLiteralValue(addTerm.coefficient));
  llvm::outs() << "view-add-term-symbol: "
               << sym::ExprView(addTerm.term).getSymbolName() << "\n";

  sym::ExprView mulView(threeX);
  llvm::outs() << "view-mul-kind: " << exprKindName(mulView.getKind()) << "\n";
  printLiteral("view-mul-coeff",
               sym::getIntegerLiteralValue(mulView.getMulCoefficient()));
  llvm::outs() << "view-mul-factors: " << mulView.getMulFactorCount() << "\n";
  sym::MulFactor factor = mulView.getMulFactor(0);
  llvm::outs() << "view-mul-factor-symbol: "
               << sym::ExprView(factor.base).getSymbolName() << "\n";
  llvm::outs() << "view-mul-factor-exp: " << factor.exponent << "\n";

  sym::ExprHandle ratio =
      mustCompose(store, threeX, sym::ExprBinaryOp::Div, five);
  auto floorHandle = sym::composeExprFloor(store, ratio);
  if (failed(floorHandle)) {
    llvm::errs() << "failed to build floor facade smoke\n";
    std::exit(1);
  }
  sym::ExprView floorView(*floorHandle);
  llvm::outs() << "view-floor-arg-kind: "
               << exprKindName(sym::ExprView(floorView.getUnaryArg()).getKind())
               << "\n";

  sym::ExprHandle mod =
      mustCompose(store, threeX, sym::ExprBinaryOp::Mod, five);
  sym::ExprView modView(mod);
  llvm::outs() << "view-mod-lhs-kind: "
               << exprKindName(sym::ExprView(modView.getBinaryLhs()).getKind())
               << "\n";
  printLiteral("view-mod-rhs",
               sym::getIntegerLiteralValue(modView.getBinaryRhs()));

  auto geZero =
      sym::composePredCmp(store, x, sym::PredCmpOp::Ge, mustBuildInt(store, 0));
  auto leMax = sym::composePredCmp(store, x, sym::PredCmpOp::Le,
                                   mustBuildInt(store, 31));
  if (failed(geZero) || failed(leMax)) {
    llvm::errs() << "failed to build predicate facade smoke\n";
    std::exit(1);
  }
  auto range = sym::composePredAnd(store, *geZero, *leMax);
  if (failed(range)) {
    llvm::errs() << "failed to build predicate AND facade smoke\n";
    std::exit(1);
  }
  sym::PredView predView(*range);
  llvm::outs() << "view-pred-valid: " << boolName(predView.isValid()) << "\n";
  llvm::outs() << "view-pred-kind: " << predKindName(predView.getKind())
               << "\n";
  llvm::outs() << "view-pred-args: " << predView.getLogicArgCount() << "\n";
  llvm::outs() << "view-pred-first-kind: "
               << predKindName(sym::PredView(predView.getLogicArg(0)).getKind())
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
  std::optional<sym::InferredRange> inferred =
      sym::inferRange(store, linear, assumptions);
  printRational("range-lower", inferred ? inferred->lower : std::nullopt);
  printRational("range-upper", inferred ? inferred->upper : std::nullopt);
  printLiteral("range-u32-upper",
               sym::inferNonNegativeUpperBound(store, linear, assumptions,
                                               /*maxUpper=*/1000));

  printRange("fits-tight", store, linear, assumptions, 1, 125);
  printRange("fits-loose", store, linear, assumptions, -1000, 1000);
  printRange("overflows-upper", store, linear, assumptions, 0, 100);
  // No assumptions -> `x` unbounded, even the loose range fails to prove.
  printRange("no-assumptions", store, linear, {}, -1000, 1000);
}

void runPow2Queries(sym::Store &store, sym::ExprHandle x) {
  sym::PredHandle pow2OrZero = mustParsePred(store, "x & (x - 1) == 0");
  sym::PredHandle positive = mustParsePred(store, "x > 0");
  llvm::SmallVector<sym::PredHandle, 2> assumptions{pow2OrZero};
  llvm::outs() << "pow2-unknown: "
               << pow2FactName(sym::getPow2Fact(store, x, {})) << "\n";
  llvm::outs() << "pow2-or-zero: "
               << pow2FactName(sym::getPow2Fact(store, x, assumptions)) << "\n";
  assumptions.push_back(positive);
  llvm::outs() << "pow2-positive: "
               << pow2FactName(sym::getPow2Fact(store, x, assumptions)) << "\n";
}

void runDefinednessQueries(sym::Store &store) {
  FailureOr<sym::PredHandle> range = sym::rangeAssumption(store, "x", 0, 31);
  if (failed(range)) {
    llvm::errs() << "failed to build definedness range\n";
    std::exit(1);
  }
  llvm::SmallVector<sym::PredHandle, 1> assumptions{*range};
  sym::ExprHandle safe = mustParseExpr(store, "floor(1 / (x + 1))");
  sym::ExprHandle partial = mustParseExpr(store, "floor(1 / (x - 1))");
  sym::ExprHandle uncovered = mustParseExpr(store, "Piecewise((x, x < 16))");
  llvm::outs() << "defined-safe-div: "
               << boolName(sym::provablyDefined(store, safe, assumptions))
               << "\n";
  llvm::outs() << "defined-partial-div: "
               << boolName(sym::provablyDefined(store, partial, assumptions))
               << "\n";
  llvm::outs() << "defined-uncovered-piecewise: "
               << boolName(sym::provablyDefined(store, uncovered, assumptions))
               << "\n";
}

} // namespace

int main() {
  sym::Store store;

  //===--------------------------------------------------------------------===//
  // (1) Integer-literal introspection round-trip (mirrors the 5/5 sanity
  // check on `getIntegerLiteralValue`).
  //===--------------------------------------------------------------------===//
  {
    printLiteral("int", sym::getIntegerLiteralValue(mustBuildInt(store, -42)));
    printLiteral("unit-rat",
                 sym::getIntegerLiteralValue(mustParseExpr(store, "7/1")));
    printLiteral("non-unit-rat",
                 sym::getIntegerLiteralValue(mustParseExpr(store, "7/2")));
    printLiteral("symbol",
                 sym::getIntegerLiteralValue(mustBuildSym(store, "N")));
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
  sym::ExprHandle five = mustBuildInt(store, 5);
  sym::ExprHandle six = mustBuildInt(store, 6);

  printUtilitySmoke(store, x);
  sym::ExprHandle threeX = mustCompose(store, three, sym::ExprBinaryOp::Mul, x);
  printFacadeSmoke(store, x, five, threeX);

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
  runPow2Queries(store, x);
  runDefinednessQueries(store);

  return 0;
}
