//===- WaveIndexMap.cpp - Private Wave index maps ------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveIndexMap.h"
#include "WaveIndexExpr.h"

#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringSet.h"

#include <cassert>

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::wave::indexing;

namespace {

static void setDiagnostic(std::string *diagnostic, const Twine &message) {
  if (diagnostic)
    *diagnostic = message.str();
}

static StringRef getName(sym::ExprHandle variable) {
  return sym::ExprView(variable).getSymbolName();
}

static void appendUnique(SmallVectorImpl<sym::PredHandle> &predicates,
                         sym::PredHandle predicate) {
  if (!llvm::is_contained(predicates, predicate))
    predicates.push_back(predicate);
}

static llvm::StringSet<> getDefinitionNames(const IndexMap &map) {
  llvm::StringSet<> names;
  for (const sym::ExprSubstitution &definition : map.definitions)
    names.insert(getName(definition.target));
  return names;
}

template <typename Handle>
static bool usesDefinition(Handle value, const llvm::StringSet<> &names) {
  bool used = false;
  sym::walkSymbolNames(value,
                       [&](StringRef name) { used |= names.contains(name); });
  return used;
}

static LogicalResult
appendCoordinateDomain(sym::Store &store, sym::ExprHandle coordinate,
                       std::optional<int64_t> extent,
                       SmallVectorImpl<sym::PredHandle> &predicates,
                       std::string *diagnostic) {
  if (!sym::isIntegerValued(coordinate)) {
    sym::ExprHandle integral = sym::composeExprFloor(store, coordinate);
    sym::PredHandle discrete =
        sym::composePredCmp(store, coordinate, sym::PredCmpOp::Eq, integral);
    appendUnique(predicates, discrete);
  }
  if (!extent)
    return success();
  sym::ExprHandle zero = sym::composeExprInt(store, 0);
  sym::ExprHandle limit = sym::composeExprInt(store, *extent);
  sym::PredHandle lower =
      sym::composePredCmp(store, coordinate, sym::PredCmpOp::Ge, zero);
  sym::PredHandle upper =
      sym::composePredCmp(store, coordinate, sym::PredCmpOp::Lt, limit);
  appendUnique(predicates, lower);
  appendUnique(predicates, upper);
  return success();
}

static const IndexMap::Input *findInput(const IndexMap &map,
                                        sym::ExprHandle variable);

static LogicalResult validateInputs(const IndexMap &map,
                                    llvm::StringSet<> &names,
                                    std::string *diagnostic) {
  llvm::DenseSet<Value> values;
  for (const IndexMap::Input &input : map.inputs) {
    StringRef name = getName(input.variable);
    if (name.empty() || !names.insert(name).second ||
        (input.extent && *input.extent <= 0) ||
        (input.value && !values.insert(input.value).second)) {
      setDiagnostic(diagnostic, "invalid index-map input");
      return failure();
    }
  }
  return success();
}

template <typename Handle>
static void noteClosedSymbols(Handle value, const llvm::StringSet<> &names,
                              bool &closed) {
  sym::walkSymbolNames(value,
                       [&](StringRef name) { closed &= names.contains(name); });
}

template <typename Range>
static void noteClosedSymbolsIn(Range &&values, const llvm::StringSet<> &names,
                                bool &closed) {
  for (auto value : values)
    noteClosedSymbols(value, names, closed);
}

static LogicalResult validateDefinitionTargets(const IndexMap &map,
                                               const llvm::StringSet<> &names,
                                               bool &closed,
                                               std::string *diagnostic) {
  llvm::DenseSet<sym::ExprHandle> definitions;
  for (const sym::ExprSubstitution &definition : map.definitions) {
    if (!definitions.insert(definition.target).second ||
        !llvm::is_contained(llvm::map_range(map.inputs,
                                            [](const IndexMap::Input &input) {
                                              return input.variable;
                                            }),
                            definition.target)) {
      setDiagnostic(diagnostic, "invalid index-map definition");
      return failure();
    }
    noteClosedSymbols(definition.target, names, closed);
    noteClosedSymbols(definition.replacement, names, closed);
  }
  return success();
}

static LogicalResult validateDefinitionValues(const IndexMap &map,
                                              std::string *diagnostic) {
  llvm::StringSet<> definitionNames = getDefinitionNames(map);
  for (const sym::ExprSubstitution &definition : map.definitions) {
    const IndexMap::Input *input = findInput(map, definition.target);
    if (!input || input->value ||
        usesDefinition(definition.replacement, definitionNames)) {
      setDiagnostic(diagnostic, "invalid recursive index-map definition");
      return failure();
    }
  }
  return success();
}

static LogicalResult validateMaterializedRequirements(const IndexMap &map,
                                                      std::string *diagnostic) {
  llvm::StringSet<> definitionNames = getDefinitionNames(map);
  for (sym::PredHandle requirement : map.requirements) {
    if (usesDefinition(requirement, definitionNames)) {
      setDiagnostic(diagnostic, "index-map requirement is not materialized");
      return failure();
    }
  }
  return success();
}

static LogicalResult validateClosed(const IndexMap &map,
                                    ArrayRef<sym::PredHandle> goals,
                                    std::string *diagnostic) {
  llvm::StringSet<> names;
  if (failed(validateInputs(map, names, diagnostic)))
    return failure();

  bool closed = true;
  noteClosedSymbolsIn(map.facts, names, closed);
  noteClosedSymbolsIn(map.requirements, names, closed);
  if (failed(validateDefinitionTargets(map, names, closed, diagnostic)) ||
      failed(validateDefinitionValues(map, diagnostic)) ||
      failed(validateMaterializedRequirements(map, diagnostic)))
    return failure();
  noteClosedSymbolsIn(map.exprs, names, closed);
  noteClosedSymbolsIn(goals, names, closed);
  if (!closed) {
    setDiagnostic(diagnostic, "index map contains an unbound symbol");
    return failure();
  }
  return success();
}

static const IndexMap::Input *findInput(const IndexMap &map,
                                        sym::ExprHandle variable) {
  auto found = llvm::find_if(map.inputs, [&](const IndexMap::Input &input) {
    return input.variable == variable;
  });
  return found == map.inputs.end() ? nullptr : &*found;
}

static const sym::ExprSubstitution *findDefinition(const IndexMap &map,
                                                   sym::ExprHandle variable) {
  auto found = llvm::find_if(map.definitions, [&](const auto &definition) {
    return definition.target == variable;
  });
  return found == map.definitions.end() ? nullptr : &*found;
}

struct PreparedDomain {
  SmallVector<sym::PredHandle, 8> facts;
  SmallVector<sym::PredHandle, 8> requirements;
};

static FailureOr<sym::PredHandle>
materializePredicate(sym::Store &store, const IndexMap &map,
                     sym::PredHandle predicate, std::string *diagnostic) {
  FailureOr<sym::ExprHandle> expression =
      materialize(store, map, sym::asExpr(predicate), diagnostic);
  std::optional<sym::PredHandle> material =
      failed(expression) ? std::nullopt : sym::asPred(*expression);
  if (!material) {
    setDiagnostic(diagnostic, "failed to materialize index-map predicate");
    return failure();
  }
  return *material;
}

static FailureOr<PreparedDomain>
prepareDomain(sym::Store &store, const IndexMap &map, std::string *diagnostic) {
  PreparedDomain domain;
  for (sym::PredHandle fact : map.facts) {
    FailureOr<sym::PredHandle> material =
        materializePredicate(store, map, fact, diagnostic);
    if (failed(material))
      return failure();
    appendUnique(domain.facts, *material);
  }
  for (const IndexMap::Input &input : map.inputs) {
    const sym::ExprSubstitution *definition =
        findDefinition(map, input.variable);
    if (!definition) {
      if (failed(appendCoordinateDomain(store, input.variable, input.extent,
                                        domain.facts, diagnostic)))
        return failure();
      continue;
    }
    FailureOr<sym::ExprHandle> replacement =
        materialize(store, map, definition->replacement, diagnostic);
    if (failed(replacement) ||
        failed(appendCoordinateDomain(store, *replacement, input.extent,
                                      domain.requirements, diagnostic)))
      return failure();
  }
  for (sym::PredHandle requirement : map.requirements) {
    FailureOr<sym::PredHandle> material =
        materializePredicate(store, map, requirement, diagnostic);
    if (failed(material))
      return failure();
    appendUnique(domain.requirements, *material);
  }
  return domain;
}

static FailureOr<sym::ExprHandle>
freshCoordinate(sym::Store &store, const IndexMap &map, StringRef scope,
                sym::ExprHandle source, std::string *diagnostic) {
  StringRef sourceName = getName(source);
  if (scope.empty() || sourceName.empty()) {
    setDiagnostic(diagnostic, "index-map relation needs named coordinates");
    return failure();
  }
  std::string stem = (Twine(scope) + "_" + sourceName).str();
  std::string name = stem;
  for (unsigned suffix = 0; llvm::any_of(
           map.inputs,
           [&](const auto &input) { return getName(input.variable) == name; });
       ++suffix)
    name = (Twine(stem) + "_" + Twine(suffix + 1)).str();
  return sym::composeExprSym(store, name);
}

static LogicalResult
validatePointDefinitions(const IndexMap &map,
                         ArrayRef<sym::ExprSubstitution> definitions,
                         std::string *diagnostic) {
  DenseSet<sym::ExprHandle> targets;
  for (const sym::ExprSubstitution &definition : definitions) {
    if (!findInput(map, definition.target) ||
        findDefinition(map, definition.target) ||
        !targets.insert(definition.target).second) {
      setDiagnostic(diagnostic, "invalid index-map point definition");
      return failure();
    }
  }
  return success();
}

struct PointDomain {
  IndexMap map;
  SmallVector<sym::ExprSubstitution> substitutions;
};

static PointDomain
buildPointDomain(const IndexMap &map,
                 ArrayRef<sym::ExprSubstitution> definitions) {
  PointDomain domain;
  for (const IndexMap::Input &input : map.inputs) {
    if (findDefinition(map, input.variable))
      continue;
    auto point = llvm::find_if(definitions, [&](const auto &definition) {
      return definition.target == input.variable;
    });
    sym::ExprHandle replacement =
        point == definitions.end() ? input.variable : point->replacement;
    domain.substitutions.push_back({input.variable, replacement});
    if (point == definitions.end())
      domain.map.inputs.push_back(input);
  }
  return domain;
}

static FailureOr<IndexMap>
specializeAtPoint(sym::Store &store, const IndexMap &map,
                  ArrayRef<sym::ExprHandle> expressions,
                  ArrayRef<sym::ExprSubstitution> definitions,
                  std::string *diagnostic) {
  IndexMap source = map;
  llvm::append_range(source.exprs, expressions);
  if (failed(validateClosed(source, {}, diagnostic)))
    return failure();
  source.exprs.clear();
  llvm::append_range(source.exprs, expressions);

  if (failed(validatePointDefinitions(map, definitions, diagnostic)))
    return failure();
  PointDomain domain = buildPointDomain(map, definitions);
  return pullback(store, source, domain.map, domain.substitutions, "point",
                  diagnostic);
}

static FailureOr<SmallVector<sym::ExprHandle>>
materializeExpressions(sym::Store &store, const IndexMap &map,
                       ArrayRef<sym::ExprHandle> expressions,
                       std::string *diagnostic) {
  SmallVector<sym::ExprHandle> materialized;
  materialized.reserve(expressions.size());
  for (sym::ExprHandle expression : expressions) {
    FailureOr<sym::ExprHandle> value =
        materialize(store, map, expression, diagnostic);
    if (failed(value))
      return failure();
    materialized.push_back(*value);
  }
  return materialized;
}

static LogicalResult
provePreparedRequirements(sym::Analysis &analysis,
                          ArrayRef<sym::PredHandle> requirements,
                          std::string *diagnostic) {
  for (sym::PredHandle requirement : requirements) {
    if (analysis.check(requirement) != sym::CheckResult::True) {
      setDiagnostic(diagnostic, "index-map requirement is not proven");
      return failure();
    }
  }
  return success();
}

static FailureOr<SmallVector<sym::ExprHandle>>
simplifyExpressions(sym::Analysis &analysis,
                    ArrayRef<sym::ExprHandle> expressions,
                    std::string *diagnostic) {
  SmallVector<sym::ExprHandle> simplified;
  simplified.reserve(expressions.size());
  for (sym::ExprHandle expression : expressions) {
    FailureOr<sym::ExprHandle> value =
        analysis.simplify(expression, diagnostic);
    if (failed(value))
      return failure();
    simplified.push_back(*value);
  }
  return simplified;
}

static LogicalResult
validatePullbackSubstitutions(const IndexMap &source,
                              ArrayRef<sym::ExprSubstitution> substitutions,
                              std::string *diagnostic) {
  size_t freeInputCount = llvm::count_if(source.inputs, [&](const auto &input) {
    return !findDefinition(source, input.variable);
  });
  if (substitutions.size() != freeInputCount) {
    setDiagnostic(diagnostic, "index-map pullback must bind every input once");
    return failure();
  }
  for (auto [index, substitution] : llvm::enumerate(substitutions)) {
    const IndexMap::Input *input = findInput(source, substitution.target);
    if (!input || findDefinition(source, input->variable) ||
        llvm::any_of(substitutions.take_front(index),
                     [&](const sym::ExprSubstitution &previous) {
                       return previous.target == substitution.target;
                     })) {
      setDiagnostic(diagnostic, "index-map pullback has an invalid input map");
      return failure();
    }
  }
  return success();
}

static LogicalResult appendDomainInputRestriction(
    sym::Store &store, IndexMap &result, const IndexMap::Input &sourceInput,
    const IndexMap::Input &domainInput, sym::ExprHandle coordinate,
    std::string *diagnostic) {
  if (!sourceInput.extent ||
      (domainInput.extent && *domainInput.extent <= *sourceInput.extent))
    return success();
  FailureOr<sym::ExprHandle> replacement =
      materialize(store, result, coordinate, diagnostic);
  if (failed(replacement))
    return failure();
  return appendCoordinateDomain(store, *replacement, sourceInput.extent,
                                result.requirements, diagnostic);
}

static LogicalResult appendFreeInputRelation(
    sym::Store &store, IndexMap &result, const IndexMap::Input &input,
    const sym::ExprSubstitution &substitution, StringRef scope,
    SmallVectorImpl<sym::ExprSubstitution> &relational,
    std::string *diagnostic) {
  auto domainInput = llvm::find_if(result.inputs, [&](const auto &candidate) {
    return candidate.variable == substitution.replacement;
  });
  if (domainInput != result.inputs.end()) {
    if (input.materializable && input.value &&
        domainInput->value == input.value)
      domainInput->materializable = true;
    relational.push_back(substitution);
    return appendDomainInputRestriction(store, result, input, *domainInput,
                                        substitution.replacement, diagnostic);
  }
  if (substitution.replacement == input.variable) {
    result.inputs.push_back(input);
    relational.push_back(substitution);
    return success();
  }

  FailureOr<sym::ExprHandle> coordinate =
      freshCoordinate(store, result, scope, input.variable, diagnostic);
  FailureOr<sym::ExprHandle> replacement =
      failed(coordinate)
          ? FailureOr<sym::ExprHandle>(failure())
          : materialize(store, result, substitution.replacement, diagnostic);
  if (failed(coordinate) || failed(replacement))
    return failure();
  result.inputs.push_back({*coordinate, input.extent, Value(), input.kind});
  result.definitions.push_back({*coordinate, *replacement});
  relational.push_back({input.variable, *coordinate});
  return appendCoordinateDomain(store, *replacement, input.extent,
                                result.requirements, diagnostic);
}

static LogicalResult buildFreeInputRelation(
    sym::Store &store, const IndexMap &source, IndexMap &result,
    ArrayRef<sym::ExprSubstitution> substitutions, StringRef scope,
    SmallVectorImpl<sym::ExprSubstitution> &relational,
    std::string *diagnostic) {
  for (const IndexMap::Input &input : source.inputs) {
    if (findDefinition(source, input.variable))
      continue;
    auto substitution = llvm::find_if(substitutions, [&](const auto &entry) {
      return entry.target == input.variable;
    });
    assert(substitution != substitutions.end() &&
           "pullback input validation must precede relation construction");
    if (failed(appendFreeInputRelation(store, result, input, *substitution,
                                       scope, relational, diagnostic)))
      return failure();
  }
  return success();
}

static LogicalResult
appendDefinedInputRelations(sym::Store &store, const IndexMap &source,
                            SmallVectorImpl<sym::ExprSubstitution> &relational,
                            std::string *diagnostic) {
  for (const IndexMap::Input &input : source.inputs) {
    const sym::ExprSubstitution *definition =
        findDefinition(source, input.variable);
    if (!definition)
      continue;
    sym::ExprHandle substituted =
        sym::substituteExpr(store, definition->replacement, relational);
    FailureOr<sym::ExprHandle> replacement =
        sym::simplifyExpr(store, substituted, diagnostic);
    if (failed(replacement))
      return failure();
    relational.push_back({input.variable, *replacement});
  }
  return success();
}

static LogicalResult
appendDefinitionRequirement(sym::Store &store, IndexMap &result,
                            const sym::ExprSubstitution &definition,
                            ArrayRef<sym::ExprSubstitution> relational,
                            std::string *diagnostic) {
  sym::ExprHandle target =
      sym::substituteExpr(store, definition.target, relational);
  sym::ExprHandle substituted =
      sym::substituteExpr(store, definition.replacement, relational);
  FailureOr<sym::ExprHandle> replacement =
      materialize(store, result, substituted, diagnostic);
  if (failed(replacement))
    return failure();

  if (const sym::ExprSubstitution *existing = findDefinition(result, target)) {
    sym::PredHandle consistent = sym::composePredCmp(
        store, existing->replacement, sym::PredCmpOp::Eq, *replacement);
    appendUnique(result.requirements, consistent);
    return success();
  }

  FailureOr<sym::ExprHandle> concreteTarget =
      materialize(store, result, target, diagnostic);
  if (failed(concreteTarget))
    return failure();
  sym::PredHandle consistent = sym::composePredCmp(
      store, *concreteTarget, sym::PredCmpOp::Eq, *replacement);
  appendUnique(result.requirements, consistent);
  return success();
}

static LogicalResult appendDefinitionRequirements(
    sym::Store &store, const IndexMap &source, IndexMap &result,
    ArrayRef<sym::ExprSubstitution> relational, std::string *diagnostic) {
  for (const sym::ExprSubstitution &definition : source.definitions) {
    if (failed(appendDefinitionRequirement(store, result, definition,
                                           relational, diagnostic)))
      return failure();
  }
  return success();
}

static FailureOr<sym::PredHandle>
remapPredicate(sym::Store &store, IndexMap &result, sym::PredHandle predicate,
               ArrayRef<sym::ExprSubstitution> relational,
               std::string *diagnostic) {
  sym::PredHandle remapped = sym::substitutePred(store, predicate, relational);
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, sym::asExpr(remapped), diagnostic);
  FailureOr<sym::ExprHandle> concrete =
      failed(simplified) ? FailureOr<sym::ExprHandle>(failure())
                         : materialize(store, result, *simplified, diagnostic);
  std::optional<sym::PredHandle> material =
      failed(concrete) ? std::nullopt : sym::asPred(*concrete);
  return material ? FailureOr<sym::PredHandle>(*material)
                  : FailureOr<sym::PredHandle>(failure());
}

