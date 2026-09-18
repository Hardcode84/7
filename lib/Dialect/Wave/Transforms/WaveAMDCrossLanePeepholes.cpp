//===- WaveAMDCrossLanePeepholes.cpp - Cross-lane peepholes ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "SIDefines.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/TypeSwitch.h"

#include <map>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDCROSSLANEPEEPHOLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

enum class PermlaneHalf : uint8_t { Lower, Upper };

class FullExecAnalysis : public RewriterBase::Listener {
public:
  explicit FullExecAnalysis(func::FuncOp func) {
    DenseMap<Operation *, bool> preserves;
    // Two linear walks: summarize regions, then mark full-EXEC segments.
    func.walk<WalkOrder::PostOrder>([&](Operation *op) {
      bool safe = false;
      if (isa<UniformLoopOp, UniformIfOp, ExecIfOp>(op))
        safe = llvm::all_of(op->getRegions(), [&](Region &region) {
          return llvm::all_of(region.getOps(), [&](Operation &nested) {
            return preserves.lookup(&nested);
          });
        });
      else
        safe = !op->getNumRegions() &&
               !op->hasTrait<OpTrait::waveamdmachine::WritesExecOp>() &&
               !isa<LabelOp, SCBranchExeczOp, SCBranchScc0Op, SCBranchScc1Op,
                    SSetpcB64Op, SEndpgmOp>(op) &&
               op->getDialect() ==
                   op->getContext()->getLoadedDialect<WaveAMDMachineDialect>();
      preserves[op] = safe;
    });
    if (func->hasAttr("wave.kernel") && !func.getBody().empty())
      markBlock(func.getBody().front(), preserves);
  }

  bool contains(Operation *op) const { return segments.contains(op); }

  bool sameSegment(Operation *lhs, Operation *rhs) const {
    unsigned segment = segments.lookup(lhs);
    return segment && segment == segments.lookup(rhs);
  }

  unsigned getSegment(Operation *op) const { return segments.lookup(op); }
  unsigned getPosition(Operation *op) const { return positions.lookup(op); }

  bool hasBarrierBetween(Operation *lhs, Operation *rhs) const {
    auto next = barriers.upper_bound(getPosition(lhs));
    return next != barriers.end() && next->first <= getPosition(rhs);
  }

  void notifyOperationInserted(Operation *op,
                               OpBuilder::InsertPoint previous) override {
    assert(!previous.isSet() && "cross-lane rewrites must not move operations");
    // Replacements insert before their root; new ops stop partner scans.
    unsigned position = getPosition(op->getNextNode());
    if (!position)
      return;
    positions[op] = position;
    ++barriers[position];
  }

  void notifyOperationErased(Operation *op) override {
    unsigned position = getPosition(op);
    if (position && !contains(op)) {
      auto barrier = barriers.find(position);
      if (!--barrier->second)
        barriers.erase(barrier);
    }
    positions.erase(op);
    segments.erase(op);
  }

private:
  void markBlock(Block &block, const DenseMap<Operation *, bool> &preserves) {
    unsigned segment = ++nextSegment;
    for (Operation &op : block) {
      if (!preserves.lookup(&op))
        break;
      if (!op.getNumRegions()) {
        segments[&op] = segment;
        positions[&op] = ++nextPosition;
        continue;
      }
      // EXEC regions restore entry mask; their bodies still run masked.
      if (!isa<ExecIfOp>(op))
        for (Region &region : op.getRegions())
          for (Block &nested : region)
            markBlock(nested, preserves);
      segment = ++nextSegment;
    }
  }

  DenseMap<Operation *, unsigned> segments;
  DenseMap<Operation *, unsigned> positions;
  std::map<unsigned, unsigned> barriers;
  unsigned nextSegment = 0;
  unsigned nextPosition = 0;
};

class MachineU32Evaluator {
public:
  MachineU32Evaluator(uint32_t lane, uint32_t workitemX)
      : lane(lane), workitemX(workitemX) {}

  std::optional<uint32_t> evaluate(Value value) {
    auto cached = values.find(value);
    if (cached != values.end())
      return cached->second;

    Operation *op = value.getDefiningOp();
    std::optional<uint32_t> result = op ? evaluateOperation(op) : std::nullopt;
    values[value] = result;
    return result;
  }

private:
  std::optional<uint32_t> evaluateOperation(Operation *op) {
    return llvm::TypeSwitch<Operation *, std::optional<uint32_t>>(op)
        .Case<ImmOp>(
            [](ImmOp imm) { return static_cast<uint32_t>(imm.getValue()); })
        .Case<VWorkitemIdXOp>([&](VWorkitemIdXOp) { return workitemX; })
        .Case<VMbcntLoOp>(
            [&](VMbcntLoOp) { return std::min(lane, uint32_t{32}); })
        .Case<VMbcntHiOp>([&](VMbcntHiOp hi) {
          std::optional<uint32_t> low = evaluate(hi.getSource());
          if (!low)
            return std::optional<uint32_t>();
          return std::optional<uint32_t>(*low + (lane >= 32 ? lane - 32 : 0));
        })
        .Case<SMovB32ValueOp>(
            [&](SMovB32ValueOp move) { return evaluate(move.getSource()); })
        .Case<VAddU32Op>([&](VAddU32Op add) {
          return evaluateBinary(
              add.getLhs(), add.getRhs(),
              [](uint32_t lhs, uint32_t rhs) { return lhs + rhs; });
        })
        .Case<VAndB32Op>([&](VAndB32Op bitAnd) {
          return evaluateBinary(
              bitAnd.getLhs(), bitAnd.getRhs(),
              [](uint32_t lhs, uint32_t rhs) { return lhs & rhs; });
        })
        .Case<VOrB32Op>([&](VOrB32Op bitOr) {
          return evaluateBinary(
              bitOr.getLhs(), bitOr.getRhs(),
              [](uint32_t lhs, uint32_t rhs) { return lhs | rhs; });
        })
        .Case<VXorB32Op>([&](VXorB32Op bitXor) {
          return evaluateBinary(
              bitXor.getLhs(), bitXor.getRhs(),
              [](uint32_t lhs, uint32_t rhs) { return lhs ^ rhs; });
        })
        .Case<VLshlrevB32Op>([&](VLshlrevB32Op shift) {
          return evaluateShift(shift.getLhs(), shift.getRhs(), true);
        })
        .Case<VLshrrevB32Op>([&](VLshrrevB32Op shift) {
          return evaluateShift(shift.getLhs(), shift.getRhs(), false);
        })
        .Default(
            [&](Operation *nested) { return evaluateFusedOperation(nested); });
  }

