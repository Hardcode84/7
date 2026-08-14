//===- WaveLowerSymbolicMemory.cpp - lower symbolic memory -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "../IR/WaveIndexExpr.h"
#include "../IR/WaveIndexMap.h"
#include "../IR/WaveMemoryAddress.h"
#include "WaveMemoryTransactionProvider.h"
#include "WaveSymbolicMemoryPreparation.h"
#include "WaveSymbolicTransformTiming.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/MathExtras.h"
#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <memory>
#include <optional>
#include <string>
#include <type_traits>
#include <vector>
namespace mlir::wave {
#define GEN_PASS_DEF_WAVELOWERSYMBOLICMEMORY
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave
using namespace mlir;
using namespace mlir::wave;
using namespace mlir::wave::symbolic_memory;
namespace {
template <typename T, typename Fn>
static FailureOr<T> runDiagnosed(Operation *anchor, StringRef message,
                                 Fn &&function) {
  bool emitted = false;
  ScopedDiagnosticHandler handler(anchor->getContext(), [&](Diagnostic &diag) {
    emitted |= diag.getSeverity() == DiagnosticSeverity::Error;
    return failure();
  });
  FailureOr<T> result = function();
  if (failed(result) && !emitted)
    anchor->emitOpError(message);
  return result;
}
using Address = MemoryTransactionAddress;
struct Transaction : MemoryTransaction {
  SmallVector<SmallVector<unsigned, 2>, 4> outputs;
  sym::ExprHandle outputSlot;
  sym::PredHandle active;
  Value condition;
  std::shared_ptr<const wave::memory_lowering::GatherTransactionEmitter>
      gatherEmitter;
};
struct Layout : MemoryTransactionLayout {
  std::shared_ptr<const wave::memory_lowering::GatherTransactionEmitter>
      emitter;
};
struct DmaTransaction {
  Transaction source, destination;
};
struct DmaPlan {
  std::vector<DmaTransaction> transactions;
  std::shared_ptr<const wave::memory_lowering::CopyTransactionEmitter> emitter;
  int64_t bytes = 0;
  bool zeroFillInactive = false;
  sym::ExprHandle readFirstOrigin, readFirstParameter;
};
static FailureOr<bool>
proveActivityEquivalent(sym::Store &store, const indexing::IndexMap &proofMap,
                        sym::PredHandle lhs, sym::PredHandle rhs,
                        int64_t alignment, indexing::CheckMemo &memo);
template <typename OpTy> static MemoryAccess getAccess(OpTy op) {
  MemoryAccess access;
  access.op = op;
  llvm::append_range(access.bases, op.getBases());
  llvm::append_range(access.bindings, op.getBindings());
  for (Attribute name : op.getBindingNames())
    access.bindingNames.push_back(cast<StringAttr>(name).getValue().str());
  access.mapping = op.getMapping();
  access.packetType = cast<SimdType>(op.getValue().getType());
  access.dependency = op.getDependency();
  access.cache = op.getCacheAttr();
  access.tokenType = op.getToken().getType();
  if constexpr (std::is_same_v<OpTy, GatherOp>)
    access.gather = true;
  else
    access.packet = op.getValue();
  return access;
}
static FailureOr<sym::ExprHandle> composeIntBinary(sym::Store &store,
                                                   sym::ExprHandle lhs,
                                                   sym::ExprBinaryOp operation,
                                                   int64_t rhs) {
  FailureOr<sym::ExprHandle> value = sym::composeExprInt(store, rhs);
  if (failed(value))
    return failure();
  return sym::composeExprBinary(store, lhs, operation, *value);
}
static FailureOr<sym::ExprHandle>
buildTransactionSlot(const FailureOr<sym::ExprHandle> &group,
                     const FailureOr<sym::ExprHandle> &within,
                     const FailureOr<sym::ExprHandle> &first, int64_t width,
                     sym::Store &store) {
  FailureOr<sym::ExprHandle> groupBase =
      failed(group)
          ? FailureOr<sym::ExprHandle>(failure())
          : composeIntBinary(store, *group, sym::ExprBinaryOp::Mul, width);
  FailureOr<sym::ExprHandle> local =
      failed(groupBase) || failed(within)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, *groupBase, sym::ExprBinaryOp::Add,
                                   *within);
  return failed(first) || failed(local)
             ? FailureOr<sym::ExprHandle>(failure())
             : sym::composeExprBinary(store, *first, sym::ExprBinaryOp::Add,
                                      *local);
}
static LogicalResult specializeTransactionLayout(const AccessMap &access,
                                                 Layout &layout,
                                                 sym::Store &store) {
  if (access.transactionFirstSlot == 0)
    return success();
  FailureOr<sym::ExprHandle> group =
      layout.group ? FailureOr<sym::ExprHandle>(layout.group)
                   : sym::composeExprSym(store, "group");
  FailureOr<sym::ExprHandle> within =
      layout.within ? FailureOr<sym::ExprHandle>(layout.within)
                    : sym::composeExprSym(store, "within");
  FailureOr<sym::ExprHandle> first =
      sym::composeExprInt(store, access.transactionFirstSlot);
  FailureOr<sym::ExprHandle> slot =
      buildTransactionSlot(group, within, first, layout.width, store);
  if (failed(group) || failed(within) || failed(slot))
    return failure();
  layout.group = *group;
  layout.within = *within;
  layout.slot = *slot;
  return success();
}
static FailureOr<std::optional<Transaction>> buildTransaction(
    const AccessMap &access, Layout layout, sym::Store &store,
    indexing::CheckMemo &memo,
    std::optional<MemoryTransactionProjection> projection = std::nullopt,
    int64_t windowBytes = 0) {
  if (failed(specializeTransactionLayout(access, layout, store)))
    return failure();
  FailureOr<sym::ExprHandle> activity =
      composeIndexExprIndicator(store, access.address.active);
  if (failed(activity))
    return failure();
  MemoryTransactionRequest request;
  request.access = {access.address,
                    access.access->bases,
                    access.proofDefinitions,
                    access.baseSelector,
                    *activity,
                    access.axes.block,
                    access.axes.slot,
                    access.axes.item,
                    access.axes.itemValue,
                    access.transactionSlotCount,
                    access.shape.elementBits};
  request.layout = layout;
  request.projection = projection;
  request.windowBytes = windowBytes;
  FailureOr<std::optional<MemoryTransaction>> planned =
      planMemoryTransaction(store, std::move(request), memo);
  if (failed(planned))
    return failure();
  if (!*planned)
    return std::optional<Transaction>{};
  Transaction result;
  static_cast<MemoryTransaction &>(result) = std::move(**planned);
  FailureOr<sym::ExprHandle> materialActive = indexing::materialize(
      store, result.map, sym::asExpr(access.address.active));
  std::optional<sym::PredHandle> active =
      failed(materialActive) ? std::nullopt : sym::asPred(*materialActive);
  if (!active)
    return failure();
  result.active = *active;
  result.outputSlot = result.slot;
  result.condition = access.condition;
  result.gatherEmitter = std::move(layout.emitter);
  return std::optional<Transaction>{std::move(result)};
}
static FailureOr<sym::ExprHandle>
specializeTransactionExpression(sym::Store &store, sym::ExprHandle expression,
                                ArrayRef<sym::ExprSubstitution> substitutions) {
  FailureOr<sym::ExprHandle> result =
      sym::substituteExpr(store, expression, substitutions);
  return failed(result) ? FailureOr<sym::ExprHandle>(failure())
                        : sym::simplifyExpr(store, *result);
}
static LogicalResult instantiateTransactionActivity(
    Transaction &instantiated, const Transaction &transaction,
    ArrayRef<sym::ExprSubstitution> selectGroup, sym::Store &store) {
  FailureOr<sym::ExprHandle> activity =
      specializeTransactionExpression(store, transaction.activity, selectGroup);
  if (failed(activity))
    return failure();
  instantiated.activity = *activity;
  if (sym::getIntegerLiteralValue(*activity))
    return success();
  FailureOr<sym::PredHandle> active =
      sym::substitutePred(store, transaction.active, selectGroup);
  if (failed(active))
    return failure();
  instantiated.active = *active;
  return success();
}
static LogicalResult instantiateTransactionAddresses(
    Transaction &instantiated, const Transaction &transaction,
    ArrayRef<sym::ExprSubstitution> selectGroup, sym::Store &store) {
  for (auto [source, target] :
       llvm::zip(transaction.addresses, instantiated.addresses)) {
    FailureOr<sym::ExprHandle> owner =
        specializeTransactionExpression(store, source.owner, selectGroup);
    FailureOr<sym::ExprHandle> selector = specializeTransactionExpression(
        store, source.baseSelector, selectGroup);
    FailureOr<sym::ExprHandle> bitOffset =
        specializeTransactionExpression(store, source.bitOffset, selectGroup);
    FailureOr<sym::ExprHandle> offset = specializeTransactionExpression(
        store, source.elementOffset, selectGroup);
    if (failed(owner) || failed(selector) || failed(bitOffset) ||
        failed(offset))
      return failure();
    std::optional<int64_t> base = sym::getIntegerLiteralValue(*selector);
    if (base &&
        (*base < 0 || *base >= static_cast<int64_t>(source.bases.size())))
      return failure();
    target.owner = *owner;
    target.baseSelector = *selector;
    target.bitOffset = *bitOffset;
    target.elementOffset = *offset;
  }
  return success();
}
static LogicalResult instantiateTransactionOutputs(
    Transaction &instantiated, const Transaction &transaction,
    const AccessMap &access, sym::ExprHandle group, sym::Store &store) {
  for (int64_t index = 0; index < transaction.width; ++index) {
    FailureOr<sym::ExprHandle> within = sym::composeExprInt(store, index);
    if (failed(within))
      return failure();
    std::array<sym::ExprSubstitution, 2> point{
        sym::ExprSubstitution{transaction.group, group},
        sym::ExprSubstitution{transaction.within, *within}};
    FailureOr<sym::ExprHandle> output =
        specializeTransactionExpression(store, transaction.outputSlot, point);
    std::optional<int64_t> slot =
        failed(output) ? std::nullopt : sym::getIntegerLiteralValue(*output);
    if (!slot || *slot < 0 || *slot >= access.shape.slotCount)
      return failure();
    instantiated.outputs.push_back(
        SmallVector<unsigned, 2>{static_cast<unsigned>(*slot)});
  }
  return success();
}
static FailureOr<Transaction>
instantiateTransaction(const AccessMap &access, const Transaction &transaction,
                       int64_t groupIndex, bool buildOutputs,
                       sym::Store &store) {
  FailureOr<sym::ExprHandle> group = sym::composeExprInt(store, groupIndex);
  if (failed(group))
    return failure();
  std::array<sym::ExprSubstitution, 1> selectGroup{
      sym::ExprSubstitution{transaction.group, *group}};
  Transaction instantiated = transaction;
  instantiated.outputs.clear();
  if (failed(instantiateTransactionActivity(instantiated, transaction,
                                            selectGroup, store)) ||
      failed(instantiateTransactionAddresses(instantiated, transaction,
                                             selectGroup, store)))
    return failure();
  if (buildOutputs && failed(instantiateTransactionOutputs(
                          instantiated, transaction, access, *group, store)))
    return failure();
  return instantiated;
}
static bool samePhysicalAddress(const Address &left, const Address &right) {
  return left.bases == right.bases && left.owner == right.owner &&
         left.baseSelector == right.baseSelector &&
         left.bitOffset == right.bitOffset &&
         left.elementOffset == right.elementOffset &&
         left.unitBits == right.unitBits;
}
static bool samePhysicalTransaction(const Transaction &lhs,
                                    const Transaction &rhs) {
  if (lhs.gatherEmitter != rhs.gatherEmitter || lhs.width != rhs.width ||
      !(lhs.activity == rhs.activity) ||
      lhs.addresses.size() != rhs.addresses.size() ||
      lhs.outputs.size() != rhs.outputs.size())
    return false;
  return llvm::all_of(llvm::zip(lhs.addresses, rhs.addresses), [](auto pair) {
    return samePhysicalAddress(std::get<0>(pair), std::get<1>(pair));
  });
}
static bool hasSameInactiveValue(const AccessMap &access,
                                 const Transaction &lhs,
                                 const Transaction &rhs) {
  if (access.access->inactiveComponents.empty())
    return true;
  return llvm::all_of(llvm::zip(lhs.outputs, rhs.outputs), [&](auto pair) {
    ArrayRef<unsigned> left = std::get<0>(pair);
    ArrayRef<unsigned> right = std::get<1>(pair);
    Value fallback = access.access->inactiveComponents[left[0]];
    return llvm::all_of(left,
                        [&](unsigned output) {
                          return access.access->inactiveComponents[output] ==
                                 fallback;
                        }) &&
           llvm::all_of(right, [&](unsigned output) {
             return access.access->inactiveComponents[output] == fallback;
           });
  });
}
static void appendTransaction(const AccessMap &access,
                              std::vector<Transaction> &plan,
                              Transaction transaction) {
  if (access.access->gather) {
    auto existing = llvm::find_if(plan, [&](const Transaction &candidate) {
      return samePhysicalTransaction(candidate, transaction) &&
             hasSameInactiveValue(access, candidate, transaction);
    });
    if (existing != plan.end()) {
      for (auto [aliases, outputs] :
           llvm::zip(existing->outputs, transaction.outputs))
        llvm::append_range(aliases, outputs);
      return;
    }
  }
  plan.push_back(std::move(transaction));
}
static FailureOr<std::optional<std::vector<Transaction>>>
buildTransactionFamily(const AccessMap &access, Layout layout,
                       sym::Store &store, indexing::CheckMemo &memo) {
  std::vector<Transaction> result;
  int64_t groupCount = layout.groupCount
                           ? layout.groupCount
                           : access.transactionSlotCount / layout.width;
  layout.groupCount = groupCount;
  FailureOr<std::optional<Transaction>> family =
      buildTransaction(access, layout, store, memo);
  if (failed(family))
    return failure();
  if (!*family)
    return std::optional<std::vector<Transaction>>{};
  for (int64_t group = 0; group < groupCount; ++group) {
    FailureOr<Transaction> instantiated =
        instantiateTransaction(access, **family, group, true, store);
    if (failed(instantiated))
      return failure();
    appendTransaction(access, result, std::move(*instantiated));
  }
  return std::optional<std::vector<Transaction>>{std::move(result)};
}
static FailureOr<std::vector<Transaction>>
planTransactions(const AccessMap &access, sym::Store &store,
                 std::string &diagnostic);
static bool hasLegalTransactionPayload(const AccessMap &access, int64_t width) {
  std::optional<int64_t> bits =
      llvm::checkedMul(width, access.shape.elementBits);
  return bits && (*bits == 16 || *bits % 32 == 0);
}
static SmallVector<wave::memory_lowering::GatherTransaction, 2>
selectGatherTransactions(const AccessMap &access) {
  if (!access.access->gather || access.access->packetWhere)
    return {};
  std::optional<int64_t> itemCount;
  if (access.axes.item) {
    auto input =
        llvm::find_if(access.address.map.inputs, [&](const auto &entry) {
          return entry.variable == *access.axes.item;
        });
    if (input != access.address.map.inputs.end())
      itemCount = input->extent;
  }
  wave::memory_lowering::GatherTransactionRequest request;
  request.bases = access.access->bases;
  request.op = access.access->op;
  request.resultType = access.access->packetType;
  request.cache = access.access->cache;
  request.item = access.axes.item.value_or(sym::ExprHandle{});
  request.slot = access.axes.slot;
  request.itemCount = itemCount;
  request.address = &access.address;
  return wave::memory_lowering::getGatherTransactions(request);
}

static FailureOr<std::optional<std::vector<Transaction>>>
planVerifiedGatherTransaction(
    const AccessMap &access,
    const wave::memory_lowering::GatherTransaction &target, sym::Store &store,
    indexing::CheckMemo &memo) {
  std::vector<Transaction> result;
  for (const auto &address : target.verifiedAddresses) {
    FailureOr<sym::ExprHandle> within = sym::composeExprSym(store, "within");
    FailureOr<sym::ExprHandle> first =
        sym::composeExprInt(store, address.firstSlot);
    FailureOr<sym::ExprHandle> slot =
        failed(within) || failed(first)
            ? FailureOr<sym::ExprHandle>(failure())
            : sym::composeExprBinary(store, *first, sym::ExprBinaryOp::Add,
                                     *within);
    if (failed(within) || failed(first) || failed(slot))
      return failure();
    Layout selected;
    selected.within = *within;
    selected.slot = *slot;
    selected.originSlot = *first;
    selected.verifiedBitOffset = address.bitOffset;
    selected.bitOffsetRelationVerified = true;
    selected.width = target.width;
    selected.groupCount = 1;
    selected.emitter = target.emitter;
    FailureOr<std::optional<std::vector<Transaction>>> transaction =
        buildTransactionFamily(access, selected, store, memo);
    if (failed(transaction))
      return failure();
    if (!*transaction)
      return std::optional<std::vector<Transaction>>{};
    for (Transaction &part : **transaction)
      appendTransaction(access, result, std::move(part));
  }
  return std::optional<std::vector<Transaction>>{std::move(result)};
}
static FailureOr<std::optional<std::vector<Transaction>>>
planSelectedGatherTransactions(
    const AccessMap &access,
    ArrayRef<wave::memory_lowering::GatherTransaction> targets,
    sym::Store &store, indexing::CheckMemo &memo) {
  int64_t count = access.transactionSlotCount;
  for (const wave::memory_lowering::GatherTransaction &target : targets) {
    if (target.width <= 1 || count % target.width)
      continue;
    if (!target.verifiedAddresses.empty()) {
      FailureOr<std::optional<std::vector<Transaction>>> transactions =
          planVerifiedGatherTransaction(access, target, store, memo);
      if (failed(transactions) || *transactions)
        return transactions;
      continue;
    }
    Layout selected;
    selected.pointItem = target.sourceItem;
    selected.originItem = target.originItem;
    selected.originSlot = target.originSlot;
    selected.displacement = target.intraBits;
    selected.width = target.width;
    selected.emitter = target.emitter;
    FailureOr<std::optional<std::vector<Transaction>>> transactions =
        buildTransactionFamily(access, selected, store, memo);
    if (failed(transactions) || *transactions)
      return transactions;
  }
  return std::optional<std::vector<Transaction>>{};
}
static FailureOr<std::optional<std::vector<Transaction>>>
planSplitTransaction(const AccessMap &access, sym::Store &store,
                     std::string &diagnostic) {
  int64_t count = access.transactionSlotCount;
  if (hasLegalTransactionPayload(access, count))
    return std::optional<std::vector<Transaction>>{};
  int64_t prefix = count - 1;
  while (prefix > 0 && !hasLegalTransactionPayload(access, prefix))
    --prefix;
  if (prefix <= 0)
    return std::optional<std::vector<Transaction>>{};
  AccessMap head = access;
  head.transactionSlotCount = prefix;
  AccessMap tail = access;
  tail.transactionFirstSlot += prefix;
  tail.transactionSlotCount -= prefix;
  FailureOr<std::vector<Transaction>> headPlan =
      planTransactions(head, store, diagnostic);
  FailureOr<std::vector<Transaction>> tailPlan =
      planTransactions(tail, store, diagnostic);
  if (failed(headPlan) || failed(tailPlan))
    return failure();
  std::vector<Transaction> combined;
  for (Transaction &transaction : *headPlan)
    appendTransaction(access, combined, std::move(transaction));
  for (Transaction &transaction : *tailPlan)
    appendTransaction(access, combined, std::move(transaction));
  return std::optional<std::vector<Transaction>>{std::move(combined)};
}
static FailureOr<std::optional<std::vector<Transaction>>>
planNaturalTransactions(const AccessMap &access, sym::Store &store,
                        indexing::CheckMemo &memo) {
  int64_t count = access.transactionSlotCount;
  for (int64_t width = count; width > 1; --width) {
    if (count % width || !hasLegalTransactionPayload(access, width))
      continue;
    Layout natural;
    natural.width = width;
    FailureOr<std::optional<std::vector<Transaction>>> transactions =
        buildTransactionFamily(access, natural, store, memo);
    if (failed(transactions) || *transactions) {
      return transactions;
    }
  }
  return std::optional<std::vector<Transaction>>{};
}
static FailureOr<std::vector<Transaction>>
planTransactions(const AccessMap &access, sym::Store &store,
                 std::string &diagnostic) {
  indexing::CheckMemo memo;
  SmallVector<wave::memory_lowering::GatherTransaction, 2> targets =
      selectGatherTransactions(access);
  FailureOr<std::optional<std::vector<Transaction>>> selected =
      planSelectedGatherTransactions(access, targets, store, memo);
  if (failed(selected))
    return failure();
  if (*selected)
    return std::move(**selected);
  FailureOr<std::optional<std::vector<Transaction>>> split =
      planSplitTransaction(access, store, diagnostic);
  if (failed(split))
    return failure();
  if (*split)
    return std::move(**split);
  // Ordinary layout: slot = group * V + within. Proof selects the largest
  // legal fiber; V = 1 is the same map with a singleton within domain.
  FailureOr<std::optional<std::vector<Transaction>>> natural =
      planNaturalTransactions(access, store, memo);
  if (failed(natural))
    return failure();
  if (*natural)
    return std::move(**natural);
  Layout scalar;
  FailureOr<std::optional<std::vector<Transaction>>> points =
      buildTransactionFamily(access, scalar, store, memo);
  if (failed(points) || !*points) {
    diagnostic = "mapping is not a byte-addressable local memory point";
    return failure();
  }
  return std::move(**points);
}
static SimdType getTransactionType(const MemoryAccess &access, int64_t length) {
  auto packet = cast<VectorType>(access.packetType.getElementType());
  Type element = packet.getElementType();
  if (length > 1)
    element = VectorType::get({length}, element);
  return SimdType::get(access.op->getContext(), element,
                       access.packetType.getWidth());
}
static Value joinTokens(IRRewriter &rewriter, const MemoryAccess &access,
                        ValueRange tokens) {
  if (tokens.size() == 1)
    return tokens.front();
  return JoinOp::create(rewriter, access.op->getLoc(), access.tokenType,
                        tokens);
}
struct Activity {
  Value condition;
  bool inactive = false;
};
static FailureOr<Activity>
materializeActivity(IRRewriter &rewriter, const AccessMap &access,
                    const Transaction &checked,
                    MemoryTransactionAddressMaterializer &materializer) {
  if (std::optional<int64_t> literal =
          sym::getIntegerLiteralValue(checked.activity))
    return Activity{{}, *literal == 0};
  if (checked.condition)
    return Activity{checked.condition, false};
  FailureOr<Value> condition =
      materializer.materializePredicate(checked, checked.active);
  if (failed(condition))
    return failure();
  Value materialized = *condition;
  if (!isa<MaskType>(materialized.getType())) {
    if (!materialized.getType().isInteger(1))
      return failure();
    Type mask = MaskType::get(access.access->op->getContext(),
                              access.access->packetType.getWidth());
    Value trueMask = ConstantOp::create(rewriter, access.getLoc(), mask,
                                        rewriter.getBoolAttr(true));
    Value falseMask = ConstantOp::create(rewriter, access.getLoc(), mask,
                                         rewriter.getBoolAttr(false));
    materialized = SelectOp::create(rewriter, access.getLoc(), mask,
                                    materialized, trueMask, falseMask);
  }
  return Activity{materialized, false};
}
template <typename ActiveFn, typename InactiveFn>
static FailureOr<SmallVector<Value>>
emitConditional(IRRewriter &rewriter, const AccessMap &access,
                const Transaction &checked,
                MemoryTransactionAddressMaterializer &materializer,
                TypeRange resultTypes, ActiveFn active, InactiveFn inactive) {
  FailureOr<Activity> activity =
      materializeActivity(rewriter, access, checked, materializer);
  if (failed(activity))
    return failure();
  if (activity->inactive)
    return inactive();
  if (!activity->condition)
    return active();
  FailureOr<SmallVector<Value>> inactiveValues = inactive();
  if (failed(inactiveValues))
    return failure();
  WhereOp where = WhereOp::create(rewriter, access.getLoc(), resultTypes,
                                  activity->condition);
  Block &thenBlock = where.getThenRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&thenBlock);
  FailureOr<SmallVector<Value>> activeValues = active();
  if (failed(activeValues))
    return failure();
  YieldOp::create(rewriter, access.getLoc(), *activeValues);
  Block &elseBlock = where.getElseRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&elseBlock);
  YieldOp::create(rewriter, access.getLoc(), *inactiveValues);
  rewriter.setInsertionPointAfter(where);
  return SmallVector<Value>(where.getResults());
}
static SmallVector<Value> collectTransactionValues(const Transaction &checked,
                                                   ArrayRef<Value> components,
                                                   bool aliasedOutputs) {
  SmallVector<Value> values;
  for (ArrayRef<unsigned> outputs : checked.outputs) {
    assert(!outputs.empty() && (aliasedOutputs || outputs.size() == 1) &&
           "generic stores have one logical output");
    Value value = components[outputs.front()];
    assert((!aliasedOutputs || llvm::all_of(outputs,
                                            [&](unsigned output) {
                                              return components[output] ==
                                                     value;
                                            })) &&
           "aliased outputs must have one inactive value");
    values.push_back(value);
  }
  return values;
}
static Value findCachedTransactionValue(
    Type type, ArrayRef<Value> values,
    SmallVectorImpl<std::pair<SmallVector<Value>, Value>> *cache) {
  if (!cache)
    return {};
  for (auto &[cachedValues, cachedValue] : *cache)
    if (cachedValue.getType() == type && cachedValues == values)
      return cachedValue;
  return {};
}
static bool isScalarizedPacket(const AccessMap &access, Type component) {
  if (access.access->gather || !access.access->packet)
    return false;
  PackOp sourcePack = access.access->packet.getDefiningOp<PackOp>();
  return sourcePack && llvm::all_of(sourcePack.getInputs(), [&](Value input) {
           return input.getType() == component;
         });
}
static Value packTransactionWords(IRRewriter &rewriter, const AccessMap &access,
                                  ArrayRef<Value> values, Type type,
                                  int64_t elementsPerWord) {
  SmallVector<Value> words;
  Type wordType = getTransactionType(*access.access, elementsPerWord);
  for (int64_t first = 0; first < static_cast<int64_t>(values.size());
       first += elementsPerWord)
    words.push_back(PackOp::create(rewriter, access.getLoc(), wordType,
                                   values.slice(first, elementsPerWord)));
  return PackOp::create(rewriter, access.getLoc(), type, words);
}
static Value buildTransactionValue(
    IRRewriter &rewriter, const AccessMap &access, const Transaction &checked,
    ArrayRef<Value> components, bool aliasedOutputs = false,
    SmallVectorImpl<std::pair<SmallVector<Value>, Value>> *cache = nullptr) {
  SmallVector<Value> values =
      collectTransactionValues(checked, components, aliasedOutputs);
  if (values.size() == 1)
    return values.front();
  Type type = getTransactionType(*access.access, values.size());
  if (Value cached = findCachedTransactionValue(type, values, cache))
    return cached;
  Type component = getComponentType(*access.access);
  int64_t elementsPerWord = 32 / access.shape.elementBits;
  bool packWords = isScalarizedPacket(access, component) &&
                   elementsPerWord > 1 &&
                   values.size() > static_cast<size_t>(elementsPerWord) &&
                   values.size() % elementsPerWord == 0;
  Value packed =
      packWords
          ? packTransactionWords(rewriter, access, values, type,
                                 elementsPerWord)
          : Value(PackOp::create(rewriter, access.getLoc(), type, values));
  if (cache)
    cache->emplace_back(std::move(values), packed);
  return packed;
}
static void unpackTransaction(IRRewriter &rewriter, const AccessMap &access,
                              const Transaction &checked, Value value,
                              SmallVectorImpl<Value> &results) {
  Type component = getComponentType(*access.access);
  if (checked.outputs.size() == 1) {
    for (unsigned output : checked.outputs.front())
      results[output] = value;
    return;
  }
  for (auto [index, outputs] : llvm::enumerate(checked.outputs)) {
    Value extracted =
        ExtractOp::create(rewriter, access.getLoc(), component, value, index);
    for (unsigned output : outputs)
      results[output] = extracted;
  }
}
static FailureOr<SmallVector<bool>>
findHoistedTransactions(ArrayRef<Transaction> plan, sym::Store &store) {
  indexing::CheckMemo memo;
  SmallVector<bool> hoisted;
  for (const Transaction &transaction : plan) {
    FailureOr<bool> hoist = proveMemoryTransactionAddressHoistable(
        store, transaction, transaction.addresses.front(), memo);
    if (failed(hoist))
      return failure();
    hoisted.push_back(*hoist);
  }
  return hoisted;
}
static LogicalResult
prepareHoistedTransactions(ArrayRef<Transaction> plan, ArrayRef<bool> hoisted,
                           MemoryTransactionAddressMaterializer &materializer) {
  for (auto [transaction, hoist] : llvm::zip(plan, hoisted))
    if (hoist && failed(materializer.prepare(transaction,
                                             transaction.addresses.front())))
      return failure();
  return success();
}
static FailureOr<SmallVector<Value>> emitGatherTransaction(
    IRRewriter &rewriter, const AccessMap &access,
    const Transaction &transaction, bool hoist,
    MemoryTransactionAddressMaterializer &materializer,
    SmallVectorImpl<std::pair<SmallVector<Value>, Value>> &inactiveValueCache) {
  const Address &address = transaction.addresses.front();
  FailureOr<Value> pointer =
      hoist ? materializer.materialize(transaction, address)
            : FailureOr<Value>(Value{});
  if (failed(pointer))
    return failure();
  auto issue = [&](Value address) {
    if (transaction.gatherEmitter)
      return transaction.gatherEmitter->emit(
          rewriter, access.getLoc(),
          getTransactionType(*access.access, transaction.outputs.size()),
          access.access->tokenType, address, access.access->dependency);
    LoadOp load = LoadOp::create(
        rewriter, access.getLoc(),
        getTransactionType(*access.access, transaction.outputs.size()),
        access.access->tokenType, address, access.access->dependency,
        access.access->cache);
    return wave::memory_lowering::GatherTransactionResult{load.getValue(),
                                                          load.getToken()};
  };
  auto active = [&]() -> FailureOr<SmallVector<Value>> {
    FailureOr<Value> activePointer =
        *pointer ? FailureOr<Value>(*pointer)
                 : materializer.materialize(transaction, address,
                                            transaction.active);
    if (failed(activePointer))
      return failure();
    auto loaded = issue(*activePointer);
    return SmallVector<Value>{loaded.value, loaded.token};
  };
  auto inactive = [&]() -> FailureOr<SmallVector<Value>> {
    return SmallVector<Value>{
        buildTransactionValue(rewriter, access, transaction,
                              access.access->inactiveComponents, true,
                              &inactiveValueCache),
        access.access->inactiveToken};
  };
  SmallVector<Type, 2> types{
      getTransactionType(*access.access, transaction.outputs.size()),
      access.access->tokenType};
  return emitConditional(rewriter, access, transaction, materializer, types,
                         active, inactive);
}
static bool isWholePacketGather(const AccessMap &access,
                                const Transaction &transaction, Value value,
                                size_t resultCount) {
  if (value.getType() != access.access->packetType ||
      transaction.outputs.size() != resultCount)
    return false;
  return llvm::all_of(llvm::enumerate(transaction.outputs), [](auto output) {
    return output.value().size() == 1 &&
           output.value().front() == output.index();
  });
}
static FailureOr<SmallVector<Value>> emitGather(IRRewriter &rewriter,
                                                const AccessMap &access,
                                                ArrayRef<Transaction> plan,
                                                sym::Store &store) {
  SmallVector<Value> results(access.shape.slotCount);
  SmallVector<Value> tokens;
  SmallVector<std::pair<SmallVector<Value>, Value>, 4> inactiveValueCache;
  FailureOr<SmallVector<bool>> hoisted = findHoistedTransactions(plan, store);
  if (failed(hoisted))
    return failure();
  MemoryTransactionAddressMaterializer materializer(
      rewriter, access.access->op, access.getLoc(), store,
      access.access->packetType.getWidth());
  if (failed(prepareHoistedTransactions(plan, *hoisted, materializer)))
    return failure();
  for (auto [transaction, hoist] : llvm::zip(plan, *hoisted)) {
    FailureOr<SmallVector<Value>> loaded = emitGatherTransaction(
        rewriter, access, transaction, hoist, materializer, inactiveValueCache);
    if (failed(loaded))
      return failure();
    if (plan.size() == 1 &&
        isWholePacketGather(access, transaction, (*loaded)[0], results.size()))
      return *loaded;
    unpackTransaction(rewriter, access, transaction, (*loaded)[0], results);
    tokens.push_back((*loaded)[1]);
  }
  Value value = PackOp::create(rewriter, access.getLoc(),
                               access.access->packetType, results);
  return SmallVector<Value>{value,
                            joinTokens(rewriter, *access.access, tokens)};
}
static FailureOr<Value>
emitScatterTransaction(IRRewriter &rewriter, const AccessMap &access,
                       const Transaction &transaction, bool hoist,
                       ArrayRef<Value> components,
                       MemoryTransactionAddressMaterializer &materializer) {
  const Address &address = transaction.addresses.front();
  FailureOr<Value> pointer =
      hoist ? materializer.materialize(transaction, address)
            : FailureOr<Value>(Value{});
  if (failed(pointer))
    return failure();
  Value value =
      buildTransactionValue(rewriter, access, transaction, components);
  auto active = [&]() -> FailureOr<SmallVector<Value>> {
    FailureOr<Value> activePointer =
        *pointer ? FailureOr<Value>(*pointer)
                 : materializer.materialize(transaction, address,
                                            transaction.active);
    if (failed(activePointer))
      return failure();
    Value token =
        StoreOp::create(rewriter, access.getLoc(), access.access->tokenType,
                        value, *activePointer, access.access->dependency,
                        access.access->cache)
            .getToken();
    return SmallVector<Value>{token};
  };
  auto inactive = [&]() -> FailureOr<SmallVector<Value>> {
    return SmallVector<Value>{access.access->inactiveToken};
  };
  SmallVector<Type, 1> types{access.access->tokenType};
  FailureOr<SmallVector<Value>> emitted = emitConditional(
      rewriter, access, transaction, materializer, types, active, inactive);
  return failed(emitted) ? FailureOr<Value>(failure()) : emitted->front();
}
static FailureOr<Value> emitScatter(IRRewriter &rewriter,
                                    const AccessMap &access,
                                    ArrayRef<Transaction> plan,
                                    sym::Store &store) {
  SmallVector<Value> components = getPacketComponents(
      rewriter, *access.access, access.access->packet, access.shape.slotCount);
  SmallVector<Value> tokens;
  FailureOr<SmallVector<bool>> hoisted = findHoistedTransactions(plan, store);
  if (failed(hoisted))
    return failure();
  MemoryTransactionAddressMaterializer materializer(
      rewriter, access.access->op, access.getLoc(), store,
      access.access->packetType.getWidth());
  if (failed(prepareHoistedTransactions(plan, *hoisted, materializer)))
    return failure();
  for (auto [transaction, hoist] : llvm::zip(plan, *hoisted)) {
    FailureOr<Value> emitted = emitScatterTransaction(
        rewriter, access, transaction, hoist, components, materializer);
    if (failed(emitted))
      return failure();
    tokens.push_back(*emitted);
  }
  return joinTokens(rewriter, *access.access, tokens);
}
static void finishAccess(IRRewriter &rewriter, const AccessMap &access,
                         ValueRange replacements, Preparation &transaction) {
  if (!access.access->packetWhere) {
    rewriter.replaceOp(access.access->op, replacements);
    return;
  }
  WhereOp where = access.access->packetWhere;
  transaction.prepareForParentErasure(where);
  if (access.access->gather || where.getNumResults() == replacements.size())
    rewriter.replaceOp(where, replacements);
  else
    rewriter.eraseOp(where);
}
static LogicalResult appendAccessPlan(const AccessMap &access,
                                      sym::Store &store,
                                      std::string &diagnostic,
                                      std::vector<Transaction> &plan) {
  FailureOr<std::vector<Transaction>> planned =
      planTransactions(access, store, diagnostic);
  if (failed(planned))
    return failure();
  llvm::append_range(plan, std::move(*planned));
  return success();
}
static bool isProvenInactive(FailureOr<sym::CheckResult> checked) {
  return succeeded(checked) && *checked == sym::CheckResult::True;
}
static LogicalResult
markTransactionsInactive(sym::Store &store,
                         MutableArrayRef<Transaction> transactions) {
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return failure();
  for (Transaction &transaction : transactions)
    transaction.activity = *zero;
  return success();
}
static LogicalResult
assignTransactionConditions(ValueRange conditions,
                            MutableArrayRef<Transaction> transactions) {
  for (Transaction &transaction : transactions) {
    if (transaction.outputs.empty() || transaction.outputs.front().empty())
      return failure();
    unsigned slot = transaction.outputs.front().front();
    if (slot >= conditions.size())
      return failure();
    transaction.condition = conditions[slot];
  }
  return success();
}
static const PacketActivityDomain *
findPacketActivityDomain(const AccessMap &access, int64_t slot) {
  auto found = llvm::find_if(
      access.packetActivityDomains, [&](const PacketActivityDomain &domain) {
        return slot >= domain.firstSlot &&
               slot < domain.firstSlot + domain.slotCount;
      });
  return found == access.packetActivityDomains.end() ? nullptr : &*found;
}
static FailureOr<bool> proveEquivalentPacketActivity(
    const AccessMap &access, const PacketActivityDomain &origin,
    const PacketActivityDomain &point, int64_t alignment, sym::Store &store,
    indexing::CheckMemo &memo) {
  if (origin.active == point.active)
    return true;
  indexing::IndexMap proofMap = access.address.map;
  for (sym::PredHandle fact : origin.facts)
    if (!llvm::is_contained(proofMap.facts, fact))
      proofMap.facts.push_back(fact);
  for (sym::PredHandle fact : point.facts)
    if (!llvm::is_contained(proofMap.facts, fact))
      proofMap.facts.push_back(fact);
  std::array<sym::ExprHandle, 2> expressions{sym::asExpr(origin.active),
                                             sym::asExpr(point.active)};
  if (failed(appendMemoryTransactionProofDefinitions(
          store, proofMap, access.proofDefinitions, expressions)))
    return failure();
  return proveActivityEquivalent(store, proofMap, origin.active, point.active,
                                 alignment, memo);
}
static FailureOr<bool>
proveUniformPacketActivity(const AccessMap &prepared,
                           const Transaction &transaction,
                           const PacketActivityDomain &origin,
                           sym::Store &store, indexing::CheckMemo &memo) {
  for (ArrayRef<unsigned> outputs : transaction.outputs) {
    for (unsigned slot : outputs) {
      const PacketActivityDomain *point =
          findPacketActivityDomain(prepared, slot);
      if (!point)
        return failure();
      FailureOr<bool> equivalent = proveEquivalentPacketActivity(
          prepared, origin, *point, transaction.width, store, memo);
      if (failed(equivalent) || !*equivalent)
        return equivalent;
    }
  }
  return true;
}
static FailureOr<bool> applyUniformPacketActivity(const AccessMap &prepared,
                                                  Transaction &transaction,
                                                  sym::Store &store,
                                                  indexing::CheckMemo &memo) {
  if (transaction.outputs.empty() || transaction.outputs.front().empty())
    return failure();
  unsigned firstSlot = transaction.outputs.front().front();
  const PacketActivityDomain *origin =
      findPacketActivityDomain(prepared, firstSlot);
  if (!origin)
    return failure();
  FailureOr<bool> uniform =
      proveUniformPacketActivity(prepared, transaction, *origin, store, memo);
  if (failed(uniform) || !*uniform)
    return uniform;
  FailureOr<sym::ExprHandle> materialActive = indexing::materialize(
      store, transaction.map, sym::asExpr(origin->active));
  std::optional<sym::PredHandle> active =
      failed(materialActive) ? std::nullopt : sym::asPred(*materialActive);
  FailureOr<sym::ExprHandle> activity =
      active ? composeIndexExprIndicator(store, *active)
             : FailureOr<sym::ExprHandle>(failure());
  if (failed(activity))
    return failure();
  transaction.active = *active;
  transaction.activity = *activity;
  transaction.condition =
      prepared.access->packetWhere.getConditions()[firstSlot];
  return true;
}
static FailureOr<std::optional<std::vector<Transaction>>>
planUniformPacketActivity(const AccessMap &prepared, sym::Store &store,
                          std::string &diagnostic) {
  AccessMap addressPlan = prepared;
  addressPlan.packetActivityDomains.clear();
  FailureOr<std::vector<Transaction>> planned =
      planTransactions(addressPlan, store, diagnostic);
  if (failed(planned))
    return failure();
  indexing::CheckMemo memo;
  for (Transaction &transaction : *planned) {
    FailureOr<bool> uniform =
        applyUniformPacketActivity(prepared, transaction, store, memo);
    if (failed(uniform))
      return failure();
    if (!*uniform)
      return std::optional<std::vector<Transaction>>{};
  }
  return std::optional<std::vector<Transaction>>{std::move(*planned)};
}
static LogicalResult
appendPacketActivityPlan(const AccessMap &prepared,
                         const PacketActivityDomain &domain, sym::Store &store,
                         std::string &diagnostic,
                         std::vector<Transaction> &plan) {
  FailureOr<sym::PredHandle> inactive =
      sym::composePredNot(store, domain.active);
  if (failed(inactive))
    return failure();
  FailureOr<sym::CheckResult> checked =
      indexing::check(store, prepared.address.map, {*inactive});
  bool provenInactive = isProvenInactive(checked);
  if (provenInactive && !prepared.access->gather)
    return success();
  AccessMap specialized = specializePacketActivity(prepared, domain);
  size_t firstTransaction = plan.size();
  if (failed(appendAccessPlan(specialized, store, diagnostic, plan)))
    return failure();
  MutableArrayRef<Transaction> appended =
      MutableArrayRef(plan).drop_front(firstTransaction);
  if (prepared.access->gather)
    return provenInactive ? markTransactionsInactive(store, appended)
                          : success();
  return assignTransactionConditions(
      prepared.access->packetWhere.getConditions(), appended);
}
static FailureOr<std::vector<Transaction>>
planAccessTransactions(const AccessMap &prepared, sym::Store &store,
                       std::string &diagnostic) {
  std::vector<Transaction> plan;
  if (prepared.packetActivityDomains.empty()) {
    if (failed(appendAccessPlan(prepared, store, diagnostic, plan)))
      return failure();
    return plan;
  }
  // Address planning supplies the exact width needed by activity proofs.
  FailureOr<std::optional<std::vector<Transaction>>> uniform =
      planUniformPacketActivity(prepared, store, diagnostic);
  if (failed(uniform))
    return failure();
  if (*uniform)
    return std::move(**uniform);
  for (const PacketActivityDomain &domain : prepared.packetActivityDomains) {
    if (failed(appendPacketActivityPlan(prepared, domain, store, diagnostic,
                                        plan)))
      return failure();
  }
  return plan;
}
static LogicalResult lowerAccess(IRRewriter &rewriter, MemoryAccess &access,
                                 WaveDialect &dialect) {
  Preparation transaction(rewriter);
  MutableArrayRef<MemoryAccess> accesses(&access, 1);
  FailureOr<AccessGroup> group = runDiagnosed<AccessGroup>(
      access.op, "failed to prepare symbolic access map", [&] {
        return prepareAccessGroup(rewriter, accesses, dialect, transaction);
      });
  if (failed(group))
    return failure();
  rewriter.setInsertionPoint(
      access.packetWhere ? access.packetWhere.getOperation() : access.op);
  std::string diagnostic;
  const AccessMap &prepared = group->front();
  FailureOr<std::vector<Transaction>> plan =
      planAccessTransactions(prepared, dialect.getSymbolStore(), diagnostic);
  if (failed(plan))
    return access.op->emitOpError(
        diagnostic.empty() ? "failed to compose the symbolic memory index map"
                           : diagnostic);
  if (access.gather) {
    FailureOr<SmallVector<Value>> replacements =
        runDiagnosed<SmallVector<Value>>(
            access.op, "failed to materialize gather plan", [&] {
              return emitGather(rewriter, group->front(), *plan,
                                dialect.getSymbolStore());
            });
    if (failed(replacements))
      return failure();
    finishAccess(rewriter, group->front(), *replacements, transaction);
  } else {
    FailureOr<Value> token = runDiagnosed<Value>(
        access.op, "failed to materialize scatter plan", [&] {
          return emitScatter(rewriter, group->front(), *plan,
                             dialect.getSymbolStore());
        });
    if (failed(token))
      return failure();
    finishAccess(rewriter, group->front(), ValueRange{*token}, transaction);
  }
  transaction.commit();
  return success();
}
struct DmaCopyMatch {
  GatherOp gather;
  WhereOp predicate;
  bool zeroFillInactive = false;
};
static bool isZeroPacket(Value value) {
  if (auto constant = value.getDefiningOp<ConstantOp>()) {
    if (auto integer = dyn_cast<IntegerAttr>(constant.getValue()))
      return integer.getValue().isZero();
    if (auto floating = dyn_cast<FloatAttr>(constant.getValue()))
      return floating.getValue().isZero() && !floating.getValue().isNegative();
  }
  if (auto splat = value.getDefiningOp<SplatOp>())
    return isZeroPacket(splat.getSource());
  auto pack = value.getDefiningOp<PackOp>();
  return pack && llvm::all_of(pack.getInputs(), isZeroPacket);
}
static std::optional<DmaCopyMatch> matchDirectDmaCopy(ScatterOp scatter) {
  if (auto gather = scatter.getValue().getDefiningOp<GatherOp>()) {
    if (gather->getBlock() == scatter->getBlock() &&
        gather.getValue().hasOneUse() && gather.getToken().hasOneUse() &&
        scatter.getDependency() == gather.getToken())
      return DmaCopyMatch{gather, {}, false};
  }
  return std::nullopt;
}
static bool hasDmaPredicateResults(WhereOp where, ScatterOp scatter) {
  return where.getNumResults() == 2 &&
         scatter.getValue() == where.getResult(0) &&
         scatter.getDependency() == where.getResult(1) &&
         where.getResult(0).hasOneUse() && where.getResult(1).hasOneUse();
}
struct DmaPredicateYields {
  YieldOp active, inactive;
};
static std::optional<DmaPredicateYields> getDmaPredicateYields(WhereOp where) {
  if (where.getThenRegion().empty() || where.getElseRegion().empty())
    return std::nullopt;
  auto thenYield =
      dyn_cast<YieldOp>(where.getThenRegion().front().getTerminator());
  auto elseYield =
      dyn_cast<YieldOp>(where.getElseRegion().front().getTerminator());
  if (!thenYield || !elseYield || thenYield.getNumOperands() != 2 ||
      elseYield.getNumOperands() != 2)
    return std::nullopt;
  return DmaPredicateYields{thenYield, elseYield};
}
static GatherOp matchDmaPredicateGather(DmaPredicateYields yields) {
  auto gather = yields.active.getOperand(0).getDefiningOp<GatherOp>();
  if (!gather || yields.active.getOperand(1) != gather.getToken() ||
      yields.inactive.getOperand(1) != gather.getDependency() ||
      !isZeroPacket(yields.inactive.getOperand(0)) ||
      !gather.getValue().hasOneUse() || !gather.getToken().hasOneUse())
    return {};
  return gather;
}
static std::optional<DmaCopyMatch> matchPredicatedDmaCopy(ScatterOp scatter) {
  auto where = scatter.getValue().getDefiningOp<WhereOp>();
  if (!where || where->getBlock() != scatter->getBlock() ||
      !hasDmaPredicateResults(where, scatter))
    return std::nullopt;
  std::optional<DmaPredicateYields> yields = getDmaPredicateYields(where);
  if (!yields)
    return std::nullopt;
  GatherOp gather = matchDmaPredicateGather(*yields);
  if (!gather)
    return std::nullopt;
  if (!isOwnedPacketRegion(where.getThenRegion().front(), gather) ||
      !isOwnedPacketRegion(where.getElseRegion().front()))
    return std::nullopt;
  return DmaCopyMatch{gather, where, true};
}
static std::optional<DmaCopyMatch> matchDmaCopy(ScatterOp scatter) {
  if (std::optional<DmaCopyMatch> direct = matchDirectDmaCopy(scatter))
    return direct;
  return matchPredicatedDmaCopy(scatter);
}
static bool haveMatchingDmaItems(const AccessMap &source,
                                 const AccessMap &destination) {
  return source.axes.item && destination.axes.item &&
         source.axes.itemValue == destination.axes.itemValue;
}
static bool hasValidDmaRange(const AccessMap &access) {
  return access.transactionFirstSlot >= 0 && access.transactionSlotCount > 0 &&
         access.transactionFirstSlot <= access.shape.slotCount &&
         access.transactionSlotCount <=
             access.shape.slotCount - access.transactionFirstSlot;
}
static bool haveMatchingDmaRanges(const AccessMap &source,
                                  const AccessMap &destination) {
  return source.shape.slotCount == destination.shape.slotCount &&
         source.shape.elementBits == destination.shape.elementBits &&
         source.transactionFirstSlot == destination.transactionFirstSlot &&
         source.transactionSlotCount == destination.transactionSlotCount;
}
struct DmaPlanShape {
  const AccessMap *source, *destination;
  Value item;
  int64_t waveWidth, bytes, windowBytes, elements, groupCount;
};
static std::optional<int64_t> getDmaWaveWidth(const AccessMap &source,
                                              const AccessMap &destination,
                                              Value item) {
  auto type = dyn_cast<SimdType>(item.getType());
  if (!type || !type.getElementType().isInteger(32) ||
      source.access->packetType.getWidth() != type.getWidth() ||
      destination.access->packetType.getWidth() != type.getWidth())
    return std::nullopt;
  return type.getWidth();
}
static std::optional<DmaPlanShape>
getDmaPlanShape(const AccessGroup &prepared,
                const wave::memory_lowering::CopyTransaction &selected) {
  if (prepared.size() != 2)
    return std::nullopt;
  const AccessMap &source = prepared[0];
  const AccessMap &destination = prepared[1];
  if (!haveMatchingDmaItems(source, destination))
    return std::nullopt;
  Value item = source.axes.itemValue;
  std::optional<int64_t> waveWidth = getDmaWaveWidth(source, destination, item);
  if (!waveWidth)
    return std::nullopt;
  if (!haveMatchingDmaRanges(source, destination) || !hasValidDmaRange(source))
    return std::nullopt;
  int64_t elements = selected.bytes * 8 / source.shape.elementBits;
  if (elements <= 0 || source.transactionFirstSlot % elements ||
      source.transactionSlotCount % elements)
    return std::nullopt;
  return DmaPlanShape{&source,        &destination,
                      item,           *waveWidth,
                      selected.bytes, selected.windowBytes,
                      elements,       source.transactionSlotCount / elements};
}
struct DmaSymbols {
  sym::ExprHandle formal, group, within, zero, one;
};
static FailureOr<DmaSymbols> buildDmaSymbols(sym::Store &store) {
  FailureOr<sym::ExprHandle> formal =
      sym::composeExprSym(store, "dma_wave_base");
  FailureOr<sym::ExprHandle> group = sym::composeExprSym(store, "group");
  FailureOr<sym::ExprHandle> within = sym::composeExprSym(store, "within");
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> one = sym::composeExprInt(store, 1);
  if (failed(formal) || failed(group) || failed(within) || failed(zero) ||
      failed(one))
    return failure();
  return DmaSymbols{*formal, *group, *within, *zero, *one};
}
static FailureOr<sym::ExprHandle>
buildDmaWaveBase(sym::Store &store, sym::ExprHandle item, int64_t waveWidth) {
  FailureOr<sym::ExprHandle> width = sym::composeExprInt(store, waveWidth);
  if (failed(width))
    return failure();
  FailureOr<sym::ExprHandle> quotient =
      sym::composeExprBinary(store, item, sym::ExprBinaryOp::Div, *width);
  if (failed(quotient))
    return failure();
  FailureOr<sym::ExprHandle> wave = sym::composeExprFloor(store, *quotient);
  if (failed(wave))
    return failure();
  return composeIntBinary(store, *wave, sym::ExprBinaryOp::Mul, waveWidth);
}
struct DmaExpressions {
  DmaSymbols symbols;
  sym::ExprHandle physicalItem, physicalWave, lane, withinBits,
      destinationDisplacement;
};
static FailureOr<DmaExpressions> buildDmaExpressions(const DmaPlanShape &shape,
                                                     sym::Store &store) {
  FailureOr<DmaSymbols> symbols = buildDmaSymbols(store);
  if (failed(symbols))
    return failure();
  sym::ExprHandle physicalItem = *shape.source->axes.item;
  FailureOr<sym::ExprHandle> physicalWave =
      buildDmaWaveBase(store, physicalItem, shape.waveWidth);
  FailureOr<sym::ExprHandle> lane = composeIntBinary(
      store, physicalItem, sym::ExprBinaryOp::Mod, shape.waveWidth);
  if (failed(physicalWave) || failed(lane))
    return failure();
  FailureOr<sym::ExprHandle> laneBits =
      composeIntBinary(store, *lane, sym::ExprBinaryOp::Mul, shape.bytes * 8);
  FailureOr<sym::ExprHandle> withinBits =
      composeIntBinary(store, symbols->within, sym::ExprBinaryOp::Mul,
                       shape.source->shape.elementBits);
  if (failed(laneBits) || failed(withinBits))
    return failure();
  FailureOr<sym::ExprHandle> displacement = sym::composeExprBinary(
      store, *laneBits, sym::ExprBinaryOp::Add, *withinBits);
  if (failed(displacement))
    return failure();
  return DmaExpressions{*symbols, physicalItem, *physicalWave,
                        *lane,    *withinBits,  *displacement};
}
struct DmaFamilies {
  Layout sourceLayout, destinationLayout;
  MemoryTransactionProjection destinationProjection;
  std::optional<Transaction> source, destination;
};
static FailureOr<DmaFamilies>
buildInitialDmaFamilies(const DmaPlanShape &shape,
                        const DmaExpressions &expressions, sym::Store &store,
                        indexing::CheckMemo &memo) {
  Layout sourceLayout;
  sourceLayout.width = shape.elements;
  sourceLayout.groupCount = shape.groupCount;
  Layout destinationLayout = sourceLayout;
  destinationLayout.within = expressions.symbols.within;
  destinationLayout.originItem = expressions.physicalWave;
  destinationLayout.displacement = expressions.destinationDisplacement;
  MemoryTransactionProjection projection{expressions.physicalItem,
                                         expressions.physicalWave,
                                         expressions.symbols.formal};
  FailureOr<std::optional<Transaction>> source =
      buildTransaction(*shape.source, sourceLayout, store, memo, std::nullopt,
                       shape.windowBytes);
  FailureOr<std::optional<Transaction>> destination =
      buildTransaction(*shape.destination, destinationLayout, store, memo,
                       projection, shape.windowBytes);
  if (failed(source) || failed(destination))
    return failure();
  return DmaFamilies{sourceLayout, destinationLayout, projection,
                     std::move(*source), std::move(*destination)};
}
static bool hasUnconditionalDmaActivity(const DmaPlanShape &shape,
                                        bool zeroFillInactive) {
  return !zeroFillInactive && !shape.source->condition &&
         !shape.destination->condition &&
         sym::getIntegerLiteralValue(
             sym::asExpr(shape.source->address.active)) == 1 &&
         sym::getIntegerLiteralValue(
             sym::asExpr(shape.destination->address.active)) == 1;
}
static bool hasRemappableDmaActivity(const DmaPlanShape &shape,
                                     bool zeroFillInactive) {
  if (!zeroFillInactive)
    return hasUnconditionalDmaActivity(shape, false);
  return !shape.source->condition && !shape.destination->condition;
}
static bool hasCoordinateDmaInputs(const DmaPlanShape &shape) {
  return hasOnlyCoordinateLaneInputs(
             shape.source->address.map, shape.source->axes.block,
             shape.source->axes.slot, shape.source->axes.item) &&
         hasOnlyCoordinateLaneInputs(
             shape.destination->address.map, shape.destination->axes.block,
             shape.destination->axes.slot, shape.destination->axes.item);
}
static bool canRemapDmaOwnership(const DmaPlanShape &shape,
                                 const DmaFamilies &families,
                                 bool zeroFillInactive) {
  return (!families.source || !families.destination) &&
         hasRemappableDmaActivity(shape, zeroFillInactive) &&
         shape.source->transactionFirstSlot == 0 &&
         supportsFullWaveOwnershipRemap(shape.destination->access->op,
                                        shape.waveWidth) &&
         hasCoordinateDmaInputs(shape);
}

