//===-- WaveAMDMachineInterfaces.td - Op interfaces -----------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEINTERFACES_TD
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEINTERFACES_TD

include "mlir/IR/OpBase.td"

def WaveAMDMachine_AddressFieldsOpInterface
    : OpInterface<"AddressFieldsOpInterface"> {
  let cppNamespace = "::mlir::waveamdmachine";
  let description = [{
    Per-op layout of the V / S / inst-offset address fields on
    a memory op. Address planning queries the spec before emission to
    route symbolic offset pieces.
  }];
  let methods = [
    StaticInterfaceMethod<
      [{Address-field layout for this op kind.}],
      "::mlir::waveamdmachine::AddressFieldSpec",
      "getAddressFieldSpec",
      (ins)
    >,
  ];
}

def WaveAMDMachine_WaitcntInfoOpInterface
    : OpInterface<"WaitcntInfoOpInterface"> {
  let cppNamespace = "::mlir::waveamdmachine";
  let description = [{
    Waitcnt counter metadata for machine ops.
  }];
  let methods = [
    InterfaceMethod<
      [{Waitcnt counter metadata for this op.}],
      "::mlir::waveamdmachine::WaitcntInfo",
      "getWaitcntInfo",
      (ins)
    >,
  ];
}

def WaveAMDMachine_M0WriteHazardOpInterface
    : OpInterface<"M0WriteHazardOpInterface"> {
  let cppNamespace = "::mlir::waveamdmachine";
  let description = [{
    M0 write that needs the hardware M0 pipeline gap before an LDS DMA consumer.
  }];
  let methods = [
    InterfaceMethod<
      [{M0 value carrying the write hazard.}],
      "::mlir::Value",
      "getM0HazardValue",
      (ins)
    >,
  ];
}

def WaveAMDMachine_MMAOpInterface
    : OpInterface<"MMAOpInterface"> {
  let cppNamespace = "::mlir::waveamdmachine";
  let description = [{
    Structured matrix multiply operand contract.
  }];
  let methods = [
    InterfaceMethod<
      [{A operand.}],
      "::mlir::Value",
      "getA",
      (ins)
    >,
    InterfaceMethod<
      [{B operand.}],
      "::mlir::Value",
      "getB",
      (ins)
    >,
    InterfaceMethod<
      [{Accumulator operand.}],
      "::mlir::Value",
      "getAcc",
      (ins)
    >,
    InterfaceMethod<
      [{Accumulator result.}],
      "::mlir::Value",
      "getAccResult",
      (ins),
      [{}],
      [{ return $_op.getResult(); }]
    >,
    InterfaceMethod<
      [{Optional A scale operand.}],
      "::mlir::Value",
      "getAScale",
      (ins),
      [{}],
      [{ return {}; }]
    >,
    InterfaceMethod<
      [{Optional B scale operand.}],
      "::mlir::Value",
      "getBScale",
      (ins),
      [{}],
      [{ return {}; }]
    >,
    InterfaceMethod<
      [{Replace accumulator operand.}],
      "void",
      "setAcc",
      (ins "::mlir::Value":$value),
      [{}],
      [{ $_op.getAccMutable().assign(value); }]
    >,
  ];
}

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEINTERFACES_TD