static LogicalResult appendRemappedPredicates(
    sym::Store &store, IndexMap &result, ArrayRef<sym::PredHandle> predicates,
    ArrayRef<sym::ExprSubstitution> relational,
    SmallVectorImpl<sym::PredHandle> &destination, std::string *diagnostic) {
  for (sym::PredHandle predicate : predicates) {
    FailureOr<sym::PredHandle> material =
        remapPredicate(store, result, predicate, relational, diagnostic);
    if (failed(material))
      return failure();
    appendUnique(destination, *material);
  }
  return success();
}

static LogicalResult appendRemappedExpressions(
    sym::Store &store, const IndexMap &source, IndexMap &result,
    ArrayRef<sym::ExprSubstitution> relational, std::string *diagnostic) {
  result.exprs.reserve(source.exprs.size());
  for (sym::ExprHandle expr : source.exprs) {
    sym::ExprHandle remapped = sym::substituteExpr(store, expr, relational);
    FailureOr<sym::ExprHandle> simplified =
        sym::simplifyExpr(store, remapped, diagnostic);
    if (failed(simplified))
      return failure();
    result.exprs.push_back(*simplified);
  }
  return success();
}

} // namespace

struct mlir::wave::indexing::CheckMemo::Impl {
  struct Domain {
    SmallVector<sym::PredHandle, 8> facts;
    llvm::DenseMap<sym::PredHandle, sym::CheckResult> results;
  };

