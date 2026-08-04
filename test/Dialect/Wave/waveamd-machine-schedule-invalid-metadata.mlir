// RUN: wave-opt %s --split-input-file \
// RUN:   --waveamd-machine-schedule='apply-schedule=1' --verify-diagnostics \
// RUN:   | FileCheck %s --check-prefix=VALID

module {
// expected-error @below {{waveamd-machine-schedule failed: reason=missing_target}}
func.func @missing_target() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "not-an-amdgpu-target"} {
// expected-error @below {{waveamd-machine-schedule failed: reason=malformed_target}}
func.func @malformed_target() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = 1 : i64} {
// expected-error @below {{waveamd-machine-schedule failed: reason=malformed_target}}
func.func @target_wrong_type() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx600"} {
// expected-error @below {{waveamd-machine-schedule failed: reason=unsupported_arch}}
func.func @unsupported_target_architecture() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.workgroup_size must be a dense i32 array}}
func.func @workgroup_shape_wrong_type()
    attributes {wave.workgroup_size = 64 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.workgroup_size must have one to three dimensions}}
func.func @workgroup_shape_empty()
    attributes {wave.workgroup_size = array<i32>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.workgroup_size must have one to three dimensions}}
func.func @workgroup_shape_rank_four()
    attributes {wave.workgroup_size = array<i32: 1, 1, 1, 1>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.workgroup_size dimensions must be positive}}
func.func @workgroup_shape_zero_dimension()
    attributes {wave.workgroup_size = array<i32: 64, 0, 1>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.workgroup_size dimensions must be positive}}
func.func @workgroup_shape_negative_dimension()
    attributes {wave.workgroup_size = array<i32: 64, -1, 1>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.workgroup_size product overflows uint64}}
func.func @workgroup_shape_product_overflow()
    attributes {wave.workgroup_size =
                    array<i32: 2147483647, 2147483647, 2147483647>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.workgroup_size exceeds target flat workgroup limit 1024}}
func.func @workgroup_shape_exceeds_target_limit()
    attributes {wave.workgroup_size = array<i32: 1025, 1, 1>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model conflicting workgroup shapes}}
func.func @conflicting_workgroup_shapes()
    attributes {gpu.known_block_size = array<i32: 32, 2, 1>,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.waves_per_workgroup must be an integer attribute}}
func.func @workgroup_waves_wrong_type()
    attributes {wave.waves_per_workgroup = "sixteen"} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.waves_per_workgroup must be positive}}
func.func @workgroup_waves_zero()
    attributes {wave.waves_per_workgroup = 0 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.waves_per_workgroup must be positive}}
func.func @workgroup_waves_negative()
    attributes {wave.waves_per_workgroup = -1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.waves_per_workgroup exceeds unsigned range}}
func.func @workgroup_waves_unsigned_overflow()
    attributes {wave.waves_per_workgroup = 4294967296 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.waves_per_workgroup exceeds target workgroup limit}}
func.func @workgroup_waves_exceeds_wave64_limit()
    attributes {wave.waves_per_workgroup = 17 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model wave.waves_per_workgroup conflicts with workgroup shape}}
func.func @workgroup_waves_conflict_with_shape()
    attributes {wave.waves_per_workgroup = 3 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {wave.waves_per_workgroup = 1 : i64,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model conflicting wave.waves_per_workgroup attributes}}
func.func @conflicting_workgroup_wave_attributes()
    attributes {wave.waves_per_workgroup = 2 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model waveamdmachine.target_waves must be an integer attribute}}
func.func @target_waves_wrong_type()
    attributes {waveamdmachine.target_waves = "one"} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model waveamdmachine.target_waves must be positive}}
func.func @target_waves_zero()
    attributes {waveamdmachine.target_waves = 0 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model waveamdmachine.target_waves must be positive}}
func.func @target_waves_negative()
    attributes {waveamdmachine.target_waves = -1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model waveamdmachine.target_waves exceeds unsigned range}}
