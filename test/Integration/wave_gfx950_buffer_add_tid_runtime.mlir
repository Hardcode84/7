// REQUIRES: host-supports-amdgpu-gfx950
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s

// CHECK: [0, 1000, 1, 1001, 2, 1002, 3, 1003, 4, 1004, 5, 1005, 6, 1006, 7, 1007, 8, 1008, 9, 1009, 10, 1010, 11, 1011, 12, 1012, 13, 1013, 14, 1014, 15, 1015, 16, 1016, 17, 1017, 18, 1018, 19, 1019, 20, 1020, 21, 1021, 22, 1022, 23, 1023, 24, 1024, 25, 1025, 26, 1026, 27, 1027, 28, 1028, 29, 1029, 30, 1030, 31, 1031, 32, 1032, 33, 1033, 34, 1034, 35, 1035, 36, 1036, 37, 1037, 38, 1038, 39, 1039, 40, 1040, 41, 1041, 42, 1042, 43, 1043, 44, 1044, 45, 1045, 46, 1046, 47, 1047, 48, 1048, 49, 1049, 50, 1050, 51, 1051, 52, 1052, 53, 1053, 54, 1054, 55, 1055, 56, 1056, 57, 1057, 58, 1058, 59, 1059, 60, 1060, 61, 1061, 62, 1062, 63, 1063, 64, 1064, 65, 1065, 66, 1066, 67, 1067, 68, 1068, 69, 1069, 70, 1070, 71, 1071, 72, 1072, 73, 1073, 74, 1074, 75, 1075, 76, 1076, 77, 1077, 78, 1078, 79, 1079, 80, 1080, 81, 1081, 82, 1082, 83, 1083, 84, 1084, 85, 1085, 86, 1086, 87, 1087, 88, 1088, 89, 1089, 90, 1090, 91, 1091, 92, 1092, 93, 1093, 94, 1094, 95, 1095, 96, 1096, 97, 1097, 98, 1098, 99, 1099, 100, 1100, 101, 1101, 102, 1102, 103, 1103, 104, 1104, 105, 1105, 106, 1106, 107, 1107, 108, 1108, 109, 1109, 110, 1110, 111, 1111, 112, 1112, 113, 1113, 114, 1114, 115, 1115, 116, 1116, 117, 1117, 118, 1118, 119, 1119, 120, 1120, 121, 1121, 122, 1122, 123, 1123, 124, 1124, 125, 1125, 126, 1126, 127, 1127]

module attributes {
  gpu.container_module,
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"
} {

gpu.module @kernels {
  func.func @write_lane_pairs(%dst: !wave.ptr<#wave.global, i32>)
      attributes {
        gpu.kernel,
        wave.kernel,
        wave.workgroup_size = array<i32: 128, 1, 1>,
        wave.waves_per_workgroup = 2 : i64
      } {
    %range = arith.constant 1024 : i32
    %buffer = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %lane = wave.lane_id : !wave.simd<i32, 64>
    %thousand = wave.constant 1000 : i32 -> !wave.simd<i32, 64>
    %second = wave.binary addi %item, %thousand
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %value = wave.pack %item, %second
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<vector<2xi32>, 64>
    %offset = wave.index_expr <"128*floor(item/64) + 2*lane">
        ["item", "lane"](%item, %lane)
        : (!wave.simd<i32, 64>, !wave.simd<i32, 64>)
        -> !wave.simd<index, 64>
    %ptrs = wave.ptr_add %buffer, %offset
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %token = wave.store %value -> %ptrs
        : (!wave.simd<vector<2xi32>, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    return
  }
}

func.func private @wave_memref_to_ptr_global_i32(memref<256xi32>)
    -> !wave.ptr<#wave.global, i32> attributes {llvm.emit_c_interface}

func.func private @printMemrefI32(memref<*xi32>)
    attributes {llvm.emit_c_interface}

func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c128 = arith.constant 128 : index
  %c256 = arith.constant 256 : index
  %zero = arith.constant 0 : i32
  %storage = memref.alloc() : memref<256xi32>
  scf.for %i = %c0 to %c256 step %c1 {
    memref.store %zero, %storage[%i] : memref<256xi32>
  }
  %unranked = memref.cast %storage : memref<256xi32> to memref<*xi32>
  gpu.host_register %unranked : memref<*xi32>
  %ptr = func.call @wave_memref_to_ptr_global_i32(%storage)
      : (memref<256xi32>) -> !wave.ptr<#wave.global, i32>
  gpu.launch_func @kernels::@write_lane_pairs
      blocks in (%c1, %c1, %c1) threads in (%c128, %c1, %c1)
      args(%ptr : !wave.ptr<#wave.global, i32>)
  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()
  return
}

}