  Domain &getDomain(ArrayRef<sym::PredHandle> facts) {
    auto found = llvm::find_if(domains, [&](const Domain &domain) {
      return ArrayRef<sym::PredHandle>(domain.facts) == facts;
    });
    if (found != domains.end())
      return *found;
    domains.emplace_back();
    domains.back().facts.append(facts.begin(), facts.end());
    return domains.back();
  }

  SmallVector<Domain, 8> domains;
};

namespace {

static FailureOr<SmallVector<sym::PredHandle>>
materializeGoals(sym::Store &store, const IndexMap &map,
                 ArrayRef<sym::PredHandle> goals, std::string *diagnostic) {
  SmallVector<sym::PredHandle> materialized;
  materialized.reserve(goals.size());
  for (sym::PredHandle goal : goals) {
    FailureOr<sym::PredHandle> predicate =
        materializePredicate(store, map, goal, diagnostic);
    if (failed(predicate))
      return failure();
    appendUnique(materialized, *predicate);
  }
  return materialized;
}

class MemoizedDomainChecker {
public:
  MemoizedDomainChecker(
      sym::Store &store, ArrayRef<IndexMap::Input> inputs,
      ArrayRef<sym::PredHandle> facts,
      llvm::DenseMap<sym::PredHandle, sym::CheckResult> &results,
      std::string *diagnostic)
      : store(store), inputs(inputs), facts(facts), results(results),
        diagnostic(diagnostic) {}

