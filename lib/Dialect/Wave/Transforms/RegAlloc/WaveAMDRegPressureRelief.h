//===- WaveAMDRegPressureRelief.h - Reg pressure relief --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGPRESSURERELIEF_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGPRESSURERELIEF_H

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <cstdint>
#include <memory>
#include <optional>
#include <string>

namespace llvm {
class raw_ostream;
} // namespace llvm

namespace mlir {
class ArrayAttr;
class Builder;
class DictionaryAttr;
class NamedAttrList;
class OpBuilder;
class Operation;

namespace wave {

enum class WaveAMDPressureReliefProviderKind : uint8_t {
  BankPromotion,
  Rematerialize,
  LDSSpill,
  ScratchSpill,
};

struct WaveAMDPressureIntervalRef {
  SmallVector<int64_t, 4> resultIndices;
  SmallVector<int64_t, 4> slotOffsets;
  SmallVector<int64_t, 4> valuePositions;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
};

struct WaveAMDPressureReliefCost {
  int64_t materializationOps = 0;
  int64_t loopWeightedOps = 0;
  int64_t latencyPenalty = 0;
  int64_t instabilityPenalty = 0;
};

struct WaveAMDPressureReliefEffect {
  int64_t sgprLiveDelta = 0;
  int64_t vgprLiveDelta = 0;
  int64_t agprLiveDelta = 0;
};

struct WaveAMDPressureReliefTempInterval {
  std::optional<unsigned> fixedBase;
  waveamdmachine::RegClass regClass;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
};

struct WaveAMDPressureReliefTempAssignment {
  waveamdmachine::RegClass regClass;
  unsigned width = 0;
  int64_t base = -1;
};

struct WaveAMDPressureReliefDiagnosticMetric {
  std::string name;
  int64_t value = 0;
};

struct WaveAMDPressureReliefDiagnosticStringMetric {
  std::string name;
  std::string value;
};

struct WaveAMDPressureReliefProviderDiagnostic {
  SmallVector<WaveAMDPressureReliefDiagnosticMetric, 8> integerMetrics;
  SmallVector<WaveAMDPressureReliefDiagnosticStringMetric, 2> stringMetrics;
  std::string message;
};

struct WaveAMDPressureFailure {
  SmallVector<WaveAMDPressureIntervalRef, 4> overlaps;
  SmallVector<WaveAMDPressureReliefProviderDiagnostic, 4> providerDiagnostics;
  WaveAMDPressureIntervalRef request;
  StringRef regClass;
  unsigned combinedAGPRLiveDwords = 0;
  unsigned combinedVGPRFamilyLimit = 0;
  unsigned limit = 0;
  unsigned liveDwords = 0;
  unsigned position = 0;
  unsigned relief = 0;
  unsigned reserved = 0;
  bool combinedVGPRAGPR = false;
  bool placementFailure = false;
};

struct WaveAMDPressureReliefQuery {
  Operation *scope = nullptr;
  const WaveAMDPressureFailure *failure = nullptr;
};

class WaveAMDPressureReliefCandidate {
public:
  virtual ~WaveAMDPressureReliefCandidate();

  virtual StringRef getProviderName() const = 0;
  virtual WaveAMDPressureReliefCost getCost() const = 0;
  virtual unsigned getReliefDwords() const = 0;
  virtual std::optional<StringRef> getRejectReason() const;
  virtual WaveAMDPressureReliefEffect
  getPressureEffect(const WaveAMDPressureFailure &failure) const;
  virtual bool
  reducesPressureFailure(const WaveAMDPressureFailure &failure) const;

  bool isLegal() const;
  virtual void
  print(llvm::raw_ostream &os, bool selected = false,
        const WaveAMDPressureFailure *failure = nullptr,
        std::optional<bool> netReducesFailure = std::nullopt) const;
  virtual DictionaryAttr
  getDiagnosticAttr(Builder &builder, bool selected = false,
                    const WaveAMDPressureFailure *failure = nullptr) const;

protected:
  virtual void printExtra(llvm::raw_ostream &os) const;
  virtual void setExtraDiagnosticAttrs(Builder &builder,
                                       NamedAttrList &attrs) const;
};

using WaveAMDPressureReliefCandidateList =
    SmallVector<std::unique_ptr<WaveAMDPressureReliefCandidate>, 4>;

class WaveAMDPressureReliefPlan {
public:
  virtual ~WaveAMDPressureReliefPlan();

  virtual WaveAMDPressureReliefProviderKind getProviderKind() const = 0;
  virtual StringRef getProviderName() const = 0;
  virtual unsigned getReliefDwords() const = 0;
};

using WaveAMDPressureReliefPlanList =
    SmallVector<std::unique_ptr<WaveAMDPressureReliefPlan>, 8>;

class WaveAMDPressureReliefMaterializationContext {
public:
  virtual ~WaveAMDPressureReliefMaterializationContext();

