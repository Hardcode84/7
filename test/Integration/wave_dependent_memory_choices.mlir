// RUN: wave-opt %s --waveamd-to-machine --waveamd-abi-lowering --waveamd-buffer-rsrc-to-tuples -o %t.selected
// RUN: wave-opt %t.selected --waveamd-expand-materialization-variants -o %t.parallel
// RUN: wave-opt %t.selected --mlir-disable-threading --waveamd-expand-materialization-variants -o %t.serial
// RUN: diff %t.parallel %t.serial
// RUN: FileCheck %s --check-prefix=EXPAND --implicit-check-not=waveamdmachine.buffer_ --implicit-check-not=waveamdmachine.materialization_variants < %t.parallel
// RUN: wave-opt %t.parallel --pass-pipeline='builtin.module(func.func(waveamdmachine.materialization_candidates(remove-dead-values,cse,canonicalize)),waveamd-machine-schedule{apply-schedule},waveamd-collapse-materialization-variants)' -o %t.winner
// RUN: FileCheck %s --check-prefix=WINNER --implicit-check-not=waveamdmachine.buffer_ --implicit-check-not=waveamdmachine.materialization --implicit-check-not=waveamdmachine.candidate_yield < %t.winner
// RUN: wave-translate %t.winner --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o /dev/null

