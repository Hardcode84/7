// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// RUN: split-file %s %t
// RUN: sed s/tdm_load/tdm_store/g %t/load.mlir > %t/store.mlir
// RUN: sed -e s/gfx1250/gfx900/g -e s/waveamdmachine.expert_scheduling_mode// %t/load.mlir > %t/gfx900-load.mlir
// RUN: not wave-opt %t/gfx900-load.mlir --waveamd-hazard-repair 2>&1 | FileCheck %s --check-prefix=GFX900-LOAD
// RUN: not wave-opt %t/gfx900-load.mlir --waveamd-insert-hazard-waits 2>&1 | FileCheck %s --check-prefix=GFX900-LOAD
// RUN: not wave-opt %t/gfx900-load.mlir --waveamd-insert-ticket-waits 2>&1 | FileCheck %s --check-prefix=GFX900-TICKET
// RUN: sed -e s/gfx1250/gfx900/g -e s/waveamdmachine.expert_scheduling_mode// %t/store.mlir > %t/gfx900-store.mlir
// RUN: not wave-opt %t/gfx900-store.mlir --waveamd-hazard-repair 2>&1 | FileCheck %s --check-prefix=GFX900-STORE
// RUN: not wave-opt %t/gfx900-store.mlir --waveamd-insert-hazard-waits 2>&1 | FileCheck %s --check-prefix=GFX900-STORE
// RUN: not wave-opt %t/gfx900-store.mlir --waveamd-insert-ticket-waits 2>&1 | FileCheck %s --check-prefix=GFX900-TICKET
// RUN: sed -e s/gfx1250/gfx1200/g %t/load.mlir > %t/gfx1200-load.mlir
// RUN: not wave-opt %t/gfx1200-load.mlir --waveamd-hazard-repair 2>&1 | FileCheck %s --check-prefix=GFX1200-LOAD
// RUN: not wave-opt %t/gfx1200-load.mlir --waveamd-insert-hazard-waits 2>&1 | FileCheck %s --check-prefix=GFX1200-LOAD
// RUN: not wave-opt %t/gfx1200-load.mlir --waveamd-insert-ticket-waits 2>&1 | FileCheck %s --check-prefix=GFX1200-LOAD
// RUN: sed -e s/gfx1250/gfx1200/g %t/store.mlir > %t/gfx1200-store.mlir
// RUN: not wave-opt %t/gfx1200-store.mlir --waveamd-hazard-repair 2>&1 | FileCheck %s --check-prefix=GFX1200-STORE
// RUN: not wave-opt %t/gfx1200-store.mlir --waveamd-insert-hazard-waits 2>&1 | FileCheck %s --check-prefix=GFX1200-STORE
// RUN: not wave-opt %t/gfx1200-store.mlir --waveamd-insert-ticket-waits 2>&1 | FileCheck %s --check-prefix=GFX1200-STORE
// RUN: sed -e s/gfx1250/gfx1201/g %t/load.mlir > %t/gfx1201-load.mlir
// RUN: not wave-opt %t/gfx1201-load.mlir --waveamd-hazard-repair 2>&1 | FileCheck %s --check-prefix=GFX1201-LOAD
// RUN: not wave-opt %t/gfx1201-load.mlir --waveamd-insert-hazard-waits 2>&1 | FileCheck %s --check-prefix=GFX1201-LOAD
// RUN: not wave-opt %t/gfx1201-load.mlir --waveamd-insert-ticket-waits 2>&1 | FileCheck %s --check-prefix=GFX1201-LOAD
// RUN: sed -e s/gfx1250/gfx1201/g %t/store.mlir > %t/gfx1201-store.mlir
// RUN: not wave-opt %t/gfx1201-store.mlir --waveamd-hazard-repair 2>&1 | FileCheck %s --check-prefix=GFX1201-STORE
// RUN: not wave-opt %t/gfx1201-store.mlir --waveamd-insert-hazard-waits 2>&1 | FileCheck %s --check-prefix=GFX1201-STORE
// RUN: not wave-opt %t/gfx1201-store.mlir --waveamd-insert-ticket-waits 2>&1 | FileCheck %s --check-prefix=GFX1201-STORE
// RUN: wave-opt %t/load.mlir --waveamd-hazard-repair | FileCheck %s --check-prefix=VALID-LOAD
// RUN: wave-opt %t/load.mlir --waveamd-insert-hazard-waits | FileCheck %s --check-prefix=VALID-LOAD
// RUN: wave-opt %t/load.mlir --waveamd-insert-ticket-waits | FileCheck %s --check-prefix=VALID-LOAD
// RUN: wave-opt %t/store.mlir --waveamd-hazard-repair | FileCheck %s --check-prefix=VALID-STORE
// RUN: wave-opt %t/store.mlir --waveamd-insert-hazard-waits | FileCheck %s --check-prefix=VALID-STORE
// RUN: wave-opt %t/store.mlir --waveamd-insert-ticket-waits | FileCheck %s --check-prefix=VALID-STORE

// GFX900-LOAD: waveamdmachine.tdm_load is not supported on ISA 9.0.0
// GFX900-STORE: waveamdmachine.tdm_store is not supported on ISA 9.0.0
// GFX1200-LOAD: waveamdmachine.tdm_load is not supported on ISA 12.0.0
// GFX1200-STORE: waveamdmachine.tdm_store is not supported on ISA 12.0.0
// GFX1201-LOAD: waveamdmachine.tdm_load is not supported on ISA 12.0.1
// GFX1201-STORE: waveamdmachine.tdm_store is not supported on ISA 12.0.1

// GFX900-TICKET: tensor wait event unsupported on target
// VALID-LOAD: waveamdmachine.tdm_load
// VALID-STORE: waveamdmachine.tdm_store

//--- load.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @tdm_target(%d0: !waveamdmachine.reg<sgpr, 4, 0>,
                        %d1: !waveamdmachine.reg<sgpr, 8, 8>)
      attributes {waveamdmachine.expert_scheduling_mode} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %result = waveamdmachine.tdm_load %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4, 0>,
           !waveamdmachine.reg<sgpr, 8, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.s_endpgm
    return
  }
}
