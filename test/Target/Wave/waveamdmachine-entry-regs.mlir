// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering %s | FileCheck %s --check-prefix=ABI
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s --check-prefix=REGALLOC

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// SELECT-LABEL: func.func @kernarg_preload_shifts_system_sgprs
// SELECT: waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 4>
// SELECT: waveamdmachine.s_workgroup_id_y : !waveamdmachine.reg<sgpr, 1, 5>
// SELECT: waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>

// ABI-LABEL: func.func @kernarg_preload_shifts_system_sgprs
// ABI: waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 4>
// ABI: waveamdmachine.s_workgroup_id_y : !waveamdmachine.reg<sgpr, 1, 5>
// ABI: waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>

// REGALLOC-LABEL: func.func @kernarg_preload_shifts_system_sgprs
// REGALLOC: waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, 4>
// REGALLOC: waveamdmachine.s_workgroup_id_y : !waveamdmachine.reg<sgpr, 1, 5>
// REGALLOC: waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>

func.func @kernarg_preload_shifts_system_sgprs()
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 2 : i64} {
  %wg_x = wave.workgroup_id 0
  %wg_y = wave.workgroup_id 1
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  return
}

// SELECT-LABEL: func.func @preloaded_arg_prefix
// SELECT: waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.arg {index = 2 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.arg {index = 3 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 4>

// ABI-LABEL: func.func @preloaded_arg_prefix
// ABI-SAME: waveamdmachine.kernarg_size = 40 : i64
// ABI: waveamdmachine.kernarg_preload {dword_offset = 0 : i64} : !waveamdmachine.reg<sgpr, 1, 2>
// ABI: waveamdmachine.kernarg_preload {dword_offset = 1 : i64} : !waveamdmachine.reg<sgpr, 2, 3>
// ABI: [[OFF12:%.*]] = waveamdmachine.imm 12
// ABI-NEXT: waveamdmachine.s_load_b64 [[OFF12]], "s[0:1]"
// ABI: [[OFF20:%.*]] = waveamdmachine.imm 20
// ABI-NEXT: waveamdmachine.s_load_b128 [[OFF20]], "s[0:1]"
// ABI-NOT: waveamdmachine.arg

// REGALLOC-LABEL: func.func @preloaded_arg_prefix
// REGALLOC-SAME: waveamdmachine.sgpr_count =
// REGALLOC: waveamdmachine.kernarg_preload {dword_offset = 0 : i64} : !waveamdmachine.reg<sgpr, 1, 2>
// REGALLOC: waveamdmachine.kernarg_preload {dword_offset = 1 : i64} : !waveamdmachine.reg<sgpr, 2, 3>

func.func @preloaded_arg_prefix(%x: i32, %wide: i64,
                                %out: !wave.ptr<#wave.global, i32>,
                                %buf: !wave.ptr<#waveamd.buffer, i32>)
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 3 : i64} {
  return
}

// ABI-LABEL: func.func @preloaded_pointer_args
// ABI-SAME: waveamdmachine.kernarg_size = 24 : i64
// ABI: waveamdmachine.kernarg_preload {dword_offset = 0 : i64} : !waveamdmachine.reg<sgpr, 2, 2>
// ABI: waveamdmachine.kernarg_preload {dword_offset = 2 : i64} : !waveamdmachine.reg<sgpr, 4, 4>
// ABI-NOT: waveamdmachine.arg

// REGALLOC-LABEL: func.func @preloaded_pointer_args
// REGALLOC: waveamdmachine.kernarg_preload {dword_offset = 0 : i64} : !waveamdmachine.reg<sgpr, 2, 2>
// REGALLOC: waveamdmachine.kernarg_preload {dword_offset = 2 : i64} : !waveamdmachine.reg<sgpr, 4, 4>

func.func @preloaded_pointer_args(%out: !wave.ptr<#wave.global, i32>,
                                  %buf: !wave.ptr<#waveamd.buffer, i32>)
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 6 : i64} {
  return
}

}
