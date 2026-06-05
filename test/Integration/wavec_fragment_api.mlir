# RUN: wavec %S/../../wavec/test/e2e/good/fragment_api.wave \
# RUN:   | wave-opt | FileCheck %s

# CHECK-LABEL: func.func @fragment_api
# CHECK-SAME: ([[SCRATCH:%.*]]: !wave.ptr<#wave.global, vector<8xi32>>)
# CHECK: waveamd.fragment_fill {{.*}} -> !waveamd.fragment<0, f16, 16, 16, 32, 8>
# CHECK: waveamd.fragment_fill {{.*}} -> !waveamd.fragment<1, f16, 16, 16, 32, 8>
# CHECK: [[REGS:%.*]] = waveamd.fragment_unpack
# CHECK-SAME: -> !wave.simd<vector<8xi32>, 32>
# CHECK: waveamd.fragment_pack [[REGS]]
# CHECK: waveamd.mma "wmma.f32.16x16x16.f16"
# CHECK: wave.read_first
# CHECK: wave.subgroup_id
# CHECK: [[PTRS:%.*]] = wave.ptr_add [[SCRATCH]]
# CHECK-SAME: -> !wave.simd<!wave.ptr<#wave.global, vector<8xi32>>, 32>
# CHECK: [[LOADED:%.*]], [[TOK:%.*]] = wave.load [[PTRS]]
# CHECK-SAME: -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
# CHECK: [[FRAG:%.*]] = waveamd.fragment_pack [[LOADED]]
# CHECK: [[STORED:%.*]] = waveamd.fragment_unpack [[FRAG]]
# CHECK: wave.store [[STORED]] -> {{%.*}} after [[TOK]]
