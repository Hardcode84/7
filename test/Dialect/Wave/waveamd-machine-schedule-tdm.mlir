// RUN: wave-opt %s --waveamd-machine-schedule-report='print-classes=1 print-score=1' 2>&1 \
// RUN:   | FileCheck %s --check-prefix=REPORT
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   | FileCheck %s --check-prefix=IR

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @tdm_schedule(
      %d0: !waveamdmachine.reg<sgpr, 4>,
      %d1: !waveamdmachine.reg<sgpr, 8>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %loaded = waveamdmachine.tdm_load %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %stored = waveamdmachine.tdm_store %d0, %d1 after %loaded
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// REPORT: op func=tdm_schedule region=0 index=1 name=waveamdmachine.tdm_load class=WriteTDM fu=LGKM latency=320 resource_cycles=1
// REPORT: op func=tdm_schedule region=0 index=2 name=waveamdmachine.tdm_store class=WriteTDM fu=LGKM latency=320 resource_cycles=1
// REPORT: score func=tdm_schedule region=0 order=original cycles={{[0-9]+}} issued_ops=2

// IR-LABEL: func.func @tdm_schedule
// IR: waveamdmachine.tdm_load
// IR: waveamdmachine.tdm_store
