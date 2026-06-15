// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering %s | FileCheck %s --check-prefix=ABI
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-preserve-hw-regs --waveamd-reg-alloc --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits %s | FileCheck %s --check-prefix=TICKET
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-preserve-hw-regs --waveamd-reg-alloc --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits %s | FileCheck %s --check-prefix=HAZARD
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-preserve-hw-regs --waveamd-reg-alloc %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-preserve-hw-regs --waveamd-reg-alloc --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --waveamd-resource-info %s | FileCheck %s --check-prefix=RESOURCE
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-preserve-hw-regs --waveamd-reg-alloc --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --waveamd-resource-info --waveamd-metadata %s | FileCheck %s --check-prefix=METADATA

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @where_test
// SELECT: waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
// SELECT: waveamdmachine.v_cmp_lt_u32
// SELECT: waveamdmachine.exec_if
// SELECT: waveamdmachine.v_add_u32
// SELECT: } : !waveamdmachine.reg<sgpr, 1>
func.func @where_test(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active {
    %sum = wave.binary addi %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    wave.yield
  } : !wave.mask<32>
  %bits = wave.ballot %active : !wave.mask<32> -> i32
  return %bits : i32
}

// SELECT-LABEL: func.func @kernel_test
// SELECT: waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.global_store_b32
// ABI-LABEL: func.func @kernel_test
// ABI: waveamdmachine.s_load_b64 {{.*}}, "s[0:1]"
// ABI: waveamdmachine.s_load_b32 {{.*}}, "s[0:1]"
// ABI-NOT: waveamdmachine.arg
// TICKET-LABEL: func.func @kernel_test
// TICKET: waveamdmachine.v_mbcnt_lo
// TICKET: waveamdmachine.s_waitcnt
// TICKET-NOT: waveamdmachine.s_delay_alu
// TICKET: waveamdmachine.v_add_u32
// TICKET: waveamdmachine.global_store_b32
// TICKET: waveamdmachine.s_waitcnt_vscnt
// TICKET: waveamdmachine.s_endpgm
// HAZARD-LABEL: func.func @kernel_test
// HAZARD: waveamdmachine.s_waitcnt
// HAZARD: waveamdmachine.s_delay_alu
// HAZARD: waveamdmachine.v_add_u32
// REGALLOC-LABEL: func.func @kernel_test
// REGALLOC: waveamdmachine.s_load_b64 {{.*}}, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2, 6>
// REGALLOC: waveamdmachine.s_load_b32 {{.*}}, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 5>
// REGALLOC: waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1, 1>
// REGALLOC: waveamdmachine.v_add_u32{{.*}} -> !waveamdmachine.reg<vgpr, 1, 2>
// RESOURCE-LABEL: func.func @kernel_test
// RESOURCE-SAME: waveamdmachine.sgpr_count = 8 : i64
// RESOURCE-SAME: waveamdmachine.vgpr_count = 4 : i64
// METADATA: module attributes {{{.*}}waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"{{.*}}}
// METADATA-LABEL: func.func @kernel_test
// METADATA-SAME: waveamdmachine.metadata
func.func @kernel_test(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %store_token = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

}
