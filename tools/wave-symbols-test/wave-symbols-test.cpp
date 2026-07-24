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

#include "mlir/Dialect/Wave/IR/Wave.h"

#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"

#include <array>
#include <cstdlib>
#include <limits>
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

const char *checkResultName(sym::CheckResult result) {
  switch (result) {
  case sym::CheckResult::True:
    return "true";
  case sym::CheckResult::False:
    return "false";
  case sym::CheckResult::Unknown:
    return "unknown";
  }
  llvm_unreachable("unknown check result");
}

const char *exactDivideStatusName(sym::ExactDivideStatus status) {
  switch (status) {
  case sym::ExactDivideStatus::Proven:
    return "proven";
  case sym::ExactDivideStatus::NotExact:
    return "not-exact";
  case sym::ExactDivideStatus::Unknown:
    return "unknown";
  case sym::ExactDivideStatus::Error:
    return "error";
  }
  llvm_unreachable("unknown exact-divide status");
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

std::unique_ptr<sym::Analysis>
mustCreateAnalysis(sym::Store &store,
                   llvm::ArrayRef<sym::PredHandle> assumptions = {}) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis)) {
    llvm::errs() << "failed to create symbolic analysis\n";
    std::exit(1);
  }
  return std::move(*analysis);
}

std::unique_ptr<sym::Analysis>
mustCreateDirectAnalysis(sym::Store &store,
                         llvm::ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::createDirect(store, assumptions);
  if (failed(analysis)) {
    llvm::errs() << "failed to create direct symbolic analysis\n";
    std::exit(1);
  }
  return std::move(*analysis);
}

sym::ExprHandle mustBuildAnalysisExpr(FailureOr<sym::ExprHandle> handle) {
  if (failed(handle)) {
    llvm::errs() << "failed to build symbolic analysis expression\n";
    std::exit(1);
  }
  return *handle;
}

