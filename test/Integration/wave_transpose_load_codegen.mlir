// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: transpose_load_b96_b6_offset:
// ASM: ds_read_b96_tr_b6 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:48
// ASM: s_endpgm
func.func @transpose_load_b96_b6_offset()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lds = wave.lds_base : !wave.ptr<#wave.shared>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %offset = wave.index_expr <"48 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr = wave.ptr_add %lds, %offset
      : !wave.ptr<#wave.shared>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.shared>, 64>
  %value, %token = waveamd.transpose_load %ptr
      : (!wave.simd<!wave.ptr<#wave.shared>, 64>)
        -> (!wave.simd<vector<3xi32>, 64>, !wave.mem.token)
  return
}

}
