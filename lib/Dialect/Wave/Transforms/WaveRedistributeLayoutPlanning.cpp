//===- WaveRedistributeLayoutPlanning.cpp - LDS layout planning -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveRedistributePlanning.h"

#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/MathExtras.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <limits>
#include <map>
#include <memory>
#include <optional>
#include <string>
#include <utility>

using namespace mlir;
using namespace mlir::wave;

namespace {
static constexpr StringLiteral kBlock = "block";
static constexpr StringLiteral kItem = "item";
static constexpr StringLiteral kSlot = "slot";
static constexpr int64_t kMaxLayoutPoints = int64_t{1} << 20;
// A score visits one point once and at most four LDS dwords. Bound the product
// of points and candidate rescoring, not just the access-pattern allocation.
static constexpr uint64_t kMaxLayoutWork = uint64_t{1} << 22;

static Type getPacketPayloadType(Type type) {
  return cast<SimdType>(type).getElementType();
}

static int64_t getPacketElementCount(Type type) {
  if (VectorType vector = dyn_cast<VectorType>(getPacketPayloadType(type)))
    return vector.getNumElements();
  return 1;
}

static const indexing::IndexMap::Input &getInput(const indexing::IndexMap &map,
                                                 StringRef name) {
  auto input = llvm::find_if(map.inputs, [&](const auto &candidate) {
    return sym::ExprView(candidate.variable).getSymbolName() == name;
  });
  assert(input != map.inputs.end() && "missing index-map input");
  return *input;
}

static FailureOr<sym::ExprHandle> composeWithInt(sym::Store &store,
                                                 sym::ExprHandle lhs,
                                                 sym::ExprBinaryOp op,
                                                 int64_t rhs) {
  FailureOr<sym::ExprHandle> literal = sym::composeExprInt(store, rhs);
  if (failed(literal))
    return failure();
  return sym::composeExprBinary(store, lhs, op, *literal);
}

static FailureOr<sym::ExprHandle>
floorDiv(sym::Store &store, sym::ExprHandle value, int64_t divisor) {
  FailureOr<sym::ExprHandle> divided =
      composeWithInt(store, value, sym::ExprBinaryOp::Div, divisor);
  if (failed(divided))
    return failure();
  return sym::composeExprFloor(store, *divided);
}

static FailureOr<waveamdmachine::AMDGPULDSAccessTopology>
getSharedMemoryAccessTopology(Operation *op, unsigned accessBits) {
  ModuleOp targetModule = waveamdmachine::findAMDGPUTargetModule(op);
  if (!targetModule)
    return waveamdmachine::AMDGPULDSAccessTopology{
        32, std::max(1u, (accessBits + 31) / 32),
        waveamdmachine::AMDGPULDSLoadLaneGrouping::Contiguous};
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> subtarget =
      waveamdmachine::createAMDGPUMCSubtargetInfo(
          op, "wave-lower-redistribute layout planning");
  if (failed(subtarget))
    return failure();
  return waveamdmachine::getAMDGPULDSAccessTopology(**subtarget, accessBits);
}

struct ScratchLoadPoint {
  int64_t item;
  int64_t localGroup;
};

struct ScratchAccessPattern {
  int64_t blocks;
  int64_t items;
  int64_t resultGroups;
  SmallVector<ScratchLoadPoint> loads;

