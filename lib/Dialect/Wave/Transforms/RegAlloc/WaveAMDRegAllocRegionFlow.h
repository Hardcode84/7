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

/// Structural RegionBranch flow for one unchanged IR epoch.
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
    Value input;
    OpOperand *operand = nullptr;
    Region *source = nullptr;
    Region *target = nullptr;
    Operation *sourceOperation = nullptr;
    unsigned successorInputIndex = 0;
    RepetitiveInputRelation repetitiveInputRelation =
        RepetitiveInputRelation::None;
  };

  /// Contiguous parallel-copy group for one successor edge.
  struct TransferGroup {
    Operation *sourceOperation = nullptr;
    Region *source = nullptr;
    Region *target = nullptr;
    unsigned firstTransfer = 0;
    unsigned transferCount = 0;
  };

  struct Branch {
    SmallVector<Region *, 2> regions;
    SmallVector<Transfer, 8> transfers;
    SmallVector<TransferGroup, 4> transferGroups;
    SmallVector<llvm::BitVector, 2> reachable;
    llvm::BitVector entryRegions;
    llvm::BitVector repetitiveRegions;
    Operation *op = nullptr;
  };

  /// Deterministic spanning edge for one storage-equivalence component.
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
  TransferKind getTransferKind(const Transfer &transfer) const;
  SmallVector<Alias, 8> getAliasForest(Operation *op) const;
  void appendOrderedAliasEdges(Operation *op,
                               SmallVectorImpl<OrderedAliasEdge> &edges) const;

  bool isRepetitive(Region *region) const;
  bool mayReach(Region *source, Region *target) const;
  bool areMutuallyExclusive(Region *lhs, Region *rhs) const;

  /// True only for mutually exclusive arms, not sequential entry regions.
  bool isExclusiveChoice(Region *region) const;

  /// True when result storage starts at the structural join.
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
  void initializeBranch(RegionBranchOpInterface branchOp, unsigned branchId,
                        Branch &branch);
  void collectTransfers(RegionBranchOpInterface branchOp, Branch &branch);
  void collectPointTransfers(RegionBranchOpInterface branchOp,
                             RegionBranchPoint point, Branch &branch);
  void appendSuccessorTransfers(RegionBranchOpInterface branchOp,
                                RegionBranchPoint point, Region *source,
                                Operation *sourceOperation,
                                RegionSuccessor successor, Branch &branch);
  void closeReachability(Branch &branch);
  void classifyRegions(Branch &branch);
  void recordRepetitiveTransfers(const Branch &branch);
  void classifyRepetitiveInputTransfers(Branch &branch);
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