  std::optional<uint32_t> evaluateFusedOperation(Operation *op) {
    return llvm::TypeSwitch<Operation *, std::optional<uint32_t>>(op)
        .Case<VAdd3U32Op>([&](VAdd3U32Op add) {
          return evaluateTernary(add.getA(), add.getB(), add.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t c) {
                                   return std::optional<uint32_t>(a + b + c);
                                 });
        })
        .Case<VLshlAddU32Op>([&](VLshlAddU32Op shift) {
          return evaluateTernary(
              shift.getA(), shift.getB(), shift.getC(),
              [](uint32_t value, uint32_t amount, uint32_t addend) {
                if (amount >= 32)
                  return std::optional<uint32_t>();
                return std::optional<uint32_t>((value << amount) + addend);
              });
        })
        .Case<VAddLshlU32Op>([&](VAddLshlU32Op shift) {
          return evaluateTernary(shift.getA(), shift.getB(), shift.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t amount) {
                                   if (amount >= 32)
                                     return std::optional<uint32_t>();
                                   return std::optional<uint32_t>((a + b)
                                                                  << amount);
                                 });
        })
        .Case<VAndOrB32Op>([&](VAndOrB32Op bitop) {
          return evaluateTernary(bitop.getA(), bitop.getB(), bitop.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t c) {
                                   return std::optional<uint32_t>((a & b) | c);
                                 });
        })
        .Case<VOr3B32Op>([&](VOr3B32Op bitop) {
          return evaluateTernary(bitop.getA(), bitop.getB(), bitop.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t c) {
                                   return std::optional<uint32_t>(a | b | c);
                                 });
        })
        .Case<VXadU32Op>([&](VXadU32Op xad) {
          return evaluateTernary(xad.getA(), xad.getB(), xad.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t c) {
                                   return std::optional<uint32_t>((a ^ b) + c);
                                 });
        })
        .Case<VBitOp3B32Op>(
            [&](VBitOp3B32Op bitop) { return evaluateBitop3(bitop); })
        .Default([](Operation *) { return std::optional<uint32_t>(); });
  }

  template <typename Fn>
  std::optional<uint32_t> evaluateBinary(Value lhsValue, Value rhsValue,
                                         Fn combine) {
    std::optional<uint32_t> lhs = evaluate(lhsValue);
    std::optional<uint32_t> rhs = evaluate(rhsValue);
    if (!lhs || !rhs)
      return std::nullopt;
    return combine(*lhs, *rhs);
  }

  template <typename Fn>
  std::optional<uint32_t> evaluateTernary(Value aValue, Value bValue,
                                          Value cValue, Fn combine) {
    std::optional<uint32_t> a = evaluate(aValue);
    std::optional<uint32_t> b = evaluate(bValue);
    std::optional<uint32_t> c = evaluate(cValue);
    if (!a || !b || !c)
      return std::nullopt;
    return combine(*a, *b, *c);
  }

  std::optional<uint32_t> evaluateShift(Value value, Value amount, bool left) {
    return evaluateBinary(value, amount,
                          [left](uint32_t input, uint32_t shift) {
                            if (shift >= 32)
                              return std::optional<uint32_t>();
                            return std::optional<uint32_t>(
                                left ? input << shift : input >> shift);
                          });
  }

  std::optional<uint32_t> evaluateBitop3(VBitOp3B32Op op) {
    return evaluateTernary(op.getA(), op.getB(), op.getC(),
                           [&](uint32_t a, uint32_t b, uint32_t c) {
                             uint32_t result = 0;
                             for (unsigned bit : llvm::seq<unsigned>(32)) {
                               unsigned input = ((a >> bit) & 1) << 2 |
                                                ((b >> bit) & 1) << 1 |
                                                ((c >> bit) & 1);
                               result |= ((op.getBitop3() >> input) & 1) << bit;
                             }
                             return std::optional<uint32_t>(result);
                           });
  }

  DenseMap<Value, std::optional<uint32_t>> values;
  uint32_t lane;
  uint32_t workitemX;
};

