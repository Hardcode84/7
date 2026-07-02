module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 4 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @_a4w4_kernel(%arg0: !wave.ptr<#wave.global, i8>, %arg1: !wave.ptr<#wave.global, i8>, %arg2: !wave.ptr<#wave.global, bf16>, %arg3: !wave.ptr<#wave.global, i8>, %arg4: !wave.ptr<#wave.global, i8>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 256, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 4 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.lds_size = 150528 : i64, wave.waves_per_workgroup = 4 : i64, wave.workgroup_size = array<i32: 256, 1, 1>, waveamdmachine.target_waves = 1 : i64} {
      %0 = wave.constant 1073741824 : index -> !wave.simd<index, 64>
      %1 = wave.constant 512 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 6144 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 4096 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 2048 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 0 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
      %8 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %10 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %11 = wave.constant 240 : i32 -> !wave.simd<i32, 64>
      %12 = wave.constant 224 : i32 -> !wave.simd<i32, 64>
      %13 = wave.constant 208 : i32 -> !wave.simd<i32, 64>
      %14 = wave.constant 192 : i32 -> !wave.simd<i32, 64>
      %15 = wave.constant 176 : i32 -> !wave.simd<i32, 64>
      %16 = wave.constant 160 : i32 -> !wave.simd<i32, 64>
      %17 = wave.constant 144 : i32 -> !wave.simd<i32, 64>
      %18 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %19 = wave.constant 112 : i32 -> !wave.simd<i32, 64>
      %20 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %21 = wave.constant 80 : i32 -> !wave.simd<i32, 64>
      %22 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %23 = wave.constant 48 : i32 -> !wave.simd<i32, 64>
      %24 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %25 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %26 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %c7168_i32 = arith.constant 7168 : i32
      %c6144_i32 = arith.constant 6144 : i32
      %c5120_i32 = arith.constant 5120 : i32
      %c4096_i32 = arith.constant 4096 : i32
      %c3072_i32 = arith.constant 3072 : i32
      %c2048_i32 = arith.constant 2048 : i32
      %c1024_i32 = arith.constant 1024 : i32
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %c64_i32 = arith.constant 64 : i32
      %c16_i32 = arith.constant 16 : i32
      %c62_i32 = arith.constant 62 : i32
      %c2_i32 = arith.constant 2 : i32
      %c255_i32 = arith.constant 255 : i32
      %c32_i32 = arith.constant 32 : i32
      %c0_i32 = arith.constant 0 : i32
      %c8_i32 = arith.constant 8 : i32
      %c4_i32 = arith.constant 4 : i32
      %c256_i32 = arith.constant 256 : i32
      %c128_i32 = arith.constant 128 : i32
      %27 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %28 = wave.pack %27, %27, %27, %27 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %29 = wave.workgroup_id 0
      %30 = wave.binary addi %arg5, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %31 = wave.binary divsi %30, %c256_i32 : i32, i32 -> i32
      %32 = wave.binary addi %arg6, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %33 = wave.binary divsi %32, %c256_i32 : i32, i32 -> i32
      %34 = wave.binary remui %29, %c8_i32 : i32, i32 -> i32
      %35 = wave.binary divui %29, %c8_i32 : i32, i32 -> i32
      %36 = wave.binary muli %34, %c32_i32 overflow<nsw> : i32, i32 -> i32
      %37 = wave.binary addi %36, %35 overflow<nsw> : i32, i32 -> i32
      %38 = wave.binary muli %33, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %39 = wave.binary divsi %37, %38 : i32, i32 -> i32
      %40 = wave.binary muli %39, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %41 = wave.binary subi %31, %40 overflow<nsw> : i32, i32 -> i32
      %42 = arith.cmpi slt, %41, %c4_i32 : i32
      %43 = wave.select %42, %41, %c4_i32 : i32
      %44 = wave.binary remsi %37, %38 : i32, i32 -> i32
      %45 = wave.assume %43 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %46 = wave.binary remui %44, %45 : i32, i32 -> i32
      %47 = wave.binary addi %40, %46 overflow<nsw> : i32, i32 -> i32
      %48 = wave.assume %43 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %49 = wave.binary divui %44, %48 : i32, i32 -> i32
      %50 = wave.binary muli %47, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %51 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %52 = wave.binary divui %51, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %53 = wave.binary remui %52, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %54 = wave.binary addi %53, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %55 = wave.binary addi %53, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %56 = wave.binary addi %53, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %57 = wave.binary addi %53, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %58 = wave.binary addi %53, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %59 = wave.binary addi %53, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %60 = wave.binary addi %53, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %61 = wave.binary addi %53, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %62 = wave.binary addi %53, %17 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %63 = wave.binary addi %53, %16 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %64 = wave.binary addi %53, %15 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %65 = wave.binary addi %53, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %66 = wave.binary addi %53, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %67 = wave.binary addi %53, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %68 = wave.binary addi %53, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %69 = wave.splat %50 : i32 -> !wave.simd<i32, 64>
      %70 = wave.binary addi %69, %53 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %71 = wave.binary addi %69, %54 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %72 = wave.binary addi %69, %55 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %73 = wave.binary addi %69, %56 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %74 = wave.binary addi %69, %57 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %75 = wave.binary addi %69, %58 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %76 = wave.binary addi %69, %59 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %77 = wave.binary addi %69, %60 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %78 = wave.binary addi %69, %61 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %79 = wave.binary addi %69, %62 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %80 = wave.binary addi %69, %63 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %81 = wave.binary addi %69, %64 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %82 = wave.binary addi %69, %65 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %83 = wave.binary addi %69, %66 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %84 = wave.binary addi %69, %67 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %85 = wave.binary addi %69, %68 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %86 = wave.binary remui %51, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %87 = wave.binary muli %86, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %88 = wave.binary muli %49, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %89 = wave.splat %88 : i32 -> !wave.simd<i32, 64>
      %90 = wave.binary addi %89, %87 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %91 = wave.binary muli %arg8, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %92 = wave.binary muli %arg11, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %93 = wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
      %94 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %95 = wave.ptr_cast %93 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %96 = wave.read_first %51 : !wave.simd<i32, 64> -> i32
      %97 = wave.assume %96 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-255 + x <= 0">] : i32
      %98 = wave.token : !wave.mem.token
      %99 = wave.index_expr <"s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %100 = wave.assume %99 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %101 = wave.ptr_add %94, %100 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %102 = wave.binary divui %97, %c64_i32 : i32, i32 -> i32
      %103 = wave.binary muli %102, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %104 = wave.ptr_add %95, %103 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %105 = waveamd.dma_load_lds %101 -> %104 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %106 = wave.index_expr <"32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %107 = wave.assume %106 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %108 = wave.ptr_add %94, %107 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %109 = wave.binary addi %103, %c1024_i32 overflow<nsw> : i32, i32 -> i32
      %110 = wave.ptr_add %95, %109 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %111 = waveamd.dma_load_lds %108 -> %110 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %112 = wave.index_expr <"64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %113 = wave.assume %112 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %114 = wave.ptr_add %94, %113 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %115 = wave.binary addi %103, %c2048_i32 overflow<nsw> : i32, i32 -> i32
      %116 = wave.ptr_add %95, %115 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %117 = waveamd.dma_load_lds %114 -> %116 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %118 = wave.index_expr <"96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %119 = wave.assume %118 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %120 = wave.ptr_add %94, %119 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %121 = wave.binary addi %103, %c3072_i32 overflow<nsw> : i32, i32 -> i32
      %122 = wave.ptr_add %95, %121 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %123 = waveamd.dma_load_lds %120 -> %122 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %124 = wave.index_expr <"128*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 128*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %125 = wave.assume %124 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %126 = wave.ptr_add %94, %125 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %127 = wave.binary addi %103, %c4096_i32 overflow<nsw> : i32, i32 -> i32
      %128 = wave.ptr_add %95, %127 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %129 = waveamd.dma_load_lds %126 -> %128 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %130 = wave.index_expr <"160*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"160*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 160*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %131 = wave.assume %130 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %132 = wave.ptr_add %94, %131 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %133 = wave.binary addi %103, %c5120_i32 overflow<nsw> : i32, i32 -> i32
      %134 = wave.ptr_add %95, %133 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %135 = waveamd.dma_load_lds %132 -> %134 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %136 = wave.index_expr <"192*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"192*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 192*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %137 = wave.assume %136 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %138 = wave.ptr_add %94, %137 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %139 = wave.binary addi %103, %c6144_i32 overflow<nsw> : i32, i32 -> i32
      %140 = wave.ptr_add %95, %139 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %141 = waveamd.dma_load_lds %138 -> %140 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %142 = wave.index_expr <"224*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"224*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 224*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %143 = wave.assume %142 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %144 = wave.ptr_add %94, %143 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %145 = wave.binary addi %103, %c7168_i32 overflow<nsw> : i32, i32 -> i32
      %146 = wave.ptr_add %95, %145 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %147 = waveamd.dma_load_lds %144 -> %146 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %148 = wave.join %105, %111, %117, %123, %129, %135, %141, %147 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %149 = wave.shared_memory_base {offset = 65536 : i64} : !wave.ptr<#wave.shared, i8>
      %150 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %151 = wave.ptr_cast %149 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %152 = wave.index_expr <"s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg8, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %153 = wave.assume %152 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %154 = wave.ptr_add %150, %153 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %155 = wave.ptr_add %151, %103 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %156 = waveamd.dma_load_lds %154 -> %155 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %157 = wave.index_expr <"32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg8, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %158 = wave.assume %157 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %159 = wave.ptr_add %150, %158 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %160 = wave.ptr_add %151, %109 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %161 = waveamd.dma_load_lds %159 -> %160 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %162 = wave.index_expr <"64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg8, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %163 = wave.assume %162 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %164 = wave.ptr_add %150, %163 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %165 = wave.ptr_add %151, %115 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %166 = waveamd.dma_load_lds %164 -> %165 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %167 = wave.index_expr <"96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg8, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %168 = wave.assume %167 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %169 = wave.ptr_add %150, %168 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %170 = wave.ptr_add %151, %121 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %171 = waveamd.dma_load_lds %169 -> %170 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %172 = wave.join %156, %161, %166, %171 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %173 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %174 = wave.index_expr <"s0*s1 + s0*(Mod(wi, 2) + 128*Mod(floor(1/128*wi), 2) + 64*Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2) + 8*Mod(floor(1/8*wi), 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2))"> assuming [#wave.pred<"s0*s1 + s0*xor(128*Mod(floor(1/128*wi), 2), xor(64*Mod(floor(1/64*wi), 2), xor(32*Mod(floor(1/32*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2)))))))) >= 0">, #wave.pred<"-2147483640 + s0*s1 + s0*xor(128*Mod(floor(1/128*wi), 2), xor(64*Mod(floor(1/64*wi), 2), xor(32*Mod(floor(1/32*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2)))))))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %175 = wave.assume %174 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483640 + x <= 0">] : !wave.simd<index, 64>
      %176 = wave.ptr_add %173, %175 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value, %token = wave.load %176 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %177 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %178 = wave.index_expr <"s0*s1 + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/32*wi), 2) + 8*s0*Mod(floor(1/16*wi), 2) + 4*s0*Mod(floor(1/8*wi), 2) + 2*s0*Mod(floor(1/4*wi), 2) + s0*Mod(floor(1/2*wi), 2) + 4*Mod(wi, 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/32*wi), 2), xor(8*Mod(floor(1/16*wi), 2), xor(4*Mod(floor(1/8*wi), 2), xor(2*Mod(floor(1/4*wi), 2), Mod(floor(1/2*wi), 2))))))) + 4*Mod(wi, 2) >= 0">, #wave.pred<"-2147483644 + s0*s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/32*wi), 2), xor(8*Mod(floor(1/16*wi), 2), xor(4*Mod(floor(1/8*wi), 2), xor(2*Mod(floor(1/4*wi), 2), Mod(floor(1/2*wi), 2))))))) + 4*Mod(wi, 2) <= 0">] ["wi", "s0", "s1"](%51, %arg11, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %179 = wave.assume %178 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483644 + x <= 0">] : !wave.simd<index, 64>
      %180 = wave.ptr_add %177, %179 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_0, %token_1 = wave.load %180 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %181 = wave.join %148, %172 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %182 = wave.shared_memory_base {offset = 98304 : i64} : !wave.ptr<#wave.shared, i8>
      %183 = wave.ptr_cast %182 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %184 = wave.index_expr <"s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %91, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %185 = wave.assume %184 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %186 = wave.ptr_add %150, %185 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %187 = wave.ptr_add %183, %103 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %188 = waveamd.dma_load_lds %186 -> %187 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %189 = wave.index_expr <"32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %91, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %190 = wave.assume %189 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %191 = wave.ptr_add %150, %190 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %192 = wave.ptr_add %183, %109 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %193 = waveamd.dma_load_lds %191 -> %192 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %194 = wave.index_expr <"64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %91, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %195 = wave.assume %194 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %196 = wave.ptr_add %150, %195 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %197 = wave.ptr_add %183, %115 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %198 = waveamd.dma_load_lds %196 -> %197 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %199 = wave.index_expr <"96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %91, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %200 = wave.assume %199 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %201 = wave.ptr_add %150, %200 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %202 = wave.ptr_add %183, %121 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %203 = waveamd.dma_load_lds %201 -> %202 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %204 = wave.join %188, %193, %198, %203 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %205 = wave.index_expr <"s1 + s0*s2 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %92, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %206 = wave.index_expr <"s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %92, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %207 = wave.index_expr <"s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %92, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %208 = wave.index_expr <"s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %92, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %209 = wave.assume %205 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %210 = wave.ptr_add %177, %209 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_2, %token_3 = wave.load %210 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %211 = wave.assume %206 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %212 = wave.ptr_add %177, %211 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_4, %token_5 = wave.load %212 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %213 = wave.assume %207 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %214 = wave.ptr_add %177, %213 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_6, %token_7 = wave.load %214 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %215 = wave.assume %208 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %216 = wave.ptr_add %177, %215 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_8, %token_9 = wave.load %216 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %217 = wave.shared_memory_base {offset = 32768 : i64} : !wave.ptr<#wave.shared, i8>
      %218 = wave.ptr_cast %217 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %219 = wave.index_expr <"128 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %220 = wave.assume %219 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %221 = wave.ptr_add %94, %220 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %222 = wave.ptr_add %218, %103 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %223 = waveamd.dma_load_lds %221 -> %222 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %224 = wave.index_expr <"128 + 32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %225 = wave.assume %224 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %226 = wave.ptr_add %94, %225 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %227 = wave.ptr_add %218, %109 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %228 = waveamd.dma_load_lds %226 -> %227 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %229 = wave.index_expr <"128 + 64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %230 = wave.assume %229 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %231 = wave.ptr_add %94, %230 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %232 = wave.ptr_add %218, %115 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %233 = waveamd.dma_load_lds %231 -> %232 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %234 = wave.index_expr <"128 + 96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %235 = wave.assume %234 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %236 = wave.ptr_add %94, %235 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %237 = wave.ptr_add %218, %121 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %238 = waveamd.dma_load_lds %236 -> %237 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %239 = wave.index_expr <"128 + 128*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 128*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 128*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %240 = wave.assume %239 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %241 = wave.ptr_add %94, %240 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %242 = wave.ptr_add %218, %127 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %243 = waveamd.dma_load_lds %241 -> %242 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %244 = wave.index_expr <"128 + 160*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 160*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 160*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %245 = wave.assume %244 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %246 = wave.ptr_add %94, %245 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %247 = wave.ptr_add %218, %133 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %248 = waveamd.dma_load_lds %246 -> %247 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %249 = wave.index_expr <"128 + 192*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 192*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 192*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %250 = wave.assume %249 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %251 = wave.ptr_add %94, %250 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %252 = wave.ptr_add %218, %139 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %253 = waveamd.dma_load_lds %251 -> %252 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %254 = wave.index_expr <"128 + 224*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 224*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 224*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg7, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %255 = wave.assume %254 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %256 = wave.ptr_add %94, %255 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %257 = wave.ptr_add %218, %145 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %258 = waveamd.dma_load_lds %256 -> %257 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %259 = wave.join %223, %228, %233, %238, %243, %248, %253, %258 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %260 = wave.shared_memory_base {offset = 81920 : i64} : !wave.ptr<#wave.shared, i8>
      %261 = wave.ptr_cast %260 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %262 = wave.index_expr <"128 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg8, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %263 = wave.assume %262 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %264 = wave.ptr_add %150, %263 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %265 = wave.ptr_add %261, %103 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %266 = waveamd.dma_load_lds %264 -> %265 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %267 = wave.index_expr <"128 + 32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 32*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg8, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %268 = wave.assume %267 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %269 = wave.ptr_add %150, %268 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %270 = wave.ptr_add %261, %109 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %271 = waveamd.dma_load_lds %269 -> %270 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %272 = wave.index_expr <"128 + 64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 64*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg8, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %273 = wave.assume %272 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %274 = wave.ptr_add %150, %273 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %275 = wave.ptr_add %261, %115 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %276 = waveamd.dma_load_lds %274 -> %275 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %277 = wave.index_expr <"128 + 96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 96*s0 + s0*s1 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1"](%51, %arg8, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %278 = wave.assume %277 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %279 = wave.ptr_add %150, %278 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %280 = wave.ptr_add %261, %121 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %281 = waveamd.dma_load_lds %279 -> %280 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %282 = wave.join %266, %271, %276, %281 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %283 = wave.index_expr <"8 + s0*s1 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %284 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %285 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %286 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %287 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(128 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %288 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(160 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %289 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(192 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %290 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(224 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg10, %50) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %291 = wave.assume %283 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %292 = wave.ptr_add %173, %291 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_10, %token_11 = wave.load %292 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %293 = wave.assume %284 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %294 = wave.ptr_add %173, %293 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_12, %token_13 = wave.load %294 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %295 = wave.assume %285 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %296 = wave.ptr_add %173, %295 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_14, %token_15 = wave.load %296 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %297 = wave.assume %286 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %298 = wave.ptr_add %173, %297 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_16, %token_17 = wave.load %298 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %299 = wave.assume %287 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %300 = wave.ptr_add %173, %299 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_18, %token_19 = wave.load %300 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %301 = wave.assume %288 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %302 = wave.ptr_add %173, %301 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_20, %token_21 = wave.load %302 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %303 = wave.assume %289 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %304 = wave.ptr_add %173, %303 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_22, %token_23 = wave.load %304 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %305 = wave.assume %290 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %306 = wave.ptr_add %173, %305 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_24, %token_25 = wave.load %306 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %307 = wave.index_expr <"8 + s0*s1 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg11, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %308 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg11, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %309 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg11, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %310 = wave.index_expr <"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%51, %arg11, %88) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %311 = wave.assume %307 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %312 = wave.ptr_add %177, %311 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_26, %token_27 = wave.load %312 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %313 = wave.assume %308 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %314 = wave.ptr_add %177, %313 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_28, %token_29 = wave.load %314 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %315 = wave.assume %309 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %316 = wave.ptr_add %177, %315 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_30, %token_31 = wave.load %316 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %317 = wave.assume %310 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %318 = wave.ptr_add %177, %317 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_32, %token_33 = wave.load %318 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %319 = wave.join %259, %282 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %320 = wave.shared_memory_base {offset = 114688 : i64} : !wave.ptr<#wave.shared, i8>
      %321 = wave.ptr_cast %320 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %322 = wave.index_expr <"128 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %91, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %323 = wave.assume %322 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %324 = wave.ptr_add %150, %323 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %325 = wave.ptr_add %321, %103 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %326 = waveamd.dma_load_lds %324 -> %325 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %327 = wave.index_expr <"128 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %91, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %328 = wave.assume %327 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %329 = wave.ptr_add %150, %328 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %330 = wave.ptr_add %321, %109 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %331 = waveamd.dma_load_lds %329 -> %330 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %332 = wave.index_expr <"128 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %91, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %333 = wave.assume %332 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %334 = wave.ptr_add %150, %333 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %335 = wave.ptr_add %321, %115 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %336 = waveamd.dma_load_lds %334 -> %335 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %337 = wave.index_expr <"128 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %91, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %338 = wave.assume %337 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %339 = wave.ptr_add %150, %338 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %340 = wave.ptr_add %321, %121 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %341 = waveamd.dma_load_lds %339 -> %340 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %342 = wave.join %326, %331, %336, %341 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %343 = wave.index_expr <"8 + s1 + s0*s2 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %92, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %344 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %92, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %345 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %92, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %346 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %92, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %347 = wave.assume %343 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %348 = wave.ptr_add %177, %347 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_34, %token_35 = wave.load %348 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %349 = wave.assume %344 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %350 = wave.ptr_add %177, %349 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_36, %token_37 = wave.load %350 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %351 = wave.assume %345 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %352 = wave.ptr_add %177, %351 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_38, %token_39 = wave.load %352 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %353 = wave.assume %346 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %354 = wave.ptr_add %177, %353 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_40, %token_41 = wave.load %354 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      wave.wait %181 : !wave.mem.token
      %355 = wave.barrier %181 : (!wave.mem.token) -> !wave.mem.token
      %356 = wave.index_expr <"2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %357 = wave.ptr_add %93, %356 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_42, %token_43 = wave.load %357 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %358 = wave.index_expr <"64 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %359 = wave.ptr_add %93, %358 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_44, %token_45 = wave.load %359 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %360 = wave.index_expr <"4096 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %361 = wave.ptr_add %93, %360 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_46, %token_47 = wave.load %361 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %362 = wave.index_expr <"4160 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %363 = wave.ptr_add %93, %362 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_48, %token_49 = wave.load %363 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %364 = wave.index_expr <"8192 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %365 = wave.ptr_add %93, %364 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_50, %token_51 = wave.load %365 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %366 = wave.index_expr <"8256 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %367 = wave.ptr_add %93, %366 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_52, %token_53 = wave.load %367 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %368 = wave.index_expr <"12288 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %369 = wave.ptr_add %93, %368 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_54, %token_55 = wave.load %369 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %370 = wave.index_expr <"12352 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %371 = wave.ptr_add %93, %370 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_56, %token_57 = wave.load %371 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %372 = wave.index_expr <"16384 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %373 = wave.ptr_add %93, %372 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_58, %token_59 = wave.load %373 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %374 = wave.index_expr <"16448 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %375 = wave.ptr_add %93, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_60, %token_61 = wave.load %375 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %376 = wave.index_expr <"20480 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %377 = wave.ptr_add %93, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_62, %token_63 = wave.load %377 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %378 = wave.index_expr <"20544 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %379 = wave.ptr_add %93, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_64, %token_65 = wave.load %379 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %380 = wave.index_expr <"24576 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %381 = wave.ptr_add %93, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_66, %token_67 = wave.load %381 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %382 = wave.index_expr <"24640 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %383 = wave.ptr_add %93, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_68, %token_69 = wave.load %383 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %384 = wave.index_expr <"28672 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %385 = wave.ptr_add %93, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_70, %token_71 = wave.load %385 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %386 = wave.index_expr <"28736 + 2048*floor(1/128*wi) + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %387 = wave.ptr_add %93, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_72, %token_73 = wave.load %387 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %388 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 2048*Mod(floor(1/64*wi), 2) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %389 = wave.ptr_add %149, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_74, %token_75 = wave.load %389 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %390 = wave.index_expr <"64 + 16*floor(1/16*Mod(wi, 64)) + 2048*Mod(floor(1/64*wi), 2) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %391 = wave.ptr_add %149, %390 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_76, %token_77 = wave.load %391 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %392 = wave.index_expr <"4096 + 16*floor(1/16*Mod(wi, 64)) + 2048*Mod(floor(1/64*wi), 2) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %393 = wave.ptr_add %149, %392 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_78, %token_79 = wave.load %393 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %394 = wave.index_expr <"4160 + 16*floor(1/16*Mod(wi, 64)) + 2048*Mod(floor(1/64*wi), 2) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %395 = wave.ptr_add %149, %394 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_80, %token_81 = wave.load %395 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %396 = wave.index_expr <"8192 + 16*floor(1/16*Mod(wi, 64)) + 2048*Mod(floor(1/64*wi), 2) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %397 = wave.ptr_add %149, %396 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_82, %token_83 = wave.load %397 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %398 = wave.index_expr <"8256 + 16*floor(1/16*Mod(wi, 64)) + 2048*Mod(floor(1/64*wi), 2) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %399 = wave.ptr_add %149, %398 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_84, %token_85 = wave.load %399 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %400 = wave.index_expr <"12288 + 16*floor(1/16*Mod(wi, 64)) + 2048*Mod(floor(1/64*wi), 2) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %401 = wave.ptr_add %149, %400 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_86, %token_87 = wave.load %401 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %402 = wave.index_expr <"12352 + 16*floor(1/16*Mod(wi, 64)) + 2048*Mod(floor(1/64*wi), 2) + 128*Mod(Mod(wi, 64), 16)"> ["wi"](%51) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %403 = wave.ptr_add %149, %402 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_88, %token_89 = wave.load %403 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %404 = wave.shared_memory_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
      %405 = wave.binary remui %51, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %406 = wave.binary divui %51, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %407 = wave.binary remui %406, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %408 = wave.binary muli %407, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %409 = wave.binary xori %405, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %410 = wave.binary divui %51, %8 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %411 = wave.binary remui %410, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %412 = wave.binary muli %411, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %413 = wave.binary xori %409, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %414 = wave.binary divui %51, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %415 = wave.binary remui %414, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %416 = wave.binary muli %415, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %417 = wave.binary xori %413, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %418 = wave.binary remui %52, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %419 = wave.binary muli %418, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %420 = wave.binary xori %417, %419 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %421 = wave.binary divui %51, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %422 = wave.binary remui %421, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %423 = wave.binary muli %422, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %424 = wave.binary xori %420, %423 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %425 = wave.binary divui %51, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %426 = wave.binary remui %425, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %427 = wave.binary muli %426, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %428 = wave.binary xori %424, %427 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %429 = wave.binary divui %51, %18 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %430 = wave.binary remui %429, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %431 = wave.binary muli %430, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %432 = wave.binary xori %428, %431 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %433 = wave.binary muli %432, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %434 = wave.ptr_add %404, %433 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %435 = wave.store %value -> %434 after %98 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %436 = wave.barrier %435 : (!wave.mem.token) -> !wave.mem.token
      %437 = wave.shared_memory_base {offset = 133120 : i64} : !wave.ptr<#wave.shared, i8>
      %438 = wave.binary muli %411, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %439 = wave.binary xori %407, %438 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %440 = wave.binary muli %415, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %441 = wave.binary xori %439, %440 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %442 = wave.binary muli %418, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %443 = wave.binary xori %441, %442 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %444 = wave.binary muli %422, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %445 = wave.binary xori %443, %444 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %446 = wave.binary muli %426, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %447 = wave.binary xori %445, %446 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %448 = wave.binary muli %430, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %449 = wave.binary xori %447, %448 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %450 = wave.binary muli %405, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %451 = wave.binary muli %449, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %452 = wave.binary addi %451, %450 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %453 = wave.ptr_add %437, %452 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %454 = wave.store %value_0 -> %453 after %436 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %455 = wave.barrier %454 : (!wave.mem.token) -> !wave.mem.token
      %456 = wave.binary muli %430, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %457 = wave.binary xori %417, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %458 = wave.binary muli %422, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %459 = wave.binary xori %418, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %460 = wave.binary muli %457, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %461 = wave.binary addi %460, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %462 = wave.binary xori %8, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %463 = wave.binary xori %462, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %464 = wave.binary addi %460, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %465 = wave.binary xori %24, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %466 = wave.binary xori %465, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %467 = wave.binary xori %466, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %468 = wave.binary xori %467, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %469 = wave.binary xori %468, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %470 = wave.binary muli %469, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %471 = wave.binary addi %470, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %472 = wave.binary addi %470, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %473 = wave.binary xori %22, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %474 = wave.binary xori %473, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %475 = wave.binary xori %474, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %476 = wave.binary xori %475, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %477 = wave.binary xori %476, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %478 = wave.binary muli %477, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %479 = wave.binary addi %478, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %480 = wave.binary addi %478, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %481 = wave.binary xori %20, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %482 = wave.binary xori %481, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %483 = wave.binary xori %482, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %484 = wave.binary xori %483, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %485 = wave.binary xori %484, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %486 = wave.binary muli %485, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %487 = wave.binary addi %486, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %488 = wave.binary addi %486, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %489 = wave.binary xori %18, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %490 = wave.binary xori %489, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %491 = wave.binary xori %490, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %492 = wave.binary xori %491, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %493 = wave.binary xori %492, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %494 = wave.binary muli %493, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %495 = wave.binary addi %494, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %496 = wave.binary addi %494, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %497 = wave.binary xori %16, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %498 = wave.binary xori %497, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %499 = wave.binary xori %498, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %500 = wave.binary xori %499, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %501 = wave.binary xori %500, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %502 = wave.binary muli %501, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %503 = wave.binary addi %502, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %504 = wave.binary addi %502, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %505 = wave.binary xori %14, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %506 = wave.binary xori %505, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %507 = wave.binary xori %506, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %508 = wave.binary xori %507, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %509 = wave.binary xori %508, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %510 = wave.binary muli %509, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %511 = wave.binary addi %510, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %512 = wave.binary addi %510, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %513 = wave.binary xori %12, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %514 = wave.binary xori %513, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %515 = wave.binary xori %514, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %516 = wave.binary xori %515, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %517 = wave.binary xori %516, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %518 = wave.binary muli %517, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %519 = wave.binary addi %518, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %520 = wave.binary addi %518, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %521 = wave.ptr_add %404, %461 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_90, %token_91 = wave.load %521 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %522 = wave.ptr_add %404, %464 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_92, %token_93 = wave.load %522 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %523 = wave.ptr_add %404, %471 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_94, %token_95 = wave.load %523 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %524 = wave.ptr_add %404, %472 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_96, %token_97 = wave.load %524 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %525 = wave.ptr_add %404, %479 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_98, %token_99 = wave.load %525 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %526 = wave.ptr_add %404, %480 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_100, %token_101 = wave.load %526 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %527 = wave.ptr_add %404, %487 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_102, %token_103 = wave.load %527 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %528 = wave.ptr_add %404, %488 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_104, %token_105 = wave.load %528 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %529 = wave.ptr_add %404, %495 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_106, %token_107 = wave.load %529 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %530 = wave.ptr_add %404, %496 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_108, %token_109 = wave.load %530 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %531 = wave.ptr_add %404, %503 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_110, %token_111 = wave.load %531 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %532 = wave.ptr_add %404, %504 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_112, %token_113 = wave.load %532 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %533 = wave.ptr_add %404, %511 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_114, %token_115 = wave.load %533 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %534 = wave.ptr_add %404, %512 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_116, %token_117 = wave.load %534 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %535 = wave.ptr_add %404, %519 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_118, %token_119 = wave.load %535 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %536 = wave.ptr_add %404, %520 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_120, %token_121 = wave.load %536 after %455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %537 = wave.join %token_91, %token_93, %token_95, %token_97, %token_99, %token_101, %token_103, %token_105, %token_107, %token_109, %token_111, %token_113, %token_115, %token_117, %token_119, %token_121 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %538 = wave.binary muli %426, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %539 = wave.binary xori %417, %538 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %540 = wave.binary muli %539, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %541 = wave.binary addi %540, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %542 = wave.binary addi %540, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %543 = wave.binary xori %468, %538 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %544 = wave.binary muli %543, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %545 = wave.binary addi %544, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %546 = wave.binary addi %544, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %547 = wave.binary xori %476, %538 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %548 = wave.binary muli %547, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %549 = wave.binary addi %548, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %550 = wave.binary addi %548, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %551 = wave.binary xori %484, %538 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %552 = wave.binary muli %551, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %553 = wave.binary addi %552, %459 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %554 = wave.binary addi %552, %463 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %555 = wave.ptr_add %437, %541 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_122, %token_123 = wave.load %555 after %537 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %556 = wave.ptr_add %437, %542 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_124, %token_125 = wave.load %556 after %537 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %557 = wave.ptr_add %437, %545 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_126, %token_127 = wave.load %557 after %537 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %558 = wave.ptr_add %437, %546 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_128, %token_129 = wave.load %558 after %537 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %559 = wave.ptr_add %437, %549 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_130, %token_131 = wave.load %559 after %537 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %560 = wave.ptr_add %437, %550 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_132, %token_133 = wave.load %560 after %537 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %561 = wave.ptr_add %437, %553 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_134, %token_135 = wave.load %561 after %537 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %562 = wave.ptr_add %437, %554 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_136, %token_137 = wave.load %562 after %537 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %563 = wave.join %token_123, %token_125, %token_127, %token_129, %token_131, %token_133, %token_135, %token_137 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %564:139 = scf.for %arg12 = %c0_i32 to %c62_i32 step %c2_i32 iter_args(%arg13 = %c256_i32, %arg14 = %c256_i32, %arg15 = %c16_i32, %arg16 = %c16_i32, %arg17 = %28, %arg18 = %28, %arg19 = %28, %arg20 = %28, %arg21 = %28, %arg22 = %28, %arg23 = %28, %arg24 = %28, %arg25 = %28, %arg26 = %28, %arg27 = %28, %arg28 = %28, %arg29 = %28, %arg30 = %28, %arg31 = %28, %arg32 = %28, %arg33 = %28, %arg34 = %28, %arg35 = %28, %arg36 = %28, %arg37 = %28, %arg38 = %28, %arg39 = %28, %arg40 = %28, %arg41 = %28, %arg42 = %28, %arg43 = %28, %arg44 = %28, %arg45 = %28, %arg46 = %28, %arg47 = %28, %arg48 = %28, %arg49 = %28, %arg50 = %28, %arg51 = %28, %arg52 = %28, %arg53 = %28, %arg54 = %28, %arg55 = %28, %arg56 = %28, %arg57 = %28, %arg58 = %28, %arg59 = %28, %arg60 = %28, %arg61 = %28, %arg62 = %28, %arg63 = %28, %arg64 = %28, %arg65 = %28, %arg66 = %28, %arg67 = %28, %arg68 = %28, %arg69 = %28, %arg70 = %28, %arg71 = %28, %arg72 = %28, %arg73 = %28, %arg74 = %28, %arg75 = %28, %arg76 = %28, %arg77 = %28, %arg78 = %28, %arg79 = %28, %arg80 = %28, %arg81 = %value_2, %arg82 = %value_4, %arg83 = %value_6, %arg84 = %value_8, %arg85 = %value_10, %arg86 = %value_12, %arg87 = %value_14, %arg88 = %value_16, %arg89 = %value_18, %arg90 = %value_20, %arg91 = %value_22, %arg92 = %value_24, %arg93 = %value_26, %arg94 = %value_28, %arg95 = %value_30, %arg96 = %value_32, %arg97 = %value_34, %arg98 = %value_36, %arg99 = %value_38, %arg100 = %value_40, %arg101 = %value_42, %arg102 = %value_44, %arg103 = %value_46, %arg104 = %value_48, %arg105 = %value_50, %arg106 = %value_52, %arg107 = %value_54, %arg108 = %value_56, %arg109 = %value_58, %arg110 = %value_60, %arg111 = %value_62, %arg112 = %value_64, %arg113 = %value_66, %arg114 = %value_68, %arg115 = %value_70, %arg116 = %value_72, %arg117 = %value_74, %arg118 = %value_76, %arg119 = %value_78, %arg120 = %value_80, %arg121 = %value_82, %arg122 = %value_84, %arg123 = %value_86, %arg124 = %value_88, %arg125 = %value_90, %arg126 = %value_92, %arg127 = %value_94, %arg128 = %value_96, %arg129 = %value_98, %arg130 = %value_100, %arg131 = %value_102, %arg132 = %value_104, %arg133 = %value_106, %arg134 = %value_108, %arg135 = %value_110, %arg136 = %value_112, %arg137 = %value_114, %arg138 = %value_116, %arg139 = %value_118, %arg140 = %value_120, %arg141 = %value_122, %arg142 = %value_124, %arg143 = %value_126, %arg144 = %value_128, %arg145 = %value_130, %arg146 = %value_132, %arg147 = %value_134, %arg148 = %value_136, %arg149 = %204, %arg150 = %319, %arg151 = %342) -> (i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %2439 = waveamd.fragment_pack %arg101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2440 = waveamd.fragment_pack %arg102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2441 = waveamd.fragment_pack %arg103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2442 = waveamd.fragment_pack %arg104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2443 = waveamd.fragment_pack %arg105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2444 = waveamd.fragment_pack %arg106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2445 = waveamd.fragment_pack %arg107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2446 = waveamd.fragment_pack %arg108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2447 = waveamd.fragment_pack %arg109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2448 = waveamd.fragment_pack %arg110 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2449 = waveamd.fragment_pack %arg111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2450 = waveamd.fragment_pack %arg112 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2451 = waveamd.fragment_pack %arg113 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2452 = waveamd.fragment_pack %arg114 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2453 = waveamd.fragment_pack %arg115 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2454 = waveamd.fragment_pack %arg116 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2455 = waveamd.fragment_pack %arg117 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2456 = waveamd.fragment_pack %arg118 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2457 = waveamd.fragment_pack %arg119 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2458 = waveamd.fragment_pack %arg120 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2459 = waveamd.fragment_pack %arg121 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2460 = waveamd.fragment_pack %arg122 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2461 = waveamd.fragment_pack %arg123 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2462 = waveamd.fragment_pack %arg124 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2463 = waveamd.fragment_pack %arg17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2464 = waveamd.fragment_pack %arg18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2465 = waveamd.fragment_pack %arg19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2466 = waveamd.fragment_pack %arg20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2467 = waveamd.fragment_pack %arg21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2468 = waveamd.fragment_pack %arg22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2469 = waveamd.fragment_pack %arg23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2470 = waveamd.fragment_pack %arg24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2471 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2472 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2473 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2474 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2475 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2476 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2477 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2478 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2479 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2480 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2481 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2482 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2483 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2484 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2485 = waveamd.fragment_pack %arg39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2486 = waveamd.fragment_pack %arg40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2487 = waveamd.fragment_pack %arg41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2488 = waveamd.fragment_pack %arg42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2489 = waveamd.fragment_pack %arg43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2490 = waveamd.fragment_pack %arg44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2491 = waveamd.fragment_pack %arg45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2492 = waveamd.fragment_pack %arg46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2493 = waveamd.fragment_pack %arg47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2494 = waveamd.fragment_pack %arg48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2495 = wave.pack %arg125, %arg126, %arg127, %arg128, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2496 = wave.pack %arg129, %arg130, %arg131, %arg132, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2497 = wave.pack %arg133, %arg134, %arg135, %arg136, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2498 = wave.pack %arg137, %arg138, %arg139, %arg140, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2499 = wave.pack %arg141, %arg142, %arg143, %arg144, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2500 = wave.pack %arg145, %arg146, %arg147, %arg148, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2501 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2499, %2439, %2495, %2463 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2502 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2499, %2440, %2495, %2501 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2503 = waveamd.fragment_unpack %2502 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2504 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2499, %2439, %2495, %2464 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2505 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2458, %2499, %2440, %2495, %2504 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2506 = waveamd.fragment_unpack %2505 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2507 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2459, %2500, %2439, %2495, %2465 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2508 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2460, %2500, %2440, %2495, %2507 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2509 = waveamd.fragment_unpack %2508 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2510 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2461, %2500, %2439, %2495, %2466 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2511 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2462, %2500, %2440, %2495, %2510 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2512 = waveamd.fragment_unpack %2511 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2513 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2499, %2441, %2495, %2467 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2514 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2499, %2442, %2495, %2513 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2515 = waveamd.fragment_unpack %2514 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2516 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2499, %2441, %2495, %2468 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2517 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2458, %2499, %2442, %2495, %2516 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2518 = waveamd.fragment_unpack %2517 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2519 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2459, %2500, %2441, %2495, %2469 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2520 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2460, %2500, %2442, %2495, %2519 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2521 = waveamd.fragment_unpack %2520 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2522 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2461, %2500, %2441, %2495, %2470 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2523 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2462, %2500, %2442, %2495, %2522 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2524 = waveamd.fragment_unpack %2523 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2525 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2499, %2443, %2496, %2471 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2526 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2499, %2444, %2496, %2525 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2527 = waveamd.fragment_unpack %2526 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2528 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2499, %2443, %2496, %2472 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2529 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2458, %2499, %2444, %2496, %2528 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2530 = waveamd.fragment_unpack %2529 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2531 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2459, %2500, %2443, %2496, %2473 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2532 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2460, %2500, %2444, %2496, %2531 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2533 = waveamd.fragment_unpack %2532 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2534 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2461, %2500, %2443, %2496, %2474 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2535 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2462, %2500, %2444, %2496, %2534 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2536 = waveamd.fragment_unpack %2535 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2537 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2499, %2445, %2496, %2475 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2538 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2499, %2446, %2496, %2537 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2539 = waveamd.fragment_unpack %2538 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2540 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2499, %2445, %2496, %2476 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2541 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2458, %2499, %2446, %2496, %2540 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2542 = waveamd.fragment_unpack %2541 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2543 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2459, %2500, %2445, %2496, %2477 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2544 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2460, %2500, %2446, %2496, %2543 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2545 = waveamd.fragment_unpack %2544 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2546 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2461, %2500, %2445, %2496, %2478 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2547 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2462, %2500, %2446, %2496, %2546 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2548 = waveamd.fragment_unpack %2547 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2549 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2499, %2447, %2497, %2479 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2550 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2499, %2448, %2497, %2549 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2551 = waveamd.fragment_unpack %2550 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2552 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2499, %2447, %2497, %2480 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2553 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2458, %2499, %2448, %2497, %2552 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2554 = waveamd.fragment_unpack %2553 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2555 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2459, %2500, %2447, %2497, %2481 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2556 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2460, %2500, %2448, %2497, %2555 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2557 = waveamd.fragment_unpack %2556 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2558 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2461, %2500, %2447, %2497, %2482 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2559 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2462, %2500, %2448, %2497, %2558 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2560 = waveamd.fragment_unpack %2559 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2561 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2499, %2449, %2497, %2483 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2562 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2499, %2450, %2497, %2561 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2563 = waveamd.fragment_unpack %2562 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2564 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2499, %2449, %2497, %2484 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2565 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2458, %2499, %2450, %2497, %2564 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2566 = waveamd.fragment_unpack %2565 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2567 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2459, %2500, %2449, %2497, %2485 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2568 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2460, %2500, %2450, %2497, %2567 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2569 = waveamd.fragment_unpack %2568 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2570 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2461, %2500, %2449, %2497, %2486 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2571 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2462, %2500, %2450, %2497, %2570 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2572 = waveamd.fragment_unpack %2571 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2573 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2499, %2451, %2498, %2487 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2574 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2499, %2452, %2498, %2573 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2575 = waveamd.fragment_unpack %2574 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2576 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2499, %2451, %2498, %2488 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2577 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2458, %2499, %2452, %2498, %2576 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2578 = waveamd.fragment_unpack %2577 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2579 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2459, %2500, %2451, %2498, %2489 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2580 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2460, %2500, %2452, %2498, %2579 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2581 = waveamd.fragment_unpack %2580 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2582 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2461, %2500, %2451, %2498, %2490 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2583 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2462, %2500, %2452, %2498, %2582 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2584 = waveamd.fragment_unpack %2583 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2585 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2499, %2453, %2498, %2491 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2586 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2499, %2454, %2498, %2585 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2587 = waveamd.fragment_unpack %2586 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2588 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2499, %2453, %2498, %2492 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2458, %2499, %2454, %2498, %2588 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2590 = waveamd.fragment_unpack %2589 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2591 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2459, %2500, %2453, %2498, %2493 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2460, %2500, %2454, %2498, %2591 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2593 = waveamd.fragment_unpack %2592 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2594 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2461, %2500, %2453, %2498, %2494 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2462, %2500, %2454, %2498, %2594 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2596 = waveamd.fragment_unpack %2595 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg149 : !wave.mem.token
        %2597 = wave.barrier %arg149 : (!wave.mem.token) -> !wave.mem.token
        %2598 = wave.ptr_add %182, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_362, %token_363 = wave.load %2598 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2599 = wave.ptr_add %182, %390 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_364, %token_365 = wave.load %2599 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2600 = wave.ptr_add %182, %392 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_366, %token_367 = wave.load %2600 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2601 = wave.ptr_add %182, %394 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_368, %token_369 = wave.load %2601 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2602 = wave.ptr_add %182, %396 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_370, %token_371 = wave.load %2602 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2603 = wave.ptr_add %182, %398 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_372, %token_373 = wave.load %2603 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2604 = wave.ptr_add %182, %400 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_374, %token_375 = wave.load %2604 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2605 = wave.ptr_add %182, %402 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_376, %token_377 = wave.load %2605 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2606 = wave.binary muli %418, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2607 = wave.binary xori %415, %2606 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2608 = wave.binary muli %422, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2609 = wave.binary xori %2607, %2608 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2610 = wave.binary muli %426, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2611 = wave.binary xori %2609, %2610 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2612 = wave.binary xori %2611, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2613 = wave.binary muli %2612, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2614 = wave.binary addi %2613, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2615 = wave.binary xori %24, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2616 = wave.binary xori %2615, %2606 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2617 = wave.binary xori %2616, %2608 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2618 = wave.binary xori %2617, %2610 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2619 = wave.binary xori %2618, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2620 = wave.binary muli %2619, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2621 = wave.binary addi %2620, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2622 = wave.binary xori %22, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2623 = wave.binary xori %2622, %2606 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2624 = wave.binary xori %2623, %2608 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2625 = wave.binary xori %2624, %2610 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2626 = wave.binary xori %2625, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2627 = wave.binary muli %2626, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2628 = wave.binary addi %2627, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2629 = wave.binary xori %20, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2630 = wave.binary xori %2629, %2606 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2631 = wave.binary xori %2630, %2608 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2632 = wave.binary xori %2631, %2610 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2633 = wave.binary xori %2632, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2634 = wave.binary muli %2633, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2635 = wave.binary addi %2634, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2636 = wave.ptr_add %437, %2614 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2637 = wave.store %arg81 -> %2636 after %563 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2638 = wave.ptr_add %437, %2621 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2639 = wave.store %arg82 -> %2638 after %563 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2640 = wave.ptr_add %437, %2628 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2641 = wave.store %arg83 -> %2640 after %563 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2642 = wave.ptr_add %437, %2635 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2643 = wave.store %arg84 -> %2642 after %563 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2644 = wave.barrier %2637, %2639, %2641, %2643 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %value_378, %token_379 = wave.load %555 after %2644 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_380, %token_381 = wave.load %556 after %2644 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_382, %token_383 = wave.load %557 after %2644 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_384, %token_385 = wave.load %558 after %2644 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_386, %token_387 = wave.load %559 after %2644 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_388, %token_389 = wave.load %560 after %2644 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_390, %token_391 = wave.load %561 after %2644 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_392, %token_393 = wave.load %562 after %2644 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2645 = wave.join %token_379, %token_381, %token_383, %token_385, %token_387, %token_389, %token_391, %token_393 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2646 = wave.index_expr <"s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2647 = wave.assume %2646 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2648 = wave.ptr_add %94, %2647 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2649 = waveamd.dma_load_lds %2648 -> %104 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2650 = wave.index_expr <"32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2651 = wave.assume %2650 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2652 = wave.ptr_add %94, %2651 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2653 = waveamd.dma_load_lds %2652 -> %110 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2654 = wave.index_expr <"64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2655 = wave.assume %2654 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2656 = wave.ptr_add %94, %2655 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2657 = waveamd.dma_load_lds %2656 -> %116 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2658 = wave.index_expr <"96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2659 = wave.assume %2658 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2660 = wave.ptr_add %94, %2659 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2661 = waveamd.dma_load_lds %2660 -> %122 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2662 = wave.index_expr <"128*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 128*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2663 = wave.assume %2662 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2664 = wave.ptr_add %94, %2663 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2665 = waveamd.dma_load_lds %2664 -> %128 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2666 = wave.index_expr <"160*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"160*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 160*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2667 = wave.assume %2666 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2668 = wave.ptr_add %94, %2667 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2669 = waveamd.dma_load_lds %2668 -> %134 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2670 = wave.index_expr <"192*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"192*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 192*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2671 = wave.assume %2670 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2672 = wave.ptr_add %94, %2671 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2673 = waveamd.dma_load_lds %2672 -> %140 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2674 = wave.index_expr <"224*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"224*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 224*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2675 = wave.assume %2674 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2676 = wave.ptr_add %94, %2675 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2677 = waveamd.dma_load_lds %2676 -> %146 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2678 = wave.join %2649, %2653, %2657, %2661, %2665, %2669, %2673, %2677 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2679 = wave.index_expr <"s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2680 = wave.assume %2679 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2681 = wave.ptr_add %150, %2680 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2682 = waveamd.dma_load_lds %2681 -> %155 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2683 = wave.index_expr <"32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2684 = wave.assume %2683 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2685 = wave.ptr_add %150, %2684 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2686 = waveamd.dma_load_lds %2685 -> %160 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2687 = wave.index_expr <"64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2688 = wave.assume %2687 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2689 = wave.ptr_add %150, %2688 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2690 = waveamd.dma_load_lds %2689 -> %165 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2691 = wave.index_expr <"96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2692 = wave.assume %2691 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2693 = wave.ptr_add %150, %2692 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2694 = waveamd.dma_load_lds %2693 -> %170 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2695 = wave.join %2682, %2686, %2690, %2694 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2696 = wave.index_expr <"s1 + s0*s2 + s0*(Mod(wi, 2) + 128*Mod(floor(1/128*wi), 2) + 64*Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2) + 8*Mod(floor(1/8*wi), 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2))"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(128*Mod(floor(1/128*wi), 2), xor(64*Mod(floor(1/64*wi), 2), xor(32*Mod(floor(1/32*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2)))))))) >= 0">, #wave.pred<"-2147483640 + s1 + s0*s2 + s0*xor(128*Mod(floor(1/128*wi), 2), xor(64*Mod(floor(1/64*wi), 2), xor(32*Mod(floor(1/32*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2)))))))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2697 = wave.assume %2696 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483640 + x <= 0">] : !wave.simd<index, 64>
        %2698 = wave.ptr_add %173, %2697 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_394, %token_395 = wave.load %2698 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2699 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/32*wi), 2) + 8*s0*Mod(floor(1/16*wi), 2) + 4*s0*Mod(floor(1/8*wi), 2) + 2*s0*Mod(floor(1/4*wi), 2) + s0*Mod(floor(1/2*wi), 2) + 4*Mod(wi, 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/32*wi), 2), xor(8*Mod(floor(1/16*wi), 2), xor(4*Mod(floor(1/8*wi), 2), xor(2*Mod(floor(1/4*wi), 2), Mod(floor(1/2*wi), 2))))))) + 4*Mod(wi, 2) >= 0">, #wave.pred<"-2147483644 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/32*wi), 2), xor(8*Mod(floor(1/16*wi), 2), xor(4*Mod(floor(1/8*wi), 2), xor(2*Mod(floor(1/4*wi), 2), Mod(floor(1/2*wi), 2))))))) + 4*Mod(wi, 2) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2700 = wave.assume %2699 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483644 + x <= 0">] : !wave.simd<index, 64>
        %2701 = wave.ptr_add %177, %2700 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_396, %token_397 = wave.load %2701 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %2702 = wave.join %2678, %2695 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2703 = waveamd.fragment_pack %value_362 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2704 = waveamd.fragment_pack %value_364 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2705 = waveamd.fragment_pack %value_366 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2706 = waveamd.fragment_pack %value_368 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2707 = waveamd.fragment_pack %value_370 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2708 = waveamd.fragment_pack %value_372 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2709 = waveamd.fragment_pack %value_374 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2710 = waveamd.fragment_pack %value_376 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2711 = waveamd.fragment_pack %arg49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2712 = waveamd.fragment_pack %arg50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2713 = waveamd.fragment_pack %arg51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2714 = waveamd.fragment_pack %arg52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2715 = waveamd.fragment_pack %arg53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2716 = waveamd.fragment_pack %arg54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2717 = waveamd.fragment_pack %arg55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2718 = waveamd.fragment_pack %arg56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2719 = waveamd.fragment_pack %arg57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2720 = waveamd.fragment_pack %arg58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2721 = waveamd.fragment_pack %arg59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2722 = waveamd.fragment_pack %arg60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2723 = waveamd.fragment_pack %arg61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2724 = waveamd.fragment_pack %arg62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2725 = waveamd.fragment_pack %arg63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2726 = waveamd.fragment_pack %arg64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2727 = waveamd.fragment_pack %arg65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2728 = waveamd.fragment_pack %arg66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2729 = waveamd.fragment_pack %arg67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2730 = waveamd.fragment_pack %arg68 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2731 = waveamd.fragment_pack %arg69 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2732 = waveamd.fragment_pack %arg70 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2733 = waveamd.fragment_pack %arg71 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2734 = waveamd.fragment_pack %arg72 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2735 = waveamd.fragment_pack %arg73 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2736 = waveamd.fragment_pack %arg74 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2737 = waveamd.fragment_pack %arg75 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2738 = waveamd.fragment_pack %arg76 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2739 = waveamd.fragment_pack %arg77 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2740 = waveamd.fragment_pack %arg78 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2741 = waveamd.fragment_pack %arg79 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2742 = waveamd.fragment_pack %arg80 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2743 = wave.pack %value_378, %value_380, %value_382, %value_384, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2744 = wave.pack %value_386, %value_388, %value_390, %value_392, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2745 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2703, %2743, %2439, %2495, %2711 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2746 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2704, %2743, %2440, %2495, %2745 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2747 = waveamd.fragment_unpack %2746 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2748 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2705, %2743, %2439, %2495, %2712 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2749 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2706, %2743, %2440, %2495, %2748 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2750 = waveamd.fragment_unpack %2749 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2751 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2707, %2744, %2439, %2495, %2713 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2752 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2708, %2744, %2440, %2495, %2751 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2753 = waveamd.fragment_unpack %2752 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2754 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2709, %2744, %2439, %2495, %2714 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2755 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2710, %2744, %2440, %2495, %2754 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2756 = waveamd.fragment_unpack %2755 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2757 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2703, %2743, %2441, %2495, %2715 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2758 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2704, %2743, %2442, %2495, %2757 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2759 = waveamd.fragment_unpack %2758 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2760 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2705, %2743, %2441, %2495, %2716 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2761 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2706, %2743, %2442, %2495, %2760 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2762 = waveamd.fragment_unpack %2761 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2763 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2707, %2744, %2441, %2495, %2717 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2764 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2708, %2744, %2442, %2495, %2763 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2765 = waveamd.fragment_unpack %2764 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2766 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2709, %2744, %2441, %2495, %2718 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2767 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2710, %2744, %2442, %2495, %2766 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2768 = waveamd.fragment_unpack %2767 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2769 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2703, %2743, %2443, %2496, %2719 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2770 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2704, %2743, %2444, %2496, %2769 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2771 = waveamd.fragment_unpack %2770 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2772 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2705, %2743, %2443, %2496, %2720 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2773 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2706, %2743, %2444, %2496, %2772 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2774 = waveamd.fragment_unpack %2773 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2775 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2707, %2744, %2443, %2496, %2721 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2776 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2708, %2744, %2444, %2496, %2775 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2777 = waveamd.fragment_unpack %2776 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2778 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2709, %2744, %2443, %2496, %2722 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2779 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2710, %2744, %2444, %2496, %2778 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2780 = waveamd.fragment_unpack %2779 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2781 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2703, %2743, %2445, %2496, %2723 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2782 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2704, %2743, %2446, %2496, %2781 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2783 = waveamd.fragment_unpack %2782 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2784 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2705, %2743, %2445, %2496, %2724 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2785 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2706, %2743, %2446, %2496, %2784 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2786 = waveamd.fragment_unpack %2785 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2787 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2707, %2744, %2445, %2496, %2725 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2788 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2708, %2744, %2446, %2496, %2787 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2789 = waveamd.fragment_unpack %2788 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2790 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2709, %2744, %2445, %2496, %2726 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2791 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2710, %2744, %2446, %2496, %2790 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2792 = waveamd.fragment_unpack %2791 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2793 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2703, %2743, %2447, %2497, %2727 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2794 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2704, %2743, %2448, %2497, %2793 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2795 = waveamd.fragment_unpack %2794 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2796 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2705, %2743, %2447, %2497, %2728 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2797 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2706, %2743, %2448, %2497, %2796 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2798 = waveamd.fragment_unpack %2797 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2799 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2707, %2744, %2447, %2497, %2729 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2800 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2708, %2744, %2448, %2497, %2799 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2801 = waveamd.fragment_unpack %2800 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2802 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2709, %2744, %2447, %2497, %2730 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2803 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2710, %2744, %2448, %2497, %2802 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2804 = waveamd.fragment_unpack %2803 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2805 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2703, %2743, %2449, %2497, %2731 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2806 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2704, %2743, %2450, %2497, %2805 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2807 = waveamd.fragment_unpack %2806 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2808 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2705, %2743, %2449, %2497, %2732 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2809 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2706, %2743, %2450, %2497, %2808 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2810 = waveamd.fragment_unpack %2809 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2811 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2707, %2744, %2449, %2497, %2733 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2812 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2708, %2744, %2450, %2497, %2811 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2813 = waveamd.fragment_unpack %2812 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2814 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2709, %2744, %2449, %2497, %2734 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2815 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2710, %2744, %2450, %2497, %2814 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2816 = waveamd.fragment_unpack %2815 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2817 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2703, %2743, %2451, %2498, %2735 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2818 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2704, %2743, %2452, %2498, %2817 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2819 = waveamd.fragment_unpack %2818 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2820 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2705, %2743, %2451, %2498, %2736 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2821 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2706, %2743, %2452, %2498, %2820 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2822 = waveamd.fragment_unpack %2821 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2823 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2707, %2744, %2451, %2498, %2737 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2824 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2708, %2744, %2452, %2498, %2823 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2825 = waveamd.fragment_unpack %2824 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2826 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2709, %2744, %2451, %2498, %2738 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2827 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2710, %2744, %2452, %2498, %2826 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2828 = waveamd.fragment_unpack %2827 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2829 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2703, %2743, %2453, %2498, %2739 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2830 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2704, %2743, %2454, %2498, %2829 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2831 = waveamd.fragment_unpack %2830 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2832 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2705, %2743, %2453, %2498, %2740 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2833 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2706, %2743, %2454, %2498, %2832 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2834 = waveamd.fragment_unpack %2833 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2835 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2707, %2744, %2453, %2498, %2741 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2836 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2708, %2744, %2454, %2498, %2835 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2837 = waveamd.fragment_unpack %2836 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2838 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2709, %2744, %2453, %2498, %2742 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2839 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2710, %2744, %2454, %2498, %2838 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2840 = waveamd.fragment_unpack %2839 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg150 : !wave.mem.token
        %2841 = wave.barrier %arg150 : (!wave.mem.token) -> !wave.mem.token
        %2842 = wave.ptr_add %217, %356 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_398, %token_399 = wave.load %2842 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2843 = wave.ptr_add %217, %358 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_400, %token_401 = wave.load %2843 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2844 = wave.ptr_add %217, %360 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_402, %token_403 = wave.load %2844 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2845 = wave.ptr_add %217, %362 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_404, %token_405 = wave.load %2845 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2846 = wave.ptr_add %217, %364 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_406, %token_407 = wave.load %2846 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2847 = wave.ptr_add %217, %366 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_408, %token_409 = wave.load %2847 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2848 = wave.ptr_add %217, %368 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_410, %token_411 = wave.load %2848 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2849 = wave.ptr_add %217, %370 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_412, %token_413 = wave.load %2849 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2850 = wave.ptr_add %217, %372 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_414, %token_415 = wave.load %2850 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2851 = wave.ptr_add %217, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_416, %token_417 = wave.load %2851 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2852 = wave.ptr_add %217, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_418, %token_419 = wave.load %2852 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2853 = wave.ptr_add %217, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_420, %token_421 = wave.load %2853 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2854 = wave.ptr_add %217, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_422, %token_423 = wave.load %2854 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2855 = wave.ptr_add %217, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_424, %token_425 = wave.load %2855 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2856 = wave.ptr_add %217, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_426, %token_427 = wave.load %2856 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2857 = wave.ptr_add %217, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_428, %token_429 = wave.load %2857 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2858 = wave.ptr_add %260, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_430, %token_431 = wave.load %2858 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2859 = wave.ptr_add %260, %390 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_432, %token_433 = wave.load %2859 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2860 = wave.ptr_add %260, %392 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_434, %token_435 = wave.load %2860 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2861 = wave.ptr_add %260, %394 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_436, %token_437 = wave.load %2861 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2862 = wave.ptr_add %260, %396 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_438, %token_439 = wave.load %2862 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2863 = wave.ptr_add %260, %398 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_440, %token_441 = wave.load %2863 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2864 = wave.ptr_add %260, %400 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_442, %token_443 = wave.load %2864 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2865 = wave.ptr_add %260, %402 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_444, %token_445 = wave.load %2865 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2866 = wave.binary xori %18, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2867 = wave.binary xori %2866, %2606 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2868 = wave.binary xori %2867, %2608 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2869 = wave.binary xori %2868, %2610 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2870 = wave.binary xori %2869, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2871 = wave.binary muli %2870, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2872 = wave.binary addi %2871, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2873 = wave.binary xori %16, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2874 = wave.binary xori %2873, %2606 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2875 = wave.binary xori %2874, %2608 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2876 = wave.binary xori %2875, %2610 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2877 = wave.binary xori %2876, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2878 = wave.binary muli %2877, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2879 = wave.binary addi %2878, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2880 = wave.binary xori %14, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2881 = wave.binary xori %2880, %2606 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2882 = wave.binary xori %2881, %2608 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2883 = wave.binary xori %2882, %2610 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2884 = wave.binary xori %2883, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2885 = wave.binary muli %2884, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2886 = wave.binary addi %2885, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2887 = wave.binary xori %12, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2888 = wave.binary xori %2887, %2606 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2889 = wave.binary xori %2888, %2608 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2890 = wave.binary xori %2889, %2610 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2891 = wave.binary xori %2890, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2892 = wave.binary muli %2891, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2893 = wave.binary addi %2892, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2894 = wave.ptr_add %404, %2614 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2895 = wave.store %arg85 -> %2894 after %2645 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2896 = wave.ptr_add %404, %2621 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2897 = wave.store %arg86 -> %2896 after %2645 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2898 = wave.ptr_add %404, %2628 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2899 = wave.store %arg87 -> %2898 after %2645 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2900 = wave.ptr_add %404, %2635 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2901 = wave.store %arg88 -> %2900 after %2645 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2902 = wave.ptr_add %404, %2872 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2903 = wave.store %arg89 -> %2902 after %2645 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2904 = wave.ptr_add %404, %2879 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2905 = wave.store %arg90 -> %2904 after %2645 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2906 = wave.ptr_add %404, %2886 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2907 = wave.store %arg91 -> %2906 after %2645 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2908 = wave.ptr_add %404, %2893 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2909 = wave.store %arg92 -> %2908 after %2645 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2910 = wave.barrier %2895, %2897, %2899, %2901, %2903, %2905, %2907, %2909 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %2911 = wave.store %arg93 -> %2636 after %2910 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2912 = wave.store %arg94 -> %2638 after %2910 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2913 = wave.store %arg95 -> %2640 after %2910 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2914 = wave.store %arg96 -> %2642 after %2910 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2915 = wave.barrier %2911, %2912, %2913, %2914 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %value_446, %token_447 = wave.load %521 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_448, %token_449 = wave.load %522 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_450, %token_451 = wave.load %523 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_452, %token_453 = wave.load %524 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_454, %token_455 = wave.load %525 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_456, %token_457 = wave.load %526 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_458, %token_459 = wave.load %527 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_460, %token_461 = wave.load %528 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_462, %token_463 = wave.load %529 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_464, %token_465 = wave.load %530 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_466, %token_467 = wave.load %531 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_468, %token_469 = wave.load %532 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_470, %token_471 = wave.load %533 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_472, %token_473 = wave.load %534 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_474, %token_475 = wave.load %535 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_476, %token_477 = wave.load %536 after %2915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2916 = wave.join %token_447, %token_449, %token_451, %token_453, %token_455, %token_457, %token_459, %token_461, %token_463, %token_465, %token_467, %token_469, %token_471, %token_473, %token_475, %token_477 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_478, %token_479 = wave.load %555 after %2916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_480, %token_481 = wave.load %556 after %2916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_482, %token_483 = wave.load %557 after %2916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_484, %token_485 = wave.load %558 after %2916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_486, %token_487 = wave.load %559 after %2916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_488, %token_489 = wave.load %560 after %2916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_490, %token_491 = wave.load %561 after %2916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_492, %token_493 = wave.load %562 after %2916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2917 = wave.join %token_479, %token_481, %token_483, %token_485, %token_487, %token_489, %token_491, %token_493 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2918 = wave.index_expr <"s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg8, %91, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %2919 = wave.assume %2918 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2920 = wave.ptr_add %150, %2919 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2921 = waveamd.dma_load_lds %2920 -> %187 after %arg150 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2922 = wave.index_expr <"32*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"32*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 32*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg8, %91, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %2923 = wave.assume %2922 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2924 = wave.ptr_add %150, %2923 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2925 = waveamd.dma_load_lds %2924 -> %192 after %arg150 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2926 = wave.index_expr <"64*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"64*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 64*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg8, %91, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %2927 = wave.assume %2926 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2928 = wave.ptr_add %150, %2927 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2929 = waveamd.dma_load_lds %2928 -> %197 after %arg150 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2930 = wave.index_expr <"96*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"96*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483632 + 96*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg8, %91, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %2931 = wave.assume %2930 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %2932 = wave.ptr_add %150, %2931 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2933 = waveamd.dma_load_lds %2932 -> %202 after %arg150 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2934 = wave.join %2921, %2925, %2929, %2933 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2935 = wave.index_expr <"s1 + s2 + s0*s3 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg11, %92, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %2936 = wave.index_expr <"s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg11, %92, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %2937 = wave.index_expr <"s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg11, %92, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %2938 = wave.index_expr <"s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg11, %92, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %2939 = wave.assume %2935 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %2940 = wave.ptr_add %177, %2939 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_494, %token_495 = wave.load %2940 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2941 = wave.assume %2936 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %2942 = wave.ptr_add %177, %2941 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_496, %token_497 = wave.load %2942 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2943 = wave.assume %2937 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %2944 = wave.ptr_add %177, %2943 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_498, %token_499 = wave.load %2944 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2945 = wave.assume %2938 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %2946 = wave.ptr_add %177, %2945 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_500, %token_501 = wave.load %2946 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2947 = waveamd.fragment_pack %value_398 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2948 = waveamd.fragment_pack %value_400 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2949 = waveamd.fragment_pack %value_402 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2950 = waveamd.fragment_pack %value_404 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2951 = waveamd.fragment_pack %value_406 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2952 = waveamd.fragment_pack %value_408 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2953 = waveamd.fragment_pack %value_410 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2954 = waveamd.fragment_pack %value_412 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2955 = waveamd.fragment_pack %value_414 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2956 = waveamd.fragment_pack %value_416 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2957 = waveamd.fragment_pack %value_418 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2958 = waveamd.fragment_pack %value_420 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2959 = waveamd.fragment_pack %value_422 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2960 = waveamd.fragment_pack %value_424 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2961 = waveamd.fragment_pack %value_426 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2962 = waveamd.fragment_pack %value_428 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2963 = waveamd.fragment_pack %value_430 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2964 = waveamd.fragment_pack %value_432 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2965 = waveamd.fragment_pack %value_434 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2966 = waveamd.fragment_pack %value_436 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2967 = waveamd.fragment_pack %value_438 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2968 = waveamd.fragment_pack %value_440 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2969 = waveamd.fragment_pack %value_442 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2970 = waveamd.fragment_pack %value_444 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2971 = waveamd.fragment_pack %2503 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2972 = waveamd.fragment_pack %2506 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2973 = waveamd.fragment_pack %2509 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2974 = waveamd.fragment_pack %2512 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2975 = waveamd.fragment_pack %2515 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2976 = waveamd.fragment_pack %2518 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2977 = waveamd.fragment_pack %2521 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2978 = waveamd.fragment_pack %2524 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2979 = waveamd.fragment_pack %2527 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2980 = waveamd.fragment_pack %2530 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2981 = waveamd.fragment_pack %2533 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2982 = waveamd.fragment_pack %2536 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2983 = waveamd.fragment_pack %2539 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2984 = waveamd.fragment_pack %2542 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2985 = waveamd.fragment_pack %2545 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2986 = waveamd.fragment_pack %2548 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2987 = waveamd.fragment_pack %2551 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2988 = waveamd.fragment_pack %2554 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2989 = waveamd.fragment_pack %2557 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2990 = waveamd.fragment_pack %2560 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2991 = waveamd.fragment_pack %2563 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2992 = waveamd.fragment_pack %2566 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2993 = waveamd.fragment_pack %2569 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2994 = waveamd.fragment_pack %2572 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2995 = waveamd.fragment_pack %2575 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2996 = waveamd.fragment_pack %2578 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2997 = waveamd.fragment_pack %2581 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2998 = waveamd.fragment_pack %2584 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2999 = waveamd.fragment_pack %2587 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3000 = waveamd.fragment_pack %2590 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3001 = waveamd.fragment_pack %2593 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3002 = waveamd.fragment_pack %2596 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3003 = wave.pack %value_446, %value_448, %value_450, %value_452, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3004 = wave.pack %value_454, %value_456, %value_458, %value_460, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3005 = wave.pack %value_462, %value_464, %value_466, %value_468, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3006 = wave.pack %value_470, %value_472, %value_474, %value_476, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3007 = wave.pack %value_478, %value_480, %value_482, %value_484, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3008 = wave.pack %value_486, %value_488, %value_490, %value_492, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3009 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2963, %3007, %2947, %3003, %2971 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3010 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2964, %3007, %2948, %3003, %3009 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3011 = waveamd.fragment_unpack %3010 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3012 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2965, %3007, %2947, %3003, %2972 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3013 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2966, %3007, %2948, %3003, %3012 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3014 = waveamd.fragment_unpack %3013 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3015 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2967, %3008, %2947, %3003, %2973 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3016 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2968, %3008, %2948, %3003, %3015 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3017 = waveamd.fragment_unpack %3016 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3018 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2969, %3008, %2947, %3003, %2974 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3019 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2970, %3008, %2948, %3003, %3018 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3020 = waveamd.fragment_unpack %3019 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3021 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2963, %3007, %2949, %3003, %2975 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3022 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2964, %3007, %2950, %3003, %3021 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3023 = waveamd.fragment_unpack %3022 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3024 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2965, %3007, %2949, %3003, %2976 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3025 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2966, %3007, %2950, %3003, %3024 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3026 = waveamd.fragment_unpack %3025 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3027 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2967, %3008, %2949, %3003, %2977 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3028 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2968, %3008, %2950, %3003, %3027 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3029 = waveamd.fragment_unpack %3028 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3030 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2969, %3008, %2949, %3003, %2978 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3031 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2970, %3008, %2950, %3003, %3030 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3032 = waveamd.fragment_unpack %3031 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3033 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2963, %3007, %2951, %3004, %2979 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3034 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2964, %3007, %2952, %3004, %3033 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3035 = waveamd.fragment_unpack %3034 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3036 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2965, %3007, %2951, %3004, %2980 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3037 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2966, %3007, %2952, %3004, %3036 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3038 = waveamd.fragment_unpack %3037 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3039 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2967, %3008, %2951, %3004, %2981 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3040 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2968, %3008, %2952, %3004, %3039 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3041 = waveamd.fragment_unpack %3040 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3042 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2969, %3008, %2951, %3004, %2982 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3043 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2970, %3008, %2952, %3004, %3042 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3044 = waveamd.fragment_unpack %3043 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3045 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2963, %3007, %2953, %3004, %2983 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3046 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2964, %3007, %2954, %3004, %3045 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3047 = waveamd.fragment_unpack %3046 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3048 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2965, %3007, %2953, %3004, %2984 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3049 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2966, %3007, %2954, %3004, %3048 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3050 = waveamd.fragment_unpack %3049 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3051 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2967, %3008, %2953, %3004, %2985 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3052 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2968, %3008, %2954, %3004, %3051 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3053 = waveamd.fragment_unpack %3052 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3054 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2969, %3008, %2953, %3004, %2986 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3055 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2970, %3008, %2954, %3004, %3054 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3056 = waveamd.fragment_unpack %3055 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3057 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2963, %3007, %2955, %3005, %2987 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3058 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2964, %3007, %2956, %3005, %3057 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3059 = waveamd.fragment_unpack %3058 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3060 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2965, %3007, %2955, %3005, %2988 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3061 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2966, %3007, %2956, %3005, %3060 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3062 = waveamd.fragment_unpack %3061 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3063 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2967, %3008, %2955, %3005, %2989 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3064 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2968, %3008, %2956, %3005, %3063 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3065 = waveamd.fragment_unpack %3064 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3066 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2969, %3008, %2955, %3005, %2990 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3067 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2970, %3008, %2956, %3005, %3066 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3068 = waveamd.fragment_unpack %3067 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3069 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2963, %3007, %2957, %3005, %2991 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3070 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2964, %3007, %2958, %3005, %3069 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3071 = waveamd.fragment_unpack %3070 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3072 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2965, %3007, %2957, %3005, %2992 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3073 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2966, %3007, %2958, %3005, %3072 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3074 = waveamd.fragment_unpack %3073 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3075 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2967, %3008, %2957, %3005, %2993 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3076 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2968, %3008, %2958, %3005, %3075 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3077 = waveamd.fragment_unpack %3076 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3078 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2969, %3008, %2957, %3005, %2994 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3079 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2970, %3008, %2958, %3005, %3078 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3080 = waveamd.fragment_unpack %3079 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3081 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2963, %3007, %2959, %3006, %2995 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3082 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2964, %3007, %2960, %3006, %3081 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3083 = waveamd.fragment_unpack %3082 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3084 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2965, %3007, %2959, %3006, %2996 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3085 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2966, %3007, %2960, %3006, %3084 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3086 = waveamd.fragment_unpack %3085 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3087 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2967, %3008, %2959, %3006, %2997 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3088 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2968, %3008, %2960, %3006, %3087 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3089 = waveamd.fragment_unpack %3088 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3090 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2969, %3008, %2959, %3006, %2998 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3091 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2970, %3008, %2960, %3006, %3090 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3092 = waveamd.fragment_unpack %3091 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3093 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2963, %3007, %2961, %3006, %2999 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3094 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2964, %3007, %2962, %3006, %3093 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3095 = waveamd.fragment_unpack %3094 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3096 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2965, %3007, %2961, %3006, %3000 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3097 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2966, %3007, %2962, %3006, %3096 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3098 = waveamd.fragment_unpack %3097 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3099 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2967, %3008, %2961, %3006, %3001 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3100 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2968, %3008, %2962, %3006, %3099 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3101 = waveamd.fragment_unpack %3100 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3102 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2969, %3008, %2961, %3006, %3002 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3103 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2970, %3008, %2962, %3006, %3102 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3104 = waveamd.fragment_unpack %3103 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg151 : !wave.mem.token
        %3105 = wave.barrier %arg151 : (!wave.mem.token) -> !wave.mem.token
        %3106 = wave.ptr_add %320, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_502, %token_503 = wave.load %3106 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3107 = wave.ptr_add %320, %390 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_504, %token_505 = wave.load %3107 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3108 = wave.ptr_add %320, %392 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_506, %token_507 = wave.load %3108 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3109 = wave.ptr_add %320, %394 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_508, %token_509 = wave.load %3109 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3110 = wave.ptr_add %320, %396 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_510, %token_511 = wave.load %3110 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3111 = wave.ptr_add %320, %398 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_512, %token_513 = wave.load %3111 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3112 = wave.ptr_add %320, %400 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_514, %token_515 = wave.load %3112 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3113 = wave.ptr_add %320, %402 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_516, %token_517 = wave.load %3113 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3114 = wave.store %arg97 -> %2636 after %2917 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %3115 = wave.store %arg98 -> %2638 after %2917 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %3116 = wave.store %arg99 -> %2640 after %2917 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %3117 = wave.store %arg100 -> %2642 after %2917 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %3118 = wave.barrier %3114, %3115, %3116, %3117 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %value_518, %token_519 = wave.load %555 after %3118 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_520, %token_521 = wave.load %556 after %3118 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_522, %token_523 = wave.load %557 after %3118 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_524, %token_525 = wave.load %558 after %3118 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_526, %token_527 = wave.load %559 after %3118 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_528, %token_529 = wave.load %560 after %3118 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_530, %token_531 = wave.load %561 after %3118 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_532, %token_533 = wave.load %562 after %3118 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3119 = wave.join %token_519, %token_521, %token_523, %token_525, %token_527, %token_529, %token_531, %token_533 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3120 = wave.index_expr <"128 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3121 = wave.assume %3120 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3122 = wave.ptr_add %94, %3121 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3123 = waveamd.dma_load_lds %3122 -> %222 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3124 = wave.index_expr <"128 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3125 = wave.assume %3124 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3126 = wave.ptr_add %94, %3125 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3127 = waveamd.dma_load_lds %3126 -> %227 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3128 = wave.index_expr <"128 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3129 = wave.assume %3128 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3130 = wave.ptr_add %94, %3129 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3131 = waveamd.dma_load_lds %3130 -> %232 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3132 = wave.index_expr <"128 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3133 = wave.assume %3132 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3134 = wave.ptr_add %94, %3133 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3135 = waveamd.dma_load_lds %3134 -> %237 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3136 = wave.index_expr <"128 + 128*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 128*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 128*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3137 = wave.assume %3136 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3138 = wave.ptr_add %94, %3137 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3139 = waveamd.dma_load_lds %3138 -> %242 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3140 = wave.index_expr <"128 + 160*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 160*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 160*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3141 = wave.assume %3140 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3142 = wave.ptr_add %94, %3141 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3143 = waveamd.dma_load_lds %3142 -> %247 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3144 = wave.index_expr <"128 + 192*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 192*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 192*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3145 = wave.assume %3144 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3146 = wave.ptr_add %94, %3145 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3147 = waveamd.dma_load_lds %3146 -> %252 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3148 = wave.index_expr <"128 + 224*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 224*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 224*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg7, %arg13, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3149 = wave.assume %3148 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3150 = wave.ptr_add %94, %3149 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3151 = waveamd.dma_load_lds %3150 -> %257 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3152 = wave.join %3123, %3127, %3131, %3135, %3139, %3143, %3147, %3151 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3153 = wave.index_expr <"128 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3154 = wave.assume %3153 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3155 = wave.ptr_add %150, %3154 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3156 = waveamd.dma_load_lds %3155 -> %265 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3157 = wave.index_expr <"128 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 32*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3158 = wave.assume %3157 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3159 = wave.ptr_add %150, %3158 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3160 = waveamd.dma_load_lds %3159 -> %270 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3161 = wave.index_expr <"128 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 64*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3162 = wave.assume %3161 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3163 = wave.ptr_add %150, %3162 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3164 = waveamd.dma_load_lds %3163 -> %275 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3165 = wave.index_expr <"128 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 96*s0 + s1 + s0*s2 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg8, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3166 = wave.assume %3165 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3167 = wave.ptr_add %150, %3166 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3168 = waveamd.dma_load_lds %3167 -> %280 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3169 = wave.join %3156, %3160, %3164, %3168 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3170 = wave.index_expr <"8 + s1 + s0*s2 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3171 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3172 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3173 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3174 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(128 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3175 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(160 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3176 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(192 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3177 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(224 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg10, %arg15, %50) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3178 = wave.assume %3170 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3179 = wave.ptr_add %173, %3178 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_534, %token_535 = wave.load %3179 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3180 = wave.assume %3171 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3181 = wave.ptr_add %173, %3180 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_536, %token_537 = wave.load %3181 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3182 = wave.assume %3172 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3183 = wave.ptr_add %173, %3182 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_538, %token_539 = wave.load %3183 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3184 = wave.assume %3173 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3185 = wave.ptr_add %173, %3184 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_540, %token_541 = wave.load %3185 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3186 = wave.assume %3174 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3187 = wave.ptr_add %173, %3186 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_542, %token_543 = wave.load %3187 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3188 = wave.assume %3175 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3189 = wave.ptr_add %173, %3188 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_544, %token_545 = wave.load %3189 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3190 = wave.assume %3176 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3191 = wave.ptr_add %173, %3190 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_546, %token_547 = wave.load %3191 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3192 = wave.assume %3177 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3193 = wave.ptr_add %173, %3192 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_548, %token_549 = wave.load %3193 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3194 = wave.index_expr <"8 + s1 + s0*s2 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3195 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3196 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3197 = wave.index_expr <"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2"](%51, %arg11, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3198 = wave.assume %3194 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3199 = wave.ptr_add %177, %3198 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_550, %token_551 = wave.load %3199 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3200 = wave.assume %3195 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3201 = wave.ptr_add %177, %3200 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_552, %token_553 = wave.load %3201 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3202 = wave.assume %3196 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3203 = wave.ptr_add %177, %3202 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_554, %token_555 = wave.load %3203 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3204 = wave.assume %3197 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3205 = wave.ptr_add %177, %3204 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_556, %token_557 = wave.load %3205 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3206 = wave.join %3152, %3169 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3207 = waveamd.fragment_pack %value_502 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3208 = waveamd.fragment_pack %value_504 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3209 = waveamd.fragment_pack %value_506 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3210 = waveamd.fragment_pack %value_508 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3211 = waveamd.fragment_pack %value_510 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3212 = waveamd.fragment_pack %value_512 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3213 = waveamd.fragment_pack %value_514 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3214 = waveamd.fragment_pack %value_516 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3215 = waveamd.fragment_pack %2747 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3216 = waveamd.fragment_pack %2750 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3217 = waveamd.fragment_pack %2753 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3218 = waveamd.fragment_pack %2756 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3219 = waveamd.fragment_pack %2759 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3220 = waveamd.fragment_pack %2762 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3221 = waveamd.fragment_pack %2765 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3222 = waveamd.fragment_pack %2768 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3223 = waveamd.fragment_pack %2771 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3224 = waveamd.fragment_pack %2774 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3225 = waveamd.fragment_pack %2777 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3226 = waveamd.fragment_pack %2780 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3227 = waveamd.fragment_pack %2783 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3228 = waveamd.fragment_pack %2786 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3229 = waveamd.fragment_pack %2789 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3230 = waveamd.fragment_pack %2792 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3231 = waveamd.fragment_pack %2795 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3232 = waveamd.fragment_pack %2798 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3233 = waveamd.fragment_pack %2801 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3234 = waveamd.fragment_pack %2804 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3235 = waveamd.fragment_pack %2807 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3236 = waveamd.fragment_pack %2810 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3237 = waveamd.fragment_pack %2813 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3238 = waveamd.fragment_pack %2816 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3239 = waveamd.fragment_pack %2819 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3240 = waveamd.fragment_pack %2822 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3241 = waveamd.fragment_pack %2825 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3242 = waveamd.fragment_pack %2828 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3243 = waveamd.fragment_pack %2831 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3244 = waveamd.fragment_pack %2834 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3245 = waveamd.fragment_pack %2837 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3246 = waveamd.fragment_pack %2840 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3247 = wave.pack %value_518, %value_520, %value_522, %value_524, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3248 = wave.pack %value_526, %value_528, %value_530, %value_532, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3249 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3207, %3247, %2947, %3003, %3215 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3250 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3208, %3247, %2948, %3003, %3249 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3251 = waveamd.fragment_unpack %3250 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3252 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3209, %3247, %2947, %3003, %3216 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3253 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3210, %3247, %2948, %3003, %3252 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3254 = waveamd.fragment_unpack %3253 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3255 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3211, %3248, %2947, %3003, %3217 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3256 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3212, %3248, %2948, %3003, %3255 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3257 = waveamd.fragment_unpack %3256 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3258 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3213, %3248, %2947, %3003, %3218 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3259 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3214, %3248, %2948, %3003, %3258 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3260 = waveamd.fragment_unpack %3259 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3261 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3207, %3247, %2949, %3003, %3219 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3262 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3208, %3247, %2950, %3003, %3261 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3263 = waveamd.fragment_unpack %3262 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3264 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3209, %3247, %2949, %3003, %3220 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3265 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3210, %3247, %2950, %3003, %3264 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3266 = waveamd.fragment_unpack %3265 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3267 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3211, %3248, %2949, %3003, %3221 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3268 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3212, %3248, %2950, %3003, %3267 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3269 = waveamd.fragment_unpack %3268 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3270 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3213, %3248, %2949, %3003, %3222 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3271 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3214, %3248, %2950, %3003, %3270 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3272 = waveamd.fragment_unpack %3271 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3273 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3207, %3247, %2951, %3004, %3223 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3274 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3208, %3247, %2952, %3004, %3273 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3275 = waveamd.fragment_unpack %3274 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3276 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3209, %3247, %2951, %3004, %3224 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3277 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3210, %3247, %2952, %3004, %3276 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3278 = waveamd.fragment_unpack %3277 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3279 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3211, %3248, %2951, %3004, %3225 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3280 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3212, %3248, %2952, %3004, %3279 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3281 = waveamd.fragment_unpack %3280 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3282 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3213, %3248, %2951, %3004, %3226 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3283 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3214, %3248, %2952, %3004, %3282 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3284 = waveamd.fragment_unpack %3283 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3285 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3207, %3247, %2953, %3004, %3227 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3286 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3208, %3247, %2954, %3004, %3285 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3287 = waveamd.fragment_unpack %3286 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3288 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3209, %3247, %2953, %3004, %3228 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3289 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3210, %3247, %2954, %3004, %3288 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3290 = waveamd.fragment_unpack %3289 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3291 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3211, %3248, %2953, %3004, %3229 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3292 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3212, %3248, %2954, %3004, %3291 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3293 = waveamd.fragment_unpack %3292 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3294 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3213, %3248, %2953, %3004, %3230 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3295 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3214, %3248, %2954, %3004, %3294 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3296 = waveamd.fragment_unpack %3295 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3297 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3207, %3247, %2955, %3005, %3231 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3298 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3208, %3247, %2956, %3005, %3297 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3299 = waveamd.fragment_unpack %3298 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3300 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3209, %3247, %2955, %3005, %3232 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3301 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3210, %3247, %2956, %3005, %3300 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3302 = waveamd.fragment_unpack %3301 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3303 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3211, %3248, %2955, %3005, %3233 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3304 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3212, %3248, %2956, %3005, %3303 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3305 = waveamd.fragment_unpack %3304 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3306 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3213, %3248, %2955, %3005, %3234 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3307 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3214, %3248, %2956, %3005, %3306 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3308 = waveamd.fragment_unpack %3307 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3309 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3207, %3247, %2957, %3005, %3235 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3310 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3208, %3247, %2958, %3005, %3309 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3311 = waveamd.fragment_unpack %3310 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3312 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3209, %3247, %2957, %3005, %3236 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3313 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3210, %3247, %2958, %3005, %3312 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3314 = waveamd.fragment_unpack %3313 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3315 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3211, %3248, %2957, %3005, %3237 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3316 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3212, %3248, %2958, %3005, %3315 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3317 = waveamd.fragment_unpack %3316 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3318 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3213, %3248, %2957, %3005, %3238 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3319 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3214, %3248, %2958, %3005, %3318 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3320 = waveamd.fragment_unpack %3319 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3321 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3207, %3247, %2959, %3006, %3239 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3322 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3208, %3247, %2960, %3006, %3321 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3323 = waveamd.fragment_unpack %3322 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3324 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3209, %3247, %2959, %3006, %3240 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3325 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3210, %3247, %2960, %3006, %3324 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3326 = waveamd.fragment_unpack %3325 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3327 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3211, %3248, %2959, %3006, %3241 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3328 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3212, %3248, %2960, %3006, %3327 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3329 = waveamd.fragment_unpack %3328 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3330 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3213, %3248, %2959, %3006, %3242 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3331 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3214, %3248, %2960, %3006, %3330 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3332 = waveamd.fragment_unpack %3331 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3333 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3207, %3247, %2961, %3006, %3243 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3334 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3208, %3247, %2962, %3006, %3333 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3335 = waveamd.fragment_unpack %3334 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3336 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3209, %3247, %2961, %3006, %3244 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3337 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3210, %3247, %2962, %3006, %3336 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3338 = waveamd.fragment_unpack %3337 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3339 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3211, %3248, %2961, %3006, %3245 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3340 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3212, %3248, %2962, %3006, %3339 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3341 = waveamd.fragment_unpack %3340 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3342 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3213, %3248, %2961, %3006, %3246 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3343 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3214, %3248, %2962, %3006, %3342 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3344 = waveamd.fragment_unpack %3343 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %2702 : !wave.mem.token
        %3345 = wave.barrier %2702 : (!wave.mem.token) -> !wave.mem.token
        %value_558, %token_559 = wave.load %357 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_560, %token_561 = wave.load %359 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_562, %token_563 = wave.load %361 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_564, %token_565 = wave.load %363 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_566, %token_567 = wave.load %365 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_568, %token_569 = wave.load %367 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_570, %token_571 = wave.load %369 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_572, %token_573 = wave.load %371 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_574, %token_575 = wave.load %373 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_576, %token_577 = wave.load %375 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_578, %token_579 = wave.load %377 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_580, %token_581 = wave.load %379 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_582, %token_583 = wave.load %381 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_584, %token_585 = wave.load %383 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_586, %token_587 = wave.load %385 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_588, %token_589 = wave.load %387 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_590, %token_591 = wave.load %389 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_592, %token_593 = wave.load %391 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_594, %token_595 = wave.load %393 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_596, %token_597 = wave.load %395 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_598, %token_599 = wave.load %397 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_600, %token_601 = wave.load %399 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_602, %token_603 = wave.load %401 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_604, %token_605 = wave.load %403 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3346 = wave.store %value_394 -> %434 after %3119 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %3347 = wave.barrier %3346 : (!wave.mem.token) -> !wave.mem.token
        %3348 = wave.store %value_396 -> %453 after %3347 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %3349 = wave.barrier %3348 : (!wave.mem.token) -> !wave.mem.token
        %value_606, %token_607 = wave.load %521 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_608, %token_609 = wave.load %522 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_610, %token_611 = wave.load %523 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_612, %token_613 = wave.load %524 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_614, %token_615 = wave.load %525 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_616, %token_617 = wave.load %526 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_618, %token_619 = wave.load %527 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_620, %token_621 = wave.load %528 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_622, %token_623 = wave.load %529 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_624, %token_625 = wave.load %530 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_626, %token_627 = wave.load %531 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_628, %token_629 = wave.load %532 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_630, %token_631 = wave.load %533 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_632, %token_633 = wave.load %534 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_634, %token_635 = wave.load %535 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_636, %token_637 = wave.load %536 after %3349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3350 = wave.join %token_607, %token_609, %token_611, %token_613, %token_615, %token_617, %token_619, %token_621, %token_623, %token_625, %token_627, %token_629, %token_631, %token_633, %token_635, %token_637 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_638, %token_639 = wave.load %555 after %3350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_640, %token_641 = wave.load %556 after %3350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_642, %token_643 = wave.load %557 after %3350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_644, %token_645 = wave.load %558 after %3350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_646, %token_647 = wave.load %559 after %3350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_648, %token_649 = wave.load %560 after %3350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_650, %token_651 = wave.load %561 after %3350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %value_652, %token_653 = wave.load %562 after %3350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3351 = wave.index_expr <"128 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg8, %91, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %3352 = wave.assume %3351 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3353 = wave.ptr_add %150, %3352 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3354 = waveamd.dma_load_lds %3353 -> %325 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3355 = wave.index_expr <"128 + 32*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 32*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 32*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg8, %91, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %3356 = wave.assume %3355 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3357 = wave.ptr_add %150, %3356 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3358 = waveamd.dma_load_lds %3357 -> %330 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3359 = wave.index_expr <"128 + 64*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 64*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 64*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg8, %91, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %3360 = wave.assume %3359 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3361 = wave.ptr_add %150, %3360 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3362 = waveamd.dma_load_lds %3361 -> %335 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3363 = wave.index_expr <"128 + 96*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128)"> assuming [#wave.pred<"128 + 96*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) >= 0">, #wave.pred<"-2147483504 + 96*s0 + s1 + s2 + s0*s3 + s0*floor(1/8*wi) + Mod(16*wi, 128) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg8, %91, %arg14, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %3364 = wave.assume %3363 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
        %3365 = wave.ptr_add %150, %3364 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %3366 = waveamd.dma_load_lds %3365 -> %340 after %98 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3367 = wave.join %3354, %3358, %3362, %3366 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3368 = wave.index_expr <"8 + s1 + s2 + s0*s3 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg11, %92, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %3369 = wave.index_expr <"8 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg11, %92, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %3370 = wave.index_expr <"8 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg11, %92, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %3371 = wave.index_expr <"8 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s2 + s0*s3 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%51, %arg11, %92, %arg16, %88) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %3372 = wave.assume %3368 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3373 = wave.ptr_add %177, %3372 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_654, %token_655 = wave.load %3373 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3374 = wave.assume %3369 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3375 = wave.ptr_add %177, %3374 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_656, %token_657 = wave.load %3375 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3376 = wave.assume %3370 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3377 = wave.ptr_add %177, %3376 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_658, %token_659 = wave.load %3377 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3378 = wave.assume %3371 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
        %3379 = wave.ptr_add %177, %3378 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_660, %token_661 = wave.load %3379 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %3380 = wave.binary addi %arg13, %c256_i32 overflow<nsw> : i32, i32 -> i32
        %3381 = wave.binary addi %arg14, %c256_i32 overflow<nsw> : i32, i32 -> i32
        %3382 = wave.binary addi %arg15, %c16_i32 overflow<nsw> : i32, i32 -> i32
        %3383 = wave.binary addi %arg16, %c16_i32 overflow<nsw> : i32, i32 -> i32
        scf.yield %3380, %3381, %3382, %3383, %3011, %3014, %3017, %3020, %3023, %3026, %3029, %3032, %3035, %3038, %3041, %3044, %3047, %3050, %3053, %3056, %3059, %3062, %3065, %3068, %3071, %3074, %3077, %3080, %3083, %3086, %3089, %3092, %3095, %3098, %3101, %3104, %3251, %3254, %3257, %3260, %3263, %3266, %3269, %3272, %3275, %3278, %3281, %3284, %3287, %3290, %3293, %3296, %3299, %3302, %3305, %3308, %3311, %3314, %3317, %3320, %3323, %3326, %3329, %3332, %3335, %3338, %3341, %3344, %value_494, %value_496, %value_498, %value_500, %value_534, %value_536, %value_538, %value_540, %value_542, %value_544, %value_546, %value_548, %value_550, %value_552, %value_554, %value_556, %value_654, %value_656, %value_658, %value_660, %value_558, %value_560, %value_562, %value_564, %value_566, %value_568, %value_570, %value_572, %value_574, %value_576, %value_578, %value_580, %value_582, %value_584, %value_586, %value_588, %value_590, %value_592, %value_594, %value_596, %value_598, %value_600, %value_602, %value_604, %value_606, %value_608, %value_610, %value_612, %value_614, %value_616, %value_618, %value_620, %value_622, %value_624, %value_626, %value_628, %value_630, %value_632, %value_634, %value_636, %value_638, %value_640, %value_642, %value_644, %value_646, %value_648, %value_650, %value_652, %2934, %3206, %3367 : i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      %565 = waveamd.fragment_pack %564#88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %566 = waveamd.fragment_pack %564#89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %567 = waveamd.fragment_pack %564#90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %568 = waveamd.fragment_pack %564#91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %569 = waveamd.fragment_pack %564#92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %570 = waveamd.fragment_pack %564#93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %571 = waveamd.fragment_pack %564#94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %572 = waveamd.fragment_pack %564#95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %573 = waveamd.fragment_pack %564#96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %574 = waveamd.fragment_pack %564#97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %575 = waveamd.fragment_pack %564#98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %576 = waveamd.fragment_pack %564#99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %577 = waveamd.fragment_pack %564#100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %578 = waveamd.fragment_pack %564#101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %579 = waveamd.fragment_pack %564#102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %580 = waveamd.fragment_pack %564#103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %581 = waveamd.fragment_pack %564#104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %582 = waveamd.fragment_pack %564#105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %583 = waveamd.fragment_pack %564#106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %584 = waveamd.fragment_pack %564#107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %585 = waveamd.fragment_pack %564#108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %586 = waveamd.fragment_pack %564#109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %587 = waveamd.fragment_pack %564#110 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %588 = waveamd.fragment_pack %564#111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %589 = waveamd.fragment_pack %564#4 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %590 = waveamd.fragment_pack %564#5 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %591 = waveamd.fragment_pack %564#6 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %592 = waveamd.fragment_pack %564#7 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %593 = waveamd.fragment_pack %564#8 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %594 = waveamd.fragment_pack %564#9 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %595 = waveamd.fragment_pack %564#10 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %596 = waveamd.fragment_pack %564#11 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %597 = waveamd.fragment_pack %564#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %598 = waveamd.fragment_pack %564#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %599 = waveamd.fragment_pack %564#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %600 = waveamd.fragment_pack %564#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %601 = waveamd.fragment_pack %564#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %602 = waveamd.fragment_pack %564#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %603 = waveamd.fragment_pack %564#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %604 = waveamd.fragment_pack %564#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %605 = waveamd.fragment_pack %564#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %606 = waveamd.fragment_pack %564#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %607 = waveamd.fragment_pack %564#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %608 = waveamd.fragment_pack %564#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %609 = waveamd.fragment_pack %564#24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %610 = waveamd.fragment_pack %564#25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %611 = waveamd.fragment_pack %564#26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %612 = waveamd.fragment_pack %564#27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %613 = waveamd.fragment_pack %564#28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %614 = waveamd.fragment_pack %564#29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %615 = waveamd.fragment_pack %564#30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %616 = waveamd.fragment_pack %564#31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %617 = waveamd.fragment_pack %564#32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %618 = waveamd.fragment_pack %564#33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %619 = waveamd.fragment_pack %564#34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %620 = waveamd.fragment_pack %564#35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %621 = wave.pack %564#112, %564#113, %564#114, %564#115, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %622 = wave.pack %564#116, %564#117, %564#118, %564#119, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %623 = wave.pack %564#120, %564#121, %564#122, %564#123, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %624 = wave.pack %564#124, %564#125, %564#126, %564#127, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %625 = wave.pack %564#128, %564#129, %564#130, %564#131, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %626 = wave.pack %564#132, %564#133, %564#134, %564#135, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %627 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %581, %625, %565, %621, %589 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %628 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %582, %625, %566, %621, %627 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %629 = waveamd.fragment_unpack %628 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %630 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %583, %625, %565, %621, %590 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %631 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %584, %625, %566, %621, %630 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %632 = waveamd.fragment_unpack %631 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %633 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %585, %626, %565, %621, %591 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %634 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %586, %626, %566, %621, %633 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %635 = waveamd.fragment_unpack %634 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %636 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %587, %626, %565, %621, %592 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %637 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %588, %626, %566, %621, %636 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %638 = waveamd.fragment_unpack %637 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %639 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %581, %625, %567, %621, %593 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %640 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %582, %625, %568, %621, %639 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %641 = waveamd.fragment_unpack %640 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %642 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %583, %625, %567, %621, %594 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %643 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %584, %625, %568, %621, %642 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %644 = waveamd.fragment_unpack %643 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %645 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %585, %626, %567, %621, %595 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %646 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %586, %626, %568, %621, %645 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %647 = waveamd.fragment_unpack %646 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %648 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %587, %626, %567, %621, %596 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %649 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %588, %626, %568, %621, %648 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %650 = waveamd.fragment_unpack %649 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %651 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %581, %625, %569, %622, %597 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %652 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %582, %625, %570, %622, %651 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %653 = waveamd.fragment_unpack %652 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %654 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %583, %625, %569, %622, %598 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %655 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %584, %625, %570, %622, %654 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %656 = waveamd.fragment_unpack %655 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %657 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %585, %626, %569, %622, %599 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %658 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %586, %626, %570, %622, %657 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %659 = waveamd.fragment_unpack %658 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %660 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %587, %626, %569, %622, %600 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %661 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %588, %626, %570, %622, %660 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %662 = waveamd.fragment_unpack %661 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %663 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %581, %625, %571, %622, %601 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %664 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %582, %625, %572, %622, %663 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %665 = waveamd.fragment_unpack %664 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %666 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %583, %625, %571, %622, %602 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %667 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %584, %625, %572, %622, %666 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %668 = waveamd.fragment_unpack %667 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %669 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %585, %626, %571, %622, %603 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %670 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %586, %626, %572, %622, %669 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %671 = waveamd.fragment_unpack %670 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %672 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %587, %626, %571, %622, %604 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %673 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %588, %626, %572, %622, %672 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %674 = waveamd.fragment_unpack %673 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %675 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %581, %625, %573, %623, %605 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %676 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %582, %625, %574, %623, %675 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %677 = waveamd.fragment_unpack %676 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %678 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %583, %625, %573, %623, %606 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %679 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %584, %625, %574, %623, %678 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %680 = waveamd.fragment_unpack %679 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %681 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %585, %626, %573, %623, %607 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %682 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %586, %626, %574, %623, %681 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %683 = waveamd.fragment_unpack %682 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %684 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %587, %626, %573, %623, %608 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %685 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %588, %626, %574, %623, %684 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %686 = waveamd.fragment_unpack %685 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %687 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %581, %625, %575, %623, %609 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %688 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %582, %625, %576, %623, %687 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %689 = waveamd.fragment_unpack %688 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %690 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %583, %625, %575, %623, %610 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %691 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %584, %625, %576, %623, %690 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %692 = waveamd.fragment_unpack %691 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %693 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %585, %626, %575, %623, %611 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %694 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %586, %626, %576, %623, %693 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %695 = waveamd.fragment_unpack %694 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %696 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %587, %626, %575, %623, %612 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %697 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %588, %626, %576, %623, %696 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %698 = waveamd.fragment_unpack %697 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %699 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %581, %625, %577, %624, %613 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %700 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %582, %625, %578, %624, %699 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %701 = waveamd.fragment_unpack %700 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %702 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %583, %625, %577, %624, %614 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %703 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %584, %625, %578, %624, %702 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %704 = waveamd.fragment_unpack %703 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %705 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %585, %626, %577, %624, %615 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %706 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %586, %626, %578, %624, %705 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %707 = waveamd.fragment_unpack %706 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %708 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %587, %626, %577, %624, %616 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %709 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %588, %626, %578, %624, %708 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %710 = waveamd.fragment_unpack %709 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %711 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %581, %625, %579, %624, %617 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %712 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %582, %625, %580, %624, %711 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %713 = waveamd.fragment_unpack %712 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %714 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %583, %625, %579, %624, %618 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %715 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %584, %625, %580, %624, %714 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %716 = waveamd.fragment_unpack %715 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %717 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %585, %626, %579, %624, %619 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %718 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %586, %626, %580, %624, %717 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %719 = waveamd.fragment_unpack %718 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %720 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %587, %626, %579, %624, %620 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %721 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %588, %626, %580, %624, %720 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %722 = waveamd.fragment_unpack %721 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      wave.wait %564#136, %564#137, %564#138 : !wave.mem.token, !wave.mem.token, !wave.mem.token
      %723 = wave.barrier %564#136, %564#137, %564#138 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %724 = wave.ptr_add %182, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_138, %token_139 = wave.load %724 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %725 = wave.ptr_add %182, %390 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_140, %token_141 = wave.load %725 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %726 = wave.ptr_add %182, %392 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_142, %token_143 = wave.load %726 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %727 = wave.ptr_add %182, %394 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_144, %token_145 = wave.load %727 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %728 = wave.ptr_add %182, %396 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_146, %token_147 = wave.load %728 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %729 = wave.ptr_add %182, %398 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_148, %token_149 = wave.load %729 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %730 = wave.ptr_add %182, %400 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_150, %token_151 = wave.load %730 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %731 = wave.ptr_add %182, %402 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_152, %token_153 = wave.load %731 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %732 = wave.binary muli %418, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %733 = wave.binary xori %415, %732 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %734 = wave.binary muli %422, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %735 = wave.binary xori %733, %734 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %736 = wave.binary muli %426, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %737 = wave.binary xori %735, %736 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %738 = wave.binary xori %737, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %739 = wave.binary muli %738, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %740 = wave.binary addi %739, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %741 = wave.binary xori %24, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %742 = wave.binary xori %741, %732 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %743 = wave.binary xori %742, %734 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %744 = wave.binary xori %743, %736 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %745 = wave.binary xori %744, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %746 = wave.binary muli %745, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %747 = wave.binary addi %746, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %748 = wave.binary xori %22, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %749 = wave.binary xori %748, %732 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %750 = wave.binary xori %749, %734 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %751 = wave.binary xori %750, %736 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %752 = wave.binary xori %751, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %753 = wave.binary muli %752, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %754 = wave.binary addi %753, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %755 = wave.binary xori %20, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %756 = wave.binary xori %755, %732 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %757 = wave.binary xori %756, %734 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %758 = wave.binary xori %757, %736 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %759 = wave.binary xori %758, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %760 = wave.binary muli %759, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %761 = wave.binary addi %760, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %762 = wave.ptr_add %437, %740 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %763 = wave.store %564#68 -> %762 after %563 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %764 = wave.ptr_add %437, %747 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %765 = wave.store %564#69 -> %764 after %563 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %766 = wave.ptr_add %437, %754 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %767 = wave.store %564#70 -> %766 after %563 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %768 = wave.ptr_add %437, %761 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %769 = wave.store %564#71 -> %768 after %563 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %770 = wave.barrier %763, %765, %767, %769 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_154, %token_155 = wave.load %555 after %770 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_156, %token_157 = wave.load %556 after %770 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_158, %token_159 = wave.load %557 after %770 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_160, %token_161 = wave.load %558 after %770 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_162, %token_163 = wave.load %559 after %770 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_164, %token_165 = wave.load %560 after %770 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_166, %token_167 = wave.load %561 after %770 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_168, %token_169 = wave.load %562 after %770 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %771 = wave.join %token_155, %token_157, %token_159, %token_161, %token_163, %token_165, %token_167, %token_169 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %772 = waveamd.fragment_pack %value_138 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %773 = waveamd.fragment_pack %value_140 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %774 = waveamd.fragment_pack %value_142 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %775 = waveamd.fragment_pack %value_144 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %776 = waveamd.fragment_pack %value_146 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %777 = waveamd.fragment_pack %value_148 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %778 = waveamd.fragment_pack %value_150 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %779 = waveamd.fragment_pack %value_152 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %780 = waveamd.fragment_pack %564#36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %781 = waveamd.fragment_pack %564#37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %782 = waveamd.fragment_pack %564#38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %783 = waveamd.fragment_pack %564#39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %784 = waveamd.fragment_pack %564#40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %785 = waveamd.fragment_pack %564#41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %786 = waveamd.fragment_pack %564#42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %787 = waveamd.fragment_pack %564#43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %788 = waveamd.fragment_pack %564#44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %789 = waveamd.fragment_pack %564#45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %790 = waveamd.fragment_pack %564#46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %791 = waveamd.fragment_pack %564#47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %792 = waveamd.fragment_pack %564#48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %793 = waveamd.fragment_pack %564#49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %794 = waveamd.fragment_pack %564#50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %795 = waveamd.fragment_pack %564#51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %796 = waveamd.fragment_pack %564#52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %797 = waveamd.fragment_pack %564#53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %798 = waveamd.fragment_pack %564#54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %799 = waveamd.fragment_pack %564#55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %800 = waveamd.fragment_pack %564#56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %801 = waveamd.fragment_pack %564#57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %802 = waveamd.fragment_pack %564#58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %803 = waveamd.fragment_pack %564#59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %804 = waveamd.fragment_pack %564#60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %805 = waveamd.fragment_pack %564#61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %806 = waveamd.fragment_pack %564#62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %807 = waveamd.fragment_pack %564#63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %808 = waveamd.fragment_pack %564#64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %809 = waveamd.fragment_pack %564#65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %810 = waveamd.fragment_pack %564#66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %811 = waveamd.fragment_pack %564#67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %812 = wave.pack %value_154, %value_156, %value_158, %value_160, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %813 = wave.pack %value_162, %value_164, %value_166, %value_168, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %814 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %772, %812, %565, %621, %780 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %815 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %773, %812, %566, %621, %814 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %816 = waveamd.fragment_unpack %815 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %817 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %774, %812, %565, %621, %781 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %818 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %775, %812, %566, %621, %817 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %819 = waveamd.fragment_unpack %818 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %820 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %776, %813, %565, %621, %782 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %821 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %777, %813, %566, %621, %820 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %822 = waveamd.fragment_unpack %821 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %823 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %778, %813, %565, %621, %783 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %824 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %779, %813, %566, %621, %823 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %825 = waveamd.fragment_unpack %824 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %826 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %772, %812, %567, %621, %784 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %827 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %773, %812, %568, %621, %826 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %828 = waveamd.fragment_unpack %827 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %829 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %774, %812, %567, %621, %785 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %830 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %775, %812, %568, %621, %829 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %831 = waveamd.fragment_unpack %830 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %832 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %776, %813, %567, %621, %786 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %833 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %777, %813, %568, %621, %832 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %834 = waveamd.fragment_unpack %833 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %835 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %778, %813, %567, %621, %787 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %836 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %779, %813, %568, %621, %835 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %837 = waveamd.fragment_unpack %836 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %838 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %772, %812, %569, %622, %788 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %839 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %773, %812, %570, %622, %838 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %840 = waveamd.fragment_unpack %839 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %841 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %774, %812, %569, %622, %789 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %842 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %775, %812, %570, %622, %841 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %843 = waveamd.fragment_unpack %842 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %844 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %776, %813, %569, %622, %790 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %845 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %777, %813, %570, %622, %844 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %846 = waveamd.fragment_unpack %845 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %847 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %778, %813, %569, %622, %791 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %848 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %779, %813, %570, %622, %847 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %849 = waveamd.fragment_unpack %848 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %850 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %772, %812, %571, %622, %792 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %851 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %773, %812, %572, %622, %850 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %852 = waveamd.fragment_unpack %851 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %853 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %774, %812, %571, %622, %793 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %854 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %775, %812, %572, %622, %853 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %855 = waveamd.fragment_unpack %854 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %856 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %776, %813, %571, %622, %794 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %857 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %777, %813, %572, %622, %856 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %858 = waveamd.fragment_unpack %857 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %859 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %778, %813, %571, %622, %795 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %860 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %779, %813, %572, %622, %859 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %861 = waveamd.fragment_unpack %860 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %862 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %772, %812, %573, %623, %796 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %863 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %773, %812, %574, %623, %862 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %864 = waveamd.fragment_unpack %863 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %865 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %774, %812, %573, %623, %797 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %866 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %775, %812, %574, %623, %865 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %867 = waveamd.fragment_unpack %866 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %868 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %776, %813, %573, %623, %798 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %869 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %777, %813, %574, %623, %868 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %870 = waveamd.fragment_unpack %869 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %871 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %778, %813, %573, %623, %799 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %872 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %779, %813, %574, %623, %871 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %873 = waveamd.fragment_unpack %872 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %874 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %772, %812, %575, %623, %800 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %875 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %773, %812, %576, %623, %874 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %876 = waveamd.fragment_unpack %875 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %877 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %774, %812, %575, %623, %801 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %878 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %775, %812, %576, %623, %877 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %879 = waveamd.fragment_unpack %878 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %880 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %776, %813, %575, %623, %802 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %881 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %777, %813, %576, %623, %880 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %882 = waveamd.fragment_unpack %881 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %883 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %778, %813, %575, %623, %803 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %884 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %779, %813, %576, %623, %883 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %885 = waveamd.fragment_unpack %884 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %886 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %772, %812, %577, %624, %804 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %887 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %773, %812, %578, %624, %886 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %888 = waveamd.fragment_unpack %887 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %889 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %774, %812, %577, %624, %805 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %890 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %775, %812, %578, %624, %889 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %891 = waveamd.fragment_unpack %890 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %892 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %776, %813, %577, %624, %806 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %893 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %777, %813, %578, %624, %892 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %894 = waveamd.fragment_unpack %893 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %895 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %778, %813, %577, %624, %807 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %896 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %779, %813, %578, %624, %895 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %897 = waveamd.fragment_unpack %896 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %898 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %772, %812, %579, %624, %808 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %899 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %773, %812, %580, %624, %898 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %900 = waveamd.fragment_unpack %899 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %901 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %774, %812, %579, %624, %809 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %902 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %775, %812, %580, %624, %901 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %903 = waveamd.fragment_unpack %902 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %904 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %776, %813, %579, %624, %810 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %905 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %777, %813, %580, %624, %904 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %906 = waveamd.fragment_unpack %905 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %907 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %778, %813, %579, %624, %811 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %908 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %779, %813, %580, %624, %907 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %909 = waveamd.fragment_unpack %908 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %910 = wave.ptr_add %217, %356 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_170, %token_171 = wave.load %910 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %911 = wave.ptr_add %217, %358 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_172, %token_173 = wave.load %911 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %912 = wave.ptr_add %217, %360 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_174, %token_175 = wave.load %912 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %913 = wave.ptr_add %217, %362 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_176, %token_177 = wave.load %913 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %914 = wave.ptr_add %217, %364 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_178, %token_179 = wave.load %914 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %915 = wave.ptr_add %217, %366 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_180, %token_181 = wave.load %915 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %916 = wave.ptr_add %217, %368 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_182, %token_183 = wave.load %916 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %917 = wave.ptr_add %217, %370 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_184, %token_185 = wave.load %917 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %918 = wave.ptr_add %217, %372 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_186, %token_187 = wave.load %918 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %919 = wave.ptr_add %217, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_188, %token_189 = wave.load %919 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %920 = wave.ptr_add %217, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_190, %token_191 = wave.load %920 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %921 = wave.ptr_add %217, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_192, %token_193 = wave.load %921 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %922 = wave.ptr_add %217, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_194, %token_195 = wave.load %922 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %923 = wave.ptr_add %217, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_196, %token_197 = wave.load %923 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %924 = wave.ptr_add %217, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_198, %token_199 = wave.load %924 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %925 = wave.ptr_add %217, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_200, %token_201 = wave.load %925 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %926 = wave.ptr_add %260, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_202, %token_203 = wave.load %926 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %927 = wave.ptr_add %260, %390 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_204, %token_205 = wave.load %927 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %928 = wave.ptr_add %260, %392 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_206, %token_207 = wave.load %928 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %929 = wave.ptr_add %260, %394 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_208, %token_209 = wave.load %929 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %930 = wave.ptr_add %260, %396 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_210, %token_211 = wave.load %930 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %931 = wave.ptr_add %260, %398 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_212, %token_213 = wave.load %931 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %932 = wave.ptr_add %260, %400 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_214, %token_215 = wave.load %932 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %933 = wave.ptr_add %260, %402 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_216, %token_217 = wave.load %933 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %934 = wave.binary xori %18, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %935 = wave.binary xori %934, %732 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %936 = wave.binary xori %935, %734 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %937 = wave.binary xori %936, %736 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %938 = wave.binary xori %937, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %939 = wave.binary muli %938, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %940 = wave.binary addi %939, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %941 = wave.binary xori %16, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %942 = wave.binary xori %941, %732 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %943 = wave.binary xori %942, %734 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %944 = wave.binary xori %943, %736 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %945 = wave.binary xori %944, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %946 = wave.binary muli %945, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %947 = wave.binary addi %946, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %948 = wave.binary xori %14, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %949 = wave.binary xori %948, %732 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %950 = wave.binary xori %949, %734 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %951 = wave.binary xori %950, %736 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %952 = wave.binary xori %951, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %953 = wave.binary muli %952, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %954 = wave.binary addi %953, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %955 = wave.binary xori %12, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %956 = wave.binary xori %955, %732 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %957 = wave.binary xori %956, %734 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %958 = wave.binary xori %957, %736 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %959 = wave.binary xori %958, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %960 = wave.binary muli %959, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %961 = wave.binary addi %960, %413 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %962 = wave.ptr_add %404, %740 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %963 = wave.store %564#72 -> %962 after %771 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %964 = wave.ptr_add %404, %747 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %965 = wave.store %564#73 -> %964 after %771 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %966 = wave.ptr_add %404, %754 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %967 = wave.store %564#74 -> %966 after %771 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %968 = wave.ptr_add %404, %761 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %969 = wave.store %564#75 -> %968 after %771 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %970 = wave.ptr_add %404, %940 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %971 = wave.store %564#76 -> %970 after %771 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %972 = wave.ptr_add %404, %947 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %973 = wave.store %564#77 -> %972 after %771 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %974 = wave.ptr_add %404, %954 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %975 = wave.store %564#78 -> %974 after %771 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %976 = wave.ptr_add %404, %961 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %977 = wave.store %564#79 -> %976 after %771 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %978 = wave.barrier %963, %965, %967, %969, %971, %973, %975, %977 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %979 = wave.store %564#80 -> %762 after %978 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %980 = wave.store %564#81 -> %764 after %978 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %981 = wave.store %564#82 -> %766 after %978 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %982 = wave.store %564#83 -> %768 after %978 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %983 = wave.barrier %979, %980, %981, %982 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_218, %token_219 = wave.load %521 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_220, %token_221 = wave.load %522 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_222, %token_223 = wave.load %523 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_224, %token_225 = wave.load %524 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_226, %token_227 = wave.load %525 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_228, %token_229 = wave.load %526 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_230, %token_231 = wave.load %527 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_232, %token_233 = wave.load %528 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_234, %token_235 = wave.load %529 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_236, %token_237 = wave.load %530 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_238, %token_239 = wave.load %531 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_240, %token_241 = wave.load %532 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_242, %token_243 = wave.load %533 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_244, %token_245 = wave.load %534 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_246, %token_247 = wave.load %535 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_248, %token_249 = wave.load %536 after %983 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %984 = wave.join %token_219, %token_221, %token_223, %token_225, %token_227, %token_229, %token_231, %token_233, %token_235, %token_237, %token_239, %token_241, %token_243, %token_245, %token_247, %token_249 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_250, %token_251 = wave.load %555 after %984 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_252, %token_253 = wave.load %556 after %984 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_254, %token_255 = wave.load %557 after %984 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_256, %token_257 = wave.load %558 after %984 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_258, %token_259 = wave.load %559 after %984 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_260, %token_261 = wave.load %560 after %984 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_262, %token_263 = wave.load %561 after %984 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_264, %token_265 = wave.load %562 after %984 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %985 = wave.join %token_251, %token_253, %token_255, %token_257, %token_259, %token_261, %token_263, %token_265 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %986 = waveamd.fragment_pack %value_170 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %987 = waveamd.fragment_pack %value_172 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %988 = waveamd.fragment_pack %value_174 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %989 = waveamd.fragment_pack %value_176 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %990 = waveamd.fragment_pack %value_178 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %991 = waveamd.fragment_pack %value_180 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %992 = waveamd.fragment_pack %value_182 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %993 = waveamd.fragment_pack %value_184 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %994 = waveamd.fragment_pack %value_186 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %995 = waveamd.fragment_pack %value_188 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %996 = waveamd.fragment_pack %value_190 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %997 = waveamd.fragment_pack %value_192 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %998 = waveamd.fragment_pack %value_194 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %999 = waveamd.fragment_pack %value_196 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1000 = waveamd.fragment_pack %value_198 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1001 = waveamd.fragment_pack %value_200 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1002 = waveamd.fragment_pack %value_202 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1003 = waveamd.fragment_pack %value_204 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1004 = waveamd.fragment_pack %value_206 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1005 = waveamd.fragment_pack %value_208 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1006 = waveamd.fragment_pack %value_210 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1007 = waveamd.fragment_pack %value_212 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1008 = waveamd.fragment_pack %value_214 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1009 = waveamd.fragment_pack %value_216 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1010 = waveamd.fragment_pack %629 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1011 = waveamd.fragment_pack %632 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1012 = waveamd.fragment_pack %635 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1013 = waveamd.fragment_pack %638 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1014 = waveamd.fragment_pack %641 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1015 = waveamd.fragment_pack %644 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1016 = waveamd.fragment_pack %647 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1017 = waveamd.fragment_pack %650 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1018 = waveamd.fragment_pack %653 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1019 = waveamd.fragment_pack %656 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1020 = waveamd.fragment_pack %659 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1021 = waveamd.fragment_pack %662 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1022 = waveamd.fragment_pack %665 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1023 = waveamd.fragment_pack %668 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1024 = waveamd.fragment_pack %671 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1025 = waveamd.fragment_pack %674 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1026 = waveamd.fragment_pack %677 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1027 = waveamd.fragment_pack %680 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1028 = waveamd.fragment_pack %683 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1029 = waveamd.fragment_pack %686 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1030 = waveamd.fragment_pack %689 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1031 = waveamd.fragment_pack %692 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1032 = waveamd.fragment_pack %695 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1033 = waveamd.fragment_pack %698 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1034 = waveamd.fragment_pack %701 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1035 = waveamd.fragment_pack %704 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1036 = waveamd.fragment_pack %707 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1037 = waveamd.fragment_pack %710 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1038 = waveamd.fragment_pack %713 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1039 = waveamd.fragment_pack %716 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1040 = waveamd.fragment_pack %719 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1041 = waveamd.fragment_pack %722 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1042 = wave.pack %value_218, %value_220, %value_222, %value_224, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1043 = wave.pack %value_226, %value_228, %value_230, %value_232, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1044 = wave.pack %value_234, %value_236, %value_238, %value_240, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1045 = wave.pack %value_242, %value_244, %value_246, %value_248, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1046 = wave.pack %value_250, %value_252, %value_254, %value_256, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1047 = wave.pack %value_258, %value_260, %value_262, %value_264, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1048 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1002, %1046, %986, %1042, %1010 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1049 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1003, %1046, %987, %1042, %1048 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1050 = waveamd.fragment_unpack %1049 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1051 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1004, %1046, %986, %1042, %1011 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1052 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1005, %1046, %987, %1042, %1051 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1053 = waveamd.fragment_unpack %1052 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1054 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1006, %1047, %986, %1042, %1012 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1055 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1007, %1047, %987, %1042, %1054 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1056 = waveamd.fragment_unpack %1055 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1057 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1008, %1047, %986, %1042, %1013 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1058 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1009, %1047, %987, %1042, %1057 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1059 = waveamd.fragment_unpack %1058 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1060 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1002, %1046, %988, %1042, %1014 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1061 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1003, %1046, %989, %1042, %1060 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1062 = waveamd.fragment_unpack %1061 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1063 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1004, %1046, %988, %1042, %1015 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1064 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1005, %1046, %989, %1042, %1063 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1065 = waveamd.fragment_unpack %1064 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1066 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1006, %1047, %988, %1042, %1016 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1067 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1007, %1047, %989, %1042, %1066 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1068 = waveamd.fragment_unpack %1067 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1069 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1008, %1047, %988, %1042, %1017 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1070 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1009, %1047, %989, %1042, %1069 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1071 = waveamd.fragment_unpack %1070 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1072 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1002, %1046, %990, %1043, %1018 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1073 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1003, %1046, %991, %1043, %1072 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1074 = waveamd.fragment_unpack %1073 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1075 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1004, %1046, %990, %1043, %1019 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1076 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1005, %1046, %991, %1043, %1075 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1077 = waveamd.fragment_unpack %1076 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1078 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1006, %1047, %990, %1043, %1020 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1079 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1007, %1047, %991, %1043, %1078 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1080 = waveamd.fragment_unpack %1079 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1081 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1008, %1047, %990, %1043, %1021 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1082 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1009, %1047, %991, %1043, %1081 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1083 = waveamd.fragment_unpack %1082 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1084 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1002, %1046, %992, %1043, %1022 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1085 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1003, %1046, %993, %1043, %1084 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1086 = waveamd.fragment_unpack %1085 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1087 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1004, %1046, %992, %1043, %1023 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1088 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1005, %1046, %993, %1043, %1087 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1089 = waveamd.fragment_unpack %1088 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1090 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1006, %1047, %992, %1043, %1024 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1091 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1007, %1047, %993, %1043, %1090 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1092 = waveamd.fragment_unpack %1091 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1093 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1008, %1047, %992, %1043, %1025 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1094 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1009, %1047, %993, %1043, %1093 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1095 = waveamd.fragment_unpack %1094 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1096 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1002, %1046, %994, %1044, %1026 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1097 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1003, %1046, %995, %1044, %1096 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1098 = waveamd.fragment_unpack %1097 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1099 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1004, %1046, %994, %1044, %1027 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1100 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1005, %1046, %995, %1044, %1099 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1101 = waveamd.fragment_unpack %1100 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1102 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1006, %1047, %994, %1044, %1028 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1103 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1007, %1047, %995, %1044, %1102 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1104 = waveamd.fragment_unpack %1103 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1105 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1008, %1047, %994, %1044, %1029 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1106 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1009, %1047, %995, %1044, %1105 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1107 = waveamd.fragment_unpack %1106 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1108 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1002, %1046, %996, %1044, %1030 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1109 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1003, %1046, %997, %1044, %1108 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1110 = waveamd.fragment_unpack %1109 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1111 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1004, %1046, %996, %1044, %1031 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1112 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1005, %1046, %997, %1044, %1111 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1113 = waveamd.fragment_unpack %1112 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1114 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1006, %1047, %996, %1044, %1032 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1115 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1007, %1047, %997, %1044, %1114 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1116 = waveamd.fragment_unpack %1115 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1117 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1008, %1047, %996, %1044, %1033 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1118 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1009, %1047, %997, %1044, %1117 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1119 = waveamd.fragment_unpack %1118 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1120 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1002, %1046, %998, %1045, %1034 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1121 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1003, %1046, %999, %1045, %1120 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1122 = waveamd.fragment_unpack %1121 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1123 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1004, %1046, %998, %1045, %1035 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1124 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1005, %1046, %999, %1045, %1123 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1125 = waveamd.fragment_unpack %1124 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1126 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1006, %1047, %998, %1045, %1036 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1127 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1007, %1047, %999, %1045, %1126 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1128 = waveamd.fragment_unpack %1127 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1129 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1008, %1047, %998, %1045, %1037 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1130 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1009, %1047, %999, %1045, %1129 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1131 = waveamd.fragment_unpack %1130 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1132 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1002, %1046, %1000, %1045, %1038 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1133 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1003, %1046, %1001, %1045, %1132 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1134 = waveamd.fragment_unpack %1133 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1135 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1004, %1046, %1000, %1045, %1039 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1136 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1005, %1046, %1001, %1045, %1135 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1137 = waveamd.fragment_unpack %1136 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1138 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1006, %1047, %1000, %1045, %1040 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1139 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1007, %1047, %1001, %1045, %1138 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1140 = waveamd.fragment_unpack %1139 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1141 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1008, %1047, %1000, %1045, %1041 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1142 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1009, %1047, %1001, %1045, %1141 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1143 = waveamd.fragment_unpack %1142 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1144 = wave.ptr_add %320, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_266, %token_267 = wave.load %1144 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1145 = wave.ptr_add %320, %390 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_268, %token_269 = wave.load %1145 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1146 = wave.ptr_add %320, %392 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_270, %token_271 = wave.load %1146 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1147 = wave.ptr_add %320, %394 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_272, %token_273 = wave.load %1147 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1148 = wave.ptr_add %320, %396 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_274, %token_275 = wave.load %1148 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1149 = wave.ptr_add %320, %398 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_276, %token_277 = wave.load %1149 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1150 = wave.ptr_add %320, %400 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_278, %token_279 = wave.load %1150 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1151 = wave.ptr_add %320, %402 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_280, %token_281 = wave.load %1151 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1152 = wave.store %564#84 -> %762 after %985 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %1153 = wave.store %564#85 -> %764 after %985 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %1154 = wave.store %564#86 -> %766 after %985 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %1155 = wave.store %564#87 -> %768 after %985 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %1156 = wave.barrier %1152, %1153, %1154, %1155 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_282, %token_283 = wave.load %555 after %1156 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_284, %token_285 = wave.load %556 after %1156 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_286, %token_287 = wave.load %557 after %1156 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_288, %token_289 = wave.load %558 after %1156 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_290, %token_291 = wave.load %559 after %1156 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_292, %token_293 = wave.load %560 after %1156 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_294, %token_295 = wave.load %561 after %1156 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %value_296, %token_297 = wave.load %562 after %1156 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %1157 = wave.splat %arg5 : i32 -> !wave.simd<i32, 64>
      %1158 = wave.cmpi slt %70, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1159 = wave.cmpi slt %71, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1160 = wave.cmpi slt %72, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1161 = wave.cmpi slt %73, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1162 = wave.cmpi slt %74, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1163 = wave.cmpi slt %75, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1164 = wave.cmpi slt %76, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1165 = wave.cmpi slt %77, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1166 = wave.cmpi slt %78, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1167 = wave.cmpi slt %79, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1168 = wave.cmpi slt %80, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1169 = wave.cmpi slt %81, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1170 = wave.cmpi slt %82, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1171 = wave.cmpi slt %83, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1172 = wave.cmpi slt %84, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1173 = wave.cmpi slt %85, %1157 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1174 = wave.select %1158, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1175 = wave.select %1159, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1176 = wave.select %1160, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1177 = wave.select %1161, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1178 = wave.select %1162, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1179 = wave.select %1163, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1180 = wave.select %1164, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1181 = wave.select %1165, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1182 = wave.select %1166, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1183 = wave.select %1167, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1184 = wave.select %1168, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1185 = wave.select %1169, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1186 = wave.select %1170, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1187 = wave.select %1171, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1188 = wave.select %1172, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1189 = wave.select %1173, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1190 = wave.splat %arg6 : i32 -> !wave.simd<i32, 64>
      %1191 = wave.cmpi slt %90, %1190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1192 = wave.select %1191, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1193 = wave.binary andi %1174, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1194 = wave.binary andi %1175, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1195 = wave.binary andi %1176, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1196 = wave.binary andi %1177, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1197 = wave.binary andi %1178, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1198 = wave.binary andi %1179, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1199 = wave.binary andi %1180, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1200 = wave.binary andi %1181, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1201 = wave.binary andi %1182, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1202 = wave.binary andi %1183, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1203 = wave.binary andi %1184, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1204 = wave.binary andi %1185, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1205 = wave.binary andi %1186, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1206 = wave.binary andi %1187, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1207 = wave.binary andi %1188, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1208 = wave.binary andi %1189, %1192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1209 = wave.cast fpconvert %1050 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1210 = wave.cast fpconvert %1053 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1211 = wave.cast fpconvert %1056 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1212 = wave.cast fpconvert %1059 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1213 = wave.cast fpconvert %1062 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1214 = wave.cast fpconvert %1065 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1215 = wave.cast fpconvert %1068 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1216 = wave.cast fpconvert %1071 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1217 = wave.cast fpconvert %1074 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1218 = wave.cast fpconvert %1077 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1219 = wave.cast fpconvert %1080 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1220 = wave.cast fpconvert %1083 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1221 = wave.cast fpconvert %1086 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1222 = wave.cast fpconvert %1089 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1223 = wave.cast fpconvert %1092 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1224 = wave.cast fpconvert %1095 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1225 = wave.cast fpconvert %1098 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1226 = wave.cast fpconvert %1101 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1227 = wave.cast fpconvert %1104 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1228 = wave.cast fpconvert %1107 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1229 = wave.cast fpconvert %1110 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1230 = wave.cast fpconvert %1113 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1231 = wave.cast fpconvert %1116 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1232 = wave.cast fpconvert %1119 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1233 = wave.cast fpconvert %1122 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1234 = wave.cast fpconvert %1125 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1235 = wave.cast fpconvert %1128 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1236 = wave.cast fpconvert %1131 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1237 = wave.cast fpconvert %1134 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1238 = wave.cast fpconvert %1137 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1239 = wave.cast fpconvert %1140 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1240 = wave.cast fpconvert %1143 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1241 = wave.shared_memory_base {offset = 134144 : i64} : !wave.ptr<#wave.shared, bf16>
      %1242 = wave.binary muli %51, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1243 = wave.ptr_add %1241, %1242 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1244 = wave.extract %1209[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1245 = wave.extract %1209[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1246 = wave.extract %1209[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1247 = wave.extract %1209[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1248 = wave.extract %1213[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1249 = wave.extract %1213[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1250 = wave.extract %1213[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1251 = wave.extract %1213[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1252 = wave.pack %1244, %1245, %1246, %1247, %1248, %1249, %1250, %1251 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1253 = wave.store %1252 -> %1243 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1254 = wave.binary addi %1242, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1255 = wave.ptr_add %1241, %1254 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1256 = wave.extract %1210[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1257 = wave.extract %1210[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1258 = wave.extract %1210[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1259 = wave.extract %1210[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1260 = wave.extract %1214[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1261 = wave.extract %1214[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1262 = wave.extract %1214[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1263 = wave.extract %1214[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1264 = wave.pack %1256, %1257, %1258, %1259, %1260, %1261, %1262, %1263 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1265 = wave.store %1264 -> %1255 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1266 = wave.binary addi %1242, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1267 = wave.ptr_add %1241, %1266 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1268 = wave.extract %1211[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1269 = wave.extract %1211[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1270 = wave.extract %1211[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1271 = wave.extract %1211[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1272 = wave.extract %1215[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1273 = wave.extract %1215[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1274 = wave.extract %1215[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1275 = wave.extract %1215[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1276 = wave.pack %1268, %1269, %1270, %1271, %1272, %1273, %1274, %1275 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1277 = wave.store %1276 -> %1267 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1278 = wave.binary addi %1242, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1279 = wave.ptr_add %1241, %1278 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1280 = wave.extract %1212[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1281 = wave.extract %1212[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1282 = wave.extract %1212[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1283 = wave.extract %1212[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1284 = wave.extract %1216[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1285 = wave.extract %1216[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1286 = wave.extract %1216[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1287 = wave.extract %1216[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1288 = wave.pack %1280, %1281, %1282, %1283, %1284, %1285, %1286, %1287 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1289 = wave.store %1288 -> %1279 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1290 = wave.barrier %1253, %1265, %1277, %1289 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1291 = wave.binary muli %405, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1292 = wave.binary muli %407, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1293 = wave.binary addi %1291, %1292 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1294 = wave.binary muli %411, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1295 = wave.binary addi %1293, %1294 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1296 = wave.binary muli %415, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1297 = wave.binary addi %1295, %1296 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1298 = wave.binary addi %1297, %418 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1299 = wave.binary addi %1298, %458 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1300 = wave.binary muli %426, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1301 = wave.binary addi %1299, %1300 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1302 = wave.binary muli %430, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1303 = wave.binary addi %1301, %1302 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1304 = wave.binary muli %1303, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1305 = wave.ptr_add %1241, %1304 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_298, %token_299 = wave.load %1305 after %1290 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1306 = wave.extract %value_298[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1307 = wave.extract %value_298[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1308 = wave.extract %value_298[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1309 = wave.extract %value_298[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1310 = wave.extract %value_298[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1311 = wave.extract %value_298[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1312 = wave.extract %value_298[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1313 = wave.extract %value_298[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1314 = wave.binary addi %25, %1291 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1315 = wave.binary addi %1314, %1292 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1316 = wave.binary addi %1315, %1294 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1317 = wave.binary addi %1316, %1296 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1318 = wave.binary addi %1317, %418 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1319 = wave.binary addi %1318, %458 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1320 = wave.binary addi %1319, %1300 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1321 = wave.binary addi %1320, %1302 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1322 = wave.binary muli %1321, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1323 = wave.ptr_add %1241, %1322 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_300, %token_301 = wave.load %1323 after %1290 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1324 = wave.extract %value_300[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1325 = wave.extract %value_300[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1326 = wave.extract %value_300[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1327 = wave.extract %value_300[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1328 = wave.extract %value_300[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1329 = wave.extract %value_300[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1330 = wave.extract %value_300[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1331 = wave.extract %value_300[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1332 = wave.binary addi %18, %1291 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1333 = wave.binary addi %1332, %1292 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1334 = wave.binary addi %1333, %1294 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1335 = wave.binary addi %1334, %1296 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1336 = wave.binary addi %1335, %418 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1337 = wave.binary addi %1336, %458 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1338 = wave.binary addi %1337, %1300 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1339 = wave.binary addi %1338, %1302 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1340 = wave.binary muli %1339, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1341 = wave.ptr_add %1241, %1340 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_302, %token_303 = wave.load %1341 after %1290 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1342 = wave.extract %value_302[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1343 = wave.extract %value_302[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1344 = wave.extract %value_302[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1345 = wave.extract %value_302[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1346 = wave.extract %value_302[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1347 = wave.extract %value_302[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1348 = wave.extract %value_302[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1349 = wave.extract %value_302[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1350 = wave.binary addi %17, %1291 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1351 = wave.binary addi %1350, %1292 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1352 = wave.binary addi %1351, %1294 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1353 = wave.binary addi %1352, %1296 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1354 = wave.binary addi %1353, %418 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1355 = wave.binary addi %1354, %458 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1356 = wave.binary addi %1355, %1300 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1357 = wave.binary addi %1356, %1302 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1358 = wave.binary muli %1357, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1359 = wave.ptr_add %1241, %1358 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_304, %token_305 = wave.load %1359 after %1290 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1360 = wave.extract %value_304[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1361 = wave.extract %value_304[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1362 = wave.extract %value_304[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1363 = wave.extract %value_304[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1364 = wave.extract %value_304[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1365 = wave.extract %value_304[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1366 = wave.extract %value_304[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1367 = wave.extract %value_304[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1368 = wave.barrier %token_299, %token_301, %token_303, %token_305 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1369 = wave.extract %1217[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1370 = wave.extract %1217[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1371 = wave.extract %1217[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1372 = wave.extract %1217[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1373 = wave.extract %1221[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1374 = wave.extract %1221[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1375 = wave.extract %1221[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1376 = wave.extract %1221[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1377 = wave.pack %1369, %1370, %1371, %1372, %1373, %1374, %1375, %1376 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1378 = wave.store %1377 -> %1243 after %1368 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1379 = wave.extract %1218[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1380 = wave.extract %1218[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1381 = wave.extract %1218[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1382 = wave.extract %1218[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1383 = wave.extract %1222[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1384 = wave.extract %1222[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1385 = wave.extract %1222[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1386 = wave.extract %1222[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1387 = wave.pack %1379, %1380, %1381, %1382, %1383, %1384, %1385, %1386 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1388 = wave.store %1387 -> %1255 after %1368 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1389 = wave.extract %1219[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1390 = wave.extract %1219[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1391 = wave.extract %1219[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1392 = wave.extract %1219[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1393 = wave.extract %1223[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1394 = wave.extract %1223[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1395 = wave.extract %1223[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1396 = wave.extract %1223[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1397 = wave.pack %1389, %1390, %1391, %1392, %1393, %1394, %1395, %1396 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1398 = wave.store %1397 -> %1267 after %1368 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1399 = wave.extract %1220[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1400 = wave.extract %1220[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1401 = wave.extract %1220[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1402 = wave.extract %1220[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1403 = wave.extract %1224[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1404 = wave.extract %1224[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1405 = wave.extract %1224[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1406 = wave.extract %1224[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1407 = wave.pack %1399, %1400, %1401, %1402, %1403, %1404, %1405, %1406 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1408 = wave.store %1407 -> %1279 after %1368 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1409 = wave.barrier %1378, %1388, %1398, %1408 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_306, %token_307 = wave.load %1305 after %1409 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1410 = wave.extract %value_306[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1411 = wave.extract %value_306[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1412 = wave.extract %value_306[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1413 = wave.extract %value_306[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1414 = wave.extract %value_306[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1415 = wave.extract %value_306[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1416 = wave.extract %value_306[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1417 = wave.extract %value_306[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_308, %token_309 = wave.load %1323 after %1409 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1418 = wave.extract %value_308[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1419 = wave.extract %value_308[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1420 = wave.extract %value_308[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1421 = wave.extract %value_308[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1422 = wave.extract %value_308[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1423 = wave.extract %value_308[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1424 = wave.extract %value_308[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1425 = wave.extract %value_308[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_310, %token_311 = wave.load %1341 after %1409 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1426 = wave.extract %value_310[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1427 = wave.extract %value_310[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1428 = wave.extract %value_310[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1429 = wave.extract %value_310[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1430 = wave.extract %value_310[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1431 = wave.extract %value_310[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1432 = wave.extract %value_310[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1433 = wave.extract %value_310[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_312, %token_313 = wave.load %1359 after %1409 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1434 = wave.extract %value_312[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1435 = wave.extract %value_312[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1436 = wave.extract %value_312[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1437 = wave.extract %value_312[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1438 = wave.extract %value_312[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1439 = wave.extract %value_312[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1440 = wave.extract %value_312[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1441 = wave.extract %value_312[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1442 = wave.barrier %token_307, %token_309, %token_311, %token_313 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1443 = wave.extract %1225[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1444 = wave.extract %1225[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1445 = wave.extract %1225[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1446 = wave.extract %1225[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1447 = wave.extract %1229[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1448 = wave.extract %1229[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1449 = wave.extract %1229[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1450 = wave.extract %1229[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1451 = wave.pack %1443, %1444, %1445, %1446, %1447, %1448, %1449, %1450 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1452 = wave.store %1451 -> %1243 after %1442 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1453 = wave.extract %1226[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1454 = wave.extract %1226[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1455 = wave.extract %1226[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1456 = wave.extract %1226[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1457 = wave.extract %1230[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1458 = wave.extract %1230[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1459 = wave.extract %1230[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1460 = wave.extract %1230[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1461 = wave.pack %1453, %1454, %1455, %1456, %1457, %1458, %1459, %1460 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1462 = wave.store %1461 -> %1255 after %1442 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1463 = wave.extract %1227[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1464 = wave.extract %1227[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1465 = wave.extract %1227[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1466 = wave.extract %1227[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1467 = wave.extract %1231[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1468 = wave.extract %1231[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1469 = wave.extract %1231[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1470 = wave.extract %1231[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1471 = wave.pack %1463, %1464, %1465, %1466, %1467, %1468, %1469, %1470 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1472 = wave.store %1471 -> %1267 after %1442 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1473 = wave.extract %1228[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1474 = wave.extract %1228[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1475 = wave.extract %1228[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1476 = wave.extract %1228[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1477 = wave.extract %1232[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1478 = wave.extract %1232[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1479 = wave.extract %1232[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1480 = wave.extract %1232[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1481 = wave.pack %1473, %1474, %1475, %1476, %1477, %1478, %1479, %1480 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1482 = wave.store %1481 -> %1279 after %1442 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1483 = wave.barrier %1452, %1462, %1472, %1482 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_314, %token_315 = wave.load %1305 after %1483 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1484 = wave.extract %value_314[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1485 = wave.extract %value_314[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1486 = wave.extract %value_314[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1487 = wave.extract %value_314[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1488 = wave.extract %value_314[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1489 = wave.extract %value_314[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1490 = wave.extract %value_314[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1491 = wave.extract %value_314[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_316, %token_317 = wave.load %1323 after %1483 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1492 = wave.extract %value_316[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1493 = wave.extract %value_316[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1494 = wave.extract %value_316[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1495 = wave.extract %value_316[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1496 = wave.extract %value_316[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1497 = wave.extract %value_316[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1498 = wave.extract %value_316[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1499 = wave.extract %value_316[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_318, %token_319 = wave.load %1341 after %1483 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1500 = wave.extract %value_318[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1501 = wave.extract %value_318[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1502 = wave.extract %value_318[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1503 = wave.extract %value_318[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1504 = wave.extract %value_318[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1505 = wave.extract %value_318[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1506 = wave.extract %value_318[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1507 = wave.extract %value_318[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_320, %token_321 = wave.load %1359 after %1483 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1508 = wave.extract %value_320[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1509 = wave.extract %value_320[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1510 = wave.extract %value_320[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1511 = wave.extract %value_320[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1512 = wave.extract %value_320[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1513 = wave.extract %value_320[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1514 = wave.extract %value_320[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1515 = wave.extract %value_320[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1516 = wave.barrier %token_315, %token_317, %token_319, %token_321 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1517 = wave.extract %1233[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1518 = wave.extract %1233[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1519 = wave.extract %1233[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1520 = wave.extract %1233[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1521 = wave.extract %1237[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1522 = wave.extract %1237[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1523 = wave.extract %1237[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1524 = wave.extract %1237[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1525 = wave.pack %1517, %1518, %1519, %1520, %1521, %1522, %1523, %1524 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1526 = wave.store %1525 -> %1243 after %1516 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1527 = wave.extract %1234[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1528 = wave.extract %1234[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1529 = wave.extract %1234[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1530 = wave.extract %1234[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1531 = wave.extract %1238[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1532 = wave.extract %1238[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1533 = wave.extract %1238[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1534 = wave.extract %1238[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1535 = wave.pack %1527, %1528, %1529, %1530, %1531, %1532, %1533, %1534 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1536 = wave.store %1535 -> %1255 after %1516 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1537 = wave.extract %1235[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1538 = wave.extract %1235[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1539 = wave.extract %1235[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1540 = wave.extract %1235[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1541 = wave.extract %1239[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1542 = wave.extract %1239[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1543 = wave.extract %1239[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1544 = wave.extract %1239[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1545 = wave.pack %1537, %1538, %1539, %1540, %1541, %1542, %1543, %1544 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1546 = wave.store %1545 -> %1267 after %1516 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1547 = wave.extract %1236[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1548 = wave.extract %1236[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1549 = wave.extract %1236[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1550 = wave.extract %1236[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1551 = wave.extract %1240[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1552 = wave.extract %1240[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1553 = wave.extract %1240[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1554 = wave.extract %1240[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1555 = wave.pack %1547, %1548, %1549, %1550, %1551, %1552, %1553, %1554 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1556 = wave.store %1555 -> %1279 after %1516 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1557 = wave.barrier %1526, %1536, %1546, %1556 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_322, %token_323 = wave.load %1305 after %1557 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1558 = wave.extract %value_322[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1559 = wave.extract %value_322[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1560 = wave.extract %value_322[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1561 = wave.extract %value_322[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1562 = wave.extract %value_322[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1563 = wave.extract %value_322[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1564 = wave.extract %value_322[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1565 = wave.extract %value_322[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_324, %token_325 = wave.load %1323 after %1557 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1566 = wave.extract %value_324[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1567 = wave.extract %value_324[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1568 = wave.extract %value_324[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1569 = wave.extract %value_324[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1570 = wave.extract %value_324[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1571 = wave.extract %value_324[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1572 = wave.extract %value_324[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1573 = wave.extract %value_324[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_326, %token_327 = wave.load %1341 after %1557 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1574 = wave.extract %value_326[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1575 = wave.extract %value_326[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1576 = wave.extract %value_326[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1577 = wave.extract %value_326[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1578 = wave.extract %value_326[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1579 = wave.extract %value_326[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1580 = wave.extract %value_326[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1581 = wave.extract %value_326[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_328, %token_329 = wave.load %1359 after %1557 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1582 = wave.extract %value_328[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1583 = wave.extract %value_328[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1584 = wave.extract %value_328[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1585 = wave.extract %value_328[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1586 = wave.extract %value_328[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1587 = wave.extract %value_328[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1588 = wave.extract %value_328[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1589 = wave.extract %value_328[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1590 = wave.barrier %token_323, %token_325, %token_327, %token_329 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1591 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %1592 = wave.binary xori %459, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1593 = wave.binary xori %1592, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1594 = wave.binary muli %405, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1595 = wave.binary muli %407, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1596 = wave.binary xori %1594, %1595 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1597 = wave.binary muli %411, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1598 = wave.binary xori %1596, %1597 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1599 = wave.binary muli %415, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1600 = wave.binary xori %1598, %1599 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1601 = wave.splat %arg9 : i32 -> !wave.simd<i32, 64>
      %1602 = wave.binary muli %1593, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1603 = wave.binary addi %1600, %1602 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1604 = wave.binary addi %1603, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1605 = wave.binary muli %69, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1606 = wave.binary addi %1604, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1607 = wave.binary xori %25, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1608 = wave.binary xori %1607, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1609 = wave.binary xori %1608, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1610 = wave.binary xori %1609, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1611 = wave.binary muli %1610, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1612 = wave.binary addi %1600, %1611 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1613 = wave.binary addi %1612, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1614 = wave.binary addi %1613, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1615 = wave.binary xori %24, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1616 = wave.binary xori %1615, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1617 = wave.binary xori %1616, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1618 = wave.binary xori %1617, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1619 = wave.binary muli %1618, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1620 = wave.binary addi %1600, %1619 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1621 = wave.binary addi %1620, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1622 = wave.binary addi %1621, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1623 = wave.binary xori %23, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1624 = wave.binary xori %1623, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1625 = wave.binary xori %1624, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1626 = wave.binary xori %1625, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1627 = wave.binary muli %1626, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1628 = wave.binary addi %1600, %1627 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1629 = wave.binary addi %1628, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1630 = wave.binary addi %1629, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1631 = wave.binary xori %22, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1632 = wave.binary xori %1631, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1633 = wave.binary xori %1632, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1634 = wave.binary xori %1633, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1635 = wave.binary muli %1634, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1636 = wave.binary addi %1600, %1635 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1637 = wave.binary addi %1636, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1638 = wave.binary addi %1637, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1639 = wave.binary xori %21, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1640 = wave.binary xori %1639, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1641 = wave.binary xori %1640, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1642 = wave.binary xori %1641, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1643 = wave.binary muli %1642, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1644 = wave.binary addi %1600, %1643 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1645 = wave.binary addi %1644, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1646 = wave.binary addi %1645, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1647 = wave.binary xori %20, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1648 = wave.binary xori %1647, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1649 = wave.binary xori %1648, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1650 = wave.binary xori %1649, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1651 = wave.binary muli %1650, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1652 = wave.binary addi %1600, %1651 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1653 = wave.binary addi %1652, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1654 = wave.binary addi %1653, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1655 = wave.binary xori %19, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1656 = wave.binary xori %1655, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1657 = wave.binary xori %1656, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1658 = wave.binary xori %1657, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1659 = wave.binary muli %1658, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1660 = wave.binary addi %1600, %1659 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1661 = wave.binary addi %1660, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1662 = wave.binary addi %1661, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1663 = wave.binary xori %18, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1664 = wave.binary xori %1663, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1665 = wave.binary xori %1664, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1666 = wave.binary xori %1665, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1667 = wave.binary muli %1666, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1668 = wave.binary addi %1600, %1667 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1669 = wave.binary addi %1668, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1670 = wave.binary addi %1669, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1671 = wave.binary xori %17, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1672 = wave.binary xori %1671, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1673 = wave.binary xori %1672, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1674 = wave.binary xori %1673, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1675 = wave.binary muli %1674, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1676 = wave.binary addi %1600, %1675 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1677 = wave.binary addi %1676, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1678 = wave.binary addi %1677, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1679 = wave.binary xori %16, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1680 = wave.binary xori %1679, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1681 = wave.binary xori %1680, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1682 = wave.binary xori %1681, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1683 = wave.binary muli %1682, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1684 = wave.binary addi %1600, %1683 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1685 = wave.binary addi %1684, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1686 = wave.binary addi %1685, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1687 = wave.binary xori %15, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1688 = wave.binary xori %1687, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1689 = wave.binary xori %1688, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1690 = wave.binary xori %1689, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1691 = wave.binary muli %1690, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1692 = wave.binary addi %1600, %1691 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1693 = wave.binary addi %1692, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1694 = wave.binary addi %1693, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1695 = wave.binary xori %14, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1696 = wave.binary xori %1695, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1697 = wave.binary xori %1696, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1698 = wave.binary xori %1697, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1699 = wave.binary muli %1698, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1700 = wave.binary addi %1600, %1699 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1701 = wave.binary addi %1700, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1702 = wave.binary addi %1701, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1703 = wave.binary xori %13, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1704 = wave.binary xori %1703, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1705 = wave.binary xori %1704, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1706 = wave.binary xori %1705, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1707 = wave.binary muli %1706, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1708 = wave.binary addi %1600, %1707 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1709 = wave.binary addi %1708, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1710 = wave.binary addi %1709, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1711 = wave.binary xori %12, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1712 = wave.binary xori %1711, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1713 = wave.binary xori %1712, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1714 = wave.binary xori %1713, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1715 = wave.binary muli %1714, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1716 = wave.binary addi %1600, %1715 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1717 = wave.binary addi %1716, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1718 = wave.binary addi %1717, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1719 = wave.binary xori %11, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1720 = wave.binary xori %1719, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1721 = wave.binary xori %1720, %1300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1722 = wave.binary xori %1721, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1723 = wave.binary muli %1722, %1601 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1724 = wave.binary addi %1600, %1723 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1725 = wave.binary addi %1724, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1726 = wave.binary addi %1725, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1727 = wave.cmpi ne %1193, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1728 = wave.pack %1306, %1307, %1308, %1309, %1324, %1325, %1326, %1327 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1729 = wave.assume %1606 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1730 = wave.ptr_add %1591, %1729 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1731 = wave.ptr_add %1591, %0 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1732 = wave.select %1727, %1730, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1733 = wave.store %1728 -> %1732 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1734 = wave.cmpi ne %1194, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1735 = wave.pack %1342, %1343, %1344, %1345, %1360, %1361, %1362, %1363 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1736 = wave.assume %1614 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1737 = wave.ptr_add %1591, %1736 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1738 = wave.select %1734, %1737, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1739 = wave.store %1735 -> %1738 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1740 = wave.cmpi ne %1195, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1741 = wave.pack %1310, %1311, %1312, %1313, %1328, %1329, %1330, %1331 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1742 = wave.assume %1622 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1743 = wave.ptr_add %1591, %1742 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1744 = wave.select %1740, %1743, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1745 = wave.store %1741 -> %1744 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1746 = wave.cmpi ne %1196, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1747 = wave.pack %1346, %1347, %1348, %1349, %1364, %1365, %1366, %1367 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1748 = wave.assume %1630 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1749 = wave.ptr_add %1591, %1748 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1750 = wave.select %1746, %1749, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1751 = wave.store %1747 -> %1750 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1752 = wave.cmpi ne %1197, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1753 = wave.pack %1410, %1411, %1412, %1413, %1418, %1419, %1420, %1421 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1754 = wave.assume %1638 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1755 = wave.ptr_add %1591, %1754 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1756 = wave.select %1752, %1755, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1757 = wave.store %1753 -> %1756 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1758 = wave.cmpi ne %1198, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1759 = wave.pack %1426, %1427, %1428, %1429, %1434, %1435, %1436, %1437 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1760 = wave.assume %1646 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1761 = wave.ptr_add %1591, %1760 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1762 = wave.select %1758, %1761, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1763 = wave.store %1759 -> %1762 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1764 = wave.cmpi ne %1199, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1765 = wave.pack %1414, %1415, %1416, %1417, %1422, %1423, %1424, %1425 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1766 = wave.assume %1654 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1767 = wave.ptr_add %1591, %1766 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1768 = wave.select %1764, %1767, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1769 = wave.store %1765 -> %1768 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1770 = wave.cmpi ne %1200, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1771 = wave.pack %1430, %1431, %1432, %1433, %1438, %1439, %1440, %1441 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1772 = wave.assume %1662 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1773 = wave.ptr_add %1591, %1772 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1774 = wave.select %1770, %1773, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1775 = wave.store %1771 -> %1774 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1776 = wave.cmpi ne %1201, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1777 = wave.pack %1484, %1485, %1486, %1487, %1492, %1493, %1494, %1495 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1778 = wave.assume %1670 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1779 = wave.ptr_add %1591, %1778 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1780 = wave.select %1776, %1779, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1781 = wave.store %1777 -> %1780 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1782 = wave.cmpi ne %1202, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1783 = wave.pack %1500, %1501, %1502, %1503, %1508, %1509, %1510, %1511 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1784 = wave.assume %1678 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1785 = wave.ptr_add %1591, %1784 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1786 = wave.select %1782, %1785, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1787 = wave.store %1783 -> %1786 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1788 = wave.cmpi ne %1203, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1789 = wave.pack %1488, %1489, %1490, %1491, %1496, %1497, %1498, %1499 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1790 = wave.assume %1686 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1791 = wave.ptr_add %1591, %1790 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1792 = wave.select %1788, %1791, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1793 = wave.store %1789 -> %1792 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1794 = wave.cmpi ne %1204, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1795 = wave.pack %1504, %1505, %1506, %1507, %1512, %1513, %1514, %1515 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1796 = wave.assume %1694 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1797 = wave.ptr_add %1591, %1796 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1798 = wave.select %1794, %1797, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1799 = wave.store %1795 -> %1798 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1800 = wave.cmpi ne %1205, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1801 = wave.pack %1558, %1559, %1560, %1561, %1566, %1567, %1568, %1569 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1802 = wave.assume %1702 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1803 = wave.ptr_add %1591, %1802 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1804 = wave.select %1800, %1803, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1805 = wave.store %1801 -> %1804 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1806 = wave.cmpi ne %1206, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1807 = wave.pack %1574, %1575, %1576, %1577, %1582, %1583, %1584, %1585 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1808 = wave.assume %1710 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1809 = wave.ptr_add %1591, %1808 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1810 = wave.select %1806, %1809, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1811 = wave.store %1807 -> %1810 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1812 = wave.cmpi ne %1207, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1813 = wave.pack %1562, %1563, %1564, %1565, %1570, %1571, %1572, %1573 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1814 = wave.assume %1718 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1815 = wave.ptr_add %1591, %1814 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1816 = wave.select %1812, %1815, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1817 = wave.store %1813 -> %1816 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1818 = wave.cmpi ne %1208, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1819 = wave.pack %1578, %1579, %1580, %1581, %1586, %1587, %1588, %1589 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1820 = wave.assume %1726 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1821 = wave.ptr_add %1591, %1820 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1822 = wave.select %1818, %1821, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1823 = wave.store %1819 -> %1822 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1824 = waveamd.fragment_pack %value_266 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1825 = waveamd.fragment_pack %value_268 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1826 = waveamd.fragment_pack %value_270 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1827 = waveamd.fragment_pack %value_272 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1828 = waveamd.fragment_pack %value_274 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1829 = waveamd.fragment_pack %value_276 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1830 = waveamd.fragment_pack %value_278 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1831 = waveamd.fragment_pack %value_280 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1832 = waveamd.fragment_pack %816 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1833 = waveamd.fragment_pack %819 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1834 = waveamd.fragment_pack %822 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1835 = waveamd.fragment_pack %825 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1836 = waveamd.fragment_pack %828 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1837 = waveamd.fragment_pack %831 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1838 = waveamd.fragment_pack %834 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1839 = waveamd.fragment_pack %837 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1840 = waveamd.fragment_pack %840 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1841 = waveamd.fragment_pack %843 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1842 = waveamd.fragment_pack %846 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1843 = waveamd.fragment_pack %849 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1844 = waveamd.fragment_pack %852 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1845 = waveamd.fragment_pack %855 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1846 = waveamd.fragment_pack %858 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1847 = waveamd.fragment_pack %861 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1848 = waveamd.fragment_pack %864 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1849 = waveamd.fragment_pack %867 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1850 = waveamd.fragment_pack %870 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1851 = waveamd.fragment_pack %873 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1852 = waveamd.fragment_pack %876 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1853 = waveamd.fragment_pack %879 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1854 = waveamd.fragment_pack %882 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1855 = waveamd.fragment_pack %885 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1856 = waveamd.fragment_pack %888 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1857 = waveamd.fragment_pack %891 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1858 = waveamd.fragment_pack %894 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1859 = waveamd.fragment_pack %897 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1860 = waveamd.fragment_pack %900 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1861 = waveamd.fragment_pack %903 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1862 = waveamd.fragment_pack %906 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1863 = waveamd.fragment_pack %909 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1864 = wave.pack %value_282, %value_284, %value_286, %value_288, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1865 = wave.pack %value_290, %value_292, %value_294, %value_296, %26, %26, %26, %26 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1866 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1824, %1864, %986, %1042, %1832 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1867 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1825, %1864, %987, %1042, %1866 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1868 = waveamd.fragment_unpack %1867 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1869 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1826, %1864, %986, %1042, %1833 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1870 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1827, %1864, %987, %1042, %1869 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1871 = waveamd.fragment_unpack %1870 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1872 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1828, %1865, %986, %1042, %1834 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1873 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1829, %1865, %987, %1042, %1872 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1874 = waveamd.fragment_unpack %1873 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1875 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1830, %1865, %986, %1042, %1835 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1876 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1831, %1865, %987, %1042, %1875 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1877 = waveamd.fragment_unpack %1876 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1878 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1824, %1864, %988, %1042, %1836 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1879 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1825, %1864, %989, %1042, %1878 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1880 = waveamd.fragment_unpack %1879 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1881 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1826, %1864, %988, %1042, %1837 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1882 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1827, %1864, %989, %1042, %1881 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1883 = waveamd.fragment_unpack %1882 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1884 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1828, %1865, %988, %1042, %1838 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1885 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1829, %1865, %989, %1042, %1884 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1886 = waveamd.fragment_unpack %1885 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1887 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1830, %1865, %988, %1042, %1839 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1888 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1831, %1865, %989, %1042, %1887 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1889 = waveamd.fragment_unpack %1888 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1890 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1824, %1864, %990, %1043, %1840 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1891 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1825, %1864, %991, %1043, %1890 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1892 = waveamd.fragment_unpack %1891 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1893 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1826, %1864, %990, %1043, %1841 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1894 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1827, %1864, %991, %1043, %1893 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1895 = waveamd.fragment_unpack %1894 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1896 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1828, %1865, %990, %1043, %1842 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1897 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1829, %1865, %991, %1043, %1896 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1898 = waveamd.fragment_unpack %1897 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1899 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1830, %1865, %990, %1043, %1843 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1900 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1831, %1865, %991, %1043, %1899 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1901 = waveamd.fragment_unpack %1900 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1902 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1824, %1864, %992, %1043, %1844 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1903 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1825, %1864, %993, %1043, %1902 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1904 = waveamd.fragment_unpack %1903 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1905 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1826, %1864, %992, %1043, %1845 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1906 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1827, %1864, %993, %1043, %1905 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1907 = waveamd.fragment_unpack %1906 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1908 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1828, %1865, %992, %1043, %1846 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1909 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1829, %1865, %993, %1043, %1908 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1910 = waveamd.fragment_unpack %1909 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1911 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1830, %1865, %992, %1043, %1847 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1912 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1831, %1865, %993, %1043, %1911 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1913 = waveamd.fragment_unpack %1912 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1914 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1824, %1864, %994, %1044, %1848 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1915 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1825, %1864, %995, %1044, %1914 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1916 = waveamd.fragment_unpack %1915 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1917 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1826, %1864, %994, %1044, %1849 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1918 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1827, %1864, %995, %1044, %1917 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1919 = waveamd.fragment_unpack %1918 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1920 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1828, %1865, %994, %1044, %1850 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1921 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1829, %1865, %995, %1044, %1920 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1922 = waveamd.fragment_unpack %1921 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1923 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1830, %1865, %994, %1044, %1851 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1924 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1831, %1865, %995, %1044, %1923 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1925 = waveamd.fragment_unpack %1924 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1926 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1824, %1864, %996, %1044, %1852 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1927 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1825, %1864, %997, %1044, %1926 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1928 = waveamd.fragment_unpack %1927 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1929 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1826, %1864, %996, %1044, %1853 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1930 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1827, %1864, %997, %1044, %1929 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1931 = waveamd.fragment_unpack %1930 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1932 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1828, %1865, %996, %1044, %1854 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1933 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1829, %1865, %997, %1044, %1932 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1934 = waveamd.fragment_unpack %1933 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1935 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1830, %1865, %996, %1044, %1855 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1936 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1831, %1865, %997, %1044, %1935 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1937 = waveamd.fragment_unpack %1936 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1938 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1824, %1864, %998, %1045, %1856 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1939 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1825, %1864, %999, %1045, %1938 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1940 = waveamd.fragment_unpack %1939 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1941 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1826, %1864, %998, %1045, %1857 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1942 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1827, %1864, %999, %1045, %1941 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1943 = waveamd.fragment_unpack %1942 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1944 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1828, %1865, %998, %1045, %1858 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1945 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1829, %1865, %999, %1045, %1944 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1946 = waveamd.fragment_unpack %1945 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1947 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1830, %1865, %998, %1045, %1859 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1948 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1831, %1865, %999, %1045, %1947 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1949 = waveamd.fragment_unpack %1948 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1950 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1824, %1864, %1000, %1045, %1860 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1951 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1825, %1864, %1001, %1045, %1950 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1952 = waveamd.fragment_unpack %1951 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1953 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1826, %1864, %1000, %1045, %1861 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1954 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1827, %1864, %1001, %1045, %1953 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1955 = waveamd.fragment_unpack %1954 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1956 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1828, %1865, %1000, %1045, %1862 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1957 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1829, %1865, %1001, %1045, %1956 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1958 = waveamd.fragment_unpack %1957 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1959 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1830, %1865, %1000, %1045, %1863 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1960 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1831, %1865, %1001, %1045, %1959 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1961 = waveamd.fragment_unpack %1960 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1962 = wave.binary addi %88, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %1963 = wave.splat %1962 : i32 -> !wave.simd<i32, 64>
      %1964 = wave.binary addi %1963, %87 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1965 = wave.cmpi slt %1964, %1190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1966 = wave.select %1965, %7, %6 : !wave.mask<64>, !wave.simd<i32, 64>
      %1967 = wave.binary andi %1174, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1968 = wave.binary andi %1175, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1969 = wave.binary andi %1176, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1970 = wave.binary andi %1177, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1971 = wave.binary andi %1178, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1972 = wave.binary andi %1179, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1973 = wave.binary andi %1180, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1974 = wave.binary andi %1181, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1975 = wave.binary andi %1182, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1976 = wave.binary andi %1183, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1977 = wave.binary andi %1184, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1978 = wave.binary andi %1185, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1979 = wave.binary andi %1186, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1980 = wave.binary andi %1187, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1981 = wave.binary andi %1188, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1982 = wave.binary andi %1189, %1966 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1983 = wave.cast fpconvert %1868 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1984 = wave.cast fpconvert %1871 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1985 = wave.cast fpconvert %1874 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1986 = wave.cast fpconvert %1877 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1987 = wave.cast fpconvert %1880 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1988 = wave.cast fpconvert %1883 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1989 = wave.cast fpconvert %1886 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1990 = wave.cast fpconvert %1889 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1991 = wave.cast fpconvert %1892 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1992 = wave.cast fpconvert %1895 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1993 = wave.cast fpconvert %1898 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1994 = wave.cast fpconvert %1901 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1995 = wave.cast fpconvert %1904 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1996 = wave.cast fpconvert %1907 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1997 = wave.cast fpconvert %1910 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1998 = wave.cast fpconvert %1913 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1999 = wave.cast fpconvert %1916 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2000 = wave.cast fpconvert %1919 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2001 = wave.cast fpconvert %1922 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2002 = wave.cast fpconvert %1925 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2003 = wave.cast fpconvert %1928 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2004 = wave.cast fpconvert %1931 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2005 = wave.cast fpconvert %1934 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2006 = wave.cast fpconvert %1937 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2007 = wave.cast fpconvert %1940 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2008 = wave.cast fpconvert %1943 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2009 = wave.cast fpconvert %1946 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2010 = wave.cast fpconvert %1949 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2011 = wave.cast fpconvert %1952 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2012 = wave.cast fpconvert %1955 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2013 = wave.cast fpconvert %1958 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2014 = wave.cast fpconvert %1961 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %2015 = wave.extract %1983[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2016 = wave.extract %1983[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2017 = wave.extract %1983[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2018 = wave.extract %1983[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2019 = wave.extract %1987[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2020 = wave.extract %1987[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2021 = wave.extract %1987[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2022 = wave.extract %1987[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2023 = wave.pack %2015, %2016, %2017, %2018, %2019, %2020, %2021, %2022 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2024 = wave.store %2023 -> %1243 after %1590 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2025 = wave.extract %1984[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2026 = wave.extract %1984[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2027 = wave.extract %1984[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2028 = wave.extract %1984[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2029 = wave.extract %1988[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2030 = wave.extract %1988[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2031 = wave.extract %1988[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2032 = wave.extract %1988[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2033 = wave.pack %2025, %2026, %2027, %2028, %2029, %2030, %2031, %2032 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2034 = wave.store %2033 -> %1255 after %1590 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2035 = wave.extract %1985[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2036 = wave.extract %1985[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2037 = wave.extract %1985[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2038 = wave.extract %1985[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2039 = wave.extract %1989[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2040 = wave.extract %1989[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2041 = wave.extract %1989[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2042 = wave.extract %1989[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2043 = wave.pack %2035, %2036, %2037, %2038, %2039, %2040, %2041, %2042 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2044 = wave.store %2043 -> %1267 after %1590 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2045 = wave.extract %1986[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2046 = wave.extract %1986[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2047 = wave.extract %1986[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2048 = wave.extract %1986[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2049 = wave.extract %1990[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2050 = wave.extract %1990[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2051 = wave.extract %1990[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2052 = wave.extract %1990[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2053 = wave.pack %2045, %2046, %2047, %2048, %2049, %2050, %2051, %2052 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2054 = wave.store %2053 -> %1279 after %1590 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2055 = wave.barrier %2024, %2034, %2044, %2054 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_330, %token_331 = wave.load %1305 after %2055 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2056 = wave.extract %value_330[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2057 = wave.extract %value_330[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2058 = wave.extract %value_330[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2059 = wave.extract %value_330[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2060 = wave.extract %value_330[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2061 = wave.extract %value_330[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2062 = wave.extract %value_330[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2063 = wave.extract %value_330[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_332, %token_333 = wave.load %1323 after %2055 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2064 = wave.extract %value_332[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2065 = wave.extract %value_332[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2066 = wave.extract %value_332[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2067 = wave.extract %value_332[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2068 = wave.extract %value_332[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2069 = wave.extract %value_332[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2070 = wave.extract %value_332[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2071 = wave.extract %value_332[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_334, %token_335 = wave.load %1341 after %2055 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2072 = wave.extract %value_334[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2073 = wave.extract %value_334[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2074 = wave.extract %value_334[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2075 = wave.extract %value_334[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2076 = wave.extract %value_334[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2077 = wave.extract %value_334[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2078 = wave.extract %value_334[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2079 = wave.extract %value_334[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_336, %token_337 = wave.load %1359 after %2055 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2080 = wave.extract %value_336[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2081 = wave.extract %value_336[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2082 = wave.extract %value_336[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2083 = wave.extract %value_336[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2084 = wave.extract %value_336[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2085 = wave.extract %value_336[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2086 = wave.extract %value_336[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2087 = wave.extract %value_336[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2088 = wave.barrier %token_331, %token_333, %token_335, %token_337 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %2089 = wave.extract %1991[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2090 = wave.extract %1991[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2091 = wave.extract %1991[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2092 = wave.extract %1991[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2093 = wave.extract %1995[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2094 = wave.extract %1995[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2095 = wave.extract %1995[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2096 = wave.extract %1995[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2097 = wave.pack %2089, %2090, %2091, %2092, %2093, %2094, %2095, %2096 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2098 = wave.store %2097 -> %1243 after %2088 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2099 = wave.extract %1992[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2100 = wave.extract %1992[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2101 = wave.extract %1992[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2102 = wave.extract %1992[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2103 = wave.extract %1996[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2104 = wave.extract %1996[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2105 = wave.extract %1996[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2106 = wave.extract %1996[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2107 = wave.pack %2099, %2100, %2101, %2102, %2103, %2104, %2105, %2106 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2108 = wave.store %2107 -> %1255 after %2088 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2109 = wave.extract %1993[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2110 = wave.extract %1993[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2111 = wave.extract %1993[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2112 = wave.extract %1993[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2113 = wave.extract %1997[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2114 = wave.extract %1997[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2115 = wave.extract %1997[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2116 = wave.extract %1997[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2117 = wave.pack %2109, %2110, %2111, %2112, %2113, %2114, %2115, %2116 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2118 = wave.store %2117 -> %1267 after %2088 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2119 = wave.extract %1994[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2120 = wave.extract %1994[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2121 = wave.extract %1994[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2122 = wave.extract %1994[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2123 = wave.extract %1998[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2124 = wave.extract %1998[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2125 = wave.extract %1998[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2126 = wave.extract %1998[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2127 = wave.pack %2119, %2120, %2121, %2122, %2123, %2124, %2125, %2126 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2128 = wave.store %2127 -> %1279 after %2088 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2129 = wave.barrier %2098, %2108, %2118, %2128 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_338, %token_339 = wave.load %1305 after %2129 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2130 = wave.extract %value_338[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2131 = wave.extract %value_338[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2132 = wave.extract %value_338[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2133 = wave.extract %value_338[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2134 = wave.extract %value_338[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2135 = wave.extract %value_338[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2136 = wave.extract %value_338[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2137 = wave.extract %value_338[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_340, %token_341 = wave.load %1323 after %2129 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2138 = wave.extract %value_340[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2139 = wave.extract %value_340[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2140 = wave.extract %value_340[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2141 = wave.extract %value_340[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2142 = wave.extract %value_340[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2143 = wave.extract %value_340[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2144 = wave.extract %value_340[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2145 = wave.extract %value_340[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_342, %token_343 = wave.load %1341 after %2129 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2146 = wave.extract %value_342[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2147 = wave.extract %value_342[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2148 = wave.extract %value_342[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2149 = wave.extract %value_342[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2150 = wave.extract %value_342[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2151 = wave.extract %value_342[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2152 = wave.extract %value_342[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2153 = wave.extract %value_342[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_344, %token_345 = wave.load %1359 after %2129 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2154 = wave.extract %value_344[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2155 = wave.extract %value_344[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2156 = wave.extract %value_344[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2157 = wave.extract %value_344[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2158 = wave.extract %value_344[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2159 = wave.extract %value_344[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2160 = wave.extract %value_344[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2161 = wave.extract %value_344[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2162 = wave.barrier %token_339, %token_341, %token_343, %token_345 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %2163 = wave.extract %1999[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2164 = wave.extract %1999[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2165 = wave.extract %1999[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2166 = wave.extract %1999[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2167 = wave.extract %2003[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2168 = wave.extract %2003[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2169 = wave.extract %2003[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2170 = wave.extract %2003[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2171 = wave.pack %2163, %2164, %2165, %2166, %2167, %2168, %2169, %2170 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2172 = wave.store %2171 -> %1243 after %2162 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2173 = wave.extract %2000[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2174 = wave.extract %2000[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2175 = wave.extract %2000[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2176 = wave.extract %2000[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2177 = wave.extract %2004[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2178 = wave.extract %2004[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2179 = wave.extract %2004[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2180 = wave.extract %2004[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2181 = wave.pack %2173, %2174, %2175, %2176, %2177, %2178, %2179, %2180 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2182 = wave.store %2181 -> %1255 after %2162 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2183 = wave.extract %2001[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2184 = wave.extract %2001[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2185 = wave.extract %2001[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2186 = wave.extract %2001[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2187 = wave.extract %2005[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2188 = wave.extract %2005[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2189 = wave.extract %2005[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2190 = wave.extract %2005[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2191 = wave.pack %2183, %2184, %2185, %2186, %2187, %2188, %2189, %2190 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2192 = wave.store %2191 -> %1267 after %2162 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2193 = wave.extract %2002[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2194 = wave.extract %2002[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2195 = wave.extract %2002[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2196 = wave.extract %2002[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2197 = wave.extract %2006[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2198 = wave.extract %2006[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2199 = wave.extract %2006[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2200 = wave.extract %2006[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2201 = wave.pack %2193, %2194, %2195, %2196, %2197, %2198, %2199, %2200 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2202 = wave.store %2201 -> %1279 after %2162 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2203 = wave.barrier %2172, %2182, %2192, %2202 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_346, %token_347 = wave.load %1305 after %2203 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2204 = wave.extract %value_346[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2205 = wave.extract %value_346[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2206 = wave.extract %value_346[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2207 = wave.extract %value_346[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2208 = wave.extract %value_346[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2209 = wave.extract %value_346[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2210 = wave.extract %value_346[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2211 = wave.extract %value_346[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_348, %token_349 = wave.load %1323 after %2203 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2212 = wave.extract %value_348[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2213 = wave.extract %value_348[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2214 = wave.extract %value_348[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2215 = wave.extract %value_348[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2216 = wave.extract %value_348[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2217 = wave.extract %value_348[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2218 = wave.extract %value_348[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2219 = wave.extract %value_348[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_350, %token_351 = wave.load %1341 after %2203 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2220 = wave.extract %value_350[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2221 = wave.extract %value_350[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2222 = wave.extract %value_350[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2223 = wave.extract %value_350[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2224 = wave.extract %value_350[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2225 = wave.extract %value_350[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2226 = wave.extract %value_350[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2227 = wave.extract %value_350[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_352, %token_353 = wave.load %1359 after %2203 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2228 = wave.extract %value_352[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2229 = wave.extract %value_352[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2230 = wave.extract %value_352[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2231 = wave.extract %value_352[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2232 = wave.extract %value_352[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2233 = wave.extract %value_352[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2234 = wave.extract %value_352[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2235 = wave.extract %value_352[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2236 = wave.barrier %token_347, %token_349, %token_351, %token_353 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %2237 = wave.extract %2007[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2238 = wave.extract %2007[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2239 = wave.extract %2007[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2240 = wave.extract %2007[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2241 = wave.extract %2011[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2242 = wave.extract %2011[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2243 = wave.extract %2011[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2244 = wave.extract %2011[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2245 = wave.pack %2237, %2238, %2239, %2240, %2241, %2242, %2243, %2244 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2246 = wave.store %2245 -> %1243 after %2236 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2247 = wave.extract %2008[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2248 = wave.extract %2008[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2249 = wave.extract %2008[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2250 = wave.extract %2008[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2251 = wave.extract %2012[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2252 = wave.extract %2012[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2253 = wave.extract %2012[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2254 = wave.extract %2012[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2255 = wave.pack %2247, %2248, %2249, %2250, %2251, %2252, %2253, %2254 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2256 = wave.store %2255 -> %1255 after %2236 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2257 = wave.extract %2009[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2258 = wave.extract %2009[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2259 = wave.extract %2009[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2260 = wave.extract %2009[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2261 = wave.extract %2013[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2262 = wave.extract %2013[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2263 = wave.extract %2013[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2264 = wave.extract %2013[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2265 = wave.pack %2257, %2258, %2259, %2260, %2261, %2262, %2263, %2264 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2266 = wave.store %2265 -> %1267 after %2236 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2267 = wave.extract %2010[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2268 = wave.extract %2010[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2269 = wave.extract %2010[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2270 = wave.extract %2010[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2271 = wave.extract %2014[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2272 = wave.extract %2014[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2273 = wave.extract %2014[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2274 = wave.extract %2014[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %2275 = wave.pack %2267, %2268, %2269, %2270, %2271, %2272, %2273, %2274 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2276 = wave.store %2275 -> %1279 after %2236 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %2277 = wave.barrier %2246, %2256, %2266, %2276 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_354, %token_355 = wave.load %1305 after %2277 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2278 = wave.extract %value_354[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2279 = wave.extract %value_354[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2280 = wave.extract %value_354[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2281 = wave.extract %value_354[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2282 = wave.extract %value_354[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2283 = wave.extract %value_354[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2284 = wave.extract %value_354[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2285 = wave.extract %value_354[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_356, %token_357 = wave.load %1323 after %2277 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2286 = wave.extract %value_356[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2287 = wave.extract %value_356[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2288 = wave.extract %value_356[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2289 = wave.extract %value_356[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2290 = wave.extract %value_356[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2291 = wave.extract %value_356[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2292 = wave.extract %value_356[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2293 = wave.extract %value_356[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_358, %token_359 = wave.load %1341 after %2277 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2294 = wave.extract %value_358[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2295 = wave.extract %value_358[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2296 = wave.extract %value_358[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2297 = wave.extract %value_358[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2298 = wave.extract %value_358[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2299 = wave.extract %value_358[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2300 = wave.extract %value_358[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2301 = wave.extract %value_358[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_360, %token_361 = wave.load %1359 after %2277 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %2302 = wave.extract %value_360[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2303 = wave.extract %value_360[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2304 = wave.extract %value_360[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2305 = wave.extract %value_360[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2306 = wave.extract %value_360[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2307 = wave.extract %value_360[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2308 = wave.extract %value_360[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2309 = wave.extract %value_360[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %2310 = wave.barrier %token_355, %token_357, %token_359, %token_361 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %2311 = wave.binary addi %1603, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2312 = wave.binary addi %2311, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2313 = wave.binary addi %1612, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2314 = wave.binary addi %2313, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2315 = wave.binary addi %1620, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2316 = wave.binary addi %2315, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2317 = wave.binary addi %1628, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2318 = wave.binary addi %2317, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2319 = wave.binary addi %1636, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2320 = wave.binary addi %2319, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2321 = wave.binary addi %1644, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2322 = wave.binary addi %2321, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2323 = wave.binary addi %1652, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2324 = wave.binary addi %2323, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2325 = wave.binary addi %1660, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2326 = wave.binary addi %2325, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2327 = wave.binary addi %1668, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2328 = wave.binary addi %2327, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2329 = wave.binary addi %1676, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2330 = wave.binary addi %2329, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2331 = wave.binary addi %1684, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2332 = wave.binary addi %2331, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2333 = wave.binary addi %1692, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2334 = wave.binary addi %2333, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2335 = wave.binary addi %1700, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2336 = wave.binary addi %2335, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2337 = wave.binary addi %1708, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2338 = wave.binary addi %2337, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2339 = wave.binary addi %1716, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2340 = wave.binary addi %2339, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2341 = wave.binary addi %1724, %1963 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2342 = wave.binary addi %2341, %1605 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2343 = wave.cmpi ne %1967, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2344 = wave.pack %2056, %2057, %2058, %2059, %2064, %2065, %2066, %2067 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2345 = wave.assume %2312 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2346 = wave.ptr_add %1591, %2345 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2347 = wave.select %2343, %2346, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2348 = wave.store %2344 -> %2347 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2349 = wave.cmpi ne %1968, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2350 = wave.pack %2072, %2073, %2074, %2075, %2080, %2081, %2082, %2083 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2351 = wave.assume %2314 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2352 = wave.ptr_add %1591, %2351 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2353 = wave.select %2349, %2352, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2354 = wave.store %2350 -> %2353 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2355 = wave.cmpi ne %1969, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2356 = wave.pack %2060, %2061, %2062, %2063, %2068, %2069, %2070, %2071 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2357 = wave.assume %2316 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2358 = wave.ptr_add %1591, %2357 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2359 = wave.select %2355, %2358, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2360 = wave.store %2356 -> %2359 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2361 = wave.cmpi ne %1970, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2362 = wave.pack %2076, %2077, %2078, %2079, %2084, %2085, %2086, %2087 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2363 = wave.assume %2318 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2364 = wave.ptr_add %1591, %2363 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2365 = wave.select %2361, %2364, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2366 = wave.store %2362 -> %2365 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2367 = wave.cmpi ne %1971, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2368 = wave.pack %2130, %2131, %2132, %2133, %2138, %2139, %2140, %2141 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2369 = wave.assume %2320 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2370 = wave.ptr_add %1591, %2369 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2371 = wave.select %2367, %2370, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2372 = wave.store %2368 -> %2371 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2373 = wave.cmpi ne %1972, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2374 = wave.pack %2146, %2147, %2148, %2149, %2154, %2155, %2156, %2157 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2375 = wave.assume %2322 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2376 = wave.ptr_add %1591, %2375 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2377 = wave.select %2373, %2376, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2378 = wave.store %2374 -> %2377 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2379 = wave.cmpi ne %1973, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2380 = wave.pack %2134, %2135, %2136, %2137, %2142, %2143, %2144, %2145 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2381 = wave.assume %2324 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2382 = wave.ptr_add %1591, %2381 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2383 = wave.select %2379, %2382, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2384 = wave.store %2380 -> %2383 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2385 = wave.cmpi ne %1974, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2386 = wave.pack %2150, %2151, %2152, %2153, %2158, %2159, %2160, %2161 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2387 = wave.assume %2326 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2388 = wave.ptr_add %1591, %2387 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2389 = wave.select %2385, %2388, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2390 = wave.store %2386 -> %2389 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2391 = wave.cmpi ne %1975, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2392 = wave.pack %2204, %2205, %2206, %2207, %2212, %2213, %2214, %2215 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2393 = wave.assume %2328 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2394 = wave.ptr_add %1591, %2393 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2395 = wave.select %2391, %2394, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2396 = wave.store %2392 -> %2395 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2397 = wave.cmpi ne %1976, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2398 = wave.pack %2220, %2221, %2222, %2223, %2228, %2229, %2230, %2231 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2399 = wave.assume %2330 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2400 = wave.ptr_add %1591, %2399 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2401 = wave.select %2397, %2400, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2402 = wave.store %2398 -> %2401 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2403 = wave.cmpi ne %1977, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2404 = wave.pack %2208, %2209, %2210, %2211, %2216, %2217, %2218, %2219 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2405 = wave.assume %2332 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2406 = wave.ptr_add %1591, %2405 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2407 = wave.select %2403, %2406, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2408 = wave.store %2404 -> %2407 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2409 = wave.cmpi ne %1978, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2410 = wave.pack %2224, %2225, %2226, %2227, %2232, %2233, %2234, %2235 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2411 = wave.assume %2334 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2412 = wave.ptr_add %1591, %2411 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2413 = wave.select %2409, %2412, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2414 = wave.store %2410 -> %2413 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2415 = wave.cmpi ne %1979, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2416 = wave.pack %2278, %2279, %2280, %2281, %2286, %2287, %2288, %2289 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2417 = wave.assume %2336 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2418 = wave.ptr_add %1591, %2417 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2419 = wave.select %2415, %2418, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2420 = wave.store %2416 -> %2419 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2421 = wave.cmpi ne %1980, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2422 = wave.pack %2294, %2295, %2296, %2297, %2302, %2303, %2304, %2305 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2423 = wave.assume %2338 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2424 = wave.ptr_add %1591, %2423 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2425 = wave.select %2421, %2424, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2426 = wave.store %2422 -> %2425 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2427 = wave.cmpi ne %1981, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2428 = wave.pack %2282, %2283, %2284, %2285, %2290, %2291, %2292, %2293 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2429 = wave.assume %2340 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2430 = wave.ptr_add %1591, %2429 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2431 = wave.select %2427, %2430, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2432 = wave.store %2428 -> %2431 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2433 = wave.cmpi ne %1982, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2434 = wave.pack %2298, %2299, %2300, %2301, %2306, %2307, %2308, %2309 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2435 = wave.assume %2342 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %2436 = wave.ptr_add %1591, %2435 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2437 = wave.select %2433, %2436, %1731 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2438 = wave.store %2434 -> %2437 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      return
    }
  }
}