sym::PredHandle mustBuildAnalysisPred(FailureOr<sym::PredHandle> handle) {
  if (failed(handle)) {
    llvm::errs() << "failed to build symbolic analysis predicate\n";
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
  sym::ExprHandle xPlusOne = mustCompose(store, x, sym::ExprBinaryOp::Add, one);
  sym::ExprHandle xPlusTwo = mustCompose(store, x, sym::ExprBinaryOp::Add, two);
  sym::ExprHandle product =
      mustCompose(store, xPlusOne, sym::ExprBinaryOp::Mul, xPlusTwo);
  printRendered(store, "expanded-product", mustExpand(store, product));
  printLiteral("endpoint-floor", sym::floorEndpoint({-3, 2}));
  printLiteral("endpoint-ceil", sym::ceilEndpoint({-3, 2}));
  printLiteral("endpoint-invalid", sym::floorEndpoint({1, 0}));
  llvm::outs() << "endpoint-compare-wide: "
               << sym::compareEndpointToInteger(
                      {std::numeric_limits<int64_t>::max(), 2},
                      std::numeric_limits<int64_t>::max())
               << "\n";

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

  sym::ExprHandle composed = mustParseExpr(store, "128 + 64*u + w");
  sym::PredHandle composedRange = mustParsePred(
      store, "128 + 64*u + w >= 0 & -2147483647 + 128 + 64*u + w <= 0");
  std::array<sym::PredHandle, 1> composedAssumptions{composedRange};
  llvm::outs() << "fits-u32-compound: "
               << boolName(sym::provablyFitsU32(store, composed,
                                                composedAssumptions))
               << "\n";
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

struct AnalysisRenderResults {
  sym::ExprHandle simplifiedMod;
  sym::ExprHandle exactQuotient;
  sym::ExprHandle affineCoefficient;
  sym::ExprHandle affineResidual;
  sym::ExprHandle finiteDifference;
  sym::ExprHandle nonlinearDifference;
  sym::ExprHandle splitResidual;
};

static void printAnalysisProofs(sym::Analysis &analysis, sym::ExprHandle x,
                                sym::ExprHandle xQuarter, sym::ExprHandle safe,
                                sym::ExprHandle shiftedMod,
                                sym::ExprHandle baseMod,
                                sym::PredHandle belowThirtyTwo) {
  llvm::outs() << "analysis-check: "
               << checkResultName(analysis.check(belowThirtyTwo)) << "\n";
  llvm::outs() << "analysis-equivalent-mod: "
               << checkResultName(analysis.equivalent(shiftedMod, baseMod))
               << "\n";
  llvm::outs() << "analysis-defined: "
               << checkResultName(analysis.defined(safe)) << "\n";
  llvm::outs() << "analysis-integer-valued: "
               << checkResultName(analysis.integerValued(xQuarter)) << "\n";
  llvm::outs() << "analysis-divisible: "
               << checkResultName(analysis.divisible(x, 4)) << "\n";
  llvm::outs() << "analysis-congruent: "
               << checkResultName(analysis.congruent(x, 4, 0)) << "\n";
}

static void printAnalysisFacts(sym::Analysis &analysis, sym::ExprHandle x,
                               sym::ExprHandle square,
                               sym::ExprHandle xPlusFour,
                               AnalysisRenderResults &results) {
  sym::ExactDivideResult quotient = analysis.tryExactDivide(x, 4);
  llvm::outs() << "analysis-exact-divide: "
               << exactDivideStatusName(quotient.status) << "\n";
  results.exactQuotient = quotient.quotient;

  std::optional<sym::KnownBits> bits = analysis.getKnownBits(x);
  llvm::outs() << "analysis-known-zero-low2: "
               << (bits ? (bits->knownZero & 3) : 0) << "\n";
  std::optional<sym::Congruence> congruence = analysis.getSymbolCongruence(x);
  llvm::outs() << "analysis-symbol-congruence: ";
  if (congruence)
    llvm::outs() << congruence->modulus << "," << congruence->residue;
  else
    llvm::outs() << "none";
  llvm::outs() << "\n";

  std::optional<sym::InferredRange> squareRange = analysis.range(square);
  printRational("analysis-range-lower",
                squareRange ? squareRange->lower : std::nullopt);
  printRational("analysis-range-upper",
                squareRange ? squareRange->upper : std::nullopt);
  printLiteral("analysis-constant-difference",
               analysis.constantDifference(xPlusFour, x));
}

static void collectAnalysisAlgebra(sym::Analysis &analysis, sym::ExprHandle x,
                                   sym::ExprHandle four, sym::ExprHandle square,
                                   sym::ExprHandle affine,
                                   sym::ExprHandle unitSlope,
                                   AnalysisRenderResults &results) {
  std::optional<sym::AffineDecomposition> decomposition =
      analysis.affineDecompose(affine, x);
  std::optional<sym::ExprHandle> finite =
      analysis.finiteDifference(unitSlope, x, four);
  std::optional<sym::ExprHandle> nonlinear =
      analysis.finiteDifference(square, x, four);
  std::optional<sym::SplitAdditiveConstant> split =
      analysis.splitAdditiveConstant(affine);
  if (!decomposition || !finite || !nonlinear || !split) {
    llvm::errs() << "failed analysis algebra query\n";
    std::exit(1);
  }
  results.affineCoefficient = decomposition->coefficient;
  results.affineResidual = decomposition->residual;
  results.finiteDifference = *finite;
  results.nonlinearDifference = *nonlinear;
  results.splitResidual = split->residual;
  llvm::outs() << "analysis-split-constant: " << split->constant << "\n";
}

static sym::PredHandle buildXorCancellationQuery(sym::Analysis &analysis,
                                                 sym::ExprHandle x) {
  sym::ExprHandle one = mustBuildAnalysisExpr(analysis.composeInteger(1));
  sym::ExprHandle inner =
      mustBuildAnalysisExpr(analysis.compose(one, sym::ExprBinaryOp::Xor, x));
  sym::ExprHandle outer = mustBuildAnalysisExpr(
      analysis.compose(one, sym::ExprBinaryOp::Xor, inner));
  return mustBuildAnalysisPred(analysis.compare(outer, sym::PredCmpOp::Eq, x));
}

static void runAnalysisCore(sym::Store &store, sym::ExprHandle x,
                            sym::PredHandle facts) {
  sym::ExprHandle xQuarter = mustParseExpr(store, "x/4");
  sym::ExprHandle safe = mustParseExpr(store, "floor(1/(x + 1))");
  sym::ExprHandle partial = mustParseExpr(store, "floor(1/x)");
  sym::ExprHandle square = mustCompose(store, x, sym::ExprBinaryOp::Mul, x);
  sym::ExprHandle shiftedMod = mustParseExpr(store, "Mod(x + 4, 4)");
  sym::ExprHandle baseMod = mustParseExpr(store, "Mod(x, 4)");
  sym::ExprHandle affine = mustParseExpr(store, "3*x + 5");
  sym::ExprHandle unitSlope = mustParseExpr(store, "x + 5");
  std::unique_ptr<sym::Analysis> analysis = mustCreateAnalysis(store, {facts});
  sym::ExprHandle four = mustBuildAnalysisExpr(analysis->composeInteger(4));
  sym::ExprHandle xPlusFour =
      mustBuildAnalysisExpr(analysis->compose(x, sym::ExprBinaryOp::Add, four));
  sym::ExprHandle thirtyTwo =
      mustBuildAnalysisExpr(analysis->composeInteger(32));
  sym::ExprHandle zero = mustBuildAnalysisExpr(analysis->composeInteger(0));
  sym::PredHandle belowThirtyTwo = mustBuildAnalysisPred(
      analysis->compare(x, sym::PredCmpOp::Lt, thirtyTwo));
  sym::PredHandle nonNegative =
      mustBuildAnalysisPred(analysis->compare(x, sym::PredCmpOp::Ge, zero));
  sym::PredHandle bounded =
      mustBuildAnalysisPred(analysis->composeAnd(nonNegative, belowThirtyTwo));
  sym::PredHandle xorCancellation = buildXorCancellationQuery(*analysis, x);

  AnalysisRenderResults results;
  std::array<sym::ExprHandle, 2> batch{shiftedMod, baseMod};
  if (failed(analysis->simplify(batch))) {
    llvm::errs() << "failed to simplify symbolic analysis batch\n";
    std::exit(1);
  }
  results.simplifiedMod = batch[0];
  llvm::outs() << "analysis-batch-pointer-equal: "
               << boolName(batch[0] == batch[1]) << "\n";
  llvm::outs() << "analysis-undefined-self-equivalent: "
               << checkResultName(analysis->equivalent(partial, partial))
               << "\n";
  printAnalysisProofs(*analysis, x, xQuarter, safe, shiftedMod, baseMod,
                      belowThirtyTwo);
  llvm::outs() << "analysis-xor-cancellation: "
               << checkResultName(analysis->check(xorCancellation)) << "\n";
  llvm::outs() << "analysis-compound-check: "
               << checkResultName(analysis->check(bounded)) << "\n";
  printAnalysisFacts(*analysis, x, square, xPlusFour, results);
  collectAnalysisAlgebra(*analysis, x, four, square, affine, unitSlope,
                         results);
  analysis.reset();

  llvm::outs() << "analysis-wrapper-xor-cancellation: "
               << checkResultName(
                      sym::checkPredicate(store, xorCancellation, {facts}))
               << "\n";
  llvm::outs() << "analysis-wrapper-compound-check: "
               << checkResultName(sym::checkPredicate(store, bounded, {facts}))
               << "\n";

  printRendered(store, "analysis-simplified-mod", results.simplifiedMod);
  printRendered(store, "analysis-exact-quotient", results.exactQuotient);
  printRendered(store, "analysis-affine-coefficient",
                results.affineCoefficient);
  printRendered(store, "analysis-affine-residual", results.affineResidual);
  printRendered(store, "analysis-finite-difference", results.finiteDifference);
  printRendered(store, "analysis-nonlinear-difference",
                results.nonlinearDifference);
  printRendered(store, "analysis-split-residual", results.splitResidual);
}

static void runAnalysisRangeMutation(sym::Store &store, sym::ExprHandle x) {
  std::unique_ptr<sym::Analysis> analysis = mustCreateAnalysis(store);
  sym::InferredRange explicitRange;
  explicitRange.lower = sym::RationalEndpoint{2, 1};
  explicitRange.upper = sym::RationalEndpoint{4, 1};
  sym::ExprHandle two = mustBuildAnalysisExpr(analysis->composeInteger(2));
  sym::ExprHandle one = mustBuildAnalysisExpr(analysis->composeInteger(1));
  sym::ExprHandle scaled =
      mustBuildAnalysisExpr(analysis->compose(two, sym::ExprBinaryOp::Mul, x));
  sym::ExprHandle derived = mustBuildAnalysisExpr(
      analysis->compose(scaled, sym::ExprBinaryOp::Add, one));
  if (failed(analysis->assumeRange(x, explicitRange)) ||
      failed(analysis->deriveAffine(x, 2, 1, derived))) {
    llvm::errs() << "failed explicit analysis range\n";
    std::exit(1);
  }
  std::optional<sym::InferredRange> range = analysis->range(derived);
  printRational("analysis-derived-lower", range ? range->lower : std::nullopt);
  printRational("analysis-derived-upper", range ? range->upper : std::nullopt);
}

static void runAnalysisFactSubstitution(sym::Store &store, sym::ExprHandle x,
                                        sym::PredHandle facts) {
  sym::ExprHandle y = mustBuildSym(store, "y");
  std::unique_ptr<sym::Analysis> analysis = mustCreateAnalysis(store, {facts});
  if (failed(analysis->substituteFacts({sym::ExprSubstitution{x, y}}))) {
    llvm::errs() << "failed to substitute analysis facts\n";
    std::exit(1);
  }
  std::optional<sym::InferredRange> yRange = analysis->range(y);
  printRational("analysis-substituted-upper",
                yRange ? yRange->upper : std::nullopt);
  llvm::outs() << "analysis-substituted-congruence: "
               << checkResultName(analysis->congruent(y, 4, 0)) << "\n";
}

static void runAnalysisBatchMutation(sym::Store &store, sym::ExprHandle x) {
  sym::PredHandle nonnegative = mustParsePred(store, "x >= 0");
  sym::PredHandle nonpositive = mustParsePred(store, "x <= 0");
  sym::PredHandle zero = mustParsePred(store, "x == 0");
  std::unique_ptr<sym::Analysis> analysis = mustCreateAnalysis(store);
  std::array<sym::PredHandle, 2> jointFacts{nonnegative, nonpositive};
  bool jointSuccess = succeeded(analysis->assume(jointFacts)) &&
                      analysis->check(zero) == sym::CheckResult::True;
  llvm::outs() << "analysis-batch-mutator-joint-success: "
               << boolName(jointSuccess) << "\n";

  analysis = mustCreateAnalysis(store);
  std::array<sym::PredHandle, 2> invalidFacts{nonnegative, sym::PredHandle{}};
  llvm::outs() << "analysis-batch-mutator-rejected: "
               << boolName(failed(analysis->assume(invalidFacts))) << "\n";
  llvm::outs() << "analysis-batch-mutator-poisoned: "
               << checkResultName(analysis->defined(x)) << "\n";
}

static void runAnalysisBatchClosure(sym::Store &store) {
  std::array<sym::PredHandle, 2> predicates{
      mustParsePred(store, "closure_divisor == 8"),
      mustParsePred(store, "closure_base + "
                           "floor(Mod(closure_lane, 8)/closure_divisor) >= 0"),
  };
  sym::PredHandle query = mustParsePred(store, "closure_base >= 0");

  std::unique_ptr<sym::Analysis> direct =
      mustCreateDirectAnalysis(store, predicates);
  llvm::outs() << "analysis-direct-batch-closure: "
               << checkResultName(direct->check(query)) << "\n";
  direct.reset();

  std::unique_ptr<sym::Analysis> analysis =
      mustCreateAnalysis(store, predicates);
  llvm::outs() << "analysis-create-batch-closure: "
               << checkResultName(analysis->check(query)) << "\n";

  analysis = mustCreateAnalysis(store);
  if (failed(analysis->assume(predicates))) {
    llvm::errs() << "failed analysis closure batch\n";
    std::exit(1);
  }
  llvm::outs() << "analysis-assume-batch-closure: "
               << checkResultName(analysis->check(query)) << "\n";
}

static void runOrderedGridEquivalence(sym::Store &store) {
  std::array<sym::PredHandle, 4> facts{
      mustParsePred(store, "Mod(grid_base, 16) == 0"),
      mustParsePred(store, "Mod(grid_limit, 16) == 0"),
      mustParsePred(store, "grid_toggle >= 0"),
      mustParsePred(store, "grid_toggle <= 1"),
  };
  sym::PredHandle lower =
      mustParsePred(store, "grid_base + 4*grid_toggle < grid_limit");
  sym::PredHandle upper =
      mustParsePred(store, "grid_base + 4*grid_toggle + 8 < grid_limit");
  std::unique_ptr<sym::Analysis> analysis = mustCreateAnalysis(store, facts);
  SmallVector<sym::PredHandle, 4> lowerForms =
      analysis->orderedComparisonForms(lower);
  SmallVector<sym::PredHandle, 4> upperForms =
      analysis->orderedComparisonForms(upper);
  bool equivalent = llvm::any_of(lowerForms, [&](sym::PredHandle lhs) {
    return llvm::is_contained(upperForms, lhs);
  });
  llvm::outs() << "analysis-ordered-grid-equivalent: " << boolName(equivalent)
               << "\n";
}

static void runAnalysisRejection(sym::Store &store, sym::ExprHandle x,
                                 sym::PredHandle validFacts,
                                 sym::PredHandle invalidFacts) {
  llvm::outs() << "analysis-or-factory-rejected: "
               << boolName(failed(sym::Analysis::create(store, {invalidFacts})))
               << "\n";
  llvm::outs() << "analysis-partial-factory-rejected: "
               << boolName(failed(
                      sym::Analysis::create(store, {validFacts, invalidFacts})))
               << "\n";
  std::unique_ptr<sym::Analysis> analysis = mustCreateAnalysis(store);
  llvm::outs() << "analysis-or-mutator-rejected: "
               << boolName(failed(analysis->assume(invalidFacts))) << "\n";
  llvm::outs() << "analysis-poisoned-query: "
               << checkResultName(analysis->defined(x)) << "\n";
  FailureOr<sym::ExprHandle> expanded = analysis->expand(x);
  llvm::outs() << "analysis-poisoned-expand: "
               << boolName(succeeded(expanded) && *expanded == x) << "\n";

  analysis = mustCreateAnalysis(store);
  std::string diagnostic = "stale";
  llvm::outs() << "analysis-invalid-handle-rejected: "
               << boolName(
                      failed(analysis->assume(sym::PredHandle{}, &diagnostic)))
               << "\n";
  llvm::outs() << "analysis-invalid-handle-diagnostic: " << diagnostic << "\n";
}

static void runSingletonFactSimplification(sym::Store &store) {
  std::array<sym::PredHandle, 6> facts{
      mustParsePred(store, "raw0 >= 0"),   mustParsePred(store, "raw0 <= 255"),
      mustParsePred(store, "raw1 >= 2"),   mustParsePred(store, "raw1 <= 2"),
      mustParsePred(store, "raw7 >= 128"), mustParsePred(store, "raw7 <= 128"),
  };
  std::unique_ptr<sym::Analysis> analysis = mustCreateAnalysis(store, facts);
  sym::ExprHandle expr = mustParseExpr(store, "Mod(floor(raw0/raw7), raw1)");
  FailureOr<sym::ExprHandle> simplified = analysis->simplify(expr);
  if (failed(simplified)) {
    llvm::errs() << "failed singleton-fact simplification\n";
    std::exit(1);
  }
  printRendered(store, "analysis-singleton-simplified", *simplified);
  std::optional<uint64_t> sourceCost = getIndexExprMaterializationCost(expr);
  std::optional<uint64_t> simplifiedCost =
      getIndexExprMaterializationCost(*simplified);
  llvm::outs() << "analysis-singleton-source-cost: ";
  if (sourceCost)
    llvm::outs() << *sourceCost;
  else
    llvm::outs() << "none";
  llvm::outs() << "\nanalysis-singleton-simplified-cost: ";
  if (simplifiedCost)
    llvm::outs() << *simplifiedCost;
  else
    llvm::outs() << "none";
  llvm::outs() << "\nanalysis-singleton-prefers-simplified: "
               << boolName(shouldUseSimplifiedIndexExpr(*simplified, expr))
               << "\n";
}

static void printMaterializationCost(sym::Store &store, StringRef label,
                                     StringRef text) {
  std::optional<uint64_t> cost =
      getIndexExprMaterializationCost(mustParseExpr(store, text));
  llvm::outs() << label << ": ";
  if (cost)
    llvm::outs() << *cost;
  else
    llvm::outs() << "none";
  llvm::outs() << "\n";
}

static void runMaterializationCostQueries(sym::Store &store) {
  printMaterializationCost(store, "material-cost-rational", "1/2");
  printMaterializationCost(store, "material-cost-nonpow2-floor",
                           "floor(1/3*x)");
  printMaterializationCost(store, "material-cost-wide-nonpow2-mod",
                           "Mod(x, 4294967297)");
  printMaterializationCost(store, "material-cost-nonpow2-exact", "1/3*x");
  printMaterializationCost(store, "material-cost-product-denominator-overflow",
                           "floor(Mod(1/4294967296*x, 3)*"
                           "Mod(1/4294967296*y, 3))");
  printMaterializationCost(store, "material-cost-piecewise",
                           "Piecewise((x, x >= 0), (0, True))");
  printMaterializationCost(store, "material-cost-pow2-floor", "floor(1/2*x)");
  printMaterializationCost(store, "material-cost-max-pow2-mod",
                           "Mod(x, 4294967296)");
}

void runAnalysisQueries(sym::Store &store, sym::ExprHandle x) {
  sym::PredHandle range =
      mustBuildAnalysisPred(sym::rangeAssumption(store, "x", 0, 31));
  sym::PredHandle multipleOfFour = mustParsePred(store, "Mod(x, 4) == 0");
  sym::PredHandle facts =
      mustBuildAnalysisPred(sym::composePredAnd(store, range, multipleOfFour));
  sym::PredHandle invalidFacts = mustBuildAnalysisPred(sym::composePredOr(
      store, mustParsePred(store, "x < 0"), mustParsePred(store, "x > 31")));
  runAnalysisCore(store, x, facts);
  runAnalysisRangeMutation(store, x);
  runAnalysisFactSubstitution(store, x, facts);
  runAnalysisBatchMutation(store, x);
  runAnalysisBatchClosure(store);
  runOrderedGridEquivalence(store);
  runAnalysisRejection(store, x, facts, invalidFacts);
  runSingletonFactSimplification(store);
  runMaterializationCostQueries(store);
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
  sym::ExprHandle literalDenominator = mustParseExpr(store, "floor(1/32*x)");
  sym::ExprHandle partial = mustParseExpr(store, "floor(1 / (x - 1))");
  sym::ExprHandle uncovered = mustParseExpr(store, "Piecewise((x, x < 16))");
  sym::ExprHandle symbolicMod = mustParseExpr(store, "Mod(x, m)");
  sym::PredHandle negativeDivisor = mustParsePred(store, "m < 0");
  sym::PredHandle positiveDivisor = mustParsePred(store, "m > 0");
  llvm::outs() << "defined-safe-div: "
               << boolName(sym::provablyDefined(store, safe, assumptions))
               << "\n";
  llvm::outs() << "defined-literal-denominator: "
               << boolName(sym::provablyDefined(store, literalDenominator, {}))
               << "\n";
  llvm::outs() << "defined-partial-div: "
               << boolName(sym::provablyDefined(store, partial, assumptions))
               << "\n";
  llvm::outs() << "defined-uncovered-piecewise: "
               << boolName(sym::provablyDefined(store, uncovered, assumptions))
               << "\n";
  llvm::outs() << "defined-mod-negative: "
               << boolName(sym::provablyDefined(store, symbolicMod,
                                                {negativeDivisor}))
               << "\n";
  llvm::outs() << "defined-mod-positive: "
               << boolName(sym::provablyDefined(store, symbolicMod,
                                                {positiveDivisor}))
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
  runAnalysisQueries(store, x);

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