struct BpermutePayload {
  SmallVector<DsBpermuteB32Op> permutes;
  SmallVector<Value> words;
  TupleFromElementsOp tuple;
  Value address;
};

struct PermlaneCandidate {
  BpermutePayload falsePayload;
  BpermutePayload truePayload;
  SmallVector<Value> firstWords;
  SmallVector<Value> secondWords;
  VCndmaskB32TupleOp select;
  PermlaneHalf half;
};

static std::optional<int64_t> getImmediate(Value value) {
  ImmOp imm = value.getDefiningOp<ImmOp>();
  if (!imm)
    return std::nullopt;
  return imm.getValue();
}

static bool sameValues(ArrayRef<Value> lhs, ArrayRef<Value> rhs) {
  if (lhs.size() != rhs.size())
    return false;
  for (auto [left, right] : llvm::zip_equal(lhs, rhs))
    if (left != right)
      return false;
  return true;
}

static std::optional<unsigned> getXLinearWorkgroupSize(func::FuncOp func) {
  DenseI32ArrayAttr shape;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    shape = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (shape)
      break;
  }
  if (!shape)
    return std::nullopt;
  ArrayRef<int32_t> dims = shape.asArrayRef();
  if (dims.size() != 3 || dims[0] <= 0 || dims[0] % 64 != 0 || dims[1] != 1 ||
      dims[2] != 1)
    return std::nullopt;
  return static_cast<unsigned>(dims[0]);
}

static std::optional<bool> evaluateCondition(Value condition,
                                             MachineU32Evaluator &evaluator) {
  Value vcc = getVCCCopySource(condition);
  if (!vcc)
    return std::nullopt;
  if (VCmpEqU32VccOp compare = vcc.getDefiningOp<VCmpEqU32VccOp>()) {
    std::optional<uint32_t> lhs = evaluator.evaluate(compare.getLhs());
    std::optional<uint32_t> rhs = evaluator.evaluate(compare.getRhs());
    if (lhs && rhs)
      return *lhs == *rhs;
  }
  return std::nullopt;
}

static LogicalResult appendBpermuteWord(BpermutePayload &payload, Value word) {
  DsBpermuteB32Op permute = word.getDefiningOp<DsBpermuteB32Op>();
  if (!permute || permute.getOffset() != 0)
    return failure();
  if (payload.address && permute.getAddr() != payload.address)
    return failure();
  payload.address = permute.getAddr();
  payload.permutes.push_back(permute);
  payload.words.push_back(permute.getData());
  return success();
}

static bool isVGPRWord(Value value) {
  RegType type = dyn_cast<RegType>(value.getType());
  return type && type.getRegClass() == RegClass::VGPR && type.getWidth() == 1;
}

static std::optional<BpermutePayload> matchBpermuteTuplePayload(Value value,
                                                                int64_t width) {
  TupleFromElementsOp tuple = value.getDefiningOp<TupleFromElementsOp>();
  if (!tuple || tuple.getElements().size() != static_cast<size_t>(width))
    return std::nullopt;

  BpermutePayload payload;
  payload.tuple = tuple;
  for (Value element : tuple.getElements())
    if (!isVGPRWord(element) || failed(appendBpermuteWord(payload, element)))
      return std::nullopt;
  return payload;
}

static std::optional<BpermutePayload> matchBpermutePayload(Value value) {
  RegType type = dyn_cast<RegType>(value.getType());
  if (!type || type.getRegClass() != RegClass::VGPR)
    return std::nullopt;

  BpermutePayload payload;
  if (type.getWidth() == 1) {
    if (failed(appendBpermuteWord(payload, value)))
      return std::nullopt;
    return payload;
  }

  return matchBpermuteTuplePayload(value, type.getWidth());
}

static std::optional<unsigned> evaluateSource(Value address,
                                              MachineU32Evaluator &evaluator) {
  std::optional<uint32_t> byteAddress = evaluator.evaluate(address);
  if (!byteAddress || *byteAddress % 4 != 0 || *byteAddress / 4 >= 64)
    return std::nullopt;
  return *byteAddress / 4;
}

static ArrayRef<Value> getSelectedWords(const PermlaneCandidate &candidate,
                                        bool takeTrue) {
  return takeTrue ? ArrayRef<Value>(candidate.truePayload.words)
                  : ArrayRef<Value>(candidate.falsePayload.words);
}

static std::optional<PermlaneCandidate>
makePermlaneCandidate(VCndmaskB32TupleOp select) {
  std::optional<BpermutePayload> falsePayload =
      matchBpermutePayload(select.getFalseValue());
  std::optional<BpermutePayload> truePayload =
      matchBpermutePayload(select.getTrueValue());
  if (!falsePayload || !truePayload ||
      falsePayload->words.size() != truePayload->words.size() ||
      sameValues(falsePayload->words, truePayload->words))
    return std::nullopt;

  return PermlaneCandidate{
      std::move(*falsePayload), std::move(*truePayload), {}, {}, select,
      PermlaneHalf::Lower};
}

struct SelectSemantics {
  PermlaneHalf half;
  bool firstTrue;
};

using SelectQuery = std::tuple<Value, Value, Value>;
using SelectCache = DenseMap<SelectQuery, std::optional<SelectSemantics>>;
using BroadcastCache = DenseMap<Value, std::optional<PermlaneHalf>>;