static bool canRankDmaOwnership(const DmaPlanShape &shape,
                                const DmaFamilies &families,
                                bool zeroFillInactive) {
  return (!families.source || !families.destination) &&
         hasRemappableDmaActivity(shape, zeroFillInactive) &&
         shape.source->packetActivityDomains.empty() &&
         shape.source->transactionFirstSlot == 0 &&
         supportsFullWaveOwnershipRemap(shape.destination->access->op,
                                        shape.waveWidth);
}
static FailureOr<sym::ExprHandle>
buildDmaLinear(const DmaPlanShape &shape, const DmaExpressions &expressions,
               sym::Store &store) {
  FailureOr<sym::ExprHandle> groupLane =
      composeIntBinary(store, expressions.symbols.group, sym::ExprBinaryOp::Mul,
                       shape.waveWidth);
  if (failed(groupLane))
    return failure();
  FailureOr<sym::ExprHandle> transactionLane = sym::composeExprBinary(
      store, *groupLane, sym::ExprBinaryOp::Add, expressions.lane);
  if (failed(transactionLane))
    return failure();
  FailureOr<sym::ExprHandle> first = composeIntBinary(
      store, *transactionLane, sym::ExprBinaryOp::Mul, shape.elements);
  if (failed(first))
    return failure();
  return sym::composeExprBinary(store, *first, sym::ExprBinaryOp::Add,
                                expressions.symbols.within);
}
struct DmaAccessPoint {
  sym::ExprHandle item, slot;
};

