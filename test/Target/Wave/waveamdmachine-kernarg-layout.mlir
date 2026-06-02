// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering %s | FileCheck %s --check-prefix=ABI
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @kernarg_layout
// SELECT: waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.arg {index = 2 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.arg {index = 3 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 4>

// ABI-LABEL: func.func @kernarg_layout
// ABI-SAME: waveamdmachine.kernarg_size = 40 : i64
// ABI: [[OFF0:%.*]] = waveamdmachine.imm 0
// ABI-NEXT: waveamdmachine.s_load_b32 [[OFF0]], "s[0:1]"
// ABI: [[OFF4:%.*]] = waveamdmachine.imm 4
// ABI-NEXT: waveamdmachine.s_load_b64 [[OFF4]], "s[0:1]"
// ABI: [[OFF12:%.*]] = waveamdmachine.imm 12
// ABI-NEXT: waveamdmachine.s_load_b64 [[OFF12]], "s[0:1]"
// ABI: [[OFF20:%.*]] = waveamdmachine.imm 20
// ABI-NEXT: waveamdmachine.s_load_b128 [[OFF20]], "s[0:1]"
// ABI-NOT: waveamdmachine.arg

// ASM: .amdhsa_kernel kernarg_layout
// ASM: .amdhsa_kernarg_size 40
// ASM: .amdhsa_user_sgpr_kernarg_segment_ptr 1
// ASM-NOT: .amdhsa_user_sgpr_kernarg_preload_length
// ASM: .amdhsa_system_sgpr_workgroup_id_x
// ASM: .name:           arg0
// ASM-NEXT: .offset:         0
// ASM-NEXT: .size:           4
// ASM-NEXT: .value_kind:     by_value
// ASM: .name:           arg1
// ASM-NEXT: .offset:         4
// ASM-NEXT: .size:           8
// ASM-NEXT: .value_kind:     by_value
// ASM: .address_space:  global
// ASM-NEXT: .name:           arg2
// ASM-NEXT: .offset:         12
// ASM-NEXT: .size:           8
// ASM-NEXT: .value_kind:     global_buffer
// ASM: .name:           arg3
// ASM-NEXT: .offset:         20
// ASM-NEXT: .size:           16
// ASM-NEXT: .value_kind:     by_value
// ASM: .kernarg_segment_size: 40
func.func @kernarg_layout(%x: i32, %wide: i64,
                          %out: !wave.ptr<#wave.global, i32>,
                          %buf: !wave.ptr<#waveamd.buffer, i32>)
    attributes {wave.kernel} {
  return
}

}
