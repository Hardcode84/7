// RUN: wave-opt --waveamd-insert-hazard-waits -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-hazard-waits -split-input-file %s \
// RUN:   | wave-opt --waveamd-insert-hazard-waits -split-input-file \
// RUN:   | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @low_base_write_waits
// CHECK: waveamdmachine.s_mov_b32 "s102"
// CHECK-NEXT: waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
// CHECK-NEXT: waveamdmachine.scratch_load_b32
func.func @low_base_write_waits() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s102", %zero
      : (!waveamdmachine.imm) -> ()
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @high_base_write_waits
// CHECK: waveamdmachine.s_mov_b32 "s103"
// CHECK-NEXT: waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
// CHECK-NEXT: waveamdmachine.scratch_load_b32
func.func @high_base_write_waits() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s103", %zero
      : (!waveamdmachine.imm) -> ()
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @scalar_without_sgpr_def_does_not_age
// CHECK: waveamdmachine.s_mov_b32 "s102"
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
// CHECK-NEXT: waveamdmachine.scratch_load_b32
func.func @scalar_without_sgpr_def_does_not_age() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s102", %zero
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @nine_salu_sgpr_defs_still_wait
// CHECK: waveamdmachine.s_mov_b32 "s8"
// CHECK-NEXT: waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
// CHECK-NEXT: waveamdmachine.scratch_load_b32
func.func @nine_salu_sgpr_defs_still_wait() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s102", %zero
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s0", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s1", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s2", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s3", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s4", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s5", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s6", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s7", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s8", %zero : (!waveamdmachine.imm) -> ()
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @ten_salu_sgpr_defs_expire
// CHECK-NOT: waveamdmachine.s_wait_alu
// CHECK: return
func.func @ten_salu_sgpr_defs_expire() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s102", %zero
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s0", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s1", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s2", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s3", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s4", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s5", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s6", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s7", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s8", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s9", %zero : (!waveamdmachine.imm) -> ()
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @valu_sgpr_def_counts
// CHECK-NOT: waveamdmachine.s_wait_alu
// CHECK: return
func.func @valu_sgpr_def_counts(
    %v: !waveamdmachine.reg<vgpr, 1, 4>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s102", %zero
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s0", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s1", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s2", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s3", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s4", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s5", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s6", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s7", %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_mov_b32 "s8", %zero : (!waveamdmachine.imm) -> ()
  %lane = waveamdmachine.v_readfirstlane_b32 %v
      : (!waveamdmachine.reg<vgpr, 1, 4>)
      -> !waveamdmachine.reg<sgpr, 1, 20>
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @full_scalar_depctr_wait_clears
// CHECK: waveamdmachine.s_mov_b32 "s102"
// CHECK-NEXT: waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
// CHECK-NEXT: waveamdmachine.scratch_load_b32
// CHECK-NOT: waveamdmachine.s_wait_alu
// CHECK: return
func.func @full_scalar_depctr_wait_clears() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s102", %zero
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  return
}

// CHECK-LABEL: func.func @scratch_hazard_survives_join
// CHECK: cf.cond_br
// CHECK: ^bb{{[0-9]+}}:
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
// CHECK-NEXT: waveamdmachine.scratch_load_b32
// CHECK: waveamdmachine.s_mov_b32 "s102"
// CHECK-NEXT: cf.br
func.func @scratch_hazard_survives_join(%cond: i1) {
  cf.cond_br %cond, ^write, ^join
^join:
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  return
^write:
  %source = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s102", %source
      : (!waveamdmachine.imm) -> ()
  cf.br ^join
}

// CHECK-LABEL: func.func @scratch_hazard_survives_backedge
// CHECK: cf.br
// CHECK: ^bb{{[0-9]+}}:
// CHECK-NEXT: waveamdmachine.imm 0
// CHECK-NEXT: waveamdmachine.s_wait_alu sa_sdst(0) va_sdst(0)
// CHECK-NEXT: waveamdmachine.scratch_load_b32
// CHECK: waveamdmachine.s_mov_b32 "s102"
// CHECK-NEXT: cf.br
func.func @scratch_hazard_survives_backedge(%cond: i1) {
  cf.br ^loop
^loop:
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value, %token = waveamdmachine.scratch_load_b32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
  cf.cond_br %cond, ^exit, ^write
^write:
  %source = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.s_mov_b32 "s102", %source
      : (!waveamdmachine.imm) -> ()
  cf.br ^loop
^exit:
  return
}

}