  const ScratchLoadPoint &get(int64_t block, int64_t resultGroup,
                              int64_t item) const {
    int64_t index = (block * resultGroups + resultGroup) * items + item;
    return loads[index];
  }
};

static FailureOr<sym::ExprHandle> getLiteral(sym::Store &store, int64_t value) {
  return sym::composeExprInt(store, value);
}

static FailureOr<ScratchLoadPoint>
getScratchLoadPoint(RedistributeOp op, const GroupWindow &window,
                    ArrayRef<sym::ExprHandle> values) {
  std::optional<int64_t> sourceItem = sym::getIntegerLiteralValue(values[0]);
  std::optional<int64_t> localGroup = sym::getIntegerLiteralValue(values[1]);
  if (!sourceItem || !localGroup)
    return op.emitOpError(
        "scratch layout point did not specialize to integer coordinates");
  if (*sourceItem < 0 || *sourceItem >= op.getRelation().getItems() ||
      *localGroup < 0 || *localGroup >= window.localGroups)
    return op.emitOpError(
        "scratch layout point specialized outside the scratch footprint");
  return ScratchLoadPoint{*sourceItem, *localGroup};
}

static FailureOr<ScratchLoadPoint>
specializeLoadPoint(sym::Store &store, RedistributeOp op,
                    const indexing::IndexMap &carrier, const PacketPlan &packet,
                    const GroupWindow &window, int64_t block, int64_t item,
                    int64_t resultGroup) {
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  int64_t packedSlot = resultGroup * packet.vectorElements;
  int64_t slot =
      packedToLogicalSlot(packet.resultWithinMask, resultSlots, packedSlot);
  FailureOr<sym::ExprHandle> blockValue = getLiteral(store, block);
  FailureOr<sym::ExprHandle> itemValue = getLiteral(store, item);
  FailureOr<sym::ExprHandle> slotValue = getLiteral(store, slot);
  if (failed(blockValue) || failed(itemValue) || failed(slotValue))
    return failure();
  std::array<sym::ExprSubstitution, 3> definitions{
      sym::ExprSubstitution{getInput(carrier, kBlock).variable, *blockValue},
      sym::ExprSubstitution{getInput(carrier, kItem).variable, *itemValue},
      sym::ExprSubstitution{getInput(carrier, kSlot).variable, *slotValue}};
  std::array<sym::ExprHandle, 2> expressions{packet.sourceItem, window.local};
  std::string diagnostic;
  FailureOr<SmallVector<sym::ExprHandle>> values =
      indexing::simplify(store, carrier, expressions, definitions, &diagnostic);
  if (failed(values))
    return op.emitOpError("failed to specialize scratch layout point: ")
           << diagnostic;
  return getScratchLoadPoint(op, window, *values);
}

static FailureOr<ScratchAccessPattern>
buildScratchAccessPattern(sym::Store &store, RedistributeOp op,
                          const indexing::IndexMap &carrier,
                          const PacketPlan &packet, const GroupWindow &window) {
  ScratchAccessPattern pattern{op.getRelation().getBlocks(),
                               op.getRelation().getItems(),
                               packet.resultGroups,
                               {}};
  pattern.loads.reserve(pattern.blocks * pattern.resultGroups * pattern.items);
  for (int64_t block : llvm::seq<int64_t>(0, pattern.blocks))
    for (int64_t group : llvm::seq<int64_t>(0, pattern.resultGroups))
      for (int64_t item : llvm::seq<int64_t>(0, pattern.items)) {
        FailureOr<ScratchLoadPoint> point = specializeLoadPoint(
            store, op, carrier, packet, window, block, item, group);
        if (failed(point))
          return failure();
        pattern.loads.push_back(*point);
      }
  return pattern;
}

static std::optional<uint64_t>
getScratchLayoutPoints(RedistributeOp op, const PacketPlan &packet) {
  std::optional<int64_t> groups =
      llvm::checkedAdd(packet.sourceGroups, packet.resultGroups);
  std::optional<int64_t> points =
      groups ? llvm::checkedMul(*groups, op.getRelation().getItems())
             : std::nullopt;
  points = points ? llvm::checkedMul(*points, op.getRelation().getBlocks())
                  : std::nullopt;
  if (!points || *points < 0)
    return std::nullopt;
  return static_cast<uint64_t>(*points);
}

struct ScratchLayoutWorkBudget {
  uint64_t workPerScore;
  uint64_t remaining = kMaxLayoutWork;