func.func @target_waves_unsigned_overflow()
    attributes {waveamdmachine.target_waves = 4294967296 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// expected-error @below {{Wave AMD machine schedule model waveamdmachine.target_waves exceeds target wave capacity}}
func.func @target_waves_exceeds_gfx950_capacity()
    attributes {waveamdmachine.target_waves = 9 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950",
                   waveamdmachine.target_waves = 1 : i64} {
// expected-error @below {{Wave AMD machine schedule model conflicting waveamdmachine.target_waves attributes}}
func.func @conflicting_target_wave_attributes()
    attributes {waveamdmachine.target_waves = 2 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

// expected-error @below {{waveamd-machine-schedule waveamdmachine.wavefront_size must be an integer attribute}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950",
                   waveamdmachine.wavefront_size = "sixty-four"} {
func.func @wavefront_size_wrong_type() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

// expected-error @below {{waveamd-machine-schedule waveamdmachine.wavefront_size must be 32 or 64}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950",
                   waveamdmachine.wavefront_size = 16 : i64} {
func.func @wavefront_size_invalid_width() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

// expected-error @below {{waveamd-machine-schedule target gfx950 does not support wave32}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950",
                   waveamdmachine.wavefront_size = 32 : i64} {
func.func @wavefront_size_unsupported_by_target() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @true_absence_uses_target_wave_fallback(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token,
    %inc0: !waveamdmachine.reg<vgpr, 1>,
    %inc1: !waveamdmachine.reg<vgpr, 1>,
    %keep0: !waveamdmachine.reg<sgpr, 1>,
    %keep1: !waveamdmachine.reg<sgpr, 1>)
    attributes {waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 56 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 56>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %raised = waveamdmachine.v_add_u32 %inc0, %inc1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %neutral = waveamdmachine.s_cmp_eq_u32 %keep0, %keep1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %use0 = waveamdmachine.v_xor_b32 %raised, %inc0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_xor_b32 %use0, %inc1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %looped = waveamdmachine.uniform_loop if %neutral
      : !waveamdmachine.reg<scc, 1>
      carries(%wide : !waveamdmachine.reg<vgpr, 56>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 56>):
    waveamdmachine.continue_if %neutral : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 56>)
  } -> !waveamdmachine.reg<vgpr, 56>
  return
}

func.func @valid_gfx950_wave64_cohort_16(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token,
    %inc0: !waveamdmachine.reg<vgpr, 1>,
    %inc1: !waveamdmachine.reg<vgpr, 1>,
    %keep0: !waveamdmachine.reg<sgpr, 1>,
    %keep1: !waveamdmachine.reg<sgpr, 1>)
    attributes {gpu.known_block_size = array<i32: 1024, 1, 1>,
                wave.waves_per_workgroup = 16 : i64,
                wave.workgroup_size = array<i32: 1024>,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 56 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 56>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %raised = waveamdmachine.v_add_u32 %inc0, %inc1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %neutral = waveamdmachine.s_cmp_eq_u32 %keep0, %keep1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %use0 = waveamdmachine.v_xor_b32 %raised, %inc0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_xor_b32 %use0, %inc1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %looped = waveamdmachine.uniform_loop if %neutral
      : !waveamdmachine.reg<scc, 1>
      carries(%wide : !waveamdmachine.reg<vgpr, 56>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 56>):
    waveamdmachine.continue_if %neutral : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 56>)
  } -> !waveamdmachine.reg<vgpr, 56>
  return
}

func.func @valid_explicit_only_gfx950_wave64_cohort_16()
    attributes {wave.waves_per_workgroup = 16 : ui5,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}

func.func @valid_unsigned_target_wave_capacity()
    attributes {waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 8 : ui4} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  return
}
}

// VALID-LABEL: func.func @true_absence_uses_target_wave_fallback
// VALID: [[ABSENT_M0:%.*]] = waveamdmachine.s_mov_m0
// VALID-NEXT: [[ABSENT_RAISED:%.*]] = waveamdmachine.v_add_u32

// VALID-LABEL: func.func @valid_gfx950_wave64_cohort_16
// VALID: [[COHORT_M0:%.*]] = waveamdmachine.s_mov_m0
// VALID-NEXT: [[COHORT_NEUTRAL:%.*]] = waveamdmachine.s_cmp_eq_u32
// VALID-NOT: waveamdmachine.v_add_u32
// VALID: waveamdmachine.global_load_lds_b32

// VALID-LABEL: func.func @valid_explicit_only_gfx950_wave64_cohort_16
// VALID: waveamdmachine.imm

// VALID-LABEL: func.func @valid_unsigned_target_wave_capacity
// VALID: waveamdmachine.imm
