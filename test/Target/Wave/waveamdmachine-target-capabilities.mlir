// RUN: wave-target-info gfx1250 | FileCheck %s --check-prefix=GFX1250
// RUN: wave-target-info gfx1251 | FileCheck %s --check-prefix=GFX1251
// RUN: not wave-target-info gfx12-5-generic 2>&1 | FileCheck %s --check-prefix=GENERIC

// GFX1250: isa: 12.5.0
// GFX1250-NEXT: default_wavefront_size: 32
// GFX1250-NEXT: supports_wave32: true
// GFX1250-NEXT: supports_wave64: false
// GFX1250-NEXT: addressable_sgprs: 106
// GFX1250-NEXT: addressable_vgprs: 1024
// GFX1250-NEXT: addressable_agprs: 0
// GFX1250-NEXT: vgpr_allocation_granule: 16
// GFX1250-NEXT: vgpr_tuple_alignment: 2
// GFX1250-NEXT: local_memory_bytes: 327680
// GFX1250-NEXT: addressable_local_memory_bytes: 327680
// GFX1250-NEXT: local_memory_banks: 32
// GFX1250-NEXT: max_waves_per_eu: 16
// GFX1250-NEXT: max_user_sgprs: 32
// GFX1250-NEXT: buffer_resource_base_bits: 57
// GFX1250-NEXT: buffer_resource_num_records_bits: 45
// GFX1250-NEXT: wait_counter_family: gfx12_split
// GFX1250-NEXT: matrix_family: gfx1250
// GFX1250-NEXT: architected_flat_scratch: true
// GFX1250-NEXT: architected_sgprs: true
// GFX1250-NEXT: clusters: true
// GFX1250-NEXT: kernarg_preload: true
// GFX1250-NEXT: requires_initial_unclaused_vmem: true
// GFX1250-NEXT: wait_xcnt: true
// GFX1250-NEXT: vgpr_windowing: true
// GFX1250-NEXT: setreg_vgpr_msb_fixup: true
// GFX1250-NEXT: descriptor_dx10_ieee: false
// GFX1250-NEXT: descriptor_wgp_mode: false
// GFX1250-NEXT: descriptor_shared_vgpr_count: false
// GFX1250-NEXT: descriptor_round_robin: true
// GFX1250-NEXT: descriptor_named_barrier_count: true
// GFX1250-NEXT: descriptor_architected_private_segment: true

// GFX1251: isa: 12.5.1
// GFX1251-NEXT: default_wavefront_size: 32
// GFX1251-NEXT: supports_wave32: true
// GFX1251-NEXT: supports_wave64: false
// GFX1251-NEXT: addressable_sgprs: 106
// GFX1251-NEXT: addressable_vgprs: 1024
// GFX1251-NEXT: addressable_agprs: 0
// GFX1251-NEXT: vgpr_allocation_granule: 16
// GFX1251-NEXT: vgpr_tuple_alignment: 2
// GFX1251-NEXT: local_memory_bytes: 327680
// GFX1251-NEXT: addressable_local_memory_bytes: 327680
// GFX1251-NEXT: local_memory_banks: 32
// GFX1251-NEXT: max_waves_per_eu: 16
// GFX1251-NEXT: max_user_sgprs: 32
// GFX1251-NEXT: buffer_resource_base_bits: 57
// GFX1251-NEXT: buffer_resource_num_records_bits: 45
// GFX1251-NEXT: wait_counter_family: gfx12_split
// GFX1251-NEXT: matrix_family: gfx1251
// GFX1251-NEXT: architected_flat_scratch: true
// GFX1251-NEXT: architected_sgprs: true
// GFX1251-NEXT: clusters: true
// GFX1251-NEXT: kernarg_preload: true
// GFX1251-NEXT: requires_initial_unclaused_vmem: true
// GFX1251-NEXT: wait_xcnt: true
// GFX1251-NEXT: vgpr_windowing: true
// GFX1251-NEXT: setreg_vgpr_msb_fixup: false
// GFX1251-NEXT: descriptor_dx10_ieee: false
// GFX1251-NEXT: descriptor_wgp_mode: false
// GFX1251-NEXT: descriptor_shared_vgpr_count: false
// GFX1251-NEXT: descriptor_round_robin: true
// GFX1251-NEXT: descriptor_named_barrier_count: true
// GFX1251-NEXT: descriptor_architected_private_segment: true

// GENERIC: no Wave capability contract for target: gfx12-5-generic