static FailureOr<sym::ExprHandle>
composeDmaSelectorBit(sym::Store &store, sym::ExprHandle selector,
                      unsigned bit) {
  FailureOr<sym::ExprHandle> divided = composeIntBinary(
      store, selector, sym::ExprBinaryOp::Div, int64_t{1} << bit);
  FailureOr<sym::ExprHandle> floored =
      failed(divided) ? FailureOr<sym::ExprHandle>(failure())
                      : sym::composeExprFloor(store, *divided);
  return failed(floored)
             ? FailureOr<sym::ExprHandle>(failure())
             : composeIntBinary(store, *floored, sym::ExprBinaryOp::Mod, 2);
}

static SmallVector<bool> getDmaBitCoefficients(ArrayRef<int64_t> values,
                                               unsigned outputBit,
                                               unsigned inputBits) {
  bool constant = (static_cast<uint64_t>(values.front()) >> outputBit) & 1;
  SmallVector<bool> coefficients;
  coefficients.reserve(inputBits);
  for (unsigned inputBit = 0; inputBit < inputBits; ++inputBit)
    coefficients.push_back(
        constant ^
        ((static_cast<uint64_t>(values[uint64_t{1} << inputBit]) >> outputBit) &
         1));
  return coefficients;
}

static bool isDmaAffineBit(ArrayRef<int64_t> values, unsigned outputBit,
                           ArrayRef<bool> coefficients) {
  bool constant = (static_cast<uint64_t>(values.front()) >> outputBit) & 1;
  for (uint64_t input = 0; input < values.size(); ++input) {
    bool expected = constant;
    for (auto [inputBit, coefficient] : llvm::enumerate(coefficients))
      if (coefficient && (input & (uint64_t{1} << inputBit)))
        expected = !expected;
    bool actual = (static_cast<uint64_t>(values[input]) >> outputBit) & 1;
    if (expected != actual)
      return false;
  }
  return true;
}