  FailureOr<sym::CheckResult> prove(sym::PredHandle predicate) {
    auto cached = results.find(predicate);
    if (cached != results.end()) {
      setDiagnostic(diagnostic, "");
      return cached->second;
    }
    std::array<sym::ExprHandle, 1> expression{sym::asExpr(predicate)};
    SmallVector<sym::PredHandle> relevantFacts =
        selectIndexExprAnalysisFacts(expression, {}, facts);
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, relevantFacts, diagnostic);
    if (failed(analysis))
      return failure();
    sym::CheckResult checked = (*analysis)->check(predicate);
    if (checked == sym::CheckResult::Unknown)
      checked = proveFiniteInput(predicate, **analysis);
    results.try_emplace(predicate, checked);
    return checked;
  }

private:
  sym::CheckResult proveFiniteInput(sym::PredHandle predicate,
                                    sym::Analysis &analysis) {
    constexpr int64_t maxEnumeratedExtent = 8;
    for (const IndexMap::Input &input : inputs) {
      if (!input.extent || *input.extent <= 0 ||
          *input.extent > maxEnumeratedExtent)
        continue;
      std::optional<sym::CheckResult> common;
      bool unresolved = false;
      for (int64_t point = 0; point < *input.extent; ++point) {
        sym::ExprHandle value = sym::composeExprInt(store, point);
        std::array<sym::ExprSubstitution, 1> substitution{
            sym::ExprSubstitution{input.variable, value}};
        sym::PredHandle specialized =
            sym::substitutePred(store, predicate, substitution);
        sym::CheckResult checked = analysis.check(specialized);
        if (checked == sym::CheckResult::Unknown ||
            (common && checked != *common)) {
          unresolved = true;
          break;
        }
        common = checked;
      }
      if (!unresolved && common)
        return *common;
    }
    return sym::CheckResult::Unknown;
  }

