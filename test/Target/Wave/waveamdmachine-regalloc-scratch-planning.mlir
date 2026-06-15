// RUN: rm -rf %t && split-file %s %t
// RUN: wave-opt --waveamd-reg-alloc --remarks-filter=waveamdmachine-regalloc \
// RUN:   --remark-policy=all --remark-format=yaml --remarks-output-file=%t/gfx950.yaml \
// RUN:   %t/gfx950.mlir >/dev/null
// RUN: FileCheck %s --input-file=%t/gfx950.yaml --check-prefix=GFX950
// RUN: wave-opt --waveamd-reg-alloc --remarks-filter=waveamdmachine-regalloc \
// RUN:   --remark-policy=all --remark-format=yaml --remarks-output-file=%t/gfx900.yaml \
// RUN:   %t/gfx900.mlir >/dev/null
// RUN: FileCheck %s --input-file=%t/gfx900.yaml --check-prefix=GFX900
// RUN: wave-opt --waveamd-reg-alloc --remarks-filter=waveamdmachine-regalloc \
// RUN:   --remark-policy=all --remark-format=yaml --remarks-output-file=%t/gfx1200.yaml \
// RUN:   %t/gfx1200.mlir >/dev/null
// RUN: FileCheck %s --input-file=%t/gfx1200.yaml --check-prefix=GFX1200

//--- gfx950.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // GFX950: Name:            regalloc-scratch-plan
  // GFX950: Function:        scratch_plan_available
  // GFX950: existing_private_bytes: '16'
  // GFX950: reserved_spill_bytes: '4'
  // GFX950: status:          available
  // GFX950: uses_flat_scratch: 'true'
  // GFX950: value_bytes:     '4'
  // GFX950: slot_base:       '20'
  // GFX950: slot_bytes:      '4'
  func.func @scratch_plan_available() attributes {
    wave.kernel,
    waveamdmachine.private_segment_fixed_size = 20 : i64,
    waveamdmachine.scratch_spill_bytes = 4 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }

  // GFX950: Name:            regalloc-scratch-plan
  // GFX950: Function:        scratch_plan_wave_private_segment
  // GFX950: existing_private_bytes: '16'
  // GFX950: reserved_spill_bytes: '4'
  // GFX950: status:          available
  // GFX950: slot_base:       '20'
  // GFX950: slot_bytes:      '4'
  func.func @scratch_plan_wave_private_segment() attributes {
    wave.kernel,
    wave.private_segment_fixed_size = 16 : i64,
    waveamdmachine.scratch_spill_bytes = 4 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}

//--- gfx1200.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1200"} {
  // GFX1200: Name:            regalloc-scratch-plan
  // GFX1200: Function:        scratch_plan_available
  // GFX1200: existing_private_bytes: '16'
  // GFX1200: reserved_spill_bytes: '4'
  // GFX1200: status:          available
  // GFX1200: uses_flat_scratch: 'true'
  // GFX1200: value_bytes:     '4'
  // GFX1200: slot_base:       '20'
  // GFX1200: slot_bytes:      '4'
  func.func @scratch_plan_available() attributes {
    wave.kernel,
    waveamdmachine.private_segment_fixed_size = 20 : i64,
    waveamdmachine.scratch_spill_bytes = 4 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}

//--- gfx900.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx900"} {
  // GFX900: Name:            regalloc-scratch-plan
  // GFX900: Function:        scratch_plan_unsupported_target
  // GFX900: status:          unsupported_target
  func.func @scratch_plan_unsupported_target() attributes {
    wave.kernel,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}
