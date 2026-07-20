//===- InstructionResourceState.h - Scoped issue resources -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONRESOURCESTATE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONRESOURCESTATE_H

#include "mlir/Support/LLVM.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

#include <array>
#include <cstdint>

namespace mlir::waveamdmachine {

struct ArchData;

enum class InstructionResourceScope : uint8_t {
  Wave,
  SIMD,
  SIMDPair,
  CU,
};

enum class InstructionResourceKind : uint8_t {
  None,
  SimdIssue,
  CuIssue,
  ValuPipe,
  SaluPipe,
  XdlPipe,
  LdsDmaIssue,
  NumResources,
};

struct WavePlacement {
  unsigned simd = 0;
  unsigned slot = 0;
};

struct InstructionResourceUse {
  InstructionResourceKind kind = InstructionResourceKind::None;
  InstructionResourceScope scope = InstructionResourceScope::Wave;
  unsigned units = 1;
  unsigned count = 1;
  int64_t offset = 0;
  int64_t period = 0;
  int64_t duration = 0;
};

struct InstructionResourceCapacities {
  unsigned valuPipe = 0;
  unsigned saluPipe = 0;
  unsigned xdlPipe = 0;
};

struct InstructionResourceQuery {
  int64_t readyCycle = 0;
  InstructionResourceKind kind = InstructionResourceKind::None;
  InstructionResourceScope scope = InstructionResourceScope::Wave;
};

llvm::StringRef getInstructionResourceScopeName(InstructionResourceScope scope);
llvm::StringRef getInstructionResourceKindName(InstructionResourceKind kind);
InstructionResourceScope
getInstructionResourceScope(InstructionResourceKind kind);

class InstructionResourceState {
public:
  InstructionResourceState(const ArchData &arch, unsigned waveCount,
                           InstructionResourceCapacities capacities = {});

  FailureOr<InstructionResourceQuery>
  query(unsigned wave, WavePlacement placement,
        ArrayRef<InstructionResourceUse> uses, int64_t earliestCycle) const;
  void commit(unsigned wave, WavePlacement placement,
              ArrayRef<InstructionResourceUse> uses, int64_t issueCycle);

  bool isEnabled(InstructionResourceKind kind) const;
  unsigned getActiveReservationCount(InstructionResourceKind kind,
                                     unsigned wave, WavePlacement placement,
                                     int64_t cycle) const;

private:
  static constexpr size_t kResourceCount =
      static_cast<size_t>(InstructionResourceKind::NumResources);

  struct Reservation {
    int64_t begin = 0;
    int64_t end = 0;
    unsigned units = 1;
  };

  struct ResourceCalendar {
    SmallVector<Reservation, 1> reservations;
    unsigned capacity = 0;
  };

  static constexpr size_t kSIMDResourceCount = 4;
  static constexpr size_t kSIMDPairResourceCount = 1;
  static constexpr size_t kCUResourceCount = 1;
  using SIMDResourceDomain = std::array<ResourceCalendar, kSIMDResourceCount>;
  using SIMDPairResourceDomain =
      std::array<ResourceCalendar, kSIMDPairResourceCount>;
  using CUResourceDomain = std::array<ResourceCalendar, kCUResourceCount>;

  const ResourceCalendar &getCalendar(unsigned wave, WavePlacement placement,
                                      InstructionResourceKind kind) const;
  ResourceCalendar &getCalendar(unsigned wave, WavePlacement placement,
                                InstructionResourceKind kind);
  static void appendReservations(const InstructionResourceUse &use,
                                 int64_t issueCycle,
                                 SmallVectorImpl<Reservation> &reservations);
  static bool canReserve(const ResourceCalendar &calendar,
                         ArrayRef<Reservation> reservations);
  static bool hasReservation(const InstructionResourceUse &use);
  LogicalResult validateUses(ArrayRef<InstructionResourceUse> uses) const;
  SmallVector<int64_t, 32>
  getCandidateCycles(unsigned wave, WavePlacement placement,
                     ArrayRef<InstructionResourceUse> uses,
                     int64_t initialCycle) const;
  bool canReserveAt(unsigned wave, WavePlacement placement,
                    ArrayRef<InstructionResourceUse> uses, int64_t cycle,
                    InstructionResourceKind &blockedKind,
                    InstructionResourceScope &blockedScope) const;
  void configure(InstructionResourceKind kind, unsigned capacity);
  void prune(int64_t cycle);

  SmallVector<SIMDResourceDomain, 4> simdResources;
  SmallVector<SIMDPairResourceDomain, 2> simdPairResources;
  CUResourceDomain cuResources;
  int64_t lastCommittedCycle = 0;
  unsigned waveCount = 0;
};

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONRESOURCESTATE_H