  bool consumeScore() {
    if (workPerScore > remaining)
      return false;
    remaining -= workPerScore;
    return true;
  }
};

struct ScratchAccessShape {
  int64_t vectorBits;
  uint64_t workPerScore;
};

static std::optional<ScratchAccessShape>
getScratchAccessShape(uint64_t points, const PacketPlan &packet,
                      int64_t elementBits) {
  if (packet.vectorElements <= 0 || elementBits <= 0)
    return std::nullopt;
  std::optional<int64_t> vectorBits =
      llvm::checkedMul(packet.vectorElements, elementBits);
  std::optional<int64_t> roundedBits =
      vectorBits ? llvm::checkedAdd(*vectorBits, int64_t{31}) : std::nullopt;
  if (!vectorBits || !roundedBits)
    return std::nullopt;
  int64_t dwords = std::max<int64_t>(1, *roundedBits / 32);
  uint64_t unsignedDwords = static_cast<uint64_t>(dwords);
  if (points > std::numeric_limits<uint64_t>::max() / unsignedDwords)
    return std::nullopt;
  return ScratchAccessShape{*vectorBits, points * unsignedDwords};
}

static std::optional<ScratchAccessShape>
getScratchLayoutShape(RedistributeOp op, const PacketPlan &packet,
                      int64_t elementBits) {
  std::optional<uint64_t> points = getScratchLayoutPoints(op, packet);
  if (!points || !*points)
    return std::nullopt;
  if (*points > static_cast<uint64_t>(kMaxLayoutPoints))
    return std::nullopt;
  std::optional<ScratchAccessShape> shape =
      getScratchAccessShape(*points, packet, elementBits);
  if (!shape || !shape->workPerScore)
    return std::nullopt;
  return shape;
}

struct ScratchLayoutInputs {
  ScratchAccessPattern pattern;
  ScratchAccessShape shape;
  waveamdmachine::AMDGPULDSAccessTopology topology;
};

static FailureOr<std::optional<ScratchLayoutInputs>> buildScratchLayoutInputs(
    sym::Store &store, RedistributeOp op, const indexing::IndexMap &carrier,
    const PacketPlan &packet, const GroupWindow &window, int64_t elementBits) {
  std::optional<ScratchAccessShape> shape =
      getScratchLayoutShape(op, packet, elementBits);
  if (!shape)
    return std::optional<ScratchLayoutInputs>{};
  FailureOr<ScratchAccessPattern> pattern =
      buildScratchAccessPattern(store, op, carrier, packet, window);
  FailureOr<waveamdmachine::AMDGPULDSAccessTopology> topology =
      getSharedMemoryAccessTopology(op, shape->vectorBits);
  if (failed(pattern) || failed(topology))
    return failure();
  if (!topology->bankCount) {
    op.emitOpError("target reports no LDS banks");
    return failure();
  }
  return std::optional<ScratchLayoutInputs>{
      ScratchLayoutInputs{std::move(*pattern), std::move(*shape), *topology}};
}

static int64_t physicalItem(const ScratchPhysicalLayout &layout, int64_t item,
                            int64_t localGroup) {
  int64_t physical = item;
  for (auto [sourceBit, targetBit] : layout.itemXors)
    physical ^= ((static_cast<uint64_t>(item) >> sourceBit) & 1) << targetBit;
  if (layout.phaseBits) {
    int64_t phase = (localGroup >> layout.groupShift) &
                    ((int64_t{1} << layout.phaseBits) - 1);
    physical ^= phase << layout.itemShift;
  }
  return physical;
}

static int64_t physicalVectorAddress(const ScratchPhysicalLayout &layout,
                                     int64_t items, int64_t vectorElements,
                                     int64_t item, int64_t localGroup) {
  return (localGroup * items + physicalItem(layout, item, localGroup)) *
         vectorElements;
}

enum class ScratchAccessKind { Load, Store };

static int64_t scoreScratchBankAccesses(
    ArrayRef<int64_t> addresses, int64_t elementBits,
    const ScratchAccessShape &shape, ScratchAccessKind kind,
    const waveamdmachine::AMDGPULDSAccessTopology &topology) {
  bool load = kind == ScratchAccessKind::Load;
  int64_t banks = topology.bankCount;
  unsigned phases = 0;
  for (unsigned lane = 0; lane < addresses.size(); ++lane)
    phases = std::max(
        phases,
        waveamdmachine::getAMDGPULDSLanePhase(topology, load, lane) + 1);
  int64_t score = 0;
  for (unsigned phase = 0; phase < phases; ++phase) {
    // Loads of one dword broadcast even when lanes select different B8/B16
    // subwords. Stores do not: contiguous B8 addresses 0..3 contribute four
    // uses of bank 0 (cost 3), and B16 addresses 0..1 contribute two (cost 1).
    DenseSet<int64_t> loadedWords;
    SmallVector<int64_t, 64> bankUse(banks, 0);
    for (auto [lane, address] : llvm::enumerate(addresses)) {
      if (waveamdmachine::getAMDGPULDSLanePhase(topology, load, lane) != phase)
        continue;
      int64_t firstBit = address * elementBits;
      int64_t firstWord = firstBit / 32;
      int64_t lastWord = (firstBit + shape.vectorBits - 1) / 32;
      for (int64_t word : llvm::seq<int64_t>(firstWord, lastWord + 1))
        if (kind == ScratchAccessKind::Store || loadedWords.insert(word).second)
          ++bankUse[word % banks];
    }
    score += *llvm::max_element(bankUse) - 1;
  }
  return score;
}

static int64_t
scoreStoreLayout(const ScratchPhysicalLayout &layout, RedistributeOp op,
                 const PacketPlan &packet, const GroupWindow &window,
                 int64_t waveWidth, int64_t elementBits,
                 const ScratchAccessShape &shape,
                 const waveamdmachine::AMDGPULDSAccessTopology &topology) {
  int64_t items = op.getRelation().getItems();
  int64_t score = 0;
  for (int64_t block : llvm::seq<int64_t>(0, op.getRelation().getBlocks())) {
    (void)block;
    for (int64_t group : llvm::seq<int64_t>(0, packet.sourceGroups)) {
      int64_t localGroup = group % window.localGroups;
      for (int64_t wave = 0; wave < items; wave += waveWidth) {
        SmallVector<int64_t> addresses;
        int64_t lanes = std::min(waveWidth, items - wave);
        addresses.reserve(lanes);
        for (int64_t lane : llvm::seq<int64_t>(0, lanes))
          addresses.push_back(physicalVectorAddress(
              layout, items, packet.vectorElements, wave + lane, localGroup));
        score += scoreScratchBankAccesses(addresses, elementBits, shape,
                                          ScratchAccessKind::Store, topology);
      }
    }
  }
  return score;
}

static int64_t
scoreLoadLayout(const ScratchPhysicalLayout &layout,
                const ScratchAccessPattern &pattern, const PacketPlan &packet,
                int64_t waveWidth, int64_t elementBits,
                const ScratchAccessShape &shape,
                const waveamdmachine::AMDGPULDSAccessTopology &topology) {
  int64_t score = 0;
  for (int64_t block : llvm::seq<int64_t>(0, pattern.blocks))
    for (int64_t group : llvm::seq<int64_t>(0, pattern.resultGroups))
      for (int64_t wave = 0; wave < pattern.items; wave += waveWidth) {
        SmallVector<int64_t> addresses;
        int64_t lanes = std::min(waveWidth, pattern.items - wave);
        addresses.reserve(lanes);
        for (int64_t lane : llvm::seq<int64_t>(0, lanes)) {
          const ScratchLoadPoint &point =
              pattern.get(block, group, wave + lane);
          addresses.push_back(physicalVectorAddress(
              layout, pattern.items, packet.vectorElements, point.item,
              point.localGroup));
        }
        score += scoreScratchBankAccesses(addresses, elementBits, shape,
                                          ScratchAccessKind::Load, topology);
      }
  return score;
}

static int64_t
scoreScratchLayout(const ScratchPhysicalLayout &layout, RedistributeOp op,
                   const ScratchAccessPattern &pattern,
                   const PacketPlan &packet, const GroupWindow &window,
                   int64_t waveWidth, int64_t elementBits,
                   const ScratchAccessShape &shape,
                   const waveamdmachine::AMDGPULDSAccessTopology &topology) {
  return scoreStoreLayout(layout, op, packet, window, waveWidth, elementBits,
                          shape, topology) +
         scoreLoadLayout(layout, pattern, packet, waveWidth, elementBits, shape,
                         topology);
}

struct ScoredLayout {
  ScratchPhysicalLayout layout;
  int64_t conflicts;
};

static bool isBetter(const ScoredLayout &candidate, const ScoredLayout &best) {
  return candidate.conflicts < best.conflicts;
}

static ScoredLayout selectPhaseLayout(
    RedistributeOp op, const ScratchAccessPattern &pattern,
    const PacketPlan &packet, const GroupWindow &window, int64_t waveWidth,
    int64_t elementBits, const ScratchAccessShape &shape,
    const waveamdmachine::AMDGPULDSAccessTopology &topology, unsigned groupBits,
    unsigned itemBits, ScratchLayoutWorkBudget &budget, ScoredLayout best) {
  for (unsigned groupShift = 0; groupShift < groupBits; ++groupShift) {
    unsigned maxPhaseBits = std::min(groupBits - groupShift, itemBits);
    for (unsigned phaseBits = 1; phaseBits <= maxPhaseBits; ++phaseBits)
      for (unsigned itemShift = 0; itemShift + phaseBits <= itemBits;
           ++itemShift) {
        ScratchPhysicalLayout candidate;
        candidate.groupShift = groupShift;
        candidate.phaseBits = phaseBits;
        candidate.itemShift = itemShift;
        if (!budget.consumeScore())
          return best;
        int64_t conflicts =
            scoreScratchLayout(candidate, op, pattern, packet, window,
                               waveWidth, elementBits, shape, topology);
        ScoredLayout scored{candidate, conflicts};
        if (isBetter(scored, best))
          best = std::move(scored);
      }
  }
  return best;
}

static ScoredLayout selectItemXorLayout(
    RedistributeOp op, const ScratchAccessPattern &pattern,
    const PacketPlan &packet, const GroupWindow &window, int64_t waveWidth,
    int64_t elementBits, const ScratchAccessShape &shape,
    const waveamdmachine::AMDGPULDSAccessTopology &topology, unsigned itemBits,
    ScratchLayoutWorkBudget &budget, ScoredLayout best) {
  bool improved = true;
  while (improved) {
    improved = false;
    ScoredLayout iterationBest = best;
    for (unsigned sourceBit = 1; sourceBit < itemBits; ++sourceBit)
      for (unsigned targetBit = 0; targetBit < sourceBit; ++targetBit) {
        std::pair<unsigned, unsigned> itemXor{sourceBit, targetBit};
        if (llvm::is_contained(best.layout.itemXors, itemXor))
          continue;
        ScratchPhysicalLayout candidate = best.layout;
        candidate.itemXors.push_back(itemXor);
        if (!budget.consumeScore())
          return iterationBest;
        int64_t conflicts =
            scoreScratchLayout(candidate, op, pattern, packet, window,
                               waveWidth, elementBits, shape, topology);
        ScoredLayout scored{candidate, conflicts};
        if (isBetter(scored, iterationBest)) {
          iterationBest = std::move(scored);
          improved = true;
        }
      }
    best = std::move(iterationBest);
  }
  return best;
}

static FailureOr<sym::ExprHandle>
composeItemXors(sym::Store &store, sym::ExprHandle item,
                const ScratchPhysicalLayout &layout) {
  sym::ExprHandle physical = item;
  if (!layout.compactItemXors) {
    for (auto [sourceBit, targetBit] : layout.itemXors) {
      FailureOr<sym::ExprHandle> bit =
          floorDiv(store, item, int64_t{1} << sourceBit);
      if (succeeded(bit))
        bit = composeWithInt(store, *bit, sym::ExprBinaryOp::Mod, 2);
      if (succeeded(bit) && targetBit)
        bit = composeWithInt(store, *bit, sym::ExprBinaryOp::Mul,
                             int64_t{1} << targetBit);
      if (failed(bit))
        return failure();
      FailureOr<sym::ExprHandle> swizzled =
          sym::composeExprBinary(store, physical, sym::ExprBinaryOp::Xor, *bit);
      if (failed(swizzled))
        return failure();
      physical = *swizzled;
    }
    return physical;
  }
  std::map<unsigned, int64_t> masksByShift;
  for (auto [sourceBit, targetBit] : layout.itemXors) {
    assert(sourceBit > targetBit && "item XOR must move a higher bit down");
    masksByShift[sourceBit - targetBit] |= int64_t{1} << targetBit;
  }
  for (auto [shift, mask] : masksByShift) {
    FailureOr<sym::ExprHandle> bits =
        floorDiv(store, item, int64_t{1} << shift);
    if (succeeded(bits))
      bits = composeWithInt(store, *bits, sym::ExprBinaryOp::And, mask);
    if (failed(bits))
      return failure();
    FailureOr<sym::ExprHandle> swizzled =
        sym::composeExprBinary(store, physical, sym::ExprBinaryOp::Xor, *bits);
    if (failed(swizzled))
      return failure();
    physical = *swizzled;
  }
  return physical;
}
} // namespace