static SelectQuery getSelectQuery(const PermlaneCandidate &candidate) {
  VCndmaskB32TupleOp select = candidate.select;
  return {select.getCondition(), candidate.falsePayload.address,
          candidate.truePayload.address};
}

static std::optional<PermlaneHalf> getBroadcastHalf(unsigned source) {
  if (source == 0)
    return PermlaneHalf::Lower;
  if (source == 32)
    return PermlaneHalf::Upper;
  return std::nullopt;
}

static void checkBroadcastLane(Value address, std::optional<PermlaneHalf> &half,
                               MachineU32Evaluator &evaluator, unsigned item) {
  if (item && !half)
    return;
  std::optional<unsigned> source = evaluateSource(address, evaluator);
  if (!source) {
    half.reset();
    return;
  }
  if (!item) {
    half = getBroadcastHalf(*source);
    return;
  }
  unsigned base = *half == PermlaneHalf::Upper ? 32 : 0;
  if (*source != base + item % 32)
    half.reset();
}

static std::optional<std::pair<bool, unsigned>>
evaluateSelectedSource(const SelectQuery &query,
                       MachineU32Evaluator &evaluator) {
  auto [condition, falseAddress, trueAddress] = query;
  std::optional<bool> takeTrue = evaluateCondition(condition, evaluator);
  if (!takeTrue)
    return std::nullopt;
  std::optional<unsigned> source =
      evaluateSource(*takeTrue ? trueAddress : falseAddress, evaluator);
  if (!source)
    return std::nullopt;
  return std::pair<bool, unsigned>{*takeTrue, *source};
}

static void checkSelectLane(const SelectQuery &query,
                            std::optional<SelectSemantics> &semantics,
                            MachineU32Evaluator &evaluator, unsigned item) {
  if (item && !semantics)
    return;
  std::optional<std::pair<bool, unsigned>> selected =
      evaluateSelectedSource(query, evaluator);
  if (!selected) {
    semantics.reset();
    return;
  }
  if (!item) {
    std::optional<PermlaneHalf> half = getBroadcastHalf(selected->second);
    if (half)
      semantics = SelectSemantics{*half, selected->first};
    return;
  }
  unsigned base = semantics->half == PermlaneHalf::Upper ? 32 : 0;
  bool expectedTrue = (item % 64 < 32) == semantics->firstTrue;
  if (selected->second != base + item % 32 || selected->first != expectedTrue)
    semantics.reset();
}

static void classifyQueries(BroadcastCache &broadcasts, SelectCache &selects,
                            unsigned workgroupSize) {
  if (broadcasts.empty() && selects.empty())
    return;
  // One DAG cache per lane, shared by all queries and then released.
  for (unsigned item : llvm::seq(workgroupSize)) {
    MachineU32Evaluator evaluator(item % 64, item);
    for (auto &[address, half] : broadcasts)
      checkBroadcastLane(address, half, evaluator, item);
    for (auto &[query, semantics] : selects)
      checkSelectLane(query, semantics, evaluator, item);
  }
}

static std::optional<unsigned>
evaluateBpermuteSource(DsBpermuteB32Op op, unsigned lane, unsigned workitemX) {
  if (op.getOffset() != 0)
    return std::nullopt;
  MachineU32Evaluator evaluator(lane, workitemX);
  return evaluateSource(op.getAddr(), evaluator);
}

static bool isHalfExchangeAtLane(DsBpermuteB32Op lhs, DsBpermuteB32Op rhs,
                                 unsigned lane, unsigned workitemX) {
  std::optional<unsigned> lhsSource =
      evaluateBpermuteSource(lhs, lane, workitemX);
  std::optional<unsigned> rhsSource =
      evaluateBpermuteSource(rhs, lane, workitemX);
  if (!lhsSource || !rhsSource)
    return false;
  unsigned otherHalf = lane ^ 32;
  return (*lhsSource == lane && *rhsSource == otherHalf) ||
         (*rhsSource == lane && *lhsSource == otherHalf);
}

static bool isHalfExchangePair(DsBpermuteB32Op lhs, DsBpermuteB32Op rhs,
                               unsigned workgroupSize) {
  if (!lhs || !rhs || lhs.getData() != rhs.getData() || workgroupSize < 64 ||
      workgroupSize % 64 != 0)
    return false;
  for (unsigned wave : llvm::seq<unsigned>(workgroupSize / 64)) {
    unsigned waveBase = wave * 64;
    for (unsigned lane : llvm::seq<unsigned>(0, 64))
      if (!isHalfExchangeAtLane(lhs, rhs, lane, waveBase + lane))
        return false;
  }
  return true;
}

class CandidateIndex : public RewriterBase::Listener {
  using OrderedCandidates = std::map<unsigned, Operation *>;
  using Bucket = std::array<OrderedCandidates, 2>;
  struct Entry {
    Bucket *bucket;
    unsigned position;
    PermlaneHalf half;
    bool firstTrue;
  };

public:
  explicit CandidateIndex(FullExecAnalysis &exec) : exec(exec) {}