  sym::Store &store;
  ArrayRef<IndexMap::Input> inputs;
  ArrayRef<sym::PredHandle> facts;
  llvm::DenseMap<sym::PredHandle, sym::CheckResult> &results;
  std::string *diagnostic;
};

static FailureOr<sym::CheckResult>
proveRequirements(MemoizedDomainChecker &checker,
                  ArrayRef<sym::PredHandle> requirements) {
  for (sym::PredHandle requirement : requirements) {
    FailureOr<sym::CheckResult> checked = checker.prove(requirement);
    if (failed(checked) || *checked != sym::CheckResult::True)
      return checked;
  }
  return sym::CheckResult::True;
}

static FailureOr<sym::CheckResult> proveGoals(MemoizedDomainChecker &checker,
                                              ArrayRef<sym::PredHandle> goals) {
  sym::CheckResult result = sym::CheckResult::True;
  for (sym::PredHandle goal : goals) {
    FailureOr<sym::CheckResult> checked = checker.prove(goal);
    if (failed(checked))
      return failure();
    if (*checked == sym::CheckResult::False)
      return sym::CheckResult::False;
    if (*checked == sym::CheckResult::Unknown)
      result = sym::CheckResult::Unknown;
  }
  return result;
}

} // namespace

mlir::wave::indexing::CheckMemo::CheckMemo() : impl(std::make_unique<Impl>()) {}
mlir::wave::indexing::CheckMemo::~CheckMemo() = default;

