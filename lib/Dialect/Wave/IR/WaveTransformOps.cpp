//===- WaveTransformOps.cpp - Wave transform-dialect ops --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/Wave.h"

#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Dialect/Transform/IR/TransformOps.h"
#include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OwningOpRef.h"
#include "mlir/IR/SymbolTable.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include <limits>

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveTransformOps.cpp.inc"

using namespace mlir;

DiagnosedSilenceableFailure
wave::TransformGetIntAttrOp::apply(transform::TransformRewriter &rewriter,
                                   transform::TransformResults &results,
                                   transform::TransformState &state) {
  StringRef key = getAttrName();
  SmallVector<Attribute> values;
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto attr = target->getAttrOfType<IntegerAttr>(key);
    if (!attr)
      return emitDefiniteFailure()
             << "target op missing IntegerAttr `" << key << "`";
    values.push_back(attr);
  }
  results.setParams(cast<OpResult>(getResult()), values);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformGetIntAttrOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
}

DiagnosedSilenceableFailure
wave::TransformBindParamOp::apply(transform::TransformRewriter &rewriter,
                                  transform::TransformResults &results,
                                  transform::TransformState &state) {
  auto targets = state.getPayloadOps(getTarget());
  if (llvm::range_size(targets) != 1)
    return emitDefiniteFailure() << "expected exactly one target op, got "
                                 << llvm::range_size(targets);
  Operation *target = *targets.begin();
  auto mod = dyn_cast<ModuleOp>(target);
  if (!mod)
    return emitDefiniteFailure() << "target must be a `builtin.module` op";

  ArrayRef<Attribute> values = state.getParams(getValue());
  if (values.size() != 1)
    return emitDefiniteFailure()
           << "expected the value param to hold one attribute, got "
           << values.size();

  Builder builder(mod.getContext());
  Attribute valueAttr = values.front();
  if (TypeAttr resultTypeAttr = getResultTypeAttr()) {
    Type resultType = resultTypeAttr.getValue();
    if (!resultType.isIntOrIndex())
      return emitDefiniteFailure()
             << "`as` clause requires an integer or index type, got "
             << resultType;
    auto intAttr = dyn_cast<IntegerAttr>(valueAttr);
    if (!intAttr)
      return emitDefiniteFailure()
             << "`as` clause requires the value to be an IntegerAttr, got "
             << valueAttr;
    valueAttr = IntegerAttr::get(resultType, intAttr.getValue().getSExtValue());
  }
  StringAttr paramsName = builder.getStringAttr("wavemeta.params");
  StringAttr keyAttr = builder.getStringAttr(getAttrName());
  SmallVector<NamedAttribute> entries;
  if (auto existing = mod->getAttrOfType<DictionaryAttr>(paramsName)) {
    for (NamedAttribute na : existing) {
      if (na.getName() != keyAttr)
        entries.push_back(na);
    }
  }
  entries.emplace_back(keyAttr, valueAttr);
  mod->setAttr(paramsName, builder.getDictionaryAttr(entries));
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformBindParamOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::onlyReadsHandle(getValueMutable(), effects);
  transform::modifiesPayload(effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.tune
//===----------------------------------------------------------------------===//

namespace {

// Enumerate one variable's domain into a flat `int64_t` list.
static FailureOr<SmallVector<int64_t>>
expandDomain(Attribute domainAttr, Operation *errOp, StringAttr name) {
  if (auto e = dyn_cast<wave::TuneEnumAttr>(domainAttr))
    return SmallVector<int64_t>(e.getValues().begin(), e.getValues().end());
  if (auto r = dyn_cast<wave::TuneRangeAttr>(domainAttr)) {
    SmallVector<int64_t> result;
    for (int64_t v = r.getLower(); v < r.getUpper(); v += r.getStep())
      result.push_back(v);
    return result;
  }
  if (auto p = dyn_cast<wave::TunePow2InAttr>(domainAttr)) {
    SmallVector<int64_t> result;
    uint64_t v = 1;
    while (v < static_cast<uint64_t>(p.getLower()))
      v <<= 1;
    for (; v <= static_cast<uint64_t>(p.getUpper()); v <<= 1)
      result.push_back(static_cast<int64_t>(v));
    return result;
  }
  return errOp->emitError("unrecognized tune-var domain for `")
         << name.getValue() << "`";
}

// Walk the Cartesian product of `domains` in lex order (first variable
// is the slow axis). `out` receives one i64 vector per config.
static void enumerateCartesian(ArrayRef<SmallVector<int64_t>> domains,
                               SmallVector<SmallVector<int64_t>> &out) {
  size_t n = domains.size();
  if (n == 0) {
    out.emplace_back();
    return;
  }
  size_t total = 1;
  for (const auto &d : domains)
    total *= d.size();
  out.reserve(total);
  for (size_t k = 0; k < total; ++k) {
    SmallVector<int64_t> config(n);
    size_t rem = k;
    for (size_t i = n; i > 0; --i) {
      size_t idx = rem % domains[i - 1].size();
      config[i - 1] = domains[i - 1][idx];
      rem /= domains[i - 1].size();
    }
    out.push_back(std::move(config));
  }
}

// Run a `transform.named_sequence` with explicit block-argument bindings.
// Mirrors `IncludeOp::apply` minus the failure-propagation knobs.
//   `bindings[i]` is the mapping for the i-th block argument of `callee`.
//   `out` receives one mapping per terminator operand.
static DiagnosedSilenceableFailure
runNamedSequence(transform::TransformOpInterface caller,
                 transform::NamedSequenceOp callee,
                 MutableArrayRef<SmallVector<transform::MappedValue>> bindings,
                 transform::TransformState &state,
                 SmallVectorImpl<SmallVector<transform::MappedValue>> &out) {
  if (callee.isExternal())
    return caller.emitDefiniteFailure()
           << "named sequence `" << callee.getSymName()
           << "` is external; cannot invoke";
  Block &block = callee.getBody().front();
  if (block.getNumArguments() != bindings.size())
    return caller.emitDefiniteFailure()
           << "named sequence `" << callee.getSymName() << "` expects "
           << block.getNumArguments() << " arguments, got " << bindings.size();
  auto scope = state.make_region_scope(callee.getBody());
  for (auto &&[arg, mapping] :
       llvm::zip_equal(block.getArguments(), bindings)) {
    if (failed(state.mapBlockArgument(arg, mapping)))
      return DiagnosedSilenceableFailure::definiteFailure();
  }
  for (Operation &op : block.without_terminator()) {
    DiagnosedSilenceableFailure res =
        state.applyTransform(cast<transform::TransformOpInterface>(op));
    if (!res.succeeded())
      return res;
  }
  // Materialise mappings for the terminator operands.
  Operation *yield = block.getTerminator();
  transform::detail::prepareValueMappings(out, yield->getOperands(), state);
  return DiagnosedSilenceableFailure::success();
}

// Expand every `$variables` entry's domain. Definite-failure on bad or
// empty domain. Outputs in declared key order.
static DiagnosedSilenceableFailure
tuneCollectDomains(transform::TransformOpInterface op, DictionaryAttr variables,
                   SmallVectorImpl<StringAttr> &names,
                   SmallVectorImpl<SmallVector<int64_t>> &domains) {
  for (NamedAttribute na : variables) {
    FailureOr<SmallVector<int64_t>> dom =
        expandDomain(na.getValue(), op.getOperation(), na.getName());
    if (failed(dom))
      return DiagnosedSilenceableFailure::definiteFailure();
    if (dom->empty())
      return op.emitDefiniteFailure()
             << "tune variable `" << na.getName().getValue()
             << "` has an empty domain after expansion";
    names.push_back(na.getName());
    domains.push_back(std::move(*dom));
  }
  return DiagnosedSilenceableFailure::success();
}

// Build the per-variable `!transform.param<i64>` bindings for one config.
static SmallVector<SmallVector<transform::MappedValue>>
buildParamBindings(Builder &builder, ArrayRef<int64_t> config) {
  SmallVector<SmallVector<transform::MappedValue>> bindings(config.size());
  for (size_t i = 0; i < config.size(); ++i)
    bindings[i].push_back(
        static_cast<Attribute>(builder.getI64IntegerAttr(config[i])));
  return bindings;
}

enum class TrialStatus { Definite, Skip, Ok };

struct TrialOutcome {
  TrialStatus status = TrialStatus::Skip;
  OwningOpRef<ModuleOp> clone;
  int64_t score = 0;
  DiagnosedSilenceableFailure diag = DiagnosedSilenceableFailure::success();
};

// Helper: pull the i64 out of a score-sequence yield. Returns the score
// on success, or `failure()` after setting `out.diag` to a definite
// failure on a malformed yield.
static FailureOr<int64_t>
extractScore(transform::TransformOpInterface caller,
             ArrayRef<SmallVector<transform::MappedValue>> scoreOut,
             TrialOutcome &out) {
  if (scoreOut.size() != 1 || scoreOut[0].size() != 1) {
    out.status = TrialStatus::Definite;
    out.diag = caller.emitDefiniteFailure()
               << "score sequence must yield a single !transform.param<i64> "
                  "with one associated value";
    return failure();
  }
  auto scoreAttr = dyn_cast<IntegerAttr>(cast<Attribute>(scoreOut[0][0]));
  if (!scoreAttr) {
    out.status = TrialStatus::Definite;
    out.diag = caller.emitDefiniteFailure()
               << "score sequence must yield an IntegerAttr-shaped param";
    return failure();
  }
  return scoreAttr.getInt();
}

// Invoke `callee` and translate the three failure modes into a
// `TrialStatus`. `Ok` here just means "no failure"; the caller still
// needs to check terminator output if any.
static TrialStatus
invokeOrClassify(transform::TransformOpInterface caller,
                 transform::NamedSequenceOp callee,
                 MutableArrayRef<SmallVector<transform::MappedValue>> bindings,
                 transform::TransformState &state,
                 SmallVectorImpl<SmallVector<transform::MappedValue>> &out,
                 TrialOutcome &outcome) {
  DiagnosedSilenceableFailure r =
      runNamedSequence(caller, callee, bindings, state, out);
  if (r.isDefiniteFailure()) {
    outcome.status = TrialStatus::Definite;
    outcome.diag = std::move(r);
    return TrialStatus::Definite;
  }
  if (!r.succeeded()) {
    (void)r.silence();
    return TrialStatus::Skip;
  }
  return TrialStatus::Ok;
}

// Evaluate one trial: assumes-check, clone, body, score. On `Ok`, the
// outcome carries the clone and its score. `Skip` means a silenceable
// failure pruned this trial. `Definite` carries a propagating failure.
static TrialOutcome
runTrial(transform::TransformOpInterface caller, ModuleOp origModule,
         transform::NamedSequenceOp bodyCallee,
         transform::NamedSequenceOp scoreCallee,
         transform::NamedSequenceOp assumesCallee,
         MutableArrayRef<SmallVector<transform::MappedValue>> paramBindings,
         transform::TransformState &state) {
  TrialOutcome out;
  if (assumesCallee) {
    SmallVector<SmallVector<transform::MappedValue>> dummy;
    TrialStatus st = invokeOrClassify(caller, assumesCallee, paramBindings,
                                      state, dummy, out);
    if (st != TrialStatus::Ok)
      return out;
  }

  out.clone = cast<ModuleOp>(origModule->clone());

  SmallVector<SmallVector<transform::MappedValue>> bodyBindings;
  bodyBindings.reserve(1 + paramBindings.size());
  SmallVector<transform::MappedValue> targetMapping;
  targetMapping.push_back(static_cast<Operation *>(out.clone->getOperation()));
  bodyBindings.push_back(std::move(targetMapping));
  for (const SmallVector<transform::MappedValue> &m : paramBindings)
    bodyBindings.push_back(m);

  SmallVector<SmallVector<transform::MappedValue>> bodyOut;
  TrialStatus bst =
      invokeOrClassify(caller, bodyCallee, bodyBindings, state, bodyOut, out);
  if (bst != TrialStatus::Ok)
    return out;

  SmallVector<SmallVector<transform::MappedValue>> scoreOut;
  TrialStatus sst =
      invokeOrClassify(caller, scoreCallee, bodyBindings, state, scoreOut, out);
  if (sst != TrialStatus::Ok)
    return out;

  FailureOr<int64_t> sc = extractScore(caller, scoreOut, out);
  if (failed(sc))
    return out;
  out.score = *sc;
  out.status = TrialStatus::Ok;
  return out;
}

// Per-tune-op resolved callees.
struct TuneCallees {
  transform::NamedSequenceOp body;
  transform::NamedSequenceOp score;
  transform::NamedSequenceOp assumes; // May be null.
};

// Drive the enumeration loop: for each config, run one trial, track
// the winner. Definite failures propagate. `bestClone`/`bestScore`
// are valid only if `anyFeasible` flips to true.
static DiagnosedSilenceableFailure tuneRunAllTrials(
    transform::TransformOpInterface caller, ModuleOp orig,
    const TuneCallees &callees, ArrayRef<SmallVector<int64_t>> configs,
    Builder &builder, transform::TransformState &state,
    OwningOpRef<ModuleOp> &bestClone, int64_t &bestScore, bool &anyFeasible) {
  for (const SmallVector<int64_t> &config : configs) {
    SmallVector<SmallVector<transform::MappedValue>> paramBindings =
        buildParamBindings(builder, config);
    TrialOutcome o = runTrial(caller, orig, callees.body, callees.score,
                              callees.assumes, paramBindings, state);
    if (o.status == TrialStatus::Definite)
      return std::move(o.diag);
    if (o.status == TrialStatus::Skip)
      continue;
    if (!anyFeasible || o.score > bestScore) {
      bestClone = std::move(o.clone);
      bestScore = o.score;
    }
    anyFeasible = true;
  }
  return DiagnosedSilenceableFailure::success();
}

// Move the winner's non-transform contents into `orig`'s body and adopt
// its module-level attributes. Transform-dialect ops on both sides
// survive: orig still hosts the running interpreter.
static void installWinner(ModuleOp orig, ModuleOp winner) {
  Block &origBody = orig.getBodyRegion().front();
  Block &winBody = winner.getBodyRegion().front();
  auto isTransformOp = [](Operation &op) {
    Dialect *d = op.getDialect();
    return d && isa<transform::TransformDialect>(d);
  };
  for (Operation &op : llvm::make_early_inc_range(origBody)) {
    if (!isTransformOp(op))
      op.erase();
  }
  SmallVector<Operation *> toMove;
  for (Operation &op : winBody) {
    if (!isTransformOp(op))
      toMove.push_back(&op);
  }
  for (Operation *op : toMove)
    op->moveBefore(&origBody, origBody.end());
  // Clone's attrs >= orig's (clone started as a copy).
  orig->setAttrs(winner->getAttrs());
}

} // namespace

LogicalResult
wave::TransformTuneOp::verifySymbolUses(SymbolTableCollection &symbolTable) {
  auto checkExists = [&](SymbolRefAttr ref, StringRef role) -> LogicalResult {
    auto callee =
        symbolTable.lookupNearestSymbolFrom<transform::NamedSequenceOp>(
            getOperation(), ref);
    if (!callee)
      return emitOpError()
             << role << " symbol `" << ref
             << "` does not resolve to a transform.named_sequence";
    return success();
  };
  if (failed(checkExists(getBodyAttr(), "body")))
    return failure();
  if (failed(checkExists(getScoreAttr(), "score")))
    return failure();
  if (SymbolRefAttr assumes = getAssumesAttr())
    if (failed(checkExists(assumes, "assumes")))
      return failure();
  return success();
}

DiagnosedSilenceableFailure
wave::TransformTuneOp::apply(transform::TransformRewriter &rewriter,
                             transform::TransformResults &results,
                             transform::TransformState &state) {
  auto targets = state.getPayloadOps(getTarget());
  if (llvm::range_size(targets) != 1)
    return emitDefiniteFailure() << "expected exactly one target op, got "
                                 << llvm::range_size(targets);
  auto origModule = dyn_cast<ModuleOp>(*targets.begin());
  if (!origModule)
    return emitDefiniteFailure() << "target must be a `builtin.module` op";

  TuneCallees callees;
  callees.body =
      SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          getOperation(), getBodyAttr());
  callees.score =
      SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          getOperation(), getScoreAttr());
  if (SymbolRefAttr assumes = getAssumesAttr())
    callees.assumes =
        SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
            getOperation(), assumes);

  SmallVector<StringAttr> varNames;
  SmallVector<SmallVector<int64_t>> varDomains;
  if (DiagnosedSilenceableFailure r =
          tuneCollectDomains(*this, getVariables(), varNames, varDomains);
      !r.succeeded())
    return r;

  SmallVector<SmallVector<int64_t>> configs;
  enumerateCartesian(varDomains, configs);

  Builder builder(getContext());
  OwningOpRef<ModuleOp> bestClone;
  int64_t bestScore = std::numeric_limits<int64_t>::min();
  bool anyFeasible = false;
  if (DiagnosedSilenceableFailure r =
          tuneRunAllTrials(*this, origModule, callees, configs, builder, state,
                           bestClone, bestScore, anyFeasible);
      !r.succeeded())
    return r;
  if (!anyFeasible)
    return emitDefiniteFailure() << "no feasible tune trial";

  installWinner(origModule, *bestClone);
  results.set(cast<OpResult>(getWinner()), {origModule});
  results.setParams(cast<OpResult>(getBestScore()),
                    {builder.getI64IntegerAttr(bestScore)});
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformTuneOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}