  void initialize(func::FuncOp func, unsigned workgroupSize) {
    BroadcastCache broadcasts;
    SelectCache selects;
    SmallVector<DsBpermuteB32Op> permutes;
    SmallVector<PermlaneCandidate, 0> candidates;
    func.walk([&](Operation *op) {
      if (!exec.contains(op))
        return;
      if (auto permute = dyn_cast<DsBpermuteB32Op>(op)) {
        if (permute.getOffset() == 0) {
          permutes.push_back(permute);
          broadcasts.try_emplace(permute.getAddr());
        }
        return;
      }
      if (auto select = dyn_cast<VCndmaskB32TupleOp>(op))
        collectSelect(select, selects, candidates);
    });
    classifyQueries(broadcasts, selects, workgroupSize);
    for (DsBpermuteB32Op permute : permutes)
      if (std::optional<PermlaneHalf> half =
              broadcasts.lookup(permute.getAddr()))
        add(permute, {permute.getData()}, *half);
    for (const PermlaneCandidate &candidate : candidates)
      if (std::optional<SelectSemantics> semantics =
              selects.lookup(getSelectQuery(candidate)))
        addSelect(candidate, *semantics);
  }

  std::optional<PermlaneCandidate> matchSelect(VCndmaskB32TupleOp op) {
    auto found = entries.find(op);
    if (found == entries.end())
      return std::nullopt;
    std::optional<PermlaneCandidate> candidate = makePermlaneCandidate(op);
    if (!candidate) {
      erase(op);
      return std::nullopt;
    }
    candidate->half = found->second.half;
    ArrayRef<Value> first =
        getSelectedWords(*candidate, found->second.firstTrue);
    ArrayRef<Value> second =
        getSelectedWords(*candidate, !found->second.firstTrue);
    candidate->firstWords.assign(first.begin(), first.end());
    candidate->secondWords.assign(second.begin(), second.end());
    return candidate;
  }

  std::optional<PermlaneHalf> getHalf(Operation *op) const {
    auto found = entries.find(op);
    if (found == entries.end())
      return std::nullopt;
    return found->second.half;
  }

  Operation *findPartner(Operation *op) const {
    auto found = entries.find(op);
    if (found == entries.end())
      return nullptr;
    const Entry &entry = found->second;
    const OrderedCandidates &partners =
        (*entry.bucket)[entry.half == PermlaneHalf::Lower ? 1 : 0];
    auto partner = partners.upper_bound(entry.position);
    if (partner == partners.end() ||
        exec.hasBarrierBetween(op, partner->second))
      return nullptr;
    return partner->second;
  }

  void notifyOperationInserted(Operation *op,
                               OpBuilder::InsertPoint previous) override {
    exec.notifyOperationInserted(op, previous);
  }

  void notifyOperationErased(Operation *op) override {
    erase(op);
    exec.notifyOperationErased(op);
  }

private:
  void collectSelect(VCndmaskB32TupleOp select, SelectCache &cache,
                     SmallVectorImpl<PermlaneCandidate> &candidates) {
    std::optional<PermlaneCandidate> candidate = makePermlaneCandidate(select);
    if (!candidate)
      return;
    for (const BpermutePayload *payload :
         {&candidate->falsePayload, &candidate->truePayload})
      for (DsBpermuteB32Op permute : payload->permutes)
        if (!exec.sameSegment(permute, select))
          return;
    cache.try_emplace(getSelectQuery(*candidate));
    candidates.push_back(std::move(*candidate));
  }

  void addSelect(const PermlaneCandidate &candidate,
                 SelectSemantics semantics) {
    SmallVector<Value> words(getSelectedWords(candidate, semantics.firstTrue));
    llvm::append_range(words,
                       getSelectedWords(candidate, !semantics.firstTrue));
    add(candidate.select, words, semantics.half, semantics.firstTrue);
  }

  void add(Operation *op, ArrayRef<Value> words, PermlaneHalf half,
           bool firstTrue = false) {
    auto key = std::make_pair(exec.getSegment(op), SmallVector<Value>(words));
    std::unique_ptr<Bucket> &bucket = buckets[key];
    if (!bucket)
      bucket = std::make_unique<Bucket>();
    unsigned position = exec.getPosition(op);
    (*bucket)[static_cast<unsigned>(half)].emplace(position, op);
    entries.try_emplace(op, Entry{bucket.get(), position, half, firstTrue});
  }

  void erase(Operation *op) {
    auto found = entries.find(op);
    if (found == entries.end())
      return;
    const Entry &entry = found->second;
    (*entry.bucket)[static_cast<unsigned>(entry.half)].erase(entry.position);
    entries.erase(found);
  }

  // Distinct replacements preserve keys; recheck select payloads on use.
  DenseMap<std::pair<unsigned, SmallVector<Value>>, std::unique_ptr<Bucket>>
      buckets;
  DenseMap<Operation *, Entry> entries;
  FullExecAnalysis &exec;
};

static std::optional<PermlaneCandidate>
findUpperCandidate(const PermlaneCandidate &lower, CandidateIndex &index) {
  while (Operation *partner = index.findPartner(lower.select)) {
    std::optional<PermlaneCandidate> candidate =
        index.matchSelect(cast<VCndmaskB32TupleOp>(partner));
    if (candidate)
      return candidate;
  }
  return std::nullopt;
}

static bool isLaneId(Value value, unsigned wavefrontSize) {
  if (wavefrontSize == 32)
    return isa_and_nonnull<VMbcntLoOp>(value.getDefiningOp());

  VMbcntHiOp hi = value.getDefiningOp<VMbcntHiOp>();
  return hi && isa_and_nonnull<VMbcntLoOp>(hi.getSource().getDefiningOp());
}

