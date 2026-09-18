//===- WaveAMDBufferAddressAnalysis.cpp - Buffer DMA eligibility
//------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDBufferPredicationUtils.h"
#include "WaveAMDMachineSelector.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::wave::wmsel;

namespace {
class BufferDmaAddressAnalysis {
public:
  BufferDmaAddressAnalysis(waveamd::DmaLoadLdsOp dma, Value descriptor,
                           DataFlowSolver &solver)
      : selector(dma->getParentOfType<func::FuncOp>(), solver),
        descriptor(descriptor) {
    selector.wavefrontSize =
        cast<SimdType>(dma.getSource().getType()).getWidth();
  }

  FailureOr<std::optional<PointerOffset>> build(Value pointer, Value stop = {});
  WaveAMDMachineSelector selector;

private:
  FailureOr<PointerOffset> buildElementOffset(Value value);
  FailureOr<std::optional<PointerOffset>> buildAdd(PtrAddOp add, Value stop);
  FailureOr<std::optional<PointerOffset>> buildCarry(BlockArgument arg);
  FailureOr<std::optional<PointerOffset>>
  buildIterationOffset(scf::ForOp loop, const PointerOffset &delta);
  Value descriptor;
  unsigned nextSymbol = 0;
};
} // namespace

FailureOr<PointerOffset>
BufferDmaAddressAnalysis::buildElementOffset(Value value) {
  if (auto index = value.getDefiningOp<IndexExprOp>())
    return makePointerOffset(selector, index);
  PointerOffset offset;
  if (std::optional<int64_t> constant = getConstantIntValue(value)) {
    FailureOr<sym::ExprHandle> expr =
        sym::composeExprInt(selector.symbolStore(), *constant);
    if (failed(expr))
      return failure();
    offset.expr = *expr;
    return offset;
  }
  std::string name = (Twine("dma_offset_") + Twine(nextSymbol++)).str();
  FailureOr<sym::ExprHandle> expr =
      sym::composeExprSym(selector.symbolStore(), name);
  if (failed(expr))
    return failure();
  offset.expr = *expr;
  TermKind kind =
      isa<SimdType>(value.getType()) ? TermKind::Lane : TermKind::Uniform;
  offset.bindings.push_back({name, value, kind});
  selector.appendBindingAssumptions(value, name, offset.assumptions);
  return offset;
}

FailureOr<std::optional<PointerOffset>>
BufferDmaAddressAnalysis::buildAdd(PtrAddOp add, Value stop) {
  FailureOr<std::optional<PointerOffset>> base = build(add.getBase(), stop);
  if (failed(base) || !*base)
    return base;
  FailureOr<PointerOffset> elements = buildElementOffset(add.getOffset());
  if (failed(elements))
    return failure();
  FailureOr<PointerOffset> bytes = scalePointerOffset(
      selector, *elements, selector.elementSizeBytes(add.getBase().getType()));
  if (failed(bytes))
    return failure();
  FailureOr<PointerOffset> merged =
      mergePointerOffsets(selector, **base, *bytes);
  if (failed(merged))
    return failure();
  return std::optional<PointerOffset>{std::move(*merged)};
}