static FailureOr<sym::ExprHandle>
composeDmaOutputBit(sym::Store &store, sym::ExprHandle selector,
                    unsigned outputBit, ArrayRef<bool> coefficients,
                    bool constant) {
  FailureOr<sym::ExprHandle> output =
      sym::composeExprInt(store, constant ? 1 : 0);
  for (auto [inputBit, coefficient] : llvm::enumerate(coefficients)) {
    if (!coefficient)
      continue;
    FailureOr<sym::ExprHandle> input =
        composeDmaSelectorBit(store, selector, inputBit);
    output = failed(output) || failed(input)
                 ? FailureOr<sym::ExprHandle>(failure())
                 : sym::composeExprBinary(store, *output,
                                          sym::ExprBinaryOp::Xor, *input);
  }
  if (failed(output))
    return failure();
  return composeIntBinary(store, *output, sym::ExprBinaryOp::Mul,
                          int64_t{1} << outputBit);
}
static bool isValidDmaPermutation(ArrayRef<int64_t> values) {
  return !values.empty() && llvm::isPowerOf2_64(values.size()) &&
         llvm::none_of(values, [](int64_t value) { return value < 0; });
}

static FailureOr<std::optional<sym::ExprHandle>>
synthesizeDmaBitPermutation(sym::Store &store, sym::ExprHandle selector,
                            ArrayRef<int64_t> values) {
  if (!isValidDmaPermutation(values))
    return std::optional<sym::ExprHandle>{};
  uint64_t maximum = static_cast<uint64_t>(*llvm::max_element(values));
  unsigned inputBits = llvm::Log2_64(values.size());
  unsigned outputBits = maximum ? llvm::Log2_64(maximum) + 1 : 0;
  FailureOr<sym::ExprHandle> result = sym::composeExprInt(store, 0);
  if (failed(result))
    return failure();
  for (unsigned outputBit = 0; outputBit < outputBits; ++outputBit) {
    bool constant = (static_cast<uint64_t>(values.front()) >> outputBit) & 1;
    SmallVector<bool> coefficients =
        getDmaBitCoefficients(values, outputBit, inputBits);
    if (!isDmaAffineBit(values, outputBit, coefficients))
      return std::optional<sym::ExprHandle>{};
    FailureOr<sym::ExprHandle> term =
        composeDmaOutputBit(store, selector, outputBit, coefficients, constant);
    result = failed(result) || failed(term)
                 ? FailureOr<sym::ExprHandle>(failure())
                 : sym::composeExprBinary(store, *result,
                                          sym::ExprBinaryOp::Add, *term);
    if (failed(result))
      return failure();
  }
  FailureOr<sym::ExprHandle> simplified = sym::simplifyExpr(store, *result);
  return failed(simplified)
             ? FailureOr<std::optional<sym::ExprHandle>>(failure())
             : std::optional<sym::ExprHandle>{*simplified};
}

struct RankedDmaBlock {
  int64_t item, firstSlot, bitOffset;
};

static FailureOr<std::optional<int64_t>>
getRankedDmaBitOffset(sym::Store &store, sym::Analysis &analysis,
                      const DmaPlanShape &shape, sym::ExprHandle bitOffset,
                      int64_t item, int64_t firstSlot,
                      sym::ExprHandle reference) {
  FailureOr<sym::ExprHandle> itemValue = sym::composeExprInt(store, item);
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, firstSlot);
  if (failed(itemValue) || failed(slotValue))
    return failure();
  std::array<sym::ExprSubstitution, 2> point{
      sym::ExprSubstitution{*shape.destination->axes.item, *itemValue},
      sym::ExprSubstitution{shape.destination->axes.slot, *slotValue}};
  FailureOr<sym::ExprHandle> specialized =
      sym::substituteExpr(store, bitOffset, point);
  if (failed(specialized))
    return failure();
  std::optional<int64_t> difference =
      analysis.constantDifference(*specialized, reference);
  return difference;
}

struct RankedDmaAnalysis {
  std::unique_ptr<sym::Analysis> analysis;
  sym::ExprHandle destinationOffset;
  sym::ExprHandle reference;
  int64_t itemCount;
  int64_t selectorCount;
};

static bool isRankedDmaCandidate(const DmaPlanShape &shape) {
  return shape.destination->axes.item &&
         shape.destination->access->bases.size() == 1;
}

static std::optional<std::pair<int64_t, int64_t>>
getRankedDmaCounts(const DmaPlanShape &shape) {
  if (!isRankedDmaCandidate(shape))
    return std::nullopt;
  auto itemInput = llvm::find_if(
      shape.destination->address.map.inputs, [&](const auto &input) {
        return input.variable == *shape.destination->axes.item;
      });
  if (itemInput == shape.destination->address.map.inputs.end() ||
      !itemInput->extent || *itemInput->extent <= 0 || shape.waveWidth <= 0 ||
      shape.groupCount <= 0 || *itemInput->extent % shape.waveWidth)
    return std::nullopt;
  std::optional<int64_t> selectorCount =
      llvm::checkedMul(*itemInput->extent, shape.groupCount);
  if (!selectorCount || !llvm::isPowerOf2_64(*selectorCount))
    return std::nullopt;
  return std::pair<int64_t, int64_t>{*itemInput->extent, *selectorCount};
}

static FailureOr<std::optional<sym::ExprHandle>>
getRankedDmaReference(const DmaPlanShape &shape,
                      sym::ExprHandle destinationOffset,
                      sym::Analysis &analysis, sym::Store &store) {
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> baseSelector = indexing::materialize(
      store, shape.destination->address.map, shape.destination->baseSelector);
  if (failed(zero) || failed(baseSelector))
    return failure();
  std::optional<int64_t> selectedBase =
      analysis.constantDifference(*baseSelector, *zero);
  if (!selectedBase || *selectedBase != 0)
    return std::optional<sym::ExprHandle>{};
  std::array<sym::ExprSubstitution, 2> origin{
      sym::ExprSubstitution{*shape.destination->axes.item, *zero},
      sym::ExprSubstitution{shape.destination->axes.slot, *zero}};
  FailureOr<sym::ExprHandle> reference =
      sym::substituteExpr(store, destinationOffset, origin);
  if (failed(reference))
    return failure();
  return analysis.divisible(*reference, 8) == sym::CheckResult::True
             ? FailureOr<std::optional<sym::ExprHandle>>(
                   std::optional<sym::ExprHandle>{*reference})
             : FailureOr<std::optional<sym::ExprHandle>>(
                   std::optional<sym::ExprHandle>{});
}

static FailureOr<std::optional<RankedDmaAnalysis>>
prepareRankedDmaAnalysis(const DmaPlanShape &shape, sym::Store &store) {
  std::optional<std::pair<int64_t, int64_t>> counts = getRankedDmaCounts(shape);
  if (!counts)
    return std::optional<RankedDmaAnalysis>{};
  FailureOr<sym::ExprHandle> destinationOffset =
      indexing::materialize(store, shape.destination->address.map,
                            shape.destination->address.bitOffset);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      createClosedIndexExprAnalysis(store,
                                    shape.destination->address.map.facts);
  if (failed(destinationOffset) || failed(analysis))
    return failure();
  FailureOr<std::optional<sym::ExprHandle>> reference =
      getRankedDmaReference(shape, *destinationOffset, **analysis, store);
  if (failed(reference))
    return failure();
  if (!*reference)
    return std::optional<RankedDmaAnalysis>{};
  return std::optional<RankedDmaAnalysis>{
      RankedDmaAnalysis{std::move(*analysis), *destinationOffset, **reference,
                        counts->first, counts->second}};
}

static FailureOr<std::optional<RankedDmaBlock>>
getRankedDmaBlock(sym::Store &store, const DmaPlanShape &shape,
                  RankedDmaAnalysis &ranked, int64_t item, int64_t group) {
  int64_t firstSlot = group * shape.elements;
  FailureOr<std::optional<int64_t>> offset = getRankedDmaBitOffset(
      store, *ranked.analysis, shape, ranked.destinationOffset, item, firstSlot,
      ranked.reference);
  if (failed(offset))
    return failure();
  if (!*offset)
    return std::optional<RankedDmaBlock>{};
  for (int64_t within = 1; within < shape.elements; ++within) {
    FailureOr<std::optional<int64_t>> pointOffset = getRankedDmaBitOffset(
        store, *ranked.analysis, shape, ranked.destinationOffset, item,
        firstSlot + within, ranked.reference);
    if (failed(pointOffset))
      return failure();
    if (!*pointOffset ||
        **pointOffset !=
            **offset + within * shape.destination->shape.elementBits)
      return std::optional<RankedDmaBlock>{};
  }
  return std::optional<RankedDmaBlock>{
      RankedDmaBlock{item, firstSlot, **offset}};
}

static FailureOr<std::optional<SmallVector<RankedDmaBlock>>>
collectRankedDmaWave(const DmaPlanShape &shape, RankedDmaAnalysis &ranked,
                     int64_t waveBase, sym::Store &store) {
  SmallVector<RankedDmaBlock> blocks;
  blocks.reserve(shape.waveWidth * shape.groupCount);
  for (int64_t item = waveBase; item < waveBase + shape.waveWidth; ++item) {
    for (int64_t group = 0; group < shape.groupCount; ++group) {
      FailureOr<std::optional<RankedDmaBlock>> block =
          getRankedDmaBlock(store, shape, ranked, item, group);
      if (failed(block))
        return failure();
      if (!*block)
        return std::optional<SmallVector<RankedDmaBlock>>{};
      blocks.push_back(**block);
    }
  }
  return std::optional<SmallVector<RankedDmaBlock>>{std::move(blocks)};
}