FailureOr<sym::ExprHandle>
mlir::wave::indexing::materialize(sym::Store &store, const IndexMap &map,
                                  sym::ExprHandle expression,
                                  std::string *diagnostic) {
  if (map.definitions.empty())
    return expression;
  sym::ExprHandle result =
      sym::substituteExpr(store, expression, map.definitions);
  return sym::simplifyExpr(store, result, diagnostic);
}

FailureOr<SmallVector<sym::ExprHandle>>
mlir::wave::indexing::simplify(sym::Store &store, const IndexMap &map,
                               ArrayRef<sym::ExprHandle> expressions,
                               ArrayRef<sym::ExprSubstitution> definitions,
                               std::string *diagnostic) {
  FailureOr<IndexMap> specialized =
      specializeAtPoint(store, map, expressions, definitions, diagnostic);
  if (failed(specialized) ||
      failed(validateClosed(*specialized, {}, diagnostic)))
    return failure();

  FailureOr<PreparedDomain> domain =
      prepareDomain(store, *specialized, diagnostic);
  if (failed(domain))
    return failure();

  FailureOr<SmallVector<sym::ExprHandle>> materialized = materializeExpressions(
      store, *specialized, specialized->exprs, diagnostic);
  if (failed(materialized))
    return failure();

  SmallVector<sym::PredHandle> relevantFacts = selectIndexExprAnalysisFacts(
      *materialized, domain->requirements, domain->facts);
  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(store, relevantFacts, diagnostic);
  if (failed(created))
    return failure();
  std::unique_ptr<sym::Analysis> analysis = std::move(*created);
  if (failed(provePreparedRequirements(*analysis, domain->requirements,
                                       diagnostic)))
    return failure();
  return simplifyExpressions(*analysis, *materialized, diagnostic);
}