FailureOr<std::optional<PointerOffset>>
BufferDmaAddressAnalysis::buildIterationOffset(scf::ForOp loop,
                                               const PointerOffset &delta) {
  if (!delta.expr)
    return std::optional<PointerOffset>{delta};
  if (llvm::any_of(delta.bindings, [&](const PointerOffsetBinding &binding) {
        return !loop.isDefinedOutsideOfLoop(binding.value);
      }))
    return std::optional<PointerOffset>{};
  std::optional<APInt> trips = loop.getStaticTripCount();
  if (!trips || trips->isZero() || trips->getActiveBits() > 63)
    return std::optional<PointerOffset>{};
  PointerOffset result = delta;
  llvm::StringMap<Value> reserved;
  for (const PointerOffsetBinding &binding : delta.bindings)
    reserved[binding.name] = binding.value;
  std::string name =
      getFreshIndexExprBindingName("dma_iteration", reserved, nextSymbol, "_");
  FailureOr<sym::ExprHandle> iteration =
      sym::composeExprSym(selector.symbolStore(), name);
  FailureOr<sym::PredHandle> bound =
      sym::rangeAssumption(selector.symbolStore(), name, 0,
                           static_cast<int64_t>(trips->getZExtValue()) - 1);
  if (failed(iteration) || failed(bound))
    return failure();
  FailureOr<sym::ExprHandle> expr = sym::composeExprBinary(
      selector.symbolStore(), delta.expr, sym::ExprBinaryOp::Mul, *iteration);
  if (failed(expr))
    return failure();
  result.expr = *expr;
  // Proof-only iteration coordinate; never materialized as the loop IV.
  result.bindings.push_back({name, loop.getInductionVar(), TermKind::Uniform});
  result.assumptions.push_back(*bound);
  return std::optional<PointerOffset>{std::move(result)};
}

FailureOr<std::optional<PointerOffset>>
BufferDmaAddressAnalysis::buildCarry(BlockArgument arg) {
  auto loop = dyn_cast<scf::ForOp>(arg.getOwner()->getParentOp());
  if (!loop || arg.getArgNumber() == 0)
    return std::optional<PointerOffset>{};
  unsigned index = arg.getArgNumber() - 1;
  auto yield = cast<scf::YieldOp>(loop.getBody()->getTerminator());
  FailureOr<std::optional<PointerOffset>> initial =
      build(loop.getInitArgs()[index]);
  FailureOr<std::optional<PointerOffset>> delta =
      build(yield.getOperand(index), arg);
  if (failed(initial) || failed(delta))
    return failure();
  if (!*initial || !*delta)
    return std::optional<PointerOffset>{};
  FailureOr<std::optional<PointerOffset>> advance =
      buildIterationOffset(loop, **delta);
  if (failed(advance) || !*advance)
    return advance;
  FailureOr<PointerOffset> offset =
      mergePointerOffsets(selector, **initial, **advance);
  if (failed(offset))
    return failure();
  return std::optional<PointerOffset>{std::move(*offset)};
}

FailureOr<std::optional<PointerOffset>>
BufferDmaAddressAnalysis::build(Value pointer, Value stop) {
  if (pointer == stop || pointer == descriptor)
    return std::optional<PointerOffset>{PointerOffset{}};
  if (auto cast = pointer.getDefiningOp<PtrCastOp>())
    return build(cast.getSource(), stop);
  if (auto add = pointer.getDefiningOp<PtrAddOp>())
    return buildAdd(add, stop);
  if (stop)
    return std::optional<PointerOffset>{};
  if (auto arg = dyn_cast<BlockArgument>(pointer))
    return buildCarry(arg);
  return std::optional<PointerOffset>{};
}

FailureOr<bool> mlir::wave::buffer_predication::canUseBufferDmaAddress(
    waveamd::DmaLoadLdsOp dma, Value descriptor, DataFlowSolver &solver) {
  if (!dma->getParentOfType<func::FuncOp>())
    return false;
  BufferDmaAddressAnalysis analysis(dma, descriptor, solver);
  FailureOr<std::optional<PointerOffset>> offset =
      analysis.build(dma.getSource());
  if (failed(offset))
    return dma.emitError("failed to analyze buffer DMA address");
  if (!*offset)
    return false;
  waveamdmachine::AddressFieldSpec spec =
      dma.getBytes() == 16
          ? waveamdmachine::BufferLoadLdsB128Op::getAddressFieldSpec()
          : waveamdmachine::BufferLoadLdsB32Op::getAddressFieldSpec();
  FailureOr<AddressPlan> plan =
      planMemoryAddress(analysis.selector, dma, **offset, spec);
  if (failed(plan))
    return failure();
  return !plan->fullAddressRemainderExpr;
}