static bool assignRankedDmaWave(const DmaPlanShape &shape, int64_t itemCount,
                                int64_t waveBase,
                                SmallVectorImpl<RankedDmaBlock> &blocks,
                                MutableArrayRef<int64_t> items,
                                MutableArrayRef<int64_t> slots) {
  llvm::sort(blocks, [](const RankedDmaBlock &lhs, const RankedDmaBlock &rhs) {
    return lhs.bitOffset < rhs.bitOffset;
  });
  int64_t transactionBits = shape.bytes * 8;
  for (auto [rank, block] : llvm::enumerate(blocks)) {
    int64_t group = static_cast<int64_t>(rank) / shape.waveWidth;
    int64_t lane = static_cast<int64_t>(rank) % shape.waveWidth;
    int64_t first = blocks[group * shape.waveWidth].bitOffset;
    if (block.bitOffset != first + lane * transactionBits)
      return false;
    int64_t selector = group * itemCount + waveBase + lane;
    items[selector] = block.item;
    slots[selector] = block.firstSlot;
  }
  return true;
}

static FailureOr<bool> buildRankedDmaTables(const DmaPlanShape &shape,
                                            RankedDmaAnalysis &ranked,
                                            SmallVectorImpl<int64_t> &items,
                                            SmallVectorImpl<int64_t> &slots,
                                            sym::Store &store) {
  int64_t waveCount = ranked.itemCount / shape.waveWidth;
  for (int64_t wave = 0; wave < waveCount; ++wave) {
    int64_t waveBase = wave * shape.waveWidth;
    FailureOr<std::optional<SmallVector<RankedDmaBlock>>> blocks =
        collectRankedDmaWave(shape, ranked, waveBase, store);
    if (failed(blocks))
      return failure();
    if (!*blocks || !assignRankedDmaWave(shape, ranked.itemCount, waveBase,
                                         **blocks, items, slots))
      return false;
  }
  return true;
}

static FailureOr<std::optional<DmaAccessPoint>>
composeRankedDmaAccessPoint(const DmaExpressions &expressions,
                            RankedDmaAnalysis &ranked, ArrayRef<int64_t> items,
                            ArrayRef<int64_t> slots, sym::Store &store) {
  FailureOr<sym::ExprHandle> groupBase =
      composeIntBinary(store, expressions.symbols.group, sym::ExprBinaryOp::Mul,
                       ranked.itemCount);
  FailureOr<sym::ExprHandle> selector =
      failed(groupBase)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, *groupBase, sym::ExprBinaryOp::Add,
                                   expressions.physicalItem);
  if (failed(selector))
    return failure();
  FailureOr<std::optional<sym::ExprHandle>> item =
      synthesizeDmaBitPermutation(store, *selector, items);
  FailureOr<std::optional<sym::ExprHandle>> firstSlot =
      synthesizeDmaBitPermutation(store, *selector, slots);
  if (failed(item) || failed(firstSlot))
    return failure();
  if (!*item || !*firstSlot)
    return std::optional<DmaAccessPoint>{};
  FailureOr<sym::ExprHandle> slot = sym::composeExprBinary(
      store, **firstSlot, sym::ExprBinaryOp::Add, expressions.symbols.within);
  return failed(slot)
             ? FailureOr<std::optional<DmaAccessPoint>>(failure())
             : std::optional<DmaAccessPoint>{DmaAccessPoint{**item, *slot}};
}

static FailureOr<std::optional<DmaAccessPoint>>
buildRankedDmaAccessPoint(const DmaPlanShape &shape,
                          const DmaExpressions &expressions,
                          sym::Store &store) {
  FailureOr<std::optional<RankedDmaAnalysis>> ranked =
      prepareRankedDmaAnalysis(shape, store);
  if (failed(ranked))
    return failure();
  if (!*ranked)
    return std::optional<DmaAccessPoint>{};
  SmallVector<int64_t> items((**ranked).selectorCount, -1);
  SmallVector<int64_t> slots((**ranked).selectorCount, -1);
  FailureOr<bool> built =
      buildRankedDmaTables(shape, **ranked, items, slots, store);
  if (failed(built))
    return failure();
  if (!*built)
    return std::optional<DmaAccessPoint>{};
  return composeRankedDmaAccessPoint(expressions, **ranked, items, slots,
                                     store);
}

struct RankedDmaAddress {
  sym::ExprHandle baseSelector;
  sym::ExprHandle bitOffset;
  sym::ExprHandle byteOffset;
  sym::ExprHandle zero;
  sym::ExprHandle one;
};

static FailureOr<sym::ExprHandle>
getRankedDmaByteOffset(sym::Store &store, sym::ExprHandle bitOffset) {
  FailureOr<sym::ExprHandle> ratio =
      composeIntBinary(store, bitOffset, sym::ExprBinaryOp::Div, 8);
  return failed(ratio) ? FailureOr<sym::ExprHandle>(failure())
                       : sym::composeExprFloor(store, *ratio);
}

static FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>>
getRankedDmaOrigin(const DmaExpressions &expressions,
                   const DmaAccessPoint &point, sym::ExprHandle zero,
                   sym::Store &store) {
  std::array<sym::ExprSubstitution, 2> atOrigin{
      sym::ExprSubstitution{expressions.symbols.within, zero},
      sym::ExprSubstitution{expressions.physicalItem,
                            expressions.symbols.formal}};
  FailureOr<sym::ExprHandle> item =
      sym::substituteExpr(store, point.item, atOrigin);
  FailureOr<sym::ExprHandle> slot =
      sym::substituteExpr(store, point.slot, atOrigin);
  if (failed(item) || failed(slot))
    return failure();
  return std::pair<sym::ExprHandle, sym::ExprHandle>{*item, *slot};
}

static FailureOr<RankedDmaAddress>
materializeRankedDmaAddress(const DmaPlanShape &shape,
                            const DmaExpressions &expressions,
                            const DmaAccessPoint &point, sym::Store &store) {
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> one = sym::composeExprInt(store, 1);
  if (failed(zero) || failed(one))
    return failure();
  FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>> origin =
      getRankedDmaOrigin(expressions, point, *zero, store);
  FailureOr<sym::ExprHandle> baseSelector = indexing::materialize(
      store, shape.destination->address.map, shape.destination->baseSelector);
  FailureOr<sym::ExprHandle> bitOffset =
      indexing::materialize(store, shape.destination->address.map,
                            shape.destination->address.bitOffset);
  if (failed(origin) || failed(baseSelector) || failed(bitOffset))
    return failure();
  std::array<sym::ExprSubstitution, 2> addressPoint{
      sym::ExprSubstitution{*shape.destination->axes.item, origin->first},
      sym::ExprSubstitution{shape.destination->axes.slot, origin->second}};
  baseSelector = sym::substituteExpr(store, *baseSelector, addressPoint);
  bitOffset = sym::substituteExpr(store, *bitOffset, addressPoint);
  FailureOr<sym::ExprHandle> byteOffset =
      failed(bitOffset) ? FailureOr<sym::ExprHandle>(failure())
                        : getRankedDmaByteOffset(store, *bitOffset);
  if (failed(baseSelector) || failed(bitOffset) || failed(byteOffset))
    return failure();
  return RankedDmaAddress{*baseSelector, *bitOffset, *byteOffset, *zero, *one};
}

static void appendUniformDmaInput(indexing::IndexMap &map,
                                  sym::ExprHandle variable, int64_t extent) {
  if (llvm::none_of(map.inputs, [&](const auto &input) {
        return input.variable == variable;
      }))
    map.inputs.push_back(
        {variable, extent, Value(), SymbolicOffsetBindingKind::Uniform});
}

static FailureOr<Transaction>
buildRankedDmaDestination(const DmaPlanShape &shape,
                          const DmaExpressions &expressions,
                          const DmaAccessPoint &point, sym::Store &store) {
  FailureOr<RankedDmaAddress> address =
      materializeRankedDmaAddress(shape, expressions, point, store);
  if (failed(address))
    return failure();
  Transaction result;
  result.map = shape.destination->address.map;
  appendUniformDmaInput(result.map, expressions.symbols.group,
                        shape.groupCount);
  auto itemInput = llvm::find_if(
      shape.destination->address.map.inputs, [&](const auto &input) {
        return input.variable == *shape.destination->axes.item;
      });
  assert(itemInput != shape.destination->address.map.inputs.end() &&
         itemInput->extent && "ranked DMA point requires a bounded item");
  appendUniformDmaInput(result.map, expressions.symbols.formal,
                        *itemInput->extent);
  result.addresses.push_back({shape.destination->access->bases, address->zero,
                              address->baseSelector, address->bitOffset,
                              address->byteOffset, 8});
  result.activity = address->one;
  result.outputSlot = point.slot;
  result.slot = point.slot;
  result.group = expressions.symbols.group;
  result.within = expressions.symbols.within;
  result.width = shape.elements;
  return result;
}

static FailureOr<sym::ExprHandle> buildDmaLocalItem(const DmaPlanShape &shape,
                                                    sym::ExprHandle linear,
                                                    bool itemMajor,
                                                    sym::Store &store) {
  int64_t divisor = itemMajor ? shape.source->transactionSlotCount : 1;
  FailureOr<sym::ExprHandle> ratio =
      composeIntBinary(store, linear, sym::ExprBinaryOp::Div, divisor);
  if (failed(ratio))
    return failure();
  return itemMajor ? sym::composeExprFloor(store, *ratio)
                   : composeIntBinary(store, *ratio, sym::ExprBinaryOp::Mod,
                                      shape.waveWidth);
}

static FailureOr<sym::ExprHandle> buildDmaSlot(const DmaPlanShape &shape,
                                               sym::ExprHandle linear,
                                               bool itemMajor,
                                               sym::Store &store) {
  FailureOr<sym::ExprHandle> slot =
      itemMajor ? composeIntBinary(store, linear, sym::ExprBinaryOp::Mod,
                                   shape.source->transactionSlotCount)
                : composeIntBinary(store, linear, sym::ExprBinaryOp::Div,
                                   shape.waveWidth);
  if (failed(slot) || itemMajor)
    return slot;
  return sym::composeExprFloor(store, *slot);
}
static FailureOr<DmaAccessPoint>
buildDmaAccessPoint(const DmaPlanShape &shape,
                    const DmaExpressions &expressions, sym::ExprHandle linear,
                    bool itemMajor, sym::Store &store) {
  FailureOr<sym::ExprHandle> localItem =
      buildDmaLocalItem(shape, linear, itemMajor, store);
  if (failed(localItem))
    return failure();
  FailureOr<sym::ExprHandle> item = sym::composeExprBinary(
      store, expressions.physicalWave, sym::ExprBinaryOp::Add, *localItem);
  FailureOr<sym::ExprHandle> slot =
      buildDmaSlot(shape, linear, itemMajor, store);
  if (failed(item) || failed(slot))
    return failure();
  return DmaAccessPoint{*item, *slot};
}
struct DmaOrigins {
  sym::ExprHandle sourceItem, sourceSlot, destinationItem, destinationSlot;
};
static FailureOr<DmaOrigins> buildDmaOrigins(const DmaPlanShape &shape,
                                             const DmaExpressions &expressions,
                                             const DmaAccessPoint &point,
                                             sym::Store &store) {
  std::array<sym::ExprSubstitution, 1> atOrigin{sym::ExprSubstitution{
      expressions.symbols.within, expressions.symbols.zero}};
  std::array<sym::ExprSubstitution, 2> atDestinationOrigin{
      sym::ExprSubstitution{expressions.symbols.within,
                            expressions.symbols.zero},
      sym::ExprSubstitution{expressions.physicalItem,
                            expressions.physicalWave}};
  FailureOr<sym::ExprHandle> sourceItem =
      sym::substituteExpr(store, point.item, atOrigin);
  FailureOr<sym::ExprHandle> sourceSlot =
      sym::substituteExpr(store, point.slot, atOrigin);
  FailureOr<sym::ExprHandle> destinationItem =
      sym::substituteExpr(store, point.item, atDestinationOrigin);
  FailureOr<sym::ExprHandle> destinationSlot =
      sym::substituteExpr(store, point.slot, atDestinationOrigin);
  if (failed(sourceItem) || failed(sourceSlot) || failed(destinationItem) ||
      failed(destinationSlot))
    return failure();
  return DmaOrigins{*sourceItem, *sourceSlot, *destinationItem,
                    *destinationSlot};
}
static FailureOr<bool>
proveActivityImplication(sym::Store &store, const indexing::IndexMap &proofMap,
                         ArrayRef<sym::PredHandle> assumptions,
                         sym::PredHandle goal, indexing::CheckMemo &memo) {
  indexing::IndexMap domain = proofMap;
  llvm::append_range(domain.facts, assumptions);
  FailureOr<sym::CheckResult> checked =
      indexing::check(store, domain, {goal}, memo);
  return failed(checked) ? FailureOr<bool>(failure())
                         : FailureOr<bool>(*checked == sym::CheckResult::True);
}

static FailureOr<sym::ExprHandle>
getActivityDifference(sym::Store &store, const indexing::IndexMap &proofMap,
                      sym::PredView comparison) {
  FailureOr<sym::ExprHandle> difference =
      sym::composeExprBinary(store, comparison.getCmpLhs(),
                             sym::ExprBinaryOp::Sub, comparison.getCmpRhs());
  if (failed(difference))
    return failure();
  FailureOr<SmallVector<sym::ExprHandle>> simplified =
      indexing::simplify(store, proofMap, {*difference}, {});
  return succeeded(simplified) && simplified->size() == 1
             ? FailureOr<sym::ExprHandle>(simplified->front())
             : difference;
}

static FailureOr<sym::PredHandle>
buildActivityAlignment(sym::Store &store, sym::ExprHandle difference,
                       int64_t alignment) {
  FailureOr<sym::ExprHandle> remainder =
      composeIntBinary(store, difference, sym::ExprBinaryOp::Mod, alignment);
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(remainder) || failed(zero))
    return failure();
  return sym::composePredCmp(store, *remainder, sym::PredCmpOp::Eq, *zero);
}

struct ActivityDelta {
  sym::ExprHandle rightDifference;
  sym::ExprHandle zero;
  sym::PredHandle nonnegative;
  sym::PredHandle inRange;
};

static sym::ExprHandle
simplifyActivityExpression(sym::Store &store,
                           const indexing::IndexMap &proofMap,
                           sym::ExprHandle expression) {
  FailureOr<SmallVector<sym::ExprHandle>> simplified =
      indexing::simplify(store, proofMap, {expression}, {});
  return succeeded(simplified) && simplified->size() == 1 ? simplified->front()
                                                          : expression;
}

static FailureOr<ActivityDelta>
buildActivityDelta(sym::Store &store, const indexing::IndexMap &proofMap,
                   sym::PredView rightComparison,
                   sym::ExprHandle leftDifference, int64_t alignment) {
  FailureOr<sym::ExprHandle> rightDifference =
      getActivityDifference(store, proofMap, rightComparison);
  if (failed(rightDifference))
    return failure();
  FailureOr<sym::ExprHandle> delta = sym::composeExprBinary(
      store, *rightDifference, sym::ExprBinaryOp::Sub, leftDifference);
  if (failed(delta))
    return failure();
  *delta = simplifyActivityExpression(store, proofMap, *delta);
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> alignmentValue =
      sym::composeExprInt(store, alignment);
  if (failed(zero) || failed(alignmentValue))
    return failure();
  FailureOr<sym::PredHandle> nonnegative =
      sym::composePredCmp(store, *delta, sym::PredCmpOp::Ge, *zero);
  FailureOr<sym::PredHandle> inRange =
      sym::composePredCmp(store, *delta, sym::PredCmpOp::Lt, *alignmentValue);
  if (failed(nonnegative) || failed(inRange))
    return failure();
  return ActivityDelta{*rightDifference, *zero, *nonnegative, *inRange};
}

static FailureOr<bool> proveActivityDelta(sym::Store &store,
                                          const indexing::IndexMap &proofMap,
                                          sym::PredHandle condition,
                                          const ActivityDelta &delta,
                                          indexing::CheckMemo &memo) {
  FailureOr<bool> nonnegative = proveActivityImplication(
      store, proofMap, {condition}, delta.nonnegative, memo);
  FailureOr<bool> inRange = proveActivityImplication(
      store, proofMap, {condition}, delta.inRange, memo);
  if (failed(nonnegative) || failed(inRange))
    return failure();
  return *nonnegative && *inRange;
}

static LogicalResult
appendActivityMargin(sym::Store &store, sym::PredCmpOp operation,
                     int64_t alignment, sym::ExprHandle difference,
                     SmallVectorImpl<sym::PredHandle> &assumptions) {
  if (operation != sym::PredCmpOp::Lt)
    return success();
  FailureOr<sym::ExprHandle> marginValue =
      sym::composeExprInt(store, -alignment);
  FailureOr<sym::PredHandle> margin =
      failed(marginValue)
          ? FailureOr<sym::PredHandle>(failure())
          : sym::composePredCmp(store, difference, sym::PredCmpOp::Le,
                                *marginValue);
  if (failed(margin))
    return failure();
  // Divisible negative value is at most -alignment.
  assumptions.push_back(*margin);
  return success();
}