static bool isLowFiveBitMask(int64_t value) {
  return value >= 0 && value <= llvm::AMDGPU::Swizzle::BITMASK_MASK;
}

static unsigned encodeBitmaskPerm(unsigned andMask, unsigned orMask,
                                  unsigned xorMask) {
  using namespace llvm::AMDGPU::Swizzle;
  return (andMask << BITMASK_AND_SHIFT) | (orMask << BITMASK_OR_SHIFT) |
         (xorMask << BITMASK_XOR_SHIFT);
}

static std::optional<unsigned> matchXorLaneSwizzle(Value laneExpr,
                                                   unsigned wavefrontSize) {
  if (isLaneId(laneExpr, wavefrontSize))
    return encodeBitmaskPerm(llvm::AMDGPU::Swizzle::BITMASK_MASK, 0, 0);

  VXorB32Op xorOp = laneExpr.getDefiningOp<VXorB32Op>();
  if (!xorOp)
    return std::nullopt;

  auto matchLaneAndMask = [&](Value lhs, Value rhs) -> std::optional<unsigned> {
    if (!isLaneId(lhs, wavefrontSize))
      return std::nullopt;
    std::optional<int64_t> mask = getImmediate(rhs);
    if (!mask || !isLowFiveBitMask(*mask))
      return std::nullopt;
    return encodeBitmaskPerm(llvm::AMDGPU::Swizzle::BITMASK_MASK, 0, *mask);
  };

  if (std::optional<unsigned> offset =
          matchLaneAndMask(xorOp.getLhs(), xorOp.getRhs()))
    return offset;
  return matchLaneAndMask(xorOp.getRhs(), xorOp.getLhs());
}

static std::optional<unsigned>
matchDsPermuteSwizzleOffset(DsPermuteB32Op op, unsigned wavefrontSize) {
  if (op.getOffset() != 0)
    return std::nullopt;

  VLshlrevB32Op byteAddr = op.getAddr().getDefiningOp<VLshlrevB32Op>();
  if (!byteAddr)
    return std::nullopt;
  std::optional<int64_t> shift = getImmediate(byteAddr.getRhs());
  if (!shift || *shift != 2)
    return std::nullopt;

  return matchXorLaneSwizzle(byteAddr.getLhs(), wavefrontSize);
}

static void eraseIfDead(PatternRewriter &rewriter, Operation *op) {
  if (!op || !op->use_empty())
    return;
  rewriter.eraseOp(op);
}

static void eraseDeadAddressChain(PatternRewriter &rewriter, Value addr) {
  VLshlrevB32Op byteAddr = addr.getDefiningOp<VLshlrevB32Op>();
  if (!byteAddr || !byteAddr->use_empty())
    return;

  Value laneExpr = byteAddr.getLhs();
  rewriter.eraseOp(byteAddr);
  if (VXorB32Op xorOp = laneExpr.getDefiningOp<VXorB32Op>()) {
    Operation *lhs = xorOp.getLhs().getDefiningOp();
    Operation *rhs = xorOp.getRhs().getDefiningOp();
    eraseIfDead(rewriter, xorOp);
    eraseIfDead(rewriter, lhs);
    eraseIfDead(rewriter, rhs);
  }
}

static void eraseMatchedPayloads(PatternRewriter &rewriter,
                                 ArrayRef<BpermutePayload> payloads) {
  llvm::SmallPtrSet<Operation *, 16> tuples;
  llvm::SmallPtrSet<Operation *, 32> permutes;
  for (const BpermutePayload &payload : payloads) {
    if (payload.tuple)
      tuples.insert(payload.tuple);
    for (DsBpermuteB32Op permute : payload.permutes)
      permutes.insert(permute);
  }
  for (Operation *tuple : tuples)
    eraseIfDead(rewriter, tuple);
  for (Operation *permute : permutes)
    eraseIfDead(rewriter, permute);
}

struct BpermuteSelectPairToPermlanePattern
    : public OpRewritePattern<VCndmaskB32TupleOp> {
  BpermuteSelectPairToPermlanePattern(MLIRContext *context,
                                      CandidateIndex &index)
      : OpRewritePattern<VCndmaskB32TupleOp>(context), index(index) {}

  LogicalResult matchAndRewrite(VCndmaskB32TupleOp op,
                                PatternRewriter &rewriter) const override {
    std::optional<PermlaneCandidate> lower = index.matchSelect(op);
    if (!lower || lower->half != PermlaneHalf::Lower)
      return failure();
    std::optional<PermlaneCandidate> upper = findUpperCandidate(*lower, index);
    if (!upper)
      return failure();
    assert(sameValues(lower->firstWords, upper->firstWords) &&
           sameValues(lower->secondWords, upper->secondWords) &&
           "indexed sources must retain equality");

    // Shared source words dominate the lower select through its payloads.
    SmallVector<Value> sourceWords(lower->firstWords);
    llvm::append_range(sourceWords, lower->secondWords);
    MLIRContext *context = op.getContext();
    Type sourceType = RegType::get(context, RegClass::VGPR, sourceWords.size(),
                                   /*index=*/-1);
    Value source = TupleFromElementsOp::create(rewriter, op.getLoc(),
                                               sourceType, sourceWords)
                       .getTuple();
    VPermlane32SwapB32TupleOp swap = VPermlane32SwapB32TupleOp::create(
        rewriter, op.getLoc(), sourceType, source);
    Type halfType = RegType::get(context, RegClass::VGPR,
                                 lower->firstWords.size(), /*index=*/-1);
    std::array<Type, 2> resultTypes{halfType, halfType};
    TupleToElementsOp split = TupleToElementsOp::create(
        rewriter, op.getLoc(), resultTypes, swap.getResult());

    std::array<BpermutePayload, 4> payloads{
        std::move(lower->falsePayload), std::move(lower->truePayload),
        std::move(upper->falsePayload), std::move(upper->truePayload)};
    rewriter.replaceOp(lower->select, split.getElements()[0]);
    rewriter.replaceOp(upper->select, split.getElements()[1]);
    eraseMatchedPayloads(rewriter, payloads);
    return success();
  }

  CandidateIndex &index;
};

