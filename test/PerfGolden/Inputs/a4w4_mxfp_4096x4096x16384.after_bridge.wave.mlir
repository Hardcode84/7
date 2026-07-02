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
      %15 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %16 = wave.pack %15, %15, %15, %15 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %17 = wave.workgroup_id 0
      %18 = wave.binary addi %arg5, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %19 = wave.binary divsi %18, %c256_i32 : i32, i32 -> i32
      %20 = wave.binary addi %arg6, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %21 = wave.binary divsi %20, %c256_i32 : i32, i32 -> i32
      %22 = wave.binary remui %17, %c8_i32 : i32, i32 -> i32
      %23 = wave.binary divui %17, %c8_i32 : i32, i32 -> i32
      %24 = wave.binary muli %22, %c32_i32 overflow<nsw> : i32, i32 -> i32
      %25 = wave.binary addi %24, %23 overflow<nsw> : i32, i32 -> i32
      %26 = wave.binary muli %21, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %27 = wave.binary divsi %25, %26 : i32, i32 -> i32
      %28 = wave.binary muli %27, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %29 = wave.binary subi %19, %28 overflow<nsw> : i32, i32 -> i32
      %30 = arith.cmpi slt, %29, %c4_i32 : i32
      %31 = wave.select %30, %29, %c4_i32 : i32
      %32 = wave.binary remsi %25, %26 : i32, i32 -> i32
      %33 = wave.assume %31 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %34 = wave.binary remui %32, %33 : i32, i32 -> i32
      %35 = wave.binary addi %28, %34 overflow<nsw> : i32, i32 -> i32
      %36 = wave.assume %31 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %37 = wave.binary divui %32, %36 : i32, i32 -> i32
      %38 = wave.binary muli %35, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %39 = wave.binary muli %38, %arg7 : i32, i32 -> i32
      %40 = wave.binary muli %arg8, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %41 = wave.binary muli %37, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %42 = wave.binary muli %41, %arg8 : i32, i32 -> i32
      %43 = wave.binary muli %arg11, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %44 = wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
      %45 = wave.ptr_add %arg0, %39 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %46 = waveamd.make_buffer %45, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %47 = wave.ptr_cast %44 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %48 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %49 = wave.read_first %48 : !wave.simd<i32, 64> -> i32
      %50 = wave.assume %49 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-255 + x <= 0">] : i32
      %51 = wave.binary divui %50, %c64_i32 : i32, i32 -> i32
      %52 = wave.binary muli %51, %c264_i32 overflow<nsw> : i32, i32 -> i32
      %53 = wave.token : !wave.mem.token
      %54 = wave.index_expr <"128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %55 = wave.assume %54 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %56 = wave.ptr_add %46, %55 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %57 = wave.ptr_add %47, %52 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %58 = waveamd.dma_load_lds %56 -> %57 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %59 = wave.index_expr <"4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %60 = wave.assume %59 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %61 = wave.ptr_add %46, %60 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %62 = wave.binary addi %52, %c1056_i32 overflow<nsw> : i32, i32 -> i32
      %63 = wave.ptr_add %47, %62 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %64 = waveamd.dma_load_lds %61 -> %63 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %65 = wave.index_expr <"8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %66 = wave.assume %65 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %67 = wave.ptr_add %46, %66 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %68 = wave.binary addi %52, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %69 = wave.ptr_add %47, %68 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %70 = waveamd.dma_load_lds %67 -> %69 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %71 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %72 = wave.assume %71 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %73 = wave.ptr_add %46, %72 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %74 = wave.binary addi %52, %c3168_i32 overflow<nsw> : i32, i32 -> i32
      %75 = wave.ptr_add %47, %74 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %76 = waveamd.dma_load_lds %73 -> %75 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %77 = wave.index_expr <"128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %78 = wave.assume %77 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %79 = wave.ptr_add %46, %78 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %80 = wave.binary addi %52, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %81 = wave.ptr_add %47, %80 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %82 = waveamd.dma_load_lds %79 -> %81 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %83 = wave.index_expr <"128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %84 = wave.assume %83 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %85 = wave.ptr_add %46, %84 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %86 = wave.binary addi %52, %c5280_i32 overflow<nsw> : i32, i32 -> i32
      %87 = wave.ptr_add %47, %86 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %88 = waveamd.dma_load_lds %85 -> %87 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %89 = wave.index_expr <"128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %90 = wave.assume %89 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %91 = wave.ptr_add %46, %90 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %92 = wave.binary addi %52, %c6336_i32 overflow<nsw> : i32, i32 -> i32
      %93 = wave.ptr_add %47, %92 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %94 = waveamd.dma_load_lds %91 -> %93 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %95 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %96 = wave.assume %95 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %97 = wave.ptr_add %46, %96 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %98 = wave.binary addi %52, %c7392_i32 overflow<nsw> : i32, i32 -> i32
      %99 = wave.ptr_add %47, %98 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %100 = waveamd.dma_load_lds %97 -> %99 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %101 = wave.join %58, %64, %70, %76, %82, %88, %94, %100 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %102 = wave.shared_memory_base {offset = 67520 : i64} : !wave.ptr<#wave.shared, i8>
      %103 = wave.ptr_add %arg1, %42 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %104 = waveamd.make_buffer %103, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %105 = wave.ptr_cast %102 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %106 = wave.index_expr <"8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %107 = wave.assume %106 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %108 = wave.ptr_add %104, %107 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %109 = wave.ptr_add %105, %52 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %110 = waveamd.dma_load_lds %108 -> %109 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %111 = wave.index_expr <"4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %112 = wave.assume %111 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %113 = wave.ptr_add %104, %112 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %114 = wave.ptr_add %105, %62 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %115 = waveamd.dma_load_lds %113 -> %114 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %116 = wave.index_expr <"8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %117 = wave.assume %116 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %118 = wave.ptr_add %104, %117 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %119 = wave.ptr_add %105, %68 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %120 = waveamd.dma_load_lds %118 -> %119 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %121 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %122 = wave.assume %121 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %123 = wave.ptr_add %104, %122 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %124 = wave.ptr_add %105, %74 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %125 = waveamd.dma_load_lds %123 -> %124 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %126 = wave.join %110, %115, %120, %125 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %127 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %128 = wave.index_expr <"s0*s1 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %129 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %130 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %131 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %132 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(128 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %133 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(160 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %134 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(192 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %135 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(224 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %136 = wave.assume %128 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %137 = wave.ptr_add %127, %136 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value, %token = wave.load %137 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %138 = wave.assume %129 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %139 = wave.ptr_add %127, %138 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_0, %token_1 = wave.load %139 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %140 = wave.assume %130 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %141 = wave.ptr_add %127, %140 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_2, %token_3 = wave.load %141 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %142 = wave.assume %131 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %143 = wave.ptr_add %127, %142 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_4, %token_5 = wave.load %143 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %144 = wave.assume %132 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %145 = wave.ptr_add %127, %144 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_6, %token_7 = wave.load %145 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %146 = wave.assume %133 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %147 = wave.ptr_add %127, %146 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_8, %token_9 = wave.load %147 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %148 = wave.assume %134 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %149 = wave.ptr_add %127, %148 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_10, %token_11 = wave.load %149 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %150 = wave.assume %135 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %151 = wave.ptr_add %127, %150 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_12, %token_13 = wave.load %151 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %152 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %153 = wave.index_expr <"s0*s1 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg11, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %154 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg11, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %155 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg11, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %156 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg11, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %157 = wave.assume %153 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %158 = wave.ptr_add %152, %157 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_14, %token_15 = wave.load %158 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %159 = wave.assume %154 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %160 = wave.ptr_add %152, %159 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_16, %token_17 = wave.load %160 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %161 = wave.assume %155 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %162 = wave.ptr_add %152, %161 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_18, %token_19 = wave.load %162 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %163 = wave.assume %156 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %164 = wave.ptr_add %152, %163 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_20, %token_21 = wave.load %164 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %165 = wave.join %101, %126 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %166 = wave.shared_memory_base {offset = 101248 : i64} : !wave.ptr<#wave.shared, i8>
      %167 = wave.ptr_cast %166 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %168 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%48, %arg8, %40) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %169 = wave.assume %168 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %170 = wave.ptr_add %104, %169 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %171 = wave.ptr_add %167, %52 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %172 = waveamd.dma_load_lds %170 -> %171 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %173 = wave.index_expr <"s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%48, %arg8, %40) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %174 = wave.assume %173 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %175 = wave.ptr_add %104, %174 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %176 = wave.ptr_add %167, %62 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %177 = waveamd.dma_load_lds %175 -> %176 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %178 = wave.index_expr <"s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%48, %arg8, %40) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %179 = wave.assume %178 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %180 = wave.ptr_add %104, %179 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %181 = wave.ptr_add %167, %68 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %182 = waveamd.dma_load_lds %180 -> %181 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %183 = wave.index_expr <"s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%48, %arg8, %40) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %184 = wave.assume %183 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %185 = wave.ptr_add %104, %184 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %186 = wave.ptr_add %167, %74 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %187 = waveamd.dma_load_lds %185 -> %186 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %188 = wave.join %172, %177, %182, %187 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %189 = wave.index_expr <"s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%48, %arg11, %43, %41) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %190 = wave.index_expr <"s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%48, %arg11, %43, %41) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %191 = wave.index_expr <"2*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%48, %arg11, %43, %41) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %192 = wave.index_expr <"3*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%48, %arg11, %43, %41) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %193 = wave.assume %189 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %194 = wave.ptr_add %152, %193 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_22, %token_23 = wave.load %194 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %195 = wave.assume %190 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %196 = wave.ptr_add %152, %195 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_24, %token_25 = wave.load %196 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %197 = wave.assume %191 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %198 = wave.ptr_add %152, %197 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_26, %token_27 = wave.load %198 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %199 = wave.assume %192 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %200 = wave.ptr_add %152, %199 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_28, %token_29 = wave.load %200 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %201 = wave.shared_memory_base {offset = 33760 : i64} : !wave.ptr<#wave.shared, i8>
      %202 = wave.ptr_cast %201 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %203 = wave.index_expr <"128 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %204 = wave.assume %203 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %205 = wave.ptr_add %46, %204 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %206 = wave.ptr_add %202, %52 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %207 = waveamd.dma_load_lds %205 -> %206 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %208 = wave.index_expr <"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %209 = wave.assume %208 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %210 = wave.ptr_add %46, %209 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %211 = wave.ptr_add %202, %62 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %212 = waveamd.dma_load_lds %210 -> %211 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %213 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %214 = wave.assume %213 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %215 = wave.ptr_add %46, %214 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %216 = wave.ptr_add %202, %68 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %217 = waveamd.dma_load_lds %215 -> %216 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %218 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %219 = wave.assume %218 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %220 = wave.ptr_add %46, %219 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %221 = wave.ptr_add %202, %74 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %222 = waveamd.dma_load_lds %220 -> %221 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %223 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %224 = wave.assume %223 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %225 = wave.ptr_add %46, %224 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %226 = wave.ptr_add %202, %80 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %227 = waveamd.dma_load_lds %225 -> %226 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %228 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %229 = wave.assume %228 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %230 = wave.ptr_add %46, %229 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %231 = wave.ptr_add %202, %86 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %232 = waveamd.dma_load_lds %230 -> %231 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %233 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %234 = wave.assume %233 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %235 = wave.ptr_add %46, %234 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %236 = wave.ptr_add %202, %92 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %237 = waveamd.dma_load_lds %235 -> %236 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %238 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %239 = wave.assume %238 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %240 = wave.ptr_add %46, %239 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %241 = wave.ptr_add %202, %98 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %242 = waveamd.dma_load_lds %240 -> %241 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %243 = wave.join %207, %212, %217, %222, %227, %232, %237, %242 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %244 = wave.shared_memory_base {offset = 84384 : i64} : !wave.ptr<#wave.shared, i8>
      %245 = wave.ptr_cast %244 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %246 = wave.index_expr <"128 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %247 = wave.assume %246 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %248 = wave.ptr_add %104, %247 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %249 = wave.ptr_add %245, %52 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %250 = waveamd.dma_load_lds %248 -> %249 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %251 = wave.index_expr <"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %252 = wave.assume %251 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %253 = wave.ptr_add %104, %252 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %254 = wave.ptr_add %245, %62 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %255 = waveamd.dma_load_lds %253 -> %254 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %256 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %257 = wave.assume %256 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %258 = wave.ptr_add %104, %257 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %259 = wave.ptr_add %245, %68 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %260 = waveamd.dma_load_lds %258 -> %259 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %261 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%48, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %262 = wave.assume %261 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %263 = wave.ptr_add %104, %262 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %264 = wave.ptr_add %245, %74 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %265 = waveamd.dma_load_lds %263 -> %264 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %266 = wave.join %250, %255, %260, %265 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %267 = wave.index_expr <"8 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %268 = wave.index_expr <"8 + s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %269 = wave.index_expr <"8 + 2*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %270 = wave.index_expr <"8 + 3*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %271 = wave.index_expr <"8 + 4*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %272 = wave.index_expr <"8 + 5*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %273 = wave.index_expr <"8 + 6*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %274 = wave.index_expr <"8 + 7*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg10, %38) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %275 = wave.assume %267 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %276 = wave.ptr_add %127, %275 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_30, %token_31 = wave.load %276 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %277 = wave.assume %268 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %278 = wave.ptr_add %127, %277 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_32, %token_33 = wave.load %278 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %279 = wave.assume %269 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %280 = wave.ptr_add %127, %279 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_34, %token_35 = wave.load %280 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %281 = wave.assume %270 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %282 = wave.ptr_add %127, %281 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_36, %token_37 = wave.load %282 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %283 = wave.assume %271 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %284 = wave.ptr_add %127, %283 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_38, %token_39 = wave.load %284 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %285 = wave.assume %272 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %286 = wave.ptr_add %127, %285 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_40, %token_41 = wave.load %286 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %287 = wave.assume %273 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %288 = wave.ptr_add %127, %287 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_42, %token_43 = wave.load %288 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %289 = wave.assume %274 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %290 = wave.ptr_add %127, %289 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_44, %token_45 = wave.load %290 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %291 = wave.index_expr <"8 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg11, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %292 = wave.index_expr <"8 + s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg11, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %293 = wave.index_expr <"8 + 2*s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg11, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %294 = wave.index_expr <"8 + 3*s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%48, %arg11, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %295 = wave.assume %291 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %296 = wave.ptr_add %152, %295 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_46, %token_47 = wave.load %296 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %297 = wave.assume %292 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %298 = wave.ptr_add %152, %297 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_48, %token_49 = wave.load %298 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %299 = wave.assume %293 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %300 = wave.ptr_add %152, %299 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_50, %token_51 = wave.load %300 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %301 = wave.assume %294 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %302 = wave.ptr_add %152, %301 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_52, %token_53 = wave.load %302 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %303 = wave.join %243, %266 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %304 = wave.shared_memory_base {offset = 118112 : i64} : !wave.ptr<#wave.shared, i8>
      %305 = wave.ptr_cast %304 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %306 = wave.index_expr <"128 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%48, %arg8, %40) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %307 = wave.assume %306 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %308 = wave.ptr_add %104, %307 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %309 = wave.ptr_add %305, %52 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %310 = waveamd.dma_load_lds %308 -> %309 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %311 = wave.index_expr <"128 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%48, %arg8, %40) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %312 = wave.assume %311 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %313 = wave.ptr_add %104, %312 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %314 = wave.ptr_add %305, %62 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %315 = waveamd.dma_load_lds %313 -> %314 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %316 = wave.index_expr <"128 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%48, %arg8, %40) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %317 = wave.assume %316 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %318 = wave.ptr_add %104, %317 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %319 = wave.ptr_add %305, %68 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %320 = waveamd.dma_load_lds %318 -> %319 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %321 = wave.index_expr <"128 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%48, %arg8, %40) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %322 = wave.assume %321 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %323 = wave.ptr_add %104, %322 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %324 = wave.ptr_add %305, %74 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %325 = waveamd.dma_load_lds %323 -> %324 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %326 = wave.join %310, %315, %320, %325 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %327 = wave.index_expr <"8 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%48, %arg11, %43, %41) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %328 = wave.index_expr <"8 + s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%48, %arg11, %43, %41) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %329 = wave.index_expr <"8 + 2*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%48, %arg11, %43, %41) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %330 = wave.index_expr <"8 + 3*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%48, %arg11, %43, %41) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %331 = wave.assume %327 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %332 = wave.ptr_add %152, %331 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_54, %token_55 = wave.load %332 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %333 = wave.assume %328 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %334 = wave.ptr_add %152, %333 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_56, %token_57 = wave.load %334 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %335 = wave.assume %329 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %336 = wave.ptr_add %152, %335 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_58, %token_59 = wave.load %336 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %337 = wave.assume %330 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %338 = wave.ptr_add %152, %337 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_60, %token_61 = wave.load %338 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %339 = wave.binary addi %39, %c256_i32 : i32, i32 -> i32
      %340 = wave.binary addi %42, %c256_i32 : i32, i32 -> i32
      wave.wait %165 : !wave.mem.token
      %341 = wave.barrier %165 : (!wave.mem.token) -> !wave.mem.token
      %342 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 16896*Mod(floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %343 = wave.ptr_add %44, %342 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_62, %token_63 = wave.load %343 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %344 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %345 = wave.ptr_add %44, %344 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_64, %token_65 = wave.load %345 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %346 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %347 = wave.ptr_add %44, %346 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_66, %token_67 = wave.load %347 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %348 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %349 = wave.ptr_add %44, %348 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_68, %token_69 = wave.load %349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %350 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %351 = wave.ptr_add %44, %350 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_70, %token_71 = wave.load %351 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %352 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/2*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %353 = wave.ptr_add %44, %352 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_72, %token_73 = wave.load %353 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %354 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %355 = wave.ptr_add %44, %354 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_74, %token_75 = wave.load %355 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %356 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/2*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %357 = wave.ptr_add %44, %356 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_76, %token_77 = wave.load %357 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %358 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 16896*Mod(1 + floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %359 = wave.ptr_add %44, %358 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_78, %token_79 = wave.load %359 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %360 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 16896*Mod(1 + floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %361 = wave.ptr_add %44, %360 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_80, %token_81 = wave.load %361 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %362 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %363 = wave.ptr_add %44, %362 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_82, %token_83 = wave.load %363 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %364 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %365 = wave.ptr_add %44, %364 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_84, %token_85 = wave.load %365 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %366 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %367 = wave.ptr_add %44, %366 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_86, %token_87 = wave.load %367 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %368 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/2*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %369 = wave.ptr_add %44, %368 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_88, %token_89 = wave.load %369 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %370 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %371 = wave.ptr_add %44, %370 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_90, %token_91 = wave.load %371 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %372 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/2*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %373 = wave.ptr_add %44, %372 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_92, %token_93 = wave.load %373 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %374 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %375 = wave.ptr_add %102, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_94, %token_95 = wave.load %375 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %376 = wave.index_expr <"64 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %377 = wave.ptr_add %102, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_96, %token_97 = wave.load %377 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %378 = wave.index_expr <"256 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %379 = wave.ptr_add %102, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_98, %token_99 = wave.load %379 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %380 = wave.index_expr <"320 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %381 = wave.ptr_add %102, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_100, %token_101 = wave.load %381 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %382 = wave.index_expr <"512 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %383 = wave.ptr_add %102, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_102, %token_103 = wave.load %383 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %384 = wave.index_expr <"576 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %385 = wave.ptr_add %102, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_104, %token_105 = wave.load %385 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %386 = wave.index_expr <"768 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %387 = wave.ptr_add %102, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_106, %token_107 = wave.load %387 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %388 = wave.index_expr <"832 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %389 = wave.ptr_add %102, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_108, %token_109 = wave.load %389 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %390 = wave.shared_memory_base {offset = 134976 : i64} : !wave.ptr<#wave.shared, i8>
      %391 = wave.binary divui %48, %14 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %392 = wave.binary remui %391, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %393 = wave.binary divui %48, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %394 = wave.binary remui %393, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %395 = wave.binary muli %394, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %396 = wave.binary xori %392, %395 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %397 = wave.binary divui %48, %11 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %398 = wave.binary remui %397, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %399 = wave.binary muli %398, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %400 = wave.binary xori %396, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %401 = wave.binary divui %48, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %402 = wave.binary remui %401, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %403 = wave.binary muli %402, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %404 = wave.binary xori %400, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %405 = wave.binary divui %48, %8 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %406 = wave.binary remui %405, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %407 = wave.binary muli %406, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %408 = wave.binary xori %404, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %409 = wave.binary remui %48, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %410 = wave.binary divui %48, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %411 = wave.binary remui %410, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %412 = wave.binary muli %411, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %413 = wave.binary xori %409, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %414 = wave.binary divui %48, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %415 = wave.binary remui %414, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %416 = wave.binary muli %415, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %417 = wave.binary xori %413, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %418 = wave.binary muli %417, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %419 = wave.binary addi %418, %408 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %420 = wave.binary xori %11, %392 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %421 = wave.binary xori %420, %395 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %422 = wave.binary xori %421, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %423 = wave.binary xori %422, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %424 = wave.binary xori %423, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %425 = wave.binary addi %418, %424 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %426 = wave.binary xori %9, %392 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %427 = wave.binary xori %426, %395 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %428 = wave.binary xori %427, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %429 = wave.binary xori %428, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %430 = wave.binary xori %429, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %431 = wave.binary addi %418, %430 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %432 = wave.binary xori %6, %392 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %433 = wave.binary xori %432, %395 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %434 = wave.binary xori %433, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %435 = wave.binary xori %434, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %436 = wave.binary xori %435, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %437 = wave.binary addi %418, %436 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %438 = wave.binary xori %8, %392 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %439 = wave.binary xori %438, %395 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %440 = wave.binary xori %439, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %441 = wave.binary xori %440, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %442 = wave.binary xori %441, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %443 = wave.binary addi %418, %442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %444 = wave.binary xori %5, %392 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %445 = wave.binary xori %444, %395 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %446 = wave.binary xori %445, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %447 = wave.binary xori %446, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %448 = wave.binary xori %447, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %449 = wave.binary addi %418, %448 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %450 = wave.binary xori %4, %392 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %451 = wave.binary xori %450, %395 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %452 = wave.binary xori %451, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %453 = wave.binary xori %452, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %454 = wave.binary xori %453, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %455 = wave.binary addi %418, %454 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %456 = wave.binary xori %3, %392 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %457 = wave.binary xori %456, %395 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %458 = wave.binary xori %457, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %459 = wave.binary xori %458, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %460 = wave.binary xori %459, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %461 = wave.binary addi %418, %460 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %462 = wave.ptr_add %390, %419 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %463 = wave.store %value -> %462 after %53 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %464 = wave.ptr_add %390, %425 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %465 = wave.store %value_0 -> %464 after %53 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %466 = wave.ptr_add %390, %431 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %467 = wave.store %value_2 -> %466 after %53 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %468 = wave.ptr_add %390, %437 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %469 = wave.store %value_4 -> %468 after %53 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %470 = wave.ptr_add %390, %443 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %471 = wave.store %value_6 -> %470 after %53 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %472 = wave.ptr_add %390, %449 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %473 = wave.store %value_8 -> %472 after %53 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %474 = wave.ptr_add %390, %455 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %475 = wave.store %value_10 -> %474 after %53 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %476 = wave.ptr_add %390, %461 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %477 = wave.store %value_12 -> %476 after %53 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %478 = wave.barrier %463, %465, %467, %469, %471, %473, %475, %477 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %479 = wave.shared_memory_base {offset = 137024 : i64} : !wave.ptr<#wave.shared, i8>
      %480 = wave.binary muli %417, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %481 = wave.binary addi %480, %408 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %482 = wave.binary addi %480, %424 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %483 = wave.binary addi %480, %430 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %484 = wave.binary addi %480, %436 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %485 = wave.ptr_add %479, %481 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %486 = wave.store %value_14 -> %485 after %478 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %487 = wave.ptr_add %479, %482 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %488 = wave.store %value_16 -> %487 after %478 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %489 = wave.ptr_add %479, %483 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %490 = wave.store %value_18 -> %489 after %478 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %491 = wave.ptr_add %479, %484 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %492 = wave.store %value_20 -> %491 after %478 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %493 = wave.barrier %486, %488, %490, %492 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %494 = wave.index_expr <"8*Mod(wi, 2) + 16*Mod(floor(1/128*wi), 2) + 512*Mod(floor(1/32*wi), 2) + 256*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 1024*Mod(floor(1/2*wi), 2)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %495 = wave.ptr_add %390, %494 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_110, %token_111 = waveamd.transpose_load %495 after %493 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %496 = wave.extract %value_110[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %497 = wave.extract %value_110[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %498 = wave.extract %value_110[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %499 = wave.extract %value_110[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %500 = wave.pack %496, %497, %498, %499 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %501 = wave.extract %value_110[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %502 = wave.extract %value_110[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %503 = wave.extract %value_110[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %504 = wave.extract %value_110[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %505 = wave.pack %501, %502, %503, %504 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %506 = wave.index_expr <"128 + 8*Mod(wi, 2) + 16*Mod(floor(1/128*wi), 2) + 512*Mod(floor(1/32*wi), 2) + 256*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 1024*Mod(floor(1/2*wi), 2)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %507 = wave.ptr_add %390, %506 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_112, %token_113 = waveamd.transpose_load %507 after %493 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %508 = wave.extract %value_112[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %509 = wave.extract %value_112[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %510 = wave.extract %value_112[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %511 = wave.extract %value_112[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %512 = wave.pack %508, %509, %510, %511 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %513 = wave.extract %value_112[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %514 = wave.extract %value_112[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %515 = wave.extract %value_112[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %516 = wave.extract %value_112[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %517 = wave.pack %513, %514, %515, %516 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %518 = wave.join %token_111, %token_113 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %519 = wave.index_expr <"8*Mod(wi, 2) + 16*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/32*wi), 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 512*Mod(floor(1/2*wi), 2)"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %520 = wave.ptr_add %479, %519 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_114, %token_115 = waveamd.transpose_load %520 after %518 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %521 = wave.extract %value_114[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %522 = wave.extract %value_114[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %523 = wave.extract %value_114[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %524 = wave.extract %value_114[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %525 = wave.pack %521, %522, %523, %524 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %526 = wave.extract %value_114[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %527 = wave.extract %value_114[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %528 = wave.extract %value_114[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %529 = wave.extract %value_114[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %530 = wave.pack %526, %527, %528, %529 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %531:121 = scf.for %arg12 = %c0_i32 to %c62_i32 step %c2_i32 iter_args(%arg13 = %339, %arg14 = %340, %arg15 = %c16_i32, %arg16 = %c16_i32, %arg17 = %16, %arg18 = %16, %arg19 = %16, %arg20 = %16, %arg21 = %16, %arg22 = %16, %arg23 = %16, %arg24 = %16, %arg25 = %16, %arg26 = %16, %arg27 = %16, %arg28 = %16, %arg29 = %16, %arg30 = %16, %arg31 = %16, %arg32 = %16, %arg33 = %16, %arg34 = %16, %arg35 = %16, %arg36 = %16, %arg37 = %16, %arg38 = %16, %arg39 = %16, %arg40 = %16, %arg41 = %16, %arg42 = %16, %arg43 = %16, %arg44 = %16, %arg45 = %16, %arg46 = %16, %arg47 = %16, %arg48 = %16, %arg49 = %16, %arg50 = %16, %arg51 = %16, %arg52 = %16, %arg53 = %16, %arg54 = %16, %arg55 = %16, %arg56 = %16, %arg57 = %16, %arg58 = %16, %arg59 = %16, %arg60 = %16, %arg61 = %16, %arg62 = %16, %arg63 = %16, %arg64 = %16, %arg65 = %16, %arg66 = %16, %arg67 = %16, %arg68 = %16, %arg69 = %16, %arg70 = %16, %arg71 = %16, %arg72 = %16, %arg73 = %16, %arg74 = %16, %arg75 = %16, %arg76 = %16, %arg77 = %16, %arg78 = %16, %arg79 = %16, %arg80 = %16, %arg81 = %value_22, %arg82 = %value_24, %arg83 = %value_26, %arg84 = %value_28, %arg85 = %value_30, %arg86 = %value_32, %arg87 = %value_34, %arg88 = %value_36, %arg89 = %value_38, %arg90 = %value_40, %arg91 = %value_42, %arg92 = %value_44, %arg93 = %value_46, %arg94 = %value_48, %arg95 = %value_50, %arg96 = %value_52, %arg97 = %value_54, %arg98 = %value_56, %arg99 = %value_58, %arg100 = %value_60, %arg101 = %value_62, %arg102 = %value_64, %arg103 = %value_66, %arg104 = %value_68, %arg105 = %value_70, %arg106 = %value_72, %arg107 = %value_74, %arg108 = %value_76, %arg109 = %value_78, %arg110 = %value_80, %arg111 = %value_82, %arg112 = %value_84, %arg113 = %value_86, %arg114 = %value_88, %arg115 = %value_90, %arg116 = %value_92, %arg117 = %value_94, %arg118 = %value_96, %arg119 = %value_98, %arg120 = %value_100, %arg121 = %value_102, %arg122 = %value_104, %arg123 = %value_106, %arg124 = %value_108, %arg125 = %500, %arg126 = %505, %arg127 = %512, %arg128 = %517, %arg129 = %525, %arg130 = %530, %arg131 = %188, %arg132 = %303, %arg133 = %326) -> (i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %2076 = waveamd.fragment_pack %arg101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2077 = waveamd.fragment_pack %arg102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2078 = waveamd.fragment_pack %arg103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2079 = waveamd.fragment_pack %arg104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2080 = waveamd.fragment_pack %arg105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2081 = waveamd.fragment_pack %arg106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2082 = waveamd.fragment_pack %arg107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2083 = waveamd.fragment_pack %arg108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2084 = waveamd.fragment_pack %arg109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2085 = waveamd.fragment_pack %arg110 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2086 = waveamd.fragment_pack %arg111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2087 = waveamd.fragment_pack %arg112 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2088 = waveamd.fragment_pack %arg113 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2089 = waveamd.fragment_pack %arg114 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2090 = waveamd.fragment_pack %arg115 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2091 = waveamd.fragment_pack %arg116 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2092 = waveamd.fragment_pack %arg117 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2093 = waveamd.fragment_pack %arg118 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2094 = waveamd.fragment_pack %arg119 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2095 = waveamd.fragment_pack %arg120 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2096 = waveamd.fragment_pack %arg121 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2097 = waveamd.fragment_pack %arg122 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2098 = waveamd.fragment_pack %arg123 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2099 = waveamd.fragment_pack %arg124 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2100 = waveamd.fragment_pack %arg17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2101 = waveamd.fragment_pack %arg18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2102 = waveamd.fragment_pack %arg19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2103 = waveamd.fragment_pack %arg20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2104 = waveamd.fragment_pack %arg21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2105 = waveamd.fragment_pack %arg22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2106 = waveamd.fragment_pack %arg23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2107 = waveamd.fragment_pack %arg24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2108 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2109 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2110 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2111 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2112 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2113 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2114 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2115 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2116 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2117 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2118 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2119 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2120 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2121 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2122 = waveamd.fragment_pack %arg39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2123 = waveamd.fragment_pack %arg40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2124 = waveamd.fragment_pack %arg41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2125 = waveamd.fragment_pack %arg42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2126 = waveamd.fragment_pack %arg43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2127 = waveamd.fragment_pack %arg44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2128 = waveamd.fragment_pack %arg45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2129 = waveamd.fragment_pack %arg46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2130 = waveamd.fragment_pack %arg47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2131 = waveamd.fragment_pack %arg48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2132 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %arg129, %2076, %arg125, %2100 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2133 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %arg129, %2077, %arg125, %2132 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2134 = waveamd.fragment_unpack %2133 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2135 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %arg129, %2076, %arg125, %2101 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2136 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %arg129, %2077, %arg125, %2135 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2137 = waveamd.fragment_unpack %2136 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2138 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2096, %arg130, %2076, %arg125, %2102 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2139 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2097, %arg130, %2077, %arg125, %2138 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2140 = waveamd.fragment_unpack %2139 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2141 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2098, %arg130, %2076, %arg125, %2103 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2142 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2099, %arg130, %2077, %arg125, %2141 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2143 = waveamd.fragment_unpack %2142 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2144 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %arg129, %2078, %arg125, %2104 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2145 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %arg129, %2079, %arg125, %2144 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2146 = waveamd.fragment_unpack %2145 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2147 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %arg129, %2078, %arg125, %2105 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2148 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %arg129, %2079, %arg125, %2147 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2149 = waveamd.fragment_unpack %2148 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2150 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2096, %arg130, %2078, %arg125, %2106 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2151 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2097, %arg130, %2079, %arg125, %2150 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2152 = waveamd.fragment_unpack %2151 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2153 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2098, %arg130, %2078, %arg125, %2107 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2154 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2099, %arg130, %2079, %arg125, %2153 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2155 = waveamd.fragment_unpack %2154 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2156 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %arg129, %2080, %arg126, %2108 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2157 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %arg129, %2081, %arg126, %2156 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2158 = waveamd.fragment_unpack %2157 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2159 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %arg129, %2080, %arg126, %2109 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2160 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %arg129, %2081, %arg126, %2159 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2161 = waveamd.fragment_unpack %2160 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2162 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2096, %arg130, %2080, %arg126, %2110 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2163 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2097, %arg130, %2081, %arg126, %2162 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2164 = waveamd.fragment_unpack %2163 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2165 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2098, %arg130, %2080, %arg126, %2111 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2166 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2099, %arg130, %2081, %arg126, %2165 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2167 = waveamd.fragment_unpack %2166 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2168 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %arg129, %2082, %arg126, %2112 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2169 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %arg129, %2083, %arg126, %2168 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2170 = waveamd.fragment_unpack %2169 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2171 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %arg129, %2082, %arg126, %2113 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2172 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %arg129, %2083, %arg126, %2171 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2173 = waveamd.fragment_unpack %2172 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2174 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2096, %arg130, %2082, %arg126, %2114 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2175 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2097, %arg130, %2083, %arg126, %2174 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2176 = waveamd.fragment_unpack %2175 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2177 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2098, %arg130, %2082, %arg126, %2115 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2178 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2099, %arg130, %2083, %arg126, %2177 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2179 = waveamd.fragment_unpack %2178 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2180 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %arg129, %2084, %arg127, %2116 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2181 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %arg129, %2085, %arg127, %2180 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2182 = waveamd.fragment_unpack %2181 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2183 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %arg129, %2084, %arg127, %2117 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2184 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %arg129, %2085, %arg127, %2183 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2185 = waveamd.fragment_unpack %2184 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2186 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2096, %arg130, %2084, %arg127, %2118 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2187 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2097, %arg130, %2085, %arg127, %2186 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2188 = waveamd.fragment_unpack %2187 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2189 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2098, %arg130, %2084, %arg127, %2119 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2190 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2099, %arg130, %2085, %arg127, %2189 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2191 = waveamd.fragment_unpack %2190 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2192 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %arg129, %2086, %arg127, %2120 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2193 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %arg129, %2087, %arg127, %2192 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2194 = waveamd.fragment_unpack %2193 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2195 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %arg129, %2086, %arg127, %2121 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2196 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %arg129, %2087, %arg127, %2195 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2197 = waveamd.fragment_unpack %2196 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2198 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2096, %arg130, %2086, %arg127, %2122 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2199 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2097, %arg130, %2087, %arg127, %2198 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2200 = waveamd.fragment_unpack %2199 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2201 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2098, %arg130, %2086, %arg127, %2123 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2202 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2099, %arg130, %2087, %arg127, %2201 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2203 = waveamd.fragment_unpack %2202 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2204 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %arg129, %2088, %arg128, %2124 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2205 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %arg129, %2089, %arg128, %2204 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2206 = waveamd.fragment_unpack %2205 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2207 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %arg129, %2088, %arg128, %2125 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2208 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %arg129, %2089, %arg128, %2207 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2209 = waveamd.fragment_unpack %2208 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2210 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2096, %arg130, %2088, %arg128, %2126 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2211 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2097, %arg130, %2089, %arg128, %2210 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2212 = waveamd.fragment_unpack %2211 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2213 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2098, %arg130, %2088, %arg128, %2127 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2214 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2099, %arg130, %2089, %arg128, %2213 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2215 = waveamd.fragment_unpack %2214 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2216 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2092, %arg129, %2090, %arg128, %2128 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2217 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2093, %arg129, %2091, %arg128, %2216 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2218 = waveamd.fragment_unpack %2217 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2219 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2094, %arg129, %2090, %arg128, %2129 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2220 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2095, %arg129, %2091, %arg128, %2219 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2221 = waveamd.fragment_unpack %2220 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2222 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2096, %arg130, %2090, %arg128, %2130 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2223 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2097, %arg130, %2091, %arg128, %2222 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2224 = waveamd.fragment_unpack %2223 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2225 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2098, %arg130, %2090, %arg128, %2131 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2226 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2099, %arg130, %2091, %arg128, %2225 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2227 = waveamd.fragment_unpack %2226 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg131 : !wave.mem.token
        %2228 = wave.barrier %arg131 : (!wave.mem.token) -> !wave.mem.token
        %2229 = wave.ptr_add %166, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_270, %token_271 = wave.load %2229 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2230 = wave.ptr_add %166, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_272, %token_273 = wave.load %2230 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2231 = wave.ptr_add %166, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_274, %token_275 = wave.load %2231 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2232 = wave.ptr_add %166, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_276, %token_277 = wave.load %2232 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2233 = wave.ptr_add %166, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_278, %token_279 = wave.load %2233 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2234 = wave.ptr_add %166, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_280, %token_281 = wave.load %2234 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2235 = wave.ptr_add %166, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_282, %token_283 = wave.load %2235 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2236 = wave.ptr_add %166, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_284, %token_285 = wave.load %2236 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2237 = wave.binary muli %409, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2238 = wave.binary muli %411, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2239 = wave.binary xori %2237, %2238 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2240 = wave.binary muli %415, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2241 = wave.binary xori %2239, %2240 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2242 = wave.binary muli %392, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2243 = wave.binary xori %2241, %2242 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2244 = wave.binary muli %394, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2245 = wave.binary xori %2243, %2244 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2246 = wave.binary muli %402, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2247 = wave.binary xori %398, %2246 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2248 = wave.binary muli %406, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2249 = wave.binary xori %2247, %2248 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2250 = wave.binary muli %2249, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2251 = wave.binary addi %2250, %2245 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2252 = wave.pack %arg81, %arg82, %arg83, %arg84 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2253 = wave.ptr_add %479, %2251 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2254 = wave.store %2252 -> %2253 after %token_115 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2255 = wave.barrier %2254 : (!wave.mem.token) -> !wave.mem.token
        %value_286, %token_287 = waveamd.transpose_load %520 after %2255 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2256 = wave.extract %value_286[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2257 = wave.extract %value_286[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2258 = wave.extract %value_286[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2259 = wave.extract %value_286[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2260 = wave.pack %2256, %2257, %2258, %2259 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2261 = wave.extract %value_286[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2262 = wave.extract %value_286[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2263 = wave.extract %value_286[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2264 = wave.extract %value_286[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2265 = wave.pack %2261, %2262, %2263, %2264 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2266 = wave.ptr_add %arg0, %arg13 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2267 = waveamd.make_buffer %2266, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2268 = wave.ptr_add %2267, %55 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2269 = waveamd.dma_load_lds %2268 -> %57 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2270 = wave.ptr_add %2267, %60 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2271 = waveamd.dma_load_lds %2270 -> %63 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2272 = wave.ptr_add %2267, %66 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2273 = waveamd.dma_load_lds %2272 -> %69 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2274 = wave.ptr_add %2267, %72 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2275 = waveamd.dma_load_lds %2274 -> %75 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2276 = wave.ptr_add %2267, %78 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2277 = waveamd.dma_load_lds %2276 -> %81 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2278 = wave.ptr_add %2267, %84 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2279 = waveamd.dma_load_lds %2278 -> %87 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2280 = wave.ptr_add %2267, %90 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2281 = waveamd.dma_load_lds %2280 -> %93 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2282 = wave.ptr_add %2267, %96 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2283 = waveamd.dma_load_lds %2282 -> %99 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2284 = wave.join %2269, %2271, %2273, %2275, %2277, %2279, %2281, %2283 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2285 = wave.ptr_add %arg1, %arg14 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2286 = waveamd.make_buffer %2285, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2287 = wave.ptr_add %2286, %107 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2288 = waveamd.dma_load_lds %2287 -> %109 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2289 = wave.ptr_add %2286, %112 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2290 = waveamd.dma_load_lds %2289 -> %114 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2291 = wave.ptr_add %2286, %117 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2292 = waveamd.dma_load_lds %2291 -> %119 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2293 = wave.ptr_add %2286, %122 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2294 = waveamd.dma_load_lds %2293 -> %124 after %arg131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2295 = wave.join %2288, %2290, %2292, %2294 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2296 = wave.ptr_add %arg3, %arg15 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2297 = waveamd.make_buffer %2296, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2298 = wave.ptr_add %2297, %136 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_288, %token_289 = wave.load %2298 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2299 = wave.ptr_add %2297, %138 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_290, %token_291 = wave.load %2299 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2300 = wave.ptr_add %2297, %140 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_292, %token_293 = wave.load %2300 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2301 = wave.ptr_add %2297, %142 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_294, %token_295 = wave.load %2301 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2302 = wave.ptr_add %2297, %144 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_296, %token_297 = wave.load %2302 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2303 = wave.ptr_add %2297, %146 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_298, %token_299 = wave.load %2303 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2304 = wave.ptr_add %2297, %148 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_300, %token_301 = wave.load %2304 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2305 = wave.ptr_add %2297, %150 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_302, %token_303 = wave.load %2305 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2306 = wave.ptr_add %arg4, %arg16 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2307 = waveamd.make_buffer %2306, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2308 = wave.ptr_add %2307, %157 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_304, %token_305 = wave.load %2308 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2309 = wave.ptr_add %2307, %159 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_306, %token_307 = wave.load %2309 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2310 = wave.ptr_add %2307, %161 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_308, %token_309 = wave.load %2310 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2311 = wave.ptr_add %2307, %163 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_310, %token_311 = wave.load %2311 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2312 = wave.join %2284, %2295 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2313 = waveamd.fragment_pack %value_270 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2314 = waveamd.fragment_pack %value_272 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2315 = waveamd.fragment_pack %value_274 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2316 = waveamd.fragment_pack %value_276 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2317 = waveamd.fragment_pack %value_278 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2318 = waveamd.fragment_pack %value_280 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2319 = waveamd.fragment_pack %value_282 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2320 = waveamd.fragment_pack %value_284 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2321 = waveamd.fragment_pack %arg49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2322 = waveamd.fragment_pack %arg50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2323 = waveamd.fragment_pack %arg51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2324 = waveamd.fragment_pack %arg52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2325 = waveamd.fragment_pack %arg53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2326 = waveamd.fragment_pack %arg54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2327 = waveamd.fragment_pack %arg55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2328 = waveamd.fragment_pack %arg56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2329 = waveamd.fragment_pack %arg57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2330 = waveamd.fragment_pack %arg58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2331 = waveamd.fragment_pack %arg59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2332 = waveamd.fragment_pack %arg60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2333 = waveamd.fragment_pack %arg61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2334 = waveamd.fragment_pack %arg62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2335 = waveamd.fragment_pack %arg63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2336 = waveamd.fragment_pack %arg64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2337 = waveamd.fragment_pack %arg65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2338 = waveamd.fragment_pack %arg66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2339 = waveamd.fragment_pack %arg67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2340 = waveamd.fragment_pack %arg68 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2341 = waveamd.fragment_pack %arg69 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2342 = waveamd.fragment_pack %arg70 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2343 = waveamd.fragment_pack %arg71 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2344 = waveamd.fragment_pack %arg72 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2345 = waveamd.fragment_pack %arg73 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2346 = waveamd.fragment_pack %arg74 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2347 = waveamd.fragment_pack %arg75 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2348 = waveamd.fragment_pack %arg76 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2349 = waveamd.fragment_pack %arg77 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2350 = waveamd.fragment_pack %arg78 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2351 = waveamd.fragment_pack %arg79 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2352 = waveamd.fragment_pack %arg80 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2353 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2313, %2260, %2076, %arg125, %2321 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2354 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2314, %2260, %2077, %arg125, %2353 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2355 = waveamd.fragment_unpack %2354 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2356 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2315, %2260, %2076, %arg125, %2322 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2357 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2316, %2260, %2077, %arg125, %2356 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2358 = waveamd.fragment_unpack %2357 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2359 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2317, %2265, %2076, %arg125, %2323 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2360 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2318, %2265, %2077, %arg125, %2359 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2361 = waveamd.fragment_unpack %2360 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2362 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2319, %2265, %2076, %arg125, %2324 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2363 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2320, %2265, %2077, %arg125, %2362 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2364 = waveamd.fragment_unpack %2363 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2365 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2313, %2260, %2078, %arg125, %2325 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2366 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2314, %2260, %2079, %arg125, %2365 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2367 = waveamd.fragment_unpack %2366 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2368 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2315, %2260, %2078, %arg125, %2326 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2369 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2316, %2260, %2079, %arg125, %2368 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2370 = waveamd.fragment_unpack %2369 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2371 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2317, %2265, %2078, %arg125, %2327 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2372 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2318, %2265, %2079, %arg125, %2371 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2373 = waveamd.fragment_unpack %2372 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2374 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2319, %2265, %2078, %arg125, %2328 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2375 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2320, %2265, %2079, %arg125, %2374 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2376 = waveamd.fragment_unpack %2375 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2377 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2313, %2260, %2080, %arg126, %2329 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2378 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2314, %2260, %2081, %arg126, %2377 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2379 = waveamd.fragment_unpack %2378 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2380 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2315, %2260, %2080, %arg126, %2330 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2381 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2316, %2260, %2081, %arg126, %2380 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2382 = waveamd.fragment_unpack %2381 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2383 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2317, %2265, %2080, %arg126, %2331 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2384 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2318, %2265, %2081, %arg126, %2383 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2385 = waveamd.fragment_unpack %2384 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2386 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2319, %2265, %2080, %arg126, %2332 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2387 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2320, %2265, %2081, %arg126, %2386 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2388 = waveamd.fragment_unpack %2387 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2389 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2313, %2260, %2082, %arg126, %2333 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2390 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2314, %2260, %2083, %arg126, %2389 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2391 = waveamd.fragment_unpack %2390 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2392 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2315, %2260, %2082, %arg126, %2334 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2393 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2316, %2260, %2083, %arg126, %2392 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2394 = waveamd.fragment_unpack %2393 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2395 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2317, %2265, %2082, %arg126, %2335 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2396 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2318, %2265, %2083, %arg126, %2395 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2397 = waveamd.fragment_unpack %2396 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2398 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2319, %2265, %2082, %arg126, %2336 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2399 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2320, %2265, %2083, %arg126, %2398 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2400 = waveamd.fragment_unpack %2399 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2401 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2313, %2260, %2084, %arg127, %2337 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2402 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2314, %2260, %2085, %arg127, %2401 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2403 = waveamd.fragment_unpack %2402 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2404 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2315, %2260, %2084, %arg127, %2338 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2405 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2316, %2260, %2085, %arg127, %2404 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2406 = waveamd.fragment_unpack %2405 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2407 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2317, %2265, %2084, %arg127, %2339 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2408 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2318, %2265, %2085, %arg127, %2407 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2409 = waveamd.fragment_unpack %2408 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2410 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2319, %2265, %2084, %arg127, %2340 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2411 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2320, %2265, %2085, %arg127, %2410 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2412 = waveamd.fragment_unpack %2411 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2413 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2313, %2260, %2086, %arg127, %2341 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2414 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2314, %2260, %2087, %arg127, %2413 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2415 = waveamd.fragment_unpack %2414 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2416 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2315, %2260, %2086, %arg127, %2342 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2417 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2316, %2260, %2087, %arg127, %2416 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2418 = waveamd.fragment_unpack %2417 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2419 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2317, %2265, %2086, %arg127, %2343 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2420 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2318, %2265, %2087, %arg127, %2419 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2421 = waveamd.fragment_unpack %2420 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2422 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2319, %2265, %2086, %arg127, %2344 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2423 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2320, %2265, %2087, %arg127, %2422 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2424 = waveamd.fragment_unpack %2423 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2425 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2313, %2260, %2088, %arg128, %2345 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2426 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2314, %2260, %2089, %arg128, %2425 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2427 = waveamd.fragment_unpack %2426 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2428 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2315, %2260, %2088, %arg128, %2346 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2429 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2316, %2260, %2089, %arg128, %2428 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2430 = waveamd.fragment_unpack %2429 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2431 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2317, %2265, %2088, %arg128, %2347 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2432 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2318, %2265, %2089, %arg128, %2431 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2433 = waveamd.fragment_unpack %2432 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2434 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2319, %2265, %2088, %arg128, %2348 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2435 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2320, %2265, %2089, %arg128, %2434 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2436 = waveamd.fragment_unpack %2435 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2437 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2313, %2260, %2090, %arg128, %2349 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2438 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2314, %2260, %2091, %arg128, %2437 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2439 = waveamd.fragment_unpack %2438 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2440 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2315, %2260, %2090, %arg128, %2350 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2441 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2316, %2260, %2091, %arg128, %2440 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2442 = waveamd.fragment_unpack %2441 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2443 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2317, %2265, %2090, %arg128, %2351 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2444 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2318, %2265, %2091, %arg128, %2443 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2445 = waveamd.fragment_unpack %2444 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2446 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2319, %2265, %2090, %arg128, %2352 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2447 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2320, %2265, %2091, %arg128, %2446 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2448 = waveamd.fragment_unpack %2447 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg132 : !wave.mem.token
        %2449 = wave.barrier %arg132 : (!wave.mem.token) -> !wave.mem.token
        %2450 = wave.ptr_add %201, %342 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_312, %token_313 = wave.load %2450 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2451 = wave.ptr_add %201, %344 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_314, %token_315 = wave.load %2451 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2452 = wave.ptr_add %201, %346 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_316, %token_317 = wave.load %2452 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2453 = wave.ptr_add %201, %348 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_318, %token_319 = wave.load %2453 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2454 = wave.ptr_add %201, %350 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_320, %token_321 = wave.load %2454 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2455 = wave.ptr_add %201, %352 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_322, %token_323 = wave.load %2455 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2456 = wave.ptr_add %201, %354 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_324, %token_325 = wave.load %2456 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2457 = wave.ptr_add %201, %356 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_326, %token_327 = wave.load %2457 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2458 = wave.ptr_add %201, %358 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_328, %token_329 = wave.load %2458 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2459 = wave.ptr_add %201, %360 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_330, %token_331 = wave.load %2459 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2460 = wave.ptr_add %201, %362 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_332, %token_333 = wave.load %2460 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2461 = wave.ptr_add %201, %364 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_334, %token_335 = wave.load %2461 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2462 = wave.ptr_add %201, %366 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_336, %token_337 = wave.load %2462 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2463 = wave.ptr_add %201, %368 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_338, %token_339 = wave.load %2463 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2464 = wave.ptr_add %201, %370 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_340, %token_341 = wave.load %2464 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2465 = wave.ptr_add %201, %372 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_342, %token_343 = wave.load %2465 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2466 = wave.ptr_add %244, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_344, %token_345 = wave.load %2466 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2467 = wave.ptr_add %244, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_346, %token_347 = wave.load %2467 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2468 = wave.ptr_add %244, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_348, %token_349 = wave.load %2468 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2469 = wave.ptr_add %244, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_350, %token_351 = wave.load %2469 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2470 = wave.ptr_add %244, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_352, %token_353 = wave.load %2470 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2471 = wave.ptr_add %244, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_354, %token_355 = wave.load %2471 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2472 = wave.ptr_add %244, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_356, %token_357 = wave.load %2472 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2473 = wave.ptr_add %244, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_358, %token_359 = wave.load %2473 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2474 = wave.binary muli %409, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2475 = wave.binary muli %411, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2476 = wave.binary xori %2474, %2475 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2477 = wave.binary muli %415, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2478 = wave.binary xori %2476, %2477 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2479 = wave.binary muli %392, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2480 = wave.binary xori %2478, %2479 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2481 = wave.binary muli %394, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2482 = wave.binary xori %2480, %2481 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2483 = wave.binary muli %2249, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2484 = wave.binary addi %2483, %2482 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2485 = wave.pack %arg85, %arg86, %arg87, %arg88, %arg89, %arg90, %arg91, %arg92 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2486 = wave.ptr_add %390, %2484 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2487 = wave.store %2485 -> %2486 after %token_287 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2488 = wave.barrier %2487 : (!wave.mem.token) -> !wave.mem.token
        %2489 = wave.pack %arg93, %arg94, %arg95, %arg96 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2490 = wave.store %2489 -> %2253 after %2488 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2491 = wave.barrier %2490 : (!wave.mem.token) -> !wave.mem.token
        %value_360, %token_361 = waveamd.transpose_load %495 after %2491 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2492 = wave.extract %value_360[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2493 = wave.extract %value_360[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2494 = wave.extract %value_360[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2495 = wave.extract %value_360[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2496 = wave.pack %2492, %2493, %2494, %2495 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2497 = wave.extract %value_360[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2498 = wave.extract %value_360[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2499 = wave.extract %value_360[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2500 = wave.extract %value_360[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2501 = wave.pack %2497, %2498, %2499, %2500 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %value_362, %token_363 = waveamd.transpose_load %507 after %2491 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2502 = wave.extract %value_362[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2503 = wave.extract %value_362[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2504 = wave.extract %value_362[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2505 = wave.extract %value_362[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2506 = wave.pack %2502, %2503, %2504, %2505 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2507 = wave.extract %value_362[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2508 = wave.extract %value_362[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2509 = wave.extract %value_362[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2510 = wave.extract %value_362[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2511 = wave.pack %2507, %2508, %2509, %2510 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2512 = wave.join %token_361, %token_363 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_364, %token_365 = waveamd.transpose_load %520 after %2512 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2513 = wave.extract %value_364[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2514 = wave.extract %value_364[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2515 = wave.extract %value_364[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2516 = wave.extract %value_364[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2517 = wave.pack %2513, %2514, %2515, %2516 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2518 = wave.extract %value_364[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2519 = wave.extract %value_364[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2520 = wave.extract %value_364[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2521 = wave.extract %value_364[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2522 = wave.pack %2518, %2519, %2520, %2521 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2523 = wave.ptr_add %2286, %169 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2524 = waveamd.dma_load_lds %2523 -> %171 after %arg132 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2525 = wave.ptr_add %2286, %174 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2526 = waveamd.dma_load_lds %2525 -> %176 after %arg132 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2527 = wave.ptr_add %2286, %179 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2528 = waveamd.dma_load_lds %2527 -> %181 after %arg132 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2529 = wave.ptr_add %2286, %184 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2530 = waveamd.dma_load_lds %2529 -> %186 after %arg132 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2531 = wave.join %2524, %2526, %2528, %2530 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2532 = wave.ptr_add %2307, %193 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_366, %token_367 = wave.load %2532 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2533 = wave.ptr_add %2307, %195 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_368, %token_369 = wave.load %2533 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2534 = wave.ptr_add %2307, %197 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_370, %token_371 = wave.load %2534 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2535 = wave.ptr_add %2307, %199 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_372, %token_373 = wave.load %2535 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2536 = waveamd.fragment_pack %value_312 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2537 = waveamd.fragment_pack %value_314 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2538 = waveamd.fragment_pack %value_316 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2539 = waveamd.fragment_pack %value_318 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2540 = waveamd.fragment_pack %value_320 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2541 = waveamd.fragment_pack %value_322 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2542 = waveamd.fragment_pack %value_324 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2543 = waveamd.fragment_pack %value_326 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2544 = waveamd.fragment_pack %value_328 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2545 = waveamd.fragment_pack %value_330 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2546 = waveamd.fragment_pack %value_332 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2547 = waveamd.fragment_pack %value_334 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2548 = waveamd.fragment_pack %value_336 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2549 = waveamd.fragment_pack %value_338 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2550 = waveamd.fragment_pack %value_340 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2551 = waveamd.fragment_pack %value_342 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2552 = waveamd.fragment_pack %value_344 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2553 = waveamd.fragment_pack %value_346 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2554 = waveamd.fragment_pack %value_348 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2555 = waveamd.fragment_pack %value_350 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2556 = waveamd.fragment_pack %value_352 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2557 = waveamd.fragment_pack %value_354 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2558 = waveamd.fragment_pack %value_356 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2559 = waveamd.fragment_pack %value_358 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2560 = waveamd.fragment_pack %2134 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2561 = waveamd.fragment_pack %2137 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2562 = waveamd.fragment_pack %2140 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2563 = waveamd.fragment_pack %2143 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2564 = waveamd.fragment_pack %2146 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2565 = waveamd.fragment_pack %2149 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2566 = waveamd.fragment_pack %2152 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2567 = waveamd.fragment_pack %2155 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2568 = waveamd.fragment_pack %2158 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2569 = waveamd.fragment_pack %2161 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2570 = waveamd.fragment_pack %2164 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2571 = waveamd.fragment_pack %2167 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2572 = waveamd.fragment_pack %2170 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2573 = waveamd.fragment_pack %2173 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2574 = waveamd.fragment_pack %2176 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2575 = waveamd.fragment_pack %2179 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2576 = waveamd.fragment_pack %2182 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2577 = waveamd.fragment_pack %2185 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2578 = waveamd.fragment_pack %2188 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2579 = waveamd.fragment_pack %2191 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2580 = waveamd.fragment_pack %2194 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2581 = waveamd.fragment_pack %2197 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2582 = waveamd.fragment_pack %2200 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2583 = waveamd.fragment_pack %2203 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2584 = waveamd.fragment_pack %2206 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2585 = waveamd.fragment_pack %2209 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2586 = waveamd.fragment_pack %2212 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2587 = waveamd.fragment_pack %2215 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2588 = waveamd.fragment_pack %2218 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2589 = waveamd.fragment_pack %2221 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2590 = waveamd.fragment_pack %2224 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2591 = waveamd.fragment_pack %2227 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2552, %2517, %2536, %2496, %2560 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2553, %2517, %2537, %2496, %2592 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2594 = waveamd.fragment_unpack %2593 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2554, %2517, %2536, %2496, %2561 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2555, %2517, %2537, %2496, %2595 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2597 = waveamd.fragment_unpack %2596 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2556, %2522, %2536, %2496, %2562 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2557, %2522, %2537, %2496, %2598 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2600 = waveamd.fragment_unpack %2599 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2558, %2522, %2536, %2496, %2563 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2602 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2559, %2522, %2537, %2496, %2601 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2603 = waveamd.fragment_unpack %2602 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2552, %2517, %2538, %2496, %2564 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2553, %2517, %2539, %2496, %2604 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2606 = waveamd.fragment_unpack %2605 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2607 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2554, %2517, %2538, %2496, %2565 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2608 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2555, %2517, %2539, %2496, %2607 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2609 = waveamd.fragment_unpack %2608 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2610 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2556, %2522, %2538, %2496, %2566 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2611 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2557, %2522, %2539, %2496, %2610 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2612 = waveamd.fragment_unpack %2611 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2613 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2558, %2522, %2538, %2496, %2567 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2614 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2559, %2522, %2539, %2496, %2613 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2615 = waveamd.fragment_unpack %2614 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2616 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2552, %2517, %2540, %2501, %2568 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2617 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2553, %2517, %2541, %2501, %2616 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2618 = waveamd.fragment_unpack %2617 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2619 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2554, %2517, %2540, %2501, %2569 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2620 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2555, %2517, %2541, %2501, %2619 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2621 = waveamd.fragment_unpack %2620 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2622 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2556, %2522, %2540, %2501, %2570 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2623 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2557, %2522, %2541, %2501, %2622 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2624 = waveamd.fragment_unpack %2623 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2625 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2558, %2522, %2540, %2501, %2571 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2626 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2559, %2522, %2541, %2501, %2625 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2627 = waveamd.fragment_unpack %2626 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2628 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2552, %2517, %2542, %2501, %2572 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2629 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2553, %2517, %2543, %2501, %2628 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2630 = waveamd.fragment_unpack %2629 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2631 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2554, %2517, %2542, %2501, %2573 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2632 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2555, %2517, %2543, %2501, %2631 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2633 = waveamd.fragment_unpack %2632 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2634 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2556, %2522, %2542, %2501, %2574 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2635 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2557, %2522, %2543, %2501, %2634 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2636 = waveamd.fragment_unpack %2635 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2637 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2558, %2522, %2542, %2501, %2575 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2638 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2559, %2522, %2543, %2501, %2637 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2639 = waveamd.fragment_unpack %2638 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2640 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2552, %2517, %2544, %2506, %2576 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2641 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2553, %2517, %2545, %2506, %2640 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2642 = waveamd.fragment_unpack %2641 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2643 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2554, %2517, %2544, %2506, %2577 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2644 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2555, %2517, %2545, %2506, %2643 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2645 = waveamd.fragment_unpack %2644 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2646 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2556, %2522, %2544, %2506, %2578 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2647 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2557, %2522, %2545, %2506, %2646 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2648 = waveamd.fragment_unpack %2647 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2649 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2558, %2522, %2544, %2506, %2579 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2650 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2559, %2522, %2545, %2506, %2649 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2651 = waveamd.fragment_unpack %2650 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2652 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2552, %2517, %2546, %2506, %2580 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2653 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2553, %2517, %2547, %2506, %2652 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2654 = waveamd.fragment_unpack %2653 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2655 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2554, %2517, %2546, %2506, %2581 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2656 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2555, %2517, %2547, %2506, %2655 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2657 = waveamd.fragment_unpack %2656 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2658 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2556, %2522, %2546, %2506, %2582 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2659 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2557, %2522, %2547, %2506, %2658 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2660 = waveamd.fragment_unpack %2659 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2661 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2558, %2522, %2546, %2506, %2583 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2662 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2559, %2522, %2547, %2506, %2661 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2663 = waveamd.fragment_unpack %2662 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2664 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2552, %2517, %2548, %2511, %2584 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2665 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2553, %2517, %2549, %2511, %2664 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2666 = waveamd.fragment_unpack %2665 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2667 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2554, %2517, %2548, %2511, %2585 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2668 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2555, %2517, %2549, %2511, %2667 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2669 = waveamd.fragment_unpack %2668 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2670 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2556, %2522, %2548, %2511, %2586 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2671 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2557, %2522, %2549, %2511, %2670 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2672 = waveamd.fragment_unpack %2671 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2673 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2558, %2522, %2548, %2511, %2587 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2674 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2559, %2522, %2549, %2511, %2673 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2675 = waveamd.fragment_unpack %2674 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2676 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2552, %2517, %2550, %2511, %2588 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2677 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2553, %2517, %2551, %2511, %2676 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2678 = waveamd.fragment_unpack %2677 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2679 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2554, %2517, %2550, %2511, %2589 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2680 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2555, %2517, %2551, %2511, %2679 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2681 = waveamd.fragment_unpack %2680 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2682 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2556, %2522, %2550, %2511, %2590 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2683 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2557, %2522, %2551, %2511, %2682 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2684 = waveamd.fragment_unpack %2683 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2685 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2558, %2522, %2550, %2511, %2591 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2686 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2559, %2522, %2551, %2511, %2685 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2687 = waveamd.fragment_unpack %2686 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %arg133 : !wave.mem.token
        %2688 = wave.barrier %arg133 : (!wave.mem.token) -> !wave.mem.token
        %2689 = wave.ptr_add %304, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_374, %token_375 = wave.load %2689 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2690 = wave.ptr_add %304, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_376, %token_377 = wave.load %2690 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2691 = wave.ptr_add %304, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_378, %token_379 = wave.load %2691 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2692 = wave.ptr_add %304, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_380, %token_381 = wave.load %2692 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2693 = wave.ptr_add %304, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_382, %token_383 = wave.load %2693 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2694 = wave.ptr_add %304, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_384, %token_385 = wave.load %2694 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2695 = wave.ptr_add %304, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_386, %token_387 = wave.load %2695 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2696 = wave.ptr_add %304, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_388, %token_389 = wave.load %2696 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2697 = wave.pack %arg97, %arg98, %arg99, %arg100 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2698 = wave.store %2697 -> %2253 after %token_365 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2699 = wave.barrier %2698 : (!wave.mem.token) -> !wave.mem.token
        %value_390, %token_391 = waveamd.transpose_load %520 after %2699 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2700 = wave.extract %value_390[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2701 = wave.extract %value_390[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2702 = wave.extract %value_390[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2703 = wave.extract %value_390[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2704 = wave.pack %2700, %2701, %2702, %2703 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2705 = wave.extract %value_390[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2706 = wave.extract %value_390[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2707 = wave.extract %value_390[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2708 = wave.extract %value_390[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2709 = wave.pack %2705, %2706, %2707, %2708 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2710 = wave.ptr_add %2267, %204 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2711 = waveamd.dma_load_lds %2710 -> %206 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2712 = wave.ptr_add %2267, %209 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2713 = waveamd.dma_load_lds %2712 -> %211 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2714 = wave.ptr_add %2267, %214 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2715 = waveamd.dma_load_lds %2714 -> %216 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2716 = wave.ptr_add %2267, %219 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2717 = waveamd.dma_load_lds %2716 -> %221 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2718 = wave.ptr_add %2267, %224 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2719 = waveamd.dma_load_lds %2718 -> %226 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2720 = wave.ptr_add %2267, %229 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2721 = waveamd.dma_load_lds %2720 -> %231 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2722 = wave.ptr_add %2267, %234 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2723 = waveamd.dma_load_lds %2722 -> %236 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2724 = wave.ptr_add %2267, %239 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2725 = waveamd.dma_load_lds %2724 -> %241 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2726 = wave.join %2711, %2713, %2715, %2717, %2719, %2721, %2723, %2725 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2727 = wave.ptr_add %2286, %247 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2728 = waveamd.dma_load_lds %2727 -> %249 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2729 = wave.ptr_add %2286, %252 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2730 = waveamd.dma_load_lds %2729 -> %254 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2731 = wave.ptr_add %2286, %257 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2732 = waveamd.dma_load_lds %2731 -> %259 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2733 = wave.ptr_add %2286, %262 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2734 = waveamd.dma_load_lds %2733 -> %264 after %arg133 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2735 = wave.join %2728, %2730, %2732, %2734 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2736 = wave.ptr_add %2297, %275 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_392, %token_393 = wave.load %2736 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2737 = wave.ptr_add %2297, %277 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_394, %token_395 = wave.load %2737 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2738 = wave.ptr_add %2297, %279 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_396, %token_397 = wave.load %2738 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2739 = wave.ptr_add %2297, %281 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_398, %token_399 = wave.load %2739 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2740 = wave.ptr_add %2297, %283 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_400, %token_401 = wave.load %2740 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2741 = wave.ptr_add %2297, %285 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_402, %token_403 = wave.load %2741 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2742 = wave.ptr_add %2297, %287 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_404, %token_405 = wave.load %2742 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2743 = wave.ptr_add %2297, %289 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_406, %token_407 = wave.load %2743 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2744 = wave.ptr_add %2307, %295 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_408, %token_409 = wave.load %2744 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2745 = wave.ptr_add %2307, %297 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_410, %token_411 = wave.load %2745 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2746 = wave.ptr_add %2307, %299 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_412, %token_413 = wave.load %2746 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2747 = wave.ptr_add %2307, %301 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_414, %token_415 = wave.load %2747 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2748 = wave.join %2726, %2735 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2749 = waveamd.fragment_pack %value_374 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2750 = waveamd.fragment_pack %value_376 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2751 = waveamd.fragment_pack %value_378 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2752 = waveamd.fragment_pack %value_380 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2753 = waveamd.fragment_pack %value_382 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2754 = waveamd.fragment_pack %value_384 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2755 = waveamd.fragment_pack %value_386 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2756 = waveamd.fragment_pack %value_388 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2757 = waveamd.fragment_pack %2355 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2758 = waveamd.fragment_pack %2358 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2759 = waveamd.fragment_pack %2361 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2760 = waveamd.fragment_pack %2364 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2761 = waveamd.fragment_pack %2367 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2762 = waveamd.fragment_pack %2370 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2763 = waveamd.fragment_pack %2373 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2764 = waveamd.fragment_pack %2376 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2765 = waveamd.fragment_pack %2379 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2766 = waveamd.fragment_pack %2382 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2767 = waveamd.fragment_pack %2385 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2768 = waveamd.fragment_pack %2388 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2769 = waveamd.fragment_pack %2391 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2770 = waveamd.fragment_pack %2394 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2771 = waveamd.fragment_pack %2397 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2772 = waveamd.fragment_pack %2400 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2773 = waveamd.fragment_pack %2403 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2774 = waveamd.fragment_pack %2406 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2775 = waveamd.fragment_pack %2409 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2776 = waveamd.fragment_pack %2412 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2777 = waveamd.fragment_pack %2415 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2778 = waveamd.fragment_pack %2418 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2779 = waveamd.fragment_pack %2421 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2780 = waveamd.fragment_pack %2424 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2781 = waveamd.fragment_pack %2427 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2782 = waveamd.fragment_pack %2430 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2783 = waveamd.fragment_pack %2433 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2784 = waveamd.fragment_pack %2436 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2785 = waveamd.fragment_pack %2439 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2786 = waveamd.fragment_pack %2442 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2787 = waveamd.fragment_pack %2445 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2788 = waveamd.fragment_pack %2448 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2789 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2749, %2704, %2536, %2496, %2757 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2790 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2750, %2704, %2537, %2496, %2789 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2791 = waveamd.fragment_unpack %2790 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2792 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2751, %2704, %2536, %2496, %2758 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2793 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2752, %2704, %2537, %2496, %2792 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2794 = waveamd.fragment_unpack %2793 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2795 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2753, %2709, %2536, %2496, %2759 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2796 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2754, %2709, %2537, %2496, %2795 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2797 = waveamd.fragment_unpack %2796 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2798 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2755, %2709, %2536, %2496, %2760 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2799 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2756, %2709, %2537, %2496, %2798 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2800 = waveamd.fragment_unpack %2799 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2801 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2749, %2704, %2538, %2496, %2761 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2802 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2750, %2704, %2539, %2496, %2801 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2803 = waveamd.fragment_unpack %2802 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2804 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2751, %2704, %2538, %2496, %2762 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2805 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2752, %2704, %2539, %2496, %2804 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2806 = waveamd.fragment_unpack %2805 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2807 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2753, %2709, %2538, %2496, %2763 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2808 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2754, %2709, %2539, %2496, %2807 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2809 = waveamd.fragment_unpack %2808 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2810 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2755, %2709, %2538, %2496, %2764 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2811 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2756, %2709, %2539, %2496, %2810 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2812 = waveamd.fragment_unpack %2811 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2813 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2749, %2704, %2540, %2501, %2765 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2814 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2750, %2704, %2541, %2501, %2813 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2815 = waveamd.fragment_unpack %2814 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2816 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2751, %2704, %2540, %2501, %2766 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2817 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2752, %2704, %2541, %2501, %2816 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2818 = waveamd.fragment_unpack %2817 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2819 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2753, %2709, %2540, %2501, %2767 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2820 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2754, %2709, %2541, %2501, %2819 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2821 = waveamd.fragment_unpack %2820 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2822 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2755, %2709, %2540, %2501, %2768 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2823 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2756, %2709, %2541, %2501, %2822 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2824 = waveamd.fragment_unpack %2823 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2825 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2749, %2704, %2542, %2501, %2769 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2826 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2750, %2704, %2543, %2501, %2825 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2827 = waveamd.fragment_unpack %2826 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2828 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2751, %2704, %2542, %2501, %2770 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2829 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2752, %2704, %2543, %2501, %2828 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2830 = waveamd.fragment_unpack %2829 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2831 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2753, %2709, %2542, %2501, %2771 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2832 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2754, %2709, %2543, %2501, %2831 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2833 = waveamd.fragment_unpack %2832 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2834 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2755, %2709, %2542, %2501, %2772 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2835 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2756, %2709, %2543, %2501, %2834 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2836 = waveamd.fragment_unpack %2835 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2837 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2749, %2704, %2544, %2506, %2773 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2838 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2750, %2704, %2545, %2506, %2837 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2839 = waveamd.fragment_unpack %2838 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2840 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2751, %2704, %2544, %2506, %2774 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2841 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2752, %2704, %2545, %2506, %2840 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2842 = waveamd.fragment_unpack %2841 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2843 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2753, %2709, %2544, %2506, %2775 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2844 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2754, %2709, %2545, %2506, %2843 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2845 = waveamd.fragment_unpack %2844 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2846 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2755, %2709, %2544, %2506, %2776 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2847 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2756, %2709, %2545, %2506, %2846 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2848 = waveamd.fragment_unpack %2847 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2849 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2749, %2704, %2546, %2506, %2777 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2850 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2750, %2704, %2547, %2506, %2849 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2851 = waveamd.fragment_unpack %2850 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2852 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2751, %2704, %2546, %2506, %2778 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2853 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2752, %2704, %2547, %2506, %2852 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2854 = waveamd.fragment_unpack %2853 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2855 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2753, %2709, %2546, %2506, %2779 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2856 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2754, %2709, %2547, %2506, %2855 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2857 = waveamd.fragment_unpack %2856 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2858 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2755, %2709, %2546, %2506, %2780 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2859 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2756, %2709, %2547, %2506, %2858 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2860 = waveamd.fragment_unpack %2859 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2861 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2749, %2704, %2548, %2511, %2781 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2862 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2750, %2704, %2549, %2511, %2861 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2863 = waveamd.fragment_unpack %2862 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2864 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2751, %2704, %2548, %2511, %2782 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2865 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2752, %2704, %2549, %2511, %2864 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2866 = waveamd.fragment_unpack %2865 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2867 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2753, %2709, %2548, %2511, %2783 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2868 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2754, %2709, %2549, %2511, %2867 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2869 = waveamd.fragment_unpack %2868 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2870 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2755, %2709, %2548, %2511, %2784 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2871 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2756, %2709, %2549, %2511, %2870 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2872 = waveamd.fragment_unpack %2871 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2873 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2749, %2704, %2550, %2511, %2785 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2874 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2750, %2704, %2551, %2511, %2873 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2875 = waveamd.fragment_unpack %2874 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2876 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2751, %2704, %2550, %2511, %2786 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2877 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2752, %2704, %2551, %2511, %2876 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2878 = waveamd.fragment_unpack %2877 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2879 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2753, %2709, %2550, %2511, %2787 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2880 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2754, %2709, %2551, %2511, %2879 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2881 = waveamd.fragment_unpack %2880 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2882 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2755, %2709, %2550, %2511, %2788 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2883 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2756, %2709, %2551, %2511, %2882 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2884 = waveamd.fragment_unpack %2883 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        wave.wait %2312 : !wave.mem.token
        %2885 = wave.barrier %2312 : (!wave.mem.token) -> !wave.mem.token
        %value_416, %token_417 = wave.load %343 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_418, %token_419 = wave.load %345 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_420, %token_421 = wave.load %347 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_422, %token_423 = wave.load %349 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_424, %token_425 = wave.load %351 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_426, %token_427 = wave.load %353 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_428, %token_429 = wave.load %355 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_430, %token_431 = wave.load %357 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_432, %token_433 = wave.load %359 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_434, %token_435 = wave.load %361 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_436, %token_437 = wave.load %363 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_438, %token_439 = wave.load %365 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_440, %token_441 = wave.load %367 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_442, %token_443 = wave.load %369 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_444, %token_445 = wave.load %371 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_446, %token_447 = wave.load %373 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_448, %token_449 = wave.load %375 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_450, %token_451 = wave.load %377 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_452, %token_453 = wave.load %379 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_454, %token_455 = wave.load %381 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_456, %token_457 = wave.load %383 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_458, %token_459 = wave.load %385 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_460, %token_461 = wave.load %387 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_462, %token_463 = wave.load %389 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2886 = wave.store %value_288 -> %462 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2887 = wave.store %value_290 -> %464 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2888 = wave.store %value_292 -> %466 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2889 = wave.store %value_294 -> %468 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2890 = wave.store %value_296 -> %470 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2891 = wave.store %value_298 -> %472 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2892 = wave.store %value_300 -> %474 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2893 = wave.store %value_302 -> %476 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2894 = wave.barrier %2886, %2887, %2888, %2889, %2890, %2891, %2892, %2893 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %2895 = wave.store %value_304 -> %485 after %2894 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2896 = wave.store %value_306 -> %487 after %2894 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2897 = wave.store %value_308 -> %489 after %2894 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2898 = wave.store %value_310 -> %491 after %2894 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2899 = wave.barrier %2895, %2896, %2897, %2898 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %value_464, %token_465 = waveamd.transpose_load %495 after %2899 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2900 = wave.extract %value_464[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2901 = wave.extract %value_464[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2902 = wave.extract %value_464[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2903 = wave.extract %value_464[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2904 = wave.pack %2900, %2901, %2902, %2903 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2905 = wave.extract %value_464[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2906 = wave.extract %value_464[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2907 = wave.extract %value_464[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2908 = wave.extract %value_464[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2909 = wave.pack %2905, %2906, %2907, %2908 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %value_466, %token_467 = waveamd.transpose_load %507 after %2899 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2910 = wave.extract %value_466[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2911 = wave.extract %value_466[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2912 = wave.extract %value_466[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2913 = wave.extract %value_466[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2914 = wave.pack %2910, %2911, %2912, %2913 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2915 = wave.extract %value_466[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2916 = wave.extract %value_466[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2917 = wave.extract %value_466[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2918 = wave.extract %value_466[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2919 = wave.pack %2915, %2916, %2917, %2918 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2920 = wave.join %token_465, %token_467 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_468, %token_469 = waveamd.transpose_load %520 after %2920 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2921 = wave.extract %value_468[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2922 = wave.extract %value_468[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2923 = wave.extract %value_468[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2924 = wave.extract %value_468[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2925 = wave.pack %2921, %2922, %2923, %2924 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2926 = wave.extract %value_468[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2927 = wave.extract %value_468[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2928 = wave.extract %value_468[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2929 = wave.extract %value_468[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %2930 = wave.pack %2926, %2927, %2928, %2929 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2931 = wave.ptr_add %2286, %307 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2932 = waveamd.dma_load_lds %2931 -> %309 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2933 = wave.ptr_add %2286, %312 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2934 = waveamd.dma_load_lds %2933 -> %314 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2935 = wave.ptr_add %2286, %317 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2936 = waveamd.dma_load_lds %2935 -> %319 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2937 = wave.ptr_add %2286, %322 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2938 = waveamd.dma_load_lds %2937 -> %324 after %53 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2939 = wave.join %2932, %2934, %2936, %2938 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2940 = wave.ptr_add %2307, %331 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_470, %token_471 = wave.load %2940 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2941 = wave.ptr_add %2307, %333 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_472, %token_473 = wave.load %2941 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2942 = wave.ptr_add %2307, %335 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_474, %token_475 = wave.load %2942 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2943 = wave.ptr_add %2307, %337 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_476, %token_477 = wave.load %2943 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2944 = wave.binary addi %arg13, %c256_i32 : i32, i32 -> i32
        %2945 = wave.binary addi %arg14, %c256_i32 : i32, i32 -> i32
        %2946 = wave.binary addi %arg15, %c16_i32 : i32, i32 -> i32
        %2947 = wave.binary addi %arg16, %c16_i32 : i32, i32 -> i32
        scf.yield %2944, %2945, %2946, %2947, %2594, %2597, %2600, %2603, %2606, %2609, %2612, %2615, %2618, %2621, %2624, %2627, %2630, %2633, %2636, %2639, %2642, %2645, %2648, %2651, %2654, %2657, %2660, %2663, %2666, %2669, %2672, %2675, %2678, %2681, %2684, %2687, %2791, %2794, %2797, %2800, %2803, %2806, %2809, %2812, %2815, %2818, %2821, %2824, %2827, %2830, %2833, %2836, %2839, %2842, %2845, %2848, %2851, %2854, %2857, %2860, %2863, %2866, %2869, %2872, %2875, %2878, %2881, %2884, %value_366, %value_368, %value_370, %value_372, %value_392, %value_394, %value_396, %value_398, %value_400, %value_402, %value_404, %value_406, %value_408, %value_410, %value_412, %value_414, %value_470, %value_472, %value_474, %value_476, %value_416, %value_418, %value_420, %value_422, %value_424, %value_426, %value_428, %value_430, %value_432, %value_434, %value_436, %value_438, %value_440, %value_442, %value_444, %value_446, %value_448, %value_450, %value_452, %value_454, %value_456, %value_458, %value_460, %value_462, %2904, %2909, %2914, %2919, %2925, %2930, %2531, %2748, %2939 : i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      %532 = waveamd.fragment_pack %531#88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %533 = waveamd.fragment_pack %531#89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %534 = waveamd.fragment_pack %531#90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %535 = waveamd.fragment_pack %531#91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %536 = waveamd.fragment_pack %531#92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %537 = waveamd.fragment_pack %531#93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %538 = waveamd.fragment_pack %531#94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %539 = waveamd.fragment_pack %531#95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %540 = waveamd.fragment_pack %531#96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %541 = waveamd.fragment_pack %531#97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %542 = waveamd.fragment_pack %531#98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %543 = waveamd.fragment_pack %531#99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %544 = waveamd.fragment_pack %531#100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %545 = waveamd.fragment_pack %531#101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %546 = waveamd.fragment_pack %531#102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %547 = waveamd.fragment_pack %531#103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %548 = waveamd.fragment_pack %531#104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %549 = waveamd.fragment_pack %531#105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %550 = waveamd.fragment_pack %531#106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %551 = waveamd.fragment_pack %531#107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %552 = waveamd.fragment_pack %531#108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %553 = waveamd.fragment_pack %531#109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %554 = waveamd.fragment_pack %531#110 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %555 = waveamd.fragment_pack %531#111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %556 = waveamd.fragment_pack %531#4 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %557 = waveamd.fragment_pack %531#5 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %558 = waveamd.fragment_pack %531#6 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %559 = waveamd.fragment_pack %531#7 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %560 = waveamd.fragment_pack %531#8 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %561 = waveamd.fragment_pack %531#9 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %562 = waveamd.fragment_pack %531#10 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %563 = waveamd.fragment_pack %531#11 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %564 = waveamd.fragment_pack %531#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %565 = waveamd.fragment_pack %531#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %566 = waveamd.fragment_pack %531#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %567 = waveamd.fragment_pack %531#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %568 = waveamd.fragment_pack %531#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %569 = waveamd.fragment_pack %531#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %570 = waveamd.fragment_pack %531#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %571 = waveamd.fragment_pack %531#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %572 = waveamd.fragment_pack %531#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %573 = waveamd.fragment_pack %531#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %574 = waveamd.fragment_pack %531#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %575 = waveamd.fragment_pack %531#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %576 = waveamd.fragment_pack %531#24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %577 = waveamd.fragment_pack %531#25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %578 = waveamd.fragment_pack %531#26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %579 = waveamd.fragment_pack %531#27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %580 = waveamd.fragment_pack %531#28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %581 = waveamd.fragment_pack %531#29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %582 = waveamd.fragment_pack %531#30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %583 = waveamd.fragment_pack %531#31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %584 = waveamd.fragment_pack %531#32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %585 = waveamd.fragment_pack %531#33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %586 = waveamd.fragment_pack %531#34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %587 = waveamd.fragment_pack %531#35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %588 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %531#116, %532, %531#112, %556 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %531#116, %533, %531#112, %588 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %590 = waveamd.fragment_unpack %589 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %591 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %531#116, %532, %531#112, %557 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %531#116, %533, %531#112, %591 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %593 = waveamd.fragment_unpack %592 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %594 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %531#117, %532, %531#112, %558 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %531#117, %533, %531#112, %594 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %596 = waveamd.fragment_unpack %595 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %597 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %531#117, %532, %531#112, %559 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %531#117, %533, %531#112, %597 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %599 = waveamd.fragment_unpack %598 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %600 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %531#116, %534, %531#112, %560 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %531#116, %535, %531#112, %600 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %602 = waveamd.fragment_unpack %601 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %603 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %531#116, %534, %531#112, %561 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %531#116, %535, %531#112, %603 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %605 = waveamd.fragment_unpack %604 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %606 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %531#117, %534, %531#112, %562 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %607 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %531#117, %535, %531#112, %606 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %608 = waveamd.fragment_unpack %607 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %609 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %531#117, %534, %531#112, %563 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %610 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %531#117, %535, %531#112, %609 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %611 = waveamd.fragment_unpack %610 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %612 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %531#116, %536, %531#113, %564 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %613 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %531#116, %537, %531#113, %612 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %614 = waveamd.fragment_unpack %613 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %615 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %531#116, %536, %531#113, %565 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %616 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %531#116, %537, %531#113, %615 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %617 = waveamd.fragment_unpack %616 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %618 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %531#117, %536, %531#113, %566 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %619 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %531#117, %537, %531#113, %618 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %620 = waveamd.fragment_unpack %619 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %621 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %531#117, %536, %531#113, %567 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %622 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %531#117, %537, %531#113, %621 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %623 = waveamd.fragment_unpack %622 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %624 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %531#116, %538, %531#113, %568 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %625 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %531#116, %539, %531#113, %624 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %626 = waveamd.fragment_unpack %625 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %627 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %531#116, %538, %531#113, %569 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %628 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %531#116, %539, %531#113, %627 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %629 = waveamd.fragment_unpack %628 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %630 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %531#117, %538, %531#113, %570 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %631 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %531#117, %539, %531#113, %630 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %632 = waveamd.fragment_unpack %631 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %633 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %531#117, %538, %531#113, %571 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %634 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %531#117, %539, %531#113, %633 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %635 = waveamd.fragment_unpack %634 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %636 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %531#116, %540, %531#114, %572 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %637 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %531#116, %541, %531#114, %636 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %638 = waveamd.fragment_unpack %637 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %639 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %531#116, %540, %531#114, %573 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %640 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %531#116, %541, %531#114, %639 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %641 = waveamd.fragment_unpack %640 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %642 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %531#117, %540, %531#114, %574 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %643 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %531#117, %541, %531#114, %642 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %644 = waveamd.fragment_unpack %643 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %645 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %531#117, %540, %531#114, %575 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %646 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %531#117, %541, %531#114, %645 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %647 = waveamd.fragment_unpack %646 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %648 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %531#116, %542, %531#114, %576 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %649 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %531#116, %543, %531#114, %648 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %650 = waveamd.fragment_unpack %649 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %651 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %531#116, %542, %531#114, %577 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %652 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %531#116, %543, %531#114, %651 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %653 = waveamd.fragment_unpack %652 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %654 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %531#117, %542, %531#114, %578 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %655 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %531#117, %543, %531#114, %654 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %656 = waveamd.fragment_unpack %655 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %657 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %531#117, %542, %531#114, %579 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %658 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %531#117, %543, %531#114, %657 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %659 = waveamd.fragment_unpack %658 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %660 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %531#116, %544, %531#115, %580 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %661 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %531#116, %545, %531#115, %660 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %662 = waveamd.fragment_unpack %661 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %663 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %531#116, %544, %531#115, %581 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %664 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %531#116, %545, %531#115, %663 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %665 = waveamd.fragment_unpack %664 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %666 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %531#117, %544, %531#115, %582 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %667 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %531#117, %545, %531#115, %666 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %668 = waveamd.fragment_unpack %667 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %669 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %531#117, %544, %531#115, %583 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %670 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %531#117, %545, %531#115, %669 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %671 = waveamd.fragment_unpack %670 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %672 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %548, %531#116, %546, %531#115, %584 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %673 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %549, %531#116, %547, %531#115, %672 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %674 = waveamd.fragment_unpack %673 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %675 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %550, %531#116, %546, %531#115, %585 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %676 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %551, %531#116, %547, %531#115, %675 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %677 = waveamd.fragment_unpack %676 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %678 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %552, %531#117, %546, %531#115, %586 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %679 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %553, %531#117, %547, %531#115, %678 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %680 = waveamd.fragment_unpack %679 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %681 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %554, %531#117, %546, %531#115, %587 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %682 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %555, %531#117, %547, %531#115, %681 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %683 = waveamd.fragment_unpack %682 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      wave.wait %531#118, %531#119, %531#120 : !wave.mem.token, !wave.mem.token, !wave.mem.token
      %684 = wave.barrier %531#118, %531#119, %531#120 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %685 = wave.ptr_add %166, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_116, %token_117 = wave.load %685 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %686 = wave.ptr_add %166, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_118, %token_119 = wave.load %686 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %687 = wave.ptr_add %166, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_120, %token_121 = wave.load %687 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %688 = wave.ptr_add %166, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_122, %token_123 = wave.load %688 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %689 = wave.ptr_add %166, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_124, %token_125 = wave.load %689 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %690 = wave.ptr_add %166, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_126, %token_127 = wave.load %690 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %691 = wave.ptr_add %166, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_128, %token_129 = wave.load %691 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %692 = wave.ptr_add %166, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_130, %token_131 = wave.load %692 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %693 = wave.binary muli %409, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %694 = wave.binary muli %411, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %695 = wave.binary xori %693, %694 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %696 = wave.binary muli %415, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %697 = wave.binary xori %695, %696 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %698 = wave.binary muli %392, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %699 = wave.binary xori %697, %698 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %700 = wave.binary muli %394, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %701 = wave.binary xori %699, %700 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %702 = wave.binary muli %402, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %703 = wave.binary xori %398, %702 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %704 = wave.binary muli %406, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %705 = wave.binary xori %703, %704 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %706 = wave.binary muli %705, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %707 = wave.binary addi %706, %701 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %708 = wave.pack %531#68, %531#69, %531#70, %531#71 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %709 = wave.ptr_add %479, %707 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %710 = wave.store %708 -> %709 after %token_115 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %711 = wave.barrier %710 : (!wave.mem.token) -> !wave.mem.token
      %value_132, %token_133 = waveamd.transpose_load %520 after %711 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %712 = wave.extract %value_132[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %713 = wave.extract %value_132[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %714 = wave.extract %value_132[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %715 = wave.extract %value_132[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %716 = wave.pack %712, %713, %714, %715 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %717 = wave.extract %value_132[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %718 = wave.extract %value_132[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %719 = wave.extract %value_132[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %720 = wave.extract %value_132[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %721 = wave.pack %717, %718, %719, %720 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %722 = waveamd.fragment_pack %value_116 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %723 = waveamd.fragment_pack %value_118 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %724 = waveamd.fragment_pack %value_120 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %725 = waveamd.fragment_pack %value_122 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %726 = waveamd.fragment_pack %value_124 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %727 = waveamd.fragment_pack %value_126 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %728 = waveamd.fragment_pack %value_128 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %729 = waveamd.fragment_pack %value_130 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %730 = waveamd.fragment_pack %531#36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %731 = waveamd.fragment_pack %531#37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %732 = waveamd.fragment_pack %531#38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %733 = waveamd.fragment_pack %531#39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %734 = waveamd.fragment_pack %531#40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %735 = waveamd.fragment_pack %531#41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %736 = waveamd.fragment_pack %531#42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %737 = waveamd.fragment_pack %531#43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %738 = waveamd.fragment_pack %531#44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %739 = waveamd.fragment_pack %531#45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %740 = waveamd.fragment_pack %531#46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %741 = waveamd.fragment_pack %531#47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %742 = waveamd.fragment_pack %531#48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %743 = waveamd.fragment_pack %531#49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %744 = waveamd.fragment_pack %531#50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %745 = waveamd.fragment_pack %531#51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %746 = waveamd.fragment_pack %531#52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %747 = waveamd.fragment_pack %531#53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %748 = waveamd.fragment_pack %531#54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %749 = waveamd.fragment_pack %531#55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %750 = waveamd.fragment_pack %531#56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %751 = waveamd.fragment_pack %531#57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %752 = waveamd.fragment_pack %531#58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %753 = waveamd.fragment_pack %531#59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %754 = waveamd.fragment_pack %531#60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %755 = waveamd.fragment_pack %531#61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %756 = waveamd.fragment_pack %531#62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %757 = waveamd.fragment_pack %531#63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %758 = waveamd.fragment_pack %531#64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %759 = waveamd.fragment_pack %531#65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %760 = waveamd.fragment_pack %531#66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %761 = waveamd.fragment_pack %531#67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %762 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %722, %716, %532, %531#112, %730 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %763 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %723, %716, %533, %531#112, %762 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %764 = waveamd.fragment_unpack %763 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %765 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %724, %716, %532, %531#112, %731 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %766 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %725, %716, %533, %531#112, %765 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %767 = waveamd.fragment_unpack %766 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %768 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %726, %721, %532, %531#112, %732 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %769 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %727, %721, %533, %531#112, %768 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %770 = waveamd.fragment_unpack %769 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %771 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %728, %721, %532, %531#112, %733 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %772 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %729, %721, %533, %531#112, %771 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %773 = waveamd.fragment_unpack %772 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %774 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %722, %716, %534, %531#112, %734 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %775 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %723, %716, %535, %531#112, %774 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %776 = waveamd.fragment_unpack %775 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %777 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %724, %716, %534, %531#112, %735 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %778 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %725, %716, %535, %531#112, %777 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %779 = waveamd.fragment_unpack %778 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %780 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %726, %721, %534, %531#112, %736 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %781 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %727, %721, %535, %531#112, %780 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %782 = waveamd.fragment_unpack %781 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %783 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %728, %721, %534, %531#112, %737 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %784 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %729, %721, %535, %531#112, %783 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %785 = waveamd.fragment_unpack %784 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %786 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %722, %716, %536, %531#113, %738 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %787 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %723, %716, %537, %531#113, %786 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %788 = waveamd.fragment_unpack %787 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %789 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %724, %716, %536, %531#113, %739 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %790 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %725, %716, %537, %531#113, %789 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %791 = waveamd.fragment_unpack %790 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %792 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %726, %721, %536, %531#113, %740 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %793 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %727, %721, %537, %531#113, %792 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %794 = waveamd.fragment_unpack %793 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %795 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %728, %721, %536, %531#113, %741 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %796 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %729, %721, %537, %531#113, %795 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %797 = waveamd.fragment_unpack %796 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %798 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %722, %716, %538, %531#113, %742 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %799 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %723, %716, %539, %531#113, %798 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %800 = waveamd.fragment_unpack %799 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %801 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %724, %716, %538, %531#113, %743 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %802 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %725, %716, %539, %531#113, %801 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %803 = waveamd.fragment_unpack %802 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %804 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %726, %721, %538, %531#113, %744 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %805 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %727, %721, %539, %531#113, %804 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %806 = waveamd.fragment_unpack %805 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %807 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %728, %721, %538, %531#113, %745 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %808 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %729, %721, %539, %531#113, %807 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %809 = waveamd.fragment_unpack %808 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %810 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %722, %716, %540, %531#114, %746 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %811 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %723, %716, %541, %531#114, %810 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %812 = waveamd.fragment_unpack %811 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %813 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %724, %716, %540, %531#114, %747 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %814 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %725, %716, %541, %531#114, %813 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %815 = waveamd.fragment_unpack %814 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %816 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %726, %721, %540, %531#114, %748 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %817 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %727, %721, %541, %531#114, %816 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %818 = waveamd.fragment_unpack %817 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %819 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %728, %721, %540, %531#114, %749 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %820 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %729, %721, %541, %531#114, %819 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %821 = waveamd.fragment_unpack %820 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %822 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %722, %716, %542, %531#114, %750 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %823 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %723, %716, %543, %531#114, %822 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %824 = waveamd.fragment_unpack %823 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %825 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %724, %716, %542, %531#114, %751 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %826 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %725, %716, %543, %531#114, %825 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %827 = waveamd.fragment_unpack %826 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %828 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %726, %721, %542, %531#114, %752 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %829 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %727, %721, %543, %531#114, %828 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %830 = waveamd.fragment_unpack %829 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %831 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %728, %721, %542, %531#114, %753 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %832 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %729, %721, %543, %531#114, %831 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %833 = waveamd.fragment_unpack %832 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %834 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %722, %716, %544, %531#115, %754 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %835 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %723, %716, %545, %531#115, %834 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %836 = waveamd.fragment_unpack %835 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %837 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %724, %716, %544, %531#115, %755 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %838 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %725, %716, %545, %531#115, %837 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %839 = waveamd.fragment_unpack %838 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %840 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %726, %721, %544, %531#115, %756 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %841 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %727, %721, %545, %531#115, %840 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %842 = waveamd.fragment_unpack %841 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %843 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %728, %721, %544, %531#115, %757 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %844 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %729, %721, %545, %531#115, %843 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %845 = waveamd.fragment_unpack %844 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %846 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %722, %716, %546, %531#115, %758 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %847 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %723, %716, %547, %531#115, %846 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %848 = waveamd.fragment_unpack %847 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %849 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %724, %716, %546, %531#115, %759 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %850 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %725, %716, %547, %531#115, %849 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %851 = waveamd.fragment_unpack %850 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %852 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %726, %721, %546, %531#115, %760 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %853 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %727, %721, %547, %531#115, %852 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %854 = waveamd.fragment_unpack %853 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %855 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %728, %721, %546, %531#115, %761 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %856 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %729, %721, %547, %531#115, %855 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %857 = waveamd.fragment_unpack %856 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %858 = wave.ptr_add %201, %342 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_134, %token_135 = wave.load %858 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %859 = wave.ptr_add %201, %344 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_136, %token_137 = wave.load %859 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %860 = wave.ptr_add %201, %346 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_138, %token_139 = wave.load %860 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %861 = wave.ptr_add %201, %348 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_140, %token_141 = wave.load %861 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %862 = wave.ptr_add %201, %350 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_142, %token_143 = wave.load %862 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %863 = wave.ptr_add %201, %352 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_144, %token_145 = wave.load %863 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %864 = wave.ptr_add %201, %354 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_146, %token_147 = wave.load %864 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %865 = wave.ptr_add %201, %356 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_148, %token_149 = wave.load %865 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %866 = wave.ptr_add %201, %358 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_150, %token_151 = wave.load %866 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %867 = wave.ptr_add %201, %360 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_152, %token_153 = wave.load %867 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %868 = wave.ptr_add %201, %362 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_154, %token_155 = wave.load %868 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %869 = wave.ptr_add %201, %364 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_156, %token_157 = wave.load %869 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %870 = wave.ptr_add %201, %366 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_158, %token_159 = wave.load %870 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %871 = wave.ptr_add %201, %368 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_160, %token_161 = wave.load %871 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %872 = wave.ptr_add %201, %370 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_162, %token_163 = wave.load %872 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %873 = wave.ptr_add %201, %372 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_164, %token_165 = wave.load %873 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %874 = wave.ptr_add %244, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_166, %token_167 = wave.load %874 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %875 = wave.ptr_add %244, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_168, %token_169 = wave.load %875 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %876 = wave.ptr_add %244, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_170, %token_171 = wave.load %876 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %877 = wave.ptr_add %244, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_172, %token_173 = wave.load %877 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %878 = wave.ptr_add %244, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_174, %token_175 = wave.load %878 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %879 = wave.ptr_add %244, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_176, %token_177 = wave.load %879 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %880 = wave.ptr_add %244, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_178, %token_179 = wave.load %880 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %881 = wave.ptr_add %244, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_180, %token_181 = wave.load %881 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %882 = wave.binary muli %409, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %883 = wave.binary muli %411, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %884 = wave.binary xori %882, %883 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %885 = wave.binary muli %415, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %886 = wave.binary xori %884, %885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %887 = wave.binary muli %392, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %888 = wave.binary xori %886, %887 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %889 = wave.binary muli %394, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %890 = wave.binary xori %888, %889 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %891 = wave.binary muli %705, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %892 = wave.binary addi %891, %890 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %893 = wave.pack %531#72, %531#73, %531#74, %531#75, %531#76, %531#77, %531#78, %531#79 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %894 = wave.ptr_add %390, %892 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %895 = wave.store %893 -> %894 after %token_133 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %896 = wave.barrier %895 : (!wave.mem.token) -> !wave.mem.token
      %897 = wave.pack %531#80, %531#81, %531#82, %531#83 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %898 = wave.store %897 -> %709 after %896 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %899 = wave.barrier %898 : (!wave.mem.token) -> !wave.mem.token
      %value_182, %token_183 = waveamd.transpose_load %495 after %899 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %900 = wave.extract %value_182[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %901 = wave.extract %value_182[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %902 = wave.extract %value_182[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %903 = wave.extract %value_182[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %904 = wave.pack %900, %901, %902, %903 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %905 = wave.extract %value_182[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %906 = wave.extract %value_182[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %907 = wave.extract %value_182[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %908 = wave.extract %value_182[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %909 = wave.pack %905, %906, %907, %908 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %value_184, %token_185 = waveamd.transpose_load %507 after %899 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %910 = wave.extract %value_184[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %911 = wave.extract %value_184[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %912 = wave.extract %value_184[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %913 = wave.extract %value_184[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %914 = wave.pack %910, %911, %912, %913 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %915 = wave.extract %value_184[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %916 = wave.extract %value_184[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %917 = wave.extract %value_184[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %918 = wave.extract %value_184[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %919 = wave.pack %915, %916, %917, %918 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %920 = wave.join %token_183, %token_185 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_186, %token_187 = waveamd.transpose_load %520 after %920 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %921 = wave.extract %value_186[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %922 = wave.extract %value_186[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %923 = wave.extract %value_186[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %924 = wave.extract %value_186[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %925 = wave.pack %921, %922, %923, %924 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %926 = wave.extract %value_186[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %927 = wave.extract %value_186[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %928 = wave.extract %value_186[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %929 = wave.extract %value_186[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %930 = wave.pack %926, %927, %928, %929 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %931 = waveamd.fragment_pack %value_134 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %932 = waveamd.fragment_pack %value_136 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %933 = waveamd.fragment_pack %value_138 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %934 = waveamd.fragment_pack %value_140 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %935 = waveamd.fragment_pack %value_142 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %936 = waveamd.fragment_pack %value_144 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %937 = waveamd.fragment_pack %value_146 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %938 = waveamd.fragment_pack %value_148 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %939 = waveamd.fragment_pack %value_150 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %940 = waveamd.fragment_pack %value_152 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %941 = waveamd.fragment_pack %value_154 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %942 = waveamd.fragment_pack %value_156 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %943 = waveamd.fragment_pack %value_158 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %944 = waveamd.fragment_pack %value_160 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %945 = waveamd.fragment_pack %value_162 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %946 = waveamd.fragment_pack %value_164 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %947 = waveamd.fragment_pack %value_166 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %948 = waveamd.fragment_pack %value_168 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %949 = waveamd.fragment_pack %value_170 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %950 = waveamd.fragment_pack %value_172 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %951 = waveamd.fragment_pack %value_174 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %952 = waveamd.fragment_pack %value_176 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %953 = waveamd.fragment_pack %value_178 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %954 = waveamd.fragment_pack %value_180 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %955 = waveamd.fragment_pack %590 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %956 = waveamd.fragment_pack %593 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %957 = waveamd.fragment_pack %596 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %958 = waveamd.fragment_pack %599 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %959 = waveamd.fragment_pack %602 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %960 = waveamd.fragment_pack %605 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %961 = waveamd.fragment_pack %608 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %962 = waveamd.fragment_pack %611 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %963 = waveamd.fragment_pack %614 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %964 = waveamd.fragment_pack %617 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %965 = waveamd.fragment_pack %620 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %966 = waveamd.fragment_pack %623 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %967 = waveamd.fragment_pack %626 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %968 = waveamd.fragment_pack %629 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %969 = waveamd.fragment_pack %632 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %970 = waveamd.fragment_pack %635 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %971 = waveamd.fragment_pack %638 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %972 = waveamd.fragment_pack %641 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %973 = waveamd.fragment_pack %644 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %974 = waveamd.fragment_pack %647 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %975 = waveamd.fragment_pack %650 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %976 = waveamd.fragment_pack %653 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %977 = waveamd.fragment_pack %656 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %978 = waveamd.fragment_pack %659 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %979 = waveamd.fragment_pack %662 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %980 = waveamd.fragment_pack %665 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %981 = waveamd.fragment_pack %668 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %982 = waveamd.fragment_pack %671 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %983 = waveamd.fragment_pack %674 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %984 = waveamd.fragment_pack %677 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %985 = waveamd.fragment_pack %680 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %986 = waveamd.fragment_pack %683 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %987 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %947, %925, %931, %904, %955 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %988 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %948, %925, %932, %904, %987 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %989 = waveamd.fragment_unpack %988 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %990 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %949, %925, %931, %904, %956 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %991 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %950, %925, %932, %904, %990 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %992 = waveamd.fragment_unpack %991 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %993 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %951, %930, %931, %904, %957 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %994 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %952, %930, %932, %904, %993 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %995 = waveamd.fragment_unpack %994 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %996 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %953, %930, %931, %904, %958 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %997 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %954, %930, %932, %904, %996 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %998 = waveamd.fragment_unpack %997 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %999 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %947, %925, %933, %904, %959 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1000 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %948, %925, %934, %904, %999 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1001 = waveamd.fragment_unpack %1000 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1002 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %949, %925, %933, %904, %960 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1003 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %950, %925, %934, %904, %1002 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1004 = waveamd.fragment_unpack %1003 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1005 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %951, %930, %933, %904, %961 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1006 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %952, %930, %934, %904, %1005 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1007 = waveamd.fragment_unpack %1006 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1008 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %953, %930, %933, %904, %962 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1009 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %954, %930, %934, %904, %1008 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1010 = waveamd.fragment_unpack %1009 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1011 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %947, %925, %935, %909, %963 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1012 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %948, %925, %936, %909, %1011 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1013 = waveamd.fragment_unpack %1012 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1014 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %949, %925, %935, %909, %964 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1015 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %950, %925, %936, %909, %1014 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1016 = waveamd.fragment_unpack %1015 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1017 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %951, %930, %935, %909, %965 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1018 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %952, %930, %936, %909, %1017 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1019 = waveamd.fragment_unpack %1018 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1020 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %953, %930, %935, %909, %966 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1021 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %954, %930, %936, %909, %1020 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1022 = waveamd.fragment_unpack %1021 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1023 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %947, %925, %937, %909, %967 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1024 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %948, %925, %938, %909, %1023 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1025 = waveamd.fragment_unpack %1024 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1026 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %949, %925, %937, %909, %968 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1027 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %950, %925, %938, %909, %1026 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1028 = waveamd.fragment_unpack %1027 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1029 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %951, %930, %937, %909, %969 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1030 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %952, %930, %938, %909, %1029 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1031 = waveamd.fragment_unpack %1030 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1032 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %953, %930, %937, %909, %970 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1033 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %954, %930, %938, %909, %1032 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1034 = waveamd.fragment_unpack %1033 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1035 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %947, %925, %939, %914, %971 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1036 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %948, %925, %940, %914, %1035 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1037 = waveamd.fragment_unpack %1036 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1038 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %949, %925, %939, %914, %972 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1039 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %950, %925, %940, %914, %1038 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1040 = waveamd.fragment_unpack %1039 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1041 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %951, %930, %939, %914, %973 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1042 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %952, %930, %940, %914, %1041 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1043 = waveamd.fragment_unpack %1042 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1044 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %953, %930, %939, %914, %974 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1045 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %954, %930, %940, %914, %1044 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1046 = waveamd.fragment_unpack %1045 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1047 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %947, %925, %941, %914, %975 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1048 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %948, %925, %942, %914, %1047 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1049 = waveamd.fragment_unpack %1048 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1050 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %949, %925, %941, %914, %976 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1051 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %950, %925, %942, %914, %1050 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1052 = waveamd.fragment_unpack %1051 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1053 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %951, %930, %941, %914, %977 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1054 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %952, %930, %942, %914, %1053 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1055 = waveamd.fragment_unpack %1054 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1056 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %953, %930, %941, %914, %978 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1057 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %954, %930, %942, %914, %1056 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1058 = waveamd.fragment_unpack %1057 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1059 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %947, %925, %943, %919, %979 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1060 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %948, %925, %944, %919, %1059 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1061 = waveamd.fragment_unpack %1060 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1062 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %949, %925, %943, %919, %980 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1063 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %950, %925, %944, %919, %1062 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1064 = waveamd.fragment_unpack %1063 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1065 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %951, %930, %943, %919, %981 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1066 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %952, %930, %944, %919, %1065 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1067 = waveamd.fragment_unpack %1066 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1068 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %953, %930, %943, %919, %982 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1069 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %954, %930, %944, %919, %1068 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1070 = waveamd.fragment_unpack %1069 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1071 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %947, %925, %945, %919, %983 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1072 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %948, %925, %946, %919, %1071 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1073 = waveamd.fragment_unpack %1072 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1074 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %949, %925, %945, %919, %984 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1075 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %950, %925, %946, %919, %1074 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1076 = waveamd.fragment_unpack %1075 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1077 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %951, %930, %945, %919, %985 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1078 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %952, %930, %946, %919, %1077 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1079 = waveamd.fragment_unpack %1078 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1080 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %953, %930, %945, %919, %986 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1081 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %954, %930, %946, %919, %1080 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1082 = waveamd.fragment_unpack %1081 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1083 = wave.ptr_add %304, %374 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_188, %token_189 = wave.load %1083 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1084 = wave.ptr_add %304, %376 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_190, %token_191 = wave.load %1084 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1085 = wave.ptr_add %304, %378 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_192, %token_193 = wave.load %1085 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1086 = wave.ptr_add %304, %380 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_194, %token_195 = wave.load %1086 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1087 = wave.ptr_add %304, %382 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_196, %token_197 = wave.load %1087 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1088 = wave.ptr_add %304, %384 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_198, %token_199 = wave.load %1088 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1089 = wave.ptr_add %304, %386 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_200, %token_201 = wave.load %1089 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1090 = wave.ptr_add %304, %388 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_202, %token_203 = wave.load %1090 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1091 = wave.pack %531#84, %531#85, %531#86, %531#87 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1092 = wave.store %1091 -> %709 after %token_187 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %1093 = wave.barrier %1092 : (!wave.mem.token) -> !wave.mem.token
      %value_204, %token_205 = waveamd.transpose_load %520 after %1093 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1094 = wave.extract %value_204[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1095 = wave.extract %value_204[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1096 = wave.extract %value_204[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1097 = wave.extract %value_204[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1098 = wave.pack %1094, %1095, %1096, %1097 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1099 = wave.extract %value_204[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1100 = wave.extract %value_204[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1101 = wave.extract %value_204[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1102 = wave.extract %value_204[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1103 = wave.pack %1099, %1100, %1101, %1102 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1104 = wave.binary muli %38, %arg9 : i32, i32 -> i32
      %1105 = wave.cast fpconvert %989 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1106 = wave.cast fpconvert %992 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1107 = wave.cast fpconvert %995 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1108 = wave.cast fpconvert %998 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1109 = wave.cast fpconvert %1001 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1110 = wave.cast fpconvert %1004 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1111 = wave.cast fpconvert %1007 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1112 = wave.cast fpconvert %1010 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1113 = wave.cast fpconvert %1013 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1114 = wave.cast fpconvert %1016 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1115 = wave.cast fpconvert %1019 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1116 = wave.cast fpconvert %1022 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1117 = wave.cast fpconvert %1025 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1118 = wave.cast fpconvert %1028 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1119 = wave.cast fpconvert %1031 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1120 = wave.cast fpconvert %1034 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1121 = wave.cast fpconvert %1037 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1122 = wave.cast fpconvert %1040 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1123 = wave.cast fpconvert %1043 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1124 = wave.cast fpconvert %1046 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1125 = wave.cast fpconvert %1049 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1126 = wave.cast fpconvert %1052 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1127 = wave.cast fpconvert %1055 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1128 = wave.cast fpconvert %1058 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1129 = wave.cast fpconvert %1061 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1130 = wave.cast fpconvert %1064 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1131 = wave.cast fpconvert %1067 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1132 = wave.cast fpconvert %1070 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1133 = wave.cast fpconvert %1073 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1134 = wave.cast fpconvert %1076 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1135 = wave.cast fpconvert %1079 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1136 = wave.cast fpconvert %1082 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1137 = wave.shared_memory_base {offset = 138048 : i64} : !wave.ptr<#wave.shared, bf16>
      %1138 = wave.binary muli %48, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1139 = wave.ptr_add %1137, %1138 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1140 = wave.extract %1105[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1141 = wave.extract %1105[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1142 = wave.extract %1105[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1143 = wave.extract %1105[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1144 = wave.extract %1109[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1145 = wave.extract %1109[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1146 = wave.extract %1109[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1147 = wave.extract %1109[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1148 = wave.pack %1140, %1141, %1142, %1143, %1144, %1145, %1146, %1147 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1149 = wave.store %1148 -> %1139 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1150 = wave.binary addi %1138, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1151 = wave.ptr_add %1137, %1150 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1152 = wave.extract %1106[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1153 = wave.extract %1106[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1154 = wave.extract %1106[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1155 = wave.extract %1106[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1156 = wave.extract %1110[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1157 = wave.extract %1110[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1158 = wave.extract %1110[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1159 = wave.extract %1110[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1160 = wave.pack %1152, %1153, %1154, %1155, %1156, %1157, %1158, %1159 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1161 = wave.store %1160 -> %1151 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1162 = wave.binary addi %1138, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1163 = wave.ptr_add %1137, %1162 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1164 = wave.extract %1107[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1165 = wave.extract %1107[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1166 = wave.extract %1107[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1167 = wave.extract %1107[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1168 = wave.extract %1111[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1169 = wave.extract %1111[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1170 = wave.extract %1111[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1171 = wave.extract %1111[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1172 = wave.pack %1164, %1165, %1166, %1167, %1168, %1169, %1170, %1171 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1173 = wave.store %1172 -> %1163 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1174 = wave.binary addi %1138, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1175 = wave.ptr_add %1137, %1174 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1176 = wave.extract %1108[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1177 = wave.extract %1108[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1178 = wave.extract %1108[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1179 = wave.extract %1108[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1180 = wave.extract %1112[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1181 = wave.extract %1112[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1182 = wave.extract %1112[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1183 = wave.extract %1112[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1184 = wave.pack %1176, %1177, %1178, %1179, %1180, %1181, %1182, %1183 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1185 = wave.store %1184 -> %1175 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1186 = wave.barrier %1149, %1161, %1173, %1185 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1187 = wave.index_expr <"8*(32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1188 = wave.ptr_add %1137, %1187 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_206, %token_207 = wave.load %1188 after %1186 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1189 = wave.extract %value_206[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1190 = wave.extract %value_206[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1191 = wave.extract %value_206[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1192 = wave.extract %value_206[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1193 = wave.extract %value_206[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1194 = wave.extract %value_206[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1195 = wave.extract %value_206[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1196 = wave.extract %value_206[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1197 = wave.index_expr <"8*(16 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1198 = wave.ptr_add %1137, %1197 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_208, %token_209 = wave.load %1198 after %1186 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1199 = wave.extract %value_208[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1200 = wave.extract %value_208[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1201 = wave.extract %value_208[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1202 = wave.extract %value_208[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1203 = wave.extract %value_208[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1204 = wave.extract %value_208[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1205 = wave.extract %value_208[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1206 = wave.extract %value_208[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1207 = wave.index_expr <"8*(128 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1208 = wave.ptr_add %1137, %1207 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_210, %token_211 = wave.load %1208 after %1186 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1209 = wave.extract %value_210[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1210 = wave.extract %value_210[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1211 = wave.extract %value_210[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1212 = wave.extract %value_210[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1213 = wave.extract %value_210[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1214 = wave.extract %value_210[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1215 = wave.extract %value_210[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1216 = wave.extract %value_210[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1217 = wave.index_expr <"8*(144 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%48) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1218 = wave.ptr_add %1137, %1217 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_212, %token_213 = wave.load %1218 after %1186 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1219 = wave.extract %value_212[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1220 = wave.extract %value_212[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1221 = wave.extract %value_212[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1222 = wave.extract %value_212[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1223 = wave.extract %value_212[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1224 = wave.extract %value_212[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1225 = wave.extract %value_212[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1226 = wave.extract %value_212[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1227 = wave.barrier %token_207, %token_209, %token_211, %token_213 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1228 = wave.extract %1113[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1229 = wave.extract %1113[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1230 = wave.extract %1113[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1231 = wave.extract %1113[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1232 = wave.extract %1117[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1233 = wave.extract %1117[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1234 = wave.extract %1117[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1235 = wave.extract %1117[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1236 = wave.pack %1228, %1229, %1230, %1231, %1232, %1233, %1234, %1235 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1237 = wave.store %1236 -> %1139 after %1227 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1238 = wave.extract %1114[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1239 = wave.extract %1114[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1240 = wave.extract %1114[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1241 = wave.extract %1114[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1242 = wave.extract %1118[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1243 = wave.extract %1118[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1244 = wave.extract %1118[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1245 = wave.extract %1118[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1246 = wave.pack %1238, %1239, %1240, %1241, %1242, %1243, %1244, %1245 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1247 = wave.store %1246 -> %1151 after %1227 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1248 = wave.extract %1115[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1249 = wave.extract %1115[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1250 = wave.extract %1115[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1251 = wave.extract %1115[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1252 = wave.extract %1119[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1253 = wave.extract %1119[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1254 = wave.extract %1119[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1255 = wave.extract %1119[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1256 = wave.pack %1248, %1249, %1250, %1251, %1252, %1253, %1254, %1255 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1257 = wave.store %1256 -> %1163 after %1227 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1258 = wave.extract %1116[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1259 = wave.extract %1116[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1260 = wave.extract %1116[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1261 = wave.extract %1116[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1262 = wave.extract %1120[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1263 = wave.extract %1120[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1264 = wave.extract %1120[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1265 = wave.extract %1120[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1266 = wave.pack %1258, %1259, %1260, %1261, %1262, %1263, %1264, %1265 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1267 = wave.store %1266 -> %1175 after %1227 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1268 = wave.barrier %1237, %1247, %1257, %1267 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_214, %token_215 = wave.load %1188 after %1268 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1269 = wave.extract %value_214[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1270 = wave.extract %value_214[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1271 = wave.extract %value_214[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1272 = wave.extract %value_214[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1273 = wave.extract %value_214[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1274 = wave.extract %value_214[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1275 = wave.extract %value_214[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1276 = wave.extract %value_214[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_216, %token_217 = wave.load %1198 after %1268 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1277 = wave.extract %value_216[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1278 = wave.extract %value_216[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1279 = wave.extract %value_216[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1280 = wave.extract %value_216[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1281 = wave.extract %value_216[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1282 = wave.extract %value_216[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1283 = wave.extract %value_216[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1284 = wave.extract %value_216[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_218, %token_219 = wave.load %1208 after %1268 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1285 = wave.extract %value_218[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1286 = wave.extract %value_218[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1287 = wave.extract %value_218[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1288 = wave.extract %value_218[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1289 = wave.extract %value_218[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1290 = wave.extract %value_218[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1291 = wave.extract %value_218[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1292 = wave.extract %value_218[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_220, %token_221 = wave.load %1218 after %1268 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1293 = wave.extract %value_220[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1294 = wave.extract %value_220[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1295 = wave.extract %value_220[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1296 = wave.extract %value_220[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1297 = wave.extract %value_220[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1298 = wave.extract %value_220[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1299 = wave.extract %value_220[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1300 = wave.extract %value_220[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1301 = wave.barrier %token_215, %token_217, %token_219, %token_221 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1302 = wave.extract %1121[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1303 = wave.extract %1121[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1304 = wave.extract %1121[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1305 = wave.extract %1121[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1306 = wave.extract %1125[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1307 = wave.extract %1125[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1308 = wave.extract %1125[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1309 = wave.extract %1125[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1310 = wave.pack %1302, %1303, %1304, %1305, %1306, %1307, %1308, %1309 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1311 = wave.store %1310 -> %1139 after %1301 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1312 = wave.extract %1122[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1313 = wave.extract %1122[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1314 = wave.extract %1122[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1315 = wave.extract %1122[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1316 = wave.extract %1126[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1317 = wave.extract %1126[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1318 = wave.extract %1126[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1319 = wave.extract %1126[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1320 = wave.pack %1312, %1313, %1314, %1315, %1316, %1317, %1318, %1319 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1321 = wave.store %1320 -> %1151 after %1301 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1322 = wave.extract %1123[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1323 = wave.extract %1123[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1324 = wave.extract %1123[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1325 = wave.extract %1123[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1326 = wave.extract %1127[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1327 = wave.extract %1127[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1328 = wave.extract %1127[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1329 = wave.extract %1127[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1330 = wave.pack %1322, %1323, %1324, %1325, %1326, %1327, %1328, %1329 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1331 = wave.store %1330 -> %1163 after %1301 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1332 = wave.extract %1124[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1333 = wave.extract %1124[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1334 = wave.extract %1124[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1335 = wave.extract %1124[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1336 = wave.extract %1128[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1337 = wave.extract %1128[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1338 = wave.extract %1128[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1339 = wave.extract %1128[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1340 = wave.pack %1332, %1333, %1334, %1335, %1336, %1337, %1338, %1339 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1341 = wave.store %1340 -> %1175 after %1301 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1342 = wave.barrier %1311, %1321, %1331, %1341 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_222, %token_223 = wave.load %1188 after %1342 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1343 = wave.extract %value_222[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1344 = wave.extract %value_222[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1345 = wave.extract %value_222[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1346 = wave.extract %value_222[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1347 = wave.extract %value_222[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1348 = wave.extract %value_222[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1349 = wave.extract %value_222[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1350 = wave.extract %value_222[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_224, %token_225 = wave.load %1198 after %1342 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1351 = wave.extract %value_224[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1352 = wave.extract %value_224[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1353 = wave.extract %value_224[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1354 = wave.extract %value_224[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1355 = wave.extract %value_224[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1356 = wave.extract %value_224[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1357 = wave.extract %value_224[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1358 = wave.extract %value_224[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_226, %token_227 = wave.load %1208 after %1342 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1359 = wave.extract %value_226[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1360 = wave.extract %value_226[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1361 = wave.extract %value_226[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1362 = wave.extract %value_226[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1363 = wave.extract %value_226[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1364 = wave.extract %value_226[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1365 = wave.extract %value_226[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1366 = wave.extract %value_226[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_228, %token_229 = wave.load %1218 after %1342 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1367 = wave.extract %value_228[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1368 = wave.extract %value_228[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1369 = wave.extract %value_228[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1370 = wave.extract %value_228[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1371 = wave.extract %value_228[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1372 = wave.extract %value_228[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1373 = wave.extract %value_228[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1374 = wave.extract %value_228[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1375 = wave.barrier %token_223, %token_225, %token_227, %token_229 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1376 = wave.extract %1129[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1377 = wave.extract %1129[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1378 = wave.extract %1129[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1379 = wave.extract %1129[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1380 = wave.extract %1133[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1381 = wave.extract %1133[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1382 = wave.extract %1133[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1383 = wave.extract %1133[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1384 = wave.pack %1376, %1377, %1378, %1379, %1380, %1381, %1382, %1383 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1385 = wave.store %1384 -> %1139 after %1375 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1386 = wave.extract %1130[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1387 = wave.extract %1130[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1388 = wave.extract %1130[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1389 = wave.extract %1130[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1390 = wave.extract %1134[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1391 = wave.extract %1134[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1392 = wave.extract %1134[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1393 = wave.extract %1134[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1394 = wave.pack %1386, %1387, %1388, %1389, %1390, %1391, %1392, %1393 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1395 = wave.store %1394 -> %1151 after %1375 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1396 = wave.extract %1131[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1397 = wave.extract %1131[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1398 = wave.extract %1131[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1399 = wave.extract %1131[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1400 = wave.extract %1135[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1401 = wave.extract %1135[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1402 = wave.extract %1135[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1403 = wave.extract %1135[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1404 = wave.pack %1396, %1397, %1398, %1399, %1400, %1401, %1402, %1403 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1405 = wave.store %1404 -> %1163 after %1375 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1406 = wave.extract %1132[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1407 = wave.extract %1132[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1408 = wave.extract %1132[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1409 = wave.extract %1132[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1410 = wave.extract %1136[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1411 = wave.extract %1136[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1412 = wave.extract %1136[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1413 = wave.extract %1136[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1414 = wave.pack %1406, %1407, %1408, %1409, %1410, %1411, %1412, %1413 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1415 = wave.store %1414 -> %1175 after %1375 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1416 = wave.barrier %1385, %1395, %1405, %1415 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_230, %token_231 = wave.load %1188 after %1416 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1417 = wave.extract %value_230[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1418 = wave.extract %value_230[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1419 = wave.extract %value_230[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1420 = wave.extract %value_230[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1421 = wave.extract %value_230[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1422 = wave.extract %value_230[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1423 = wave.extract %value_230[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1424 = wave.extract %value_230[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_232, %token_233 = wave.load %1198 after %1416 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1425 = wave.extract %value_232[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1426 = wave.extract %value_232[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1427 = wave.extract %value_232[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1428 = wave.extract %value_232[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1429 = wave.extract %value_232[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1430 = wave.extract %value_232[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1431 = wave.extract %value_232[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1432 = wave.extract %value_232[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_234, %token_235 = wave.load %1208 after %1416 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1433 = wave.extract %value_234[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1434 = wave.extract %value_234[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1435 = wave.extract %value_234[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1436 = wave.extract %value_234[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1437 = wave.extract %value_234[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1438 = wave.extract %value_234[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1439 = wave.extract %value_234[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1440 = wave.extract %value_234[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_236, %token_237 = wave.load %1218 after %1416 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1441 = wave.extract %value_236[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1442 = wave.extract %value_236[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1443 = wave.extract %value_236[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1444 = wave.extract %value_236[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1445 = wave.extract %value_236[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1446 = wave.extract %value_236[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1447 = wave.extract %value_236[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1448 = wave.extract %value_236[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1449 = wave.barrier %token_231, %token_233, %token_235, %token_237 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1450 = wave.ptr_add %arg2, %1104 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#wave.global, bf16>
      %1451 = waveamd.make_buffer %1450, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %1452 = wave.pack %1189, %1190, %1191, %1192, %1199, %1200, %1201, %1202 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1453 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1454 = wave.assume %1453 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1455 = wave.ptr_add %1451, %1454 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1456 = wave.store %1452 -> %1455 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1457 = wave.pack %1209, %1210, %1211, %1212, %1219, %1220, %1221, %1222 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1458 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1459 = wave.assume %1458 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1460 = wave.ptr_add %1451, %1459 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1461 = wave.store %1457 -> %1460 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1462 = wave.pack %1193, %1194, %1195, %1196, %1203, %1204, %1205, %1206 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1463 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1464 = wave.assume %1463 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1465 = wave.ptr_add %1451, %1464 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1466 = wave.store %1462 -> %1465 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1467 = wave.pack %1213, %1214, %1215, %1216, %1223, %1224, %1225, %1226 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1468 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1469 = wave.assume %1468 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1470 = wave.ptr_add %1451, %1469 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1471 = wave.store %1467 -> %1470 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1472 = wave.pack %1269, %1270, %1271, %1272, %1277, %1278, %1279, %1280 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1473 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1474 = wave.assume %1473 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1475 = wave.ptr_add %1451, %1474 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1476 = wave.store %1472 -> %1475 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1477 = wave.pack %1285, %1286, %1287, %1288, %1293, %1294, %1295, %1296 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1478 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1479 = wave.assume %1478 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1480 = wave.ptr_add %1451, %1479 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1481 = wave.store %1477 -> %1480 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1482 = wave.pack %1273, %1274, %1275, %1276, %1281, %1282, %1283, %1284 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1483 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1484 = wave.assume %1483 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1485 = wave.ptr_add %1451, %1484 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1486 = wave.store %1482 -> %1485 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1487 = wave.pack %1289, %1290, %1291, %1292, %1297, %1298, %1299, %1300 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1488 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1489 = wave.assume %1488 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1490 = wave.ptr_add %1451, %1489 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1491 = wave.store %1487 -> %1490 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1492 = wave.pack %1343, %1344, %1345, %1346, %1351, %1352, %1353, %1354 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1493 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1494 = wave.assume %1493 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1495 = wave.ptr_add %1451, %1494 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1496 = wave.store %1492 -> %1495 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1497 = wave.pack %1359, %1360, %1361, %1362, %1367, %1368, %1369, %1370 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1498 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1499 = wave.assume %1498 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1500 = wave.ptr_add %1451, %1499 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1501 = wave.store %1497 -> %1500 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1502 = wave.pack %1347, %1348, %1349, %1350, %1355, %1356, %1357, %1358 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1503 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1504 = wave.assume %1503 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1505 = wave.ptr_add %1451, %1504 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1506 = wave.store %1502 -> %1505 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1507 = wave.pack %1363, %1364, %1365, %1366, %1371, %1372, %1373, %1374 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1508 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1509 = wave.assume %1508 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1510 = wave.ptr_add %1451, %1509 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1511 = wave.store %1507 -> %1510 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1512 = wave.pack %1417, %1418, %1419, %1420, %1425, %1426, %1427, %1428 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1513 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1514 = wave.assume %1513 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1515 = wave.ptr_add %1451, %1514 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1516 = wave.store %1512 -> %1515 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1517 = wave.pack %1433, %1434, %1435, %1436, %1441, %1442, %1443, %1444 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1518 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1519 = wave.assume %1518 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1520 = wave.ptr_add %1451, %1519 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1521 = wave.store %1517 -> %1520 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1522 = wave.pack %1421, %1422, %1423, %1424, %1429, %1430, %1431, %1432 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1523 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1524 = wave.assume %1523 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1525 = wave.ptr_add %1451, %1524 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1526 = wave.store %1522 -> %1525 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1527 = wave.pack %1437, %1438, %1439, %1440, %1445, %1446, %1447, %1448 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1528 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1529 = wave.assume %1528 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1530 = wave.ptr_add %1451, %1529 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1531 = wave.store %1527 -> %1530 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1532 = waveamd.fragment_pack %value_188 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1533 = waveamd.fragment_pack %value_190 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1534 = waveamd.fragment_pack %value_192 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1535 = waveamd.fragment_pack %value_194 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1536 = waveamd.fragment_pack %value_196 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1537 = waveamd.fragment_pack %value_198 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1538 = waveamd.fragment_pack %value_200 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1539 = waveamd.fragment_pack %value_202 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1540 = waveamd.fragment_pack %764 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1541 = waveamd.fragment_pack %767 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1542 = waveamd.fragment_pack %770 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1543 = waveamd.fragment_pack %773 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1544 = waveamd.fragment_pack %776 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1545 = waveamd.fragment_pack %779 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1546 = waveamd.fragment_pack %782 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1547 = waveamd.fragment_pack %785 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1548 = waveamd.fragment_pack %788 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1549 = waveamd.fragment_pack %791 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1550 = waveamd.fragment_pack %794 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1551 = waveamd.fragment_pack %797 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1552 = waveamd.fragment_pack %800 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1553 = waveamd.fragment_pack %803 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1554 = waveamd.fragment_pack %806 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1555 = waveamd.fragment_pack %809 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1556 = waveamd.fragment_pack %812 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1557 = waveamd.fragment_pack %815 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1558 = waveamd.fragment_pack %818 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1559 = waveamd.fragment_pack %821 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1560 = waveamd.fragment_pack %824 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1561 = waveamd.fragment_pack %827 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1562 = waveamd.fragment_pack %830 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1563 = waveamd.fragment_pack %833 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1564 = waveamd.fragment_pack %836 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1565 = waveamd.fragment_pack %839 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1566 = waveamd.fragment_pack %842 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1567 = waveamd.fragment_pack %845 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1568 = waveamd.fragment_pack %848 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1569 = waveamd.fragment_pack %851 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1570 = waveamd.fragment_pack %854 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1571 = waveamd.fragment_pack %857 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1572 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1532, %1098, %931, %904, %1540 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1573 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1533, %1098, %932, %904, %1572 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1574 = waveamd.fragment_unpack %1573 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1575 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1534, %1098, %931, %904, %1541 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1576 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1535, %1098, %932, %904, %1575 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1577 = waveamd.fragment_unpack %1576 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1578 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1536, %1103, %931, %904, %1542 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1579 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1537, %1103, %932, %904, %1578 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1580 = waveamd.fragment_unpack %1579 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1581 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1538, %1103, %931, %904, %1543 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1582 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1539, %1103, %932, %904, %1581 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1583 = waveamd.fragment_unpack %1582 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1584 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1532, %1098, %933, %904, %1544 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1585 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1533, %1098, %934, %904, %1584 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1586 = waveamd.fragment_unpack %1585 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1587 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1534, %1098, %933, %904, %1545 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1588 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1535, %1098, %934, %904, %1587 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1589 = waveamd.fragment_unpack %1588 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1536, %1103, %933, %904, %1546 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1591 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1537, %1103, %934, %904, %1590 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1592 = waveamd.fragment_unpack %1591 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1538, %1103, %933, %904, %1547 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1594 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1539, %1103, %934, %904, %1593 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1595 = waveamd.fragment_unpack %1594 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1532, %1098, %935, %909, %1548 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1597 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1533, %1098, %936, %909, %1596 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1598 = waveamd.fragment_unpack %1597 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1534, %1098, %935, %909, %1549 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1600 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1535, %1098, %936, %909, %1599 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1601 = waveamd.fragment_unpack %1600 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1602 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1536, %1103, %935, %909, %1550 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1603 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1537, %1103, %936, %909, %1602 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1604 = waveamd.fragment_unpack %1603 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1538, %1103, %935, %909, %1551 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1606 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1539, %1103, %936, %909, %1605 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1607 = waveamd.fragment_unpack %1606 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1608 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1532, %1098, %937, %909, %1552 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1609 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1533, %1098, %938, %909, %1608 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1610 = waveamd.fragment_unpack %1609 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1611 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1534, %1098, %937, %909, %1553 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1612 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1535, %1098, %938, %909, %1611 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1613 = waveamd.fragment_unpack %1612 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1614 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1536, %1103, %937, %909, %1554 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1615 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1537, %1103, %938, %909, %1614 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1616 = waveamd.fragment_unpack %1615 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1617 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1538, %1103, %937, %909, %1555 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1618 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1539, %1103, %938, %909, %1617 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1619 = waveamd.fragment_unpack %1618 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1620 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1532, %1098, %939, %914, %1556 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1621 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1533, %1098, %940, %914, %1620 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1622 = waveamd.fragment_unpack %1621 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1623 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1534, %1098, %939, %914, %1557 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1624 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1535, %1098, %940, %914, %1623 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1625 = waveamd.fragment_unpack %1624 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1626 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1536, %1103, %939, %914, %1558 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1627 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1537, %1103, %940, %914, %1626 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1628 = waveamd.fragment_unpack %1627 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1629 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1538, %1103, %939, %914, %1559 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1630 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1539, %1103, %940, %914, %1629 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1631 = waveamd.fragment_unpack %1630 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1632 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1532, %1098, %941, %914, %1560 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1633 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1533, %1098, %942, %914, %1632 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1634 = waveamd.fragment_unpack %1633 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1635 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1534, %1098, %941, %914, %1561 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1636 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1535, %1098, %942, %914, %1635 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1637 = waveamd.fragment_unpack %1636 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1638 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1536, %1103, %941, %914, %1562 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1639 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1537, %1103, %942, %914, %1638 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1640 = waveamd.fragment_unpack %1639 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1641 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1538, %1103, %941, %914, %1563 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1642 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1539, %1103, %942, %914, %1641 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1643 = waveamd.fragment_unpack %1642 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1644 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1532, %1098, %943, %919, %1564 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1645 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1533, %1098, %944, %919, %1644 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1646 = waveamd.fragment_unpack %1645 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1647 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1534, %1098, %943, %919, %1565 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1648 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1535, %1098, %944, %919, %1647 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1649 = waveamd.fragment_unpack %1648 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1650 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1536, %1103, %943, %919, %1566 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1651 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1537, %1103, %944, %919, %1650 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1652 = waveamd.fragment_unpack %1651 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1653 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1538, %1103, %943, %919, %1567 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1654 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1539, %1103, %944, %919, %1653 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1655 = waveamd.fragment_unpack %1654 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1656 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1532, %1098, %945, %919, %1568 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1657 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1533, %1098, %946, %919, %1656 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1658 = waveamd.fragment_unpack %1657 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1659 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1534, %1098, %945, %919, %1569 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1660 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1535, %1098, %946, %919, %1659 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1661 = waveamd.fragment_unpack %1660 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1662 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1536, %1103, %945, %919, %1570 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1663 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1537, %1103, %946, %919, %1662 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1664 = waveamd.fragment_unpack %1663 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1665 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1538, %1103, %945, %919, %1571 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1666 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1539, %1103, %946, %919, %1665 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1667 = waveamd.fragment_unpack %1666 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1668 = wave.cast fpconvert %1574 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1669 = wave.cast fpconvert %1577 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1670 = wave.cast fpconvert %1580 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1671 = wave.cast fpconvert %1583 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1672 = wave.cast fpconvert %1586 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1673 = wave.cast fpconvert %1589 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1674 = wave.cast fpconvert %1592 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1675 = wave.cast fpconvert %1595 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1676 = wave.cast fpconvert %1598 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1677 = wave.cast fpconvert %1601 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1678 = wave.cast fpconvert %1604 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1679 = wave.cast fpconvert %1607 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1680 = wave.cast fpconvert %1610 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1681 = wave.cast fpconvert %1613 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1682 = wave.cast fpconvert %1616 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1683 = wave.cast fpconvert %1619 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1684 = wave.cast fpconvert %1622 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1685 = wave.cast fpconvert %1625 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1686 = wave.cast fpconvert %1628 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1687 = wave.cast fpconvert %1631 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1688 = wave.cast fpconvert %1634 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1689 = wave.cast fpconvert %1637 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1690 = wave.cast fpconvert %1640 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1691 = wave.cast fpconvert %1643 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1692 = wave.cast fpconvert %1646 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1693 = wave.cast fpconvert %1649 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1694 = wave.cast fpconvert %1652 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1695 = wave.cast fpconvert %1655 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1696 = wave.cast fpconvert %1658 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1697 = wave.cast fpconvert %1661 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1698 = wave.cast fpconvert %1664 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1699 = wave.cast fpconvert %1667 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1700 = wave.extract %1668[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1701 = wave.extract %1668[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1702 = wave.extract %1668[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1703 = wave.extract %1668[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1704 = wave.extract %1672[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1705 = wave.extract %1672[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1706 = wave.extract %1672[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1707 = wave.extract %1672[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1708 = wave.pack %1700, %1701, %1702, %1703, %1704, %1705, %1706, %1707 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1709 = wave.store %1708 -> %1139 after %1449 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1710 = wave.extract %1669[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1711 = wave.extract %1669[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1712 = wave.extract %1669[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1713 = wave.extract %1669[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1714 = wave.extract %1673[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1715 = wave.extract %1673[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1716 = wave.extract %1673[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1717 = wave.extract %1673[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1718 = wave.pack %1710, %1711, %1712, %1713, %1714, %1715, %1716, %1717 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1719 = wave.store %1718 -> %1151 after %1449 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1720 = wave.extract %1670[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1721 = wave.extract %1670[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1722 = wave.extract %1670[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1723 = wave.extract %1670[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1724 = wave.extract %1674[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1725 = wave.extract %1674[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1726 = wave.extract %1674[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1727 = wave.extract %1674[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1728 = wave.pack %1720, %1721, %1722, %1723, %1724, %1725, %1726, %1727 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1729 = wave.store %1728 -> %1163 after %1449 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1730 = wave.extract %1671[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1731 = wave.extract %1671[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1732 = wave.extract %1671[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1733 = wave.extract %1671[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1734 = wave.extract %1675[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1735 = wave.extract %1675[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1736 = wave.extract %1675[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1737 = wave.extract %1675[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1738 = wave.pack %1730, %1731, %1732, %1733, %1734, %1735, %1736, %1737 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1739 = wave.store %1738 -> %1175 after %1449 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1740 = wave.barrier %1709, %1719, %1729, %1739 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_238, %token_239 = wave.load %1188 after %1740 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1741 = wave.extract %value_238[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1742 = wave.extract %value_238[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1743 = wave.extract %value_238[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1744 = wave.extract %value_238[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1745 = wave.extract %value_238[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1746 = wave.extract %value_238[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1747 = wave.extract %value_238[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1748 = wave.extract %value_238[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_240, %token_241 = wave.load %1198 after %1740 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1749 = wave.extract %value_240[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1750 = wave.extract %value_240[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1751 = wave.extract %value_240[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1752 = wave.extract %value_240[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1753 = wave.extract %value_240[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1754 = wave.extract %value_240[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1755 = wave.extract %value_240[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1756 = wave.extract %value_240[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_242, %token_243 = wave.load %1208 after %1740 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1757 = wave.extract %value_242[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1758 = wave.extract %value_242[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1759 = wave.extract %value_242[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1760 = wave.extract %value_242[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1761 = wave.extract %value_242[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1762 = wave.extract %value_242[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1763 = wave.extract %value_242[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1764 = wave.extract %value_242[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_244, %token_245 = wave.load %1218 after %1740 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1765 = wave.extract %value_244[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1766 = wave.extract %value_244[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1767 = wave.extract %value_244[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1768 = wave.extract %value_244[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1769 = wave.extract %value_244[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1770 = wave.extract %value_244[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1771 = wave.extract %value_244[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1772 = wave.extract %value_244[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1773 = wave.barrier %token_239, %token_241, %token_243, %token_245 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1774 = wave.extract %1676[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1775 = wave.extract %1676[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1776 = wave.extract %1676[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1777 = wave.extract %1676[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1778 = wave.extract %1680[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1779 = wave.extract %1680[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1780 = wave.extract %1680[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1781 = wave.extract %1680[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1782 = wave.pack %1774, %1775, %1776, %1777, %1778, %1779, %1780, %1781 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1783 = wave.store %1782 -> %1139 after %1773 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1784 = wave.extract %1677[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1785 = wave.extract %1677[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1786 = wave.extract %1677[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1787 = wave.extract %1677[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1788 = wave.extract %1681[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1789 = wave.extract %1681[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1790 = wave.extract %1681[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1791 = wave.extract %1681[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1792 = wave.pack %1784, %1785, %1786, %1787, %1788, %1789, %1790, %1791 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1793 = wave.store %1792 -> %1151 after %1773 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1794 = wave.extract %1678[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1795 = wave.extract %1678[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1796 = wave.extract %1678[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1797 = wave.extract %1678[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1798 = wave.extract %1682[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1799 = wave.extract %1682[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1800 = wave.extract %1682[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1801 = wave.extract %1682[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1802 = wave.pack %1794, %1795, %1796, %1797, %1798, %1799, %1800, %1801 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1803 = wave.store %1802 -> %1163 after %1773 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1804 = wave.extract %1679[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1805 = wave.extract %1679[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1806 = wave.extract %1679[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1807 = wave.extract %1679[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1808 = wave.extract %1683[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1809 = wave.extract %1683[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1810 = wave.extract %1683[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1811 = wave.extract %1683[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1812 = wave.pack %1804, %1805, %1806, %1807, %1808, %1809, %1810, %1811 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1813 = wave.store %1812 -> %1175 after %1773 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1814 = wave.barrier %1783, %1793, %1803, %1813 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_246, %token_247 = wave.load %1188 after %1814 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1815 = wave.extract %value_246[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1816 = wave.extract %value_246[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1817 = wave.extract %value_246[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1818 = wave.extract %value_246[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1819 = wave.extract %value_246[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1820 = wave.extract %value_246[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1821 = wave.extract %value_246[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1822 = wave.extract %value_246[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_248, %token_249 = wave.load %1198 after %1814 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1823 = wave.extract %value_248[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1824 = wave.extract %value_248[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1825 = wave.extract %value_248[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1826 = wave.extract %value_248[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1827 = wave.extract %value_248[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1828 = wave.extract %value_248[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1829 = wave.extract %value_248[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1830 = wave.extract %value_248[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_250, %token_251 = wave.load %1208 after %1814 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1831 = wave.extract %value_250[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1832 = wave.extract %value_250[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1833 = wave.extract %value_250[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1834 = wave.extract %value_250[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1835 = wave.extract %value_250[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1836 = wave.extract %value_250[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1837 = wave.extract %value_250[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1838 = wave.extract %value_250[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_252, %token_253 = wave.load %1218 after %1814 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1839 = wave.extract %value_252[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1840 = wave.extract %value_252[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1841 = wave.extract %value_252[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1842 = wave.extract %value_252[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1843 = wave.extract %value_252[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1844 = wave.extract %value_252[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1845 = wave.extract %value_252[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1846 = wave.extract %value_252[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1847 = wave.barrier %token_247, %token_249, %token_251, %token_253 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1848 = wave.extract %1684[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1849 = wave.extract %1684[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1850 = wave.extract %1684[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1851 = wave.extract %1684[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1852 = wave.extract %1688[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1853 = wave.extract %1688[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1854 = wave.extract %1688[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1855 = wave.extract %1688[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1856 = wave.pack %1848, %1849, %1850, %1851, %1852, %1853, %1854, %1855 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1857 = wave.store %1856 -> %1139 after %1847 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1858 = wave.extract %1685[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1859 = wave.extract %1685[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1860 = wave.extract %1685[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1861 = wave.extract %1685[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1862 = wave.extract %1689[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1863 = wave.extract %1689[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1864 = wave.extract %1689[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1865 = wave.extract %1689[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1866 = wave.pack %1858, %1859, %1860, %1861, %1862, %1863, %1864, %1865 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1867 = wave.store %1866 -> %1151 after %1847 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1868 = wave.extract %1686[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1869 = wave.extract %1686[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1870 = wave.extract %1686[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1871 = wave.extract %1686[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1872 = wave.extract %1690[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1873 = wave.extract %1690[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1874 = wave.extract %1690[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1875 = wave.extract %1690[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1876 = wave.pack %1868, %1869, %1870, %1871, %1872, %1873, %1874, %1875 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1877 = wave.store %1876 -> %1163 after %1847 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1878 = wave.extract %1687[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1879 = wave.extract %1687[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1880 = wave.extract %1687[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1881 = wave.extract %1687[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1882 = wave.extract %1691[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1883 = wave.extract %1691[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1884 = wave.extract %1691[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1885 = wave.extract %1691[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1886 = wave.pack %1878, %1879, %1880, %1881, %1882, %1883, %1884, %1885 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1887 = wave.store %1886 -> %1175 after %1847 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1888 = wave.barrier %1857, %1867, %1877, %1887 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_254, %token_255 = wave.load %1188 after %1888 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1889 = wave.extract %value_254[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1890 = wave.extract %value_254[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1891 = wave.extract %value_254[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1892 = wave.extract %value_254[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1893 = wave.extract %value_254[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1894 = wave.extract %value_254[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1895 = wave.extract %value_254[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1896 = wave.extract %value_254[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_256, %token_257 = wave.load %1198 after %1888 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1897 = wave.extract %value_256[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1898 = wave.extract %value_256[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1899 = wave.extract %value_256[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1900 = wave.extract %value_256[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1901 = wave.extract %value_256[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1902 = wave.extract %value_256[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1903 = wave.extract %value_256[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1904 = wave.extract %value_256[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_258, %token_259 = wave.load %1208 after %1888 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1905 = wave.extract %value_258[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1906 = wave.extract %value_258[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1907 = wave.extract %value_258[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1908 = wave.extract %value_258[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1909 = wave.extract %value_258[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1910 = wave.extract %value_258[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1911 = wave.extract %value_258[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1912 = wave.extract %value_258[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_260, %token_261 = wave.load %1218 after %1888 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1913 = wave.extract %value_260[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1914 = wave.extract %value_260[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1915 = wave.extract %value_260[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1916 = wave.extract %value_260[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1917 = wave.extract %value_260[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1918 = wave.extract %value_260[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1919 = wave.extract %value_260[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1920 = wave.extract %value_260[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1921 = wave.barrier %token_255, %token_257, %token_259, %token_261 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1922 = wave.extract %1692[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1923 = wave.extract %1692[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1924 = wave.extract %1692[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1925 = wave.extract %1692[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1926 = wave.extract %1696[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1927 = wave.extract %1696[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1928 = wave.extract %1696[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1929 = wave.extract %1696[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1930 = wave.pack %1922, %1923, %1924, %1925, %1926, %1927, %1928, %1929 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1931 = wave.store %1930 -> %1139 after %1921 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1932 = wave.extract %1693[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1933 = wave.extract %1693[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1934 = wave.extract %1693[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1935 = wave.extract %1693[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1936 = wave.extract %1697[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1937 = wave.extract %1697[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1938 = wave.extract %1697[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1939 = wave.extract %1697[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1940 = wave.pack %1932, %1933, %1934, %1935, %1936, %1937, %1938, %1939 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1941 = wave.store %1940 -> %1151 after %1921 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1942 = wave.extract %1694[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1943 = wave.extract %1694[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1944 = wave.extract %1694[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1945 = wave.extract %1694[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1946 = wave.extract %1698[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1947 = wave.extract %1698[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1948 = wave.extract %1698[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1949 = wave.extract %1698[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1950 = wave.pack %1942, %1943, %1944, %1945, %1946, %1947, %1948, %1949 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1951 = wave.store %1950 -> %1163 after %1921 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1952 = wave.extract %1695[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1953 = wave.extract %1695[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1954 = wave.extract %1695[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1955 = wave.extract %1695[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1956 = wave.extract %1699[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1957 = wave.extract %1699[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1958 = wave.extract %1699[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1959 = wave.extract %1699[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1960 = wave.pack %1952, %1953, %1954, %1955, %1956, %1957, %1958, %1959 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1961 = wave.store %1960 -> %1175 after %1921 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1962 = wave.barrier %1931, %1941, %1951, %1961 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_262, %token_263 = wave.load %1188 after %1962 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1963 = wave.extract %value_262[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1964 = wave.extract %value_262[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1965 = wave.extract %value_262[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1966 = wave.extract %value_262[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1967 = wave.extract %value_262[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1968 = wave.extract %value_262[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1969 = wave.extract %value_262[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1970 = wave.extract %value_262[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_264, %token_265 = wave.load %1198 after %1962 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1971 = wave.extract %value_264[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1972 = wave.extract %value_264[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1973 = wave.extract %value_264[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1974 = wave.extract %value_264[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1975 = wave.extract %value_264[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1976 = wave.extract %value_264[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1977 = wave.extract %value_264[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1978 = wave.extract %value_264[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_266, %token_267 = wave.load %1208 after %1962 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1979 = wave.extract %value_266[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1980 = wave.extract %value_266[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1981 = wave.extract %value_266[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1982 = wave.extract %value_266[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1983 = wave.extract %value_266[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1984 = wave.extract %value_266[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1985 = wave.extract %value_266[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1986 = wave.extract %value_266[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_268, %token_269 = wave.load %1218 after %1962 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1987 = wave.extract %value_268[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1988 = wave.extract %value_268[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1989 = wave.extract %value_268[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1990 = wave.extract %value_268[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1991 = wave.extract %value_268[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1992 = wave.extract %value_268[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1993 = wave.extract %value_268[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1994 = wave.extract %value_268[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1995 = wave.barrier %token_263, %token_265, %token_267, %token_269 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1996 = wave.pack %1741, %1742, %1743, %1744, %1749, %1750, %1751, %1752 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1997 = wave.index_expr <"128 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1998 = wave.assume %1997 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1999 = wave.ptr_add %1451, %1998 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2000 = wave.store %1996 -> %1999 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2001 = wave.pack %1757, %1758, %1759, %1760, %1765, %1766, %1767, %1768 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2002 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2003 = wave.assume %2002 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2004 = wave.ptr_add %1451, %2003 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2005 = wave.store %2001 -> %2004 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2006 = wave.pack %1745, %1746, %1747, %1748, %1753, %1754, %1755, %1756 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2007 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2008 = wave.assume %2007 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2009 = wave.ptr_add %1451, %2008 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2010 = wave.store %2006 -> %2009 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2011 = wave.pack %1761, %1762, %1763, %1764, %1769, %1770, %1771, %1772 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2012 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2013 = wave.assume %2012 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2014 = wave.ptr_add %1451, %2013 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2015 = wave.store %2011 -> %2014 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2016 = wave.pack %1815, %1816, %1817, %1818, %1823, %1824, %1825, %1826 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2017 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2018 = wave.assume %2017 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2019 = wave.ptr_add %1451, %2018 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2020 = wave.store %2016 -> %2019 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2021 = wave.pack %1831, %1832, %1833, %1834, %1839, %1840, %1841, %1842 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2022 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2023 = wave.assume %2022 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2024 = wave.ptr_add %1451, %2023 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2025 = wave.store %2021 -> %2024 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2026 = wave.pack %1819, %1820, %1821, %1822, %1827, %1828, %1829, %1830 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2027 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2028 = wave.assume %2027 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2029 = wave.ptr_add %1451, %2028 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2030 = wave.store %2026 -> %2029 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2031 = wave.pack %1835, %1836, %1837, %1838, %1843, %1844, %1845, %1846 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2032 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2033 = wave.assume %2032 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2034 = wave.ptr_add %1451, %2033 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2035 = wave.store %2031 -> %2034 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2036 = wave.pack %1889, %1890, %1891, %1892, %1897, %1898, %1899, %1900 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2037 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2038 = wave.assume %2037 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2039 = wave.ptr_add %1451, %2038 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2040 = wave.store %2036 -> %2039 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2041 = wave.pack %1905, %1906, %1907, %1908, %1913, %1914, %1915, %1916 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2042 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2043 = wave.assume %2042 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2044 = wave.ptr_add %1451, %2043 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2045 = wave.store %2041 -> %2044 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2046 = wave.pack %1893, %1894, %1895, %1896, %1901, %1902, %1903, %1904 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2047 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2048 = wave.assume %2047 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2049 = wave.ptr_add %1451, %2048 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2050 = wave.store %2046 -> %2049 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2051 = wave.pack %1909, %1910, %1911, %1912, %1917, %1918, %1919, %1920 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2052 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2053 = wave.assume %2052 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2054 = wave.ptr_add %1451, %2053 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2055 = wave.store %2051 -> %2054 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2056 = wave.pack %1963, %1964, %1965, %1966, %1971, %1972, %1973, %1974 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2057 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2058 = wave.assume %2057 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2059 = wave.ptr_add %1451, %2058 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2060 = wave.store %2056 -> %2059 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2061 = wave.pack %1979, %1980, %1981, %1982, %1987, %1988, %1989, %1990 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2062 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2063 = wave.assume %2062 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2064 = wave.ptr_add %1451, %2063 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2065 = wave.store %2061 -> %2064 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2066 = wave.pack %1967, %1968, %1969, %1970, %1975, %1976, %1977, %1978 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2067 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2068 = wave.assume %2067 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2069 = wave.ptr_add %1451, %2068 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2070 = wave.store %2066 -> %2069 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2071 = wave.pack %1983, %1984, %1985, %1986, %1991, %1992, %1993, %1994 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2072 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%48, %arg9, %41) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2073 = wave.assume %2072 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2074 = wave.ptr_add %1451, %2073 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2075 = wave.store %2071 -> %2074 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      return
    }
  }
}