static FailureOr<bool> proveNormalizedActivityComparison(
    sym::Store &store, const indexing::IndexMap &proofMap,
    sym::PredCmpOp operation, sym::ExprHandle leftDifference,
    sym::PredHandle condition, sym::PredHandle aligned,
    const ActivityDelta &delta, int64_t alignment, indexing::CheckMemo &memo) {
  FailureOr<sym::PredHandle> normalizedLeft =
      sym::composePredCmp(store, leftDifference, operation, delta.zero);
  FailureOr<sym::PredHandle> normalizedRight =
      sym::composePredCmp(store, delta.rightDifference, operation, delta.zero);
  if (failed(normalizedLeft) || failed(normalizedRight))
    return failure();
  SmallVector<sym::PredHandle> forwardAssumptions{
      condition, aligned, delta.nonnegative, delta.inRange, *normalizedLeft};
  if (failed(appendActivityMargin(store, operation, alignment, leftDifference,
                                  forwardAssumptions)))
    return failure();
  FailureOr<bool> forward = proveActivityImplication(
      store, proofMap, forwardAssumptions, *normalizedRight, memo);
  FailureOr<bool> reverse = proveActivityImplication(
      store, proofMap,
      {condition, aligned, delta.nonnegative, delta.inRange, *normalizedRight},
      *normalizedLeft, memo);
  if (failed(forward) || failed(reverse))
    return failure();
  return *forward && *reverse;
}

static bool haveMatchingActivityComparison(sym::PredView left,
                                           sym::PredView right) {
  return left.getKind() == sym::PredKind::Cmp &&
         right.getKind() == sym::PredKind::Cmp &&
         left.getCmpOp() == right.getCmpOp();
}

static FailureOr<bool>
proveActivityComparison(sym::Store &store, const indexing::IndexMap &proofMap,
                        sym::PredHandle leftValue, sym::PredHandle rightValue,
                        sym::PredHandle condition, int64_t alignment,
                        indexing::CheckMemo &memo) {
  sym::PredView left(leftValue);
  sym::PredView right(rightValue);
  bool matchingComparison = haveMatchingActivityComparison(left, right);
  if (!matchingComparison)
    return false;
  FailureOr<sym::ExprHandle> difference =
      getActivityDifference(store, proofMap, left);
  FailureOr<sym::PredHandle> aligned =
      failed(difference)
          ? FailureOr<sym::PredHandle>(failure())
          : buildActivityAlignment(store, *difference, alignment);
  if (failed(aligned))
    return failure();
  FailureOr<bool> provenAligned =
      proveActivityImplication(store, proofMap, {condition}, *aligned, memo);
  if (failed(provenAligned) || !*provenAligned)
    return provenAligned;
  FailureOr<ActivityDelta> delta =
      buildActivityDelta(store, proofMap, right, *difference, alignment);
  if (failed(delta))
    return failure();
  FailureOr<bool> provenDelta =
      proveActivityDelta(store, proofMap, condition, *delta, memo);
  if (failed(provenDelta) || !*provenDelta)
    return provenDelta;
  return proveNormalizedActivityComparison(store, proofMap, *left.getCmpOp(),
                                           *difference, condition, *aligned,
                                           *delta, alignment, memo);
}

static bool haveMatchingActivityConditions(sym::ExprView left,
                                           sym::ExprView right) {
  if (left.getPiecewiseCaseCount() != right.getPiecewiseCaseCount())
    return false;
  for (uint32_t index = 0; index < left.getPiecewiseCaseCount(); ++index)
    if (!(left.getPiecewiseCase(index).condition ==
          right.getPiecewiseCase(index).condition))
      return false;
  return true;
}

static FailureOr<bool> proveMatchingActivityCases(
    sym::Store &store, const indexing::IndexMap &proofMap, sym::ExprView left,
    sym::ExprView right, int64_t alignment, indexing::CheckMemo &memo) {
  for (uint32_t index = 0; index < left.getPiecewiseCaseCount(); ++index) {
    sym::PiecewiseCase leftCase = left.getPiecewiseCase(index);
    sym::PiecewiseCase rightCase = right.getPiecewiseCase(index);
    std::optional<sym::PredHandle> leftValue = sym::asPred(leftCase.value);
    std::optional<sym::PredHandle> rightValue = sym::asPred(rightCase.value);
    if (!leftValue || !rightValue)
      return false;
    FailureOr<bool> equivalent =
        proveActivityComparison(store, proofMap, *leftValue, *rightValue,
                                leftCase.condition, alignment, memo);
    if (failed(equivalent) || !*equivalent)
      return equivalent;
  }
  return true;
}

static FailureOr<SmallVector<sym::PredHandle>>
buildActivityCaseSelectors(sym::Store &store, sym::ExprView view) {
  SmallVector<sym::PredHandle> selectors;
  SmallVector<sym::PredHandle> prior;
  selectors.reserve(view.getPiecewiseCaseCount());
  prior.reserve(view.getPiecewiseCaseCount());
  for (uint32_t index = 0; index < view.getPiecewiseCaseCount(); ++index) {
    sym::PredHandle condition = view.getPiecewiseCase(index).condition;
    sym::PredHandle selected = condition;
    for (sym::PredHandle earlier : prior) {
      FailureOr<sym::PredHandle> inactive = sym::composePredNot(store, earlier);
      FailureOr<sym::PredHandle> combined =
          failed(inactive) ? FailureOr<sym::PredHandle>(failure())
                           : sym::composePredAnd(store, selected, *inactive);
      if (failed(combined))
        return failure();
      selected = *combined;
    }
    selectors.push_back(selected);
    prior.push_back(condition);
  }
  return selectors;
}

static FailureOr<bool>
proveCrossActivityCases(sym::Store &store, const indexing::IndexMap &proofMap,
                        sym::ExprView left, sym::ExprView right,
                        ArrayRef<sym::PredHandle> leftSelectors,
                        ArrayRef<sym::PredHandle> rightSelectors,
                        int64_t alignment, indexing::CheckMemo &memo) {
  for (uint32_t leftIndex = 0; leftIndex < left.getPiecewiseCaseCount();
       ++leftIndex) {
    std::optional<sym::PredHandle> leftValue =
        sym::asPred(left.getPiecewiseCase(leftIndex).value);
    if (!leftValue)
      return false;
    for (uint32_t rightIndex = 0; rightIndex < right.getPiecewiseCaseCount();
         ++rightIndex) {
      std::optional<sym::PredHandle> rightValue =
          sym::asPred(right.getPiecewiseCase(rightIndex).value);
      if (!rightValue)
        return false;
      FailureOr<sym::PredHandle> selected = sym::composePredAnd(
          store, leftSelectors[leftIndex], rightSelectors[rightIndex]);
      if (failed(selected))
        return failure();
      FailureOr<bool> equivalent = proveActivityComparison(
          store, proofMap, *leftValue, *rightValue, *selected, alignment, memo);
      if (failed(equivalent) || !*equivalent)
        return equivalent;
    }
  }
  return true;
}

static bool haveMatchingActivityLogic(sym::PredView left, sym::PredView right) {
  bool logical = left.getKind() == sym::PredKind::And ||
                 left.getKind() == sym::PredKind::Or;
  return logical && left.getKind() == right.getKind() &&
         left.getLogicArgCount() == right.getLogicArgCount();
}

static FailureOr<bool> proveMatchingActivityLogic(
    sym::Store &store, const indexing::IndexMap &proofMap, sym::PredView left,
    sym::PredView right, int64_t alignment, indexing::CheckMemo &memo) {
  for (uint32_t index : llvm::seq<uint32_t>(0, left.getLogicArgCount())) {
    FailureOr<bool> equivalent =
        proveActivityEquivalent(store, proofMap, left.getLogicArg(index),
                                right.getLogicArg(index), alignment, memo);
    if (failed(equivalent) || !*equivalent)
      return equivalent;
  }
  return true;
}

static FailureOr<bool> provePiecewiseActivityEquivalent(
    sym::Store &store, const indexing::IndexMap &proofMap, sym::ExprView left,
    sym::ExprView right, int64_t alignment, indexing::CheckMemo &memo) {
  if (left.getPiecewiseCaseCount() != right.getPiecewiseCaseCount())
    return false;
  if (haveMatchingActivityConditions(left, right))
    return proveMatchingActivityCases(store, proofMap, left, right, alignment,
                                      memo);
  FailureOr<SmallVector<sym::PredHandle>> leftSelectors =
      buildActivityCaseSelectors(store, left);
  FailureOr<SmallVector<sym::PredHandle>> rightSelectors =
      buildActivityCaseSelectors(store, right);
  if (failed(leftSelectors) || failed(rightSelectors))
    return failure();
  return proveCrossActivityCases(store, proofMap, left, right, *leftSelectors,
                                 *rightSelectors, alignment, memo);
}

static FailureOr<bool>
proveActivityEquivalent(sym::Store &store, const indexing::IndexMap &proofMap,
                        sym::PredHandle lhs, sym::PredHandle rhs,
                        int64_t alignment, indexing::CheckMemo &memo) {
  if (lhs == rhs)
    return true;
  sym::PredView leftPredicate(lhs);
  sym::PredView rightPredicate(rhs);
  if (leftPredicate.getKind() == sym::PredKind::Not &&
      rightPredicate.getKind() == sym::PredKind::Not)
    return proveActivityEquivalent(store, proofMap, leftPredicate.getUnaryArg(),
                                   rightPredicate.getUnaryArg(), alignment,
                                   memo);
  if (haveMatchingActivityLogic(leftPredicate, rightPredicate))
    return proveMatchingActivityLogic(store, proofMap, leftPredicate,
                                      rightPredicate, alignment, memo);
  sym::ExprView left(sym::asExpr(lhs));
  sym::ExprView right(sym::asExpr(rhs));
  if (left.getKind() == sym::ExprKind::Piecewise &&
      right.getKind() == sym::ExprKind::Piecewise)
    return provePiecewiseActivityEquivalent(store, proofMap, left, right,
                                            alignment, memo);
  FailureOr<sym::PredHandle> unconditional = sym::composePredTrue(store);
  if (failed(unconditional))
    return failure();
  return proveActivityComparison(store, proofMap, lhs, rhs, *unconditional,
                                 alignment, memo);
}
static FailureOr<sym::PredHandle>
getDmaPacketDomainSelector(const DmaAccessPoint &point,
                           const PacketActivityDomain &domain, bool last,
                           sym::Store &store) {
  if (last)
    return sym::composePredTrue(store);
  FailureOr<sym::ExprHandle> end =
      sym::composeExprInt(store, domain.firstSlot + domain.slotCount);
  return failed(end)
             ? FailureOr<sym::PredHandle>(failure())
             : sym::composePredCmp(store, point.slot, sym::PredCmpOp::Lt, *end);
}
static FailureOr<sym::PredHandle>
buildDmaPacketActivity(const DmaPlanShape &shape, const DmaAccessPoint &point,
                       ArrayRef<sym::ExprSubstitution> remap,
                       sym::Store &store) {
  ArrayRef<PacketActivityDomain> domains = shape.source->packetActivityDomains;
  assert(domains.front().firstSlot == 0 &&
         domains.back().firstSlot + domains.back().slotCount ==
             shape.source->shape.slotCount &&
         "packet activity domains must cover every slot");
  SmallVector<sym::PiecewiseCase> cases;
  cases.reserve(domains.size());
  for (auto [index, domain] : llvm::enumerate(domains)) {
    if (index)
      assert(domains[index - 1].firstSlot + domains[index - 1].slotCount ==
                 domain.firstSlot &&
             "packet activity domains must be contiguous");
    FailureOr<sym::PredHandle> value =
        sym::substitutePred(store, domain.active, remap);
    FailureOr<sym::PredHandle> selected = getDmaPacketDomainSelector(
        point, domain, index + 1 == domains.size(), store);
    if (failed(value) || failed(selected))
      return failure();
    cases.push_back({sym::asExpr(*value), *selected});
  }
  FailureOr<sym::ExprHandle> packet = sym::composeExprPiecewise(store, cases);
  std::optional<sym::PredHandle> predicate =
      failed(packet) ? std::nullopt : sym::asPred(*packet);
  return predicate ? FailureOr<sym::PredHandle>(*predicate)
                   : FailureOr<sym::PredHandle>(failure());
}
static FailureOr<sym::PredHandle> remapDmaActivity(const DmaPlanShape &shape,
                                                   const DmaAccessPoint &point,
                                                   sym::Store &store) {
  std::array<sym::ExprSubstitution, 2> remap{
      sym::ExprSubstitution{*shape.source->axes.item, point.item},
      sym::ExprSubstitution{shape.source->axes.slot, point.slot}};
  FailureOr<sym::PredHandle> active =
      sym::substitutePred(store, shape.source->address.active, remap);
  if (failed(active) || shape.source->packetActivityDomains.empty())
    return active;
  FailureOr<sym::PredHandle> packet =
      buildDmaPacketActivity(shape, point, remap, store);
  if (failed(packet))
    return failure();
  return sym::composePredAnd(store, *active, *packet);
}
static indexing::IndexMap
buildDmaActivityProofMap(const DmaPlanShape &shape,
                         const DmaExpressions &expressions) {
  indexing::IndexMap proofMap = shape.source->address.map;
  for (const PacketActivityDomain &domain : shape.source->packetActivityDomains)
    for (sym::PredHandle fact : domain.facts)
      if (!llvm::is_contained(proofMap.facts, fact))
        proofMap.facts.push_back(fact);
  proofMap.inputs.push_back({expressions.symbols.group, shape.groupCount,
                             Value(), SymbolicOffsetBindingKind::Uniform});
  return proofMap;
}
static FailureOr<bool>
proveUniformDmaActivity(const DmaPlanShape &shape,
                        const DmaExpressions &expressions,
                        sym::PredHandle mapped, sym::PredHandle origin,
                        const indexing::IndexMap &proofMap, sym::Store &store,
                        indexing::CheckMemo &memo) {
  for (int64_t index = 1; index < shape.elements; ++index) {
    FailureOr<sym::ExprHandle> within = sym::composeExprInt(store, index);
    if (failed(within))
      return failure();
    std::array<sym::ExprSubstitution, 1> atPoint{
        sym::ExprSubstitution{expressions.symbols.within, *within}};
    FailureOr<sym::PredHandle> actual =
        sym::substitutePred(store, mapped, atPoint);
    if (failed(actual))
      return failure();
    FailureOr<bool> equivalent = proveActivityEquivalent(
        store, proofMap, origin, *actual, shape.elements, memo);
    if (failed(equivalent) || !*equivalent)
      return equivalent;
  }
  return true;
}
static FailureOr<std::optional<sym::PredHandle>>
uniformDmaActivity(const DmaPlanShape &shape, const DmaExpressions &expressions,
                   const DmaAccessPoint &point, sym::Store &store,
                   indexing::CheckMemo &memo) {
  FailureOr<sym::PredHandle> mapped = remapDmaActivity(shape, point, store);
  if (failed(mapped))
    return failure();
  indexing::IndexMap proofMap = buildDmaActivityProofMap(shape, expressions);
  std::array<sym::ExprSubstitution, 1> atOrigin{sym::ExprSubstitution{
      expressions.symbols.within, expressions.symbols.zero}};
  FailureOr<sym::PredHandle> origin =
      sym::substitutePred(store, *mapped, atOrigin);
  if (failed(origin))
    return failure();
  FailureOr<bool> uniform = proveUniformDmaActivity(
      shape, expressions, *mapped, *origin, proofMap, store, memo);
  if (failed(uniform))
    return failure();
  return *uniform ? std::optional<sym::PredHandle>{*origin}
                  : std::optional<sym::PredHandle>{};
}
static FailureOr<std::optional<SmallVector<const PacketActivityDomain *>>>
collectUniformDmaGroupActivities(const DmaPlanShape &shape, sym::Store &store,
                                 indexing::CheckMemo &memo) {
  const AccessMap &source = *shape.source;
  SmallVector<const PacketActivityDomain *> activities;
  activities.reserve(shape.groupCount);
  for (int64_t group = 0; group < shape.groupCount; ++group) {
    int64_t first = source.transactionFirstSlot + group * shape.elements;
    const PacketActivityDomain *origin =
        findPacketActivityDomain(source, first);
    if (!origin)
      return std::optional<SmallVector<const PacketActivityDomain *>>{};
    for (int64_t within = 1; within < shape.elements; ++within) {
      const PacketActivityDomain *point =
          findPacketActivityDomain(source, first + within);
      if (!point)
        return std::optional<SmallVector<const PacketActivityDomain *>>{};
      FailureOr<bool> equivalent = proveEquivalentPacketActivity(
          source, *origin, *point, shape.elements, store, memo);
      if (failed(equivalent))
        return failure();
      if (!*equivalent)
        return std::optional<SmallVector<const PacketActivityDomain *>>{};
    }
    activities.push_back(origin);
  }
  return std::optional<SmallVector<const PacketActivityDomain *>>{
      std::move(activities)};
}
static void setRemappedDmaLayouts(const DmaExpressions &expressions,
                                  const DmaAccessPoint &point,
                                  const DmaOrigins &origins,
                                  DmaFamilies &families) {
  families.sourceLayout.group = families.destinationLayout.group =
      expressions.symbols.group;
  families.sourceLayout.within = families.destinationLayout.within =
      expressions.symbols.within;
  families.sourceLayout.accessItem = families.destinationLayout.accessItem =
      point.item;
  families.sourceLayout.slot = families.destinationLayout.slot = point.slot;
  families.sourceLayout.originItem = origins.sourceItem;
  families.sourceLayout.originSlot = origins.sourceSlot;
  families.sourceLayout.displacement = expressions.withinBits;
  families.destinationLayout.originItem = origins.destinationItem;
  families.destinationLayout.originSlot = origins.destinationSlot;
  families.destinationLayout.displacement = expressions.destinationDisplacement;
}
static LogicalResult makeDmaSourceUnconditional(AccessMap &source,
                                                sym::Store &store) {
  FailureOr<sym::PredHandle> active = sym::composePredTrue(store);
  if (failed(active))
    return failure();
  source.address.active = *active;
  source.packetActivityDomains.clear();
  return success();
}
static LogicalResult applyUniformDmaActivity(Transaction &source,
                                             sym::PredHandle uniformActivity,
                                             const DmaPlanShape &shape,
                                             sym::Store &store) {
  FailureOr<sym::ExprHandle> activity =
      composeIndexExprIndicator(store, uniformActivity);
  if (failed(activity))
    return failure();
  source.activity = *activity;
  if (shape.source->packetActivityDomains.size() != 1)
    return success();
  const PacketActivityDomain &domain =
      shape.source->packetActivityDomains.front();
  if (domain.firstSlot == 0 &&
      domain.slotCount == shape.source->shape.slotCount)
    source.condition = domain.condition;
  return success();
}
struct RemappedDmaTransactions {
  std::optional<Transaction> source;
  std::optional<Transaction> destination;
};
static FailureOr<RemappedDmaTransactions> buildRemappedDmaTransactions(
    const DmaPlanShape &shape, const AccessMap &sourceAccess,
    const DmaFamilies &families, sym::Store &store, indexing::CheckMemo &memo) {
  FailureOr<std::optional<Transaction>> source =
      buildTransaction(sourceAccess, families.sourceLayout, store, memo,
                       std::nullopt, shape.windowBytes);
  FailureOr<std::optional<Transaction>> destination =
      buildTransaction(*shape.destination, families.destinationLayout, store,
                       memo, families.destinationProjection, shape.windowBytes);
  if (failed(source) || failed(destination))
    return failure();
  return RemappedDmaTransactions{std::move(*source), std::move(*destination)};
}
static LogicalResult
commitRemappedDmaTransactions(const DmaPlanShape &shape,
                              std::optional<sym::PredHandle> uniformActivity,
                              RemappedDmaTransactions transactions,
                              DmaFamilies &families, sym::Store &store) {
  if (uniformActivity && transactions.source &&
      failed(applyUniformDmaActivity(*transactions.source, *uniformActivity,
                                     shape, store)))
    return failure();
  families.source = std::move(transactions.source);
  families.destination = std::move(transactions.destination);
  return success();
}
static LogicalResult remapDmaOwnershipAtPoint(const DmaPlanShape &shape,
                                              const DmaExpressions &expressions,
                                              const DmaAccessPoint &point,
                                              DmaFamilies &families,
                                              sym::Store &store,
                                              indexing::CheckMemo &memo) {
  FailureOr<DmaOrigins> origins =
      buildDmaOrigins(shape, expressions, point, store);
  if (failed(origins))
    return failure();
  setRemappedDmaLayouts(expressions, point, *origins, families);
  AccessMap sourceAccess = *shape.source;
  FailureOr<std::optional<sym::PredHandle>> uniformActivity =
      uniformDmaActivity(shape, expressions, point, store, memo);
  if (failed(uniformActivity))
    return failure();
  if (!*uniformActivity && !shape.source->packetActivityDomains.empty())
    return success();
  if (*uniformActivity &&
      failed(makeDmaSourceUnconditional(sourceAccess, store)))
    return failure();
  FailureOr<RemappedDmaTransactions> transactions =
      buildRemappedDmaTransactions(shape, sourceAccess, families, store, memo);
  if (failed(transactions))
    return failure();
  return commitRemappedDmaTransactions(
      shape, *uniformActivity, std::move(*transactions), families, store);
}

