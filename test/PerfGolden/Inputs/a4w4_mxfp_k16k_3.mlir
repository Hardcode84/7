module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 4 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @_a4w4_kernel(%arg0: !wave.ptr<#wave.global, i8>, %arg1: !wave.ptr<#wave.global, i8>, %arg2: !wave.ptr<#wave.global, bf16>, %arg3: !wave.ptr<#wave.global, i8>, %arg4: !wave.ptr<#wave.global, i8>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 256, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 4 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 4 : i64, wave.workgroup_size = array<i32: 256, 1, 1>, waveamdmachine.target_waves = 1 : i64} {
      %0 = wave.constant 6144 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 4096 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 2048 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %8 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %10 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %c4216_i32 = arith.constant 4216 : i32
      %c16864_i32 = arith.constant 16864 : i32
      %c8440_i32 = arith.constant 8440 : i32
      %c33760_i32 = arith.constant 33760 : i32
      %c7392_i32 = arith.constant 7392 : i32
      %c6336_i32 = arith.constant 6336 : i32
      %c5280_i32 = arith.constant 5280 : i32
      %c4224_i32 = arith.constant 4224 : i32
      %c3168_i32 = arith.constant 3168 : i32
      %c2112_i32 = arith.constant 2112 : i32
      %c1056_i32 = arith.constant 1056 : i32
      %c264_i32 = arith.constant 264 : i32
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %c64_i32 = arith.constant 64 : i32
      %c16_i32 = arith.constant 16 : i32
      %c62_i32 = arith.constant 62 : i32
      %c2_i32 = arith.constant 2 : i32
      %c255_i32 = arith.constant 255 : i32
      %c0_i32 = arith.constant 0 : i32
      %c32_i32 = arith.constant 32 : i32
      %c8_i32 = arith.constant 8 : i32
      %c4_i32 = arith.constant 4 : i32
      %c128_i32 = arith.constant 128 : i32
      %c256_i32 = arith.constant 256 : i32
      %11 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %12 = wave.pack %11, %11, %11, %11 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %13 = wave.workgroup_id 0
      %14 = wave.binary addi %arg5, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %15 = wave.binary divsi %14, %c256_i32 : i32, i32 -> i32
      %16 = wave.binary addi %arg6, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %17 = wave.binary divsi %16, %c256_i32 : i32, i32 -> i32
      %18 = wave.binary remui %13, %c8_i32 : i32, i32 -> i32
      %19 = wave.binary divui %13, %c8_i32 : i32, i32 -> i32
      %20 = wave.binary muli %18, %c32_i32 overflow<nsw> : i32, i32 -> i32
      %21 = wave.binary addi %20, %19 overflow<nsw> : i32, i32 -> i32
      %22 = wave.binary muli %17, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %23 = wave.binary divsi %21, %22 : i32, i32 -> i32
      %24 = wave.binary muli %23, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %25 = wave.binary subi %15, %24 overflow<nsw> : i32, i32 -> i32
      %26 = arith.cmpi slt, %25, %c4_i32 : i32
      %27 = wave.select %26, %25, %c4_i32 : i32
      %28 = wave.binary remsi %21, %22 : i32, i32 -> i32
      %29 = wave.assume %27 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %30 = wave.binary remui %28, %29 : i32, i32 -> i32
      %31 = wave.binary addi %24, %30 overflow<nsw> : i32, i32 -> i32
      %32 = wave.assume %27 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %33 = wave.binary divui %28, %32 : i32, i32 -> i32
      %34 = wave.alloc() {align = 16 : i64, bytesize = 67520 : i64} : !wave.ptr<#wave.shared, i8>
      %35 = wave.alloc() {align = 16 : i64, bytesize = 33728 : i64} : !wave.ptr<#wave.shared, i8>
      %36 = wave.alloc() {align = 16 : i64, bytesize = 33728 : i64} : !wave.ptr<#wave.shared, i8>
      %37 = wave.alloc() {align = 16 : i64, bytesize = 2048 : i64} : !wave.ptr<#wave.shared, i8>
      %38 = wave.alloc() {align = 16 : i64, bytesize = 1024 : i64} : !wave.ptr<#wave.shared, i8>
      %39 = wave.binary muli %31, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %40 = wave.binary muli %39, %arg7 : i32, i32 -> i32
      %41 = wave.binary muli %arg8, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %42 = wave.binary muli %33, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %43 = wave.binary muli %42, %arg8 : i32, i32 -> i32
      %44 = wave.binary muli %arg10, %c8_i32 overflow<nsw> : i32, i32 -> i32
      %45 = wave.binary muli %arg11, %c8_i32 overflow<nsw> : i32, i32 -> i32
      %46 = wave.ptr_add %arg0, %40 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %47 = waveamd.make_buffer %46, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %48 = wave.ptr_cast %34 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %49 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %50 = wave.read_first %49 : !wave.simd<i32, 64> -> i32
      %51 = wave.assume %50 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-255 + x <= 0">] : i32
      %52 = wave.binary divui %51, %c64_i32 : i32, i32 -> i32
      %53 = wave.binary muli %52, %c264_i32 overflow<nsw> : i32, i32 -> i32
      %54 = wave.token : !wave.mem.token
      %55 = wave.index_expr <"128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %56 = wave.assume %55 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %57 = wave.ptr_add %47, %56 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %58 = wave.ptr_add %48, %53 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %59 = waveamd.dma_load_lds %57 -> %58 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %60 = wave.index_expr <"4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %61 = wave.assume %60 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %62 = wave.ptr_add %47, %61 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %63 = wave.binary addi %53, %c1056_i32 overflow<nsw> : i32, i32 -> i32
      %64 = wave.ptr_add %48, %63 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %65 = waveamd.dma_load_lds %62 -> %64 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %66 = wave.index_expr <"8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %67 = wave.assume %66 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %68 = wave.ptr_add %47, %67 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %69 = wave.binary addi %53, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %70 = wave.ptr_add %48, %69 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %71 = waveamd.dma_load_lds %68 -> %70 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %72 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %73 = wave.assume %72 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %74 = wave.ptr_add %47, %73 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %75 = wave.binary addi %53, %c3168_i32 overflow<nsw> : i32, i32 -> i32
      %76 = wave.ptr_add %48, %75 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %77 = waveamd.dma_load_lds %74 -> %76 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %78 = wave.index_expr <"128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %79 = wave.assume %78 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %80 = wave.ptr_add %47, %79 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %81 = wave.binary addi %53, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %82 = wave.ptr_add %48, %81 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %83 = waveamd.dma_load_lds %80 -> %82 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %84 = wave.index_expr <"128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %85 = wave.assume %84 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %86 = wave.ptr_add %47, %85 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %87 = wave.binary addi %53, %c5280_i32 overflow<nsw> : i32, i32 -> i32
      %88 = wave.ptr_add %48, %87 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %89 = waveamd.dma_load_lds %86 -> %88 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %90 = wave.index_expr <"128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %91 = wave.assume %90 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %92 = wave.ptr_add %47, %91 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %93 = wave.binary addi %53, %c6336_i32 overflow<nsw> : i32, i32 -> i32
      %94 = wave.ptr_add %48, %93 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %95 = waveamd.dma_load_lds %92 -> %94 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %96 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %97 = wave.assume %96 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %98 = wave.ptr_add %47, %97 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %99 = wave.binary addi %53, %c7392_i32 overflow<nsw> : i32, i32 -> i32
      %100 = wave.ptr_add %48, %99 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %101 = waveamd.dma_load_lds %98 -> %100 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %102 = wave.join %59, %65, %71, %77, %83, %89, %95, %101 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %103 = wave.ptr_add %arg1, %43 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %104 = waveamd.make_buffer %103, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %105 = wave.ptr_cast %35 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %106 = wave.index_expr <"8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %107 = wave.assume %106 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %108 = wave.ptr_add %104, %107 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %109 = wave.ptr_add %105, %53 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %110 = waveamd.dma_load_lds %108 -> %109 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %111 = wave.index_expr <"4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %112 = wave.assume %111 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %113 = wave.ptr_add %104, %112 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %114 = wave.ptr_add %105, %63 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %115 = waveamd.dma_load_lds %113 -> %114 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %116 = wave.index_expr <"8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %117 = wave.assume %116 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %118 = wave.ptr_add %104, %117 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %119 = wave.ptr_add %105, %69 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %120 = waveamd.dma_load_lds %118 -> %119 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %121 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %122 = wave.assume %121 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %123 = wave.ptr_add %104, %122 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %124 = wave.ptr_add %105, %75 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %125 = waveamd.dma_load_lds %123 -> %124 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %126 = wave.join %110, %115, %120, %125 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %127 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %128 = wave.index_expr <"s1 + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-2147483640 + s1 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %129 = wave.assume %128 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483640 + x <= 0">] : !wave.simd<index, 64>
      %130 = wave.ptr_add %127, %129 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value, %token = wave.load %130 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %131 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %132 = wave.index_expr <"s1 + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 4*Mod(wi, 2) + 64*Mod(floor(1/16*wi), 2) + 32*Mod(floor(1/8*wi), 2) + 16*Mod(floor(1/4*wi), 2) + 8*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-2147483644 + s1 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %133 = wave.assume %132 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483644 + x <= 0">] : !wave.simd<index, 64>
      %134 = wave.ptr_add %131, %133 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_0, %token_1 = wave.load %134 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %135 = wave.join %102, %126 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %136 = wave.ptr_cast %36 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %137 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %138 = wave.assume %137 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %139 = wave.ptr_add %104, %138 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %140 = wave.ptr_add %136, %53 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %141 = waveamd.dma_load_lds %139 -> %140 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %142 = wave.index_expr <"s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %143 = wave.assume %142 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %144 = wave.ptr_add %104, %143 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %145 = wave.ptr_add %136, %63 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %146 = waveamd.dma_load_lds %144 -> %145 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %147 = wave.index_expr <"s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %148 = wave.assume %147 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %149 = wave.ptr_add %104, %148 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %150 = wave.ptr_add %136, %69 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %151 = waveamd.dma_load_lds %149 -> %150 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %152 = wave.index_expr <"s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %153 = wave.assume %152 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %154 = wave.ptr_add %104, %153 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %155 = wave.ptr_add %136, %75 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %156 = waveamd.dma_load_lds %154 -> %155 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %157 = wave.join %141, %146, %151, %156 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %158 = wave.index_expr <"128 + s1 + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 4*Mod(wi, 2) + 64*Mod(floor(1/16*wi), 2) + 32*Mod(floor(1/8*wi), 2) + 16*Mod(floor(1/4*wi), 2) + 8*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-2147483516 + s1 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %159 = wave.assume %158 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483644 + x <= 0">] : !wave.simd<index, 64>
      %160 = wave.ptr_add %131, %159 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_2, %token_3 = wave.load %160 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %161 = wave.ptr_add %34, %c33760_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
      %162 = wave.index_expr <"128 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %163 = wave.assume %162 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %164 = wave.ptr_add %47, %163 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %165 = wave.binary addi %c8440_i32, %53 overflow<nsw> : i32, i32 -> i32
      %166 = wave.ptr_add %48, %165 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %167 = waveamd.dma_load_lds %164 -> %166 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %168 = wave.index_expr <"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %169 = wave.assume %168 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %170 = wave.ptr_add %47, %169 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %171 = wave.binary addi %c8440_i32, %63 overflow<nsw> : i32, i32 -> i32
      %172 = wave.ptr_add %48, %171 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %173 = waveamd.dma_load_lds %170 -> %172 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %174 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %175 = wave.assume %174 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %176 = wave.ptr_add %47, %175 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %177 = wave.binary addi %c8440_i32, %69 overflow<nsw> : i32, i32 -> i32
      %178 = wave.ptr_add %48, %177 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %179 = waveamd.dma_load_lds %176 -> %178 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %180 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %181 = wave.assume %180 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %182 = wave.ptr_add %47, %181 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %183 = wave.binary addi %c8440_i32, %75 overflow<nsw> : i32, i32 -> i32
      %184 = wave.ptr_add %48, %183 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %185 = waveamd.dma_load_lds %182 -> %184 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %186 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %187 = wave.assume %186 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %188 = wave.ptr_add %47, %187 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %189 = wave.binary addi %c8440_i32, %81 overflow<nsw> : i32, i32 -> i32
      %190 = wave.ptr_add %48, %189 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %191 = waveamd.dma_load_lds %188 -> %190 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %192 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %193 = wave.assume %192 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %194 = wave.ptr_add %47, %193 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %195 = wave.binary addi %c8440_i32, %87 overflow<nsw> : i32, i32 -> i32
      %196 = wave.ptr_add %48, %195 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %197 = waveamd.dma_load_lds %194 -> %196 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %198 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %199 = wave.assume %198 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %200 = wave.ptr_add %47, %199 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %201 = wave.binary addi %c8440_i32, %93 overflow<nsw> : i32, i32 -> i32
      %202 = wave.ptr_add %48, %201 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %203 = waveamd.dma_load_lds %200 -> %202 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %204 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %205 = wave.assume %204 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %206 = wave.ptr_add %47, %205 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %207 = wave.binary addi %c8440_i32, %99 overflow<nsw> : i32, i32 -> i32
      %208 = wave.ptr_add %48, %207 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %209 = waveamd.dma_load_lds %206 -> %208 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %210 = wave.join %167, %173, %179, %185, %191, %197, %203, %209 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %211 = wave.ptr_add %35, %c16864_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
      %212 = wave.index_expr <"128 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %213 = wave.assume %212 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %214 = wave.ptr_add %104, %213 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %215 = wave.binary addi %c4216_i32, %53 overflow<nsw> : i32, i32 -> i32
      %216 = wave.ptr_add %105, %215 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %217 = waveamd.dma_load_lds %214 -> %216 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %218 = wave.index_expr <"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %219 = wave.assume %218 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %220 = wave.ptr_add %104, %219 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %221 = wave.binary addi %c4216_i32, %63 overflow<nsw> : i32, i32 -> i32
      %222 = wave.ptr_add %105, %221 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %223 = waveamd.dma_load_lds %220 -> %222 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %224 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %225 = wave.assume %224 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %226 = wave.ptr_add %104, %225 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %227 = wave.binary addi %c4216_i32, %69 overflow<nsw> : i32, i32 -> i32
      %228 = wave.ptr_add %105, %227 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %229 = waveamd.dma_load_lds %226 -> %228 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %230 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %231 = wave.assume %230 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %232 = wave.ptr_add %104, %231 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %233 = wave.binary addi %c4216_i32, %75 overflow<nsw> : i32, i32 -> i32
      %234 = wave.ptr_add %105, %233 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %235 = waveamd.dma_load_lds %232 -> %234 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %236 = wave.join %217, %223, %229, %235 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %237 = wave.index_expr <"s1 + s2 + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-2147483640 + s1 + s2 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg10, %39, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %238 = wave.assume %237 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483640 + x <= 0">] : !wave.simd<index, 64>
      %239 = wave.ptr_add %127, %238 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_4, %token_5 = wave.load %239 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %240 = wave.index_expr <"s1 + s2 + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 4*Mod(wi, 2) + 64*Mod(floor(1/16*wi), 2) + 32*Mod(floor(1/8*wi), 2) + 16*Mod(floor(1/4*wi), 2) + 8*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-2147483644 + s1 + s2 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %42, %45) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %241 = wave.assume %240 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483644 + x <= 0">] : !wave.simd<index, 64>
      %242 = wave.ptr_add %131, %241 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_6, %token_7 = wave.load %242 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %243 = wave.join %210, %236 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %244 = wave.ptr_add %36, %c16864_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
      %245 = wave.index_expr <"128 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %246 = wave.assume %245 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %247 = wave.ptr_add %104, %246 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %248 = wave.ptr_add %136, %215 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %249 = waveamd.dma_load_lds %247 -> %248 after %157 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %250 = wave.index_expr <"128 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %251 = wave.assume %250 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %252 = wave.ptr_add %104, %251 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %253 = wave.ptr_add %136, %221 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %254 = waveamd.dma_load_lds %252 -> %253 after %157 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %255 = wave.index_expr <"128 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %256 = wave.assume %255 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %257 = wave.ptr_add %104, %256 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %258 = wave.ptr_add %136, %227 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %259 = waveamd.dma_load_lds %257 -> %258 after %157 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %260 = wave.index_expr <"128 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %261 = wave.assume %260 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %262 = wave.ptr_add %104, %261 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %263 = wave.ptr_add %136, %233 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %264 = waveamd.dma_load_lds %262 -> %263 after %157 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %265 = wave.join %249, %254, %259, %264 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %266 = wave.index_expr <"128 + s1 + s2 + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 4*Mod(wi, 2) + 64*Mod(floor(1/16*wi), 2) + 32*Mod(floor(1/8*wi), 2) + 16*Mod(floor(1/4*wi), 2) + 8*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s2 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-2147483516 + s1 + s2 + s0*xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) + xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %42, %45) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %267 = wave.assume %266 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483644 + x <= 0">] : !wave.simd<index, 64>
      %268 = wave.ptr_add %131, %267 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_8, %token_9 = wave.load %268 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %269 = wave.binary addi %40, %c256_i32 : i32, i32 -> i32
      %270 = wave.binary addi %43, %c256_i32 : i32, i32 -> i32
      %271 = wave.binary muli %arg10, %c16_i32 : i32, i32 -> i32
      %272 = wave.binary muli %arg11, %c16_i32 : i32, i32 -> i32
      wave.wait %135 : !wave.mem.token
      %273 = wave.barrier %135 : (!wave.mem.token) -> !wave.mem.token
      %274 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 16896*Mod(floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %275 = wave.ptr_add %34, %274 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_10, %token_11 = wave.load %275 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %276 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %277 = wave.ptr_add %34, %276 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_12, %token_13 = wave.load %277 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %278 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %279 = wave.ptr_add %34, %278 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_14, %token_15 = wave.load %279 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %280 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %281 = wave.ptr_add %34, %280 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_16, %token_17 = wave.load %281 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %282 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %283 = wave.ptr_add %34, %282 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_18, %token_19 = wave.load %283 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %284 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/2*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %285 = wave.ptr_add %34, %284 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_20, %token_21 = wave.load %285 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %286 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %287 = wave.ptr_add %34, %286 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_22, %token_23 = wave.load %287 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %288 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/2*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %289 = wave.ptr_add %34, %288 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_24, %token_25 = wave.load %289 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %290 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 16896*Mod(1 + floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %291 = wave.ptr_add %34, %290 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_26, %token_27 = wave.load %291 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %292 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 16896*Mod(1 + floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %293 = wave.ptr_add %34, %292 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_28, %token_29 = wave.load %293 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %294 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %295 = wave.ptr_add %34, %294 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_30, %token_31 = wave.load %295 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %296 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %297 = wave.ptr_add %34, %296 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_32, %token_33 = wave.load %297 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %298 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %299 = wave.ptr_add %34, %298 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_34, %token_35 = wave.load %299 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %300 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/2*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %301 = wave.ptr_add %34, %300 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_36, %token_37 = wave.load %301 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %302 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %303 = wave.ptr_add %34, %302 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_38, %token_39 = wave.load %303 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %304 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/2*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %305 = wave.ptr_add %34, %304 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_40, %token_41 = wave.load %305 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %306 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %307 = wave.ptr_add %35, %306 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_42, %token_43 = wave.load %307 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %308 = wave.index_expr <"64 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %309 = wave.ptr_add %35, %308 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_44, %token_45 = wave.load %309 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %310 = wave.index_expr <"256 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %311 = wave.ptr_add %35, %310 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_46, %token_47 = wave.load %311 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %312 = wave.index_expr <"320 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %313 = wave.ptr_add %35, %312 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_48, %token_49 = wave.load %313 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %314 = wave.index_expr <"512 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %315 = wave.ptr_add %35, %314 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_50, %token_51 = wave.load %315 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %316 = wave.index_expr <"576 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %317 = wave.ptr_add %35, %316 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_52, %token_53 = wave.load %317 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %318 = wave.index_expr <"768 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %319 = wave.ptr_add %35, %318 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_54, %token_55 = wave.load %319 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %320 = wave.index_expr <"832 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %321 = wave.ptr_add %35, %320 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_56, %token_57 = wave.load %321 after %273 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %322 = wave.binary remui %49, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %323 = wave.binary muli %322, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %324 = wave.binary divui %49, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %325 = wave.binary remui %324, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %326 = wave.binary muli %325, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %327 = wave.binary xori %323, %326 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %328 = wave.binary divui %49, %7 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %329 = wave.binary remui %328, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %330 = wave.binary muli %329, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %331 = wave.binary xori %327, %330 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %332 = wave.binary divui %49, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %333 = wave.binary remui %332, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %334 = wave.binary muli %333, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %335 = wave.binary xori %331, %334 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %336 = wave.binary divui %49, %8 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %337 = wave.binary remui %336, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %338 = wave.binary muli %337, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %339 = wave.binary xori %335, %338 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %340 = wave.binary divui %49, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %341 = wave.binary remui %340, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %342 = wave.binary divui %49, %5 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %343 = wave.binary remui %342, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %344 = wave.binary muli %343, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %345 = wave.binary xori %341, %344 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %346 = wave.binary divui %49, %4 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %347 = wave.binary remui %346, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %348 = wave.binary muli %347, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %349 = wave.binary xori %345, %348 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %350 = wave.binary muli %349, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %351 = wave.binary addi %350, %339 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %352 = wave.ptr_add %37, %351 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %353 = wave.store %value -> %352 after %54 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %354 = wave.barrier %353 : (!wave.mem.token) -> !wave.mem.token
      %355 = wave.binary muli %322, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %356 = wave.binary muli %325, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %357 = wave.binary xori %355, %356 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %358 = wave.binary muli %329, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %359 = wave.binary xori %357, %358 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %360 = wave.binary muli %333, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %361 = wave.binary xori %359, %360 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %362 = wave.binary muli %337, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %363 = wave.binary xori %361, %362 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %364 = wave.binary muli %349, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %365 = wave.binary addi %364, %363 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %366 = wave.ptr_add %38, %365 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %367 = wave.store %value_0 -> %366 after %54 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %368 = wave.barrier %367 : (!wave.mem.token) -> !wave.mem.token
      %369 = wave.index_expr <"8*Mod(wi, 2) + 16*Mod(floor(1/128*wi), 2) + 512*Mod(floor(1/32*wi), 2) + 256*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 1024*Mod(floor(1/2*wi), 2)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %370 = wave.ptr_add %37, %369 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_58, %token_59 = waveamd.transpose_load %370 after %354 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %371 = wave.extract %value_58[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %372 = wave.extract %value_58[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %373 = wave.index_expr <"128 + 8*Mod(wi, 2) + 16*Mod(floor(1/128*wi), 2) + 512*Mod(floor(1/32*wi), 2) + 256*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 1024*Mod(floor(1/2*wi), 2)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %374 = wave.ptr_add %37, %373 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_60, %token_61 = waveamd.transpose_load %374 after %354 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %375 = wave.extract %value_60[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %376 = wave.extract %value_60[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %377 = wave.join %token_59, %token_61 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %378 = wave.index_expr <"8*Mod(wi, 2) + 16*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/32*wi), 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 512*Mod(floor(1/2*wi), 2)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %379 = wave.ptr_add %38, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_62, %token_63 = waveamd.transpose_load %379 after %368 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %380 = wave.extract %value_62[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %381 = wave.extract %value_62[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %382:105 = scf.for %arg12 = %c0_i32 to %c62_i32 step %c2_i32 iter_args(%arg13 = %269, %arg14 = %270, %arg15 = %271, %arg16 = %272, %arg17 = %12, %arg18 = %12, %arg19 = %12, %arg20 = %12, %arg21 = %12, %arg22 = %12, %arg23 = %12, %arg24 = %12, %arg25 = %12, %arg26 = %12, %arg27 = %12, %arg28 = %12, %arg29 = %12, %arg30 = %12, %arg31 = %12, %arg32 = %12, %arg33 = %12, %arg34 = %12, %arg35 = %12, %arg36 = %12, %arg37 = %12, %arg38 = %12, %arg39 = %12, %arg40 = %12, %arg41 = %12, %arg42 = %12, %arg43 = %12, %arg44 = %12, %arg45 = %12, %arg46 = %12, %arg47 = %12, %arg48 = %12, %arg49 = %12, %arg50 = %12, %arg51 = %12, %arg52 = %12, %arg53 = %12, %arg54 = %12, %arg55 = %12, %arg56 = %12, %arg57 = %12, %arg58 = %12, %arg59 = %12, %arg60 = %12, %arg61 = %12, %arg62 = %12, %arg63 = %12, %arg64 = %12, %arg65 = %12, %arg66 = %12, %arg67 = %12, %arg68 = %12, %arg69 = %12, %arg70 = %12, %arg71 = %12, %arg72 = %12, %arg73 = %12, %arg74 = %12, %arg75 = %12, %arg76 = %12, %arg77 = %12, %arg78 = %12, %arg79 = %12, %arg80 = %12, %arg81 = %value_2, %arg82 = %value_4, %arg83 = %value_6, %arg84 = %value_8, %arg85 = %value_10, %arg86 = %value_12, %arg87 = %value_14, %arg88 = %value_16, %arg89 = %value_18, %arg90 = %value_20, %arg91 = %value_22, %arg92 = %value_24, %arg93 = %value_26, %arg94 = %value_28, %arg95 = %value_30, %arg96 = %value_32, %arg97 = %value_34, %arg98 = %value_36, %arg99 = %value_38, %arg100 = %value_40, %arg101 = %value_42, %arg102 = %value_44, %arg103 = %value_46, %arg104 = %value_48, %arg105 = %value_50, %arg106 = %value_52, %arg107 = %value_54, %arg108 = %value_56, %arg109 = %371, %arg110 = %372, %arg111 = %375, %arg112 = %376, %arg113 = %380, %arg114 = %381, %arg115 = %157, %arg116 = %243, %arg117 = %265) -> (i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<8xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %1864 = waveamd.fragment_pack %arg85 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1865 = waveamd.fragment_pack %arg86 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1866 = waveamd.fragment_pack %arg87 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1867 = waveamd.fragment_pack %arg88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1868 = waveamd.fragment_pack %arg89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1869 = waveamd.fragment_pack %arg90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1870 = waveamd.fragment_pack %arg91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1871 = waveamd.fragment_pack %arg92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1872 = waveamd.fragment_pack %arg93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1873 = waveamd.fragment_pack %arg94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1874 = waveamd.fragment_pack %arg95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1875 = waveamd.fragment_pack %arg96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1876 = waveamd.fragment_pack %arg97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1877 = waveamd.fragment_pack %arg98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1878 = waveamd.fragment_pack %arg99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1879 = waveamd.fragment_pack %arg100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %1880 = waveamd.fragment_pack %arg101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %1881 = waveamd.fragment_pack %arg102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %1882 = waveamd.fragment_pack %arg103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %1883 = waveamd.fragment_pack %arg104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %1884 = waveamd.fragment_pack %arg105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %1885 = waveamd.fragment_pack %arg106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %1886 = waveamd.fragment_pack %arg107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %1887 = waveamd.fragment_pack %arg108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %1888 = waveamd.fragment_pack %arg17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1889 = waveamd.fragment_pack %arg18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1890 = waveamd.fragment_pack %arg19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1891 = waveamd.fragment_pack %arg20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1892 = waveamd.fragment_pack %arg21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1893 = waveamd.fragment_pack %arg22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1894 = waveamd.fragment_pack %arg23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1895 = waveamd.fragment_pack %arg24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1896 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1897 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1898 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1899 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1900 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1901 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1902 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1903 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1904 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1905 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1906 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1907 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1908 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1909 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1910 = waveamd.fragment_pack %arg39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1911 = waveamd.fragment_pack %arg40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1912 = waveamd.fragment_pack %arg41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1913 = waveamd.fragment_pack %arg42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1914 = waveamd.fragment_pack %arg43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1915 = waveamd.fragment_pack %arg44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1916 = waveamd.fragment_pack %arg45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1917 = waveamd.fragment_pack %arg46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1918 = waveamd.fragment_pack %arg47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1919 = waveamd.fragment_pack %arg48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1920 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1880, %arg113, %1864, %arg109, %1888 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1921 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1881, %arg113, %1865, %arg109, %1920 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1922 = waveamd.fragment_unpack %1921 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1923 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1882, %arg113, %1864, %arg109, %1889 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1924 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1883, %arg113, %1865, %arg109, %1923 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1925 = waveamd.fragment_unpack %1924 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1926 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1884, %arg114, %1864, %arg109, %1890 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1927 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1885, %arg114, %1865, %arg109, %1926 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1928 = waveamd.fragment_unpack %1927 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1929 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1886, %arg114, %1864, %arg109, %1891 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1930 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1887, %arg114, %1865, %arg109, %1929 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1931 = waveamd.fragment_unpack %1930 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1932 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1880, %arg113, %1866, %arg109, %1892 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1933 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1881, %arg113, %1867, %arg109, %1932 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1934 = waveamd.fragment_unpack %1933 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1935 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1882, %arg113, %1866, %arg109, %1893 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1936 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1883, %arg113, %1867, %arg109, %1935 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1937 = waveamd.fragment_unpack %1936 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1938 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1884, %arg114, %1866, %arg109, %1894 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1939 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1885, %arg114, %1867, %arg109, %1938 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1940 = waveamd.fragment_unpack %1939 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1941 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1886, %arg114, %1866, %arg109, %1895 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1942 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1887, %arg114, %1867, %arg109, %1941 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1943 = waveamd.fragment_unpack %1942 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1944 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1880, %arg113, %1868, %arg110, %1896 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1945 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1881, %arg113, %1869, %arg110, %1944 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1946 = waveamd.fragment_unpack %1945 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1947 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1882, %arg113, %1868, %arg110, %1897 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1948 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1883, %arg113, %1869, %arg110, %1947 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1949 = waveamd.fragment_unpack %1948 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1950 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1884, %arg114, %1868, %arg110, %1898 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1951 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1885, %arg114, %1869, %arg110, %1950 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1952 = waveamd.fragment_unpack %1951 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1953 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1886, %arg114, %1868, %arg110, %1899 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1954 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1887, %arg114, %1869, %arg110, %1953 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1955 = waveamd.fragment_unpack %1954 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1956 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1880, %arg113, %1870, %arg110, %1900 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1957 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1881, %arg113, %1871, %arg110, %1956 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1958 = waveamd.fragment_unpack %1957 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1959 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1882, %arg113, %1870, %arg110, %1901 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1960 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1883, %arg113, %1871, %arg110, %1959 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1961 = waveamd.fragment_unpack %1960 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1962 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1884, %arg114, %1870, %arg110, %1902 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1963 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1885, %arg114, %1871, %arg110, %1962 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1964 = waveamd.fragment_unpack %1963 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1965 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1886, %arg114, %1870, %arg110, %1903 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1966 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1887, %arg114, %1871, %arg110, %1965 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1967 = waveamd.fragment_unpack %1966 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1968 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1880, %arg113, %1872, %arg111, %1904 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1969 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1881, %arg113, %1873, %arg111, %1968 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1970 = waveamd.fragment_unpack %1969 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1971 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1882, %arg113, %1872, %arg111, %1905 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1972 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1883, %arg113, %1873, %arg111, %1971 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1973 = waveamd.fragment_unpack %1972 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1974 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1884, %arg114, %1872, %arg111, %1906 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1975 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1885, %arg114, %1873, %arg111, %1974 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1976 = waveamd.fragment_unpack %1975 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1977 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1886, %arg114, %1872, %arg111, %1907 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1978 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1887, %arg114, %1873, %arg111, %1977 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1979 = waveamd.fragment_unpack %1978 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1980 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1880, %arg113, %1874, %arg111, %1908 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1981 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1881, %arg113, %1875, %arg111, %1980 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1982 = waveamd.fragment_unpack %1981 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1983 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1882, %arg113, %1874, %arg111, %1909 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1984 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1883, %arg113, %1875, %arg111, %1983 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1985 = waveamd.fragment_unpack %1984 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1986 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1884, %arg114, %1874, %arg111, %1910 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1987 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1885, %arg114, %1875, %arg111, %1986 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1988 = waveamd.fragment_unpack %1987 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1989 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1886, %arg114, %1874, %arg111, %1911 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1990 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1887, %arg114, %1875, %arg111, %1989 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1991 = waveamd.fragment_unpack %1990 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1992 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1880, %arg113, %1876, %arg112, %1912 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1993 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1881, %arg113, %1877, %arg112, %1992 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1994 = waveamd.fragment_unpack %1993 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1995 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1882, %arg113, %1876, %arg112, %1913 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1996 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1883, %arg113, %1877, %arg112, %1995 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1997 = waveamd.fragment_unpack %1996 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1998 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1884, %arg114, %1876, %arg112, %1914 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1999 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1885, %arg114, %1877, %arg112, %1998 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2000 = waveamd.fragment_unpack %1999 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2001 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1886, %arg114, %1876, %arg112, %1915 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2002 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1887, %arg114, %1877, %arg112, %2001 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2003 = waveamd.fragment_unpack %2002 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2004 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1880, %arg113, %1878, %arg112, %1916 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2005 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1881, %arg113, %1879, %arg112, %2004 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2006 = waveamd.fragment_unpack %2005 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2007 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1882, %arg113, %1878, %arg112, %1917 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2008 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1883, %arg113, %1879, %arg112, %2007 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2009 = waveamd.fragment_unpack %2008 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2010 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1884, %arg114, %1878, %arg112, %1918 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2011 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1885, %arg114, %1879, %arg112, %2010 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2012 = waveamd.fragment_unpack %2011 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2013 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1886, %arg114, %1878, %arg112, %1919 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2014 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1887, %arg114, %1879, %arg112, %2013 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2015 = waveamd.fragment_unpack %2014 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg115 : !wave.mem.token
        %2016 = wave.barrier %arg115 : (!wave.mem.token) -> !wave.mem.token
        %2017 = wave.ptr_add %36, %306 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_218, %token_219 = wave.load %2017 after %2016 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2018 = wave.ptr_add %36, %308 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_220, %token_221 = wave.load %2018 after %2016 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2019 = wave.ptr_add %36, %310 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_222, %token_223 = wave.load %2019 after %2016 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2020 = wave.ptr_add %36, %312 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_224, %token_225 = wave.load %2020 after %2016 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2021 = wave.ptr_add %36, %314 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_226, %token_227 = wave.load %2021 after %2016 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2022 = wave.ptr_add %36, %316 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_228, %token_229 = wave.load %2022 after %2016 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2023 = wave.ptr_add %36, %318 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_230, %token_231 = wave.load %2023 after %2016 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2024 = wave.ptr_add %36, %320 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_232, %token_233 = wave.load %2024 after %2016 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2025 = wave.join %token_219, %token_221, %token_223, %token_225, %token_227, %token_229, %token_231, %token_233 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2026 = wave.store %arg81 -> %366 after %token_63 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2027 = wave.barrier %2026 : (!wave.mem.token) -> !wave.mem.token
        %value_234, %token_235 = waveamd.transpose_load %379 after %2027 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2028 = wave.extract %value_234[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2029 = wave.extract %value_234[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2030 = wave.ptr_add %arg0, %arg13 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2031 = waveamd.make_buffer %2030, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2032 = wave.join %arg116, %arg115 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2033 = wave.ptr_add %2031, %56 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2034 = waveamd.dma_load_lds %2033 -> %58 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2035 = wave.ptr_add %2031, %61 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2036 = waveamd.dma_load_lds %2035 -> %64 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2037 = wave.ptr_add %2031, %67 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2038 = waveamd.dma_load_lds %2037 -> %70 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2039 = wave.ptr_add %2031, %73 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2040 = waveamd.dma_load_lds %2039 -> %76 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2041 = wave.ptr_add %2031, %79 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2042 = waveamd.dma_load_lds %2041 -> %82 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2043 = wave.ptr_add %2031, %85 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2044 = waveamd.dma_load_lds %2043 -> %88 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2045 = wave.ptr_add %2031, %91 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2046 = waveamd.dma_load_lds %2045 -> %94 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2047 = wave.ptr_add %2031, %97 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2048 = waveamd.dma_load_lds %2047 -> %100 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2049 = wave.join %2034, %2036, %2038, %2040, %2042, %2044, %2046, %2048 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2050 = wave.ptr_add %arg1, %arg14 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2051 = waveamd.make_buffer %2050, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2052 = wave.ptr_add %2051, %107 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2053 = waveamd.dma_load_lds %2052 -> %109 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2054 = wave.ptr_add %2051, %112 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2055 = waveamd.dma_load_lds %2054 -> %114 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2056 = wave.ptr_add %2051, %117 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2057 = waveamd.dma_load_lds %2056 -> %119 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2058 = wave.ptr_add %2051, %122 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2059 = waveamd.dma_load_lds %2058 -> %124 after %2032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2060 = wave.join %2053, %2055, %2057, %2059 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2061 = wave.ptr_add %arg3, %arg15 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2062 = waveamd.make_buffer %2061, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2063 = wave.ptr_add %2062, %129 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_236, %token_237 = wave.load %2063 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2064 = wave.ptr_add %arg4, %arg16 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2065 = waveamd.make_buffer %2064, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2066 = wave.ptr_add %2065, %133 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_238, %token_239 = wave.load %2066 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %2067 = wave.join %2049, %2060 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2068 = waveamd.fragment_pack %value_218 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2069 = waveamd.fragment_pack %value_220 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2070 = waveamd.fragment_pack %value_222 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2071 = waveamd.fragment_pack %value_224 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2072 = waveamd.fragment_pack %value_226 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2073 = waveamd.fragment_pack %value_228 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2074 = waveamd.fragment_pack %value_230 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2075 = waveamd.fragment_pack %value_232 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2076 = waveamd.fragment_pack %arg49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2077 = waveamd.fragment_pack %arg50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2078 = waveamd.fragment_pack %arg51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2079 = waveamd.fragment_pack %arg52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2080 = waveamd.fragment_pack %arg53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2081 = waveamd.fragment_pack %arg54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2082 = waveamd.fragment_pack %arg55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2083 = waveamd.fragment_pack %arg56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2084 = waveamd.fragment_pack %arg57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2085 = waveamd.fragment_pack %arg58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2086 = waveamd.fragment_pack %arg59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2087 = waveamd.fragment_pack %arg60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2088 = waveamd.fragment_pack %arg61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2089 = waveamd.fragment_pack %arg62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2090 = waveamd.fragment_pack %arg63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2091 = waveamd.fragment_pack %arg64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2092 = waveamd.fragment_pack %arg65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2093 = waveamd.fragment_pack %arg66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2094 = waveamd.fragment_pack %arg67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2095 = waveamd.fragment_pack %arg68 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2096 = waveamd.fragment_pack %arg69 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2097 = waveamd.fragment_pack %arg70 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2098 = waveamd.fragment_pack %arg71 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2099 = waveamd.fragment_pack %arg72 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2100 = waveamd.fragment_pack %arg73 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2101 = waveamd.fragment_pack %arg74 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2102 = waveamd.fragment_pack %arg75 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2103 = waveamd.fragment_pack %arg76 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2104 = waveamd.fragment_pack %arg77 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2105 = waveamd.fragment_pack %arg78 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2106 = waveamd.fragment_pack %arg79 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2107 = waveamd.fragment_pack %arg80 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2108 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2068, %2028, %1864, %arg109, %2076 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2109 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2069, %2028, %1865, %arg109, %2108 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2110 = waveamd.fragment_unpack %2109 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2111 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2070, %2028, %1864, %arg109, %2077 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2112 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2071, %2028, %1865, %arg109, %2111 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2113 = waveamd.fragment_unpack %2112 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2114 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2072, %2029, %1864, %arg109, %2078 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2115 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2073, %2029, %1865, %arg109, %2114 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2116 = waveamd.fragment_unpack %2115 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2117 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2074, %2029, %1864, %arg109, %2079 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2118 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2075, %2029, %1865, %arg109, %2117 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2119 = waveamd.fragment_unpack %2118 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2120 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2068, %2028, %1866, %arg109, %2080 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2121 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2069, %2028, %1867, %arg109, %2120 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2122 = waveamd.fragment_unpack %2121 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2123 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2070, %2028, %1866, %arg109, %2081 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2124 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2071, %2028, %1867, %arg109, %2123 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2125 = waveamd.fragment_unpack %2124 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2126 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2072, %2029, %1866, %arg109, %2082 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2127 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2073, %2029, %1867, %arg109, %2126 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2128 = waveamd.fragment_unpack %2127 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2129 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2074, %2029, %1866, %arg109, %2083 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2130 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2075, %2029, %1867, %arg109, %2129 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2131 = waveamd.fragment_unpack %2130 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2132 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2068, %2028, %1868, %arg110, %2084 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2133 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2069, %2028, %1869, %arg110, %2132 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2134 = waveamd.fragment_unpack %2133 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2135 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2070, %2028, %1868, %arg110, %2085 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2136 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2071, %2028, %1869, %arg110, %2135 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2137 = waveamd.fragment_unpack %2136 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2138 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2072, %2029, %1868, %arg110, %2086 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2139 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2073, %2029, %1869, %arg110, %2138 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2140 = waveamd.fragment_unpack %2139 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2141 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2074, %2029, %1868, %arg110, %2087 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2142 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2075, %2029, %1869, %arg110, %2141 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2143 = waveamd.fragment_unpack %2142 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2144 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2068, %2028, %1870, %arg110, %2088 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2145 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2069, %2028, %1871, %arg110, %2144 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2146 = waveamd.fragment_unpack %2145 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2147 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2070, %2028, %1870, %arg110, %2089 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2148 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2071, %2028, %1871, %arg110, %2147 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2149 = waveamd.fragment_unpack %2148 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2150 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2072, %2029, %1870, %arg110, %2090 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2151 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2073, %2029, %1871, %arg110, %2150 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2152 = waveamd.fragment_unpack %2151 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2153 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2074, %2029, %1870, %arg110, %2091 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2154 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2075, %2029, %1871, %arg110, %2153 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2155 = waveamd.fragment_unpack %2154 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2156 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2068, %2028, %1872, %arg111, %2092 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2157 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2069, %2028, %1873, %arg111, %2156 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2158 = waveamd.fragment_unpack %2157 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2159 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2070, %2028, %1872, %arg111, %2093 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2160 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2071, %2028, %1873, %arg111, %2159 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2161 = waveamd.fragment_unpack %2160 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2162 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2072, %2029, %1872, %arg111, %2094 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2163 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2073, %2029, %1873, %arg111, %2162 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2164 = waveamd.fragment_unpack %2163 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2165 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2074, %2029, %1872, %arg111, %2095 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2166 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2075, %2029, %1873, %arg111, %2165 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2167 = waveamd.fragment_unpack %2166 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2168 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2068, %2028, %1874, %arg111, %2096 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2169 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2069, %2028, %1875, %arg111, %2168 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2170 = waveamd.fragment_unpack %2169 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2171 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2070, %2028, %1874, %arg111, %2097 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2172 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2071, %2028, %1875, %arg111, %2171 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2173 = waveamd.fragment_unpack %2172 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2174 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2072, %2029, %1874, %arg111, %2098 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2175 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2073, %2029, %1875, %arg111, %2174 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2176 = waveamd.fragment_unpack %2175 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2177 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2074, %2029, %1874, %arg111, %2099 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2178 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2075, %2029, %1875, %arg111, %2177 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2179 = waveamd.fragment_unpack %2178 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2180 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2068, %2028, %1876, %arg112, %2100 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2181 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2069, %2028, %1877, %arg112, %2180 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2182 = waveamd.fragment_unpack %2181 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2183 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2070, %2028, %1876, %arg112, %2101 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2184 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2071, %2028, %1877, %arg112, %2183 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2185 = waveamd.fragment_unpack %2184 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2186 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2072, %2029, %1876, %arg112, %2102 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2187 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2073, %2029, %1877, %arg112, %2186 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2188 = waveamd.fragment_unpack %2187 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2189 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2074, %2029, %1876, %arg112, %2103 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2190 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2075, %2029, %1877, %arg112, %2189 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2191 = waveamd.fragment_unpack %2190 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2192 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2068, %2028, %1878, %arg112, %2104 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2193 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2069, %2028, %1879, %arg112, %2192 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2194 = waveamd.fragment_unpack %2193 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2195 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2070, %2028, %1878, %arg112, %2105 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2196 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2071, %2028, %1879, %arg112, %2195 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2197 = waveamd.fragment_unpack %2196 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2198 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2072, %2029, %1878, %arg112, %2106 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2199 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2073, %2029, %1879, %arg112, %2198 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2200 = waveamd.fragment_unpack %2199 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2201 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2074, %2029, %1878, %arg112, %2107 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2202 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2075, %2029, %1879, %arg112, %2201 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2203 = waveamd.fragment_unpack %2202 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg116 : !wave.mem.token
        %2204 = wave.barrier %arg116 : (!wave.mem.token) -> !wave.mem.token
        %2205 = wave.ptr_add %161, %274 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_240, %token_241 = wave.load %2205 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2206 = wave.ptr_add %161, %276 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_242, %token_243 = wave.load %2206 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2207 = wave.ptr_add %161, %278 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_244, %token_245 = wave.load %2207 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2208 = wave.ptr_add %161, %280 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_246, %token_247 = wave.load %2208 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2209 = wave.ptr_add %161, %282 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_248, %token_249 = wave.load %2209 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2210 = wave.ptr_add %161, %284 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_250, %token_251 = wave.load %2210 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2211 = wave.ptr_add %161, %286 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_252, %token_253 = wave.load %2211 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2212 = wave.ptr_add %161, %288 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_254, %token_255 = wave.load %2212 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2213 = wave.ptr_add %161, %290 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_256, %token_257 = wave.load %2213 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2214 = wave.ptr_add %161, %292 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_258, %token_259 = wave.load %2214 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2215 = wave.ptr_add %161, %294 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_260, %token_261 = wave.load %2215 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2216 = wave.ptr_add %161, %296 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_262, %token_263 = wave.load %2216 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2217 = wave.ptr_add %161, %298 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_264, %token_265 = wave.load %2217 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2218 = wave.ptr_add %161, %300 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_266, %token_267 = wave.load %2218 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2219 = wave.ptr_add %161, %302 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_268, %token_269 = wave.load %2219 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2220 = wave.ptr_add %161, %304 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_270, %token_271 = wave.load %2220 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2221 = wave.join %token_241, %token_243, %token_245, %token_247, %token_249, %token_251, %token_253, %token_255, %token_257, %token_259, %token_261, %token_263, %token_265, %token_267, %token_269, %token_271 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2222 = wave.ptr_add %211, %306 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_272, %token_273 = wave.load %2222 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2223 = wave.ptr_add %211, %308 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_274, %token_275 = wave.load %2223 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2224 = wave.ptr_add %211, %310 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_276, %token_277 = wave.load %2224 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2225 = wave.ptr_add %211, %312 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_278, %token_279 = wave.load %2225 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2226 = wave.ptr_add %211, %314 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_280, %token_281 = wave.load %2226 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2227 = wave.ptr_add %211, %316 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_282, %token_283 = wave.load %2227 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2228 = wave.ptr_add %211, %318 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_284, %token_285 = wave.load %2228 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2229 = wave.ptr_add %211, %320 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_286, %token_287 = wave.load %2229 after %2204 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2230 = wave.join %token_273, %token_275, %token_277, %token_279, %token_281, %token_283, %token_285, %token_287 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2231 = wave.store %arg82 -> %352 after %377 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2232 = wave.barrier %2231 : (!wave.mem.token) -> !wave.mem.token
        %2233 = wave.store %arg83 -> %366 after %token_235 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2234 = wave.barrier %2233 : (!wave.mem.token) -> !wave.mem.token
        %value_288, %token_289 = waveamd.transpose_load %370 after %2232 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2235 = wave.extract %value_288[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2236 = wave.extract %value_288[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %value_290, %token_291 = waveamd.transpose_load %374 after %2232 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2237 = wave.extract %value_290[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2238 = wave.extract %value_290[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2239 = wave.join %token_289, %token_291 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_292, %token_293 = waveamd.transpose_load %379 after %2234 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2240 = wave.extract %value_292[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2241 = wave.extract %value_292[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2242 = wave.join %2025, %arg116 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2243 = wave.ptr_add %2051, %138 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2244 = waveamd.dma_load_lds %2243 -> %140 after %2242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2245 = wave.ptr_add %2051, %143 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2246 = waveamd.dma_load_lds %2245 -> %145 after %2242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2247 = wave.ptr_add %2051, %148 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2248 = waveamd.dma_load_lds %2247 -> %150 after %2242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2249 = wave.ptr_add %2051, %153 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2250 = waveamd.dma_load_lds %2249 -> %155 after %2242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2251 = wave.join %2244, %2246, %2248, %2250 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2252 = wave.ptr_add %2065, %159 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_294, %token_295 = wave.load %2252 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %2253 = waveamd.fragment_pack %value_240 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2254 = waveamd.fragment_pack %value_242 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2255 = waveamd.fragment_pack %value_244 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2256 = waveamd.fragment_pack %value_246 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2257 = waveamd.fragment_pack %value_248 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2258 = waveamd.fragment_pack %value_250 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2259 = waveamd.fragment_pack %value_252 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2260 = waveamd.fragment_pack %value_254 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2261 = waveamd.fragment_pack %value_256 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2262 = waveamd.fragment_pack %value_258 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2263 = waveamd.fragment_pack %value_260 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2264 = waveamd.fragment_pack %value_262 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2265 = waveamd.fragment_pack %value_264 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2266 = waveamd.fragment_pack %value_266 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2267 = waveamd.fragment_pack %value_268 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2268 = waveamd.fragment_pack %value_270 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2269 = waveamd.fragment_pack %value_272 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2270 = waveamd.fragment_pack %value_274 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2271 = waveamd.fragment_pack %value_276 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2272 = waveamd.fragment_pack %value_278 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2273 = waveamd.fragment_pack %value_280 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2274 = waveamd.fragment_pack %value_282 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2275 = waveamd.fragment_pack %value_284 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2276 = waveamd.fragment_pack %value_286 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2277 = waveamd.fragment_pack %1922 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2278 = waveamd.fragment_pack %1925 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2279 = waveamd.fragment_pack %1928 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2280 = waveamd.fragment_pack %1931 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2281 = waveamd.fragment_pack %1934 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2282 = waveamd.fragment_pack %1937 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2283 = waveamd.fragment_pack %1940 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2284 = waveamd.fragment_pack %1943 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2285 = waveamd.fragment_pack %1946 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2286 = waveamd.fragment_pack %1949 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2287 = waveamd.fragment_pack %1952 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2288 = waveamd.fragment_pack %1955 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2289 = waveamd.fragment_pack %1958 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2290 = waveamd.fragment_pack %1961 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2291 = waveamd.fragment_pack %1964 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2292 = waveamd.fragment_pack %1967 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2293 = waveamd.fragment_pack %1970 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2294 = waveamd.fragment_pack %1973 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2295 = waveamd.fragment_pack %1976 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2296 = waveamd.fragment_pack %1979 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2297 = waveamd.fragment_pack %1982 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2298 = waveamd.fragment_pack %1985 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2299 = waveamd.fragment_pack %1988 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2300 = waveamd.fragment_pack %1991 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2301 = waveamd.fragment_pack %1994 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2302 = waveamd.fragment_pack %1997 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2303 = waveamd.fragment_pack %2000 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2304 = waveamd.fragment_pack %2003 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2305 = waveamd.fragment_pack %2006 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2306 = waveamd.fragment_pack %2009 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2307 = waveamd.fragment_pack %2012 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2308 = waveamd.fragment_pack %2015 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2309 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2269, %2240, %2253, %2235, %2277 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2310 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2270, %2240, %2254, %2235, %2309 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2311 = waveamd.fragment_unpack %2310 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2312 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2271, %2240, %2253, %2235, %2278 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2313 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2272, %2240, %2254, %2235, %2312 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2314 = waveamd.fragment_unpack %2313 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2315 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2273, %2241, %2253, %2235, %2279 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2316 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2274, %2241, %2254, %2235, %2315 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2317 = waveamd.fragment_unpack %2316 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2318 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2275, %2241, %2253, %2235, %2280 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2319 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2276, %2241, %2254, %2235, %2318 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2320 = waveamd.fragment_unpack %2319 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2321 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2269, %2240, %2255, %2235, %2281 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2322 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2270, %2240, %2256, %2235, %2321 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2323 = waveamd.fragment_unpack %2322 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2324 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2271, %2240, %2255, %2235, %2282 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2325 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2272, %2240, %2256, %2235, %2324 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2326 = waveamd.fragment_unpack %2325 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2327 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2273, %2241, %2255, %2235, %2283 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2328 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2274, %2241, %2256, %2235, %2327 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2329 = waveamd.fragment_unpack %2328 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2330 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2275, %2241, %2255, %2235, %2284 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2331 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2276, %2241, %2256, %2235, %2330 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2332 = waveamd.fragment_unpack %2331 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2333 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2269, %2240, %2257, %2236, %2285 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2334 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2270, %2240, %2258, %2236, %2333 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2335 = waveamd.fragment_unpack %2334 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2336 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2271, %2240, %2257, %2236, %2286 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2337 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2272, %2240, %2258, %2236, %2336 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2338 = waveamd.fragment_unpack %2337 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2339 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2273, %2241, %2257, %2236, %2287 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2340 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2274, %2241, %2258, %2236, %2339 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2341 = waveamd.fragment_unpack %2340 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2342 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2275, %2241, %2257, %2236, %2288 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2343 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2276, %2241, %2258, %2236, %2342 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2344 = waveamd.fragment_unpack %2343 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2345 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2269, %2240, %2259, %2236, %2289 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2346 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2270, %2240, %2260, %2236, %2345 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2347 = waveamd.fragment_unpack %2346 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2348 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2271, %2240, %2259, %2236, %2290 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2349 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2272, %2240, %2260, %2236, %2348 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2350 = waveamd.fragment_unpack %2349 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2351 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2273, %2241, %2259, %2236, %2291 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2352 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2274, %2241, %2260, %2236, %2351 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2353 = waveamd.fragment_unpack %2352 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2354 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2275, %2241, %2259, %2236, %2292 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2355 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2276, %2241, %2260, %2236, %2354 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2356 = waveamd.fragment_unpack %2355 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2357 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2269, %2240, %2261, %2237, %2293 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2358 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2270, %2240, %2262, %2237, %2357 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2359 = waveamd.fragment_unpack %2358 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2360 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2271, %2240, %2261, %2237, %2294 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2361 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2272, %2240, %2262, %2237, %2360 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2362 = waveamd.fragment_unpack %2361 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2363 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2273, %2241, %2261, %2237, %2295 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2364 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2274, %2241, %2262, %2237, %2363 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2365 = waveamd.fragment_unpack %2364 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2366 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2275, %2241, %2261, %2237, %2296 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2367 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2276, %2241, %2262, %2237, %2366 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2368 = waveamd.fragment_unpack %2367 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2369 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2269, %2240, %2263, %2237, %2297 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2370 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2270, %2240, %2264, %2237, %2369 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2371 = waveamd.fragment_unpack %2370 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2372 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2271, %2240, %2263, %2237, %2298 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2373 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2272, %2240, %2264, %2237, %2372 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2374 = waveamd.fragment_unpack %2373 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2375 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2273, %2241, %2263, %2237, %2299 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2376 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2274, %2241, %2264, %2237, %2375 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2377 = waveamd.fragment_unpack %2376 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2378 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2275, %2241, %2263, %2237, %2300 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2379 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2276, %2241, %2264, %2237, %2378 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2380 = waveamd.fragment_unpack %2379 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2381 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2269, %2240, %2265, %2238, %2301 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2382 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2270, %2240, %2266, %2238, %2381 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2383 = waveamd.fragment_unpack %2382 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2384 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2271, %2240, %2265, %2238, %2302 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2385 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2272, %2240, %2266, %2238, %2384 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2386 = waveamd.fragment_unpack %2385 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2387 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2273, %2241, %2265, %2238, %2303 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2388 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2274, %2241, %2266, %2238, %2387 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2389 = waveamd.fragment_unpack %2388 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2390 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2275, %2241, %2265, %2238, %2304 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2391 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2276, %2241, %2266, %2238, %2390 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2392 = waveamd.fragment_unpack %2391 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2393 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2269, %2240, %2267, %2238, %2305 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2394 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2270, %2240, %2268, %2238, %2393 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2395 = waveamd.fragment_unpack %2394 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2396 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2271, %2240, %2267, %2238, %2306 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2397 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2272, %2240, %2268, %2238, %2396 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2398 = waveamd.fragment_unpack %2397 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2399 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2273, %2241, %2267, %2238, %2307 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2400 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2274, %2241, %2268, %2238, %2399 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2401 = waveamd.fragment_unpack %2400 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2402 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2275, %2241, %2267, %2238, %2308 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2403 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2276, %2241, %2268, %2238, %2402 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2404 = waveamd.fragment_unpack %2403 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg117 : !wave.mem.token
        %2405 = wave.barrier %arg117 : (!wave.mem.token) -> !wave.mem.token
        %2406 = wave.ptr_add %244, %306 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_296, %token_297 = wave.load %2406 after %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2407 = wave.ptr_add %244, %308 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_298, %token_299 = wave.load %2407 after %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2408 = wave.ptr_add %244, %310 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_300, %token_301 = wave.load %2408 after %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2409 = wave.ptr_add %244, %312 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_302, %token_303 = wave.load %2409 after %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2410 = wave.ptr_add %244, %314 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_304, %token_305 = wave.load %2410 after %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2411 = wave.ptr_add %244, %316 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_306, %token_307 = wave.load %2411 after %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2412 = wave.ptr_add %244, %318 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_308, %token_309 = wave.load %2412 after %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2413 = wave.ptr_add %244, %320 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_310, %token_311 = wave.load %2413 after %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2414 = wave.join %token_297, %token_299, %token_301, %token_303, %token_305, %token_307, %token_309, %token_311 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2415 = wave.store %arg84 -> %366 after %token_293 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2416 = wave.barrier %2415 : (!wave.mem.token) -> !wave.mem.token
        %value_312, %token_313 = waveamd.transpose_load %379 after %2416 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2417 = wave.extract %value_312[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2418 = wave.extract %value_312[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2419 = wave.join %2221, %arg117 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2420 = wave.ptr_add %2031, %163 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2421 = waveamd.dma_load_lds %2420 -> %166 after %2419 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2422 = wave.ptr_add %2031, %169 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2423 = waveamd.dma_load_lds %2422 -> %172 after %2419 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2424 = wave.ptr_add %2031, %175 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2425 = waveamd.dma_load_lds %2424 -> %178 after %2419 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2426 = wave.ptr_add %2031, %181 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2427 = waveamd.dma_load_lds %2426 -> %184 after %2419 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2428 = wave.ptr_add %2031, %187 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2429 = waveamd.dma_load_lds %2428 -> %190 after %2419 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2430 = wave.ptr_add %2031, %193 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2431 = waveamd.dma_load_lds %2430 -> %196 after %2419 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2432 = wave.ptr_add %2031, %199 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2433 = waveamd.dma_load_lds %2432 -> %202 after %2419 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2434 = wave.ptr_add %2031, %205 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2435 = waveamd.dma_load_lds %2434 -> %208 after %2419 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2436 = wave.join %2421, %2423, %2425, %2427, %2429, %2431, %2433, %2435 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2437 = wave.join %2230, %arg117 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2438 = wave.ptr_add %2051, %213 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2439 = waveamd.dma_load_lds %2438 -> %216 after %2437 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2440 = wave.ptr_add %2051, %219 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2441 = waveamd.dma_load_lds %2440 -> %222 after %2437 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2442 = wave.ptr_add %2051, %225 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2443 = waveamd.dma_load_lds %2442 -> %228 after %2437 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2444 = wave.ptr_add %2051, %231 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2445 = waveamd.dma_load_lds %2444 -> %234 after %2437 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2446 = wave.join %2439, %2441, %2443, %2445 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2447 = wave.ptr_add %2062, %238 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_314, %token_315 = wave.load %2447 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2448 = wave.ptr_add %2065, %241 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_316, %token_317 = wave.load %2448 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %2449 = wave.join %2436, %2446 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2450 = waveamd.fragment_pack %value_296 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2451 = waveamd.fragment_pack %value_298 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2452 = waveamd.fragment_pack %value_300 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2453 = waveamd.fragment_pack %value_302 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2454 = waveamd.fragment_pack %value_304 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2455 = waveamd.fragment_pack %value_306 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2456 = waveamd.fragment_pack %value_308 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2457 = waveamd.fragment_pack %value_310 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2458 = waveamd.fragment_pack %2110 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2459 = waveamd.fragment_pack %2113 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2460 = waveamd.fragment_pack %2116 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2461 = waveamd.fragment_pack %2119 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2462 = waveamd.fragment_pack %2122 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2463 = waveamd.fragment_pack %2125 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2464 = waveamd.fragment_pack %2128 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2465 = waveamd.fragment_pack %2131 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2466 = waveamd.fragment_pack %2134 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2467 = waveamd.fragment_pack %2137 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2468 = waveamd.fragment_pack %2140 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2469 = waveamd.fragment_pack %2143 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2470 = waveamd.fragment_pack %2146 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2471 = waveamd.fragment_pack %2149 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2472 = waveamd.fragment_pack %2152 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2473 = waveamd.fragment_pack %2155 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2474 = waveamd.fragment_pack %2158 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2475 = waveamd.fragment_pack %2161 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2476 = waveamd.fragment_pack %2164 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2477 = waveamd.fragment_pack %2167 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2478 = waveamd.fragment_pack %2170 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2479 = waveamd.fragment_pack %2173 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2480 = waveamd.fragment_pack %2176 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2481 = waveamd.fragment_pack %2179 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2482 = waveamd.fragment_pack %2182 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2483 = waveamd.fragment_pack %2185 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2484 = waveamd.fragment_pack %2188 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2485 = waveamd.fragment_pack %2191 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2486 = waveamd.fragment_pack %2194 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2487 = waveamd.fragment_pack %2197 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2488 = waveamd.fragment_pack %2200 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2489 = waveamd.fragment_pack %2203 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2490 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2450, %2417, %2253, %2235, %2458 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2491 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2451, %2417, %2254, %2235, %2490 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2492 = waveamd.fragment_unpack %2491 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2493 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2452, %2417, %2253, %2235, %2459 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2494 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2453, %2417, %2254, %2235, %2493 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2495 = waveamd.fragment_unpack %2494 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2496 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2454, %2418, %2253, %2235, %2460 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2497 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2418, %2254, %2235, %2496 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2498 = waveamd.fragment_unpack %2497 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2499 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2418, %2253, %2235, %2461 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2500 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2418, %2254, %2235, %2499 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2501 = waveamd.fragment_unpack %2500 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2502 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2450, %2417, %2255, %2235, %2462 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2503 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2451, %2417, %2256, %2235, %2502 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2504 = waveamd.fragment_unpack %2503 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2505 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2452, %2417, %2255, %2235, %2463 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2506 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2453, %2417, %2256, %2235, %2505 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2507 = waveamd.fragment_unpack %2506 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2508 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2454, %2418, %2255, %2235, %2464 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2509 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2418, %2256, %2235, %2508 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2510 = waveamd.fragment_unpack %2509 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2511 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2418, %2255, %2235, %2465 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2512 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2418, %2256, %2235, %2511 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2513 = waveamd.fragment_unpack %2512 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2514 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2450, %2417, %2257, %2236, %2466 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2515 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2451, %2417, %2258, %2236, %2514 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2516 = waveamd.fragment_unpack %2515 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2517 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2452, %2417, %2257, %2236, %2467 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2518 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2453, %2417, %2258, %2236, %2517 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2519 = waveamd.fragment_unpack %2518 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2520 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2454, %2418, %2257, %2236, %2468 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2521 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2418, %2258, %2236, %2520 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2522 = waveamd.fragment_unpack %2521 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2523 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2418, %2257, %2236, %2469 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2524 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2418, %2258, %2236, %2523 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2525 = waveamd.fragment_unpack %2524 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2526 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2450, %2417, %2259, %2236, %2470 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2527 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2451, %2417, %2260, %2236, %2526 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2528 = waveamd.fragment_unpack %2527 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2529 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2452, %2417, %2259, %2236, %2471 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2530 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2453, %2417, %2260, %2236, %2529 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2531 = waveamd.fragment_unpack %2530 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2532 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2454, %2418, %2259, %2236, %2472 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2533 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2418, %2260, %2236, %2532 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2534 = waveamd.fragment_unpack %2533 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2535 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2418, %2259, %2236, %2473 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2536 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2418, %2260, %2236, %2535 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2537 = waveamd.fragment_unpack %2536 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2538 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2450, %2417, %2261, %2237, %2474 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2539 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2451, %2417, %2262, %2237, %2538 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2540 = waveamd.fragment_unpack %2539 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2541 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2452, %2417, %2261, %2237, %2475 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2542 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2453, %2417, %2262, %2237, %2541 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2543 = waveamd.fragment_unpack %2542 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2544 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2454, %2418, %2261, %2237, %2476 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2545 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2418, %2262, %2237, %2544 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2546 = waveamd.fragment_unpack %2545 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2547 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2418, %2261, %2237, %2477 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2548 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2418, %2262, %2237, %2547 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2549 = waveamd.fragment_unpack %2548 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2550 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2450, %2417, %2263, %2237, %2478 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2551 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2451, %2417, %2264, %2237, %2550 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2552 = waveamd.fragment_unpack %2551 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2553 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2452, %2417, %2263, %2237, %2479 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2554 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2453, %2417, %2264, %2237, %2553 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2555 = waveamd.fragment_unpack %2554 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2556 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2454, %2418, %2263, %2237, %2480 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2557 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2418, %2264, %2237, %2556 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2558 = waveamd.fragment_unpack %2557 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2559 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2418, %2263, %2237, %2481 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2560 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2418, %2264, %2237, %2559 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2561 = waveamd.fragment_unpack %2560 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2562 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2450, %2417, %2265, %2238, %2482 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2563 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2451, %2417, %2266, %2238, %2562 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2564 = waveamd.fragment_unpack %2563 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2565 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2452, %2417, %2265, %2238, %2483 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2566 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2453, %2417, %2266, %2238, %2565 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2567 = waveamd.fragment_unpack %2566 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2568 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2454, %2418, %2265, %2238, %2484 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2569 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2418, %2266, %2238, %2568 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2570 = waveamd.fragment_unpack %2569 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2571 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2418, %2265, %2238, %2485 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2572 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2418, %2266, %2238, %2571 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2573 = waveamd.fragment_unpack %2572 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2574 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2450, %2417, %2267, %2238, %2486 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2575 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2451, %2417, %2268, %2238, %2574 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2576 = waveamd.fragment_unpack %2575 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2577 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2452, %2417, %2267, %2238, %2487 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2578 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2453, %2417, %2268, %2238, %2577 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2579 = waveamd.fragment_unpack %2578 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2580 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2454, %2418, %2267, %2238, %2488 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2581 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2455, %2418, %2268, %2238, %2580 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2582 = waveamd.fragment_unpack %2581 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2583 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2456, %2418, %2267, %2238, %2489 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2584 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2457, %2418, %2268, %2238, %2583 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2585 = waveamd.fragment_unpack %2584 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %2067 : !wave.mem.token
        %2586 = wave.barrier %2067 : (!wave.mem.token) -> !wave.mem.token
        %value_318, %token_319 = wave.load %275 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_320, %token_321 = wave.load %277 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_322, %token_323 = wave.load %279 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_324, %token_325 = wave.load %281 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_326, %token_327 = wave.load %283 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_328, %token_329 = wave.load %285 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_330, %token_331 = wave.load %287 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_332, %token_333 = wave.load %289 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_334, %token_335 = wave.load %291 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_336, %token_337 = wave.load %293 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_338, %token_339 = wave.load %295 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_340, %token_341 = wave.load %297 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_342, %token_343 = wave.load %299 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_344, %token_345 = wave.load %301 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_346, %token_347 = wave.load %303 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_348, %token_349 = wave.load %305 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_350, %token_351 = wave.load %307 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_352, %token_353 = wave.load %309 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_354, %token_355 = wave.load %311 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_356, %token_357 = wave.load %313 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_358, %token_359 = wave.load %315 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_360, %token_361 = wave.load %317 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_362, %token_363 = wave.load %319 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_364, %token_365 = wave.load %321 after %2586 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2587 = wave.store %value_236 -> %352 after %2239 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2588 = wave.barrier %2587 : (!wave.mem.token) -> !wave.mem.token
        %2589 = wave.store %value_238 -> %366 after %token_313 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2590 = wave.barrier %2589 : (!wave.mem.token) -> !wave.mem.token
        %value_366, %token_367 = waveamd.transpose_load %370 after %2588 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2591 = wave.extract %value_366[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2592 = wave.extract %value_366[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %value_368, %token_369 = waveamd.transpose_load %374 after %2588 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2593 = wave.extract %value_368[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2594 = wave.extract %value_368[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %value_370, %token_371 = waveamd.transpose_load %379 after %2590 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2595 = wave.extract %value_370[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2596 = wave.extract %value_370[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2597 = wave.ptr_add %2051, %246 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2598 = waveamd.dma_load_lds %2597 -> %248 after %2414 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2599 = wave.ptr_add %2051, %251 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2600 = waveamd.dma_load_lds %2599 -> %253 after %2414 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2601 = wave.ptr_add %2051, %256 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2602 = waveamd.dma_load_lds %2601 -> %258 after %2414 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2603 = wave.ptr_add %2051, %261 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2604 = waveamd.dma_load_lds %2603 -> %263 after %2414 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2605 = wave.join %2598, %2600, %2602, %2604 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2606 = wave.ptr_add %2065, %267 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_372, %token_373 = wave.load %2606 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %2607 = wave.binary addi %arg13, %c256_i32 : i32, i32 -> i32
        %2608 = wave.binary addi %arg14, %c256_i32 : i32, i32 -> i32
        %2609 = wave.binary addi %arg15, %271 : i32, i32 -> i32
        %2610 = wave.binary addi %arg16, %272 : i32, i32 -> i32
        scf.yield %2607, %2608, %2609, %2610, %2311, %2314, %2317, %2320, %2323, %2326, %2329, %2332, %2335, %2338, %2341, %2344, %2347, %2350, %2353, %2356, %2359, %2362, %2365, %2368, %2371, %2374, %2377, %2380, %2383, %2386, %2389, %2392, %2395, %2398, %2401, %2404, %2492, %2495, %2498, %2501, %2504, %2507, %2510, %2513, %2516, %2519, %2522, %2525, %2528, %2531, %2534, %2537, %2540, %2543, %2546, %2549, %2552, %2555, %2558, %2561, %2564, %2567, %2570, %2573, %2576, %2579, %2582, %2585, %value_294, %value_314, %value_316, %value_372, %value_318, %value_320, %value_322, %value_324, %value_326, %value_328, %value_330, %value_332, %value_334, %value_336, %value_338, %value_340, %value_342, %value_344, %value_346, %value_348, %value_350, %value_352, %value_354, %value_356, %value_358, %value_360, %value_362, %value_364, %2591, %2592, %2593, %2594, %2595, %2596, %2251, %2449, %2605 : i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<8xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      %383 = waveamd.fragment_pack %382#72 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %384 = waveamd.fragment_pack %382#73 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %385 = waveamd.fragment_pack %382#74 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %386 = waveamd.fragment_pack %382#75 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %387 = waveamd.fragment_pack %382#76 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %388 = waveamd.fragment_pack %382#77 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %389 = waveamd.fragment_pack %382#78 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %390 = waveamd.fragment_pack %382#79 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %391 = waveamd.fragment_pack %382#80 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %392 = waveamd.fragment_pack %382#81 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %393 = waveamd.fragment_pack %382#82 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %394 = waveamd.fragment_pack %382#83 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %395 = waveamd.fragment_pack %382#84 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %396 = waveamd.fragment_pack %382#85 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %397 = waveamd.fragment_pack %382#86 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %398 = waveamd.fragment_pack %382#87 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %399 = waveamd.fragment_pack %382#88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %400 = waveamd.fragment_pack %382#89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %401 = waveamd.fragment_pack %382#90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %402 = waveamd.fragment_pack %382#91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %403 = waveamd.fragment_pack %382#92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %404 = waveamd.fragment_pack %382#93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %405 = waveamd.fragment_pack %382#94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %406 = waveamd.fragment_pack %382#95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %407 = waveamd.fragment_pack %382#4 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %408 = waveamd.fragment_pack %382#5 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %409 = waveamd.fragment_pack %382#6 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %410 = waveamd.fragment_pack %382#7 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %411 = waveamd.fragment_pack %382#8 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %412 = waveamd.fragment_pack %382#9 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %413 = waveamd.fragment_pack %382#10 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %414 = waveamd.fragment_pack %382#11 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %415 = waveamd.fragment_pack %382#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %416 = waveamd.fragment_pack %382#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %417 = waveamd.fragment_pack %382#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %418 = waveamd.fragment_pack %382#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %419 = waveamd.fragment_pack %382#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %420 = waveamd.fragment_pack %382#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %421 = waveamd.fragment_pack %382#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %422 = waveamd.fragment_pack %382#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %423 = waveamd.fragment_pack %382#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %424 = waveamd.fragment_pack %382#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %425 = waveamd.fragment_pack %382#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %426 = waveamd.fragment_pack %382#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %427 = waveamd.fragment_pack %382#24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %428 = waveamd.fragment_pack %382#25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %429 = waveamd.fragment_pack %382#26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %430 = waveamd.fragment_pack %382#27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %431 = waveamd.fragment_pack %382#28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %432 = waveamd.fragment_pack %382#29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %433 = waveamd.fragment_pack %382#30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %434 = waveamd.fragment_pack %382#31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %435 = waveamd.fragment_pack %382#32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %436 = waveamd.fragment_pack %382#33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %437 = waveamd.fragment_pack %382#34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %438 = waveamd.fragment_pack %382#35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %439 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %382#100, %383, %382#96, %407 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %440 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %382#100, %384, %382#96, %439 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %441 = waveamd.fragment_unpack %440 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %442 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %382#100, %383, %382#96, %408 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %443 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %382#100, %384, %382#96, %442 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %444 = waveamd.fragment_unpack %443 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %445 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %382#101, %383, %382#96, %409 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %446 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %382#101, %384, %382#96, %445 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %447 = waveamd.fragment_unpack %446 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %448 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %382#101, %383, %382#96, %410 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %449 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %382#101, %384, %382#96, %448 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %450 = waveamd.fragment_unpack %449 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %451 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %382#100, %385, %382#96, %411 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %452 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %382#100, %386, %382#96, %451 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %453 = waveamd.fragment_unpack %452 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %454 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %382#100, %385, %382#96, %412 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %455 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %382#100, %386, %382#96, %454 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %456 = waveamd.fragment_unpack %455 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %457 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %382#101, %385, %382#96, %413 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %458 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %382#101, %386, %382#96, %457 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %459 = waveamd.fragment_unpack %458 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %460 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %382#101, %385, %382#96, %414 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %461 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %382#101, %386, %382#96, %460 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %462 = waveamd.fragment_unpack %461 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %463 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %382#100, %387, %382#97, %415 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %464 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %382#100, %388, %382#97, %463 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %465 = waveamd.fragment_unpack %464 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %466 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %382#100, %387, %382#97, %416 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %467 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %382#100, %388, %382#97, %466 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %468 = waveamd.fragment_unpack %467 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %469 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %382#101, %387, %382#97, %417 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %470 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %382#101, %388, %382#97, %469 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %471 = waveamd.fragment_unpack %470 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %472 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %382#101, %387, %382#97, %418 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %473 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %382#101, %388, %382#97, %472 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %474 = waveamd.fragment_unpack %473 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %475 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %382#100, %389, %382#97, %419 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %476 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %382#100, %390, %382#97, %475 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %477 = waveamd.fragment_unpack %476 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %478 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %382#100, %389, %382#97, %420 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %479 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %382#100, %390, %382#97, %478 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %480 = waveamd.fragment_unpack %479 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %481 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %382#101, %389, %382#97, %421 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %482 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %382#101, %390, %382#97, %481 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %483 = waveamd.fragment_unpack %482 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %484 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %382#101, %389, %382#97, %422 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %485 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %382#101, %390, %382#97, %484 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %486 = waveamd.fragment_unpack %485 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %487 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %382#100, %391, %382#98, %423 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %488 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %382#100, %392, %382#98, %487 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %489 = waveamd.fragment_unpack %488 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %490 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %382#100, %391, %382#98, %424 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %491 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %382#100, %392, %382#98, %490 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %492 = waveamd.fragment_unpack %491 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %493 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %382#101, %391, %382#98, %425 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %494 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %382#101, %392, %382#98, %493 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %495 = waveamd.fragment_unpack %494 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %496 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %382#101, %391, %382#98, %426 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %497 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %382#101, %392, %382#98, %496 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %498 = waveamd.fragment_unpack %497 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %499 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %382#100, %393, %382#98, %427 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %500 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %382#100, %394, %382#98, %499 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %501 = waveamd.fragment_unpack %500 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %502 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %382#100, %393, %382#98, %428 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %503 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %382#100, %394, %382#98, %502 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %504 = waveamd.fragment_unpack %503 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %505 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %382#101, %393, %382#98, %429 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %506 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %382#101, %394, %382#98, %505 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %507 = waveamd.fragment_unpack %506 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %508 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %382#101, %393, %382#98, %430 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %509 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %382#101, %394, %382#98, %508 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %510 = waveamd.fragment_unpack %509 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %511 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %382#100, %395, %382#99, %431 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %512 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %382#100, %396, %382#99, %511 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %513 = waveamd.fragment_unpack %512 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %514 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %382#100, %395, %382#99, %432 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %515 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %382#100, %396, %382#99, %514 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %516 = waveamd.fragment_unpack %515 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %517 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %382#101, %395, %382#99, %433 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %518 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %382#101, %396, %382#99, %517 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %519 = waveamd.fragment_unpack %518 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %520 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %382#101, %395, %382#99, %434 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %521 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %382#101, %396, %382#99, %520 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %522 = waveamd.fragment_unpack %521 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %523 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %382#100, %397, %382#99, %435 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %524 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %382#100, %398, %382#99, %523 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %525 = waveamd.fragment_unpack %524 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %526 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %382#100, %397, %382#99, %436 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %527 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %382#100, %398, %382#99, %526 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %528 = waveamd.fragment_unpack %527 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %529 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %382#101, %397, %382#99, %437 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %530 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %382#101, %398, %382#99, %529 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %531 = waveamd.fragment_unpack %530 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %532 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %382#101, %397, %382#99, %438 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %533 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %382#101, %398, %382#99, %532 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %534 = waveamd.fragment_unpack %533 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      wave.wait %382#102, %382#103, %382#104 : !wave.mem.token, !wave.mem.token, !wave.mem.token
      %535 = wave.barrier %382#102, %382#103, %382#104 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %536 = wave.ptr_add %36, %306 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_64, %token_65 = wave.load %536 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %537 = wave.ptr_add %36, %308 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_66, %token_67 = wave.load %537 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %538 = wave.ptr_add %36, %310 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_68, %token_69 = wave.load %538 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %539 = wave.ptr_add %36, %312 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_70, %token_71 = wave.load %539 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %540 = wave.ptr_add %36, %314 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_72, %token_73 = wave.load %540 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %541 = wave.ptr_add %36, %316 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_74, %token_75 = wave.load %541 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %542 = wave.ptr_add %36, %318 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_76, %token_77 = wave.load %542 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %543 = wave.ptr_add %36, %320 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_78, %token_79 = wave.load %543 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %544 = wave.join %token_65, %token_67, %token_69, %token_71, %token_73, %token_75, %token_77, %token_79 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %545 = wave.store %382#68 -> %366 after %token_63 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %546 = wave.barrier %545 : (!wave.mem.token) -> !wave.mem.token
      %value_80, %token_81 = waveamd.transpose_load %379 after %546 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %547 = wave.extract %value_80[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %548 = wave.extract %value_80[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %549 = waveamd.fragment_pack %value_64 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %550 = waveamd.fragment_pack %value_66 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %551 = waveamd.fragment_pack %value_68 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %552 = waveamd.fragment_pack %value_70 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %553 = waveamd.fragment_pack %value_72 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %554 = waveamd.fragment_pack %value_74 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %555 = waveamd.fragment_pack %value_76 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %556 = waveamd.fragment_pack %value_78 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %557 = waveamd.fragment_pack %382#36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %558 = waveamd.fragment_pack %382#37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %559 = waveamd.fragment_pack %382#38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %560 = waveamd.fragment_pack %382#39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %561 = waveamd.fragment_pack %382#40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %562 = waveamd.fragment_pack %382#41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %563 = waveamd.fragment_pack %382#42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %564 = waveamd.fragment_pack %382#43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %565 = waveamd.fragment_pack %382#44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %566 = waveamd.fragment_pack %382#45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %567 = waveamd.fragment_pack %382#46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %568 = waveamd.fragment_pack %382#47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %569 = waveamd.fragment_pack %382#48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %570 = waveamd.fragment_pack %382#49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %571 = waveamd.fragment_pack %382#50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %572 = waveamd.fragment_pack %382#51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %573 = waveamd.fragment_pack %382#52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %574 = waveamd.fragment_pack %382#53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %575 = waveamd.fragment_pack %382#54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %576 = waveamd.fragment_pack %382#55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %577 = waveamd.fragment_pack %382#56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %578 = waveamd.fragment_pack %382#57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %579 = waveamd.fragment_pack %382#58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %580 = waveamd.fragment_pack %382#59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %581 = waveamd.fragment_pack %382#60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %582 = waveamd.fragment_pack %382#61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %583 = waveamd.fragment_pack %382#62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %584 = waveamd.fragment_pack %382#63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %585 = waveamd.fragment_pack %382#64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %586 = waveamd.fragment_pack %382#65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %587 = waveamd.fragment_pack %382#66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %588 = waveamd.fragment_pack %382#67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %547, %383, %382#96, %557 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %547, %384, %382#96, %589 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %591 = waveamd.fragment_unpack %590 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %547, %383, %382#96, %558 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %547, %384, %382#96, %592 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %594 = waveamd.fragment_unpack %593 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %548, %383, %382#96, %559 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %548, %384, %382#96, %595 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %597 = waveamd.fragment_unpack %596 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %548, %383, %382#96, %560 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %556, %548, %384, %382#96, %598 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %600 = waveamd.fragment_unpack %599 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %547, %385, %382#96, %561 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %602 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %547, %386, %382#96, %601 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %603 = waveamd.fragment_unpack %602 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %547, %385, %382#96, %562 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %547, %386, %382#96, %604 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %606 = waveamd.fragment_unpack %605 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %607 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %548, %385, %382#96, %563 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %608 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %548, %386, %382#96, %607 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %609 = waveamd.fragment_unpack %608 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %610 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %548, %385, %382#96, %564 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %611 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %556, %548, %386, %382#96, %610 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %612 = waveamd.fragment_unpack %611 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %613 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %547, %387, %382#97, %565 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %614 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %547, %388, %382#97, %613 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %615 = waveamd.fragment_unpack %614 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %616 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %547, %387, %382#97, %566 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %617 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %547, %388, %382#97, %616 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %618 = waveamd.fragment_unpack %617 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %619 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %548, %387, %382#97, %567 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %620 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %548, %388, %382#97, %619 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %621 = waveamd.fragment_unpack %620 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %622 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %548, %387, %382#97, %568 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %623 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %556, %548, %388, %382#97, %622 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %624 = waveamd.fragment_unpack %623 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %625 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %547, %389, %382#97, %569 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %626 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %547, %390, %382#97, %625 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %627 = waveamd.fragment_unpack %626 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %628 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %547, %389, %382#97, %570 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %629 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %547, %390, %382#97, %628 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %630 = waveamd.fragment_unpack %629 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %631 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %548, %389, %382#97, %571 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %632 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %548, %390, %382#97, %631 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %633 = waveamd.fragment_unpack %632 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %634 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %548, %389, %382#97, %572 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %635 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %556, %548, %390, %382#97, %634 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %636 = waveamd.fragment_unpack %635 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %637 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %547, %391, %382#98, %573 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %638 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %547, %392, %382#98, %637 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %639 = waveamd.fragment_unpack %638 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %640 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %547, %391, %382#98, %574 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %641 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %547, %392, %382#98, %640 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %642 = waveamd.fragment_unpack %641 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %643 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %548, %391, %382#98, %575 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %644 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %548, %392, %382#98, %643 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %645 = waveamd.fragment_unpack %644 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %646 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %548, %391, %382#98, %576 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %647 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %556, %548, %392, %382#98, %646 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %648 = waveamd.fragment_unpack %647 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %649 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %547, %393, %382#98, %577 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %650 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %547, %394, %382#98, %649 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %651 = waveamd.fragment_unpack %650 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %652 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %547, %393, %382#98, %578 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %653 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %547, %394, %382#98, %652 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %654 = waveamd.fragment_unpack %653 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %655 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %548, %393, %382#98, %579 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %656 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %548, %394, %382#98, %655 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %657 = waveamd.fragment_unpack %656 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %658 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %548, %393, %382#98, %580 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %659 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %556, %548, %394, %382#98, %658 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %660 = waveamd.fragment_unpack %659 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %661 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %547, %395, %382#99, %581 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %662 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %547, %396, %382#99, %661 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %663 = waveamd.fragment_unpack %662 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %664 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %547, %395, %382#99, %582 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %665 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %547, %396, %382#99, %664 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %666 = waveamd.fragment_unpack %665 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %667 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %548, %395, %382#99, %583 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %668 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %548, %396, %382#99, %667 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %669 = waveamd.fragment_unpack %668 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %670 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %548, %395, %382#99, %584 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %671 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %556, %548, %396, %382#99, %670 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %672 = waveamd.fragment_unpack %671 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %673 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %547, %397, %382#99, %585 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %674 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %547, %398, %382#99, %673 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %675 = waveamd.fragment_unpack %674 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %676 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %547, %397, %382#99, %586 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %677 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %547, %398, %382#99, %676 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %678 = waveamd.fragment_unpack %677 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %679 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %548, %397, %382#99, %587 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %680 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %548, %398, %382#99, %679 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %681 = waveamd.fragment_unpack %680 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %682 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %548, %397, %382#99, %588 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %683 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %556, %548, %398, %382#99, %682 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %684 = waveamd.fragment_unpack %683 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %685 = wave.ptr_add %161, %274 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_82, %token_83 = wave.load %685 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %686 = wave.ptr_add %161, %276 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_84, %token_85 = wave.load %686 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %687 = wave.ptr_add %161, %278 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_86, %token_87 = wave.load %687 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %688 = wave.ptr_add %161, %280 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_88, %token_89 = wave.load %688 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %689 = wave.ptr_add %161, %282 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_90, %token_91 = wave.load %689 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %690 = wave.ptr_add %161, %284 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_92, %token_93 = wave.load %690 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %691 = wave.ptr_add %161, %286 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_94, %token_95 = wave.load %691 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %692 = wave.ptr_add %161, %288 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_96, %token_97 = wave.load %692 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %693 = wave.ptr_add %161, %290 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_98, %token_99 = wave.load %693 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %694 = wave.ptr_add %161, %292 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_100, %token_101 = wave.load %694 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %695 = wave.ptr_add %161, %294 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_102, %token_103 = wave.load %695 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %696 = wave.ptr_add %161, %296 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_104, %token_105 = wave.load %696 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %697 = wave.ptr_add %161, %298 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_106, %token_107 = wave.load %697 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %698 = wave.ptr_add %161, %300 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_108, %token_109 = wave.load %698 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %699 = wave.ptr_add %161, %302 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_110, %token_111 = wave.load %699 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %700 = wave.ptr_add %161, %304 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_112, %token_113 = wave.load %700 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %701 = wave.ptr_add %211, %306 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_114, %token_115 = wave.load %701 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %702 = wave.ptr_add %211, %308 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_116, %token_117 = wave.load %702 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %703 = wave.ptr_add %211, %310 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_118, %token_119 = wave.load %703 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %704 = wave.ptr_add %211, %312 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_120, %token_121 = wave.load %704 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %705 = wave.ptr_add %211, %314 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_122, %token_123 = wave.load %705 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %706 = wave.ptr_add %211, %316 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_124, %token_125 = wave.load %706 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %707 = wave.ptr_add %211, %318 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_126, %token_127 = wave.load %707 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %708 = wave.ptr_add %211, %320 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_128, %token_129 = wave.load %708 after %535 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %709 = wave.store %382#69 -> %352 after %377 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %710 = wave.barrier %709 : (!wave.mem.token) -> !wave.mem.token
      %711 = wave.store %382#70 -> %366 after %token_81 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %712 = wave.barrier %711 : (!wave.mem.token) -> !wave.mem.token
      %value_130, %token_131 = waveamd.transpose_load %370 after %710 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %713 = wave.extract %value_130[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %714 = wave.extract %value_130[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %value_132, %token_133 = waveamd.transpose_load %374 after %710 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %715 = wave.extract %value_132[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %716 = wave.extract %value_132[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %value_134, %token_135 = waveamd.transpose_load %379 after %712 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %717 = wave.extract %value_134[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %718 = wave.extract %value_134[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %719 = waveamd.fragment_pack %value_82 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %720 = waveamd.fragment_pack %value_84 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %721 = waveamd.fragment_pack %value_86 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %722 = waveamd.fragment_pack %value_88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %723 = waveamd.fragment_pack %value_90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %724 = waveamd.fragment_pack %value_92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %725 = waveamd.fragment_pack %value_94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %726 = waveamd.fragment_pack %value_96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %727 = waveamd.fragment_pack %value_98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %728 = waveamd.fragment_pack %value_100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %729 = waveamd.fragment_pack %value_102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %730 = waveamd.fragment_pack %value_104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %731 = waveamd.fragment_pack %value_106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %732 = waveamd.fragment_pack %value_108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %733 = waveamd.fragment_pack %value_110 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %734 = waveamd.fragment_pack %value_112 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %735 = waveamd.fragment_pack %value_114 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %736 = waveamd.fragment_pack %value_116 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %737 = waveamd.fragment_pack %value_118 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %738 = waveamd.fragment_pack %value_120 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %739 = waveamd.fragment_pack %value_122 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %740 = waveamd.fragment_pack %value_124 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %741 = waveamd.fragment_pack %value_126 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %742 = waveamd.fragment_pack %value_128 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %743 = waveamd.fragment_pack %441 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %744 = waveamd.fragment_pack %444 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %745 = waveamd.fragment_pack %447 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %746 = waveamd.fragment_pack %450 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %747 = waveamd.fragment_pack %453 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %748 = waveamd.fragment_pack %456 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %749 = waveamd.fragment_pack %459 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %750 = waveamd.fragment_pack %462 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %751 = waveamd.fragment_pack %465 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %752 = waveamd.fragment_pack %468 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %753 = waveamd.fragment_pack %471 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %754 = waveamd.fragment_pack %474 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %755 = waveamd.fragment_pack %477 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %756 = waveamd.fragment_pack %480 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %757 = waveamd.fragment_pack %483 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %758 = waveamd.fragment_pack %486 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %759 = waveamd.fragment_pack %489 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %760 = waveamd.fragment_pack %492 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %761 = waveamd.fragment_pack %495 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %762 = waveamd.fragment_pack %498 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %763 = waveamd.fragment_pack %501 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %764 = waveamd.fragment_pack %504 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %765 = waveamd.fragment_pack %507 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %766 = waveamd.fragment_pack %510 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %767 = waveamd.fragment_pack %513 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %768 = waveamd.fragment_pack %516 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %769 = waveamd.fragment_pack %519 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %770 = waveamd.fragment_pack %522 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %771 = waveamd.fragment_pack %525 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %772 = waveamd.fragment_pack %528 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %773 = waveamd.fragment_pack %531 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %774 = waveamd.fragment_pack %534 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %775 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %735, %717, %719, %713, %743 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %776 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %736, %717, %720, %713, %775 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %777 = waveamd.fragment_unpack %776 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %778 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %737, %717, %719, %713, %744 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %779 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %738, %717, %720, %713, %778 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %780 = waveamd.fragment_unpack %779 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %781 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %739, %718, %719, %713, %745 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %782 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %740, %718, %720, %713, %781 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %783 = waveamd.fragment_unpack %782 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %784 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %741, %718, %719, %713, %746 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %785 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %742, %718, %720, %713, %784 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %786 = waveamd.fragment_unpack %785 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %787 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %735, %717, %721, %713, %747 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %788 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %736, %717, %722, %713, %787 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %789 = waveamd.fragment_unpack %788 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %790 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %737, %717, %721, %713, %748 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %791 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %738, %717, %722, %713, %790 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %792 = waveamd.fragment_unpack %791 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %793 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %739, %718, %721, %713, %749 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %794 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %740, %718, %722, %713, %793 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %795 = waveamd.fragment_unpack %794 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %796 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %741, %718, %721, %713, %750 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %797 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %742, %718, %722, %713, %796 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %798 = waveamd.fragment_unpack %797 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %799 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %735, %717, %723, %714, %751 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %800 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %736, %717, %724, %714, %799 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %801 = waveamd.fragment_unpack %800 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %802 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %737, %717, %723, %714, %752 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %803 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %738, %717, %724, %714, %802 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %804 = waveamd.fragment_unpack %803 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %805 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %739, %718, %723, %714, %753 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %806 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %740, %718, %724, %714, %805 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %807 = waveamd.fragment_unpack %806 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %808 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %741, %718, %723, %714, %754 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %809 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %742, %718, %724, %714, %808 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %810 = waveamd.fragment_unpack %809 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %811 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %735, %717, %725, %714, %755 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %812 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %736, %717, %726, %714, %811 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %813 = waveamd.fragment_unpack %812 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %814 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %737, %717, %725, %714, %756 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %815 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %738, %717, %726, %714, %814 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %816 = waveamd.fragment_unpack %815 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %817 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %739, %718, %725, %714, %757 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %818 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %740, %718, %726, %714, %817 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %819 = waveamd.fragment_unpack %818 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %820 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %741, %718, %725, %714, %758 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %821 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %742, %718, %726, %714, %820 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %822 = waveamd.fragment_unpack %821 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %823 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %735, %717, %727, %715, %759 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %824 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %736, %717, %728, %715, %823 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %825 = waveamd.fragment_unpack %824 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %826 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %737, %717, %727, %715, %760 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %827 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %738, %717, %728, %715, %826 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %828 = waveamd.fragment_unpack %827 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %829 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %739, %718, %727, %715, %761 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %830 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %740, %718, %728, %715, %829 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %831 = waveamd.fragment_unpack %830 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %832 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %741, %718, %727, %715, %762 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %833 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %742, %718, %728, %715, %832 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %834 = waveamd.fragment_unpack %833 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %835 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %735, %717, %729, %715, %763 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %836 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %736, %717, %730, %715, %835 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %837 = waveamd.fragment_unpack %836 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %838 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %737, %717, %729, %715, %764 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %839 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %738, %717, %730, %715, %838 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %840 = waveamd.fragment_unpack %839 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %841 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %739, %718, %729, %715, %765 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %842 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %740, %718, %730, %715, %841 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %843 = waveamd.fragment_unpack %842 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %844 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %741, %718, %729, %715, %766 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %845 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %742, %718, %730, %715, %844 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %846 = waveamd.fragment_unpack %845 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %847 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %735, %717, %731, %716, %767 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %848 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %736, %717, %732, %716, %847 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %849 = waveamd.fragment_unpack %848 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %850 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %737, %717, %731, %716, %768 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %851 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %738, %717, %732, %716, %850 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %852 = waveamd.fragment_unpack %851 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %853 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %739, %718, %731, %716, %769 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %854 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %740, %718, %732, %716, %853 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %855 = waveamd.fragment_unpack %854 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %856 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %741, %718, %731, %716, %770 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %857 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %742, %718, %732, %716, %856 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %858 = waveamd.fragment_unpack %857 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %859 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %735, %717, %733, %716, %771 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %860 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %736, %717, %734, %716, %859 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %861 = waveamd.fragment_unpack %860 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %862 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %737, %717, %733, %716, %772 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %863 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %738, %717, %734, %716, %862 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %864 = waveamd.fragment_unpack %863 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %865 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %739, %718, %733, %716, %773 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %866 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %740, %718, %734, %716, %865 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %867 = waveamd.fragment_unpack %866 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %868 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %741, %718, %733, %716, %774 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %869 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %742, %718, %734, %716, %868 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %870 = waveamd.fragment_unpack %869 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %871 = wave.ptr_add %244, %306 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_136, %token_137 = wave.load %871 after %544 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %872 = wave.ptr_add %244, %308 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_138, %token_139 = wave.load %872 after %544 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %873 = wave.ptr_add %244, %310 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_140, %token_141 = wave.load %873 after %544 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %874 = wave.ptr_add %244, %312 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_142, %token_143 = wave.load %874 after %544 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %875 = wave.ptr_add %244, %314 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_144, %token_145 = wave.load %875 after %544 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %876 = wave.ptr_add %244, %316 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_146, %token_147 = wave.load %876 after %544 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %877 = wave.ptr_add %244, %318 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_148, %token_149 = wave.load %877 after %544 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %878 = wave.ptr_add %244, %320 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_150, %token_151 = wave.load %878 after %544 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %879 = wave.store %382#71 -> %366 after %token_135 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %880 = wave.barrier %879 : (!wave.mem.token) -> !wave.mem.token
      %value_152, %token_153 = waveamd.transpose_load %379 after %880 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %881 = wave.extract %value_152[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %882 = wave.extract %value_152[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %883 = wave.binary muli %39, %arg9 : i32, i32 -> i32
      %884 = wave.cast fpconvert %777 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %885 = wave.cast fpconvert %780 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %886 = wave.cast fpconvert %783 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %887 = wave.cast fpconvert %786 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %888 = wave.cast fpconvert %789 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %889 = wave.cast fpconvert %792 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %890 = wave.cast fpconvert %795 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %891 = wave.cast fpconvert %798 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %892 = wave.cast fpconvert %801 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %893 = wave.cast fpconvert %804 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %894 = wave.cast fpconvert %807 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %895 = wave.cast fpconvert %810 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %896 = wave.cast fpconvert %813 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %897 = wave.cast fpconvert %816 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %898 = wave.cast fpconvert %819 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %899 = wave.cast fpconvert %822 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %900 = wave.cast fpconvert %825 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %901 = wave.cast fpconvert %828 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %902 = wave.cast fpconvert %831 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %903 = wave.cast fpconvert %834 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %904 = wave.cast fpconvert %837 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %905 = wave.cast fpconvert %840 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %906 = wave.cast fpconvert %843 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %907 = wave.cast fpconvert %846 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %908 = wave.cast fpconvert %849 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %909 = wave.cast fpconvert %852 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %910 = wave.cast fpconvert %855 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %911 = wave.cast fpconvert %858 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %912 = wave.cast fpconvert %861 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %913 = wave.cast fpconvert %864 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %914 = wave.cast fpconvert %867 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %915 = wave.cast fpconvert %870 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %916 = wave.alloc() {align = 16 : i64, bytesize = 16384 : i64} : !wave.ptr<#wave.shared, bf16>
      %917 = wave.binary muli %49, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %918 = wave.ptr_add %916, %917 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %919 = wave.extract %884[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %920 = wave.extract %884[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %921 = wave.extract %884[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %922 = wave.extract %884[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %923 = wave.extract %888[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %924 = wave.extract %888[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %925 = wave.extract %888[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %926 = wave.extract %888[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %927 = wave.pack %919, %920, %921, %922, %923, %924, %925, %926 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %928 = wave.store %927 -> %918 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %929 = wave.binary addi %917, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %930 = wave.ptr_add %916, %929 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %931 = wave.extract %885[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %932 = wave.extract %885[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %933 = wave.extract %885[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %934 = wave.extract %885[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %935 = wave.extract %889[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %936 = wave.extract %889[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %937 = wave.extract %889[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %938 = wave.extract %889[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %939 = wave.pack %931, %932, %933, %934, %935, %936, %937, %938 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %940 = wave.store %939 -> %930 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %941 = wave.binary addi %917, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %942 = wave.ptr_add %916, %941 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %943 = wave.extract %886[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %944 = wave.extract %886[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %945 = wave.extract %886[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %946 = wave.extract %886[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %947 = wave.extract %890[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %948 = wave.extract %890[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %949 = wave.extract %890[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %950 = wave.extract %890[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %951 = wave.pack %943, %944, %945, %946, %947, %948, %949, %950 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %952 = wave.store %951 -> %942 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %953 = wave.binary addi %917, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %954 = wave.ptr_add %916, %953 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %955 = wave.extract %887[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %956 = wave.extract %887[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %957 = wave.extract %887[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %958 = wave.extract %887[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %959 = wave.extract %891[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %960 = wave.extract %891[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %961 = wave.extract %891[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %962 = wave.extract %891[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %963 = wave.pack %955, %956, %957, %958, %959, %960, %961, %962 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %964 = wave.store %963 -> %954 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %965 = wave.barrier %928, %940, %952, %964 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %966 = wave.index_expr <"8*(32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %967 = wave.ptr_add %916, %966 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_154, %token_155 = wave.load %967 after %965 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %968 = wave.extract %value_154[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %969 = wave.extract %value_154[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %970 = wave.extract %value_154[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %971 = wave.extract %value_154[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %972 = wave.extract %value_154[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %973 = wave.extract %value_154[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %974 = wave.extract %value_154[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %975 = wave.extract %value_154[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %976 = wave.index_expr <"8*(16 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %977 = wave.ptr_add %916, %976 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_156, %token_157 = wave.load %977 after %965 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %978 = wave.extract %value_156[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %979 = wave.extract %value_156[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %980 = wave.extract %value_156[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %981 = wave.extract %value_156[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %982 = wave.extract %value_156[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %983 = wave.extract %value_156[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %984 = wave.extract %value_156[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %985 = wave.extract %value_156[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %986 = wave.index_expr <"8*(128 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %987 = wave.ptr_add %916, %986 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_158, %token_159 = wave.load %987 after %965 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %988 = wave.extract %value_158[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %989 = wave.extract %value_158[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %990 = wave.extract %value_158[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %991 = wave.extract %value_158[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %992 = wave.extract %value_158[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %993 = wave.extract %value_158[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %994 = wave.extract %value_158[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %995 = wave.extract %value_158[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %996 = wave.index_expr <"8*(144 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %997 = wave.ptr_add %916, %996 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_160, %token_161 = wave.load %997 after %965 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %998 = wave.extract %value_160[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %999 = wave.extract %value_160[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1000 = wave.extract %value_160[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1001 = wave.extract %value_160[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1002 = wave.extract %value_160[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1003 = wave.extract %value_160[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1004 = wave.extract %value_160[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1005 = wave.extract %value_160[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1006 = wave.barrier %token_155, %token_157, %token_159, %token_161 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1007 = wave.extract %892[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1008 = wave.extract %892[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1009 = wave.extract %892[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1010 = wave.extract %892[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1011 = wave.extract %896[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1012 = wave.extract %896[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1013 = wave.extract %896[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1014 = wave.extract %896[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1015 = wave.pack %1007, %1008, %1009, %1010, %1011, %1012, %1013, %1014 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1016 = wave.store %1015 -> %918 after %1006 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1017 = wave.extract %893[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1018 = wave.extract %893[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1019 = wave.extract %893[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1020 = wave.extract %893[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1021 = wave.extract %897[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1022 = wave.extract %897[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1023 = wave.extract %897[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1024 = wave.extract %897[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1025 = wave.pack %1017, %1018, %1019, %1020, %1021, %1022, %1023, %1024 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1026 = wave.store %1025 -> %930 after %1006 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1027 = wave.extract %894[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1028 = wave.extract %894[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1029 = wave.extract %894[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1030 = wave.extract %894[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1031 = wave.extract %898[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1032 = wave.extract %898[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1033 = wave.extract %898[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1034 = wave.extract %898[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1035 = wave.pack %1027, %1028, %1029, %1030, %1031, %1032, %1033, %1034 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1036 = wave.store %1035 -> %942 after %1006 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1037 = wave.extract %895[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1038 = wave.extract %895[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1039 = wave.extract %895[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1040 = wave.extract %895[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1041 = wave.extract %899[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1042 = wave.extract %899[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1043 = wave.extract %899[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1044 = wave.extract %899[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1045 = wave.pack %1037, %1038, %1039, %1040, %1041, %1042, %1043, %1044 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1046 = wave.store %1045 -> %954 after %1006 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1047 = wave.barrier %1016, %1026, %1036, %1046 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_162, %token_163 = wave.load %967 after %1047 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1048 = wave.extract %value_162[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1049 = wave.extract %value_162[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1050 = wave.extract %value_162[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1051 = wave.extract %value_162[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1052 = wave.extract %value_162[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1053 = wave.extract %value_162[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1054 = wave.extract %value_162[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1055 = wave.extract %value_162[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_164, %token_165 = wave.load %977 after %1047 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1056 = wave.extract %value_164[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1057 = wave.extract %value_164[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1058 = wave.extract %value_164[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1059 = wave.extract %value_164[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1060 = wave.extract %value_164[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1061 = wave.extract %value_164[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1062 = wave.extract %value_164[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1063 = wave.extract %value_164[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_166, %token_167 = wave.load %987 after %1047 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1064 = wave.extract %value_166[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1065 = wave.extract %value_166[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1066 = wave.extract %value_166[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1067 = wave.extract %value_166[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1068 = wave.extract %value_166[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1069 = wave.extract %value_166[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1070 = wave.extract %value_166[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1071 = wave.extract %value_166[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_168, %token_169 = wave.load %997 after %1047 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1072 = wave.extract %value_168[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1073 = wave.extract %value_168[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1074 = wave.extract %value_168[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1075 = wave.extract %value_168[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1076 = wave.extract %value_168[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1077 = wave.extract %value_168[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1078 = wave.extract %value_168[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1079 = wave.extract %value_168[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1080 = wave.barrier %token_163, %token_165, %token_167, %token_169 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1081 = wave.extract %900[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1082 = wave.extract %900[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1083 = wave.extract %900[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1084 = wave.extract %900[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1085 = wave.extract %904[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1086 = wave.extract %904[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1087 = wave.extract %904[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1088 = wave.extract %904[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1089 = wave.pack %1081, %1082, %1083, %1084, %1085, %1086, %1087, %1088 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1090 = wave.store %1089 -> %918 after %1080 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1091 = wave.extract %901[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1092 = wave.extract %901[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1093 = wave.extract %901[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1094 = wave.extract %901[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1095 = wave.extract %905[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1096 = wave.extract %905[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1097 = wave.extract %905[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1098 = wave.extract %905[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1099 = wave.pack %1091, %1092, %1093, %1094, %1095, %1096, %1097, %1098 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1100 = wave.store %1099 -> %930 after %1080 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1101 = wave.extract %902[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1102 = wave.extract %902[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1103 = wave.extract %902[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1104 = wave.extract %902[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1105 = wave.extract %906[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1106 = wave.extract %906[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1107 = wave.extract %906[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1108 = wave.extract %906[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1109 = wave.pack %1101, %1102, %1103, %1104, %1105, %1106, %1107, %1108 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1110 = wave.store %1109 -> %942 after %1080 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1111 = wave.extract %903[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1112 = wave.extract %903[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1113 = wave.extract %903[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1114 = wave.extract %903[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1115 = wave.extract %907[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1116 = wave.extract %907[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1117 = wave.extract %907[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1118 = wave.extract %907[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1119 = wave.pack %1111, %1112, %1113, %1114, %1115, %1116, %1117, %1118 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1120 = wave.store %1119 -> %954 after %1080 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1121 = wave.barrier %1090, %1100, %1110, %1120 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_170, %token_171 = wave.load %967 after %1121 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1122 = wave.extract %value_170[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1123 = wave.extract %value_170[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1124 = wave.extract %value_170[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1125 = wave.extract %value_170[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1126 = wave.extract %value_170[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1127 = wave.extract %value_170[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1128 = wave.extract %value_170[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1129 = wave.extract %value_170[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_172, %token_173 = wave.load %977 after %1121 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1130 = wave.extract %value_172[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1131 = wave.extract %value_172[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1132 = wave.extract %value_172[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1133 = wave.extract %value_172[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1134 = wave.extract %value_172[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1135 = wave.extract %value_172[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1136 = wave.extract %value_172[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1137 = wave.extract %value_172[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_174, %token_175 = wave.load %987 after %1121 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1138 = wave.extract %value_174[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1139 = wave.extract %value_174[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1140 = wave.extract %value_174[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1141 = wave.extract %value_174[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1142 = wave.extract %value_174[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1143 = wave.extract %value_174[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1144 = wave.extract %value_174[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1145 = wave.extract %value_174[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_176, %token_177 = wave.load %997 after %1121 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1146 = wave.extract %value_176[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1147 = wave.extract %value_176[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1148 = wave.extract %value_176[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1149 = wave.extract %value_176[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1150 = wave.extract %value_176[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1151 = wave.extract %value_176[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1152 = wave.extract %value_176[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1153 = wave.extract %value_176[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1154 = wave.barrier %token_171, %token_173, %token_175, %token_177 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1155 = wave.extract %908[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1156 = wave.extract %908[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1157 = wave.extract %908[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1158 = wave.extract %908[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1159 = wave.extract %912[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1160 = wave.extract %912[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1161 = wave.extract %912[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1162 = wave.extract %912[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1163 = wave.pack %1155, %1156, %1157, %1158, %1159, %1160, %1161, %1162 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1164 = wave.store %1163 -> %918 after %1154 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1165 = wave.extract %909[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1166 = wave.extract %909[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1167 = wave.extract %909[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1168 = wave.extract %909[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1169 = wave.extract %913[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1170 = wave.extract %913[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1171 = wave.extract %913[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1172 = wave.extract %913[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1173 = wave.pack %1165, %1166, %1167, %1168, %1169, %1170, %1171, %1172 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1174 = wave.store %1173 -> %930 after %1154 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1175 = wave.extract %910[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1176 = wave.extract %910[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1177 = wave.extract %910[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1178 = wave.extract %910[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1179 = wave.extract %914[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1180 = wave.extract %914[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1181 = wave.extract %914[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1182 = wave.extract %914[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1183 = wave.pack %1175, %1176, %1177, %1178, %1179, %1180, %1181, %1182 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1184 = wave.store %1183 -> %942 after %1154 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1185 = wave.extract %911[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1186 = wave.extract %911[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1187 = wave.extract %911[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1188 = wave.extract %911[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1189 = wave.extract %915[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1190 = wave.extract %915[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1191 = wave.extract %915[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1192 = wave.extract %915[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1193 = wave.pack %1185, %1186, %1187, %1188, %1189, %1190, %1191, %1192 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1194 = wave.store %1193 -> %954 after %1154 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1195 = wave.barrier %1164, %1174, %1184, %1194 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_178, %token_179 = wave.load %967 after %1195 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1196 = wave.extract %value_178[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1197 = wave.extract %value_178[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1198 = wave.extract %value_178[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1199 = wave.extract %value_178[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1200 = wave.extract %value_178[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1201 = wave.extract %value_178[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1202 = wave.extract %value_178[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1203 = wave.extract %value_178[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_180, %token_181 = wave.load %977 after %1195 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1204 = wave.extract %value_180[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1205 = wave.extract %value_180[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1206 = wave.extract %value_180[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1207 = wave.extract %value_180[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1208 = wave.extract %value_180[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1209 = wave.extract %value_180[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1210 = wave.extract %value_180[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1211 = wave.extract %value_180[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_182, %token_183 = wave.load %987 after %1195 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1212 = wave.extract %value_182[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1213 = wave.extract %value_182[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1214 = wave.extract %value_182[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1215 = wave.extract %value_182[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1216 = wave.extract %value_182[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1217 = wave.extract %value_182[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1218 = wave.extract %value_182[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1219 = wave.extract %value_182[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_184, %token_185 = wave.load %997 after %1195 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1220 = wave.extract %value_184[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1221 = wave.extract %value_184[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1222 = wave.extract %value_184[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1223 = wave.extract %value_184[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1224 = wave.extract %value_184[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1225 = wave.extract %value_184[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1226 = wave.extract %value_184[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1227 = wave.extract %value_184[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1228 = wave.barrier %token_179, %token_181, %token_183, %token_185 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1229 = wave.ptr_add %arg2, %883 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#wave.global, bf16>
      %1230 = waveamd.make_buffer %1229, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %1231 = wave.pack %968, %969, %970, %971, %978, %979, %980, %981 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1232 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1233 = wave.assume %1232 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1234 = wave.ptr_add %1230, %1233 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1235 = wave.store %1231 -> %1234 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1236 = wave.pack %988, %989, %990, %991, %998, %999, %1000, %1001 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1237 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1238 = wave.assume %1237 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1239 = wave.ptr_add %1230, %1238 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1240 = wave.store %1236 -> %1239 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1241 = wave.pack %972, %973, %974, %975, %982, %983, %984, %985 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1242 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1243 = wave.assume %1242 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1244 = wave.ptr_add %1230, %1243 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1245 = wave.store %1241 -> %1244 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1246 = wave.pack %992, %993, %994, %995, %1002, %1003, %1004, %1005 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1247 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1248 = wave.assume %1247 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1249 = wave.ptr_add %1230, %1248 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1250 = wave.store %1246 -> %1249 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1251 = wave.pack %1048, %1049, %1050, %1051, %1056, %1057, %1058, %1059 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1252 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1253 = wave.assume %1252 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1254 = wave.ptr_add %1230, %1253 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1255 = wave.store %1251 -> %1254 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1256 = wave.pack %1064, %1065, %1066, %1067, %1072, %1073, %1074, %1075 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1257 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1258 = wave.assume %1257 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1259 = wave.ptr_add %1230, %1258 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1260 = wave.store %1256 -> %1259 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1261 = wave.pack %1052, %1053, %1054, %1055, %1060, %1061, %1062, %1063 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1262 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1263 = wave.assume %1262 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1264 = wave.ptr_add %1230, %1263 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1265 = wave.store %1261 -> %1264 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1266 = wave.pack %1068, %1069, %1070, %1071, %1076, %1077, %1078, %1079 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1267 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1268 = wave.assume %1267 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1269 = wave.ptr_add %1230, %1268 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1270 = wave.store %1266 -> %1269 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1271 = wave.pack %1122, %1123, %1124, %1125, %1130, %1131, %1132, %1133 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1272 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1273 = wave.assume %1272 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1274 = wave.ptr_add %1230, %1273 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1275 = wave.store %1271 -> %1274 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1276 = wave.pack %1138, %1139, %1140, %1141, %1146, %1147, %1148, %1149 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1277 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1278 = wave.assume %1277 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1279 = wave.ptr_add %1230, %1278 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1280 = wave.store %1276 -> %1279 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1281 = wave.pack %1126, %1127, %1128, %1129, %1134, %1135, %1136, %1137 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1282 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1283 = wave.assume %1282 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1284 = wave.ptr_add %1230, %1283 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1285 = wave.store %1281 -> %1284 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1286 = wave.pack %1142, %1143, %1144, %1145, %1150, %1151, %1152, %1153 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1287 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1288 = wave.assume %1287 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1289 = wave.ptr_add %1230, %1288 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1290 = wave.store %1286 -> %1289 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1291 = wave.pack %1196, %1197, %1198, %1199, %1204, %1205, %1206, %1207 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1292 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1293 = wave.assume %1292 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1294 = wave.ptr_add %1230, %1293 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1295 = wave.store %1291 -> %1294 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1296 = wave.pack %1212, %1213, %1214, %1215, %1220, %1221, %1222, %1223 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1297 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1298 = wave.assume %1297 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1299 = wave.ptr_add %1230, %1298 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1300 = wave.store %1296 -> %1299 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1301 = wave.pack %1200, %1201, %1202, %1203, %1208, %1209, %1210, %1211 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1302 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1303 = wave.assume %1302 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1304 = wave.ptr_add %1230, %1303 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1305 = wave.store %1301 -> %1304 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1306 = wave.pack %1216, %1217, %1218, %1219, %1224, %1225, %1226, %1227 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1307 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1308 = wave.assume %1307 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1309 = wave.ptr_add %1230, %1308 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1310 = wave.store %1306 -> %1309 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1311 = waveamd.fragment_pack %value_136 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1312 = waveamd.fragment_pack %value_138 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1313 = waveamd.fragment_pack %value_140 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1314 = waveamd.fragment_pack %value_142 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1315 = waveamd.fragment_pack %value_144 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1316 = waveamd.fragment_pack %value_146 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1317 = waveamd.fragment_pack %value_148 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1318 = waveamd.fragment_pack %value_150 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1319 = waveamd.fragment_pack %591 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1320 = waveamd.fragment_pack %594 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1321 = waveamd.fragment_pack %597 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1322 = waveamd.fragment_pack %600 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1323 = waveamd.fragment_pack %603 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1324 = waveamd.fragment_pack %606 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1325 = waveamd.fragment_pack %609 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1326 = waveamd.fragment_pack %612 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1327 = waveamd.fragment_pack %615 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1328 = waveamd.fragment_pack %618 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1329 = waveamd.fragment_pack %621 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1330 = waveamd.fragment_pack %624 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1331 = waveamd.fragment_pack %627 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1332 = waveamd.fragment_pack %630 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1333 = waveamd.fragment_pack %633 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1334 = waveamd.fragment_pack %636 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1335 = waveamd.fragment_pack %639 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1336 = waveamd.fragment_pack %642 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1337 = waveamd.fragment_pack %645 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1338 = waveamd.fragment_pack %648 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1339 = waveamd.fragment_pack %651 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1340 = waveamd.fragment_pack %654 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1341 = waveamd.fragment_pack %657 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1342 = waveamd.fragment_pack %660 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1343 = waveamd.fragment_pack %663 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1344 = waveamd.fragment_pack %666 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1345 = waveamd.fragment_pack %669 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1346 = waveamd.fragment_pack %672 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1347 = waveamd.fragment_pack %675 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1348 = waveamd.fragment_pack %678 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1349 = waveamd.fragment_pack %681 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1350 = waveamd.fragment_pack %684 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1351 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1311, %881, %719, %713, %1319 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1352 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1312, %881, %720, %713, %1351 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1353 = waveamd.fragment_unpack %1352 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1354 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1313, %881, %719, %713, %1320 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1355 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1314, %881, %720, %713, %1354 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1356 = waveamd.fragment_unpack %1355 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1357 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1315, %882, %719, %713, %1321 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1358 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1316, %882, %720, %713, %1357 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1359 = waveamd.fragment_unpack %1358 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1360 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1317, %882, %719, %713, %1322 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1361 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1318, %882, %720, %713, %1360 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1362 = waveamd.fragment_unpack %1361 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1363 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1311, %881, %721, %713, %1323 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1364 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1312, %881, %722, %713, %1363 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1365 = waveamd.fragment_unpack %1364 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1366 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1313, %881, %721, %713, %1324 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1367 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1314, %881, %722, %713, %1366 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1368 = waveamd.fragment_unpack %1367 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1369 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1315, %882, %721, %713, %1325 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1370 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1316, %882, %722, %713, %1369 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1371 = waveamd.fragment_unpack %1370 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1372 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1317, %882, %721, %713, %1326 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1373 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1318, %882, %722, %713, %1372 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1374 = waveamd.fragment_unpack %1373 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1375 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1311, %881, %723, %714, %1327 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1376 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1312, %881, %724, %714, %1375 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1377 = waveamd.fragment_unpack %1376 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1378 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1313, %881, %723, %714, %1328 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1379 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1314, %881, %724, %714, %1378 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1380 = waveamd.fragment_unpack %1379 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1381 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1315, %882, %723, %714, %1329 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1382 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1316, %882, %724, %714, %1381 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1383 = waveamd.fragment_unpack %1382 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1384 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1317, %882, %723, %714, %1330 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1385 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1318, %882, %724, %714, %1384 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1386 = waveamd.fragment_unpack %1385 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1387 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1311, %881, %725, %714, %1331 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1388 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1312, %881, %726, %714, %1387 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1389 = waveamd.fragment_unpack %1388 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1390 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1313, %881, %725, %714, %1332 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1391 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1314, %881, %726, %714, %1390 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1392 = waveamd.fragment_unpack %1391 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1393 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1315, %882, %725, %714, %1333 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1394 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1316, %882, %726, %714, %1393 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1395 = waveamd.fragment_unpack %1394 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1396 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1317, %882, %725, %714, %1334 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1397 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1318, %882, %726, %714, %1396 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1398 = waveamd.fragment_unpack %1397 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1399 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1311, %881, %727, %715, %1335 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1400 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1312, %881, %728, %715, %1399 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1401 = waveamd.fragment_unpack %1400 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1402 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1313, %881, %727, %715, %1336 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1403 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1314, %881, %728, %715, %1402 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1404 = waveamd.fragment_unpack %1403 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1405 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1315, %882, %727, %715, %1337 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1406 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1316, %882, %728, %715, %1405 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1407 = waveamd.fragment_unpack %1406 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1408 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1317, %882, %727, %715, %1338 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1409 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1318, %882, %728, %715, %1408 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1410 = waveamd.fragment_unpack %1409 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1411 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1311, %881, %729, %715, %1339 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1412 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1312, %881, %730, %715, %1411 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1413 = waveamd.fragment_unpack %1412 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1414 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1313, %881, %729, %715, %1340 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1415 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1314, %881, %730, %715, %1414 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1416 = waveamd.fragment_unpack %1415 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1417 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1315, %882, %729, %715, %1341 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1418 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1316, %882, %730, %715, %1417 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1419 = waveamd.fragment_unpack %1418 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1420 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1317, %882, %729, %715, %1342 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1421 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1318, %882, %730, %715, %1420 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1422 = waveamd.fragment_unpack %1421 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1423 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1311, %881, %731, %716, %1343 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1424 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1312, %881, %732, %716, %1423 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1425 = waveamd.fragment_unpack %1424 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1426 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1313, %881, %731, %716, %1344 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1427 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1314, %881, %732, %716, %1426 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1428 = waveamd.fragment_unpack %1427 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1429 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1315, %882, %731, %716, %1345 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1430 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1316, %882, %732, %716, %1429 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1431 = waveamd.fragment_unpack %1430 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1432 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1317, %882, %731, %716, %1346 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1433 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1318, %882, %732, %716, %1432 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1434 = waveamd.fragment_unpack %1433 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1435 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1311, %881, %733, %716, %1347 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1436 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1312, %881, %734, %716, %1435 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1437 = waveamd.fragment_unpack %1436 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1438 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1313, %881, %733, %716, %1348 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1439 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1314, %881, %734, %716, %1438 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1440 = waveamd.fragment_unpack %1439 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1441 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1315, %882, %733, %716, %1349 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1442 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1316, %882, %734, %716, %1441 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1443 = waveamd.fragment_unpack %1442 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1444 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1317, %882, %733, %716, %1350 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1445 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1318, %882, %734, %716, %1444 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1446 = waveamd.fragment_unpack %1445 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1447 = wave.cast fpconvert %1353 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1448 = wave.cast fpconvert %1356 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1449 = wave.cast fpconvert %1359 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1450 = wave.cast fpconvert %1362 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1451 = wave.cast fpconvert %1365 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1452 = wave.cast fpconvert %1368 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1453 = wave.cast fpconvert %1371 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1454 = wave.cast fpconvert %1374 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1455 = wave.cast fpconvert %1377 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1456 = wave.cast fpconvert %1380 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1457 = wave.cast fpconvert %1383 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1458 = wave.cast fpconvert %1386 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1459 = wave.cast fpconvert %1389 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1460 = wave.cast fpconvert %1392 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1461 = wave.cast fpconvert %1395 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1462 = wave.cast fpconvert %1398 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1463 = wave.cast fpconvert %1401 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1464 = wave.cast fpconvert %1404 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1465 = wave.cast fpconvert %1407 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1466 = wave.cast fpconvert %1410 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1467 = wave.cast fpconvert %1413 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1468 = wave.cast fpconvert %1416 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1469 = wave.cast fpconvert %1419 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1470 = wave.cast fpconvert %1422 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1471 = wave.cast fpconvert %1425 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1472 = wave.cast fpconvert %1428 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1473 = wave.cast fpconvert %1431 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1474 = wave.cast fpconvert %1434 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1475 = wave.cast fpconvert %1437 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1476 = wave.cast fpconvert %1440 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1477 = wave.cast fpconvert %1443 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1478 = wave.cast fpconvert %1446 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1479 = wave.alloc() {align = 16 : i64, bytesize = 16384 : i64} : !wave.ptr<#wave.shared, bf16>
      %1480 = wave.ptr_add %1479, %917 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1481 = wave.extract %1447[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1482 = wave.extract %1447[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1483 = wave.extract %1447[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1484 = wave.extract %1447[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1485 = wave.extract %1451[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1486 = wave.extract %1451[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1487 = wave.extract %1451[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1488 = wave.extract %1451[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1489 = wave.pack %1481, %1482, %1483, %1484, %1485, %1486, %1487, %1488 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1490 = wave.store %1489 -> %1480 after %1228 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1491 = wave.ptr_add %1479, %929 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1492 = wave.extract %1448[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1493 = wave.extract %1448[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1494 = wave.extract %1448[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1495 = wave.extract %1448[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1496 = wave.extract %1452[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1497 = wave.extract %1452[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1498 = wave.extract %1452[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1499 = wave.extract %1452[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1500 = wave.pack %1492, %1493, %1494, %1495, %1496, %1497, %1498, %1499 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1501 = wave.store %1500 -> %1491 after %1228 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1502 = wave.ptr_add %1479, %941 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1503 = wave.extract %1449[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1504 = wave.extract %1449[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1505 = wave.extract %1449[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1506 = wave.extract %1449[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1507 = wave.extract %1453[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1508 = wave.extract %1453[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1509 = wave.extract %1453[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1510 = wave.extract %1453[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1511 = wave.pack %1503, %1504, %1505, %1506, %1507, %1508, %1509, %1510 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1512 = wave.store %1511 -> %1502 after %1228 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1513 = wave.ptr_add %1479, %953 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1514 = wave.extract %1450[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1515 = wave.extract %1450[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1516 = wave.extract %1450[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1517 = wave.extract %1450[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1518 = wave.extract %1454[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1519 = wave.extract %1454[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1520 = wave.extract %1454[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1521 = wave.extract %1454[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1522 = wave.pack %1514, %1515, %1516, %1517, %1518, %1519, %1520, %1521 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1523 = wave.store %1522 -> %1513 after %1228 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1524 = wave.barrier %1490, %1501, %1512, %1523 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1525 = wave.ptr_add %1479, %966 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_186, %token_187 = wave.load %1525 after %1524 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1526 = wave.extract %value_186[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1527 = wave.extract %value_186[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1528 = wave.extract %value_186[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1529 = wave.extract %value_186[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1530 = wave.extract %value_186[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1531 = wave.extract %value_186[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1532 = wave.extract %value_186[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1533 = wave.extract %value_186[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1534 = wave.ptr_add %1479, %976 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_188, %token_189 = wave.load %1534 after %1524 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1535 = wave.extract %value_188[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1536 = wave.extract %value_188[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1537 = wave.extract %value_188[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1538 = wave.extract %value_188[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1539 = wave.extract %value_188[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1540 = wave.extract %value_188[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1541 = wave.extract %value_188[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1542 = wave.extract %value_188[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1543 = wave.ptr_add %1479, %986 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_190, %token_191 = wave.load %1543 after %1524 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1544 = wave.extract %value_190[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1545 = wave.extract %value_190[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1546 = wave.extract %value_190[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1547 = wave.extract %value_190[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1548 = wave.extract %value_190[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1549 = wave.extract %value_190[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1550 = wave.extract %value_190[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1551 = wave.extract %value_190[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1552 = wave.ptr_add %1479, %996 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_192, %token_193 = wave.load %1552 after %1524 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1553 = wave.extract %value_192[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1554 = wave.extract %value_192[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1555 = wave.extract %value_192[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1556 = wave.extract %value_192[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1557 = wave.extract %value_192[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1558 = wave.extract %value_192[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1559 = wave.extract %value_192[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1560 = wave.extract %value_192[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1561 = wave.barrier %token_187, %token_189, %token_191, %token_193 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1562 = wave.extract %1455[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1563 = wave.extract %1455[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1564 = wave.extract %1455[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1565 = wave.extract %1455[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1566 = wave.extract %1459[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1567 = wave.extract %1459[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1568 = wave.extract %1459[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1569 = wave.extract %1459[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1570 = wave.pack %1562, %1563, %1564, %1565, %1566, %1567, %1568, %1569 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1571 = wave.store %1570 -> %1480 after %1561 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1572 = wave.extract %1456[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1573 = wave.extract %1456[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1574 = wave.extract %1456[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1575 = wave.extract %1456[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1576 = wave.extract %1460[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1577 = wave.extract %1460[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1578 = wave.extract %1460[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1579 = wave.extract %1460[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1580 = wave.pack %1572, %1573, %1574, %1575, %1576, %1577, %1578, %1579 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1581 = wave.store %1580 -> %1491 after %1561 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1582 = wave.extract %1457[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1583 = wave.extract %1457[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1584 = wave.extract %1457[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1585 = wave.extract %1457[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1586 = wave.extract %1461[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1587 = wave.extract %1461[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1588 = wave.extract %1461[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1589 = wave.extract %1461[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1590 = wave.pack %1582, %1583, %1584, %1585, %1586, %1587, %1588, %1589 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1591 = wave.store %1590 -> %1502 after %1561 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1592 = wave.extract %1458[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1593 = wave.extract %1458[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1594 = wave.extract %1458[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1595 = wave.extract %1458[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1596 = wave.extract %1462[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1597 = wave.extract %1462[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1598 = wave.extract %1462[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1599 = wave.extract %1462[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1600 = wave.pack %1592, %1593, %1594, %1595, %1596, %1597, %1598, %1599 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1601 = wave.store %1600 -> %1513 after %1561 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1602 = wave.barrier %1571, %1581, %1591, %1601 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_194, %token_195 = wave.load %1525 after %1602 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1603 = wave.extract %value_194[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1604 = wave.extract %value_194[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1605 = wave.extract %value_194[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1606 = wave.extract %value_194[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1607 = wave.extract %value_194[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1608 = wave.extract %value_194[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1609 = wave.extract %value_194[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1610 = wave.extract %value_194[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_196, %token_197 = wave.load %1534 after %1602 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1611 = wave.extract %value_196[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1612 = wave.extract %value_196[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1613 = wave.extract %value_196[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1614 = wave.extract %value_196[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1615 = wave.extract %value_196[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1616 = wave.extract %value_196[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1617 = wave.extract %value_196[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1618 = wave.extract %value_196[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_198, %token_199 = wave.load %1543 after %1602 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1619 = wave.extract %value_198[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1620 = wave.extract %value_198[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1621 = wave.extract %value_198[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1622 = wave.extract %value_198[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1623 = wave.extract %value_198[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1624 = wave.extract %value_198[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1625 = wave.extract %value_198[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1626 = wave.extract %value_198[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_200, %token_201 = wave.load %1552 after %1602 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1627 = wave.extract %value_200[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1628 = wave.extract %value_200[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1629 = wave.extract %value_200[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1630 = wave.extract %value_200[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1631 = wave.extract %value_200[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1632 = wave.extract %value_200[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1633 = wave.extract %value_200[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1634 = wave.extract %value_200[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1635 = wave.barrier %token_195, %token_197, %token_199, %token_201 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1636 = wave.extract %1463[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1637 = wave.extract %1463[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1638 = wave.extract %1463[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1639 = wave.extract %1463[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1640 = wave.extract %1467[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1641 = wave.extract %1467[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1642 = wave.extract %1467[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1643 = wave.extract %1467[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1644 = wave.pack %1636, %1637, %1638, %1639, %1640, %1641, %1642, %1643 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1645 = wave.store %1644 -> %1480 after %1635 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1646 = wave.extract %1464[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1647 = wave.extract %1464[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1648 = wave.extract %1464[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1649 = wave.extract %1464[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1650 = wave.extract %1468[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1651 = wave.extract %1468[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1652 = wave.extract %1468[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1653 = wave.extract %1468[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1654 = wave.pack %1646, %1647, %1648, %1649, %1650, %1651, %1652, %1653 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1655 = wave.store %1654 -> %1491 after %1635 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1656 = wave.extract %1465[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1657 = wave.extract %1465[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1658 = wave.extract %1465[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1659 = wave.extract %1465[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1660 = wave.extract %1469[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1661 = wave.extract %1469[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1662 = wave.extract %1469[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1663 = wave.extract %1469[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1664 = wave.pack %1656, %1657, %1658, %1659, %1660, %1661, %1662, %1663 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1665 = wave.store %1664 -> %1502 after %1635 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1666 = wave.extract %1466[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1667 = wave.extract %1466[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1668 = wave.extract %1466[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1669 = wave.extract %1466[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1670 = wave.extract %1470[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1671 = wave.extract %1470[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1672 = wave.extract %1470[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1673 = wave.extract %1470[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1674 = wave.pack %1666, %1667, %1668, %1669, %1670, %1671, %1672, %1673 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1675 = wave.store %1674 -> %1513 after %1635 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1676 = wave.barrier %1645, %1655, %1665, %1675 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_202, %token_203 = wave.load %1525 after %1676 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1677 = wave.extract %value_202[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1678 = wave.extract %value_202[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1679 = wave.extract %value_202[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1680 = wave.extract %value_202[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1681 = wave.extract %value_202[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1682 = wave.extract %value_202[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1683 = wave.extract %value_202[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1684 = wave.extract %value_202[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_204, %token_205 = wave.load %1534 after %1676 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1685 = wave.extract %value_204[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1686 = wave.extract %value_204[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1687 = wave.extract %value_204[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1688 = wave.extract %value_204[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1689 = wave.extract %value_204[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1690 = wave.extract %value_204[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1691 = wave.extract %value_204[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1692 = wave.extract %value_204[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_206, %token_207 = wave.load %1543 after %1676 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1693 = wave.extract %value_206[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1694 = wave.extract %value_206[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1695 = wave.extract %value_206[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1696 = wave.extract %value_206[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1697 = wave.extract %value_206[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1698 = wave.extract %value_206[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1699 = wave.extract %value_206[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1700 = wave.extract %value_206[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_208, %token_209 = wave.load %1552 after %1676 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1701 = wave.extract %value_208[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1702 = wave.extract %value_208[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1703 = wave.extract %value_208[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1704 = wave.extract %value_208[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1705 = wave.extract %value_208[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1706 = wave.extract %value_208[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1707 = wave.extract %value_208[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1708 = wave.extract %value_208[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1709 = wave.barrier %token_203, %token_205, %token_207, %token_209 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1710 = wave.extract %1471[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1711 = wave.extract %1471[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1712 = wave.extract %1471[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1713 = wave.extract %1471[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1714 = wave.extract %1475[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1715 = wave.extract %1475[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1716 = wave.extract %1475[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1717 = wave.extract %1475[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1718 = wave.pack %1710, %1711, %1712, %1713, %1714, %1715, %1716, %1717 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1719 = wave.store %1718 -> %1480 after %1709 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1720 = wave.extract %1472[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1721 = wave.extract %1472[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1722 = wave.extract %1472[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1723 = wave.extract %1472[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1724 = wave.extract %1476[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1725 = wave.extract %1476[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1726 = wave.extract %1476[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1727 = wave.extract %1476[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1728 = wave.pack %1720, %1721, %1722, %1723, %1724, %1725, %1726, %1727 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1729 = wave.store %1728 -> %1491 after %1709 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1730 = wave.extract %1473[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1731 = wave.extract %1473[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1732 = wave.extract %1473[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1733 = wave.extract %1473[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1734 = wave.extract %1477[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1735 = wave.extract %1477[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1736 = wave.extract %1477[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1737 = wave.extract %1477[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1738 = wave.pack %1730, %1731, %1732, %1733, %1734, %1735, %1736, %1737 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1739 = wave.store %1738 -> %1502 after %1709 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1740 = wave.extract %1474[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1741 = wave.extract %1474[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1742 = wave.extract %1474[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1743 = wave.extract %1474[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1744 = wave.extract %1478[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1745 = wave.extract %1478[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1746 = wave.extract %1478[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1747 = wave.extract %1478[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1748 = wave.pack %1740, %1741, %1742, %1743, %1744, %1745, %1746, %1747 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1749 = wave.store %1748 -> %1513 after %1709 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1750 = wave.barrier %1719, %1729, %1739, %1749 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_210, %token_211 = wave.load %1525 after %1750 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1751 = wave.extract %value_210[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1752 = wave.extract %value_210[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1753 = wave.extract %value_210[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1754 = wave.extract %value_210[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1755 = wave.extract %value_210[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1756 = wave.extract %value_210[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1757 = wave.extract %value_210[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1758 = wave.extract %value_210[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_212, %token_213 = wave.load %1534 after %1750 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1759 = wave.extract %value_212[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1760 = wave.extract %value_212[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1761 = wave.extract %value_212[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1762 = wave.extract %value_212[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1763 = wave.extract %value_212[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1764 = wave.extract %value_212[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1765 = wave.extract %value_212[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1766 = wave.extract %value_212[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_214, %token_215 = wave.load %1543 after %1750 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1767 = wave.extract %value_214[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1768 = wave.extract %value_214[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1769 = wave.extract %value_214[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1770 = wave.extract %value_214[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1771 = wave.extract %value_214[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1772 = wave.extract %value_214[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1773 = wave.extract %value_214[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1774 = wave.extract %value_214[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_216, %token_217 = wave.load %1552 after %1750 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1775 = wave.extract %value_216[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1776 = wave.extract %value_216[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1777 = wave.extract %value_216[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1778 = wave.extract %value_216[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1779 = wave.extract %value_216[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1780 = wave.extract %value_216[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1781 = wave.extract %value_216[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1782 = wave.extract %value_216[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1783 = wave.barrier %token_211, %token_213, %token_215, %token_217 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1784 = wave.pack %1526, %1527, %1528, %1529, %1535, %1536, %1537, %1538 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1785 = wave.index_expr <"128 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1786 = wave.assume %1785 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1787 = wave.ptr_add %1230, %1786 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1788 = wave.store %1784 -> %1787 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1789 = wave.pack %1544, %1545, %1546, %1547, %1553, %1554, %1555, %1556 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1790 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1791 = wave.assume %1790 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1792 = wave.ptr_add %1230, %1791 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1793 = wave.store %1789 -> %1792 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1794 = wave.pack %1530, %1531, %1532, %1533, %1539, %1540, %1541, %1542 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1795 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1796 = wave.assume %1795 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1797 = wave.ptr_add %1230, %1796 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1798 = wave.store %1794 -> %1797 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1799 = wave.pack %1548, %1549, %1550, %1551, %1557, %1558, %1559, %1560 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1800 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1801 = wave.assume %1800 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1802 = wave.ptr_add %1230, %1801 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1803 = wave.store %1799 -> %1802 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1804 = wave.pack %1603, %1604, %1605, %1606, %1611, %1612, %1613, %1614 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1805 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1806 = wave.assume %1805 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1807 = wave.ptr_add %1230, %1806 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1808 = wave.store %1804 -> %1807 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1809 = wave.pack %1619, %1620, %1621, %1622, %1627, %1628, %1629, %1630 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1810 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1811 = wave.assume %1810 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1812 = wave.ptr_add %1230, %1811 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1813 = wave.store %1809 -> %1812 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1814 = wave.pack %1607, %1608, %1609, %1610, %1615, %1616, %1617, %1618 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1815 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1816 = wave.assume %1815 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1817 = wave.ptr_add %1230, %1816 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1818 = wave.store %1814 -> %1817 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1819 = wave.pack %1623, %1624, %1625, %1626, %1631, %1632, %1633, %1634 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1820 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1821 = wave.assume %1820 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1822 = wave.ptr_add %1230, %1821 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1823 = wave.store %1819 -> %1822 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1824 = wave.pack %1677, %1678, %1679, %1680, %1685, %1686, %1687, %1688 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1825 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1826 = wave.assume %1825 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1827 = wave.ptr_add %1230, %1826 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1828 = wave.store %1824 -> %1827 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1829 = wave.pack %1693, %1694, %1695, %1696, %1701, %1702, %1703, %1704 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1830 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1831 = wave.assume %1830 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1832 = wave.ptr_add %1230, %1831 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1833 = wave.store %1829 -> %1832 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1834 = wave.pack %1681, %1682, %1683, %1684, %1689, %1690, %1691, %1692 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1835 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1836 = wave.assume %1835 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1837 = wave.ptr_add %1230, %1836 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1838 = wave.store %1834 -> %1837 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1839 = wave.pack %1697, %1698, %1699, %1700, %1705, %1706, %1707, %1708 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1840 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1841 = wave.assume %1840 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1842 = wave.ptr_add %1230, %1841 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1843 = wave.store %1839 -> %1842 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1844 = wave.pack %1751, %1752, %1753, %1754, %1759, %1760, %1761, %1762 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1845 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1846 = wave.assume %1845 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1847 = wave.ptr_add %1230, %1846 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1848 = wave.store %1844 -> %1847 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1849 = wave.pack %1767, %1768, %1769, %1770, %1775, %1776, %1777, %1778 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1850 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1851 = wave.assume %1850 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1852 = wave.ptr_add %1230, %1851 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1853 = wave.store %1849 -> %1852 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1854 = wave.pack %1755, %1756, %1757, %1758, %1763, %1764, %1765, %1766 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1855 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1856 = wave.assume %1855 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1857 = wave.ptr_add %1230, %1856 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1858 = wave.store %1854 -> %1857 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1859 = wave.pack %1771, %1772, %1773, %1774, %1779, %1780, %1781, %1782 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1860 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1861 = wave.assume %1860 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1862 = wave.ptr_add %1230, %1861 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1863 = wave.store %1859 -> %1862 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      return
    }
  }
}