struct DsPermuteToSwizzlePattern : public OpRewritePattern<DsPermuteB32Op> {
  DsPermuteToSwizzlePattern(MLIRContext *context, unsigned wavefrontSize)
      : OpRewritePattern<DsPermuteB32Op>(context),
        wavefrontSize(wavefrontSize) {}

  LogicalResult matchAndRewrite(DsPermuteB32Op op,
                                PatternRewriter &rewriter) const override {
    std::optional<unsigned> offset =
        matchDsPermuteSwizzleOffset(op, wavefrontSize);
    if (!offset)
      return failure();

    Value addr = op.getAddr();
    DsSwizzleB32Op swizzle = DsSwizzleB32Op::create(
        rewriter, op.getLoc(), op.getResult().getType(), op.getData(),
        rewriter.getI64IntegerAttr(*offset));
    rewriter.replaceOp(op, swizzle.getResult());
    eraseDeadAddressChain(rewriter, addr);
    return success();
  }

  unsigned wavefrontSize;
};

struct BpermuteHalfBroadcastPairToPermlanePattern
    : public OpRewritePattern<DsBpermuteB32Op> {
  BpermuteHalfBroadcastPairToPermlanePattern(MLIRContext *context,
                                             CandidateIndex &index)
      : OpRewritePattern<DsBpermuteB32Op>(context), index(index) {}

  LogicalResult matchAndRewrite(DsBpermuteB32Op op,
                                PatternRewriter &rewriter) const override {
    std::optional<PermlaneHalf> opHalf = index.getHalf(op);
    if (!opHalf)
      return failure();

    DsBpermuteB32Op partner =
        cast_if_present<DsBpermuteB32Op>(index.findPartner(op));
    if (!partner)
      return failure();
    assert(op.getData() == partner.getData() &&
           "indexed sources must retain equality");

    Type pairType =
        RegType::get(op.getContext(), RegClass::VGPR, 2, /*index=*/-1);
    Value source =
        VMovB32TupleOp::create(rewriter, op.getLoc(), pairType, op.getData())
            .getResult();
    VPermlane32SwapB32TupleOp swap = VPermlane32SwapB32TupleOp::create(
        rewriter, op.getLoc(), pairType, source);
    Type wordType = op.getResult().getType();
    std::array<Type, 2> resultTypes{wordType, wordType};
    TupleToElementsOp split = TupleToElementsOp::create(
        rewriter, op.getLoc(), resultTypes, swap.getResult());

    Value lower = split.getElements()[0];
    Value upper = split.getElements()[1];
    rewriter.replaceOp(partner, *opHalf == PermlaneHalf::Lower ? upper : lower);
    rewriter.replaceOp(op, *opHalf == PermlaneHalf::Lower ? lower : upper);
    return success();
  }

  CandidateIndex &index;
};

static bool isOtherHalfExchange(DsBpermuteB32Op op, unsigned workgroupSize) {
  if (!op || workgroupSize < 64 || workgroupSize % 64 != 0)
    return false;
  for (unsigned wave : llvm::seq<unsigned>(workgroupSize / 64)) {
    unsigned waveBase = wave * 64;
    for (unsigned lane : llvm::seq<unsigned>(0, 64)) {
      std::optional<unsigned> source =
          evaluateBpermuteSource(op, lane, waveBase + lane);
      if (!source || *source != (lane ^ 32))
        return false;
    }
  }
  return true;
}

template <typename BinaryOp>
struct BpermuteHalfReductionToPermlanePattern
    : public OpRewritePattern<BinaryOp> {
  BpermuteHalfReductionToPermlanePattern(MLIRContext *context,
                                         unsigned workgroupSize,
                                         const FullExecAnalysis &exec)
      : OpRewritePattern<BinaryOp>(context), exec(exec),
        workgroupSize(workgroupSize) {}

  LogicalResult matchAndRewrite(BinaryOp op,
                                PatternRewriter &rewriter) const override {
    DsBpermuteB32Op permute =
        op.getLhs().template getDefiningOp<DsBpermuteB32Op>();
    Value direct = op.getRhs();
    if (!permute) {
      permute = op.getRhs().template getDefiningOp<DsBpermuteB32Op>();
      direct = op.getLhs();
    }
    if (!permute || !exec.sameSegment(permute, op) ||
        permute.getData() != direct ||
        !isOtherHalfExchange(permute, workgroupSize))
      return failure();

    Type pairType =
        RegType::get(op.getContext(), RegClass::VGPR, 2, /*index=*/-1);
    Value source =
        VMovB32TupleOp::create(rewriter, op.getLoc(), pairType, direct)
            .getResult();
    VPermlane32SwapB32TupleOp swap = VPermlane32SwapB32TupleOp::create(
        rewriter, op.getLoc(), pairType, source);
    Type wordType = direct.getType();
    std::array<Type, 2> resultTypes{wordType, wordType};
    TupleToElementsOp split = TupleToElementsOp::create(
        rewriter, op.getLoc(), resultTypes, swap.getResult());
    BinaryOp replacement =
        BinaryOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                         split.getElements()[0], split.getElements()[1]);

    Value addr = permute.getAddr();
    rewriter.replaceOp(op, replacement.getResult());
    eraseIfDead(rewriter, permute);
    eraseDeadAddressChain(rewriter, addr);
    return success();
  }

  const FullExecAnalysis &exec;
  unsigned workgroupSize;
};

