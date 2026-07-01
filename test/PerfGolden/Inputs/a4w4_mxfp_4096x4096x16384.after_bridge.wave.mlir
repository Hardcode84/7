module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 4 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @_a4w4_kernel(%arg0: !wave.ptr<#wave.global, i8>, %arg1: !wave.ptr<#wave.global, i8>, %arg2: !wave.ptr<#wave.global, bf16>, %arg3: !wave.ptr<#wave.global, i8>, %arg4: !wave.ptr<#wave.global, i8>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 256, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 4 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.lds_size = 154432 : i64, wave.waves_per_workgroup = 4 : i64, wave.workgroup_size = array<i32: 256, 1, 1>, waveamdmachine.schedule_max_region_ops = -1 : i64, waveamdmachine.target_waves = 1 : i64} {
      %0 = wave.constant 6144 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 4096 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 2048 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 224 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 192 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 160 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %8 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %10 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %11 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %12 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %13 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %14 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %15 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
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
      %16 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %17 = wave.pack %16, %16, %16, %16 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %18 = wave.workgroup_id 0
      %19 = wave.binary addi %arg5, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %20 = wave.binary divsi %19, %c256_i32 : i32, i32 -> i32
      %21 = wave.binary addi %arg6, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %22 = wave.binary divsi %21, %c256_i32 : i32, i32 -> i32
      %23 = wave.binary remui %18, %c8_i32 : i32, i32 -> i32
      %24 = wave.binary divui %18, %c8_i32 : i32, i32 -> i32
      %25 = wave.binary muli %23, %c32_i32 overflow<nsw> : i32, i32 -> i32
      %26 = wave.binary addi %25, %24 overflow<nsw> : i32, i32 -> i32
      %27 = wave.binary muli %22, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %28 = wave.binary divsi %26, %27 : i32, i32 -> i32
      %29 = wave.binary muli %28, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %30 = wave.binary subi %20, %29 overflow<nsw> : i32, i32 -> i32
      %31 = arith.cmpi slt, %30, %c4_i32 : i32
      %32 = wave.select %31, %30, %c4_i32 : i32
      %33 = wave.binary remsi %26, %27 : i32, i32 -> i32
      %34 = wave.assume %32 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %35 = wave.binary remui %33, %34 : i32, i32 -> i32
      %36 = wave.binary addi %29, %35 overflow<nsw> : i32, i32 -> i32
      %37 = wave.assume %32 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %38 = wave.binary divui %33, %37 : i32, i32 -> i32
      %39 = wave.binary muli %36, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %40 = wave.binary muli %39, %arg7 : i32, i32 -> i32
      %41 = wave.binary muli %arg8, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %42 = wave.binary muli %38, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %43 = wave.binary muli %42, %arg8 : i32, i32 -> i32
      %44 = wave.binary muli %arg11, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %45 = wave.lds_base : !wave.ptr<#wave.shared, i8>
      %46 = wave.ptr_add %arg0, %40 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %47 = waveamd.make_buffer %46, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %48 = wave.ptr_cast %45 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
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
      %103 = wave.lds_base {offset = 67520 : i64} : !wave.ptr<#wave.shared, i8>
      %104 = wave.ptr_add %arg1, %43 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %105 = waveamd.make_buffer %104, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %106 = wave.ptr_cast %103 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %107 = wave.index_expr <"8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %108 = wave.assume %107 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %109 = wave.ptr_add %105, %108 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %110 = wave.ptr_add %106, %53 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %111 = waveamd.dma_load_lds %109 -> %110 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %112 = wave.index_expr <"4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %113 = wave.assume %112 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %114 = wave.ptr_add %105, %113 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %115 = wave.ptr_add %106, %63 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %116 = waveamd.dma_load_lds %114 -> %115 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %117 = wave.index_expr <"8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %118 = wave.assume %117 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %119 = wave.ptr_add %105, %118 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %120 = wave.ptr_add %106, %69 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %121 = waveamd.dma_load_lds %119 -> %120 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %122 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %123 = wave.assume %122 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %124 = wave.ptr_add %105, %123 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %125 = wave.ptr_add %106, %75 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %126 = waveamd.dma_load_lds %124 -> %125 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %127 = wave.join %111, %116, %121, %126 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %128 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %129 = wave.index_expr <"s0*s1 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %130 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %131 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %132 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %133 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(128 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %134 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(160 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %135 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(192 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %136 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(224 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %137 = wave.assume %129 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %138 = wave.ptr_add %128, %137 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value, %token = wave.load %138 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %139 = wave.assume %130 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %140 = wave.ptr_add %128, %139 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_0, %token_1 = wave.load %140 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %141 = wave.assume %131 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %142 = wave.ptr_add %128, %141 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_2, %token_3 = wave.load %142 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %143 = wave.assume %132 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %144 = wave.ptr_add %128, %143 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_4, %token_5 = wave.load %144 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %145 = wave.assume %133 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %146 = wave.ptr_add %128, %145 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_6, %token_7 = wave.load %146 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %147 = wave.assume %134 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %148 = wave.ptr_add %128, %147 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_8, %token_9 = wave.load %148 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %149 = wave.assume %135 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %150 = wave.ptr_add %128, %149 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_10, %token_11 = wave.load %150 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %151 = wave.assume %136 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %152 = wave.ptr_add %128, %151 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_12, %token_13 = wave.load %152 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %153 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %154 = wave.index_expr <"s0*s1 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %155 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %156 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %157 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %158 = wave.assume %154 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %159 = wave.ptr_add %153, %158 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_14, %token_15 = wave.load %159 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %160 = wave.assume %155 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %161 = wave.ptr_add %153, %160 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_16, %token_17 = wave.load %161 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %162 = wave.assume %156 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %163 = wave.ptr_add %153, %162 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_18, %token_19 = wave.load %163 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %164 = wave.assume %157 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %165 = wave.ptr_add %153, %164 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_20, %token_21 = wave.load %165 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %166 = wave.join %102, %127 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %167 = wave.lds_base {offset = 101248 : i64} : !wave.ptr<#wave.shared, i8>
      %168 = wave.ptr_cast %167 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %169 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %170 = wave.assume %169 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %171 = wave.ptr_add %105, %170 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %172 = wave.ptr_add %168, %53 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %173 = waveamd.dma_load_lds %171 -> %172 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %174 = wave.index_expr <"s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %175 = wave.assume %174 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %176 = wave.ptr_add %105, %175 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %177 = wave.ptr_add %168, %63 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %178 = waveamd.dma_load_lds %176 -> %177 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %179 = wave.index_expr <"s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %180 = wave.assume %179 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %181 = wave.ptr_add %105, %180 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %182 = wave.ptr_add %168, %69 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %183 = waveamd.dma_load_lds %181 -> %182 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %184 = wave.index_expr <"s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %185 = wave.assume %184 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %186 = wave.ptr_add %105, %185 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %187 = wave.ptr_add %168, %75 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %188 = waveamd.dma_load_lds %186 -> %187 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %189 = wave.join %173, %178, %183, %188 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %190 = wave.index_expr <"s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %44, %42) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %191 = wave.index_expr <"s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %44, %42) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %192 = wave.index_expr <"2*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %44, %42) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %193 = wave.index_expr <"3*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %44, %42) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %194 = wave.assume %190 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %195 = wave.ptr_add %153, %194 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_22, %token_23 = wave.load %195 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %196 = wave.assume %191 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %197 = wave.ptr_add %153, %196 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_24, %token_25 = wave.load %197 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %198 = wave.assume %192 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %199 = wave.ptr_add %153, %198 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_26, %token_27 = wave.load %199 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %200 = wave.assume %193 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %201 = wave.ptr_add %153, %200 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_28, %token_29 = wave.load %201 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %202 = wave.lds_base {offset = 33760 : i64} : !wave.ptr<#wave.shared, i8>
      %203 = wave.ptr_cast %202 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %204 = wave.index_expr <"128 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %205 = wave.assume %204 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %206 = wave.ptr_add %47, %205 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %207 = wave.ptr_add %203, %53 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %208 = waveamd.dma_load_lds %206 -> %207 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %209 = wave.index_expr <"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %210 = wave.assume %209 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %211 = wave.ptr_add %47, %210 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %212 = wave.ptr_add %203, %63 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %213 = waveamd.dma_load_lds %211 -> %212 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %214 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %215 = wave.assume %214 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %216 = wave.ptr_add %47, %215 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %217 = wave.ptr_add %203, %69 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %218 = waveamd.dma_load_lds %216 -> %217 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %219 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %220 = wave.assume %219 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %221 = wave.ptr_add %47, %220 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %222 = wave.ptr_add %203, %75 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %223 = waveamd.dma_load_lds %221 -> %222 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %224 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %225 = wave.assume %224 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %226 = wave.ptr_add %47, %225 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %227 = wave.ptr_add %203, %81 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %228 = waveamd.dma_load_lds %226 -> %227 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %229 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %230 = wave.assume %229 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %231 = wave.ptr_add %47, %230 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %232 = wave.ptr_add %203, %87 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %233 = waveamd.dma_load_lds %231 -> %232 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %234 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %235 = wave.assume %234 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %236 = wave.ptr_add %47, %235 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %237 = wave.ptr_add %203, %93 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %238 = waveamd.dma_load_lds %236 -> %237 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %239 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %240 = wave.assume %239 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %241 = wave.ptr_add %47, %240 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %242 = wave.ptr_add %203, %99 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %243 = waveamd.dma_load_lds %241 -> %242 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %244 = wave.join %208, %213, %218, %223, %228, %233, %238, %243 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %245 = wave.lds_base {offset = 84384 : i64} : !wave.ptr<#wave.shared, i8>
      %246 = wave.ptr_cast %245 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %247 = wave.index_expr <"128 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %248 = wave.assume %247 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %249 = wave.ptr_add %105, %248 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %250 = wave.ptr_add %246, %53 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %251 = waveamd.dma_load_lds %249 -> %250 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %252 = wave.index_expr <"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %253 = wave.assume %252 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %254 = wave.ptr_add %105, %253 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %255 = wave.ptr_add %246, %63 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %256 = waveamd.dma_load_lds %254 -> %255 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %257 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %258 = wave.assume %257 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %259 = wave.ptr_add %105, %258 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %260 = wave.ptr_add %246, %69 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %261 = waveamd.dma_load_lds %259 -> %260 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %262 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%49, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %263 = wave.assume %262 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %264 = wave.ptr_add %105, %263 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %265 = wave.ptr_add %246, %75 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %266 = waveamd.dma_load_lds %264 -> %265 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %267 = wave.join %251, %256, %261, %266 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %268 = wave.index_expr <"8 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %269 = wave.index_expr <"8 + s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %270 = wave.index_expr <"8 + 2*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %271 = wave.index_expr <"8 + 3*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %272 = wave.index_expr <"8 + 4*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %273 = wave.index_expr <"8 + 5*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %274 = wave.index_expr <"8 + 6*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %275 = wave.index_expr <"8 + 7*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg10, %39) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %276 = wave.assume %268 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %277 = wave.ptr_add %128, %276 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_30, %token_31 = wave.load %277 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %278 = wave.assume %269 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %279 = wave.ptr_add %128, %278 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_32, %token_33 = wave.load %279 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %280 = wave.assume %270 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %281 = wave.ptr_add %128, %280 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_34, %token_35 = wave.load %281 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %282 = wave.assume %271 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %283 = wave.ptr_add %128, %282 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_36, %token_37 = wave.load %283 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %284 = wave.assume %272 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %285 = wave.ptr_add %128, %284 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_38, %token_39 = wave.load %285 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %286 = wave.assume %273 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %287 = wave.ptr_add %128, %286 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_40, %token_41 = wave.load %287 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %288 = wave.assume %274 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %289 = wave.ptr_add %128, %288 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_42, %token_43 = wave.load %289 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %290 = wave.assume %275 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %291 = wave.ptr_add %128, %290 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_44, %token_45 = wave.load %291 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %292 = wave.index_expr <"8 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %293 = wave.index_expr <"8 + s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %294 = wave.index_expr <"8 + 2*s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %295 = wave.index_expr <"8 + 3*s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%49, %arg11, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %296 = wave.assume %292 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %297 = wave.ptr_add %153, %296 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_46, %token_47 = wave.load %297 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %298 = wave.assume %293 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %299 = wave.ptr_add %153, %298 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_48, %token_49 = wave.load %299 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %300 = wave.assume %294 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %301 = wave.ptr_add %153, %300 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_50, %token_51 = wave.load %301 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %302 = wave.assume %295 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %303 = wave.ptr_add %153, %302 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_52, %token_53 = wave.load %303 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %304 = wave.join %244, %267 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %305 = wave.lds_base {offset = 118112 : i64} : !wave.ptr<#wave.shared, i8>
      %306 = wave.ptr_cast %305 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %307 = wave.index_expr <"128 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %308 = wave.assume %307 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %309 = wave.ptr_add %105, %308 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %310 = wave.ptr_add %306, %53 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %311 = waveamd.dma_load_lds %309 -> %310 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %312 = wave.index_expr <"128 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %313 = wave.assume %312 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %314 = wave.ptr_add %105, %313 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %315 = wave.ptr_add %306, %63 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %316 = waveamd.dma_load_lds %314 -> %315 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %317 = wave.index_expr <"128 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %318 = wave.assume %317 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %319 = wave.ptr_add %105, %318 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %320 = wave.ptr_add %306, %69 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %321 = waveamd.dma_load_lds %319 -> %320 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %322 = wave.index_expr <"128 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%49, %arg8, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %323 = wave.assume %322 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %324 = wave.ptr_add %105, %323 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %325 = wave.ptr_add %306, %75 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %326 = waveamd.dma_load_lds %324 -> %325 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %327 = wave.join %311, %316, %321, %326 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %328 = wave.index_expr <"8 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %44, %42) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %329 = wave.index_expr <"8 + s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %44, %42) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %330 = wave.index_expr <"8 + 2*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %44, %42) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %331 = wave.index_expr <"8 + 3*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%49, %arg11, %44, %42) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %332 = wave.assume %328 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %333 = wave.ptr_add %153, %332 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_54, %token_55 = wave.load %333 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %334 = wave.assume %329 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %335 = wave.ptr_add %153, %334 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_56, %token_57 = wave.load %335 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %336 = wave.assume %330 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %337 = wave.ptr_add %153, %336 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_58, %token_59 = wave.load %337 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %338 = wave.assume %331 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %339 = wave.ptr_add %153, %338 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_60, %token_61 = wave.load %339 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %340 = wave.binary addi %40, %c256_i32 : i32, i32 -> i32
      %341 = wave.binary addi %43, %c256_i32 : i32, i32 -> i32
      wave.wait %166 : !wave.mem.token
      %342 = wave.barrier %166 : (!wave.mem.token) -> !wave.mem.token
      %343 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 16896*Mod(floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %344 = wave.ptr_add %45, %343 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_62, %token_63 = wave.load %344 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %345 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %346 = wave.ptr_add %45, %345 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_64, %token_65 = wave.load %346 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %347 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %348 = wave.ptr_add %45, %347 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_66, %token_67 = wave.load %348 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %349 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %350 = wave.ptr_add %45, %349 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_68, %token_69 = wave.load %350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %351 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %352 = wave.ptr_add %45, %351 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_70, %token_71 = wave.load %352 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %353 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/2*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %354 = wave.ptr_add %45, %353 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_72, %token_73 = wave.load %354 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %355 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %356 = wave.ptr_add %45, %355 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_74, %token_75 = wave.load %356 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %357 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/2*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %358 = wave.ptr_add %45, %357 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_76, %token_77 = wave.load %358 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %359 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 16896*Mod(1 + floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %360 = wave.ptr_add %45, %359 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_78, %token_79 = wave.load %360 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %361 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 16896*Mod(1 + floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %362 = wave.ptr_add %45, %361 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_80, %token_81 = wave.load %362 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %363 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %364 = wave.ptr_add %45, %363 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_82, %token_83 = wave.load %364 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %365 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %366 = wave.ptr_add %45, %365 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_84, %token_85 = wave.load %366 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %367 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %368 = wave.ptr_add %45, %367 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_86, %token_87 = wave.load %368 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %369 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/2*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %370 = wave.ptr_add %45, %369 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_88, %token_89 = wave.load %370 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %371 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %372 = wave.ptr_add %45, %371 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_90, %token_91 = wave.load %372 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %373 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/2*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %374 = wave.ptr_add %45, %373 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_92, %token_93 = wave.load %374 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %375 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %376 = wave.ptr_add %103, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_94, %token_95 = wave.load %376 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %377 = wave.index_expr <"64 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %378 = wave.ptr_add %103, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_96, %token_97 = wave.load %378 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %379 = wave.index_expr <"256 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %380 = wave.ptr_add %103, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_98, %token_99 = wave.load %380 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %381 = wave.index_expr <"320 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %382 = wave.ptr_add %103, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_100, %token_101 = wave.load %382 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %383 = wave.index_expr <"512 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %384 = wave.ptr_add %103, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_102, %token_103 = wave.load %384 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %385 = wave.index_expr <"576 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %386 = wave.ptr_add %103, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_104, %token_105 = wave.load %386 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %387 = wave.index_expr <"768 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %388 = wave.ptr_add %103, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_106, %token_107 = wave.load %388 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %389 = wave.index_expr <"832 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %390 = wave.ptr_add %103, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_108, %token_109 = wave.load %390 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %391 = wave.lds_base {offset = 134976 : i64} : !wave.ptr<#wave.shared, i8>
      %392 = wave.binary divui %49, %14 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %393 = wave.binary remui %392, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %394 = wave.binary divui %49, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %395 = wave.binary remui %394, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %396 = wave.binary muli %395, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %397 = wave.binary xori %393, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %398 = wave.binary divui %49, %11 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %399 = wave.binary remui %398, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %400 = wave.binary muli %399, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %401 = wave.binary xori %397, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %402 = wave.binary divui %49, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %403 = wave.binary remui %402, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %404 = wave.binary muli %403, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %405 = wave.binary xori %401, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %406 = wave.binary divui %49, %8 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %407 = wave.binary remui %406, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %408 = wave.binary muli %407, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %409 = wave.binary xori %405, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %410 = wave.binary remui %49, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %411 = wave.binary divui %49, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %412 = wave.binary remui %411, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %413 = wave.binary muli %412, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %414 = wave.binary xori %410, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %415 = wave.binary divui %49, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %416 = wave.binary remui %415, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %417 = wave.binary muli %416, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %418 = wave.binary xori %414, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %419 = wave.binary muli %418, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %420 = wave.binary addi %419, %409 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %421 = wave.binary xori %11, %393 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %422 = wave.binary xori %421, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %423 = wave.binary xori %422, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %424 = wave.binary xori %423, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %425 = wave.binary xori %424, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %426 = wave.binary addi %419, %425 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %427 = wave.binary xori %9, %393 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %428 = wave.binary xori %427, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %429 = wave.binary xori %428, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %430 = wave.binary xori %429, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %431 = wave.binary xori %430, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %432 = wave.binary addi %419, %431 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %433 = wave.binary xori %6, %393 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %434 = wave.binary xori %433, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %435 = wave.binary xori %434, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %436 = wave.binary xori %435, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %437 = wave.binary xori %436, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %438 = wave.binary addi %419, %437 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %439 = wave.binary xori %8, %393 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %440 = wave.binary xori %439, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %441 = wave.binary xori %440, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %442 = wave.binary xori %441, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %443 = wave.binary xori %442, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %444 = wave.binary addi %419, %443 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %445 = wave.binary xori %5, %393 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %446 = wave.binary xori %445, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %447 = wave.binary xori %446, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %448 = wave.binary xori %447, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %449 = wave.binary xori %448, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %450 = wave.binary addi %419, %449 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %451 = wave.binary xori %4, %393 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %452 = wave.binary xori %451, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %453 = wave.binary xori %452, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %454 = wave.binary xori %453, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %455 = wave.binary xori %454, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %456 = wave.binary addi %419, %455 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %457 = wave.binary xori %3, %393 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %458 = wave.binary xori %457, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %459 = wave.binary xori %458, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %460 = wave.binary xori %459, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %461 = wave.binary xori %460, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %462 = wave.binary addi %419, %461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %463 = wave.ptr_add %391, %420 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %464 = wave.store %value -> %463 after %54 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %465 = wave.ptr_add %391, %426 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %466 = wave.store %value_0 -> %465 after %54 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %467 = wave.ptr_add %391, %432 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %468 = wave.store %value_2 -> %467 after %54 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %469 = wave.ptr_add %391, %438 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %470 = wave.store %value_4 -> %469 after %54 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %471 = wave.ptr_add %391, %444 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %472 = wave.store %value_6 -> %471 after %54 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %473 = wave.ptr_add %391, %450 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %474 = wave.store %value_8 -> %473 after %54 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %475 = wave.ptr_add %391, %456 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %476 = wave.store %value_10 -> %475 after %54 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %477 = wave.ptr_add %391, %462 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %478 = wave.store %value_12 -> %477 after %54 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %479 = wave.barrier %464, %466, %468, %470, %472, %474, %476, %478 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %480 = wave.lds_base {offset = 137024 : i64} : !wave.ptr<#wave.shared, i8>
      %481 = wave.binary muli %418, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %482 = wave.binary addi %481, %409 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %483 = wave.binary addi %481, %425 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %484 = wave.binary addi %481, %431 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %485 = wave.binary addi %481, %437 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %486 = wave.ptr_add %480, %482 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %487 = wave.store %value_14 -> %486 after %479 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %488 = wave.ptr_add %480, %483 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %489 = wave.store %value_16 -> %488 after %479 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %490 = wave.ptr_add %480, %484 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %491 = wave.store %value_18 -> %490 after %479 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %492 = wave.ptr_add %480, %485 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %493 = wave.store %value_20 -> %492 after %479 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %494 = wave.barrier %487, %489, %491, %493 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %495 = wave.index_expr <"8*Mod(wi, 2) + 16*Mod(floor(1/128*wi), 2) + 512*Mod(floor(1/32*wi), 2) + 256*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 1024*Mod(floor(1/2*wi), 2)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %496 = wave.ptr_add %391, %495 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_110, %token_111 = waveamd.transpose_load %496 after %494 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %497 = wave.extract %value_110[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %498 = wave.extract %value_110[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %499 = wave.extract %value_110[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %500 = wave.extract %value_110[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %501 = wave.extract %value_110[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %502 = wave.extract %value_110[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %503 = wave.extract %value_110[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %504 = wave.extract %value_110[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %505 = wave.index_expr <"128 + 8*Mod(wi, 2) + 16*Mod(floor(1/128*wi), 2) + 512*Mod(floor(1/32*wi), 2) + 256*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 1024*Mod(floor(1/2*wi), 2)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %506 = wave.ptr_add %391, %505 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_112, %token_113 = waveamd.transpose_load %506 after %494 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %507 = wave.extract %value_112[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %508 = wave.extract %value_112[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %509 = wave.extract %value_112[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %510 = wave.extract %value_112[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %511 = wave.extract %value_112[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %512 = wave.extract %value_112[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %513 = wave.extract %value_112[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %514 = wave.extract %value_112[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %515 = wave.join %token_111, %token_113 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %516 = wave.index_expr <"8*Mod(wi, 2) + 16*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/32*wi), 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 512*Mod(floor(1/2*wi), 2)"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %517 = wave.ptr_add %480, %516 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_114, %token_115 = waveamd.transpose_load %517 after %515 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %518 = wave.extract %value_114[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %519 = wave.extract %value_114[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %520 = wave.extract %value_114[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %521 = wave.extract %value_114[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %522 = wave.extract %value_114[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %523 = wave.extract %value_114[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %524 = wave.extract %value_114[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %525 = wave.extract %value_114[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %526:139 = scf.for %arg12 = %c0_i32 to %c62_i32 step %c2_i32 iter_args(%arg13 = %340, %arg14 = %341, %arg15 = %c16_i32, %arg16 = %c16_i32, %arg17 = %17, %arg18 = %17, %arg19 = %17, %arg20 = %17, %arg21 = %17, %arg22 = %17, %arg23 = %17, %arg24 = %17, %arg25 = %17, %arg26 = %17, %arg27 = %17, %arg28 = %17, %arg29 = %17, %arg30 = %17, %arg31 = %17, %arg32 = %17, %arg33 = %17, %arg34 = %17, %arg35 = %17, %arg36 = %17, %arg37 = %17, %arg38 = %17, %arg39 = %17, %arg40 = %17, %arg41 = %17, %arg42 = %17, %arg43 = %17, %arg44 = %17, %arg45 = %17, %arg46 = %17, %arg47 = %17, %arg48 = %17, %arg49 = %17, %arg50 = %17, %arg51 = %17, %arg52 = %17, %arg53 = %17, %arg54 = %17, %arg55 = %17, %arg56 = %17, %arg57 = %17, %arg58 = %17, %arg59 = %17, %arg60 = %17, %arg61 = %17, %arg62 = %17, %arg63 = %17, %arg64 = %17, %arg65 = %17, %arg66 = %17, %arg67 = %17, %arg68 = %17, %arg69 = %17, %arg70 = %17, %arg71 = %17, %arg72 = %17, %arg73 = %17, %arg74 = %17, %arg75 = %17, %arg76 = %17, %arg77 = %17, %arg78 = %17, %arg79 = %17, %arg80 = %17, %arg81 = %value_22, %arg82 = %value_24, %arg83 = %value_26, %arg84 = %value_28, %arg85 = %value_30, %arg86 = %value_32, %arg87 = %value_34, %arg88 = %value_36, %arg89 = %value_38, %arg90 = %value_40, %arg91 = %value_42, %arg92 = %value_44, %arg93 = %value_46, %arg94 = %value_48, %arg95 = %value_50, %arg96 = %value_52, %arg97 = %value_54, %arg98 = %value_56, %arg99 = %value_58, %arg100 = %value_60, %arg101 = %value_62, %arg102 = %value_64, %arg103 = %value_66, %arg104 = %value_68, %arg105 = %value_70, %arg106 = %value_72, %arg107 = %value_74, %arg108 = %value_76, %arg109 = %value_78, %arg110 = %value_80, %arg111 = %value_82, %arg112 = %value_84, %arg113 = %value_86, %arg114 = %value_88, %arg115 = %value_90, %arg116 = %value_92, %arg117 = %value_94, %arg118 = %value_96, %arg119 = %value_98, %arg120 = %value_100, %arg121 = %value_102, %arg122 = %value_104, %arg123 = %value_106, %arg124 = %value_108, %arg125 = %497, %arg126 = %498, %arg127 = %499, %arg128 = %500, %arg129 = %501, %arg130 = %502, %arg131 = %503, %arg132 = %504, %arg133 = %507, %arg134 = %508, %arg135 = %509, %arg136 = %510, %arg137 = %511, %arg138 = %512, %arg139 = %513, %arg140 = %514, %arg141 = %518, %arg142 = %519, %arg143 = %520, %arg144 = %521, %arg145 = %522, %arg146 = %523, %arg147 = %524, %arg148 = %525, %arg149 = %189, %arg150 = %304, %arg151 = %327) -> (i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %2072 = waveamd.fragment_pack %arg101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2073 = waveamd.fragment_pack %arg102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2074 = waveamd.fragment_pack %arg103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2075 = waveamd.fragment_pack %arg104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2076 = waveamd.fragment_pack %arg105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2077 = waveamd.fragment_pack %arg106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2078 = waveamd.fragment_pack %arg107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2079 = waveamd.fragment_pack %arg108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2080 = waveamd.fragment_pack %arg109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2081 = waveamd.fragment_pack %arg110 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2082 = waveamd.fragment_pack %arg111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2083 = waveamd.fragment_pack %arg112 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2084 = waveamd.fragment_pack %arg113 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2085 = waveamd.fragment_pack %arg114 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2086 = waveamd.fragment_pack %arg115 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2087 = waveamd.fragment_pack %arg116 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2088 = waveamd.fragment_pack %arg117 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2089 = waveamd.fragment_pack %arg118 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2090 = waveamd.fragment_pack %arg119 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2091 = waveamd.fragment_pack %arg120 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2092 = waveamd.fragment_pack %arg121 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2093 = waveamd.fragment_pack %arg122 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2094 = waveamd.fragment_pack %arg123 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2095 = waveamd.fragment_pack %arg124 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2096 = waveamd.fragment_pack %arg17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2097 = waveamd.fragment_pack %arg18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2098 = waveamd.fragment_pack %arg19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2099 = waveamd.fragment_pack %arg20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2100 = waveamd.fragment_pack %arg21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2101 = waveamd.fragment_pack %arg22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2102 = waveamd.fragment_pack %arg23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2103 = waveamd.fragment_pack %arg24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2104 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2105 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2106 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2107 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2108 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2109 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2110 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2111 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2112 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2113 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2114 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2115 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2116 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2117 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2118 = waveamd.fragment_pack %arg39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2119 = waveamd.fragment_pack %arg40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2120 = waveamd.fragment_pack %arg41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2121 = waveamd.fragment_pack %arg42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2122 = waveamd.fragment_pack %arg43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2123 = waveamd.fragment_pack %arg44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2124 = waveamd.fragment_pack %arg45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2125 = waveamd.fragment_pack %arg46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2126 = waveamd.fragment_pack %arg47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2127 = waveamd.fragment_pack %arg48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2128 = wave.pack %arg125, %arg126, %arg127, %arg128, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2129 = wave.pack %arg129, %arg130, %arg131, %arg132, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2130 = wave.pack %arg133, %arg134, %arg135, %arg136, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2131 = wave.pack %arg137, %arg138, %arg139, %arg140, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2132 = wave.pack %arg141, %arg142, %arg143, %arg144, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2133 = wave.pack %arg145, %arg146, %arg147, %arg148, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2134 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2088, %2132, %2072, %2128, %2096 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2135 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2089, %2132, %2073, %2128, %2134 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2136 = waveamd.fragment_unpack %2135 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2137 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2090, %2132, %2072, %2128, %2097 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2138 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2091, %2132, %2073, %2128, %2137 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2139 = waveamd.fragment_unpack %2138 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2140 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %2133, %2072, %2128, %2098 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2141 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %2133, %2073, %2128, %2140 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2142 = waveamd.fragment_unpack %2141 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2143 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %2133, %2072, %2128, %2099 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2144 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %2133, %2073, %2128, %2143 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2145 = waveamd.fragment_unpack %2144 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2146 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2088, %2132, %2074, %2128, %2100 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2147 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2089, %2132, %2075, %2128, %2146 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2148 = waveamd.fragment_unpack %2147 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2149 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2090, %2132, %2074, %2128, %2101 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2150 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2091, %2132, %2075, %2128, %2149 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2151 = waveamd.fragment_unpack %2150 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2152 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %2133, %2074, %2128, %2102 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2153 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %2133, %2075, %2128, %2152 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2154 = waveamd.fragment_unpack %2153 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2155 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %2133, %2074, %2128, %2103 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2156 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %2133, %2075, %2128, %2155 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2157 = waveamd.fragment_unpack %2156 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2158 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2088, %2132, %2076, %2129, %2104 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2159 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2089, %2132, %2077, %2129, %2158 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2160 = waveamd.fragment_unpack %2159 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2161 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2090, %2132, %2076, %2129, %2105 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2162 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2091, %2132, %2077, %2129, %2161 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2163 = waveamd.fragment_unpack %2162 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2164 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %2133, %2076, %2129, %2106 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2165 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %2133, %2077, %2129, %2164 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2166 = waveamd.fragment_unpack %2165 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2167 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %2133, %2076, %2129, %2107 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2168 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %2133, %2077, %2129, %2167 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2169 = waveamd.fragment_unpack %2168 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2170 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2088, %2132, %2078, %2129, %2108 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2171 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2089, %2132, %2079, %2129, %2170 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2172 = waveamd.fragment_unpack %2171 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2173 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2090, %2132, %2078, %2129, %2109 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2174 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2091, %2132, %2079, %2129, %2173 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2175 = waveamd.fragment_unpack %2174 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2176 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %2133, %2078, %2129, %2110 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2177 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %2133, %2079, %2129, %2176 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2178 = waveamd.fragment_unpack %2177 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2179 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %2133, %2078, %2129, %2111 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2180 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %2133, %2079, %2129, %2179 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2181 = waveamd.fragment_unpack %2180 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2182 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2088, %2132, %2080, %2130, %2112 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2183 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2089, %2132, %2081, %2130, %2182 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2184 = waveamd.fragment_unpack %2183 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2185 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2090, %2132, %2080, %2130, %2113 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2186 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2091, %2132, %2081, %2130, %2185 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2187 = waveamd.fragment_unpack %2186 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2188 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %2133, %2080, %2130, %2114 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2189 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %2133, %2081, %2130, %2188 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2190 = waveamd.fragment_unpack %2189 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2191 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %2133, %2080, %2130, %2115 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2192 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %2133, %2081, %2130, %2191 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2193 = waveamd.fragment_unpack %2192 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2194 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2088, %2132, %2082, %2130, %2116 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2195 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2089, %2132, %2083, %2130, %2194 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2196 = waveamd.fragment_unpack %2195 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2197 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2090, %2132, %2082, %2130, %2117 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2198 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2091, %2132, %2083, %2130, %2197 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2199 = waveamd.fragment_unpack %2198 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2200 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %2133, %2082, %2130, %2118 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2201 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %2133, %2083, %2130, %2200 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2202 = waveamd.fragment_unpack %2201 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2203 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %2133, %2082, %2130, %2119 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2204 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %2133, %2083, %2130, %2203 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2205 = waveamd.fragment_unpack %2204 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2206 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2088, %2132, %2084, %2131, %2120 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2207 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2089, %2132, %2085, %2131, %2206 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2208 = waveamd.fragment_unpack %2207 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2209 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2090, %2132, %2084, %2131, %2121 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2210 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2091, %2132, %2085, %2131, %2209 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2211 = waveamd.fragment_unpack %2210 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2212 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %2133, %2084, %2131, %2122 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2213 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %2133, %2085, %2131, %2212 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2214 = waveamd.fragment_unpack %2213 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2215 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %2133, %2084, %2131, %2123 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2216 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %2133, %2085, %2131, %2215 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2217 = waveamd.fragment_unpack %2216 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2218 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2088, %2132, %2086, %2131, %2124 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2219 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2089, %2132, %2087, %2131, %2218 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2220 = waveamd.fragment_unpack %2219 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2221 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2090, %2132, %2086, %2131, %2125 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2222 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2091, %2132, %2087, %2131, %2221 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2223 = waveamd.fragment_unpack %2222 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2224 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %2133, %2086, %2131, %2126 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2225 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %2133, %2087, %2131, %2224 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2226 = waveamd.fragment_unpack %2225 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2227 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %2133, %2086, %2131, %2127 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2228 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %2133, %2087, %2131, %2227 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2229 = waveamd.fragment_unpack %2228 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg149 : !wave.mem.token
        %2230 = wave.barrier %arg149 : (!wave.mem.token) -> !wave.mem.token
        %2231 = wave.ptr_add %167, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_270, %token_271 = wave.load %2231 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2232 = wave.ptr_add %167, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_272, %token_273 = wave.load %2232 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2233 = wave.ptr_add %167, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_274, %token_275 = wave.load %2233 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2234 = wave.ptr_add %167, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_276, %token_277 = wave.load %2234 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2235 = wave.ptr_add %167, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_278, %token_279 = wave.load %2235 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2236 = wave.ptr_add %167, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_280, %token_281 = wave.load %2236 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2237 = wave.ptr_add %167, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_282, %token_283 = wave.load %2237 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2238 = wave.ptr_add %167, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_284, %token_285 = wave.load %2238 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2239 = wave.binary muli %410, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2240 = wave.binary muli %412, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2241 = wave.binary xori %2239, %2240 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2242 = wave.binary muli %416, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2243 = wave.binary xori %2241, %2242 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2244 = wave.binary muli %393, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2245 = wave.binary xori %2243, %2244 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2246 = wave.binary muli %395, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2247 = wave.binary xori %2245, %2246 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2248 = wave.binary muli %403, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2249 = wave.binary xori %399, %2248 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2250 = wave.binary muli %407, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2251 = wave.binary xori %2249, %2250 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2252 = wave.binary muli %2251, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2253 = wave.binary addi %2252, %2247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2254 = wave.pack %arg81, %arg82, %arg83, %arg84 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2255 = wave.ptr_add %480, %2253 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2256 = wave.store %2254 -> %2255 after %token_115 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2257 = wave.barrier %2256 : (!wave.mem.token) -> !wave.mem.token
        %value_286, %token_287 = waveamd.transpose_load %517 after %2257 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2258 = wave.ptr_add %arg0, %arg13 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2259 = waveamd.make_buffer %2258, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2260 = wave.ptr_add %2259, %56 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2261 = waveamd.dma_load_lds %2260 -> %58 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2262 = wave.ptr_add %2259, %61 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2263 = waveamd.dma_load_lds %2262 -> %64 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2264 = wave.ptr_add %2259, %67 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2265 = waveamd.dma_load_lds %2264 -> %70 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2266 = wave.ptr_add %2259, %73 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2267 = waveamd.dma_load_lds %2266 -> %76 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2268 = wave.ptr_add %2259, %79 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2269 = waveamd.dma_load_lds %2268 -> %82 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2270 = wave.ptr_add %2259, %85 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2271 = waveamd.dma_load_lds %2270 -> %88 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2272 = wave.ptr_add %2259, %91 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2273 = waveamd.dma_load_lds %2272 -> %94 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2274 = wave.ptr_add %2259, %97 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2275 = waveamd.dma_load_lds %2274 -> %100 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2276 = wave.join %2261, %2263, %2265, %2267, %2269, %2271, %2273, %2275 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2277 = wave.ptr_add %arg1, %arg14 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2278 = waveamd.make_buffer %2277, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2279 = wave.ptr_add %2278, %108 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2280 = waveamd.dma_load_lds %2279 -> %110 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2281 = wave.ptr_add %2278, %113 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2282 = waveamd.dma_load_lds %2281 -> %115 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2283 = wave.ptr_add %2278, %118 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2284 = waveamd.dma_load_lds %2283 -> %120 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2285 = wave.ptr_add %2278, %123 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2286 = waveamd.dma_load_lds %2285 -> %125 after %arg149 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2287 = wave.join %2280, %2282, %2284, %2286 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2288 = wave.ptr_add %arg3, %arg15 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2289 = waveamd.make_buffer %2288, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2290 = wave.ptr_add %2289, %137 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_288, %token_289 = wave.load %2290 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2291 = wave.ptr_add %2289, %139 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_290, %token_291 = wave.load %2291 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2292 = wave.ptr_add %2289, %141 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_292, %token_293 = wave.load %2292 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2293 = wave.ptr_add %2289, %143 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_294, %token_295 = wave.load %2293 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2294 = wave.ptr_add %2289, %145 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_296, %token_297 = wave.load %2294 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2295 = wave.ptr_add %2289, %147 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_298, %token_299 = wave.load %2295 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2296 = wave.ptr_add %2289, %149 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_300, %token_301 = wave.load %2296 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2297 = wave.ptr_add %2289, %151 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_302, %token_303 = wave.load %2297 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2298 = wave.ptr_add %arg4, %arg16 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2299 = waveamd.make_buffer %2298, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2300 = wave.ptr_add %2299, %158 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_304, %token_305 = wave.load %2300 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2301 = wave.ptr_add %2299, %160 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_306, %token_307 = wave.load %2301 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2302 = wave.ptr_add %2299, %162 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_308, %token_309 = wave.load %2302 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2303 = wave.ptr_add %2299, %164 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_310, %token_311 = wave.load %2303 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2304 = wave.join %2276, %2287 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2305 = waveamd.fragment_pack %value_270 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2306 = waveamd.fragment_pack %value_272 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2307 = waveamd.fragment_pack %value_274 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2308 = waveamd.fragment_pack %value_276 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2309 = waveamd.fragment_pack %value_278 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2310 = waveamd.fragment_pack %value_280 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2311 = waveamd.fragment_pack %value_282 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2312 = waveamd.fragment_pack %value_284 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2313 = waveamd.fragment_pack %arg49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2314 = waveamd.fragment_pack %arg50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2315 = waveamd.fragment_pack %arg51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2316 = waveamd.fragment_pack %arg52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2317 = waveamd.fragment_pack %arg53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2318 = waveamd.fragment_pack %arg54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2319 = waveamd.fragment_pack %arg55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2320 = waveamd.fragment_pack %arg56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2321 = waveamd.fragment_pack %arg57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2322 = waveamd.fragment_pack %arg58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2323 = waveamd.fragment_pack %arg59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2324 = waveamd.fragment_pack %arg60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2325 = waveamd.fragment_pack %arg61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2326 = waveamd.fragment_pack %arg62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2327 = waveamd.fragment_pack %arg63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2328 = waveamd.fragment_pack %arg64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2329 = waveamd.fragment_pack %arg65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2330 = waveamd.fragment_pack %arg66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2331 = waveamd.fragment_pack %arg67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2332 = waveamd.fragment_pack %arg68 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2333 = waveamd.fragment_pack %arg69 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2334 = waveamd.fragment_pack %arg70 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2335 = waveamd.fragment_pack %arg71 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2336 = waveamd.fragment_pack %arg72 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2337 = waveamd.fragment_pack %arg73 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2338 = waveamd.fragment_pack %arg74 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2339 = waveamd.fragment_pack %arg75 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2340 = waveamd.fragment_pack %arg76 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2341 = waveamd.fragment_pack %arg77 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2342 = waveamd.fragment_pack %arg78 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2343 = waveamd.fragment_pack %arg79 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2344 = waveamd.fragment_pack %arg80 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2345 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2305, %value_286, %2072, %2128, %2313 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2346 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2306, %value_286, %2073, %2128, %2345 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2347 = waveamd.fragment_unpack %2346 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2348 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2307, %value_286, %2072, %2128, %2314 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2349 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2308, %value_286, %2073, %2128, %2348 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2350 = waveamd.fragment_unpack %2349 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2351 = wave.extract %value_286[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2352 = wave.extract %value_286[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2353 = wave.extract %value_286[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2354 = wave.extract %value_286[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2355 = wave.extract %value_286[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2356 = wave.extract %value_286[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2357 = wave.extract %value_286[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2358 = wave.extract %value_286[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2359 = wave.pack %2351, %2352, %2353, %2354, %2355, %2356, %2357, %2358 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2360 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2309, %2359, %2072, %2128, %2315 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2361 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2310, %2359, %2073, %2128, %2360 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2362 = waveamd.fragment_unpack %2361 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2363 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2311, %2359, %2072, %2128, %2316 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2364 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2312, %2359, %2073, %2128, %2363 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2365 = waveamd.fragment_unpack %2364 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2366 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2305, %value_286, %2074, %2128, %2317 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2367 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2306, %value_286, %2075, %2128, %2366 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2368 = waveamd.fragment_unpack %2367 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2369 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2307, %value_286, %2074, %2128, %2318 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2370 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2308, %value_286, %2075, %2128, %2369 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2371 = waveamd.fragment_unpack %2370 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2372 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2309, %2359, %2074, %2128, %2319 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2373 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2310, %2359, %2075, %2128, %2372 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2374 = waveamd.fragment_unpack %2373 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2375 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2311, %2359, %2074, %2128, %2320 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2376 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2312, %2359, %2075, %2128, %2375 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2377 = waveamd.fragment_unpack %2376 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2378 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2305, %value_286, %2076, %2129, %2321 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2379 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2306, %value_286, %2077, %2129, %2378 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2380 = waveamd.fragment_unpack %2379 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2381 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2307, %value_286, %2076, %2129, %2322 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2382 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2308, %value_286, %2077, %2129, %2381 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2383 = waveamd.fragment_unpack %2382 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2384 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2309, %2359, %2076, %2129, %2323 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2385 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2310, %2359, %2077, %2129, %2384 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2386 = waveamd.fragment_unpack %2385 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2387 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2311, %2359, %2076, %2129, %2324 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2388 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2312, %2359, %2077, %2129, %2387 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2389 = waveamd.fragment_unpack %2388 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2390 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2305, %value_286, %2078, %2129, %2325 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2391 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2306, %value_286, %2079, %2129, %2390 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2392 = waveamd.fragment_unpack %2391 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2393 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2307, %value_286, %2078, %2129, %2326 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2394 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2308, %value_286, %2079, %2129, %2393 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2395 = waveamd.fragment_unpack %2394 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2396 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2309, %2359, %2078, %2129, %2327 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2397 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2310, %2359, %2079, %2129, %2396 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2398 = waveamd.fragment_unpack %2397 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2399 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2311, %2359, %2078, %2129, %2328 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2400 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2312, %2359, %2079, %2129, %2399 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2401 = waveamd.fragment_unpack %2400 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2402 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2305, %value_286, %2080, %2130, %2329 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2403 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2306, %value_286, %2081, %2130, %2402 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2404 = waveamd.fragment_unpack %2403 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2405 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2307, %value_286, %2080, %2130, %2330 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2406 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2308, %value_286, %2081, %2130, %2405 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2407 = waveamd.fragment_unpack %2406 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2408 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2309, %2359, %2080, %2130, %2331 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2409 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2310, %2359, %2081, %2130, %2408 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2410 = waveamd.fragment_unpack %2409 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2411 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2311, %2359, %2080, %2130, %2332 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2412 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2312, %2359, %2081, %2130, %2411 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2413 = waveamd.fragment_unpack %2412 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2414 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2305, %value_286, %2082, %2130, %2333 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2415 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2306, %value_286, %2083, %2130, %2414 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2416 = waveamd.fragment_unpack %2415 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2417 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2307, %value_286, %2082, %2130, %2334 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2418 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2308, %value_286, %2083, %2130, %2417 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2419 = waveamd.fragment_unpack %2418 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2420 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2309, %2359, %2082, %2130, %2335 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2421 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2310, %2359, %2083, %2130, %2420 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2422 = waveamd.fragment_unpack %2421 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2423 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2311, %2359, %2082, %2130, %2336 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2424 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2312, %2359, %2083, %2130, %2423 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2425 = waveamd.fragment_unpack %2424 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2426 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2305, %value_286, %2084, %2131, %2337 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2427 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2306, %value_286, %2085, %2131, %2426 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2428 = waveamd.fragment_unpack %2427 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2429 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2307, %value_286, %2084, %2131, %2338 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2430 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2308, %value_286, %2085, %2131, %2429 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2431 = waveamd.fragment_unpack %2430 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2432 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2309, %2359, %2084, %2131, %2339 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2433 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2310, %2359, %2085, %2131, %2432 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2434 = waveamd.fragment_unpack %2433 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2435 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2311, %2359, %2084, %2131, %2340 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2436 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2312, %2359, %2085, %2131, %2435 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2437 = waveamd.fragment_unpack %2436 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2438 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2305, %value_286, %2086, %2131, %2341 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2439 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2306, %value_286, %2087, %2131, %2438 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2440 = waveamd.fragment_unpack %2439 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2441 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2307, %value_286, %2086, %2131, %2342 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2442 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2308, %value_286, %2087, %2131, %2441 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2443 = waveamd.fragment_unpack %2442 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2444 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2309, %2359, %2086, %2131, %2343 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2445 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2310, %2359, %2087, %2131, %2444 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2446 = waveamd.fragment_unpack %2445 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2447 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2311, %2359, %2086, %2131, %2344 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2448 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2312, %2359, %2087, %2131, %2447 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2449 = waveamd.fragment_unpack %2448 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg150 : !wave.mem.token
        %2450 = wave.barrier %arg150 : (!wave.mem.token) -> !wave.mem.token
        %2451 = wave.ptr_add %202, %343 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_312, %token_313 = wave.load %2451 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2452 = wave.ptr_add %202, %345 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_314, %token_315 = wave.load %2452 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2453 = wave.ptr_add %202, %347 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_316, %token_317 = wave.load %2453 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2454 = wave.ptr_add %202, %349 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_318, %token_319 = wave.load %2454 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2455 = wave.ptr_add %202, %351 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_320, %token_321 = wave.load %2455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2456 = wave.ptr_add %202, %353 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_322, %token_323 = wave.load %2456 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2457 = wave.ptr_add %202, %355 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_324, %token_325 = wave.load %2457 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2458 = wave.ptr_add %202, %357 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_326, %token_327 = wave.load %2458 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2459 = wave.ptr_add %202, %359 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_328, %token_329 = wave.load %2459 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2460 = wave.ptr_add %202, %361 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_330, %token_331 = wave.load %2460 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2461 = wave.ptr_add %202, %363 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_332, %token_333 = wave.load %2461 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2462 = wave.ptr_add %202, %365 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_334, %token_335 = wave.load %2462 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2463 = wave.ptr_add %202, %367 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_336, %token_337 = wave.load %2463 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2464 = wave.ptr_add %202, %369 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_338, %token_339 = wave.load %2464 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2465 = wave.ptr_add %202, %371 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_340, %token_341 = wave.load %2465 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2466 = wave.ptr_add %202, %373 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_342, %token_343 = wave.load %2466 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2467 = wave.ptr_add %245, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_344, %token_345 = wave.load %2467 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2468 = wave.ptr_add %245, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_346, %token_347 = wave.load %2468 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2469 = wave.ptr_add %245, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_348, %token_349 = wave.load %2469 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2470 = wave.ptr_add %245, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_350, %token_351 = wave.load %2470 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2471 = wave.ptr_add %245, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_352, %token_353 = wave.load %2471 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2472 = wave.ptr_add %245, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_354, %token_355 = wave.load %2472 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2473 = wave.ptr_add %245, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_356, %token_357 = wave.load %2473 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2474 = wave.ptr_add %245, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_358, %token_359 = wave.load %2474 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2475 = wave.binary muli %410, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2476 = wave.binary muli %412, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2477 = wave.binary xori %2475, %2476 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2478 = wave.binary muli %416, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2479 = wave.binary xori %2477, %2478 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2480 = wave.binary muli %393, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2481 = wave.binary xori %2479, %2480 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2482 = wave.binary muli %395, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2483 = wave.binary xori %2481, %2482 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2484 = wave.binary muli %2251, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2485 = wave.binary addi %2484, %2483 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2486 = wave.pack %arg85, %arg86, %arg87, %arg88, %arg89, %arg90, %arg91, %arg92 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2487 = wave.ptr_add %391, %2485 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2488 = wave.store %2486 -> %2487 after %token_287 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2489 = wave.barrier %2488 : (!wave.mem.token) -> !wave.mem.token
        %2490 = wave.pack %arg93, %arg94, %arg95, %arg96 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2491 = wave.store %2490 -> %2255 after %2489 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2492 = wave.barrier %2491 : (!wave.mem.token) -> !wave.mem.token
        %value_360, %token_361 = waveamd.transpose_load %496 after %2492 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %value_362, %token_363 = waveamd.transpose_load %506 after %2492 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2493 = wave.join %token_361, %token_363 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_364, %token_365 = waveamd.transpose_load %517 after %2493 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2494 = wave.ptr_add %2278, %170 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2495 = waveamd.dma_load_lds %2494 -> %172 after %arg150 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2496 = wave.ptr_add %2278, %175 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2497 = waveamd.dma_load_lds %2496 -> %177 after %arg150 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2498 = wave.ptr_add %2278, %180 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2499 = waveamd.dma_load_lds %2498 -> %182 after %arg150 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2500 = wave.ptr_add %2278, %185 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2501 = waveamd.dma_load_lds %2500 -> %187 after %arg150 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2502 = wave.join %2495, %2497, %2499, %2501 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2503 = wave.ptr_add %2299, %194 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_366, %token_367 = wave.load %2503 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2504 = wave.ptr_add %2299, %196 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_368, %token_369 = wave.load %2504 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2505 = wave.ptr_add %2299, %198 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_370, %token_371 = wave.load %2505 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2506 = wave.ptr_add %2299, %200 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_372, %token_373 = wave.load %2506 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2507 = waveamd.fragment_pack %value_312 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2508 = waveamd.fragment_pack %value_314 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2509 = waveamd.fragment_pack %value_316 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2510 = waveamd.fragment_pack %value_318 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2511 = waveamd.fragment_pack %value_320 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2512 = waveamd.fragment_pack %value_322 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2513 = waveamd.fragment_pack %value_324 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2514 = waveamd.fragment_pack %value_326 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2515 = waveamd.fragment_pack %value_328 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2516 = waveamd.fragment_pack %value_330 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2517 = waveamd.fragment_pack %value_332 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2518 = waveamd.fragment_pack %value_334 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2519 = waveamd.fragment_pack %value_336 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2520 = waveamd.fragment_pack %value_338 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2521 = waveamd.fragment_pack %value_340 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2522 = waveamd.fragment_pack %value_342 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2523 = waveamd.fragment_pack %value_344 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2524 = waveamd.fragment_pack %value_346 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2525 = waveamd.fragment_pack %value_348 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2526 = waveamd.fragment_pack %value_350 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2527 = waveamd.fragment_pack %value_352 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2528 = waveamd.fragment_pack %value_354 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2529 = waveamd.fragment_pack %value_356 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2530 = waveamd.fragment_pack %value_358 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2531 = waveamd.fragment_pack %2136 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2532 = waveamd.fragment_pack %2139 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2533 = waveamd.fragment_pack %2142 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2534 = waveamd.fragment_pack %2145 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2535 = waveamd.fragment_pack %2148 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2536 = waveamd.fragment_pack %2151 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2537 = waveamd.fragment_pack %2154 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2538 = waveamd.fragment_pack %2157 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2539 = waveamd.fragment_pack %2160 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2540 = waveamd.fragment_pack %2163 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2541 = waveamd.fragment_pack %2166 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2542 = waveamd.fragment_pack %2169 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2543 = waveamd.fragment_pack %2172 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2544 = waveamd.fragment_pack %2175 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2545 = waveamd.fragment_pack %2178 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2546 = waveamd.fragment_pack %2181 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2547 = waveamd.fragment_pack %2184 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2548 = waveamd.fragment_pack %2187 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2549 = waveamd.fragment_pack %2190 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2550 = waveamd.fragment_pack %2193 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2551 = waveamd.fragment_pack %2196 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2552 = waveamd.fragment_pack %2199 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2553 = waveamd.fragment_pack %2202 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2554 = waveamd.fragment_pack %2205 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2555 = waveamd.fragment_pack %2208 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2556 = waveamd.fragment_pack %2211 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2557 = waveamd.fragment_pack %2214 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2558 = waveamd.fragment_pack %2217 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2559 = waveamd.fragment_pack %2220 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2560 = waveamd.fragment_pack %2223 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2561 = waveamd.fragment_pack %2226 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2562 = waveamd.fragment_pack %2229 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2563 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2523, %value_364, %2507, %value_360, %2531 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2564 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2524, %value_364, %2508, %value_360, %2563 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2565 = waveamd.fragment_unpack %2564 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2566 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2525, %value_364, %2507, %value_360, %2532 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2567 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2526, %value_364, %2508, %value_360, %2566 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2568 = waveamd.fragment_unpack %2567 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2569 = wave.extract %value_364[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2570 = wave.extract %value_364[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2571 = wave.extract %value_364[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2572 = wave.extract %value_364[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2573 = wave.extract %value_364[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2574 = wave.extract %value_364[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2575 = wave.extract %value_364[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2576 = wave.extract %value_364[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2577 = wave.pack %2569, %2570, %2571, %2572, %2573, %2574, %2575, %2576 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2578 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2527, %2577, %2507, %value_360, %2533 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2579 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2528, %2577, %2508, %value_360, %2578 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2580 = waveamd.fragment_unpack %2579 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2581 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2529, %2577, %2507, %value_360, %2534 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2582 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2530, %2577, %2508, %value_360, %2581 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2583 = waveamd.fragment_unpack %2582 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2584 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2523, %value_364, %2509, %value_360, %2535 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2585 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2524, %value_364, %2510, %value_360, %2584 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2586 = waveamd.fragment_unpack %2585 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2587 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2525, %value_364, %2509, %value_360, %2536 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2588 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2526, %value_364, %2510, %value_360, %2587 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2589 = waveamd.fragment_unpack %2588 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2527, %2577, %2509, %value_360, %2537 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2591 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2528, %2577, %2510, %value_360, %2590 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2592 = waveamd.fragment_unpack %2591 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2529, %2577, %2509, %value_360, %2538 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2594 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2530, %2577, %2510, %value_360, %2593 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2595 = waveamd.fragment_unpack %2594 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2596 = wave.extract %value_360[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2597 = wave.extract %value_360[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2598 = wave.extract %value_360[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2599 = wave.extract %value_360[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2600 = wave.extract %value_360[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2601 = wave.extract %value_360[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2602 = wave.extract %value_360[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2603 = wave.extract %value_360[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2604 = wave.pack %2596, %2597, %2598, %2599, %2600, %2601, %2602, %2603 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2523, %value_364, %2511, %2604, %2539 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2606 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2524, %value_364, %2512, %2604, %2605 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2607 = waveamd.fragment_unpack %2606 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2608 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2525, %value_364, %2511, %2604, %2540 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2609 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2526, %value_364, %2512, %2604, %2608 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2610 = waveamd.fragment_unpack %2609 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2611 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2527, %2577, %2511, %2604, %2541 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2612 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2528, %2577, %2512, %2604, %2611 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2613 = waveamd.fragment_unpack %2612 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2614 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2529, %2577, %2511, %2604, %2542 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2615 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2530, %2577, %2512, %2604, %2614 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2616 = waveamd.fragment_unpack %2615 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2617 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2523, %value_364, %2513, %2604, %2543 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2618 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2524, %value_364, %2514, %2604, %2617 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2619 = waveamd.fragment_unpack %2618 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2620 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2525, %value_364, %2513, %2604, %2544 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2621 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2526, %value_364, %2514, %2604, %2620 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2622 = waveamd.fragment_unpack %2621 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2623 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2527, %2577, %2513, %2604, %2545 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2624 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2528, %2577, %2514, %2604, %2623 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2625 = waveamd.fragment_unpack %2624 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2626 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2529, %2577, %2513, %2604, %2546 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2627 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2530, %2577, %2514, %2604, %2626 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2628 = waveamd.fragment_unpack %2627 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2629 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2523, %value_364, %2515, %value_362, %2547 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2630 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2524, %value_364, %2516, %value_362, %2629 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2631 = waveamd.fragment_unpack %2630 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2632 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2525, %value_364, %2515, %value_362, %2548 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2633 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2526, %value_364, %2516, %value_362, %2632 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2634 = waveamd.fragment_unpack %2633 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2635 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2527, %2577, %2515, %value_362, %2549 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2636 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2528, %2577, %2516, %value_362, %2635 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2637 = waveamd.fragment_unpack %2636 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2638 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2529, %2577, %2515, %value_362, %2550 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2639 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2530, %2577, %2516, %value_362, %2638 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2640 = waveamd.fragment_unpack %2639 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2641 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2523, %value_364, %2517, %value_362, %2551 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2642 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2524, %value_364, %2518, %value_362, %2641 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2643 = waveamd.fragment_unpack %2642 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2644 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2525, %value_364, %2517, %value_362, %2552 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2645 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2526, %value_364, %2518, %value_362, %2644 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2646 = waveamd.fragment_unpack %2645 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2647 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2527, %2577, %2517, %value_362, %2553 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2648 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2528, %2577, %2518, %value_362, %2647 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2649 = waveamd.fragment_unpack %2648 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2650 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2529, %2577, %2517, %value_362, %2554 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2651 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2530, %2577, %2518, %value_362, %2650 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2652 = waveamd.fragment_unpack %2651 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2653 = wave.extract %value_362[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2654 = wave.extract %value_362[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2655 = wave.extract %value_362[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2656 = wave.extract %value_362[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2657 = wave.extract %value_362[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2658 = wave.extract %value_362[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2659 = wave.extract %value_362[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2660 = wave.extract %value_362[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2661 = wave.pack %2653, %2654, %2655, %2656, %2657, %2658, %2659, %2660 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2662 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2523, %value_364, %2519, %2661, %2555 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2663 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2524, %value_364, %2520, %2661, %2662 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2664 = waveamd.fragment_unpack %2663 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2665 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2525, %value_364, %2519, %2661, %2556 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2666 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2526, %value_364, %2520, %2661, %2665 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2667 = waveamd.fragment_unpack %2666 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2668 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2527, %2577, %2519, %2661, %2557 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2669 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2528, %2577, %2520, %2661, %2668 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2670 = waveamd.fragment_unpack %2669 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2671 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2529, %2577, %2519, %2661, %2558 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2672 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2530, %2577, %2520, %2661, %2671 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2673 = waveamd.fragment_unpack %2672 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2674 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2523, %value_364, %2521, %2661, %2559 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2675 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2524, %value_364, %2522, %2661, %2674 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2676 = waveamd.fragment_unpack %2675 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2677 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2525, %value_364, %2521, %2661, %2560 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2678 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2526, %value_364, %2522, %2661, %2677 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2679 = waveamd.fragment_unpack %2678 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2680 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2527, %2577, %2521, %2661, %2561 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2681 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2528, %2577, %2522, %2661, %2680 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2682 = waveamd.fragment_unpack %2681 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2683 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2529, %2577, %2521, %2661, %2562 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2684 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2530, %2577, %2522, %2661, %2683 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2685 = waveamd.fragment_unpack %2684 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg151 : !wave.mem.token
        %2686 = wave.barrier %arg151 : (!wave.mem.token) -> !wave.mem.token
        %2687 = wave.ptr_add %305, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_374, %token_375 = wave.load %2687 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2688 = wave.ptr_add %305, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_376, %token_377 = wave.load %2688 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2689 = wave.ptr_add %305, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_378, %token_379 = wave.load %2689 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2690 = wave.ptr_add %305, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_380, %token_381 = wave.load %2690 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2691 = wave.ptr_add %305, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_382, %token_383 = wave.load %2691 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2692 = wave.ptr_add %305, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_384, %token_385 = wave.load %2692 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2693 = wave.ptr_add %305, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_386, %token_387 = wave.load %2693 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2694 = wave.ptr_add %305, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_388, %token_389 = wave.load %2694 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2695 = wave.pack %arg97, %arg98, %arg99, %arg100 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2696 = wave.store %2695 -> %2255 after %token_365 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2697 = wave.barrier %2696 : (!wave.mem.token) -> !wave.mem.token
        %value_390, %token_391 = waveamd.transpose_load %517 after %2697 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2698 = wave.ptr_add %2259, %205 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2699 = waveamd.dma_load_lds %2698 -> %207 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2700 = wave.ptr_add %2259, %210 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2701 = waveamd.dma_load_lds %2700 -> %212 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2702 = wave.ptr_add %2259, %215 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2703 = waveamd.dma_load_lds %2702 -> %217 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2704 = wave.ptr_add %2259, %220 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2705 = waveamd.dma_load_lds %2704 -> %222 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2706 = wave.ptr_add %2259, %225 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2707 = waveamd.dma_load_lds %2706 -> %227 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2708 = wave.ptr_add %2259, %230 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2709 = waveamd.dma_load_lds %2708 -> %232 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2710 = wave.ptr_add %2259, %235 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2711 = waveamd.dma_load_lds %2710 -> %237 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2712 = wave.ptr_add %2259, %240 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2713 = waveamd.dma_load_lds %2712 -> %242 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2714 = wave.join %2699, %2701, %2703, %2705, %2707, %2709, %2711, %2713 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2715 = wave.ptr_add %2278, %248 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2716 = waveamd.dma_load_lds %2715 -> %250 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2717 = wave.ptr_add %2278, %253 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2718 = waveamd.dma_load_lds %2717 -> %255 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2719 = wave.ptr_add %2278, %258 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2720 = waveamd.dma_load_lds %2719 -> %260 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2721 = wave.ptr_add %2278, %263 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2722 = waveamd.dma_load_lds %2721 -> %265 after %arg151 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2723 = wave.join %2716, %2718, %2720, %2722 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2724 = wave.ptr_add %2289, %276 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_392, %token_393 = wave.load %2724 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2725 = wave.ptr_add %2289, %278 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_394, %token_395 = wave.load %2725 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2726 = wave.ptr_add %2289, %280 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_396, %token_397 = wave.load %2726 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2727 = wave.ptr_add %2289, %282 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_398, %token_399 = wave.load %2727 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2728 = wave.ptr_add %2289, %284 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_400, %token_401 = wave.load %2728 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2729 = wave.ptr_add %2289, %286 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_402, %token_403 = wave.load %2729 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2730 = wave.ptr_add %2289, %288 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_404, %token_405 = wave.load %2730 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2731 = wave.ptr_add %2289, %290 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_406, %token_407 = wave.load %2731 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2732 = wave.ptr_add %2299, %296 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_408, %token_409 = wave.load %2732 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2733 = wave.ptr_add %2299, %298 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_410, %token_411 = wave.load %2733 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2734 = wave.ptr_add %2299, %300 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_412, %token_413 = wave.load %2734 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2735 = wave.ptr_add %2299, %302 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_414, %token_415 = wave.load %2735 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2736 = wave.join %2714, %2723 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2737 = waveamd.fragment_pack %value_374 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2738 = waveamd.fragment_pack %value_376 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2739 = waveamd.fragment_pack %value_378 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2740 = waveamd.fragment_pack %value_380 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2741 = waveamd.fragment_pack %value_382 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2742 = waveamd.fragment_pack %value_384 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2743 = waveamd.fragment_pack %value_386 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2744 = waveamd.fragment_pack %value_388 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2745 = waveamd.fragment_pack %2347 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2746 = waveamd.fragment_pack %2350 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2747 = waveamd.fragment_pack %2362 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2748 = waveamd.fragment_pack %2365 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2749 = waveamd.fragment_pack %2368 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2750 = waveamd.fragment_pack %2371 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2751 = waveamd.fragment_pack %2374 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2752 = waveamd.fragment_pack %2377 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2753 = waveamd.fragment_pack %2380 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2754 = waveamd.fragment_pack %2383 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2755 = waveamd.fragment_pack %2386 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2756 = waveamd.fragment_pack %2389 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2757 = waveamd.fragment_pack %2392 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2758 = waveamd.fragment_pack %2395 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2759 = waveamd.fragment_pack %2398 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2760 = waveamd.fragment_pack %2401 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2761 = waveamd.fragment_pack %2404 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2762 = waveamd.fragment_pack %2407 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2763 = waveamd.fragment_pack %2410 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2764 = waveamd.fragment_pack %2413 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2765 = waveamd.fragment_pack %2416 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2766 = waveamd.fragment_pack %2419 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2767 = waveamd.fragment_pack %2422 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2768 = waveamd.fragment_pack %2425 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2769 = waveamd.fragment_pack %2428 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2770 = waveamd.fragment_pack %2431 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2771 = waveamd.fragment_pack %2434 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2772 = waveamd.fragment_pack %2437 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2773 = waveamd.fragment_pack %2440 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2774 = waveamd.fragment_pack %2443 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2775 = waveamd.fragment_pack %2446 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2776 = waveamd.fragment_pack %2449 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2777 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2737, %value_390, %2507, %value_360, %2745 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2778 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2738, %value_390, %2508, %value_360, %2777 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2779 = waveamd.fragment_unpack %2778 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2780 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2739, %value_390, %2507, %value_360, %2746 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2781 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2740, %value_390, %2508, %value_360, %2780 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2782 = waveamd.fragment_unpack %2781 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2783 = wave.extract %value_390[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2784 = wave.extract %value_390[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2785 = wave.extract %value_390[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2786 = wave.extract %value_390[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2787 = wave.extract %value_390[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2788 = wave.extract %value_390[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2789 = wave.extract %value_390[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2790 = wave.extract %value_390[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2791 = wave.pack %2783, %2784, %2785, %2786, %2787, %2788, %2789, %2790 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2792 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2741, %2791, %2507, %value_360, %2747 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2793 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2742, %2791, %2508, %value_360, %2792 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2794 = waveamd.fragment_unpack %2793 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2795 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2743, %2791, %2507, %value_360, %2748 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2796 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2744, %2791, %2508, %value_360, %2795 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2797 = waveamd.fragment_unpack %2796 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2798 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2737, %value_390, %2509, %value_360, %2749 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2799 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2738, %value_390, %2510, %value_360, %2798 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2800 = waveamd.fragment_unpack %2799 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2801 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2739, %value_390, %2509, %value_360, %2750 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2802 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2740, %value_390, %2510, %value_360, %2801 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2803 = waveamd.fragment_unpack %2802 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2804 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2741, %2791, %2509, %value_360, %2751 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2805 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2742, %2791, %2510, %value_360, %2804 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2806 = waveamd.fragment_unpack %2805 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2807 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2743, %2791, %2509, %value_360, %2752 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2808 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2744, %2791, %2510, %value_360, %2807 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2809 = waveamd.fragment_unpack %2808 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2810 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2737, %value_390, %2511, %2604, %2753 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2811 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2738, %value_390, %2512, %2604, %2810 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2812 = waveamd.fragment_unpack %2811 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2813 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2739, %value_390, %2511, %2604, %2754 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2814 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2740, %value_390, %2512, %2604, %2813 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2815 = waveamd.fragment_unpack %2814 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2816 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2741, %2791, %2511, %2604, %2755 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2817 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2742, %2791, %2512, %2604, %2816 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2818 = waveamd.fragment_unpack %2817 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2819 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2743, %2791, %2511, %2604, %2756 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2820 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2744, %2791, %2512, %2604, %2819 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2821 = waveamd.fragment_unpack %2820 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2822 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2737, %value_390, %2513, %2604, %2757 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2823 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2738, %value_390, %2514, %2604, %2822 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2824 = waveamd.fragment_unpack %2823 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2825 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2739, %value_390, %2513, %2604, %2758 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2826 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2740, %value_390, %2514, %2604, %2825 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2827 = waveamd.fragment_unpack %2826 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2828 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2741, %2791, %2513, %2604, %2759 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2829 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2742, %2791, %2514, %2604, %2828 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2830 = waveamd.fragment_unpack %2829 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2831 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2743, %2791, %2513, %2604, %2760 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2832 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2744, %2791, %2514, %2604, %2831 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2833 = waveamd.fragment_unpack %2832 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2834 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2737, %value_390, %2515, %value_362, %2761 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2835 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2738, %value_390, %2516, %value_362, %2834 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2836 = waveamd.fragment_unpack %2835 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2837 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2739, %value_390, %2515, %value_362, %2762 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2838 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2740, %value_390, %2516, %value_362, %2837 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2839 = waveamd.fragment_unpack %2838 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2840 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2741, %2791, %2515, %value_362, %2763 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2841 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2742, %2791, %2516, %value_362, %2840 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2842 = waveamd.fragment_unpack %2841 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2843 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2743, %2791, %2515, %value_362, %2764 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2844 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2744, %2791, %2516, %value_362, %2843 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2845 = waveamd.fragment_unpack %2844 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2846 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2737, %value_390, %2517, %value_362, %2765 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2847 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2738, %value_390, %2518, %value_362, %2846 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2848 = waveamd.fragment_unpack %2847 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2849 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2739, %value_390, %2517, %value_362, %2766 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2850 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2740, %value_390, %2518, %value_362, %2849 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2851 = waveamd.fragment_unpack %2850 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2852 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2741, %2791, %2517, %value_362, %2767 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2853 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2742, %2791, %2518, %value_362, %2852 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2854 = waveamd.fragment_unpack %2853 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2855 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2743, %2791, %2517, %value_362, %2768 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2856 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2744, %2791, %2518, %value_362, %2855 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2857 = waveamd.fragment_unpack %2856 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2858 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2737, %value_390, %2519, %2661, %2769 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2859 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2738, %value_390, %2520, %2661, %2858 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2860 = waveamd.fragment_unpack %2859 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2861 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2739, %value_390, %2519, %2661, %2770 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2862 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2740, %value_390, %2520, %2661, %2861 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2863 = waveamd.fragment_unpack %2862 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2864 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2741, %2791, %2519, %2661, %2771 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2865 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2742, %2791, %2520, %2661, %2864 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2866 = waveamd.fragment_unpack %2865 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2867 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2743, %2791, %2519, %2661, %2772 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2868 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2744, %2791, %2520, %2661, %2867 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2869 = waveamd.fragment_unpack %2868 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2870 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2737, %value_390, %2521, %2661, %2773 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2871 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2738, %value_390, %2522, %2661, %2870 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2872 = waveamd.fragment_unpack %2871 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2873 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2739, %value_390, %2521, %2661, %2774 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2874 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2740, %value_390, %2522, %2661, %2873 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2875 = waveamd.fragment_unpack %2874 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2876 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2741, %2791, %2521, %2661, %2775 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2877 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2742, %2791, %2522, %2661, %2876 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2878 = waveamd.fragment_unpack %2877 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2879 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2743, %2791, %2521, %2661, %2776 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2880 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2744, %2791, %2522, %2661, %2879 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2881 = waveamd.fragment_unpack %2880 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %2304 : !wave.mem.token
        %2882 = wave.barrier %2304 : (!wave.mem.token) -> !wave.mem.token
        %value_416, %token_417 = wave.load %344 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_418, %token_419 = wave.load %346 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_420, %token_421 = wave.load %348 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_422, %token_423 = wave.load %350 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_424, %token_425 = wave.load %352 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_426, %token_427 = wave.load %354 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_428, %token_429 = wave.load %356 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_430, %token_431 = wave.load %358 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_432, %token_433 = wave.load %360 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_434, %token_435 = wave.load %362 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_436, %token_437 = wave.load %364 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_438, %token_439 = wave.load %366 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_440, %token_441 = wave.load %368 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_442, %token_443 = wave.load %370 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_444, %token_445 = wave.load %372 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_446, %token_447 = wave.load %374 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_448, %token_449 = wave.load %376 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_450, %token_451 = wave.load %378 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_452, %token_453 = wave.load %380 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_454, %token_455 = wave.load %382 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_456, %token_457 = wave.load %384 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_458, %token_459 = wave.load %386 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_460, %token_461 = wave.load %388 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_462, %token_463 = wave.load %390 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2883 = wave.store %value_288 -> %463 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2884 = wave.store %value_290 -> %465 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2885 = wave.store %value_292 -> %467 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2886 = wave.store %value_294 -> %469 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2887 = wave.store %value_296 -> %471 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2888 = wave.store %value_298 -> %473 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2889 = wave.store %value_300 -> %475 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2890 = wave.store %value_302 -> %477 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2891 = wave.barrier %2883, %2884, %2885, %2886, %2887, %2888, %2889, %2890 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %2892 = wave.store %value_304 -> %486 after %2891 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2893 = wave.store %value_306 -> %488 after %2891 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2894 = wave.store %value_308 -> %490 after %2891 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2895 = wave.store %value_310 -> %492 after %2891 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2896 = wave.barrier %2892, %2893, %2894, %2895 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %value_464, %token_465 = waveamd.transpose_load %496 after %2896 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2897 = wave.extract %value_464[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2898 = wave.extract %value_464[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2899 = wave.extract %value_464[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2900 = wave.extract %value_464[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2901 = wave.extract %value_464[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2902 = wave.extract %value_464[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2903 = wave.extract %value_464[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2904 = wave.extract %value_464[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %value_466, %token_467 = waveamd.transpose_load %506 after %2896 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2905 = wave.extract %value_466[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2906 = wave.extract %value_466[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2907 = wave.extract %value_466[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2908 = wave.extract %value_466[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2909 = wave.extract %value_466[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2910 = wave.extract %value_466[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2911 = wave.extract %value_466[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2912 = wave.extract %value_466[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2913 = wave.join %token_465, %token_467 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_468, %token_469 = waveamd.transpose_load %517 after %2913 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2914 = wave.extract %value_468[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2915 = wave.extract %value_468[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2916 = wave.extract %value_468[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2917 = wave.extract %value_468[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2918 = wave.extract %value_468[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2919 = wave.extract %value_468[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2920 = wave.extract %value_468[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2921 = wave.extract %value_468[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2922 = wave.ptr_add %2278, %308 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2923 = waveamd.dma_load_lds %2922 -> %310 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2924 = wave.ptr_add %2278, %313 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2925 = waveamd.dma_load_lds %2924 -> %315 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2926 = wave.ptr_add %2278, %318 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2927 = waveamd.dma_load_lds %2926 -> %320 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2928 = wave.ptr_add %2278, %323 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2929 = waveamd.dma_load_lds %2928 -> %325 after %54 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2930 = wave.join %2923, %2925, %2927, %2929 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2931 = wave.ptr_add %2299, %332 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_470, %token_471 = wave.load %2931 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2932 = wave.ptr_add %2299, %334 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_472, %token_473 = wave.load %2932 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2933 = wave.ptr_add %2299, %336 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_474, %token_475 = wave.load %2933 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2934 = wave.ptr_add %2299, %338 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_476, %token_477 = wave.load %2934 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2935 = wave.binary addi %arg13, %c256_i32 : i32, i32 -> i32
        %2936 = wave.binary addi %arg14, %c256_i32 : i32, i32 -> i32
        %2937 = wave.binary addi %arg15, %c16_i32 : i32, i32 -> i32
        %2938 = wave.binary addi %arg16, %c16_i32 : i32, i32 -> i32
        scf.yield %2935, %2936, %2937, %2938, %2565, %2568, %2580, %2583, %2586, %2589, %2592, %2595, %2607, %2610, %2613, %2616, %2619, %2622, %2625, %2628, %2631, %2634, %2637, %2640, %2643, %2646, %2649, %2652, %2664, %2667, %2670, %2673, %2676, %2679, %2682, %2685, %2779, %2782, %2794, %2797, %2800, %2803, %2806, %2809, %2812, %2815, %2818, %2821, %2824, %2827, %2830, %2833, %2836, %2839, %2842, %2845, %2848, %2851, %2854, %2857, %2860, %2863, %2866, %2869, %2872, %2875, %2878, %2881, %value_366, %value_368, %value_370, %value_372, %value_392, %value_394, %value_396, %value_398, %value_400, %value_402, %value_404, %value_406, %value_408, %value_410, %value_412, %value_414, %value_470, %value_472, %value_474, %value_476, %value_416, %value_418, %value_420, %value_422, %value_424, %value_426, %value_428, %value_430, %value_432, %value_434, %value_436, %value_438, %value_440, %value_442, %value_444, %value_446, %value_448, %value_450, %value_452, %value_454, %value_456, %value_458, %value_460, %value_462, %2897, %2898, %2899, %2900, %2901, %2902, %2903, %2904, %2905, %2906, %2907, %2908, %2909, %2910, %2911, %2912, %2914, %2915, %2916, %2917, %2918, %2919, %2920, %2921, %2502, %2736, %2930 : i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      %527 = waveamd.fragment_pack %526#88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %528 = waveamd.fragment_pack %526#89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %529 = waveamd.fragment_pack %526#90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %530 = waveamd.fragment_pack %526#91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %531 = waveamd.fragment_pack %526#92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %532 = waveamd.fragment_pack %526#93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %533 = waveamd.fragment_pack %526#94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %534 = waveamd.fragment_pack %526#95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %535 = waveamd.fragment_pack %526#96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %536 = waveamd.fragment_pack %526#97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %537 = waveamd.fragment_pack %526#98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %538 = waveamd.fragment_pack %526#99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %539 = waveamd.fragment_pack %526#100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %540 = waveamd.fragment_pack %526#101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %541 = waveamd.fragment_pack %526#102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %542 = waveamd.fragment_pack %526#103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %543 = waveamd.fragment_pack %526#104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %544 = waveamd.fragment_pack %526#105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %545 = waveamd.fragment_pack %526#106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %546 = waveamd.fragment_pack %526#107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %547 = waveamd.fragment_pack %526#108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %548 = waveamd.fragment_pack %526#109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %549 = waveamd.fragment_pack %526#110 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %550 = waveamd.fragment_pack %526#111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %551 = waveamd.fragment_pack %526#4 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %552 = waveamd.fragment_pack %526#5 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %553 = waveamd.fragment_pack %526#6 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %554 = waveamd.fragment_pack %526#7 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %555 = waveamd.fragment_pack %526#8 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %556 = waveamd.fragment_pack %526#9 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %557 = waveamd.fragment_pack %526#10 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %558 = waveamd.fragment_pack %526#11 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %559 = waveamd.fragment_pack %526#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %560 = waveamd.fragment_pack %526#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %561 = waveamd.fragment_pack %526#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %562 = waveamd.fragment_pack %526#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %563 = waveamd.fragment_pack %526#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %564 = waveamd.fragment_pack %526#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %565 = waveamd.fragment_pack %526#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %566 = waveamd.fragment_pack %526#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %567 = waveamd.fragment_pack %526#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %568 = waveamd.fragment_pack %526#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %569 = waveamd.fragment_pack %526#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %570 = waveamd.fragment_pack %526#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %571 = waveamd.fragment_pack %526#24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %572 = waveamd.fragment_pack %526#25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %573 = waveamd.fragment_pack %526#26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %574 = waveamd.fragment_pack %526#27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %575 = waveamd.fragment_pack %526#28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %576 = waveamd.fragment_pack %526#29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %577 = waveamd.fragment_pack %526#30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %578 = waveamd.fragment_pack %526#31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %579 = waveamd.fragment_pack %526#32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %580 = waveamd.fragment_pack %526#33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %581 = waveamd.fragment_pack %526#34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %582 = waveamd.fragment_pack %526#35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %583 = wave.pack %526#112, %526#113, %526#114, %526#115, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %584 = wave.pack %526#116, %526#117, %526#118, %526#119, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %585 = wave.pack %526#120, %526#121, %526#122, %526#123, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %586 = wave.pack %526#124, %526#125, %526#126, %526#127, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %587 = wave.pack %526#128, %526#129, %526#130, %526#131, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %588 = wave.pack %526#132, %526#133, %526#134, %526#135, %15, %15, %15, %15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %587, %527, %583, %551 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %587, %528, %583, %589 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %591 = waveamd.fragment_unpack %590 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %545, %587, %527, %583, %552 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %546, %587, %528, %583, %592 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %594 = waveamd.fragment_unpack %593 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %547, %588, %527, %583, %553 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %588, %528, %583, %595 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %597 = waveamd.fragment_unpack %596 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %588, %527, %583, %554 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %588, %528, %583, %598 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %600 = waveamd.fragment_unpack %599 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %587, %529, %583, %555 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %602 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %587, %530, %583, %601 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %603 = waveamd.fragment_unpack %602 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %545, %587, %529, %583, %556 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %546, %587, %530, %583, %604 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %606 = waveamd.fragment_unpack %605 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %607 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %547, %588, %529, %583, %557 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %608 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %588, %530, %583, %607 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %609 = waveamd.fragment_unpack %608 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %610 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %588, %529, %583, %558 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %611 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %588, %530, %583, %610 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %612 = waveamd.fragment_unpack %611 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %613 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %587, %531, %584, %559 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %614 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %587, %532, %584, %613 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %615 = waveamd.fragment_unpack %614 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %616 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %545, %587, %531, %584, %560 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %617 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %546, %587, %532, %584, %616 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %618 = waveamd.fragment_unpack %617 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %619 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %547, %588, %531, %584, %561 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %620 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %588, %532, %584, %619 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %621 = waveamd.fragment_unpack %620 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %622 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %588, %531, %584, %562 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %623 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %588, %532, %584, %622 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %624 = waveamd.fragment_unpack %623 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %625 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %587, %533, %584, %563 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %626 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %587, %534, %584, %625 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %627 = waveamd.fragment_unpack %626 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %628 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %545, %587, %533, %584, %564 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %629 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %546, %587, %534, %584, %628 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %630 = waveamd.fragment_unpack %629 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %631 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %547, %588, %533, %584, %565 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %632 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %588, %534, %584, %631 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %633 = waveamd.fragment_unpack %632 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %634 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %588, %533, %584, %566 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %635 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %588, %534, %584, %634 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %636 = waveamd.fragment_unpack %635 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %637 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %587, %535, %585, %567 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %638 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %587, %536, %585, %637 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %639 = waveamd.fragment_unpack %638 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %640 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %545, %587, %535, %585, %568 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %641 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %546, %587, %536, %585, %640 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %642 = waveamd.fragment_unpack %641 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %643 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %547, %588, %535, %585, %569 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %644 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %588, %536, %585, %643 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %645 = waveamd.fragment_unpack %644 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %646 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %588, %535, %585, %570 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %647 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %588, %536, %585, %646 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %648 = waveamd.fragment_unpack %647 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %649 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %587, %537, %585, %571 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %650 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %587, %538, %585, %649 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %651 = waveamd.fragment_unpack %650 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %652 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %545, %587, %537, %585, %572 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %653 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %546, %587, %538, %585, %652 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %654 = waveamd.fragment_unpack %653 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %655 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %547, %588, %537, %585, %573 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %656 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %588, %538, %585, %655 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %657 = waveamd.fragment_unpack %656 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %658 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %588, %537, %585, %574 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %659 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %588, %538, %585, %658 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %660 = waveamd.fragment_unpack %659 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %661 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %587, %539, %586, %575 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %662 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %587, %540, %586, %661 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %663 = waveamd.fragment_unpack %662 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %664 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %545, %587, %539, %586, %576 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %665 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %546, %587, %540, %586, %664 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %666 = waveamd.fragment_unpack %665 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %667 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %547, %588, %539, %586, %577 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %668 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %588, %540, %586, %667 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %669 = waveamd.fragment_unpack %668 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %670 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %588, %539, %586, %578 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %671 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %588, %540, %586, %670 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %672 = waveamd.fragment_unpack %671 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %673 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %587, %541, %586, %579 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %674 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %587, %542, %586, %673 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %675 = waveamd.fragment_unpack %674 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %676 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %545, %587, %541, %586, %580 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %677 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %546, %587, %542, %586, %676 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %678 = waveamd.fragment_unpack %677 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %679 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %547, %588, %541, %586, %581 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %680 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %588, %542, %586, %679 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %681 = waveamd.fragment_unpack %680 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %682 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %588, %541, %586, %582 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %683 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %588, %542, %586, %682 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %684 = waveamd.fragment_unpack %683 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      wave.wait %526#136, %526#137, %526#138 : !wave.mem.token, !wave.mem.token, !wave.mem.token
      %685 = wave.barrier %526#136, %526#137, %526#138 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %686 = wave.ptr_add %167, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_116, %token_117 = wave.load %686 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %687 = wave.ptr_add %167, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_118, %token_119 = wave.load %687 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %688 = wave.ptr_add %167, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_120, %token_121 = wave.load %688 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %689 = wave.ptr_add %167, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_122, %token_123 = wave.load %689 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %690 = wave.ptr_add %167, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_124, %token_125 = wave.load %690 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %691 = wave.ptr_add %167, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_126, %token_127 = wave.load %691 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %692 = wave.ptr_add %167, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_128, %token_129 = wave.load %692 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %693 = wave.ptr_add %167, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_130, %token_131 = wave.load %693 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %694 = wave.binary muli %410, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %695 = wave.binary muli %412, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %696 = wave.binary xori %694, %695 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %697 = wave.binary muli %416, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %698 = wave.binary xori %696, %697 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %699 = wave.binary muli %393, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %700 = wave.binary xori %698, %699 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %701 = wave.binary muli %395, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %702 = wave.binary xori %700, %701 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %703 = wave.binary muli %403, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %704 = wave.binary xori %399, %703 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %705 = wave.binary muli %407, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %706 = wave.binary xori %704, %705 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %707 = wave.binary muli %706, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %708 = wave.binary addi %707, %702 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %709 = wave.pack %526#68, %526#69, %526#70, %526#71 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %710 = wave.ptr_add %480, %708 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %711 = wave.store %709 -> %710 after %token_115 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %712 = wave.barrier %711 : (!wave.mem.token) -> !wave.mem.token
      %value_132, %token_133 = waveamd.transpose_load %517 after %712 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %713 = waveamd.fragment_pack %value_116 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %714 = waveamd.fragment_pack %value_118 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %715 = waveamd.fragment_pack %value_120 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %716 = waveamd.fragment_pack %value_122 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %717 = waveamd.fragment_pack %value_124 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %718 = waveamd.fragment_pack %value_126 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %719 = waveamd.fragment_pack %value_128 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %720 = waveamd.fragment_pack %value_130 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %721 = waveamd.fragment_pack %526#36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %722 = waveamd.fragment_pack %526#37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %723 = waveamd.fragment_pack %526#38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %724 = waveamd.fragment_pack %526#39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %725 = waveamd.fragment_pack %526#40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %726 = waveamd.fragment_pack %526#41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %727 = waveamd.fragment_pack %526#42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %728 = waveamd.fragment_pack %526#43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %729 = waveamd.fragment_pack %526#44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %730 = waveamd.fragment_pack %526#45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %731 = waveamd.fragment_pack %526#46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %732 = waveamd.fragment_pack %526#47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %733 = waveamd.fragment_pack %526#48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %734 = waveamd.fragment_pack %526#49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %735 = waveamd.fragment_pack %526#50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %736 = waveamd.fragment_pack %526#51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %737 = waveamd.fragment_pack %526#52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %738 = waveamd.fragment_pack %526#53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %739 = waveamd.fragment_pack %526#54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %740 = waveamd.fragment_pack %526#55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %741 = waveamd.fragment_pack %526#56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %742 = waveamd.fragment_pack %526#57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %743 = waveamd.fragment_pack %526#58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %744 = waveamd.fragment_pack %526#59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %745 = waveamd.fragment_pack %526#60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %746 = waveamd.fragment_pack %526#61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %747 = waveamd.fragment_pack %526#62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %748 = waveamd.fragment_pack %526#63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %749 = waveamd.fragment_pack %526#64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %750 = waveamd.fragment_pack %526#65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %751 = waveamd.fragment_pack %526#66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %752 = waveamd.fragment_pack %526#67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %753 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %713, %value_132, %527, %583, %721 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %754 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %714, %value_132, %528, %583, %753 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %755 = waveamd.fragment_unpack %754 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %756 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %715, %value_132, %527, %583, %722 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %757 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %716, %value_132, %528, %583, %756 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %758 = waveamd.fragment_unpack %757 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %759 = wave.extract %value_132[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %760 = wave.extract %value_132[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %761 = wave.extract %value_132[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %762 = wave.extract %value_132[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %763 = wave.extract %value_132[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %764 = wave.extract %value_132[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %765 = wave.extract %value_132[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %766 = wave.extract %value_132[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %767 = wave.pack %759, %760, %761, %762, %763, %764, %765, %766 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %768 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %717, %767, %527, %583, %723 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %769 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %718, %767, %528, %583, %768 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %770 = waveamd.fragment_unpack %769 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %771 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %719, %767, %527, %583, %724 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %772 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %720, %767, %528, %583, %771 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %773 = waveamd.fragment_unpack %772 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %774 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %713, %value_132, %529, %583, %725 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %775 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %714, %value_132, %530, %583, %774 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %776 = waveamd.fragment_unpack %775 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %777 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %715, %value_132, %529, %583, %726 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %778 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %716, %value_132, %530, %583, %777 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %779 = waveamd.fragment_unpack %778 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %780 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %717, %767, %529, %583, %727 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %781 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %718, %767, %530, %583, %780 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %782 = waveamd.fragment_unpack %781 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %783 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %719, %767, %529, %583, %728 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %784 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %720, %767, %530, %583, %783 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %785 = waveamd.fragment_unpack %784 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %786 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %713, %value_132, %531, %584, %729 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %787 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %714, %value_132, %532, %584, %786 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %788 = waveamd.fragment_unpack %787 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %789 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %715, %value_132, %531, %584, %730 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %790 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %716, %value_132, %532, %584, %789 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %791 = waveamd.fragment_unpack %790 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %792 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %717, %767, %531, %584, %731 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %793 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %718, %767, %532, %584, %792 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %794 = waveamd.fragment_unpack %793 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %795 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %719, %767, %531, %584, %732 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %796 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %720, %767, %532, %584, %795 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %797 = waveamd.fragment_unpack %796 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %798 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %713, %value_132, %533, %584, %733 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %799 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %714, %value_132, %534, %584, %798 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %800 = waveamd.fragment_unpack %799 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %801 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %715, %value_132, %533, %584, %734 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %802 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %716, %value_132, %534, %584, %801 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %803 = waveamd.fragment_unpack %802 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %804 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %717, %767, %533, %584, %735 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %805 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %718, %767, %534, %584, %804 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %806 = waveamd.fragment_unpack %805 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %807 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %719, %767, %533, %584, %736 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %808 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %720, %767, %534, %584, %807 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %809 = waveamd.fragment_unpack %808 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %810 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %713, %value_132, %535, %585, %737 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %811 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %714, %value_132, %536, %585, %810 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %812 = waveamd.fragment_unpack %811 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %813 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %715, %value_132, %535, %585, %738 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %814 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %716, %value_132, %536, %585, %813 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %815 = waveamd.fragment_unpack %814 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %816 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %717, %767, %535, %585, %739 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %817 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %718, %767, %536, %585, %816 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %818 = waveamd.fragment_unpack %817 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %819 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %719, %767, %535, %585, %740 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %820 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %720, %767, %536, %585, %819 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %821 = waveamd.fragment_unpack %820 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %822 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %713, %value_132, %537, %585, %741 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %823 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %714, %value_132, %538, %585, %822 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %824 = waveamd.fragment_unpack %823 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %825 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %715, %value_132, %537, %585, %742 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %826 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %716, %value_132, %538, %585, %825 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %827 = waveamd.fragment_unpack %826 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %828 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %717, %767, %537, %585, %743 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %829 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %718, %767, %538, %585, %828 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %830 = waveamd.fragment_unpack %829 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %831 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %719, %767, %537, %585, %744 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %832 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %720, %767, %538, %585, %831 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %833 = waveamd.fragment_unpack %832 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %834 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %713, %value_132, %539, %586, %745 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %835 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %714, %value_132, %540, %586, %834 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %836 = waveamd.fragment_unpack %835 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %837 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %715, %value_132, %539, %586, %746 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %838 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %716, %value_132, %540, %586, %837 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %839 = waveamd.fragment_unpack %838 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %840 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %717, %767, %539, %586, %747 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %841 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %718, %767, %540, %586, %840 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %842 = waveamd.fragment_unpack %841 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %843 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %719, %767, %539, %586, %748 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %844 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %720, %767, %540, %586, %843 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %845 = waveamd.fragment_unpack %844 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %846 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %713, %value_132, %541, %586, %749 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %847 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %714, %value_132, %542, %586, %846 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %848 = waveamd.fragment_unpack %847 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %849 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %715, %value_132, %541, %586, %750 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %850 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %716, %value_132, %542, %586, %849 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %851 = waveamd.fragment_unpack %850 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %852 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %717, %767, %541, %586, %751 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %853 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %718, %767, %542, %586, %852 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %854 = waveamd.fragment_unpack %853 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %855 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %719, %767, %541, %586, %752 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %856 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %720, %767, %542, %586, %855 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %857 = waveamd.fragment_unpack %856 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %858 = wave.ptr_add %202, %343 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_134, %token_135 = wave.load %858 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %859 = wave.ptr_add %202, %345 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_136, %token_137 = wave.load %859 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %860 = wave.ptr_add %202, %347 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_138, %token_139 = wave.load %860 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %861 = wave.ptr_add %202, %349 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_140, %token_141 = wave.load %861 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %862 = wave.ptr_add %202, %351 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_142, %token_143 = wave.load %862 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %863 = wave.ptr_add %202, %353 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_144, %token_145 = wave.load %863 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %864 = wave.ptr_add %202, %355 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_146, %token_147 = wave.load %864 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %865 = wave.ptr_add %202, %357 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_148, %token_149 = wave.load %865 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %866 = wave.ptr_add %202, %359 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_150, %token_151 = wave.load %866 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %867 = wave.ptr_add %202, %361 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_152, %token_153 = wave.load %867 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %868 = wave.ptr_add %202, %363 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_154, %token_155 = wave.load %868 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %869 = wave.ptr_add %202, %365 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_156, %token_157 = wave.load %869 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %870 = wave.ptr_add %202, %367 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_158, %token_159 = wave.load %870 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %871 = wave.ptr_add %202, %369 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_160, %token_161 = wave.load %871 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %872 = wave.ptr_add %202, %371 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_162, %token_163 = wave.load %872 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %873 = wave.ptr_add %202, %373 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_164, %token_165 = wave.load %873 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %874 = wave.ptr_add %245, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_166, %token_167 = wave.load %874 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %875 = wave.ptr_add %245, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_168, %token_169 = wave.load %875 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %876 = wave.ptr_add %245, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_170, %token_171 = wave.load %876 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %877 = wave.ptr_add %245, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_172, %token_173 = wave.load %877 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %878 = wave.ptr_add %245, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_174, %token_175 = wave.load %878 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %879 = wave.ptr_add %245, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_176, %token_177 = wave.load %879 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %880 = wave.ptr_add %245, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_178, %token_179 = wave.load %880 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %881 = wave.ptr_add %245, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_180, %token_181 = wave.load %881 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %882 = wave.binary muli %410, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %883 = wave.binary muli %412, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %884 = wave.binary xori %882, %883 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %885 = wave.binary muli %416, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %886 = wave.binary xori %884, %885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %887 = wave.binary muli %393, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %888 = wave.binary xori %886, %887 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %889 = wave.binary muli %395, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %890 = wave.binary xori %888, %889 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %891 = wave.binary muli %706, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %892 = wave.binary addi %891, %890 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %893 = wave.pack %526#72, %526#73, %526#74, %526#75, %526#76, %526#77, %526#78, %526#79 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %894 = wave.ptr_add %391, %892 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %895 = wave.store %893 -> %894 after %token_133 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %896 = wave.barrier %895 : (!wave.mem.token) -> !wave.mem.token
      %897 = wave.pack %526#80, %526#81, %526#82, %526#83 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %898 = wave.store %897 -> %710 after %896 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %899 = wave.barrier %898 : (!wave.mem.token) -> !wave.mem.token
      %value_182, %token_183 = waveamd.transpose_load %496 after %899 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %value_184, %token_185 = waveamd.transpose_load %506 after %899 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %900 = wave.join %token_183, %token_185 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_186, %token_187 = waveamd.transpose_load %517 after %900 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %901 = waveamd.fragment_pack %value_134 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %902 = waveamd.fragment_pack %value_136 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %903 = waveamd.fragment_pack %value_138 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %904 = waveamd.fragment_pack %value_140 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %905 = waveamd.fragment_pack %value_142 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %906 = waveamd.fragment_pack %value_144 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %907 = waveamd.fragment_pack %value_146 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %908 = waveamd.fragment_pack %value_148 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %909 = waveamd.fragment_pack %value_150 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %910 = waveamd.fragment_pack %value_152 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %911 = waveamd.fragment_pack %value_154 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %912 = waveamd.fragment_pack %value_156 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %913 = waveamd.fragment_pack %value_158 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %914 = waveamd.fragment_pack %value_160 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %915 = waveamd.fragment_pack %value_162 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %916 = waveamd.fragment_pack %value_164 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %917 = waveamd.fragment_pack %value_166 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %918 = waveamd.fragment_pack %value_168 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %919 = waveamd.fragment_pack %value_170 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %920 = waveamd.fragment_pack %value_172 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %921 = waveamd.fragment_pack %value_174 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %922 = waveamd.fragment_pack %value_176 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %923 = waveamd.fragment_pack %value_178 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %924 = waveamd.fragment_pack %value_180 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %925 = waveamd.fragment_pack %591 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %926 = waveamd.fragment_pack %594 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %927 = waveamd.fragment_pack %597 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %928 = waveamd.fragment_pack %600 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %929 = waveamd.fragment_pack %603 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %930 = waveamd.fragment_pack %606 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %931 = waveamd.fragment_pack %609 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %932 = waveamd.fragment_pack %612 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %933 = waveamd.fragment_pack %615 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %934 = waveamd.fragment_pack %618 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %935 = waveamd.fragment_pack %621 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %936 = waveamd.fragment_pack %624 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %937 = waveamd.fragment_pack %627 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %938 = waveamd.fragment_pack %630 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %939 = waveamd.fragment_pack %633 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %940 = waveamd.fragment_pack %636 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %941 = waveamd.fragment_pack %639 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %942 = waveamd.fragment_pack %642 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %943 = waveamd.fragment_pack %645 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %944 = waveamd.fragment_pack %648 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %945 = waveamd.fragment_pack %651 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %946 = waveamd.fragment_pack %654 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %947 = waveamd.fragment_pack %657 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %948 = waveamd.fragment_pack %660 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %949 = waveamd.fragment_pack %663 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %950 = waveamd.fragment_pack %666 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %951 = waveamd.fragment_pack %669 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %952 = waveamd.fragment_pack %672 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %953 = waveamd.fragment_pack %675 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %954 = waveamd.fragment_pack %678 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %955 = waveamd.fragment_pack %681 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %956 = waveamd.fragment_pack %684 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %957 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %917, %value_186, %901, %value_182, %925 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %958 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %918, %value_186, %902, %value_182, %957 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %959 = waveamd.fragment_unpack %958 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %960 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %919, %value_186, %901, %value_182, %926 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %961 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %920, %value_186, %902, %value_182, %960 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %962 = waveamd.fragment_unpack %961 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %963 = wave.extract %value_186[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %964 = wave.extract %value_186[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %965 = wave.extract %value_186[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %966 = wave.extract %value_186[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %967 = wave.extract %value_186[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %968 = wave.extract %value_186[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %969 = wave.extract %value_186[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %970 = wave.extract %value_186[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %971 = wave.pack %963, %964, %965, %966, %967, %968, %969, %970 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %972 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %921, %971, %901, %value_182, %927 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %973 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %922, %971, %902, %value_182, %972 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %974 = waveamd.fragment_unpack %973 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %975 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %923, %971, %901, %value_182, %928 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %976 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %924, %971, %902, %value_182, %975 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %977 = waveamd.fragment_unpack %976 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %978 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %917, %value_186, %903, %value_182, %929 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %979 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %918, %value_186, %904, %value_182, %978 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %980 = waveamd.fragment_unpack %979 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %981 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %919, %value_186, %903, %value_182, %930 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %982 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %920, %value_186, %904, %value_182, %981 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %983 = waveamd.fragment_unpack %982 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %984 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %921, %971, %903, %value_182, %931 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %985 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %922, %971, %904, %value_182, %984 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %986 = waveamd.fragment_unpack %985 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %987 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %923, %971, %903, %value_182, %932 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %988 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %924, %971, %904, %value_182, %987 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %989 = waveamd.fragment_unpack %988 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %990 = wave.extract %value_182[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %991 = wave.extract %value_182[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %992 = wave.extract %value_182[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %993 = wave.extract %value_182[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %994 = wave.extract %value_182[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %995 = wave.extract %value_182[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %996 = wave.extract %value_182[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %997 = wave.extract %value_182[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %998 = wave.pack %990, %991, %992, %993, %994, %995, %996, %997 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %999 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %917, %value_186, %905, %998, %933 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1000 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %918, %value_186, %906, %998, %999 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1001 = waveamd.fragment_unpack %1000 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1002 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %919, %value_186, %905, %998, %934 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1003 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %920, %value_186, %906, %998, %1002 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1004 = waveamd.fragment_unpack %1003 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1005 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %921, %971, %905, %998, %935 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1006 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %922, %971, %906, %998, %1005 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1007 = waveamd.fragment_unpack %1006 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1008 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %923, %971, %905, %998, %936 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1009 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %924, %971, %906, %998, %1008 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1010 = waveamd.fragment_unpack %1009 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1011 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %917, %value_186, %907, %998, %937 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1012 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %918, %value_186, %908, %998, %1011 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1013 = waveamd.fragment_unpack %1012 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1014 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %919, %value_186, %907, %998, %938 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1015 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %920, %value_186, %908, %998, %1014 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1016 = waveamd.fragment_unpack %1015 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1017 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %921, %971, %907, %998, %939 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1018 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %922, %971, %908, %998, %1017 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1019 = waveamd.fragment_unpack %1018 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1020 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %923, %971, %907, %998, %940 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1021 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %924, %971, %908, %998, %1020 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1022 = waveamd.fragment_unpack %1021 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1023 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %917, %value_186, %909, %value_184, %941 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1024 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %918, %value_186, %910, %value_184, %1023 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1025 = waveamd.fragment_unpack %1024 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1026 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %919, %value_186, %909, %value_184, %942 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1027 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %920, %value_186, %910, %value_184, %1026 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1028 = waveamd.fragment_unpack %1027 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1029 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %921, %971, %909, %value_184, %943 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1030 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %922, %971, %910, %value_184, %1029 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1031 = waveamd.fragment_unpack %1030 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1032 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %923, %971, %909, %value_184, %944 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1033 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %924, %971, %910, %value_184, %1032 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1034 = waveamd.fragment_unpack %1033 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1035 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %917, %value_186, %911, %value_184, %945 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1036 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %918, %value_186, %912, %value_184, %1035 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1037 = waveamd.fragment_unpack %1036 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1038 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %919, %value_186, %911, %value_184, %946 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1039 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %920, %value_186, %912, %value_184, %1038 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1040 = waveamd.fragment_unpack %1039 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1041 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %921, %971, %911, %value_184, %947 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1042 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %922, %971, %912, %value_184, %1041 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1043 = waveamd.fragment_unpack %1042 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1044 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %923, %971, %911, %value_184, %948 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1045 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %924, %971, %912, %value_184, %1044 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1046 = waveamd.fragment_unpack %1045 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1047 = wave.extract %value_184[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1048 = wave.extract %value_184[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1049 = wave.extract %value_184[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1050 = wave.extract %value_184[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1051 = wave.extract %value_184[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1052 = wave.extract %value_184[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1053 = wave.extract %value_184[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1054 = wave.extract %value_184[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1055 = wave.pack %1047, %1048, %1049, %1050, %1051, %1052, %1053, %1054 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1056 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %917, %value_186, %913, %1055, %949 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1057 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %918, %value_186, %914, %1055, %1056 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1058 = waveamd.fragment_unpack %1057 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1059 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %919, %value_186, %913, %1055, %950 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1060 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %920, %value_186, %914, %1055, %1059 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1061 = waveamd.fragment_unpack %1060 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1062 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %921, %971, %913, %1055, %951 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1063 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %922, %971, %914, %1055, %1062 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1064 = waveamd.fragment_unpack %1063 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1065 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %923, %971, %913, %1055, %952 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1066 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %924, %971, %914, %1055, %1065 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1067 = waveamd.fragment_unpack %1066 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1068 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %917, %value_186, %915, %1055, %953 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1069 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %918, %value_186, %916, %1055, %1068 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1070 = waveamd.fragment_unpack %1069 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1071 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %919, %value_186, %915, %1055, %954 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1072 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %920, %value_186, %916, %1055, %1071 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1073 = waveamd.fragment_unpack %1072 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1074 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %921, %971, %915, %1055, %955 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1075 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %922, %971, %916, %1055, %1074 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1076 = waveamd.fragment_unpack %1075 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1077 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %923, %971, %915, %1055, %956 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1078 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %924, %971, %916, %1055, %1077 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1079 = waveamd.fragment_unpack %1078 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1080 = wave.ptr_add %305, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_188, %token_189 = wave.load %1080 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1081 = wave.ptr_add %305, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_190, %token_191 = wave.load %1081 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1082 = wave.ptr_add %305, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_192, %token_193 = wave.load %1082 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1083 = wave.ptr_add %305, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_194, %token_195 = wave.load %1083 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1084 = wave.ptr_add %305, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_196, %token_197 = wave.load %1084 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1085 = wave.ptr_add %305, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_198, %token_199 = wave.load %1085 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1086 = wave.ptr_add %305, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_200, %token_201 = wave.load %1086 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1087 = wave.ptr_add %305, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_202, %token_203 = wave.load %1087 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1088 = wave.pack %526#84, %526#85, %526#86, %526#87 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1089 = wave.store %1088 -> %710 after %token_187 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %1090 = wave.barrier %1089 : (!wave.mem.token) -> !wave.mem.token
      %value_204, %token_205 = waveamd.transpose_load %517 after %1090 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1091 = wave.binary muli %39, %arg9 : i32, i32 -> i32
      %1092 = wave.cast fpconvert %959 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1093 = wave.cast fpconvert %962 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1094 = wave.cast fpconvert %974 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1095 = wave.cast fpconvert %977 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1096 = wave.cast fpconvert %980 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1097 = wave.cast fpconvert %983 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1098 = wave.cast fpconvert %986 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1099 = wave.cast fpconvert %989 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1100 = wave.cast fpconvert %1001 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1101 = wave.cast fpconvert %1004 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1102 = wave.cast fpconvert %1007 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1103 = wave.cast fpconvert %1010 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1104 = wave.cast fpconvert %1013 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1105 = wave.cast fpconvert %1016 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1106 = wave.cast fpconvert %1019 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1107 = wave.cast fpconvert %1022 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1108 = wave.cast fpconvert %1025 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1109 = wave.cast fpconvert %1028 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1110 = wave.cast fpconvert %1031 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1111 = wave.cast fpconvert %1034 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1112 = wave.cast fpconvert %1037 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1113 = wave.cast fpconvert %1040 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1114 = wave.cast fpconvert %1043 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1115 = wave.cast fpconvert %1046 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1116 = wave.cast fpconvert %1058 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1117 = wave.cast fpconvert %1061 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1118 = wave.cast fpconvert %1064 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1119 = wave.cast fpconvert %1067 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1120 = wave.cast fpconvert %1070 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1121 = wave.cast fpconvert %1073 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1122 = wave.cast fpconvert %1076 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1123 = wave.cast fpconvert %1079 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1124 = wave.lds_base {offset = 138048 : i64} : !wave.ptr<#wave.shared, bf16>
      %1125 = wave.binary muli %49, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1126 = wave.ptr_add %1124, %1125 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1127 = wave.extract %1092[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1128 = wave.extract %1092[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1129 = wave.extract %1092[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1130 = wave.extract %1092[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1131 = wave.extract %1096[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1132 = wave.extract %1096[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1133 = wave.extract %1096[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1134 = wave.extract %1096[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1135 = wave.pack %1127, %1128, %1129, %1130, %1131, %1132, %1133, %1134 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1136 = wave.store %1135 -> %1126 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1137 = wave.binary addi %1125, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1138 = wave.ptr_add %1124, %1137 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1139 = wave.extract %1093[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1140 = wave.extract %1093[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1141 = wave.extract %1093[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1142 = wave.extract %1093[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1143 = wave.extract %1097[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1144 = wave.extract %1097[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1145 = wave.extract %1097[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1146 = wave.extract %1097[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1147 = wave.pack %1139, %1140, %1141, %1142, %1143, %1144, %1145, %1146 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1148 = wave.store %1147 -> %1138 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1149 = wave.binary addi %1125, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1150 = wave.ptr_add %1124, %1149 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1151 = wave.extract %1094[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1152 = wave.extract %1094[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1153 = wave.extract %1094[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1154 = wave.extract %1094[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1155 = wave.extract %1098[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1156 = wave.extract %1098[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1157 = wave.extract %1098[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1158 = wave.extract %1098[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1159 = wave.pack %1151, %1152, %1153, %1154, %1155, %1156, %1157, %1158 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1160 = wave.store %1159 -> %1150 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1161 = wave.binary addi %1125, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1162 = wave.ptr_add %1124, %1161 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1163 = wave.extract %1095[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1164 = wave.extract %1095[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1165 = wave.extract %1095[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1166 = wave.extract %1095[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1167 = wave.extract %1099[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1168 = wave.extract %1099[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1169 = wave.extract %1099[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1170 = wave.extract %1099[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1171 = wave.pack %1163, %1164, %1165, %1166, %1167, %1168, %1169, %1170 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1172 = wave.store %1171 -> %1162 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1173 = wave.barrier %1136, %1148, %1160, %1172 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1174 = wave.index_expr <"8*(32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1175 = wave.ptr_add %1124, %1174 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_206, %token_207 = wave.load %1175 after %1173 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1176 = wave.extract %value_206[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1177 = wave.extract %value_206[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1178 = wave.extract %value_206[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1179 = wave.extract %value_206[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1180 = wave.extract %value_206[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1181 = wave.extract %value_206[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1182 = wave.extract %value_206[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1183 = wave.extract %value_206[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1184 = wave.index_expr <"8*(16 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1185 = wave.ptr_add %1124, %1184 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_208, %token_209 = wave.load %1185 after %1173 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1186 = wave.extract %value_208[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1187 = wave.extract %value_208[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1188 = wave.extract %value_208[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1189 = wave.extract %value_208[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1190 = wave.extract %value_208[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1191 = wave.extract %value_208[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1192 = wave.extract %value_208[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1193 = wave.extract %value_208[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1194 = wave.index_expr <"8*(128 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1195 = wave.ptr_add %1124, %1194 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_210, %token_211 = wave.load %1195 after %1173 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1196 = wave.extract %value_210[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1197 = wave.extract %value_210[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1198 = wave.extract %value_210[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1199 = wave.extract %value_210[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1200 = wave.extract %value_210[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1201 = wave.extract %value_210[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1202 = wave.extract %value_210[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1203 = wave.extract %value_210[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1204 = wave.index_expr <"8*(144 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%49) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1205 = wave.ptr_add %1124, %1204 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_212, %token_213 = wave.load %1205 after %1173 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1206 = wave.extract %value_212[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1207 = wave.extract %value_212[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1208 = wave.extract %value_212[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1209 = wave.extract %value_212[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1210 = wave.extract %value_212[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1211 = wave.extract %value_212[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1212 = wave.extract %value_212[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1213 = wave.extract %value_212[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1214 = wave.barrier %token_207, %token_209, %token_211, %token_213 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1215 = wave.extract %1100[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1216 = wave.extract %1100[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1217 = wave.extract %1100[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1218 = wave.extract %1100[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1219 = wave.extract %1104[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1220 = wave.extract %1104[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1221 = wave.extract %1104[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1222 = wave.extract %1104[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1223 = wave.pack %1215, %1216, %1217, %1218, %1219, %1220, %1221, %1222 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1224 = wave.store %1223 -> %1126 after %1214 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1225 = wave.extract %1101[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1226 = wave.extract %1101[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1227 = wave.extract %1101[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1228 = wave.extract %1101[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1229 = wave.extract %1105[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1230 = wave.extract %1105[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1231 = wave.extract %1105[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1232 = wave.extract %1105[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1233 = wave.pack %1225, %1226, %1227, %1228, %1229, %1230, %1231, %1232 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1234 = wave.store %1233 -> %1138 after %1214 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1235 = wave.extract %1102[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1236 = wave.extract %1102[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1237 = wave.extract %1102[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1238 = wave.extract %1102[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1239 = wave.extract %1106[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1240 = wave.extract %1106[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1241 = wave.extract %1106[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1242 = wave.extract %1106[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1243 = wave.pack %1235, %1236, %1237, %1238, %1239, %1240, %1241, %1242 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1244 = wave.store %1243 -> %1150 after %1214 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1245 = wave.extract %1103[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1246 = wave.extract %1103[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1247 = wave.extract %1103[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1248 = wave.extract %1103[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1249 = wave.extract %1107[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1250 = wave.extract %1107[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1251 = wave.extract %1107[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1252 = wave.extract %1107[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1253 = wave.pack %1245, %1246, %1247, %1248, %1249, %1250, %1251, %1252 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1254 = wave.store %1253 -> %1162 after %1214 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1255 = wave.barrier %1224, %1234, %1244, %1254 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_214, %token_215 = wave.load %1175 after %1255 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1256 = wave.extract %value_214[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1257 = wave.extract %value_214[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1258 = wave.extract %value_214[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1259 = wave.extract %value_214[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1260 = wave.extract %value_214[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1261 = wave.extract %value_214[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1262 = wave.extract %value_214[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1263 = wave.extract %value_214[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_216, %token_217 = wave.load %1185 after %1255 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1264 = wave.extract %value_216[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1265 = wave.extract %value_216[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1266 = wave.extract %value_216[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1267 = wave.extract %value_216[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1268 = wave.extract %value_216[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1269 = wave.extract %value_216[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1270 = wave.extract %value_216[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1271 = wave.extract %value_216[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_218, %token_219 = wave.load %1195 after %1255 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1272 = wave.extract %value_218[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1273 = wave.extract %value_218[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1274 = wave.extract %value_218[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1275 = wave.extract %value_218[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1276 = wave.extract %value_218[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1277 = wave.extract %value_218[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1278 = wave.extract %value_218[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1279 = wave.extract %value_218[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_220, %token_221 = wave.load %1205 after %1255 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1280 = wave.extract %value_220[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1281 = wave.extract %value_220[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1282 = wave.extract %value_220[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1283 = wave.extract %value_220[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1284 = wave.extract %value_220[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1285 = wave.extract %value_220[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1286 = wave.extract %value_220[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1287 = wave.extract %value_220[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1288 = wave.barrier %token_215, %token_217, %token_219, %token_221 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1289 = wave.extract %1108[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1290 = wave.extract %1108[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1291 = wave.extract %1108[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1292 = wave.extract %1108[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1293 = wave.extract %1112[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1294 = wave.extract %1112[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1295 = wave.extract %1112[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1296 = wave.extract %1112[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1297 = wave.pack %1289, %1290, %1291, %1292, %1293, %1294, %1295, %1296 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1298 = wave.store %1297 -> %1126 after %1288 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1299 = wave.extract %1109[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1300 = wave.extract %1109[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1301 = wave.extract %1109[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1302 = wave.extract %1109[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1303 = wave.extract %1113[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1304 = wave.extract %1113[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1305 = wave.extract %1113[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1306 = wave.extract %1113[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1307 = wave.pack %1299, %1300, %1301, %1302, %1303, %1304, %1305, %1306 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1308 = wave.store %1307 -> %1138 after %1288 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1309 = wave.extract %1110[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1310 = wave.extract %1110[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1311 = wave.extract %1110[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1312 = wave.extract %1110[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1313 = wave.extract %1114[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1314 = wave.extract %1114[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1315 = wave.extract %1114[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1316 = wave.extract %1114[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1317 = wave.pack %1309, %1310, %1311, %1312, %1313, %1314, %1315, %1316 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1318 = wave.store %1317 -> %1150 after %1288 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1319 = wave.extract %1111[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1320 = wave.extract %1111[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1321 = wave.extract %1111[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1322 = wave.extract %1111[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1323 = wave.extract %1115[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1324 = wave.extract %1115[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1325 = wave.extract %1115[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1326 = wave.extract %1115[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1327 = wave.pack %1319, %1320, %1321, %1322, %1323, %1324, %1325, %1326 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1328 = wave.store %1327 -> %1162 after %1288 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1329 = wave.barrier %1298, %1308, %1318, %1328 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_222, %token_223 = wave.load %1175 after %1329 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1330 = wave.extract %value_222[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1331 = wave.extract %value_222[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1332 = wave.extract %value_222[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1333 = wave.extract %value_222[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1334 = wave.extract %value_222[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1335 = wave.extract %value_222[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1336 = wave.extract %value_222[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1337 = wave.extract %value_222[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_224, %token_225 = wave.load %1185 after %1329 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1338 = wave.extract %value_224[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1339 = wave.extract %value_224[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1340 = wave.extract %value_224[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1341 = wave.extract %value_224[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1342 = wave.extract %value_224[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1343 = wave.extract %value_224[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1344 = wave.extract %value_224[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1345 = wave.extract %value_224[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_226, %token_227 = wave.load %1195 after %1329 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1346 = wave.extract %value_226[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1347 = wave.extract %value_226[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1348 = wave.extract %value_226[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1349 = wave.extract %value_226[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1350 = wave.extract %value_226[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1351 = wave.extract %value_226[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1352 = wave.extract %value_226[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1353 = wave.extract %value_226[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_228, %token_229 = wave.load %1205 after %1329 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1354 = wave.extract %value_228[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1355 = wave.extract %value_228[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1356 = wave.extract %value_228[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1357 = wave.extract %value_228[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1358 = wave.extract %value_228[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1359 = wave.extract %value_228[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1360 = wave.extract %value_228[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1361 = wave.extract %value_228[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1362 = wave.barrier %token_223, %token_225, %token_227, %token_229 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1363 = wave.extract %1116[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1364 = wave.extract %1116[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1365 = wave.extract %1116[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1366 = wave.extract %1116[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1367 = wave.extract %1120[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1368 = wave.extract %1120[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1369 = wave.extract %1120[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1370 = wave.extract %1120[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1371 = wave.pack %1363, %1364, %1365, %1366, %1367, %1368, %1369, %1370 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1372 = wave.store %1371 -> %1126 after %1362 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1373 = wave.extract %1117[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1374 = wave.extract %1117[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1375 = wave.extract %1117[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1376 = wave.extract %1117[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1377 = wave.extract %1121[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1378 = wave.extract %1121[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1379 = wave.extract %1121[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1380 = wave.extract %1121[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1381 = wave.pack %1373, %1374, %1375, %1376, %1377, %1378, %1379, %1380 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1382 = wave.store %1381 -> %1138 after %1362 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1383 = wave.extract %1118[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1384 = wave.extract %1118[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1385 = wave.extract %1118[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1386 = wave.extract %1118[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1387 = wave.extract %1122[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1388 = wave.extract %1122[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1389 = wave.extract %1122[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1390 = wave.extract %1122[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1391 = wave.pack %1383, %1384, %1385, %1386, %1387, %1388, %1389, %1390 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1392 = wave.store %1391 -> %1150 after %1362 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1393 = wave.extract %1119[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1394 = wave.extract %1119[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1395 = wave.extract %1119[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1396 = wave.extract %1119[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1397 = wave.extract %1123[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1398 = wave.extract %1123[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1399 = wave.extract %1123[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1400 = wave.extract %1123[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1401 = wave.pack %1393, %1394, %1395, %1396, %1397, %1398, %1399, %1400 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1402 = wave.store %1401 -> %1162 after %1362 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1403 = wave.barrier %1372, %1382, %1392, %1402 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_230, %token_231 = wave.load %1175 after %1403 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1404 = wave.extract %value_230[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1405 = wave.extract %value_230[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1406 = wave.extract %value_230[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1407 = wave.extract %value_230[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1408 = wave.extract %value_230[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1409 = wave.extract %value_230[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1410 = wave.extract %value_230[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1411 = wave.extract %value_230[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_232, %token_233 = wave.load %1185 after %1403 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1412 = wave.extract %value_232[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1413 = wave.extract %value_232[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1414 = wave.extract %value_232[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1415 = wave.extract %value_232[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1416 = wave.extract %value_232[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1417 = wave.extract %value_232[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1418 = wave.extract %value_232[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1419 = wave.extract %value_232[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_234, %token_235 = wave.load %1195 after %1403 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1420 = wave.extract %value_234[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1421 = wave.extract %value_234[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1422 = wave.extract %value_234[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1423 = wave.extract %value_234[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1424 = wave.extract %value_234[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1425 = wave.extract %value_234[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1426 = wave.extract %value_234[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1427 = wave.extract %value_234[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_236, %token_237 = wave.load %1205 after %1403 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1428 = wave.extract %value_236[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1429 = wave.extract %value_236[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1430 = wave.extract %value_236[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1431 = wave.extract %value_236[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1432 = wave.extract %value_236[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1433 = wave.extract %value_236[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1434 = wave.extract %value_236[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1435 = wave.extract %value_236[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1436 = wave.barrier %token_231, %token_233, %token_235, %token_237 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1437 = wave.ptr_add %arg2, %1091 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#wave.global, bf16>
      %1438 = waveamd.make_buffer %1437, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %1439 = wave.pack %1176, %1177, %1178, %1179, %1186, %1187, %1188, %1189 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1440 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1441 = wave.assume %1440 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1442 = wave.ptr_add %1438, %1441 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1443 = wave.store %1439 -> %1442 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1444 = wave.pack %1196, %1197, %1198, %1199, %1206, %1207, %1208, %1209 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1445 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1446 = wave.assume %1445 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1447 = wave.ptr_add %1438, %1446 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1448 = wave.store %1444 -> %1447 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1449 = wave.pack %1180, %1181, %1182, %1183, %1190, %1191, %1192, %1193 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1450 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1451 = wave.assume %1450 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1452 = wave.ptr_add %1438, %1451 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1453 = wave.store %1449 -> %1452 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1454 = wave.pack %1200, %1201, %1202, %1203, %1210, %1211, %1212, %1213 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1455 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1456 = wave.assume %1455 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1457 = wave.ptr_add %1438, %1456 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1458 = wave.store %1454 -> %1457 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1459 = wave.pack %1256, %1257, %1258, %1259, %1264, %1265, %1266, %1267 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1460 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1461 = wave.assume %1460 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1462 = wave.ptr_add %1438, %1461 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1463 = wave.store %1459 -> %1462 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1464 = wave.pack %1272, %1273, %1274, %1275, %1280, %1281, %1282, %1283 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1465 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1466 = wave.assume %1465 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1467 = wave.ptr_add %1438, %1466 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1468 = wave.store %1464 -> %1467 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1469 = wave.pack %1260, %1261, %1262, %1263, %1268, %1269, %1270, %1271 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1470 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1471 = wave.assume %1470 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1472 = wave.ptr_add %1438, %1471 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1473 = wave.store %1469 -> %1472 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1474 = wave.pack %1276, %1277, %1278, %1279, %1284, %1285, %1286, %1287 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1475 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1476 = wave.assume %1475 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1477 = wave.ptr_add %1438, %1476 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1478 = wave.store %1474 -> %1477 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1479 = wave.pack %1330, %1331, %1332, %1333, %1338, %1339, %1340, %1341 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1480 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1481 = wave.assume %1480 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1482 = wave.ptr_add %1438, %1481 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1483 = wave.store %1479 -> %1482 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1484 = wave.pack %1346, %1347, %1348, %1349, %1354, %1355, %1356, %1357 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1485 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1486 = wave.assume %1485 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1487 = wave.ptr_add %1438, %1486 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1488 = wave.store %1484 -> %1487 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1489 = wave.pack %1334, %1335, %1336, %1337, %1342, %1343, %1344, %1345 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1490 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1491 = wave.assume %1490 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1492 = wave.ptr_add %1438, %1491 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1493 = wave.store %1489 -> %1492 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1494 = wave.pack %1350, %1351, %1352, %1353, %1358, %1359, %1360, %1361 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1495 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1496 = wave.assume %1495 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1497 = wave.ptr_add %1438, %1496 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1498 = wave.store %1494 -> %1497 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1499 = wave.pack %1404, %1405, %1406, %1407, %1412, %1413, %1414, %1415 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1500 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1501 = wave.assume %1500 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1502 = wave.ptr_add %1438, %1501 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1503 = wave.store %1499 -> %1502 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1504 = wave.pack %1420, %1421, %1422, %1423, %1428, %1429, %1430, %1431 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1505 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1506 = wave.assume %1505 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1507 = wave.ptr_add %1438, %1506 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1508 = wave.store %1504 -> %1507 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1509 = wave.pack %1408, %1409, %1410, %1411, %1416, %1417, %1418, %1419 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1510 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1511 = wave.assume %1510 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1512 = wave.ptr_add %1438, %1511 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1513 = wave.store %1509 -> %1512 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1514 = wave.pack %1424, %1425, %1426, %1427, %1432, %1433, %1434, %1435 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1515 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1516 = wave.assume %1515 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1517 = wave.ptr_add %1438, %1516 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1518 = wave.store %1514 -> %1517 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1519 = waveamd.fragment_pack %value_188 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1520 = waveamd.fragment_pack %value_190 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1521 = waveamd.fragment_pack %value_192 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1522 = waveamd.fragment_pack %value_194 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1523 = waveamd.fragment_pack %value_196 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1524 = waveamd.fragment_pack %value_198 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1525 = waveamd.fragment_pack %value_200 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1526 = waveamd.fragment_pack %value_202 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1527 = waveamd.fragment_pack %755 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1528 = waveamd.fragment_pack %758 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1529 = waveamd.fragment_pack %770 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1530 = waveamd.fragment_pack %773 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1531 = waveamd.fragment_pack %776 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1532 = waveamd.fragment_pack %779 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1533 = waveamd.fragment_pack %782 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1534 = waveamd.fragment_pack %785 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1535 = waveamd.fragment_pack %788 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1536 = waveamd.fragment_pack %791 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1537 = waveamd.fragment_pack %794 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1538 = waveamd.fragment_pack %797 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1539 = waveamd.fragment_pack %800 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1540 = waveamd.fragment_pack %803 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1541 = waveamd.fragment_pack %806 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1542 = waveamd.fragment_pack %809 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1543 = waveamd.fragment_pack %812 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1544 = waveamd.fragment_pack %815 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1545 = waveamd.fragment_pack %818 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1546 = waveamd.fragment_pack %821 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1547 = waveamd.fragment_pack %824 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1548 = waveamd.fragment_pack %827 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1549 = waveamd.fragment_pack %830 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1550 = waveamd.fragment_pack %833 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1551 = waveamd.fragment_pack %836 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1552 = waveamd.fragment_pack %839 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1553 = waveamd.fragment_pack %842 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1554 = waveamd.fragment_pack %845 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1555 = waveamd.fragment_pack %848 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1556 = waveamd.fragment_pack %851 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1557 = waveamd.fragment_pack %854 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1558 = waveamd.fragment_pack %857 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1559 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1519, %value_204, %901, %value_182, %1527 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1560 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1520, %value_204, %902, %value_182, %1559 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1561 = waveamd.fragment_unpack %1560 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1562 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1521, %value_204, %901, %value_182, %1528 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1563 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1522, %value_204, %902, %value_182, %1562 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1564 = waveamd.fragment_unpack %1563 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1565 = wave.extract %value_204[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1566 = wave.extract %value_204[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1567 = wave.extract %value_204[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1568 = wave.extract %value_204[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1569 = wave.extract %value_204[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1570 = wave.extract %value_204[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1571 = wave.extract %value_204[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1572 = wave.extract %value_204[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1573 = wave.pack %1565, %1566, %1567, %1568, %1569, %1570, %1571, %1572 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1574 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1523, %1573, %901, %value_182, %1529 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1575 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1524, %1573, %902, %value_182, %1574 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1576 = waveamd.fragment_unpack %1575 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1577 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1525, %1573, %901, %value_182, %1530 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1578 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1526, %1573, %902, %value_182, %1577 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1579 = waveamd.fragment_unpack %1578 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1580 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1519, %value_204, %903, %value_182, %1531 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1581 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1520, %value_204, %904, %value_182, %1580 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1582 = waveamd.fragment_unpack %1581 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1583 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1521, %value_204, %903, %value_182, %1532 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1584 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1522, %value_204, %904, %value_182, %1583 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1585 = waveamd.fragment_unpack %1584 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1586 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1523, %1573, %903, %value_182, %1533 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1587 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1524, %1573, %904, %value_182, %1586 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1588 = waveamd.fragment_unpack %1587 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1525, %1573, %903, %value_182, %1534 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1526, %1573, %904, %value_182, %1589 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1591 = waveamd.fragment_unpack %1590 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1519, %value_204, %905, %998, %1535 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1520, %value_204, %906, %998, %1592 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1594 = waveamd.fragment_unpack %1593 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1521, %value_204, %905, %998, %1536 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1522, %value_204, %906, %998, %1595 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1597 = waveamd.fragment_unpack %1596 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1523, %1573, %905, %998, %1537 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1524, %1573, %906, %998, %1598 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1600 = waveamd.fragment_unpack %1599 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1525, %1573, %905, %998, %1538 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1602 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1526, %1573, %906, %998, %1601 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1603 = waveamd.fragment_unpack %1602 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1519, %value_204, %907, %998, %1539 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1520, %value_204, %908, %998, %1604 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1606 = waveamd.fragment_unpack %1605 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1607 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1521, %value_204, %907, %998, %1540 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1608 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1522, %value_204, %908, %998, %1607 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1609 = waveamd.fragment_unpack %1608 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1610 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1523, %1573, %907, %998, %1541 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1611 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1524, %1573, %908, %998, %1610 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1612 = waveamd.fragment_unpack %1611 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1613 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1525, %1573, %907, %998, %1542 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1614 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1526, %1573, %908, %998, %1613 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1615 = waveamd.fragment_unpack %1614 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1616 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1519, %value_204, %909, %value_184, %1543 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1617 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1520, %value_204, %910, %value_184, %1616 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1618 = waveamd.fragment_unpack %1617 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1619 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1521, %value_204, %909, %value_184, %1544 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1620 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1522, %value_204, %910, %value_184, %1619 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1621 = waveamd.fragment_unpack %1620 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1622 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1523, %1573, %909, %value_184, %1545 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1623 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1524, %1573, %910, %value_184, %1622 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1624 = waveamd.fragment_unpack %1623 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1625 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1525, %1573, %909, %value_184, %1546 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1626 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1526, %1573, %910, %value_184, %1625 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1627 = waveamd.fragment_unpack %1626 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1628 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1519, %value_204, %911, %value_184, %1547 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1629 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1520, %value_204, %912, %value_184, %1628 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1630 = waveamd.fragment_unpack %1629 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1631 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1521, %value_204, %911, %value_184, %1548 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1632 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1522, %value_204, %912, %value_184, %1631 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1633 = waveamd.fragment_unpack %1632 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1634 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1523, %1573, %911, %value_184, %1549 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1635 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1524, %1573, %912, %value_184, %1634 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1636 = waveamd.fragment_unpack %1635 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1637 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1525, %1573, %911, %value_184, %1550 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1638 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1526, %1573, %912, %value_184, %1637 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1639 = waveamd.fragment_unpack %1638 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1640 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1519, %value_204, %913, %1055, %1551 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1641 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1520, %value_204, %914, %1055, %1640 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1642 = waveamd.fragment_unpack %1641 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1643 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1521, %value_204, %913, %1055, %1552 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1644 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1522, %value_204, %914, %1055, %1643 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1645 = waveamd.fragment_unpack %1644 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1646 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1523, %1573, %913, %1055, %1553 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1647 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1524, %1573, %914, %1055, %1646 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1648 = waveamd.fragment_unpack %1647 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1649 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1525, %1573, %913, %1055, %1554 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1650 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1526, %1573, %914, %1055, %1649 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1651 = waveamd.fragment_unpack %1650 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1652 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1519, %value_204, %915, %1055, %1555 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1653 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1520, %value_204, %916, %1055, %1652 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1654 = waveamd.fragment_unpack %1653 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1655 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1521, %value_204, %915, %1055, %1556 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1656 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1522, %value_204, %916, %1055, %1655 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1657 = waveamd.fragment_unpack %1656 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1658 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1523, %1573, %915, %1055, %1557 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1659 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1524, %1573, %916, %1055, %1658 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1660 = waveamd.fragment_unpack %1659 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1661 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1525, %1573, %915, %1055, %1558 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1662 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1526, %1573, %916, %1055, %1661 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1663 = waveamd.fragment_unpack %1662 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1664 = wave.cast fpconvert %1561 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1665 = wave.cast fpconvert %1564 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1666 = wave.cast fpconvert %1576 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1667 = wave.cast fpconvert %1579 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1668 = wave.cast fpconvert %1582 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1669 = wave.cast fpconvert %1585 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1670 = wave.cast fpconvert %1588 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1671 = wave.cast fpconvert %1591 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1672 = wave.cast fpconvert %1594 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1673 = wave.cast fpconvert %1597 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1674 = wave.cast fpconvert %1600 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1675 = wave.cast fpconvert %1603 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1676 = wave.cast fpconvert %1606 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1677 = wave.cast fpconvert %1609 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1678 = wave.cast fpconvert %1612 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1679 = wave.cast fpconvert %1615 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1680 = wave.cast fpconvert %1618 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1681 = wave.cast fpconvert %1621 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1682 = wave.cast fpconvert %1624 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1683 = wave.cast fpconvert %1627 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1684 = wave.cast fpconvert %1630 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1685 = wave.cast fpconvert %1633 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1686 = wave.cast fpconvert %1636 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1687 = wave.cast fpconvert %1639 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1688 = wave.cast fpconvert %1642 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1689 = wave.cast fpconvert %1645 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1690 = wave.cast fpconvert %1648 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1691 = wave.cast fpconvert %1651 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1692 = wave.cast fpconvert %1654 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1693 = wave.cast fpconvert %1657 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1694 = wave.cast fpconvert %1660 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1695 = wave.cast fpconvert %1663 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1696 = wave.extract %1664[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1697 = wave.extract %1664[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1698 = wave.extract %1664[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1699 = wave.extract %1664[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1700 = wave.extract %1668[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1701 = wave.extract %1668[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1702 = wave.extract %1668[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1703 = wave.extract %1668[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1704 = wave.pack %1696, %1697, %1698, %1699, %1700, %1701, %1702, %1703 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1705 = wave.store %1704 -> %1126 after %1436 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1706 = wave.extract %1665[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1707 = wave.extract %1665[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1708 = wave.extract %1665[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1709 = wave.extract %1665[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1710 = wave.extract %1669[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1711 = wave.extract %1669[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1712 = wave.extract %1669[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1713 = wave.extract %1669[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1714 = wave.pack %1706, %1707, %1708, %1709, %1710, %1711, %1712, %1713 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1715 = wave.store %1714 -> %1138 after %1436 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1716 = wave.extract %1666[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1717 = wave.extract %1666[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1718 = wave.extract %1666[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1719 = wave.extract %1666[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1720 = wave.extract %1670[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1721 = wave.extract %1670[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1722 = wave.extract %1670[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1723 = wave.extract %1670[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1724 = wave.pack %1716, %1717, %1718, %1719, %1720, %1721, %1722, %1723 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1725 = wave.store %1724 -> %1150 after %1436 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1726 = wave.extract %1667[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1727 = wave.extract %1667[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1728 = wave.extract %1667[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1729 = wave.extract %1667[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1730 = wave.extract %1671[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1731 = wave.extract %1671[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1732 = wave.extract %1671[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1733 = wave.extract %1671[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1734 = wave.pack %1726, %1727, %1728, %1729, %1730, %1731, %1732, %1733 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1735 = wave.store %1734 -> %1162 after %1436 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1736 = wave.barrier %1705, %1715, %1725, %1735 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_238, %token_239 = wave.load %1175 after %1736 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1737 = wave.extract %value_238[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1738 = wave.extract %value_238[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1739 = wave.extract %value_238[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1740 = wave.extract %value_238[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1741 = wave.extract %value_238[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1742 = wave.extract %value_238[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1743 = wave.extract %value_238[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1744 = wave.extract %value_238[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_240, %token_241 = wave.load %1185 after %1736 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1745 = wave.extract %value_240[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1746 = wave.extract %value_240[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1747 = wave.extract %value_240[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1748 = wave.extract %value_240[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1749 = wave.extract %value_240[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1750 = wave.extract %value_240[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1751 = wave.extract %value_240[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1752 = wave.extract %value_240[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_242, %token_243 = wave.load %1195 after %1736 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1753 = wave.extract %value_242[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1754 = wave.extract %value_242[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1755 = wave.extract %value_242[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1756 = wave.extract %value_242[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1757 = wave.extract %value_242[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1758 = wave.extract %value_242[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1759 = wave.extract %value_242[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1760 = wave.extract %value_242[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_244, %token_245 = wave.load %1205 after %1736 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1761 = wave.extract %value_244[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1762 = wave.extract %value_244[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1763 = wave.extract %value_244[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1764 = wave.extract %value_244[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1765 = wave.extract %value_244[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1766 = wave.extract %value_244[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1767 = wave.extract %value_244[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1768 = wave.extract %value_244[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1769 = wave.barrier %token_239, %token_241, %token_243, %token_245 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1770 = wave.extract %1672[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1771 = wave.extract %1672[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1772 = wave.extract %1672[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1773 = wave.extract %1672[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1774 = wave.extract %1676[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1775 = wave.extract %1676[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1776 = wave.extract %1676[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1777 = wave.extract %1676[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1778 = wave.pack %1770, %1771, %1772, %1773, %1774, %1775, %1776, %1777 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1779 = wave.store %1778 -> %1126 after %1769 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1780 = wave.extract %1673[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1781 = wave.extract %1673[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1782 = wave.extract %1673[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1783 = wave.extract %1673[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1784 = wave.extract %1677[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1785 = wave.extract %1677[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1786 = wave.extract %1677[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1787 = wave.extract %1677[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1788 = wave.pack %1780, %1781, %1782, %1783, %1784, %1785, %1786, %1787 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1789 = wave.store %1788 -> %1138 after %1769 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1790 = wave.extract %1674[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1791 = wave.extract %1674[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1792 = wave.extract %1674[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1793 = wave.extract %1674[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1794 = wave.extract %1678[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1795 = wave.extract %1678[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1796 = wave.extract %1678[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1797 = wave.extract %1678[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1798 = wave.pack %1790, %1791, %1792, %1793, %1794, %1795, %1796, %1797 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1799 = wave.store %1798 -> %1150 after %1769 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1800 = wave.extract %1675[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1801 = wave.extract %1675[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1802 = wave.extract %1675[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1803 = wave.extract %1675[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1804 = wave.extract %1679[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1805 = wave.extract %1679[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1806 = wave.extract %1679[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1807 = wave.extract %1679[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1808 = wave.pack %1800, %1801, %1802, %1803, %1804, %1805, %1806, %1807 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1809 = wave.store %1808 -> %1162 after %1769 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1810 = wave.barrier %1779, %1789, %1799, %1809 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_246, %token_247 = wave.load %1175 after %1810 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1811 = wave.extract %value_246[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1812 = wave.extract %value_246[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1813 = wave.extract %value_246[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1814 = wave.extract %value_246[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1815 = wave.extract %value_246[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1816 = wave.extract %value_246[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1817 = wave.extract %value_246[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1818 = wave.extract %value_246[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_248, %token_249 = wave.load %1185 after %1810 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1819 = wave.extract %value_248[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1820 = wave.extract %value_248[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1821 = wave.extract %value_248[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1822 = wave.extract %value_248[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1823 = wave.extract %value_248[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1824 = wave.extract %value_248[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1825 = wave.extract %value_248[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1826 = wave.extract %value_248[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_250, %token_251 = wave.load %1195 after %1810 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1827 = wave.extract %value_250[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1828 = wave.extract %value_250[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1829 = wave.extract %value_250[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1830 = wave.extract %value_250[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1831 = wave.extract %value_250[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1832 = wave.extract %value_250[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1833 = wave.extract %value_250[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1834 = wave.extract %value_250[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_252, %token_253 = wave.load %1205 after %1810 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1835 = wave.extract %value_252[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1836 = wave.extract %value_252[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1837 = wave.extract %value_252[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1838 = wave.extract %value_252[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1839 = wave.extract %value_252[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1840 = wave.extract %value_252[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1841 = wave.extract %value_252[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1842 = wave.extract %value_252[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1843 = wave.barrier %token_247, %token_249, %token_251, %token_253 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1844 = wave.extract %1680[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1845 = wave.extract %1680[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1846 = wave.extract %1680[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1847 = wave.extract %1680[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1848 = wave.extract %1684[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1849 = wave.extract %1684[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1850 = wave.extract %1684[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1851 = wave.extract %1684[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1852 = wave.pack %1844, %1845, %1846, %1847, %1848, %1849, %1850, %1851 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1853 = wave.store %1852 -> %1126 after %1843 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1854 = wave.extract %1681[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1855 = wave.extract %1681[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1856 = wave.extract %1681[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1857 = wave.extract %1681[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1858 = wave.extract %1685[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1859 = wave.extract %1685[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1860 = wave.extract %1685[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1861 = wave.extract %1685[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1862 = wave.pack %1854, %1855, %1856, %1857, %1858, %1859, %1860, %1861 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1863 = wave.store %1862 -> %1138 after %1843 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1864 = wave.extract %1682[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1865 = wave.extract %1682[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1866 = wave.extract %1682[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1867 = wave.extract %1682[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1868 = wave.extract %1686[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1869 = wave.extract %1686[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1870 = wave.extract %1686[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1871 = wave.extract %1686[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1872 = wave.pack %1864, %1865, %1866, %1867, %1868, %1869, %1870, %1871 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1873 = wave.store %1872 -> %1150 after %1843 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1874 = wave.extract %1683[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1875 = wave.extract %1683[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1876 = wave.extract %1683[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1877 = wave.extract %1683[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1878 = wave.extract %1687[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1879 = wave.extract %1687[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1880 = wave.extract %1687[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1881 = wave.extract %1687[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1882 = wave.pack %1874, %1875, %1876, %1877, %1878, %1879, %1880, %1881 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1883 = wave.store %1882 -> %1162 after %1843 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1884 = wave.barrier %1853, %1863, %1873, %1883 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_254, %token_255 = wave.load %1175 after %1884 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1885 = wave.extract %value_254[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1886 = wave.extract %value_254[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1887 = wave.extract %value_254[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1888 = wave.extract %value_254[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1889 = wave.extract %value_254[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1890 = wave.extract %value_254[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1891 = wave.extract %value_254[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1892 = wave.extract %value_254[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_256, %token_257 = wave.load %1185 after %1884 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1893 = wave.extract %value_256[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1894 = wave.extract %value_256[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1895 = wave.extract %value_256[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1896 = wave.extract %value_256[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1897 = wave.extract %value_256[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1898 = wave.extract %value_256[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1899 = wave.extract %value_256[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1900 = wave.extract %value_256[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_258, %token_259 = wave.load %1195 after %1884 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1901 = wave.extract %value_258[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1902 = wave.extract %value_258[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1903 = wave.extract %value_258[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1904 = wave.extract %value_258[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1905 = wave.extract %value_258[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1906 = wave.extract %value_258[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1907 = wave.extract %value_258[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1908 = wave.extract %value_258[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_260, %token_261 = wave.load %1205 after %1884 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1909 = wave.extract %value_260[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1910 = wave.extract %value_260[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1911 = wave.extract %value_260[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1912 = wave.extract %value_260[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1913 = wave.extract %value_260[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1914 = wave.extract %value_260[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1915 = wave.extract %value_260[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1916 = wave.extract %value_260[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1917 = wave.barrier %token_255, %token_257, %token_259, %token_261 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1918 = wave.extract %1688[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1919 = wave.extract %1688[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1920 = wave.extract %1688[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1921 = wave.extract %1688[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1922 = wave.extract %1692[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1923 = wave.extract %1692[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1924 = wave.extract %1692[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1925 = wave.extract %1692[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1926 = wave.pack %1918, %1919, %1920, %1921, %1922, %1923, %1924, %1925 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1927 = wave.store %1926 -> %1126 after %1917 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1928 = wave.extract %1689[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1929 = wave.extract %1689[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1930 = wave.extract %1689[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1931 = wave.extract %1689[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1932 = wave.extract %1693[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1933 = wave.extract %1693[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1934 = wave.extract %1693[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1935 = wave.extract %1693[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1936 = wave.pack %1928, %1929, %1930, %1931, %1932, %1933, %1934, %1935 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1937 = wave.store %1936 -> %1138 after %1917 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1938 = wave.extract %1690[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1939 = wave.extract %1690[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1940 = wave.extract %1690[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1941 = wave.extract %1690[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1942 = wave.extract %1694[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1943 = wave.extract %1694[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1944 = wave.extract %1694[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1945 = wave.extract %1694[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1946 = wave.pack %1938, %1939, %1940, %1941, %1942, %1943, %1944, %1945 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1947 = wave.store %1946 -> %1150 after %1917 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1948 = wave.extract %1691[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1949 = wave.extract %1691[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1950 = wave.extract %1691[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1951 = wave.extract %1691[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1952 = wave.extract %1695[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1953 = wave.extract %1695[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1954 = wave.extract %1695[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1955 = wave.extract %1695[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1956 = wave.pack %1948, %1949, %1950, %1951, %1952, %1953, %1954, %1955 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1957 = wave.store %1956 -> %1162 after %1917 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1958 = wave.barrier %1927, %1937, %1947, %1957 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_262, %token_263 = wave.load %1175 after %1958 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1959 = wave.extract %value_262[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1960 = wave.extract %value_262[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1961 = wave.extract %value_262[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1962 = wave.extract %value_262[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1963 = wave.extract %value_262[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1964 = wave.extract %value_262[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1965 = wave.extract %value_262[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1966 = wave.extract %value_262[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_264, %token_265 = wave.load %1185 after %1958 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1967 = wave.extract %value_264[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1968 = wave.extract %value_264[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1969 = wave.extract %value_264[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1970 = wave.extract %value_264[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1971 = wave.extract %value_264[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1972 = wave.extract %value_264[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1973 = wave.extract %value_264[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1974 = wave.extract %value_264[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_266, %token_267 = wave.load %1195 after %1958 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1975 = wave.extract %value_266[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1976 = wave.extract %value_266[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1977 = wave.extract %value_266[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1978 = wave.extract %value_266[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1979 = wave.extract %value_266[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1980 = wave.extract %value_266[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1981 = wave.extract %value_266[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1982 = wave.extract %value_266[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_268, %token_269 = wave.load %1205 after %1958 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1983 = wave.extract %value_268[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1984 = wave.extract %value_268[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1985 = wave.extract %value_268[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1986 = wave.extract %value_268[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1987 = wave.extract %value_268[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1988 = wave.extract %value_268[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1989 = wave.extract %value_268[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1990 = wave.extract %value_268[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1991 = wave.barrier %token_263, %token_265, %token_267, %token_269 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1992 = wave.pack %1737, %1738, %1739, %1740, %1745, %1746, %1747, %1748 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1993 = wave.index_expr <"128 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1994 = wave.assume %1993 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1995 = wave.ptr_add %1438, %1994 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1996 = wave.store %1992 -> %1995 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1997 = wave.pack %1753, %1754, %1755, %1756, %1761, %1762, %1763, %1764 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1998 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1999 = wave.assume %1998 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2000 = wave.ptr_add %1438, %1999 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2001 = wave.store %1997 -> %2000 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2002 = wave.pack %1741, %1742, %1743, %1744, %1749, %1750, %1751, %1752 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2003 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2004 = wave.assume %2003 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2005 = wave.ptr_add %1438, %2004 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2006 = wave.store %2002 -> %2005 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2007 = wave.pack %1757, %1758, %1759, %1760, %1765, %1766, %1767, %1768 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2008 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2009 = wave.assume %2008 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2010 = wave.ptr_add %1438, %2009 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2011 = wave.store %2007 -> %2010 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2012 = wave.pack %1811, %1812, %1813, %1814, %1819, %1820, %1821, %1822 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2013 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2014 = wave.assume %2013 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2015 = wave.ptr_add %1438, %2014 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2016 = wave.store %2012 -> %2015 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2017 = wave.pack %1827, %1828, %1829, %1830, %1835, %1836, %1837, %1838 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2018 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2019 = wave.assume %2018 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2020 = wave.ptr_add %1438, %2019 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2021 = wave.store %2017 -> %2020 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2022 = wave.pack %1815, %1816, %1817, %1818, %1823, %1824, %1825, %1826 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2023 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2024 = wave.assume %2023 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2025 = wave.ptr_add %1438, %2024 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2026 = wave.store %2022 -> %2025 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2027 = wave.pack %1831, %1832, %1833, %1834, %1839, %1840, %1841, %1842 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2028 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2029 = wave.assume %2028 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2030 = wave.ptr_add %1438, %2029 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2031 = wave.store %2027 -> %2030 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2032 = wave.pack %1885, %1886, %1887, %1888, %1893, %1894, %1895, %1896 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2033 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2034 = wave.assume %2033 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2035 = wave.ptr_add %1438, %2034 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2036 = wave.store %2032 -> %2035 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2037 = wave.pack %1901, %1902, %1903, %1904, %1909, %1910, %1911, %1912 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2038 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2039 = wave.assume %2038 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2040 = wave.ptr_add %1438, %2039 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2041 = wave.store %2037 -> %2040 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2042 = wave.pack %1889, %1890, %1891, %1892, %1897, %1898, %1899, %1900 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2043 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2044 = wave.assume %2043 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2045 = wave.ptr_add %1438, %2044 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2046 = wave.store %2042 -> %2045 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2047 = wave.pack %1905, %1906, %1907, %1908, %1913, %1914, %1915, %1916 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2048 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2049 = wave.assume %2048 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2050 = wave.ptr_add %1438, %2049 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2051 = wave.store %2047 -> %2050 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2052 = wave.pack %1959, %1960, %1961, %1962, %1967, %1968, %1969, %1970 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2053 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2054 = wave.assume %2053 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2055 = wave.ptr_add %1438, %2054 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2056 = wave.store %2052 -> %2055 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2057 = wave.pack %1975, %1976, %1977, %1978, %1983, %1984, %1985, %1986 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2058 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2059 = wave.assume %2058 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2060 = wave.ptr_add %1438, %2059 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2061 = wave.store %2057 -> %2060 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2062 = wave.pack %1963, %1964, %1965, %1966, %1971, %1972, %1973, %1974 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2063 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2064 = wave.assume %2063 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2065 = wave.ptr_add %1438, %2064 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2066 = wave.store %2062 -> %2065 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2067 = wave.pack %1979, %1980, %1981, %1982, %1987, %1988, %1989, %1990 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2068 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%49, %arg9, %42) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2069 = wave.assume %2068 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2070 = wave.ptr_add %1438, %2069 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2071 = wave.store %2067 -> %2070 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      return
    }
  }
}
