//===- WaveAMDRegAllocRegionFlow.h - Region control flow -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCREGIONFLOW_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCREGIONFLOW_H

#include "mlir/IR/Operation.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave::regalloc_detail {

/// A cached structural view of RegionBranchOpInterface control flow.
///
/// Regalloc clients must derive split/join and repetition semantics from this
/// summary.  The summary deliberately knows nothing about Wave operation names,
/// register classes, allocation policy, or copy instructions.  Dialect-specific
/// storage semantics belong in operation interfaces; allocation clients merely
/// consume the resulting SSA transfers.
class RegAllocRegionFlow {
public:
  enum class TransferKind : unsigned {
    RepetitiveEntry,
    Cyclic,
    Forward,
    Exit,
  };

  enum class RepetitiveInputRelation {
    None,
    SameSlot,
    DifferentSlots,
  };

  struct Transfer {
    /// The forwarded operand and the successor input it populates.
    OpOperand *operand = nullptr;
    Value input;

    /// Null denotes the parent side of the region branch operation.
    Region *source = nullptr;
    Region *target = nullptr;

    /// The branch op for parent transfers, otherwise the region terminator.
    Operation *sourceOperation = nullptr;

    /// Ordinal within the successor's input range.  This mechanically ties
    /// entry, cyclic, and exit transfers for the common single-region case
    /// without rebuilding a value graph.
    unsigned successorInputIndex = 0;

    /// Structural relationship between source and target successor inputs on
    /// a cyclic edge.  This distinguishes forwarding one logical carry slot
    /// across regions from a permutation between distinct entry slots.
    RepetitiveInputRelation repetitiveInputRelation =
        RepetitiveInputRelation::None;
  };

  /// One RegionBranch successor edge.  Its transfers occupy a contiguous
  /// slice of Branch::transfers, preserving the interface's parallel-copy
  /// boundary without requiring clients to reconstruct groups by hashing
  /// operations and regions.
  struct TransferGroup {
    Operation *sourceOperation = nullptr;
    Region *source = nullptr;
    Region *target = nullptr;
    unsigned firstTransfer = 0;
    unsigned transferCount = 0;
  };

  struct Branch {
    Operation *op = nullptr;
    SmallVector<Region *, 2> regions;
    SmallVector<Transfer, 8> transfers;
    SmallVector<TransferGroup, 4> transferGroups;
    SmallVector<llvm::BitVector, 2> reachable;
    llvm::BitVector entryRegions;
    llvm::BitVector repetitiveRegions;
  };

  /// One edge in a deterministic spanning forest of the structural SSA
  /// transfers.  RegionBranch interfaces may describe the same logical value
  /// on several executable paths (for example, loop entry, bypass, backedge,
  /// and exit).  Regalloc needs one storage-equivalence component, not one
  /// independently significant alias edge per path.
  struct Alias {
    Value primary;
    Value extra;
    const Transfer *transfer = nullptr;
    TransferKind kind = TransferKind::Forward;
  };

  struct OrderedAliasEdge {
    Value lhs;
    Value rhs;
    const Transfer *transfer = nullptr;
    TransferKind kind = TransferKind::Forward;
  };

  explicit RegAllocRegionFlow(Operation *root);

  const Branch *lookup(Operation *op) const;
  ArrayRef<Branch> getBranches() const { return branches; }
  ArrayRef<Transfer> getTransfers(Operation *op) const;
  SmallVector<Alias, 8> getAliasForest(Operation *op) const;
  void appendOrderedAliasEdges(Operation *op,
                               SmallVectorImpl<OrderedAliasEdge> &edges) const;

  bool isRepetitive(Region *region) const;
  bool mayReach(Region *source, Region *target) const;
  bool areMutuallyExclusive(Region *lhs, Region *rhs) const;

  /// True when a region is one arm of an exclusive choice.  Sequential regions
  /// (for example, masked then/else execution) and repetitive regions are not
  /// exclusive choices even when both are possible entry successors.
  bool isExclusiveChoice(Region *region) const;

  /// Whether result definitions belong at the structural join rather than at
  /// the branch operation entry in a linearized operation order.  Acyclic
  /// sequencing between regions requires entry storage; exclusive arms and
  /// strongly connected repetitive regions do not.
  bool resultsStartAtJoin(Operation *op) const;
  bool isRepetitiveTransferOperand(OpOperand *operand) const {
    return repetitiveTransferOperands.contains(operand);
  }
  bool feedsRepetitiveTransfer(Value value) const;

  Region *getEnclosingRepetitiveRegion(Operation *op) const;
  Region *getEnclosingRepetitiveRegion(Value value) const;

  bool useMayFollow(Value value, Operation *from, Operation *user) const;

  static bool isDefinedInside(Operation *scope, Value value);
  static bool isOperationInside(Operation *scope, Operation *op);
  static Region *getChildRegion(Operation *parent, Operation *nested);

private:
  struct RegionLocation {
    unsigned branch = 0;
    unsigned region = 0;
  };

  void collect(Operation *root);
  void buildBranch(RegionBranchOpInterface branch);
  void classifyRepetitiveInputTransfers(Branch &branch);
  TransferKind getTransferKind(const Transfer &transfer) const;
  bool useCannotFollow(Operation *from, Operation *user) const;
  bool useMayFollowThroughRepetition(Value value, Operation *from,
                                     Operation *user) const;

  SmallVector<Branch, 0> branches;
  DenseMap<Operation *, unsigned> branchIds;
  DenseMap<Region *, RegionLocation> regionLocations;
  DenseSet<Region *> exclusiveRegions;
  DenseSet<OpOperand *> repetitiveTransferOperands;
  DenseSet<Value> repetitiveTransferInputs;
};

} // namespace mlir::wave::regalloc_detail

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCREGIONFLOW_H
