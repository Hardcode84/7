// RUN: rm -rf %t && split-file %s %t
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=15 agpr-limit=0' \
// RUN:   --waveamd-resource-info %t/result-use.mlir | FileCheck %s --check-prefix=RESULT
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=15 agpr-limit=0' \
// RUN:   --waveamd-resource-info %t/preheader-use.mlir | FileCheck %s --check-prefix=PRE
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=15 agpr-limit=0' \
// RUN:   --waveamd-resource-info %t/body-use.mlir | FileCheck %s --check-prefix=BODY
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=15 agpr-limit=0' \
// RUN:   --waveamd-resource-info %t/updated-backedge.mlir | FileCheck %s --check-prefix=UPDATE
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=4 agpr-limit=0' \
// RUN:   %t/two-carries.mlir | FileCheck %s --check-prefix=TWO
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=15 agpr-limit=0' \
// RUN:   --waveamd-resource-info %t/nested.mlir | FileCheck %s --check-prefix=NEST
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=15 agpr-limit=0' \
// RUN:   --waveamd-resource-info %t/nested-preheader-use.mlir | FileCheck %s --check-prefix=NESTPRE
// RUN: not wave-opt --waveamd-reg-alloc='vgpr-limit=15 agpr-limit=0' \
// RUN:   %t/bad-init-use.mlir 2>&1 | FileCheck %s --check-prefix=BAD
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=23 agpr-limit=0' \
// RUN:   --waveamd-resource-info %t/bad-init-use-fallback.mlir | FileCheck %s --check-prefix=FALLBACK
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=7 agpr-limit=0' \
// RUN:   --waveamd-resource-info %t/immediate-boundary.mlir | FileCheck %s --check-prefix=BOUNDARY
// RUN: not wave-opt --waveamd-reg-alloc='vgpr-limit=4 agpr-limit=0' \
// RUN:   %t/scalar-reject.mlir 2>&1 | FileCheck %s --check-prefix=SCALAR

//--- result-use.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// RESULT-LABEL: func.func @scratch_loop_carry_result_use
// RESULT-SAME: waveamdmachine.scratch_spill_bytes = 32 : i64
// RESULT: %[[STORE:.*]] = waveamdmachine.scratch_store_tuple_b32
// RESULT: %[[LOOP:.*]] = waveamdmachine.uniform_loop {{.*}}carries(%[[STORE]] : !waveamdmachine.mem.token)
// RESULT: %[[LOAD:.*]], {{.*}} = waveamdmachine.scratch_load_tuple_b32 {{.*}} after %[[LOOP]]
// RESULT: waveamdmachine.tuple_to_elements %[[LOAD]]
func.func @scratch_loop_carry_result_use()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %parts:8 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  %result_parts:8 = waveamdmachine.tuple_to_elements %loop
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  waveamdmachine.s_endpgm
  return
}

}

//--- scalar-reject.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SCALAR: error: waveamd-reg-alloc ran out of VGPR registers
// SCALAR: memory spill cannot materialize loop-carried values
// SCALAR: memory spill reject detail: loop_carry=1
func.func @scalar_vgpr_loop_carry_no_memory_spill()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 1>):
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_mov_b32_tuple %loop {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %parts:4 = waveamdmachine.tuple_to_elements %tmp
      : (!waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  waveamdmachine.s_endpgm
  return
}

}

//--- preheader-use.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// PRE-LABEL: func.func @scratch_loop_carry_preheader_init_use
// PRE-SAME: waveamdmachine.scratch_spill_bytes = 32 : i64
// PRE: %[[STORE:.*]] = waveamdmachine.scratch_store_tuple_b32
// PRE: %[[PRELOAD:.*]], {{.*}} = waveamdmachine.scratch_load_tuple_b32 {{.*}} after %[[STORE]]
// PRE: waveamdmachine.tuple_to_elements %[[PRELOAD]]
// PRE: waveamdmachine.uniform_loop {{.*}}carries(%[[STORE]] : !waveamdmachine.mem.token)
func.func @scratch_loop_carry_preheader_init_use()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %init_parts:8 = waveamdmachine.tuple_to_elements %acc
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %parts:8 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  waveamdmachine.s_endpgm
  return
}

}

