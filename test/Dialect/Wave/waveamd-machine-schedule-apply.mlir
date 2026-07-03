// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s --check-prefix=IR
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1 max-region-ops=2' | FileCheck %s --check-prefix=CAP
// RUN: not wave-opt %s --waveamd-machine-schedule='apply-schedule=1 beam-search=1' 2>&1 | FileCheck %s --check-prefix=ERR

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill(%base: !waveamdmachine.reg<sgpr, 1>,
                   %off: !waveamdmachine.reg<vgpr, 1>,
                   %ptr: !waveamdmachine.reg<sgpr, 2>,
                   %a: !waveamdmachine.reg<vgpr, 1>,
                   %b: !waveamdmachine.reg<vgpr, 1>,
                   %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @m0_fill
// IR: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[FILL:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// CAP-LABEL: func.func @m0_fill
// CAP: [[M0:%.*]] = waveamdmachine.s_mov_m0
// CAP-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// DIAG: waveamd-machine-schedule region func=m0_fill
// DIAG-SAME: action=apply reason=better
// DIAG-SAME: filled_gaps=1
// DIAG-SAME: m0_gaps=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @barrier_keep(%off: !waveamdmachine.reg<vgpr, 1>,
                        %base: !waveamdmachine.reg<sgpr, 2>,
                        %a: !waveamdmachine.reg<vgpr, 1>,
                        %b: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %tok2 = waveamdmachine.s_barrier %tok1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @barrier_keep
// IR: [[TOK0:%.*]] = waveamdmachine.token
// IR-NEXT: {{%.*}}, [[TOK1:%.*]] = waveamdmachine.global_load_b32
// IR-NEXT: {{%.*}} = waveamdmachine.s_barrier [[TOK1]]
// IR-NEXT: waveamdmachine.v_add_u32
// DIAG: waveamd-machine-schedule region func=barrier_keep
// DIAG-SAME: action=keep reason=not_better
// DIAG-SAME: filled_gaps=1
// DIAG-SAME: memory_token_gaps={{[1-9][0-9]*}}

// ERR: waveamd-machine-schedule unsupported option: beam-search