static LogicalResult remapDmaOwnership(const DmaPlanShape &shape,
                                       const DmaExpressions &expressions,
                                       DmaFamilies &families, sym::Store &store,
                                       indexing::CheckMemo &memo,
                                       bool itemMajor = false) {
  FailureOr<sym::ExprHandle> linear = buildDmaLinear(shape, expressions, store);
  if (failed(linear))
    return failure();
  FailureOr<DmaAccessPoint> point =
      buildDmaAccessPoint(shape, expressions, *linear, itemMajor, store);
  return failed(point) ? failure()
                       : remapDmaOwnershipAtPoint(shape, expressions, *point,
                                                  families, store, memo);
}
static FailureOr<DmaPlan>
instantiateDmaPlan(const DmaPlanShape &shape, const DmaExpressions &expressions,
                   DmaFamilies &families,
                   const wave::memory_lowering::CopyTransaction &selected,
                   bool zeroFillInactive, sym::Store &store) {
  DmaPlan result{{},
                 selected.emitter,
                 shape.bytes,
                 zeroFillInactive,
                 expressions.physicalWave,
                 expressions.symbols.formal};
  for (int64_t group = 0; group < shape.groupCount; ++group) {
    FailureOr<Transaction> source = instantiateTransaction(
        *shape.source, *families.source, group, false, store);
    FailureOr<Transaction> destination = instantiateTransaction(
        *shape.destination, *families.destination, group, false, store);
    if (failed(source) || failed(destination))
      return failure();
    source->activity =
        zeroFillInactive ? source->activity : expressions.symbols.one;
    result.transactions.push_back(
        {std::move(*source), std::move(*destination)});
  }
  return result;
}
static void
specializeDmaGroupActivity(AccessMap &source,
                           ArrayRef<const PacketActivityDomain *> activities,
                           int64_t group) {
  if (activities.empty())
    return;
  source.address.active = activities[group]->active;
  source.condition = activities[group]->condition;
  source.packetActivityDomains.clear();
}
static LogicalResult applySpecializedDmaGroupActivity(
    Transaction &source, ArrayRef<const PacketActivityDomain *> activities,
    int64_t group, sym::Store &store) {
  if (activities.empty())
    return success();
  FailureOr<sym::ExprHandle> activity =
      composeIndexExprIndicator(store, activities[group]->active);
  if (failed(activity))
    return failure();
  source.activity = *activity;
  source.condition = activities[group]->condition;
  return success();
}
static bool failedDmaTransactionPair(
    const FailureOr<std::optional<Transaction>> &source,
    const FailureOr<std::optional<Transaction>> &destination) {
  return failed(source) || failed(destination);
}
static FailureOr<std::optional<DmaTransaction>> buildSpecializedDmaTransaction(
    const DmaPlanShape &shape, const DmaExpressions &expressions,
    bool zeroFillInactive,
    ArrayRef<const PacketActivityDomain *> groupActivities, int64_t group,
    sym::Store &store, indexing::CheckMemo &memo) {
  int64_t firstSlot = group * shape.elements;
  FailureOr<sym::ExprHandle> first = sym::composeExprInt(store, firstSlot);
  FailureOr<sym::ExprHandle> slot =
      failed(first)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, *first, sym::ExprBinaryOp::Add,
                                   expressions.symbols.within);
  if (failed(slot))
    return failure();
  AccessMap sourceAccess =
      specializeTransactionRange(*shape.source, firstSlot, shape.elements);
  AccessMap destinationAccess =
      specializeTransactionRange(*shape.destination, firstSlot, shape.elements);
  specializeDmaGroupActivity(sourceAccess, groupActivities, group);
  Layout sourceLayout;
  sourceLayout.width = shape.elements;
  sourceLayout.groupCount = 1;
  sourceLayout.within = expressions.symbols.within;
  sourceLayout.slot = *slot;
  sourceLayout.originSlot = *first;
  Layout destinationLayout = sourceLayout;
  destinationLayout.originItem = expressions.physicalWave;
  destinationLayout.displacement = expressions.destinationDisplacement;
  MemoryTransactionProjection projection{expressions.physicalItem,
                                         expressions.physicalWave,
                                         expressions.symbols.formal};
  FailureOr<std::optional<Transaction>> source = buildTransaction(
      sourceAccess, sourceLayout, store, memo, std::nullopt, shape.windowBytes);
  FailureOr<std::optional<Transaction>> destination =
      buildTransaction(destinationAccess, destinationLayout, store, memo,
                       projection, shape.windowBytes);
  if (failedDmaTransactionPair(source, destination))
    return failure();
  if (!*source || !*destination)
    return std::optional<DmaTransaction>{};
  FailureOr<Transaction> sourceTransaction =
      instantiateTransaction(sourceAccess, **source, 0, false, store);
  FailureOr<Transaction> destinationTransaction =
      instantiateTransaction(destinationAccess, **destination, 0, false, store);
  if (failed(sourceTransaction) || failed(destinationTransaction))
    return failure();
  if (failed(applySpecializedDmaGroupActivity(*sourceTransaction,
                                              groupActivities, group, store)))
    return failure();
  sourceTransaction->activity =
      zeroFillInactive ? sourceTransaction->activity : expressions.symbols.one;
  return std::optional<DmaTransaction>{DmaTransaction{
      std::move(*sourceTransaction), std::move(*destinationTransaction)}};
}
static FailureOr<std::optional<DmaPlan>>
buildSpecializedDmaPlan(const DmaPlanShape &shape,
                        const DmaExpressions &expressions,
                        const wave::memory_lowering::CopyTransaction &selected,
                        bool zeroFillInactive,
                        ArrayRef<const PacketActivityDomain *> groupActivities,
                        sym::Store &store, indexing::CheckMemo &memo) {
  DmaPlan result{{},
                 selected.emitter,
                 shape.bytes,
                 zeroFillInactive,
                 expressions.physicalWave,
                 expressions.symbols.formal};
  for (int64_t group = 0; group < shape.groupCount; ++group) {
    FailureOr<std::optional<DmaTransaction>> transaction =
        buildSpecializedDmaTransaction(shape, expressions, zeroFillInactive,
                                       groupActivities, group, store, memo);
    if (failed(transaction))
      return failure();
    if (!*transaction)
      return std::optional<DmaPlan>{};
    result.transactions.push_back(std::move(**transaction));
  }
  return std::optional<DmaPlan>{std::move(result)};
}
static FailureOr<std::optional<sym::PredHandle>>
getNaturalDmaActivity(const DmaPlanShape &shape,
                      const DmaExpressions &expressions, sym::Store &store,
                      indexing::CheckMemo &memo) {
  FailureOr<sym::ExprHandle> groupBase = composeIntBinary(
      store, expressions.symbols.group, sym::ExprBinaryOp::Mul, shape.elements);
  FailureOr<sym::ExprHandle> slot =
      failed(groupBase)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, *groupBase, sym::ExprBinaryOp::Add,
                                   expressions.symbols.within);
  if (failed(slot))
    return failure();
  DmaAccessPoint point{expressions.physicalItem, *slot};
  return uniformDmaActivity(shape, expressions, point, store, memo);
}
static FailureOr<DmaFamilies> buildUnconditionalDmaFamilies(
    const AccessGroup &prepared,
    const wave::memory_lowering::CopyTransaction &selected,
    const DmaExpressions &expressions, sym::Store &store,
    indexing::CheckMemo &memo) {
  AccessGroup unconditional = prepared;
  FailureOr<sym::PredHandle> active = sym::composePredTrue(store);
  if (failed(active))
    return failure();
  unconditional[0].address.active = *active;
  std::optional<DmaPlanShape> shape = getDmaPlanShape(unconditional, selected);
  if (!shape)
    return failure();
  return buildInitialDmaFamilies(*shape, expressions, store, memo);
}
static LogicalResult recoverUniformDmaFamilies(
    const AccessGroup &prepared,
    const wave::memory_lowering::CopyTransaction &selected,
    const DmaPlanShape &shape, const DmaExpressions &expressions,
    DmaFamilies &families, sym::Store &store, indexing::CheckMemo &memo) {
  FailureOr<std::optional<sym::PredHandle>> uniformActivity =
      getNaturalDmaActivity(shape, expressions, store, memo);
  if (failed(uniformActivity))
    return failure();
  if (!*uniformActivity)
    return success();
  FailureOr<DmaFamilies> unconditional = buildUnconditionalDmaFamilies(
      prepared, selected, expressions, store, memo);
  if (failed(unconditional))
    return failure();
  if (!unconditional->source || !unconditional->destination)
    return success();
  FailureOr<sym::ExprHandle> activity =
      composeIndexExprIndicator(store, **uniformActivity);
  if (failed(activity))
    return failure();
  unconditional->source->activity = *activity;
  unconditional->source->active = **uniformActivity;
  if (shape.groupCount == 1 && !shape.source->packetActivityDomains.empty())
    unconditional->source->condition =
        shape.source->packetActivityDomains.front().condition;
  families = std::move(*unconditional);
  return success();
}
static LogicalResult tryRankDmaOwnership(const DmaPlanShape &shape,
                                         const DmaExpressions &expressions,
                                         DmaFamilies &families,
                                         sym::Store &store,
                                         indexing::CheckMemo &memo) {
  FailureOr<std::optional<DmaAccessPoint>> point =
      buildRankedDmaAccessPoint(shape, expressions, store);
  if (failed(point))
    return failure();
  if (!*point)
    return success();
  if (failed(remapDmaOwnershipAtPoint(shape, expressions, **point, families,
                                      store, memo)))
    return failure();
  if (!families.source || families.destination)
    return success();
  FailureOr<Transaction> destination =
      buildRankedDmaDestination(shape, expressions, **point, store);
  if (failed(destination))
    return failure();
  families.destination = std::move(*destination);
  return success();
}
static LogicalResult tryNaturalDmaOwnership(const DmaPlanShape &shape,
                                            const DmaExpressions &expressions,
                                            DmaFamilies &families,
                                            sym::Store &store,
                                            indexing::CheckMemo &memo) {
  if (failed(remapDmaOwnership(shape, expressions, families, store, memo)))
    return failure();
  if (families.source && families.destination)
    return success();
  return remapDmaOwnership(shape, expressions, families, store, memo,
                           /*itemMajor=*/true);
}
static FailureOr<std::optional<DmaPlan>> buildFallbackDmaPlan(
    const DmaPlanShape &shape, const DmaExpressions &expressions,
    const wave::memory_lowering::CopyTransaction &selected,
    bool zeroFillInactive, sym::Store &store, indexing::CheckMemo &memo) {
  if (!shape.source->packetActivityDomains.empty()) {
    FailureOr<std::optional<SmallVector<const PacketActivityDomain *>>>
        activities = collectUniformDmaGroupActivities(shape, store, memo);
    if (failed(activities))
      return failure();
    if (!*activities)
      return std::optional<DmaPlan>{};
    return buildSpecializedDmaPlan(shape, expressions, selected,
                                   zeroFillInactive, **activities, store, memo);
  }
  FailureOr<std::optional<DmaPlan>> specialized = buildSpecializedDmaPlan(
      shape, expressions, selected, zeroFillInactive, {}, store, memo);
  if (failed(specialized) || *specialized)
    return specialized;
  return std::optional<DmaPlan>{};
}
static FailureOr<DmaFamilies>
prepareDmaFamilies(const AccessGroup &prepared,
                   const wave::memory_lowering::CopyTransaction &selected,
                   const DmaPlanShape &shape, const DmaExpressions &expressions,
                   bool zeroFillInactive, sym::Store &store,
                   indexing::CheckMemo &memo) {
  FailureOr<DmaFamilies> families =
      buildInitialDmaFamilies(shape, expressions, store, memo);
  if (failed(families))
    return failure();
  if (zeroFillInactive && !shape.source->packetActivityDomains.empty())
    families->source.reset();
  if (zeroFillInactive && (!families->source || !families->destination))
    if (failed(recoverUniformDmaFamilies(prepared, selected, shape, expressions,
                                         *families, store, memo)))
      return failure();
  return families;
}
static LogicalResult refineDmaFamilies(const DmaPlanShape &shape,
                                       const DmaExpressions &expressions,
                                       DmaFamilies &families,
                                       bool zeroFillInactive, sym::Store &store,
                                       indexing::CheckMemo &memo) {
  if (canRankDmaOwnership(shape, families, zeroFillInactive))
    if (failed(tryRankDmaOwnership(shape, expressions, families, store, memo)))
      return failure();
  if (canRemapDmaOwnership(shape, families, zeroFillInactive))
    if (failed(
            tryNaturalDmaOwnership(shape, expressions, families, store, memo)))
      return failure();
  return success();
}
static FailureOr<std::optional<DmaPlan>>
planDmaCopy(const AccessGroup &prepared,
            const wave::memory_lowering::CopyTransaction &selected,
            bool zeroFillInactive, WaveDialect &dialect) {
  std::optional<DmaPlanShape> shape = getDmaPlanShape(prepared, selected);
  if (!shape)
    return std::optional<DmaPlan>{};
  sym::Store &store = dialect.getSymbolStore();
  indexing::CheckMemo memo;
  FailureOr<DmaExpressions> expressions = buildDmaExpressions(*shape, store);
  if (failed(expressions)) {
    shape->source->access->op->emitOpError("failed to build DMA expressions");
    return failure();
  }
  FailureOr<DmaFamilies> families = prepareDmaFamilies(
      prepared, selected, *shape, *expressions, zeroFillInactive, store, memo);
  if (failed(families))
    return failure();
  if (failed(refineDmaFamilies(*shape, *expressions, *families,
                               zeroFillInactive, store, memo)))
    return failure();
  if (!families->source || !families->destination)
    return buildFallbackDmaPlan(*shape, *expressions, selected,
                                zeroFillInactive, store, memo);
  FailureOr<DmaPlan> plan = instantiateDmaPlan(
      *shape, *expressions, *families, selected, zeroFillInactive, store);
  return failed(plan) ? FailureOr<std::optional<DmaPlan>>(failure())
                      : std::optional<DmaPlan>{std::move(*plan)};
}
static bool specializeWholePacketActivity(AccessGroup &prepared) {
  for (AccessMap &access : prepared) {
    if (access.packetActivityDomains.empty())
      continue;
    if (access.packetActivityDomains.size() != 1)
      return false;
    const PacketActivityDomain &domain = access.packetActivityDomains.front();
    if (domain.firstSlot != 0 || domain.slotCount != access.shape.slotCount)
      return false;
    access = specializePacketActivity(access, domain);
  }
  return true;
}
static void appendDmaPlan(DmaPlan &result, DmaPlan next) {
  assert(result.emitter == next.emitter && result.bytes == next.bytes &&
         result.zeroFillInactive == next.zeroFillInactive &&
         result.readFirstOrigin == next.readFirstOrigin &&
         result.readFirstParameter == next.readFirstParameter &&
         "activity domains must preserve the DMA plan identity");
  llvm::append_range(result.transactions, std::move(next.transactions));
}
static FailureOr<std::optional<DmaPlan>>
planZeroFillDmaDomains(const AccessGroup &prepared,
                       const wave::memory_lowering::CopyTransaction &selected,
                       WaveDialect &dialect) {
  const AccessMap &source = prepared[0];
  const AccessMap &destination = prepared[1];
  if (source.packetActivityDomains.empty()) {
    if (!destination.packetActivityDomains.empty())
      return std::optional<DmaPlan>{};
    return planDmaCopy(prepared, selected, true, dialect);
  }
  // Partitioning is legal only when both sides retain the same slot range.
  if (!destination.packetActivityDomains.empty())
    return std::optional<DmaPlan>{};
  FailureOr<std::optional<DmaPlan>> remapped =
      planDmaCopy(prepared, selected, true, dialect);
  if (failed(remapped) || *remapped)
    return remapped;
  std::optional<DmaPlan> result;
  for (const PacketActivityDomain &domain : source.packetActivityDomains) {
    AccessGroup specialized = prepared;
    specialized[0] = specializePacketActivity(source, domain);
    specialized[1] = specializeTransactionRange(destination, domain.firstSlot,
                                                domain.slotCount);
    FailureOr<std::optional<DmaPlan>> planned =
        planDmaCopy(specialized, selected, true, dialect);
    if (failed(planned))
      return failure();
    if (!*planned)
      return std::optional<DmaPlan>{};
    if (!result)
      result = std::move(**planned);
    else
      appendDmaPlan(*result, std::move(**planned));
  }
  return result;
}
static FailureOr<std::optional<DmaPlan>>
planDmaCopyDomains(const AccessGroup &prepared,
                   const wave::memory_lowering::CopyTransaction &selected,
                   bool zeroFillInactive, WaveDialect &dialect) {
  if (prepared.size() != 2)
    return std::optional<DmaPlan>{};
  if (!zeroFillInactive) {
    AccessGroup specialized = prepared;
    if (!specializeWholePacketActivity(specialized))
      return std::optional<DmaPlan>{};
    return planDmaCopy(specialized, selected, false, dialect);
  }
  return planZeroFillDmaDomains(prepared, selected, dialect);
}
struct DmaEmission {
  DmaEmission(IRRewriter &rewriter, const AccessGroup &prepared, DmaPlan &plan,
              Value dependency, sym::Store &store)
      : rewriter(rewriter), source(prepared[0]), destination(prepared[1]),
        plan(plan), dependency(dependency), store(store),
        sourceMaterializer(rewriter, source.access->op, source.getLoc(), store,
                           source.access->packetType.getWidth()),
        destinationMaterializer(rewriter, destination.access->op,
                                destination.getLoc(), store,
                                destination.access->packetType.getWidth()) {}
  IRRewriter &rewriter;
  const AccessMap &source, &destination;
  DmaPlan &plan;
  Value dependency;
  sym::Store &store;
  MemoryTransactionAddressMaterializer sourceMaterializer,
      destinationMaterializer;
  SmallVector<bool> sourceHoisted, destinationHoisted;
};
static FailureOr<Value> materializeDmaWaveBase(DmaEmission &state) {
  FailureOr<Value> origin = state.sourceMaterializer.materializeExpr(
      state.plan.transactions.front().source, state.plan.readFirstOrigin);
  if (failed(origin))
    return failure();
  Value waveBase = *origin;
  if (auto type = dyn_cast<SimdType>(waveBase.getType()))
    waveBase = ReadFirstOp::create(state.rewriter, state.source.getLoc(),
                                   type.getElementType(), waveBase);
  return waveBase;
}
static LogicalResult bindDmaWaveBase(DmaEmission &state,
                                     DmaTransaction &checked, Value waveBase) {
  auto binding =
      llvm::find_if(checked.destination.map.inputs, [&](const auto &input) {
        return input.variable == state.plan.readFirstParameter;
      });
  if (binding == checked.destination.map.inputs.end() || binding->value)
    return failure();
  binding->value = waveBase;
  binding->kind = SymbolicOffsetBindingKind::Uniform;
  return success();
}
static FailureOr<std::pair<bool, bool>>
prepareDmaTransaction(DmaEmission &state, DmaTransaction &checked,
                      Value waveBase, indexing::CheckMemo &memo) {
  if (failed(bindDmaWaveBase(state, checked, waveBase)))
    return failure();
  FailureOr<bool> sourceHoistable = proveMemoryTransactionAddressHoistable(
      state.store, checked.source, checked.source.addresses.front(), memo);
  FailureOr<bool> destinationHoistable = proveMemoryTransactionAddressHoistable(
      state.store, checked.destination, checked.destination.addresses.front(),
      memo);
  if (failed(sourceHoistable) || failed(destinationHoistable) ||
      (state.plan.zeroFillInactive && !*destinationHoistable))
    return failure();
  if (*sourceHoistable &&
      failed(state.sourceMaterializer.prepare(
          checked.source, checked.source.addresses.front())))
    return failure();
  if (*destinationHoistable &&
      failed(state.destinationMaterializer.prepare(
          checked.destination, checked.destination.addresses.front())))
    return failure();
  return std::pair<bool, bool>{*sourceHoistable, *destinationHoistable};
}
static LogicalResult prepareDmaTransactions(DmaEmission &state,
                                            Value waveBase) {
  indexing::CheckMemo memo;
  for (DmaTransaction &checked : state.plan.transactions) {
    FailureOr<std::pair<bool, bool>> prepared =
        prepareDmaTransaction(state, checked, waveBase, memo);
    if (failed(prepared))
      return failure();
    state.sourceHoisted.push_back(prepared->first);
    state.destinationHoisted.push_back(prepared->second);
  }
  return success();
}
static FailureOr<SmallVector<Value>>
issueDmaTransaction(DmaEmission &state, DmaTransaction &checked,
                    FailureOr<Value> &sourcePointer,
                    FailureOr<Value> &destinationPointer) {
  if (!*sourcePointer)
    sourcePointer = state.sourceMaterializer.materialize(
        checked.source, checked.source.addresses.front(),
        checked.source.active);
  if (!*destinationPointer)
    destinationPointer = state.destinationMaterializer.materialize(
        checked.destination, checked.destination.addresses.front(),
        checked.destination.active);
  if (failed(sourcePointer) || failed(destinationPointer))
    return failure();
  PtrType destinationType =
      getMemoryBasePtrType((*destinationPointer).getType());
  Type dwordPointer =
      PtrType::get(state.rewriter.getContext(), state.rewriter.getI32Type(),
                   destinationType.getAddressSpace());
  if ((*destinationPointer).getType() != dwordPointer)
    *destinationPointer =
        PtrCastOp::create(state.rewriter, state.source.getLoc(), dwordPointer,
                          *destinationPointer);
  FailureOr<Value> emitted = state.plan.emitter->emit(
      state.rewriter, state.source.getLoc(),
      state.destination.access->tokenType, *sourcePointer, *destinationPointer,
      state.dependency, state.plan.bytes, state.plan.zeroFillInactive);
  return failed(emitted) ? FailureOr<SmallVector<Value>>(failure())
                         : SmallVector<Value>{*emitted};
}
static FailureOr<Value> emitDmaTransaction(DmaEmission &state,
                                           DmaTransaction &checked,
                                           bool sourceHoist,
                                           bool destinationHoist) {
  FailureOr<Value> sourcePointer =
      sourceHoist ? state.sourceMaterializer.materialize(
                        checked.source, checked.source.addresses.front())
                  : FailureOr<Value>(Value{});
  FailureOr<Value> destinationPointer =
      destinationHoist
          ? state.destinationMaterializer.materialize(
                checked.destination, checked.destination.addresses.front())
          : FailureOr<Value>(Value{});
  if (failed(sourcePointer) || failed(destinationPointer))
    return failure();
  auto issue = [&]() {
    return issueDmaTransaction(state, checked, sourcePointer,
                               destinationPointer);
  };
  auto inactive = [&]() -> FailureOr<SmallVector<Value>> {
    return SmallVector<Value>{state.dependency};
  };
  FailureOr<SmallVector<Value>> emitted = emitConditional(
      state.rewriter, state.source, checked.source, state.sourceMaterializer,
      TypeRange{state.destination.access->tokenType}, issue, inactive);
  return failed(emitted) ? FailureOr<Value>(failure()) : emitted->front();
}
static FailureOr<Value> emitDmaCopy(IRRewriter &rewriter,
                                    const AccessGroup &prepared, DmaPlan &plan,
                                    Value dependency, sym::Store &store) {
  DmaEmission state(rewriter, prepared, plan, dependency, store);
  SmallVector<Value> tokens;
  FailureOr<Value> waveBase = materializeDmaWaveBase(state);
  if (failed(waveBase) || failed(prepareDmaTransactions(state, *waveBase)))
    return failure();
  for (auto [checked, sourceHoist, destinationHoist] : llvm::zip(
           plan.transactions, state.sourceHoisted, state.destinationHoisted)) {
    FailureOr<Value> emitted =
        emitDmaTransaction(state, checked, sourceHoist, destinationHoist);
    if (failed(emitted))
      return failure();
    tokens.push_back(*emitted);
  }
  if (tokens.empty())
    return failure();
  return joinTokens(rewriter, *state.destination.access, tokens);
}
static bool haveCompatibleDmaAccesses(const MemoryAccess &source,
                                      const MemoryAccess &destination) {
  return !source.cache && !destination.cache && source.bases.size() == 1 &&
         destination.bases.size() == 1 &&
         source.packetType == destination.packetType;
}
static bool dmaInputsDominatePredicate(const DmaCopyMatch &match,
                                       const MemoryAccess &source,
                                       const MemoryAccess &destination) {
  if (!match.predicate)
    return true;
  DominanceInfo dominance(match.predicate);
  auto dominates = [&](Value value) {
    return !value || dominance.dominates(value, match.predicate);
  };
  return llvm::all_of(source.bases, dominates) &&
         llvm::all_of(source.bindings, dominates) &&
         dominates(source.dependency) &&
         llvm::all_of(destination.bases, dominates) &&
         llvm::all_of(destination.bindings, dominates);
}
static bool configureDmaPredicate(DmaCopyMatch match, MemoryAccess &source,
                                  const MemoryAccess &destination) {
  if (match.zeroFillInactive && match.predicate.getConditions().size() == 1)
    source.ambientCondition = match.predicate.getCondition();
  return dmaInputsDominatePredicate(match, source, destination);
}
static FailureOr<AccessGroup>
prepareDmaAccessGroup(ScatterOp scatter, IRRewriter &rewriter,
                      MutableArrayRef<MemoryAccess> accesses,
                      WaveDialect &dialect, Preparation &transaction) {
  return runDiagnosed<AccessGroup>(
      scatter, "failed to prepare symbolic DMA access maps", [&] {
        return prepareAccessGroup(rewriter, accesses, dialect, transaction);
      });
}
static FailureOr<std::optional<DmaPlan>>
prepareDmaPlan(ScatterOp scatter, const AccessGroup &prepared,
               const wave::memory_lowering::CopyTransaction &target,
               bool zeroFillInactive, WaveDialect &dialect) {
  return runDiagnosed<std::optional<DmaPlan>>(
      scatter, "failed to plan symbolic DMA copy", [&] {
        return planDmaCopyDomains(prepared, target, zeroFillInactive, dialect);
      });
}
static FailureOr<Value> materializeDmaPlan(ScatterOp scatter,
                                           IRRewriter &rewriter,
                                           const AccessGroup &prepared,
                                           DmaPlan &plan, Value dependency,
                                           WaveDialect &dialect) {
  return runDiagnosed<Value>(
      scatter, "failed to materialize symbolic DMA copy", [&] {
        return emitDmaCopy(rewriter, prepared, plan, dependency,
                           dialect.getSymbolStore());
      });
}
static void finishDmaCopy(IRRewriter &rewriter, ScatterOp scatter,
                          const DmaCopyMatch &match, Value token,
                          Preparation &transaction) {
  rewriter.replaceOp(scatter, token);
  if (match.predicate) {
    transaction.prepareForParentErasure(match.predicate);
    rewriter.eraseOp(match.predicate);
  } else {
    rewriter.eraseOp(match.gather);
  }
  transaction.commit();
}
static Value getDmaDependency(IRRewriter &rewriter, ScatterOp scatter,
                              const MemoryAccess &source) {
  if (source.dependency)
    return source.dependency;
  return TokenOp::create(rewriter, scatter.getLoc(), source.tokenType);
}
static FailureOr<std::optional<DmaPlan>>
selectDmaPlan(ScatterOp scatter, const AccessGroup &prepared,
              ArrayRef<wave::memory_lowering::CopyTransaction> targets,
              bool zeroFillInactive, WaveDialect &dialect) {
  for (const wave::memory_lowering::CopyTransaction &target : targets) {
    FailureOr<std::optional<DmaPlan>> candidate =
        prepareDmaPlan(scatter, prepared, target, zeroFillInactive, dialect);
    if (failed(candidate))
      return failure();
    if (*candidate)
      return std::optional<DmaPlan>{std::move(**candidate)};
  }
  return std::optional<DmaPlan>{};
}
static FailureOr<bool> tryLowerDmaCopy(ScatterOp scatter, WaveDialect &dialect,
                                       IRRewriter &rewriter) {
  std::optional<DmaCopyMatch> match = matchDmaCopy(scatter);
  if (!match)
    return false;
  std::array<MemoryAccess, 2> accesses{getAccess(match->gather),
                                       getAccess(scatter)};
  MemoryAccess &source = accesses[0];
  MemoryAccess &destination = accesses[1];
  if (!haveCompatibleDmaAccesses(source, destination) ||
      !configureDmaPredicate(*match, source, destination))
    return false;
  wave::memory_lowering::CopyTransactionRequest request{
      source.bases.front(), destination.bases.front(), scatter,
      source.packetType, match->zeroFillInactive};
  SmallVector<wave::memory_lowering::CopyTransaction> targets =
      wave::memory_lowering::getCopyTransactions(request);
  if (targets.empty())
    return false;
  Operation *anchor = match->predicate ? match->predicate.getOperation()
                                       : scatter.getOperation();
  rewriter.setInsertionPoint(anchor);
  Preparation transaction(rewriter);
  FailureOr<AccessGroup> prepared = prepareDmaAccessGroup(
      scatter, rewriter, MutableArrayRef<MemoryAccess>(accesses), dialect,
      transaction);
  if (failed(prepared))
    return failure();
  FailureOr<std::optional<DmaPlan>> plan = selectDmaPlan(
      scatter, *prepared, targets, match->zeroFillInactive, dialect);
  if (failed(plan))
    return failure();
  if (!*plan)
    return false;
  rewriter.setInsertionPoint(anchor);
  Value dependency = getDmaDependency(rewriter, scatter, source);
  FailureOr<Value> token = materializeDmaPlan(scatter, rewriter, *prepared,
                                              **plan, dependency, dialect);
  if (failed(token))
    return failure();
  finishDmaCopy(rewriter, scatter, *match, *token, transaction);
  return true;
}
static LogicalResult lowerDmaCopies(Operation *root, WaveDialect &dialect,
                                    IRRewriter &rewriter) {
  SmallVector<ScatterOp> scatters;
  root->walk([&](ScatterOp scatter) { scatters.push_back(scatter); });
  for (ScatterOp scatter : scatters) {
    FailureOr<bool> lowered = tryLowerDmaCopy(scatter, dialect, rewriter);
    if (failed(lowered))
      return failure();
  }
  return success();
}
struct WaveLowerSymbolicMemoryPass
    : public wave::impl::WaveLowerSymbolicMemoryBase<
          WaveLowerSymbolicMemoryPass> {
  using Base::Base;
  void runOnOperation() override {
    SymbolicTransformTiming timing("lower_symbolic_memory");
    Operation *root = getOperation();
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect) {
      root->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }
    IRRewriter rewriter(&getContext());
    {
      TimingScope dmaTiming = timing.nest("symbolic_memory_dma");
      if (failed(lowerDmaCopies(root, *dialect, rewriter)))
        return signalPassFailure();
    }
    SmallVector<Operation *> accesses;
    {
      TimingScope collectTiming = timing.nest("symbolic_memory_collect");
      root->walk([&](Operation *op) {
        if (isa<GatherOp, ScatterOp>(op))
          accesses.push_back(op);
      });
    }
    TimingScope accessTiming = timing.nest("symbolic_memory_accesses");
    for (Operation *op : accesses) {
      rewriter.setInsertionPoint(op);
      MemoryAccess access = isa<GatherOp>(op) ? getAccess(cast<GatherOp>(op))
                                              : getAccess(cast<ScatterOp>(op));
      if (failed(lowerAccess(rewriter, access, *dialect)))
        return signalPassFailure();
    }
  }
};
} // namespace
