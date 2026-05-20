// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s

// Black-box coverage of the gap-walking allocator's behaviour.
// Each test exercises one or two specific algorithmic properties
// (alignment in reclaimed holes, tie-breaks, multi-expiry, class
// isolation, ...) with the smallest IR that discriminates the
// correct answer from a plausible bug.

// =============================================================
// 1. Width-3 lands at the next 4-aligned slot, not at the freshly
// vacated v1 slot. The gap walker must round up inside reclaimed
// holes, not just at the front of the register file.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @width3_in_gap_skips_to_aligned_base
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 3 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 3, 8>
func.func @width3_in_gap_skips_to_aligned_base() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %lo  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f1  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f2  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f3  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  // %f1, %f2, %f3 die here, freeing v1..v3.
  %d1  = waveamdmachine.v_mov_b32_tuple %f1   {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %d2  = waveamdmachine.v_mov_b32_tuple %f2   {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %d3  = waveamdmachine.v_mov_b32_tuple %f3   {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // Now v0 and v4 are occupied (long-lived), v1..v3 free. A width-3
  // request with alignment 4 cannot land at v1; v4 is taken; next
  // 4-aligned candidate is v8.
  %t   = waveamdmachine.v_mov_b32_tuple %zero {registers = 3 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 3>
  %slo = waveamdmachine.v_mov_b32_tuple %lo   {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %shi = waveamdmachine.v_mov_b32_tuple %hi   {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// =============================================================
// 2. Width-5 requires 8-alignment (VReg_160). With v0 occupied by a
// width-1, the next legal base is v8 -- not v1 (1-aligned), not v3
// (5-aligned but not 8-aligned).
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @width5_after_width1_skips_to_v8
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 5 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 5, 8>
func.func @width5_after_width1_skips_to_v8() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %lo  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t   = waveamdmachine.v_mov_b32_tuple %zero {registers = 5 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 5>
  %slo = waveamdmachine.v_mov_b32_tuple %lo   {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// =============================================================
// 3. Widths 6 and 7 both round up to 8-alignment. Two sequential
// dead intervals must both land at v0 (the earlier expires before
// the later is born). Catches an alignment-ladder miscalculation.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @width6_and_width7_share_v0
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 6 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 6, 0>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 7 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 7, 0>
func.func @width6_and_width7_share_v0() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 6 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 6>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 7 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 7>
  return
}

}

// -----

// =============================================================
// 4. First-fit tie-break: when two equal-sized holes are available,
// the allocator must pick the lower-indexed one. Catches a
// most-recently-vacated or high-end preference.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @first_fit_picks_lower_hole
// At %target's birth, %h1 and %h2 have expired -- so have their
// kill-sinks %k1 (v5) and %k2 (v1) -- leaving holes at v1 (k2
// vacated) and v3 (h2 vacated) below the live tail. Greedy
// first-fit picks v1, the lower hole.
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 0>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 1>
// CHECK: %[[B:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 2>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 3>
// CHECK: %[[C:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 4>
// CHECK: %[[K1:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 5>
// CHECK: %[[K2:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 1>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 1>
func.func @first_fit_picks_lower_hole() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %h1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %h2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c  = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  // Kill %h1 and %h2 so they free their slots before %target.
  %k1 = waveamdmachine.v_mov_b32_tuple %h1 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %k2 = waveamdmachine.v_mov_b32_tuple %h2 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %target = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %sa = waveamdmachine.v_mov_b32_tuple %a {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sb = waveamdmachine.v_mov_b32_tuple %b {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sc = waveamdmachine.v_mov_b32_tuple %c {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// =============================================================
// 5. Width-8 alignment is determined by the new interval's own
// width, not by the running cursor. With a width-3 long-lived at
// v0, a width-8 cannot land at v4 (which would be 4-aligned only)
// and must skip to v8.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @width8_alignment_independent_of_neighbor
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 8 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8, 8>
func.func @width8_alignment_independent_of_neighbor() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 3 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 3>
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %sa = waveamdmachine.v_mov_b32_tuple %a {registers = 3 : i64} : (!waveamdmachine.reg<vgpr, 3>) -> !waveamdmachine.reg<vgpr, 3>
  return
}

}

// -----

// =============================================================
// 6. Multi-expiry: two width-1 intervals dying at the same
// program point both free their slots before the next allocation.
// A width-2 born right after must land at v0.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @two_dying_same_position_reclaimed
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 2 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2, 0>
func.func @two_dying_same_position_reclaimed() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %f1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  // Both die here at the next two ops.
  %k1 = waveamdmachine.v_mov_b32_tuple %f1 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %k2 = waveamdmachine.v_mov_b32_tuple %f2 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %t  = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  return
}

}

// -----

// =============================================================
// 7. A long-lived blocker at v0 must not cause subsequent width-1
// allocations to monotonically climb. Each dead width-1 returns to
// v1 (the lowest free slot), and a chain of them never reaches v2.
// Catches an allocator that maintains a "free cursor" instead of
// rescanning gaps.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @long_blocker_no_monotonic_cursor
// CHECK: %[[B:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 0>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 1>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 1>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 1>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, 1>
func.func @long_blocker_no_monotonic_cursor() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %blocker = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  // Each of these dies before the next is born; the allocator must
  // keep returning to v1 instead of climbing v1 -> v2 -> v3.
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %sblock = waveamdmachine.v_mov_b32_tuple %blocker {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// =============================================================
// 8. SGPR kernel preload reserves five registers (s0..s4). The
// first allocatable SGPR is s5, not s0. Mirrors the v0 reservation
// on the VGPR side but with a wider prefix.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @sgpr_kernel_reserves_first_five
// CHECK: %{{.+}} = waveamdmachine.s_mov_b32_tuple {{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 5>
func.func @sgpr_kernel_reserves_first_five() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s = waveamdmachine.s_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

// =============================================================
// 9. SGPR and VGPR are allocated independently. A width-3 VGPR
// going to v4 (post-v0 reservation, 4-aligned) and a width-2 SGPR
// going to s6 (first 2-aligned slot after the 5-SGPR reservation)
// must not influence each other.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @sgpr_vgpr_classes_isolated
// CHECK: %{{.+}} = waveamdmachine.s_mov_b32_tuple {{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2, 6>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 3 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 3, 4>
func.func @sgpr_vgpr_classes_isolated() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s = waveamdmachine.s_mov_b32_tuple %zero {registers = 2 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %v = waveamdmachine.v_mov_b32_tuple %zero {registers = 3 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 3>
  return
}

}

// -----

// =============================================================
// 10. Reserved prefix is permanent. Even after every real
// allocation dies, the reserved slots stay blocked: a late width-1
// reuses v1, never v0.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @reserved_v0_persists_past_expiry
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 1>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} : (!waveamdmachine.reg<vgpr, 1, 1>) -> !waveamdmachine.reg<vgpr, 1, 2>
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 1>
func.func @reserved_v0_persists_past_expiry() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %ka = waveamdmachine.v_mov_b32_tuple %a   {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // %a is dead now. A late width-1 must NOT land at v0.
  %late = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// =============================================================
// 11. Gap exists but is too narrow once alignment kicks in. With
// width-1 at v0 and width-1 at v4 long-lived, a width-4 request
// must land at v8 -- v1..v3 is too narrow for width 4 anyway, and
// v4 is occupied; the next 4-aligned slot is v8.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @gap_too_small_for_width
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 8>
func.func @gap_too_small_for_width() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %f3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %k1 = waveamdmachine.v_mov_b32_tuple %f1 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %k2 = waveamdmachine.v_mov_b32_tuple %f2 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %k3 = waveamdmachine.v_mov_b32_tuple %f3 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %sa = waveamdmachine.v_mov_b32_tuple %a {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sb = waveamdmachine.v_mov_b32_tuple %b {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

// =============================================================
// 12. Exact tail fit: a width-4 tuple landing at the very last
// 4-VGPR slot (gfx1100 has 256 VGPRs, so the legal tail is v252).
// Catches an off-by-one rejecting the legal boundary slot, and a
// silent wrap producing phys >= numPhys.
//
// Builds the dense prefix with one width-128 + one width-124 tuple,
// then asks for a width-4 -- the only remaining 4-aligned slot is
// v252.
// =============================================================
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @exact_fit_at_register_file_tail
// CHECK: %{{.+}} = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 252>
func.func @exact_fit_at_register_file_tail() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %big1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 128 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 128>
  %big2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 124 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 124>
  %t    = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}   : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  // Width-1 sinks just extend big1 / big2 across %t's birth without
  // requesting another wide block themselves.
  %s1 = waveamdmachine.v_mov_b32_tuple %big1 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 128>) -> !waveamdmachine.reg<vgpr, 1>
  %s2 = waveamdmachine.v_mov_b32_tuple %big2 {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 124>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
