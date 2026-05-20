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
    Per-op layout of the V / S / inst-offset address-field bucket on
    a memory op. The bucketizer queries the spec before emission to
    decide where each summand of a symbolic offset goes.
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

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEINTERFACES_TD
