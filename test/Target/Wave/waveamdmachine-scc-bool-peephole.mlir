// RUN: wave-opt --split-input-file --waveamd-elide-scc-bool-roundtrip %s | FileCheck %s --check-prefix=ELIDE
// RUN: wave-opt --split-input-file --waveamd-elide-scc-bool-roundtrip --waveamd-preserve-hw-regs %s | FileCheck %s --check-prefix=PRESERVE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ELIDE-LABEL: func.func @direct_select(
// ELIDE-SAME: [[X:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// ELIDE-SAME: [[Y:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// ELIDE-SAME: [[A:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// ELIDE-SAME: [[B:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// ELIDE: [[SCC:%.*]] = waveamdmachine.s_cmp_lt_i32 [[X]], [[Y]]
// ELIDE-NOT: waveamdmachine.s_cmp_lg_u32
// ELIDE: [[PICK:%.*]] = waveamdmachine.s_cselect_b32 [[SCC]], [[A]], [[B]]
// ELIDE: return [[PICK]]
// PRESERVE-LABEL: func.func @direct_select(
// PRESERVE: [[SCC:%.*]] = waveamdmachine.s_cmp_lt_i32
// PRESERVE-NOT: waveamdmachine.s_cmp_lg_u32
// PRESERVE: waveamdmachine.s_cselect_b32 [[SCC]]
func.func @direct_select(%x: !waveamdmachine.reg<sgpr, 1>,
                         %y: !waveamdmachine.reg<sgpr, 1>,
                         %a: !waveamdmachine.reg<sgpr, 1>,
                         %b: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 1> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %scc = waveamdmachine.s_cmp_lt_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<scc, 1>
  %bool = waveamdmachine.s_cselect_b32 %scc, %one, %zero
      : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.imm,
         !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %reload = waveamdmachine.s_cmp_lg_u32 %bool, %zero
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<scc, 1>
  %pick = waveamdmachine.s_cselect_b32 %reload, %a, %b
      : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  return %pick : !waveamdmachine.reg<sgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ELIDE-LABEL: func.func @clobbered_select(
// ELIDE: [[SCC:%.*]] = waveamdmachine.s_cmp_lt_i32
// ELIDE-NOT: waveamdmachine.s_cmp_lg_u32
// ELIDE: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32
// ELIDE: waveamdmachine.s_cselect_b32 [[SCC]], [[SUM]]
// PRESERVE-LABEL: func.func @clobbered_select(
// PRESERVE: [[SCC:%.*]] = waveamdmachine.s_cmp_lt_i32
// PRESERVE: [[SAVE:%.*]] = waveamdmachine.s_cselect_b32 [[SCC]]
// PRESERVE: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32
// PRESERVE: [[RELOAD:%.*]] = waveamdmachine.s_cmp_lg_u32 [[SAVE]]
// PRESERVE-NEXT: waveamdmachine.s_cselect_b32 [[RELOAD]], [[SUM]]
func.func @clobbered_select(%x: !waveamdmachine.reg<sgpr, 1>,
                            %y: !waveamdmachine.reg<sgpr, 1>,
                            %a: !waveamdmachine.reg<sgpr, 1>,
                            %b: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 1> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %scc = waveamdmachine.s_cmp_lt_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<scc, 1>
  %bool = waveamdmachine.s_cselect_b32 %scc, %one, %zero
      : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.imm,
         !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %sum, %sum_scc = waveamdmachine.s_add_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %reload = waveamdmachine.s_cmp_lg_u32 %bool, %zero
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<scc, 1>
  %pick = waveamdmachine.s_cselect_b32 %reload, %sum, %b
      : (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  return %pick : !waveamdmachine.reg<sgpr, 1>
}

}
