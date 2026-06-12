// RUN: wave-opt --waveamd-resource-info %s | FileCheck %s --check-prefix=INFO
// RUN: wave-opt --waveamd-resource-info %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// INFO: module attributes
// INFO-SAME: waveamdmachine.private_segment_fixed_size_max = 24 : i64
// INFO-LABEL: func.func @scratch_metadata
// INFO-SAME: waveamdmachine.private_segment_fixed_size = 24 : i64
// INFO-SAME: waveamdmachine.scratch_spill_bytes = 8 : i64

// ASM-LABEL: .amdhsa_kernel scratch_metadata
// ASM: .amdhsa_private_segment_fixed_size 24
// ASM: .amdhsa_enable_private_segment 1
// ASM: .set .Lscratch_metadata.private_seg_size, 24
func.func @scratch_metadata() attributes {
    wave.kernel,
    wave.private_segment_fixed_size = 16 : i64,
    waveamdmachine.scratch_spill_bytes = 8 : i64
  } {
  %off = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  waveamdmachine.s_endpgm
  return
}

// INFO-LABEL: func.func @scratch_metadata_machine
// INFO-SAME: waveamdmachine.private_segment_fixed_size = 24 : i64
// ASM-LABEL: .amdhsa_kernel scratch_metadata_machine
// ASM: .amdhsa_private_segment_fixed_size 24
// ASM: .private_segment_fixed_size: 24
func.func @scratch_metadata_machine() attributes {
    wave.kernel,
    waveamdmachine.private_segment_fixed_size = 24 : i64
  } {
  %off = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  waveamdmachine.s_endpgm
  return
}

}