//--- body-use.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// BODY-LABEL: func.func @scratch_loop_carry_body_use
// BODY-SAME: waveamdmachine.scratch_spill_bytes = 32 : i64
// BODY: %[[STORE:.*]] = waveamdmachine.scratch_store_tuple_b32
// BODY: waveamdmachine.uniform_loop {{.*}}carries(%[[STORE]] : !waveamdmachine.mem.token)
// BODY: ^bb0(%[[TOKEN:.*]]: !waveamdmachine.mem.token):
// BODY: %[[RELOAD:.*]], %[[NEXT_TOKEN:.*]] = waveamdmachine.scratch_load_tuple_b32 {{.*}} after %[[TOKEN]]
// BODY: waveamdmachine.tuple_to_elements %[[RELOAD]]
// BODY: waveamdmachine.continue_if {{.*}}carries(%[[NEXT_TOKEN]] : !waveamdmachine.mem.token)
func.func @scratch_loop_carry_body_use()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
    %carry_parts:8 = waveamdmachine.tuple_to_elements %carry
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %parts:8 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  waveamdmachine.s_endpgm
  return
}

}

//--- updated-backedge.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// UPDATE-LABEL: func.func @scratch_loop_carry_updated_backedge
// UPDATE-SAME: waveamdmachine.scratch_spill_bytes = 32 : i64
// UPDATE: %[[STORE:.*]] = waveamdmachine.scratch_store_tuple_b32
// UPDATE: waveamdmachine.uniform_loop {{.*}}carries(%[[STORE]] : !waveamdmachine.mem.token)
// UPDATE: ^bb0(%{{.*}}: !waveamdmachine.mem.token):
// UPDATE: %{{.*}}, %[[TOKEN:.*]] = waveamdmachine.scratch_load_tuple_b32
// UPDATE: %[[UPDATED:.*]] = waveamdmachine.tuple_from_elements
// UPDATE: %[[BACKEDGE:.*]] = waveamdmachine.scratch_store_tuple_b32 {{.*}}, %[[UPDATED]], {{.*}} after %[[TOKEN]]
// UPDATE: waveamdmachine.continue_if {{.*}}carries(%[[BACKEDGE]] : !waveamdmachine.mem.token)
func.func @scratch_loop_carry_updated_backedge()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
    %carry_parts:8 = waveamdmachine.tuple_to_elements %carry
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %parts:8 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %updated = waveamdmachine.tuple_from_elements
        %carry_parts#0, %carry_parts#1, %carry_parts#2, %carry_parts#3,
        %parts#4, %parts#5, %parts#6, %parts#7
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 8>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%updated : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  waveamdmachine.s_endpgm
  return
}

}

//--- two-carries.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// TWO-LABEL: func.func @scratch_loop_carry_two_carries
// TWO-SAME: waveamdmachine.scratch_spill_bytes = 16 : i64
// TWO: waveamdmachine.scratch_store_tuple_b32
// TWO-NOT: waveamdmachine.scratch_store_tuple_b32 {{.*}} offset 16
// TWO: waveamdmachine.uniform_loop {{.*}}carries(%{{.*}}, %{{.*}} : !waveamdmachine.reg<vgpr, 4, 0>, !waveamdmachine.mem.token)
func.func @scratch_loop_carry_two_carries()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %acc1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %loop:2 = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc0, %acc1 : !waveamdmachine.reg<vgpr, 4>,
                              !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%carry0: !waveamdmachine.reg<vgpr, 4>,
       %carry1: !waveamdmachine.reg<vgpr, 4>):
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry0, %carry1 : !waveamdmachine.reg<vgpr, 4>,
                                  !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>
  waveamdmachine.s_endpgm
  return
}

}

//--- nested.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// NEST-LABEL: func.func @scratch_loop_carry_nested
// NEST-SAME: waveamdmachine.scratch_spill_bytes = 64 : i64
// NEST: %[[OUTER_STORE:.*]] = waveamdmachine.scratch_store_tuple_b32
// NEST: waveamdmachine.uniform_loop {{.*}}carries(%[[OUTER_STORE]] : !waveamdmachine.mem.token)
// NEST: %[[INNER_STORE:.*]] = waveamdmachine.scratch_store_tuple_b32 {{.*}} offset 32
// NEST: waveamdmachine.uniform_loop {{.*}}carries(%[[INNER_STORE]] : !waveamdmachine.mem.token)
func.func @scratch_loop_carry_nested()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %outer_init = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %outer = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%outer_init : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%outer_carry: !waveamdmachine.reg<vgpr, 8>):
    %outer_tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %outer_parts:8 = waveamdmachine.tuple_to_elements %outer_tmp
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %inner_init = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %inner = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
        carries(%inner_init : !waveamdmachine.reg<vgpr, 8>) {
    ^bb0(%inner_carry: !waveamdmachine.reg<vgpr, 8>):
      %inner_tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
      %inner_parts:8 = waveamdmachine.tuple_to_elements %inner_tmp
          : (!waveamdmachine.reg<vgpr, 8>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%inner_carry : !waveamdmachine.reg<vgpr, 8>)
    } -> !waveamdmachine.reg<vgpr, 8>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%outer_carry : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  waveamdmachine.s_endpgm
  return
}

}