FailureOr<sym::ExactDivideResult> mlir::wave::indexing::tryExactDivide(
    sym::Store &store, const IndexMap &map, sym::ExprHandle expression,
    int64_t divisor, ArrayRef<sym::PredHandle> assumptions,
    std::string *diagnostic) {
  SmallVector<sym::PredHandle> closedGoals(assumptions);
  if (failed(validateClosed(map, closedGoals, diagnostic)))
    return failure();

  FailureOr<PreparedDomain> domain = prepareDomain(store, map, diagnostic);
  FailureOr<sym::ExprHandle> materialized =
      materialize(store, map, expression, diagnostic);
  FailureOr<SmallVector<sym::PredHandle>> materializedAssumptions =
      materializeGoals(store, map, assumptions, diagnostic);
  if (failed(domain) || failed(materialized) || failed(materializedAssumptions))
    return failure();

  std::array<sym::ExprHandle, 1> expressions{*materialized};
  SmallVector<sym::PredHandle> relevantFacts = selectIndexExprAnalysisFacts(
      expressions, domain->requirements, domain->facts);
  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(store, relevantFacts, diagnostic);
  if (failed(created) || failed(provePreparedRequirements(
                             **created, domain->requirements, diagnostic)))
    return failure();
  FailureOr<std::unique_ptr<sym::Analysis>> structural =
      sym::Analysis::create(store, {}, diagnostic);
  if (failed(structural))
    return failure();
  sym::ExactDivideResult divided =
      (*structural)->tryExactDivide(*materialized, divisor);
  if (divided.status == sym::ExactDivideStatus::Proven ||
      divided.status == sym::ExactDivideStatus::NotExact)
    return divided;
  if (failed((*created)->assume(*materializedAssumptions, diagnostic)))
    return failure();
  return (*created)->tryExactDivide(*materialized, divisor);
}