FailureOr<ScratchPhysicalLayout> mlir::wave::selectScratchPhysicalLayout(
    sym::Store &store, RedistributeOp op, const indexing::IndexMap &carrier,
    const PacketPlan &packet, const GroupWindow &window, int64_t waveWidth,
    int64_t elementBits) {
  FailureOr<std::optional<ScratchLayoutInputs>> inputs =
      buildScratchLayoutInputs(store, op, carrier, packet, window, elementBits);
  if (failed(inputs))
    return failure();
  if (!*inputs)
    return ScratchPhysicalLayout{};
  ScratchLayoutInputs &prepared = **inputs;
  ScratchLayoutWorkBudget budget{prepared.shape.workPerScore};
  ScratchPhysicalLayout identity;
  if (!budget.consumeScore())
    return identity;
  ScoredLayout best{identity,
                    scoreScratchLayout(identity, op, prepared.pattern, packet,
                                       window, waveWidth, elementBits,
                                       prepared.shape, prepared.topology)};
  unsigned groupBits =
      window.localGroups > 1 ? llvm::Log2_64_Ceil(window.localGroups) : 0;
  unsigned itemBits =
      llvm::countr_zero(static_cast<uint64_t>(op.getRelation().getItems()));

  bool targetSpecificGrouping =
      prepared.topology.loadLaneGrouping !=
      waveamdmachine::AMDGPULDSLoadLaneGrouping::Contiguous;
  if (targetSpecificGrouping) {
    // First reconstruct the conventional 32-bank layout. CDNA4 issues a B128
    // read in four quad-pair phases across the full wave. Preserve the layout
    // only when every phase is conflict-free. Otherwise, use the conservative
    // combined-quad topology below to find a replacement.
    waveamdmachine::AMDGPULDSAccessTopology contiguousTopology{
        32, prepared.topology.dwordsPerLane,
        waveamdmachine::AMDGPULDSLoadLaneGrouping::Contiguous};
    ScratchLayoutWorkBudget contiguousBudget{prepared.shape.workPerScore};
    ScoredLayout contiguous{
        identity, scoreScratchLayout(identity, op, prepared.pattern, packet,
                                     window, waveWidth, elementBits,
                                     prepared.shape, contiguousTopology)};
    contiguous = selectPhaseLayout(op, prepared.pattern, packet, window,
                                   waveWidth, elementBits, prepared.shape,
                                   contiguousTopology, groupBits, itemBits,
                                   contiguousBudget, std::move(contiguous));
    contiguous =
        selectItemXorLayout(op, prepared.pattern, packet, window, waveWidth,
                            elementBits, prepared.shape, contiguousTopology,
                            itemBits, contiguousBudget, std::move(contiguous));
    waveamdmachine::AMDGPULDSAccessTopology preservationTopology =
        prepared.topology;
    preservationTopology.loadLaneGrouping =
        waveamdmachine::AMDGPULDSLoadLaneGrouping::DsReadB128QuadPairs;
    ScoredLayout targetScored{
        contiguous.layout,
        scoreScratchLayout(contiguous.layout, op, prepared.pattern, packet,
                           window, waveWidth, elementBits, prepared.shape,
                           preservationTopology)};
    if (targetScored.conflicts == 0)
      return std::move(targetScored.layout);

    // Keep the conventional layout in the replacement search, but compare it
    // with other candidates only after scoring it under the replacement
    // topology. The preservation and replacement scores model different lane
    // groupings and are not comparable.
    if (budget.consumeScore()) {
      ScoredLayout replacementScored{
          contiguous.layout,
          scoreScratchLayout(contiguous.layout, op, prepared.pattern, packet,
                             window, waveWidth, elementBits, prepared.shape,
                             prepared.topology)};
      if (isBetter(replacementScored, best))
        best = std::move(replacementScored);
    }
  }

  best = selectPhaseLayout(op, prepared.pattern, packet, window, waveWidth,
                           elementBits, prepared.shape, prepared.topology,
                           groupBits, itemBits, budget, std::move(best));
  best = selectItemXorLayout(op, prepared.pattern, packet, window, waveWidth,
                             elementBits, prepared.shape, prepared.topology,
                             itemBits, budget, std::move(best));
  // Topology-selected layouts can need several XORs to remove conflicts.
  // Combine equal-distance bit moves so the replacement does not add a serial
  // address operation for each moved bit. Keep the established expression
  // tree when the conventional layout is already conflict-free.
  best.layout.compactItemXors = targetSpecificGrouping;
  return std::move(best.layout);
}

FailureOr<sym::ExprHandle>
mlir::wave::composeScratchPhysicalItem(sym::Store &store, sym::ExprHandle item,
                                       sym::ExprHandle localGroup,
                                       const ScratchPhysicalLayout &layout) {
  FailureOr<sym::ExprHandle> physical = composeItemXors(store, item, layout);
  if (failed(physical) || !layout.phaseBits)
    return physical;
  FailureOr<sym::ExprHandle> phase =
      floorDiv(store, localGroup, int64_t{1} << layout.groupShift);
  if (succeeded(phase))
    phase = composeWithInt(store, *phase, sym::ExprBinaryOp::Mod,
                           int64_t{1} << layout.phaseBits);
  if (succeeded(phase))
    phase = composeWithInt(store, *phase, sym::ExprBinaryOp::Mul,
                           int64_t{1} << layout.itemShift);
  if (failed(phase))
    return failure();
  return sym::composeExprBinary(store, *physical, sym::ExprBinaryOp::Xor,
                                *phase);
}