//--- nested-preheader-use.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// NESTPRE-LABEL: func.func @scratch_loop_carry_nested_preheader_init_use
// NESTPRE-SAME: waveamdmachine.scratch_spill_bytes = 32 : i64
// NESTPRE: waveamdmachine.uniform_if
// NESTPRE: %[[STORE:.*]] = waveamdmachine.scratch_store_tuple_b32
// NESTPRE: %[[PRELOAD:.*]], {{.*}} = waveamdmachine.scratch_load_tuple_b32 {{.*}} after %[[STORE]]
// NESTPRE: waveamdmachine.tuple_to_elements %[[PRELOAD]]
// NESTPRE: waveamdmachine.uniform_loop {{.*}}carries(%[[STORE]] : !waveamdmachine.mem.token)
func.func @scratch_loop_carry_nested_preheader_init_use()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  waveamdmachine.uniform_if %cond {
    %init_parts:8 = waveamdmachine.tuple_to_elements %acc
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
        carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
      %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
      %parts:8 = waveamdmachine.tuple_to_elements %tmp
          : (!waveamdmachine.reg<vgpr, 8>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 8>)
    } -> !waveamdmachine.reg<vgpr, 8>
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_endpgm
  return
}

}

//--- bad-init-use.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// BAD-NOT: cannot materialize scratch spill for loop init use outside loop preheader
// BAD: error: waveamd-reg-alloc ran out of VGPR registers
// BAD: memory spill cannot materialize loop-carried values
func.func @scratch_loop_carry_bad_init_use()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %parts:8 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  %init_parts:8 = waveamdmachine.tuple_to_elements %acc
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  waveamdmachine.s_endpgm
  return
}

}

//--- bad-init-use-fallback.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// FALLBACK-LABEL: func.func @scratch_loop_carry_bad_init_use_fallback
// FALLBACK-SAME: waveamdmachine.scratch_spill_bytes = 32 : i64
// FALLBACK: waveamdmachine.scratch_store_tuple_b32
// FALLBACK: waveamdmachine.uniform_loop
// FALLBACK: waveamdmachine.scratch_load_tuple_b32
func.func @scratch_loop_carry_bad_init_use_fallback()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %spill = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 8>):
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %parts:8 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 8>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<vgpr, 8>
  %init_parts:8 = waveamdmachine.tuple_to_elements %acc
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %spill_parts:8 = waveamdmachine.tuple_to_elements %spill
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  waveamdmachine.s_endpgm
  return
}

}

//--- immediate-boundary.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// BOUNDARY-LABEL: func.func @scratch_loop_carry_immediate_boundary
// BOUNDARY-SAME: waveamdmachine.private_segment_fixed_size = 4108 : i64
// BOUNDARY-SAME: waveamdmachine.scratch_spill_bytes = 16 : i64
// BOUNDARY-NOT: scratch_store_tuple_b32
// BOUNDARY: waveamdmachine.scratch_store_b32 {{.*}} offset 4092
// BOUNDARY: waveamdmachine.imm 4096
// BOUNDARY: waveamdmachine.scratch_store_b32
// BOUNDARY: waveamdmachine.imm 4100
// BOUNDARY: waveamdmachine.scratch_store_b32
// BOUNDARY: waveamdmachine.imm 4104
// BOUNDARY: waveamdmachine.scratch_store_b32
// BOUNDARY: waveamdmachine.uniform_loop
// BOUNDARY-NOT: scratch_load_tuple_b32
// BOUNDARY: waveamdmachine.scratch_load_b32 {{.*}} offset 4092
func.func @scratch_loop_carry_immediate_boundary()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64,
                waveamdmachine.private_segment_fixed_size = 4092 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%acc : !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 4>):
    %tmp = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %parts:4 = waveamdmachine.tuple_to_elements %tmp
        : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>
  %result_parts:4 = waveamdmachine.tuple_to_elements %loop
      : (!waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  waveamdmachine.s_endpgm
  return
}

}