FailureOr<IndexMap>
mlir::wave::indexing::pullback(sym::Store &store, const IndexMap &source,
                               const IndexMap &domain,
                               ArrayRef<sym::ExprSubstitution> substitutions,
                               StringRef scope, std::string *diagnostic) {
  if (failed(validatePullbackSubstitutions(source, substitutions, diagnostic)))
    return failure();

  IndexMap result = domain;
  result.exprs.clear();
  SmallVector<sym::ExprSubstitution> relational;
  relational.reserve(source.inputs.size());
  if (failed(buildFreeInputRelation(store, source, result, substitutions, scope,
                                    relational, diagnostic)) ||
      failed(
          appendDefinedInputRelations(store, source, relational, diagnostic)) ||
      failed(appendDefinitionRequirements(store, source, result, relational,
                                          diagnostic)) ||
      failed(appendRemappedPredicates(store, result, source.requirements,
                                      relational, result.requirements,
                                      diagnostic)) ||
      failed(appendRemappedPredicates(store, result, source.facts, relational,
                                      result.facts, diagnostic)) ||
      failed(appendRemappedExpressions(store, source, result, relational,
                                       diagnostic)))
    return failure();
  return result;
}

FailureOr<sym::CheckResult>
mlir::wave::indexing::check(sym::Store &store, const IndexMap &map,
                            ArrayRef<sym::PredHandle> goals,
                            std::string *diagnostic) {
  CheckMemo memo;
  return check(store, map, goals, memo, diagnostic);
}

FailureOr<sym::CheckResult>
mlir::wave::indexing::check(sym::Store &store, const IndexMap &map,
                            ArrayRef<sym::PredHandle> goals, CheckMemo &memo,
                            std::string *diagnostic) {
  if (failed(validateClosed(map, goals, diagnostic)))
    return failure();

  FailureOr<PreparedDomain> prepared = prepareDomain(store, map, diagnostic);
  if (failed(prepared))
    return failure();

  FailureOr<SmallVector<sym::PredHandle>> materialized =
      materializeGoals(store, map, goals, diagnostic);
  if (failed(materialized))
    return failure();

  SmallVector<sym::ExprHandle> goalExpressions;
  goalExpressions.reserve(materialized->size());
  for (sym::PredHandle goal : *materialized)
    goalExpressions.push_back(sym::asExpr(goal));
  SmallVector<sym::PredHandle> relevantFacts = selectIndexExprAnalysisFacts(
      goalExpressions, prepared->requirements, prepared->facts);
  CheckMemo::Impl::Domain &domain = memo.impl->getDomain(relevantFacts);
  MemoizedDomainChecker checker(store, map.inputs, relevantFacts,
                                domain.results, diagnostic);
  FailureOr<sym::CheckResult> required =
      proveRequirements(checker, prepared->requirements);
  if (failed(required) || *required != sym::CheckResult::True)
    return required;
  return proveGoals(checker, *materialized);
}