// EXPAND-LABEL: func.func @dependent_memory_choices
// EXPAND: waveamdmachine.materialization_candidates
// EXPAND: waveamdmachine.uniform_loop
// EXPAND: [[A:%.*]] = waveamdmachine.v_mul_lo_u32
// EXPAND: [[B:%.*]] = waveamdmachine.v_mul_lo_u32
// EXPAND: [[SEED:%.*]] = waveamdmachine.buffer_store_b32
// EXPAND: [[VALUE:%.*]], [[LOADED:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[SEED]] offset 256
// EXPAND: [[STORED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[VALUE]], {{.*}} after [[LOADED]] offset 512
// EXPAND: waveamdmachine.v_add_u32 [[A]], [[B]]
// EXPAND: [[COMBINED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}} after [[STORED]] offset 1024
// EXPAND: [[BACK:%.*]], [[READ:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[COMBINED]] offset 512
// EXPAND: [[OUT:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[BACK]], {{.*}} after [[READ]]
// EXPAND-NOT: waveamdmachine.buffer_
// EXPAND: waveamdmachine.continue_if {{.*}} carries({{.*}}, [[OUT]]
// EXPAND: waveamdmachine.candidate_yield
// EXPAND: waveamdmachine.uniform_loop
// EXPAND: [[A:%.*]] = waveamdmachine.v_mul_lo_u32
// EXPAND: [[B:%.*]] = waveamdmachine.v_lshlrev_b32
// EXPAND: [[SEED:%.*]] = waveamdmachine.buffer_store_b32
// EXPAND: [[VALUE:%.*]], [[LOADED:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[SEED]] offset 256
// EXPAND: [[STORED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[VALUE]], {{.*}} after [[LOADED]] offset 512
// EXPAND: waveamdmachine.v_add_u32 [[A]], [[B]]
// EXPAND: [[COMBINED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}} after [[STORED]] offset 1024
// EXPAND: [[BACK:%.*]], [[READ:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[COMBINED]] offset 512
// EXPAND: [[OUT:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[BACK]], {{.*}} after [[READ]]
// EXPAND-NOT: waveamdmachine.buffer_
// EXPAND: waveamdmachine.continue_if {{.*}} carries({{.*}}, [[OUT]]
// EXPAND: waveamdmachine.candidate_yield
// EXPAND: waveamdmachine.uniform_loop
// EXPAND: [[A:%.*]] = waveamdmachine.v_mul_lo_u32
// EXPAND: [[B:%.*]] = waveamdmachine.v_add_u32
// EXPAND: [[SEED:%.*]] = waveamdmachine.buffer_store_b32
// EXPAND: [[VALUE:%.*]], [[LOADED:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[SEED]] offset 256
// EXPAND: [[STORED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[VALUE]], {{.*}} after [[LOADED]] offset 512
// EXPAND: waveamdmachine.v_add_u32 [[A]], [[B]]
// EXPAND: [[COMBINED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}} after [[STORED]] offset 1024
// EXPAND: [[BACK:%.*]], [[READ:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[COMBINED]] offset 512
// EXPAND: [[OUT:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[BACK]], {{.*}} after [[READ]]
// EXPAND-NOT: waveamdmachine.buffer_
// EXPAND: waveamdmachine.continue_if {{.*}} carries({{.*}}, [[OUT]]
// EXPAND: waveamdmachine.candidate_yield
// EXPAND: waveamdmachine.uniform_loop
// EXPAND: [[A:%.*]] = waveamdmachine.v_add_u32
// EXPAND: [[B:%.*]] = waveamdmachine.v_mul_lo_u32
// EXPAND: [[SEED:%.*]] = waveamdmachine.buffer_store_b32
// EXPAND: [[VALUE:%.*]], [[LOADED:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[SEED]] offset 256
// EXPAND: [[STORED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[VALUE]], {{.*}} after [[LOADED]] offset 512
// EXPAND: waveamdmachine.v_add_u32 [[A]], [[B]]
// EXPAND: [[COMBINED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}} after [[STORED]] offset 1024
// EXPAND: [[BACK:%.*]], [[READ:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[COMBINED]] offset 512
// EXPAND: [[OUT:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[BACK]], {{.*}} after [[READ]]
// EXPAND-NOT: waveamdmachine.buffer_
// EXPAND: waveamdmachine.continue_if {{.*}} carries({{.*}}, [[OUT]]
// EXPAND: waveamdmachine.candidate_yield
// EXPAND: waveamdmachine.uniform_loop
// EXPAND: [[A:%.*]] = waveamdmachine.v_add_u32
// EXPAND: [[B:%.*]] = waveamdmachine.v_lshlrev_b32
// EXPAND: [[SEED:%.*]] = waveamdmachine.buffer_store_b32
// EXPAND: [[VALUE:%.*]], [[LOADED:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[SEED]] offset 256
// EXPAND: [[STORED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[VALUE]], {{.*}} after [[LOADED]] offset 512
// EXPAND: waveamdmachine.v_add_u32 [[A]], [[B]]
// EXPAND: [[COMBINED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}} after [[STORED]] offset 1024
// EXPAND: [[BACK:%.*]], [[READ:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[COMBINED]] offset 512
// EXPAND: [[OUT:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[BACK]], {{.*}} after [[READ]]
// EXPAND-NOT: waveamdmachine.buffer_
// EXPAND: waveamdmachine.continue_if {{.*}} carries({{.*}}, [[OUT]]
// EXPAND: waveamdmachine.candidate_yield
// EXPAND: waveamdmachine.uniform_loop
// EXPAND: [[A:%.*]] = waveamdmachine.v_add_u32
// EXPAND: [[B:%.*]] = waveamdmachine.v_add_u32
// EXPAND: [[SEED:%.*]] = waveamdmachine.buffer_store_b32
// EXPAND: [[VALUE:%.*]], [[LOADED:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[SEED]] offset 256
// EXPAND: [[STORED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[VALUE]], {{.*}} after [[LOADED]] offset 512
// EXPAND: waveamdmachine.v_add_u32 [[A]], [[B]]
// EXPAND: [[COMBINED:%.*]] = waveamdmachine.buffer_store_b32 {{.*}} after [[STORED]] offset 1024
// EXPAND: [[BACK:%.*]], [[READ:%.*]] = waveamdmachine.buffer_load_b32 {{.*}} after [[COMBINED]] offset 512
// EXPAND: [[OUT:%.*]] = waveamdmachine.buffer_store_b32 {{.*}}, [[BACK]], {{.*}} after [[READ]]
// EXPAND-NOT: waveamdmachine.buffer_
// EXPAND: waveamdmachine.continue_if {{.*}} carries({{.*}}, [[OUT]]
// EXPAND: waveamdmachine.candidate_yield
// EXPAND-NOT: waveamdmachine.materialization_candidates
// EXPAND-NOT: waveamdmachine.candidate_yield
// EXPAND: waveamdmachine.s_endpgm
// WINNER-LABEL: func.func @dependent_memory_choices
// WINNER: waveamdmachine.uniform_loop
// WINNER: waveamdmachine.buffer_store_b32
// WINNER: waveamdmachine.buffer_load_b32
// WINNER: waveamdmachine.buffer_store_b32
// WINNER: waveamdmachine.buffer_store_b32
// WINNER: waveamdmachine.buffer_load_b32
// WINNER: waveamdmachine.buffer_store_b32
// WINNER-NOT: waveamdmachine.buffer_
// WINNER: waveamdmachine.s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @dependent_memory_choices(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %two = arith.constant 2 : i32
  %four = arith.constant 4 : i32
  %range = arith.constant 2048 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %initial = wave.token : !wave.mem.token
  %done = scf.for %i = %zero to %four step %one
      iter_args(%previous = %initial) -> (!wave.mem.token) : i32 {
    %a0 = wave.binary muli %lane, %two : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
    %a1 = wave.binary addi %lane, %lane : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a = wave.materialization_variants %a0, %a1 : !wave.simd<i32, 32>
    %b0 = wave.binary muli %lane, %four : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
    %b1 = wave.binary shli %lane, %two : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
    %b2 = wave.binary addi %a0, %a0 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %b = wave.materialization_variants %b0, %b1, %b2 : !wave.simd<i32, 32>
    %src_offset = wave.index_expr <"64 + a"> ["a"](%a)
        : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %dst_offset = wave.index_expr <"128 + b"> ["b"](%b)
        : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %combined_offset = wave.index_expr <"256 + a + b"> ["a", "b"](%a, %b)
        : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %src = wave.ptr_add %buffer, %src_offset
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %dst = wave.ptr_add %buffer, %dst_offset
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %combined = wave.ptr_add %buffer, %combined_offset
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %expected = wave.binary addi %lane, %i : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
    %seed = wave.store %expected -> %src after %previous
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) -> !wave.mem.token
    %value, %loaded = wave.load %src after %seed
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %stored = wave.store %value -> %dst after %loaded
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) -> !wave.mem.token
    %combined_store = wave.store %expected -> %combined after %stored
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) -> !wave.mem.token
    %readback, %read_token = wave.load %dst after %combined_store
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %output = wave.ptr_add %buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %written = wave.store %readback -> %output after %read_token
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) -> !wave.mem.token
    scf.yield %written : !wave.mem.token
  }
  return
}
}