template <typename BinaryOp>
struct BpermutePairReductionToPermlanePattern
    : public OpRewritePattern<BinaryOp> {
  BpermutePairReductionToPermlanePattern(MLIRContext *context,
                                         unsigned workgroupSize,
                                         const FullExecAnalysis &exec)
      : OpRewritePattern<BinaryOp>(context), exec(exec),
        workgroupSize(workgroupSize) {}

  LogicalResult matchAndRewrite(BinaryOp op,
                                PatternRewriter &rewriter) const override {
    DsBpermuteB32Op lhs = op.getLhs().template getDefiningOp<DsBpermuteB32Op>();
    DsBpermuteB32Op rhs = op.getRhs().template getDefiningOp<DsBpermuteB32Op>();
    if (!exec.sameSegment(lhs, op) || !exec.sameSegment(rhs, op) ||
        !isHalfExchangePair(lhs, rhs, workgroupSize))
      return failure();

    Value data = lhs.getData();
    Type pairType =
        RegType::get(op.getContext(), RegClass::VGPR, 2, /*index=*/-1);
    Value source = VMovB32TupleOp::create(rewriter, op.getLoc(), pairType, data)
                       .getResult();
    VPermlane32SwapB32TupleOp swap = VPermlane32SwapB32TupleOp::create(
        rewriter, op.getLoc(), pairType, source);
    Type wordType = data.getType();
    std::array<Type, 2> resultTypes{wordType, wordType};
    TupleToElementsOp split = TupleToElementsOp::create(
        rewriter, op.getLoc(), resultTypes, swap.getResult());
    BinaryOp replacement =
        BinaryOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                         split.getElements()[0], split.getElements()[1]);
    rewriter.replaceOp(op, replacement.getResult());
    eraseIfDead(rewriter, lhs);
    eraseIfDead(rewriter, rhs);
    return success();
  }

  const FullExecAnalysis &exec;
  unsigned workgroupSize;
};

static bool hasCrossLanePeepholeCandidate(func::FuncOp func) {
  bool found = false;
  WalkResult result = func.walk([&](Operation *op) {
    if (!isa<DsPermuteB32Op, DsBpermuteB32Op>(op))
      return WalkResult::advance();
    found = true;
    return WalkResult::interrupt();
  });
  return result.wasInterrupted() && found;
}

static LogicalResult runOnFunc(func::FuncOp func) {
  if (!hasCrossLanePeepholeCandidate(func))
    return success();

  FailureOr<unsigned> wavefrontSize = waveamdmachine::getAMDGPUWavefrontSize(
      func, "waveamd-cross-lane-peepholes");
  if (failed(wavefrontSize))
    return failure();
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(func,
                                                "waveamd-cross-lane-peepholes");
  if (failed(isa))
    return failure();

  FullExecAnalysis exec(func);
  CandidateIndex index(exec);
  RewritePatternSet patterns(func.getContext());
  patterns.add<DsPermuteToSwizzlePattern>(func.getContext(), *wavefrontSize);
  std::optional<unsigned> workgroupSize = getXLinearWorkgroupSize(func);
  if (*wavefrontSize == 64 && workgroupSize &&
      VPermlane32SwapB32TupleOp::isSupportedOnIsa(*isa)) {
    index.initialize(func, *workgroupSize);
    patterns.add<BpermuteSelectPairToPermlanePattern>(func.getContext(), index);
    patterns.add<BpermuteHalfBroadcastPairToPermlanePattern>(func.getContext(),
                                                             index);
    patterns.add<BpermuteHalfReductionToPermlanePattern<VAddF32Op>,
                 BpermuteHalfReductionToPermlanePattern<VMaxF32Op>,
                 BpermutePairReductionToPermlanePattern<VAddF32Op>,
                 BpermutePairReductionToPermlanePattern<VMaxF32Op>>(
        func.getContext(), *workgroupSize, exec);
  }
  return applyPatternsGreedily(
      func, std::move(patterns),
      GreedyRewriteConfig()
          .setListener(&index)
          .enableFolding(false)
          .setRegionSimplificationLevel(GreedySimplifyRegionLevel::Disabled));
}

struct WaveAMDCrossLanePeepholesPass
    : public wave::impl::WaveAMDCrossLanePeepholesBase<
          WaveAMDCrossLanePeepholesPass> {
  void runOnOperation() override {
    WalkResult result = getOperation()->walk([&](func::FuncOp func) {
      if (failed(runOnFunc(func)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