  virtual FailureOr<WaveAMDPressureReliefTempAssignment>
  consumeTempAssignment(const WaveAMDPressureReliefPlan &plan,
                        waveamdmachine::RegClass regClass, unsigned width,
                        Operation *diagOp) = 0;
};

class WaveAMDPressureReliefProvider {
public:
  virtual ~WaveAMDPressureReliefProvider();

  virtual StringRef getName() const = 0;
  virtual WaveAMDPressureReliefProviderKind getKind() const = 0;
  virtual LogicalResult
  collectCandidates(const WaveAMDPressureReliefQuery &query,
                    WaveAMDPressureReliefCandidateList &candidates) const = 0;
  virtual std::unique_ptr<WaveAMDPressureReliefPlan>
  createPlan(const WaveAMDPressureReliefCandidate &candidate) const;
  virtual std::optional<StringRef> getRejectReason() const;
  virtual void collectFailureDiagnostics(
      SmallVectorImpl<WaveAMDPressureReliefProviderDiagnostic> &diagnostics)
      const;
  virtual void applyPlan(const WaveAMDPressureReliefPlan &plan) const;
  virtual void collectPlanTempIntervals(
      const WaveAMDPressureReliefPlan &plan,
      SmallVectorImpl<WaveAMDPressureReliefTempInterval> &intervals) const;
  virtual bool ownsPlan(const WaveAMDPressureReliefPlan &plan) const;
  virtual LogicalResult
  materializePlan(const WaveAMDPressureReliefPlan &plan,
                  WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder) const;
  virtual LogicalResult
  materializePlans(ArrayRef<const WaveAMDPressureReliefPlan *> plans,
                   WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) const;
  virtual bool hasRegAllocState() const;
  virtual void emitRemarks() const;
  virtual void notifyAttemptStarted() const;
  virtual void notifyNoCandidate() const;
  virtual void notifyPlanApplied() const;

  virtual bool
  isBetterCandidate(const WaveAMDPressureReliefCandidate &lhs,
                    const WaveAMDPressureReliefCandidate &rhs) const;
};

bool isBetterWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &lhs,
    const WaveAMDPressureReliefCandidate &rhs);
WaveAMDPressureReliefEffect
combineWaveAMDPressureReliefEffects(WaveAMDPressureReliefEffect lhs,
                                    WaveAMDPressureReliefEffect rhs);
bool waveAMDPressureReliefEffectProgressesFailure(
    const WaveAMDPressureFailure &failure,
    WaveAMDPressureReliefEffect currentEffect,
    WaveAMDPressureReliefEffect candidateEffect);
bool isBetterWaveAMDPressureReliefEffect(const WaveAMDPressureFailure &failure,
                                         WaveAMDPressureReliefEffect lhs,
                                         WaveAMDPressureReliefEffect rhs);
bool waveAMDPressureReliefEffectReducesFailure(
    const WaveAMDPressureFailure &failure, WaveAMDPressureReliefEffect effect);
bool waveAMDPressureReliefEffectSolvesFailure(
    const WaveAMDPressureFailure &failure, WaveAMDPressureReliefEffect effect);
std::string
formatWaveAMDPressureInterval(const WaveAMDPressureIntervalRef &interval);
std::string
formatWaveAMDPressureIntervals(ArrayRef<WaveAMDPressureIntervalRef> intervals);
std::string
formatWaveAMDPressureReliefCost(const WaveAMDPressureReliefCost &cost);
std::string formatWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &candidate, bool selected = false,
    const WaveAMDPressureFailure *failure = nullptr);
std::string formatWaveAMDPressureReliefCandidates(
    ArrayRef<std::unique_ptr<WaveAMDPressureReliefCandidate>> candidates,
    std::optional<unsigned> selected = std::nullopt,
    const WaveAMDPressureFailure *failure = nullptr);
DictionaryAttr
getWaveAMDPressureIntervalAttr(Builder &builder,
                               const WaveAMDPressureIntervalRef &interval);
ArrayAttr getWaveAMDPressureIntervalArrayAttr(
    Builder &builder, ArrayRef<WaveAMDPressureIntervalRef> intervals);
ArrayAttr getWaveAMDPressureReliefCandidateArrayAttr(
    Builder &builder,
    ArrayRef<std::unique_ptr<WaveAMDPressureReliefCandidate>> candidates,
    std::optional<unsigned> selected = std::nullopt,
    const WaveAMDPressureFailure *failure = nullptr);

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGPRESSURERELIEF_H
